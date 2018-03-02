require 'log4r'
require 'fog/arubacloud/error'

module VagrantPlugins
  module ArubaCloud
    module Action
      # This deletes the running server, if there is one.
      class DeleteServer
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new('vagrant_arubacloud::action::delete_server')
        end

        def call(env)
          if env[:machine].id
            config = env[:machine].provider_config
            arubacloud_dc = config.endpoint
            env[:ui].info(" [#{arubacloud_dc}] " + I18n.t('vagrant_arubacloud.deleting_server'))
            # On fog side, get will call get_service_details, I must be sure
            # that the returned object has the "id" parameters not nil
            server = env[:arubacloud_compute].servers.get(env[:machine].id)
            begin
              server.delete
            rescue Fog::ArubaCloud::Errors::VmStatus
              env[:ui].warn(I18n.t('vagrant_arubacloud.bad_state'))
            end
            env[:machine].id = nil
          end

          @app.call(env)
        end
      end
    end
  end
end
