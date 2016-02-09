module VagrantPlugins
  module ArubaCloud
    module Action
      class DisableRequireTty
        def initialize(app, env)
          @app = app
          @machine = env[:machine]
        end

        def call(env)
          unless @machine.guest.capability?(:disable_requiretty)
            @machine.ui.warn(I18n.t('vagrant_arubacloud.disable_require_tty_cap_not_found'))
            return
          end

          @machine.ui.detail(I18n.t('vagrant_arubacloud.disabling_requiretty'))
          @machine.guest.capability(:disable_requiretty)

          @app.call(env)
        end
      end
    end
  end
end
