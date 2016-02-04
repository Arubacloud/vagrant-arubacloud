require 'vagrant/action/builder'

module VagrantPlugins
  module ArubaCloud
    module Action

      # Access top level stuff
      include Vagrant::Action::Builtin

      def self.action_destroy
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Call, IsCreated do |env, b1|
            unless env[:result]
              b1.use MessageNotCreated
              next
            end

            b1.use Call, DestroyConfirm do |env1, b2|
              if env1[:result]
                b2.use ConnectArubaCloud
                b2.use HaltServer
                b2.use DeleteServer
              else
                b2.use Message, ' The server will not be deleted.'
                next
              end
            end
          end
        end
      end

      def self.action_halt
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate #shame on you
          b.use Call, IsCreated do |env, b1|
            unless env[:result]
              b1.use MessageNotCreated
              next
            end
            b1.use ConnectArubaCloud
            b1.use HaltServer
          end
        end
      end

      def self.action_provision
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Call, IsCreated do |env, b2|
            unless env[:result]
              b2.use MessageNotCreated
              next
            end
            b2.use Provision
            b2.use SyncedFolders
          end
        end
      end

      def self.action_read_ssh_info
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use ConnectArubaCloud
          b.use ReadSSHInfo
        end
      end

      # This action is called to read the state of the machine. The
      # resulting state is expected to be put into the `:machine_state_id`
      # key.
      def self.action_read_state
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use ConnectArubaCloud
          b.use ReadState
        end
      end

      def self.action_ssh
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Call, IsCreated do |env, b2|
            unless env[:result]
              b2.use MessageNotCreated
              next
            end
            b2.use SSHExec
          end
        end
      end

      def self.action_ssh_run
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Call, IsCreated do |env, b2|
            unless env[:result]
              b2.use MessageNotCreated
              next
            end

            b2.use SSHRun
          end
        end
      end

      def self.action_up
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Call, IsCreated do |env, b2|
            if env[:result]
              b2.use MessageAlreadyCreated
              next
            end

            b2.use ConnectArubaCloud
            # b2.use RunInitScript # temporarily removed
            b2.use CreateServer
            b2.use WaitForCommunicator
          end
        end
      end

      def self.action_list_servers
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConnectArubaCloud
          b.use ListServers
        end
      end

      def self.action_list_templates
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConnectArubaCloud
          b.use ListTemplates
        end
      end

      # The autoload farm
      action_root = Pathname.new(File.expand_path('../action', __FILE__))
      autoload :ConnectArubaCloud, action_root.join('connect_arubacloud')
      autoload :CreateServer, action_root.join('create_server')
      autoload :HaltServer, action_root.join('halt_server')
      autoload :DeleteServer, action_root.join('delete_server')
      autoload :IsCreated, action_root.join('is_created')
      autoload :MessageNotCreated, action_root.join('message_not_created')
      autoload :MessageAlreadyCreated, action_root.join('message_already_created')
      autoload :ReadSSHInfo, action_root.join('read_ssh_info')
      autoload :ReadState, action_root.join('read_state')
      # autoload :RunInitScript, action_root.join("run_init_script")
      autoload :ListServers, action_root.join('list_servers')
      autoload :ListTemplates, action_root.join('list_templates')

    end
  end
end
