require 'fog/arubacloud'
require 'log4r'

require 'vagrant/util/retryable'

module VagrantPlugins
  module ArubaCloud
    module Action

      # Create a new server
      class CreateServer
        include Vagrant::Util::Retryable

        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new('vagrant_arubacloud::action::create_server')
        end

        def call(env)
          config = env[:machine].provider_config
          arubacloud_dc = config.endpoint
          tb_package_id = {'small' => 'CPU: 1, Ram(GB): 1, DiskSize(GB): 20',
                           'medium' => 'CPU: 1, Ram(GB): 2, DiskSize(GB): 40',
                           'large' => 'CPU: 2, Ram(GB): 4, DiskSize(GB): 80',
                           'extra large' => 'CPU: 4, Ram(GB): 8, DiskSize(GB): 160'
                }
          tb_package_id.default = " *unknow package_id* "

          sshpwd = env[:machine].config.ssh.password

          # Set Server Name
          server_name = config.server_name || env[:machine].name

          # Output the settings we're going to use to the user
          env[:ui].info('Creating a server with the following settings...')
          env[:ui].info(" -- Datacenter:    #{arubacloud_dc}")
          env[:ui].info(" -- Name:          #{server_name}")
          env[:ui].info(" -- Root Password: #{sshpwd}")
          # Build the config hash according to the service type
          if config.service_type.eql? 4
            options = {
                :name => server_name,
                :vm_type => 'smart',
                :admin_passwd => sshpwd,
                :cpu => 1,
                :memory => 1,
                :template_id => config.template_id,
                :package_id => config.package_id
            }
            env[:ui].info(" -- Package:       #{config.package_id}  config as:  #{tb_package_id[config.package_id]}")

          else
            # Processing hds
            disks = []
            accum = "["
            config.hds.each do |disk_spec|
              disks << env[:arubacloud_compute].disks.create({
                  :size => disk_spec[:size],
                  :virtual_disk_type => disk_spec[:type]}).get_hash
              accum += "(hd#{disk_spec[:type]}: #{disk_spec[:size]})"
            end
            accum += "]"
            options = {
                :name => server_name,
                :vm_type => 'pro',
                :admin_passwd => sshpwd,
                :cpu => config.cpu_number,
                :memory => config.ram_qty,
                :template_id => config.template_id,
                :disks => disks
            }
            env[:ui].info(" -- Config as:   CPU: #{config.cpu_number}, Ram(GB): #{config.ram_qty}, Disk(GB): #{accum} ")
          end

          env[:ui].info(" -- OS Template:   #{config.template_id}")
          env[:ui].info(" -- Service Type:  #{config.service_type} (#{options[:vm_type]}) ")

          # Create the server
          begin
            server = env[:arubacloud_compute].servers.create(options)
          rescue Fog::ArubaCloud::Errors::RequestError => e
            message = ''
            error = nil
            @logger.debug(e.inspect.to_yaml)
            if e.response['ResultCode'].eql? 16
              message = "Virtual machine with name: #{options[:name]}, already present. Bailout!"
              error = Errors::MachineAlreadyPresent
            elsif e.response['ResultCode'].eql?(-500)
              message = 'Server returned an unexpected response. Bailout!'
              error = Errors::BadServerResponse
            end
            env[:ui].warn("Response message: #{e.response.to_yaml}")
            env[:ui].warn(message)
            raise error
          end

          # Store id of the machine
          env[:machine].id = server.id

          # Wait for ssh to be ready
          env[:ui].info(" [#{arubacloud_dc}] " + 'Waiting until server is ready...')

          retryable(:tries => 20, :sleep => 45) do
            next if env[:interrupted]
            server.wait_for(5) { ready? }
          end

          env[:ui].info(" [#{arubacloud_dc}] " + 'The server is ready!')

          @app.call(env)
        end

      end
    end
  end
end
