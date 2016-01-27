module VagrantPlugins
  module ArubaCloud
    module Command
      class Templates < Vagrant.plugin('2', :command)
        def execute
          options = {}
          opts = OptionParser.new do |o|
            o.banner = 'Usage: vagrant arubacloud templates [options]'
          end

          argv = parse_options(opts)
          return unless argv

          with_target_vms(argv, :provider => :arubacloud) do |machine|
            machine.action('list_templates')
          end
        end
      end
    end
  end
end
