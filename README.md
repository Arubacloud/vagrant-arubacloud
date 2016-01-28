# Vagrant ArubaCloud Provider

This is a [Vagrant](http://www.vagrantup.com) 1.5+ plugin that adds ArubaCloud provider 
to Vagrant, allowing Vagrant to control and provision machine in ArubaCloud Smart IaaS Service.

## Features
* Boot ArubaCloud instances.
* SSH into instances.
* Provision the instances with any built-in Vagrant provisioner.
* Specify which datacenter you want to use.


## Installation
Install using standard `vagrant plugin install` method, since the gem is published in[central RubyGemsrepository](https://rubygems.org/gems/vagrant-arubacloud)
```
$ vagrant plugin install vagrant-arubacloud
```

## Quickstart
After installing the plugin (instructions above), the quickest way to get
started is to actually use a dummy ArubaCloud box and specify all the details
manually within a `config.vm.provider` block. So first, add the dummy
box using any name you want:

```
$ vagrant box add dummy https://github.com/arubacloud/vagrant-arubacloud/raw/master/dummy.box
...
```

And then make a Vagrantfile that looks like the following, filling in
your information where necessary.

```
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "dummy"

  config.vm.define :ubuntu do |ubuntu|
    ubuntu.ssh.username = 'root'
    ubuntu.ssh.password = 'yourstrongpassword'
    ubuntu.vm.provider :arubacloud do |ac|
      ac.arubacloud_username = ENV['AC_USERNAME']
      ac.arubacloud_password = ENV['AC_PASSWORD']
      ac.admin_password = 'yourstrongpassword'
      ac.template_id = '601'
      ac.package_id = 1
    end
  end
end
```

For now, the root password must be specified in this way, I will change it soon (it's horrible).

And then run `vagrant up --provider=arubacloud`.

This will start an Ubuntu 14.04 instance in the second Italian Datacenter (DC2-IT) within
your account. And assuming your SSH information was filled in properly
within your Vagrantfile, SSH and provisioning will work as well.

Note that normally a lot of this boilerplate is encoded within the box
file, but the box file used for the quick start, the "dummy" box, has
no preconfigured defaults.

If you have issues with SSH connecting, make sure that the instances
are being launched with a security group that allows SSH access.

## Development

To work on the `vagrant-arubacloud` plugin, clone this repository out, and use
[Bundler](http://gembundler.com) to get the dependencies:

```
$ bundle
```

Once you have the dependencies, verify the unit tests pass with `rake`:

```
$ bundle exec rake
```

If those pass, you're ready to start developing the plugin. You can test
the plugin without installing it into your Vagrant environment by just
creating a `Vagrantfile` in the top level of this directory (it is gitignored)
and add the following line to your `Vagrantfile` 
```ruby
Vagrant.require_plugin "vagrant-arubacloud"
```
Use bundler to execute Vagrant:
```
$ bundle exec vagrant up --provider=arubacloud
``` 
