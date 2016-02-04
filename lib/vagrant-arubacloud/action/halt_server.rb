require 'log4r'
require 'vagrant/util/retryable'

module VagrantPlugins
  module ArubaCloud
    module Action
      # This stop a server, if it exists
      class HaltServer
        include Vagrant::Util::Retryable

        def initialize(app, env)
          @app    = app
          @env    = env
          @logger = Log4r::Logger.new('vagrant_arubacloud::action::halt_server')
        end

        def call(env)
          if env[:machine].id
            env[:ui].info(I18n.t('vagrant_arubacloud.halting_server'))
            server = env[:arubacloud_compute].servers.get(env[:machine].id)
            server.power_off
            # Wait for the server to be proper shut down
            retryable(:tries => 20, :sleep => 1) do
              server.wait_for(1) { stopped? }
            end
            env[:ui].info(I18n.t('vagrant_arubacloud.server_powered_off'))
          end

          @app.call(env)
        end
      end
    end
  end
end
