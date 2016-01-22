require 'fog'
require 'log4r'
require 'pp'

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
          config         = env[:machine].provider_config

          env[:ui].info('Creating machine...')

          # Set Server Name
          server_name = config.server_name || env[:machine].name

          # Output the settings we're going to use to the user
          env[:ui].info('Creating a server with the following settings...')
          env[:ui].info(" -- Name: #{server_name}")
          env[:ui].info(" -- Root Password: #{config.admin_password}")
          env[:ui].info(" -- Package: #{config.package_id}")
          env[:ui].info(" -- OS Template: #{config.template_id}")

          # Build the options to create
          options = {
              :name => server_name,
              :vm_type => 'smart',
              :admin_passwd => config.admin_password,
              :cpu => 1,
              :memory => 1,
              :template_id => config.template_id,
              :package_id => config.package_id
          }

          # Create the server
          server = env[:arubacloud_compute].servers.create(options)

          # Store id of the machine
          env[:machine].id = server.id

          # Wait for ssh to be ready
          env[:ui].info('Waiting for the server to be ready...')
          user = env[:machine].config.ssh.username

          retryable(:tries => 10, :sleep => 60) do
            next if env[:interrupted]

            @logger.debug("create_server: ready? #{server.ready?}")
            @logger.debug("create_server: server.state: #{server.state}")
            server.wait_for(5) { ready? } # you shall not pass!
          end

          env[:ui].info(' The server is ready!')

          @app.call(env)
        end

      end
    end
  end
end