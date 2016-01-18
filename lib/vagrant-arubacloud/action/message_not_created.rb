module VagrantPlugins
  module ArubaCloud
    module Action
      class MessageNotCreated
        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:ui].info('vagrant_rackspace.not_created')
          @app.call(env)
        end
      end
    end
  end
end