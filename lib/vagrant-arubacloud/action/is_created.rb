module VagrantPlugins
  module ArubaCloud
    module Action
      class IsCreated
        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:result] = env[:machine].state != 5
          @app.call(env)
        end
      end
    end
  end
end
