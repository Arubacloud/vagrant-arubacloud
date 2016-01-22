module VagrantPlugins
  module ArubaCloud
    module Action
      class MessageNotCreated
        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:ui].info('Server is not present, assuming not created... Bailout!')
          @app.call(env)
        end
      end
    end
  end
end