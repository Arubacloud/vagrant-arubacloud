require 'log4r'

module VagrantPlugins
  module ArubaCloud
    module Action
      class IsCreated
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new('vagrant_arubacloud::action::is_created')
        end

        def call(env)
          env[:result] = env[:machine].id != nil
          @app.call(env)
        end
      end
    end
  end
end
