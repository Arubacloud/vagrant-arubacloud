require 'log4r'
require 'vagrant/util/retryable'
require 'fog/arubacloud/error'
require 'optparse'

module VagrantPlugins
  module ArubaCloud
    module Action
      # This stop a server, if it exists
      class StartServer
        include Vagrant::Util::Retryable

        def initialize(app, env)
          @app    = app
          @env    = env
          @logger = Log4r::Logger.new('vagrant_arubacloud::action::start_server')
        end

        def call(env)
          if env[:machine].id
            config = env[:machine].provider_config
            arubacloud_dc = config.endpoint
            
            env[:ui].info(" [#{arubacloud_dc}] " + I18n.t('vagrant_arubacloud.starting_server'))
            server = env[:arubacloud_compute].servers.get(env[:machine].id)
            # Check if the vm is already powered on
            @logger.debug("VM ready?: #{server.ready?}")
            if server.ready?
              # continue the middleware
              @app.call(env)
            else
              # Try to power-on the VM.
              begin
                server.power_on 
                rescue Fog::ArubaCloud::Errors::VmStatus
                  env[:ui].warn(I18n.t('vagrant_arubacloud.bad_state'))
                  return
                rescue Fog::ArubaCloud::Errors::RequestError => e
                  if e.response['ResultCode'].eql? 17
                    env[:ui].warn(I18n.t('vagrant_arubacloud.operation_already_in_queue'))
                    return
                  end
              end

              # Wait for the server to be proper started and up
              env[:ui].info(" [#{arubacloud_dc}] " + I18n.t('vagrant_arubacloud.waiting_server_powered_on'))
              retryable(:tries => 40, :sleep => 2) do
                server.wait_for(1) { ready? }
              end
              env[:ui].info(" [#{arubacloud_dc}] " + I18n.t('vagrant_arubacloud.server_powered_on'))
            end
          end

          @app.call(env)
        end
      end
    end
  end
end
