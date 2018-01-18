# -*- mode: ruby -*-
# vi: set ft=ruby :
# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

%w{AC_USERNAME AC_PASSWORD}.each do |var|
  abort "Please set the environment variable #{var} in order to run the test" unless ENV.key? var
end

require 'securerandom'
rnd_string = SecureRandom.hex(2)

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "dummy"
  config.vm.define :ubuntu do |ubuntu|
    ubuntu.ssh.username = 'root'
    ubuntu.ssh.password = 'test123'
    ubuntu.vm.provider :arubacloud do |ac|
      ac.arubacloud_username = ENV['AC_USERNAME']
      ac.arubacloud_password = ENV['AC_PASSWORD']
      # service_type 4 = smart
      ac.service_type = 4
      ac.admin_password = 'test123'
      ac.template_id = '793'
      ac.server_name = 'lnxtestvag1'
      # The package id now must be expressed with name:
      #  'small,medium,large,extralarge'
      ac.package_id = 'small'
    end
  end
end
