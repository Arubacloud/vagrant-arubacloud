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
          env[:result] = env[:machine].vm.id?(nil)
          env[:ui].info(env[:result].to_s)
          @app.call(env)
        end
      end
    end
  end
end
