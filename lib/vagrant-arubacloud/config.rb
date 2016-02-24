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
      # @return [String]
      attr_accessor :server_name

      # The ID of the template to use, use vagrant arubacloud templates to obtain
      # the complete list.
      # @return [Integer]
      attr_accessor :template_id

      # The smart vm type expressed in ID:
      # 1 = small
      # 2 = medium
      # 3 = large
      # 4 = extra-large
      # @return [Integer]
      attr_accessor :package_id

      # The admin password of the vm (root user) .
      # @return [String]
      attr_accessor :admin_password

      # Service Type expressed in ID [Integer]:
      # 1 = Pro Hyper-V
      # 2 = Pro VMWare
      # 3 = Pro Hyper-V Low Cost
      # 4 = Smart
      # @return [Integer]
      attr_accessor :service_type

      # Number of Virtual CPU to be assigned to the VM
      # Pro VMWare:  1 < n < 8
      # Pro Hyper-V: 1 < n < 4
      # @return [Integer]
      attr_accessor :cpu_number

      # Amount of GB of RAM to be assigned to the VM
      # n <= 16
      # @return [Integer]
      attr_accessor :ram_qty

      # Array containing hard disk Configuration
      # Example configuration (size is expressed in GB):
      # Hds = [{:type => 0, :size => 100}, {:type => 1, :size => 200}]
      # Hd type 0 is required because specify the first hard disk, max size per hd: 500 GB
      # Hd type > 0 < 4 are 3 additional hard disks (optional)
      # @return [Array]
      attr_accessor :hds

      def initialize
        @arubacloud_username = UNSET_VALUE
        @arubacloud_password = UNSET_VALUE
        @admin_password = UNSET_VALUE
        @url = UNSET_VALUE
        @server_name = UNSET_VALUE
        @template_id = UNSET_VALUE
        @package_id = UNSET_VALUE
        @service_type = UNSET_VALUE
        @cpu_number = UNSET_VALUE
        @ram_qty = UNSET_VALUE
        @hds = UNSET_VALUE
      end

      def finalize!
        @arubacloud_username = nil if @arubacloud_username == UNSET_VALUE
        @arubacloud_password = nil if @arubacloud_password == UNSET_VALUE
        @admin_password = nil if @admin_password == UNSET_VALUE
        @url = nil if @url == UNSET_VALUE
        @server_name = nil if @server_name == UNSET_VALUE
        @template_id = nil if @template_id == UNSET_VALUE
        @package_id = nil if @package_id == UNSET_VALUE
        @service_type = nil if @service_type == UNSET_VALUE
        @cpu_number = nil if @cpu_number == UNSET_VALUE
        @ram_qty = nil if @ram_qty == UNSET_VALUE
        @hds = nil if @hds == UNSET_VALUE
      end

      def validate(machine)
        errors = _detected_errors

        # Global configurations needed by all service types
        errors << I18n.t('vagrant_arubacloud.config.arubacloud_username_required') unless @arubacloud_username
        errors << I18n.t('vagrant_arubacloud.config.arubacloud_password_required') unless @arubacloud_password
        errors << I18n.t('vagrant_arubacloud.config.admin_password_required') unless @admin_password
        errors << I18n.t('vagrant_arubacloud.config.template_id_required') unless @template_id
        errors << I18n.t('vagrant_arubacloud.config.service_type_required') unless @service_type

        if @service_type.eql? Fog::Compute::ArubaCloud::SMART
          errors << I18n.t('vagrant_arubacloud.config.package_id_required') unless @package_id
        else
          errors << I18n.t('vagrant_arubacloud.config.cpu_number_required') unless @cpu_number
          errors << I18n.t('vagrant_arubacloud.config.ram_qty_required') unless @ram_qty
          if @hds
            errors << I18n.t('vagrant_arubacloud.config.hds_conf_must_be_array') unless @hds.kind_of?(Array)
          elsif
            errors << I18n.t('vagrant_arubacloud.config.hds_conf_required')
          end
        end
        {'ArubaCloud Provider' => errors}
      end

    end # Config
  end # ArubaCloud
end # VagrantPlugins