require 'vagrant-arubacloud/action'

module VagrantPlugins
  module ArubaCloud
    module Command
      class Root < Vagrant.plugin('2', :command)
        def self.synopsis
          'query ArubaCloud for servers and templates'
        end

        def initialize(argv, env)
          @main_args, @sub_command, @sub_args = split_main_and_subcommand(argv)
          @env = env

          @subcommands = Vagrant::Registry.new
          @subcommands.register(:templates) do
            require File.expand_path('../templates', __FILE__)
            Templates
          end
          @subcommands.register(:servers) do
            require File.expand_path('../servers', __FILE__)
            Servers
          end

          super(argv, env)
        end

        def execute
          if @main_args.include?('-h') || @main_args.include?('--help')
            return help
          end

          # Set command_class to default nil
          command_class = nil
          command_class = @subcommands.get(@sub_command.to_sym) if @sub_command
          return help if command_class.nil? || !@sub_command
          @logger.debug("Invoking command class: #{command_class} #{@sub_args.inspect}")

          # Initialize and execute the command class
          command_class.new(@sub_args, @env).execute
        end

        def help
          opts = OptionParser.new do |opts|
            opts.banner = 'Usage: vagrant arubacloud <subcommand> [<args>]'
            opts.separator ''
            opts.separator 'Available subcommands:'

            # Add the available subcommands as separators in order to print them
            # out as well.
            keys = []
            @subcommands.each { |key, value| keys << key.to_s }

            keys.sort.each do |key|
              opts.separator "     #{key}"
            end

            opts.separator ''
            opts.separator 'For help on any individual subcommand run `vagrant arubacloud <subcommand> -h`'
          end

          @env.ui.info(opts.help, :prefix => false)
        end
      end
    end
  end
end
