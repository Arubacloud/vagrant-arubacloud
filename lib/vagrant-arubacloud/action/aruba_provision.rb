require 'log4r'

module VagrantPlugins
  module ArubaCloud
    module Action

      # This override is needed to intercept provisioning action and
      # call the disable_requiretty capability. This is horrible, but for now
      # that's it.
      class ArubaProvision < Vagrant::Action::Builtin::Provision

        def initialize(app, env)
          @machine = env[:machine]
          super
        end

        def call(env)
          @env = env

          if @machine.guest.name.eql? :redhat
            unless @machine.guest.capability?(:disable_requiretty)
              @machine.ui.warn(I18n.t('vagrant_arubacloud.disable_require_tty_cap_not_found'))
              return
            end

            @machine.ui.detail(I18n.t('vagrant_arubacloud.disabling_requiretty'))
            @machine.guest.capability(:disable_requiretty)
          end

          # Return the control to original Provision in middleware stack
          super
        end
      end

    end
  end
end
