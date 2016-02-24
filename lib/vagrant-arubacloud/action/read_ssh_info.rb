require 'log4r'

module VagrantPlugins
  module ArubaCloud
    module Action

      # This action reads the SSH info for the machine and puts it into
      # ':machine_ssh_info' key in the environment
      class ReadSSHInfo
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new('vagrant_arubacloud::action::read_ssh_info')
        end

        def call(env)
          env[:machine_ssh_info] = read_ssh_info(env[:arubacloud_compute], env[:machine])
          @app.call(env)
        end

        def read_ssh_info(arubacloud, machine)
          return nil if machine.id.nil?

          # Find the machine
          server = arubacloud.servers.get(machine.id)
          if server.nil?
            # The machine can't be found
            @logger.info("'Machine couldn't be found, assuming it got destroyed.")
            machine.id = nil
            nil
          else
            @logger.info("read_ssh_info: server.smart_ipv4: #{server.smart_ipv4}")
            # Return the server object
            {
                :host => server.get_public_ip,
                :port => 22,
                :username => 'root'
            }
          end
        end # read_ssh_info
      end # ReadSSHInfo
    end # Action
  end # ArubaCloud
end # VagrantPlugins