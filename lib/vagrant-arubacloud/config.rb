require 'vagrant'
require 'fog/arubacloud'

module VagrantPlugins
  module ArubaCloud

    class Config < Vagrant.plugin('2', :config)
      # ArubaCloud Username
      # @return [String]
      attr_accessor :arubacloud_username

      # ArubaCloud Password
      # @return [String]
      attr_accessor :arubacloud_password

      # Ws EndPoint Url
      # Expected to be the url of the web service to use
      # @return [String]
      attr_accessor :url

      # The name of the server. This defaults to the name of the machine
      # defined by Vagrant (via 'config.vm.define'), but can be override here.
      attr_accessor :server_name

      # The ID of the template to use
      attr_accessor :template_id

      # The smart vm type
      attr_accessor :package_id

      # The admin password of the vm (root user)
      attr_accessor :admin_password

      def initialize
        @arubacloud_username = UNSET_VALUE
        @arubacloud_password = UNSET_VALUE
        @admin_password = UNSET_VALUE
        @url = UNSET_VALUE
        @server_name = UNSET_VALUE
        @template_id = UNSET_VALUE
        @package_id = UNSET_VALUE
      end

      def finalize!
        @arubacloud_username = nil if @arubacloud_username == UNSET_VALUE
        @arubacloud_password = nil if @arubacloud_password == UNSET_VALUE
        @admin_password = nil if @admin_password == UNSET_VALUE
        @url = nil if @url == UNSET_VALUE
        @server_name = nil if @server_name == UNSET_VALUE
        @template_id = nil if @template_id == UNSET_VALUE
        @package_id = nil if @package_id == UNSET_VALUE
      end

      def validate(machine)
        errors = _detected_errors

        errors << 'An Username is required.' unless @arubacloud_username
        errors << 'A Password is required.' unless @arubacloud_password
        errors << 'An SSH root Password is required' unless @admin_password
        errors << 'A template_id is required.' unless @template_id
        errors << 'A package_id is required.' unless @package_id

        {'ArubaCloud Provider' => errors}
      end

    end # Config
  end # ArubaCloud
end # VagrantPlugins