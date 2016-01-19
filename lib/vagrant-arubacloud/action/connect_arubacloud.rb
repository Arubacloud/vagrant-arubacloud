require 'fog'
require 'log4r'

module VagrantPlugins
  module ArubaCloud
    module Action

      class ConnectArubaCloud
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new('vagrant_arubacloud::action::connect_arubacloud')
        end

        def call(env)
          # Set the datacenter
          config = env[:machine].provider_config
          arubacloud_username = config.arubacloud_username
          arubacloud_password = config.arubacloud_password

          params = {
              :provider => :arubacloud,
              :arubacloud_username => arubacloud_username,
              :arubacloud_password => arubacloud_password,
          }

          if config.url
            @logger.info("Connecting to Datacenter: #{config.url}")
            params[:url] = config.url
          end

          env[:arubacloud_compute] = Fog::Compute.new params

          @app.call(env)
        end
      end
    end
  end
end