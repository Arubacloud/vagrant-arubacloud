require "log4r"

module VagrantPlugins
  module ArubaCloud
    module Action
      # This stop a server, if it exists
      class HaltServer
        def initialize(app, env)
          @app    = app
          @env    = env
          @logger = Log4r::Logger.new('vagrant_arubacloud::action::halt_server')
        end

        def call(env)
          if env[:machine].id
            env[:ui].info('vagrant_arubacloud.halting_server')

            server = env[:arubacloud_compute].servers.get(env[:machine].id)
            server.power_off
          end

          @app.call(env)
        end
      end
    end
  end
end
