# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

%w{AC_USERNAME AC_PASSWORD AC_ADMIN_PASSWORD}.each do |var|
  abort "Please set the environment variable #{var} in order to run the test" unless ENV.key? var
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "dummy"

  config.vm.define :ubuntu do |ubuntu|
    ubuntu.vm.provider :arubacloud do |ac|
      ac.username = ENV['AC_USERNAME']
      ac.password = ENV['AC_PASSWORD']
      ac.admin_password = ENV['AC_ADMIN_PASSWORD']
    end
  end

end
