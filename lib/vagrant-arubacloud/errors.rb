require 'vagrant'

module VagrantPlugins
  module ArubaCloud
    module Errors

      class ArubaCloudError < Vagrant::Errors::VagrantError
        error_namespace('vagrant_aruba_cloud.errors')
      end

      class MachineAlreadyPresent < ArubaCloudError
      end

      class BadServerResponse < ArubaCloudError
      end

    end
  end
end