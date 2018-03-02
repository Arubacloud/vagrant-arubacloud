require 'vagrant/action/builder'
require 'vagrant/action'

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

      def self.action_start
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Call, IsCreated do |env, b1|
            unless env[:result]
              b1.use MessageNotCreated
              next
            end
            b1.use ConnectArubaCloud
            b1.use StartServer
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
            # Use our custom provisioning class
            b2.use ArubaProvision
            b2.use SyncedFolders
          end
        end
      end

      def self.action_reload
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use ConnectArubaCloud

          b.use Call, IsCreated do |env, b2|
            if !env[:result]
              b2.use MessageNotCreated
              next
            end
            b2.use action_halt
            # if not stopped , signal and exit
	    b2.use Call, IsState, Fog::ArubaCloud::Compute::Server::STOPPED  do |envr, br|
	      if !envr[:result]
                br.use Message, ' The server not respond at power off request.'
	        next
	      end
	    end
            # VM is power off ; now can be powered on
            b2.use action_start
            b2.use Call, IsCreated do |env3, b3|
              unless env3[:result]
                b3.use Message, ' The server not re-create or not started  '
                next
              end
              # Use our custom provisioning class
              b3.use ConnectArubaCloud
              b3.use WaitForCommunicator
              b3.use SyncedFolders
            end
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
            b2.use CreateServer
            b2.use WaitForCommunicator
            b2.use SyncedFolders
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
      autoload :StartServer, action_root.join('start_server')
      autoload :DeleteServer, action_root.join('delete_server')
      autoload :IsCreated, action_root.join('is_created')
      autoload :MessageNotCreated, action_root.join('message_not_created')
      autoload :MessageAlreadyCreated, action_root.join('message_already_created')
      autoload :ReadSSHInfo, action_root.join('read_ssh_info')
      autoload :ReadState, action_root.join('read_state')
      autoload :ListServers, action_root.join('list_servers')
      autoload :ListTemplates, action_root.join('list_templates')
      autoload :ArubaProvision, action_root.join('aruba_provision')
    end
  end
end
