require 'pp'

module VagrantPlugins
  module ArubaCloud
    module Command
      class Servers < Vagrant.plugin('2', :command)
        def execute
          options = {}
          opts = OptionParser.new do |o|
            o.banner = 'Usage: vagrant arubacloud servers [options]'
          end
          argv = parse_options(opts)
          return unless argv

          vm_count = 1
          vm_list = Array.new
          vm_size = 0

          with_target_vms(argv,  :provider => :arubacloud ,  :plist => '1' ) do |machine|
            if vm_count == 1
              ll = machine.name.length
              ui_ext = Vagrant::UI::Prefixed.new(  Vagrant::UI::Colored.new, " "*ll )
              ui_ext.opts = { :color => :white, :bold => true  }
              ui_ext.detail ('%-6s %-20s %-8s %-12s %-14s %s' % ['DC', 'Server Name', ' Id ', 'State Code', 'State meaning', 'IPv4 address'])
              ui_ext.detail ("-" * 80)
              # vm_size : how many vm are in .vagrant directory (is default)
              # status  : 'owned'  all VM defined in my '.vagrant' directory
              machine.provider_config.reserved_status = "owned"
              vm_size = machine.config.vm.defined_vm_keys.length
            end
            if (vm_count == vm_size)
                # if last element change 'status' to 'other' to output list of all external VM in current DC
                # and send  list all  VM's ( server.name) founds  in '.vagrant' directory
                machine.provider_config.reserved_status = "other"
                machine.provider_config.reserved_list_owned = vm_list
            end

            machine.action('list_servers')
            vm_count += 1
            # accum in append current server-name returned by list_server only if exist
            if machine.provider_config.reserved_list_owned
              vm_list <<  machine.provider_config.reserved_list_owned
            end
          end
        end
      end
    end
  end
end
