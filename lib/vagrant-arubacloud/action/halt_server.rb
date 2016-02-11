require 'log4r'
require 'vagrant/util/retryable'
require 'fog/arubacloud/error'
require 'pry'

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

            # Check if the vm is already powered off
            @logger.debug("VM stopped?: #{server.stopped?}")
            if server.stopped?
              # continue the middleware
              @app.call(env)
            else
              # Try to poweroff the VM.
              begin
                server.power_off
                rescue Fog::ArubaCloud::Errors::VmStatus
                  env[:ui].warn(I18n.t('vagrant_arubacloud.bad_state'))
                  return
                rescue Fog::ArubaCloud::Errors::RequestError => e
                  if e.response['ResultCode'].eql? 17
                    env[:ui].warn(I18n.t('vagrant_arubacloud.operation_already_in_queue'))
                    return
                  end
              end

              # Wait for the server to be proper shut down
              retryable(:tries => 20, :sleep => 1) do
                server.wait_for(1) { stopped? }
              end
              env[:ui].info(I18n.t('vagrant_arubacloud.server_powered_off'))
            end
          end

          @app.call(env)
        end
      end
    end
  end
end
