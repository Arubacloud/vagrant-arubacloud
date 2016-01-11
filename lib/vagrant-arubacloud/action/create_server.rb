require 'fog'
require 'log4r'

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
          machine_config = env[:machine].config

          env[:ui].info('Creating machine...')

          # Set Server Name
          server_name = config.server_name || env[:machine].name

          # Output the settings we're going to use to the user
          env[:ui].info('Launching a server with the following settings...')
          env[:ui].info(" -- Name: #{server_name}")
          env[:ui].info(" -- Package: #{machine_config.package_id}")
          env[:ui].info(" -- OS Template: #{machine_config.template_id}")

          # Build the options to create
          options = {
              :name => server_name,
              :vm_type => 'smart',
              :admin_passwd => machine_config.admin_passwd,
              :cpu => 1,
              :memory => 1,
              :tempalte_id => machine_config.template_id,
              :package_id => machine_config.package_id
          }

          # Create the server
          server = env[:arubacloud_compute].servers.create(options)

          # Wait for the server to finish building
          env[:ui].info('Waiting for the server to be created...')

        end
      end
    end
  end
end