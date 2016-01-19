require 'vagrant'

require 'vagrant-arubacloud/action'
module VagrantPlugins
  module ArubaCloud
    class Provider < Vagrant.plugin('2', :provider)
      def initialize(machine)
        @machine = machine
      end

      def action(name)
        # Attempt to get the action method from the Action class if it
        # exists, otherwise return nil to show that we don't support the
        # given action.
        action_method = "action_#{name}"
        return Action.send(action_method) if Action.respond_to?(action_method)
        nil
      end

      def state
        # Run a custom action we define called "read_state" which does
        # what it says. It puts the state in the `:machine_state_id`
        # key in the environment.
        env = @machine.action('read_state')

        state_id = env[:machine_state_id]

        # Get the short and long description
        short = "vagrant_arubacloud.states.short_#{state_id}"
        long  = "vagrant_arubacloud.states.long_#{state_id}"

        # Return the MachineState object
        Vagrant::MachineState.new(state_id, short, long)
      end

      def to_s
        'ArubaCloud IaaS'
      end
    end # Provider
  end # ArubaCloud
end # VagrantPlugins