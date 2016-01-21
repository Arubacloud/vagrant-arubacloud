require "log4r"

module VagrantPlugins
  module ArubaCloud
    module Action
      # This action reads the state of the machine and puts it in the
      # `:machine_state_id` key in the environment.
      class ReadState
        def initialize(app, env)
          @app    = app
          @env    = env
          @logger = Log4r::Logger.new('vagrant_arubacloud::action::read_state')
        end

        def call(env)
          # env[:ui].output(":machine_state_id: #{env[:machine_state_id]}")
          # env[:ui].output(":arubacloud_compute: #{env[:arubacloud_compute]}")
          # env[:ui].output(":machine: #{env[:machine]}")
          env[:machine_state_id] = read_state(env[:arubacloud_compute], env[:machine])
          @app.call(env)
        end

        def read_state(arubacloud, machine)
          return :not_created if machine.id.nil?

          # Find the machine
          server = arubacloud.servers.get(machine.id)
          unless server.instance_of? Fog::Compute::ArubaCloud::Server
            msg = "VagrantPlugins::ArubaCloud::Action::ReadState.read_state, 'server' must be Fog::Compute::ArubaCloud::Server, got: #{server.class}"
            @logger.critical("#{msg}")
          end
          if server.nil? || server.state == Fog::Compute::ArubaCloud::Server::DELETED
            # The machine can't be found
            @logger.info('Machine not found or deleted, assuming it got destroyed.')
            machine.id = nil
            return :not_created
          end

          @env[:ui].output("VagrantPlugins::ArubaCloud::Action::ReadState.read_state, server state : #{server.state}")
          # Return the state
          server.state
        end
      end
    end
  end
end
