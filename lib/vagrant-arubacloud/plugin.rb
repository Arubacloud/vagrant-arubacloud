begin
  require 'vagrant'
rescue LoadError
  raise 'The ArubaCloud IaaS provider must be run within Vagrant.'
end

if Vagrant::VERSION < '1.2.0'
  raise 'ArubaCloud IaaS provider is only compatible with Vagrant 1.2+'
end

module VagrantPlugins
  module ArubaCloud
    class Plugin < Vagrant.plugin('2')
      # noinspection RubyArgCount
      name 'ArubaCloud'
      description <<-DESC
      This plugin enable Vagrant to manage machines in ArubaCloud IaaS service.
      DESC

      config(:arubacloud, :provider) do
        require_relative 'config'
        Config
      end

      provider(:arubacloud, { :box_optional => true, :parallel => true }) do
        ArubaCloud.init_i18n
        ArubaCloud.init_logging

        require_relative 'provider'
        Provider
      end

      command('arubacloud') do
        ArubaCloud.init_i18n
        ArubaCloud.init_logging

        require_relative 'command/root'
        Command::Root
      end

      command('snapshot') do
        ArubaCloud.init_i18n
        ArubaCloud.init_logging

        require_relative 'command/snapshot'
        Command::Snapshot
      end

      # Disable require tty for centOS
      guest_capability 'redhat', 'disable_requiretty' do
        require_relative 'cap/disable_requiretty'
        Cap::DisableRequireTty
      end
    end # Plugin
  end # ArubaCloud
end # VagrantPlugins
