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
          username = config.username
          password = config.password

          params = {
              :provider => :arubacloud,
              :arubacloud_username => username,
              :arubacloud_password => password,
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