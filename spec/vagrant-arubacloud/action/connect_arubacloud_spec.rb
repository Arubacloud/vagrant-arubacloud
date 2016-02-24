require 'vagrant-arubacloud/action'
require 'spec_helper'

include VagrantPlugins::ArubaCloud::Action

describe VagrantPlugins::ArubaCloud::Action::ConnectArubaCloud do
  let(:app) do
    double.tap do |app|
      app.stub(:call)
    end
  end

  let(:config) do
    double.tap do |config|
      config.stub(:arubacloud_username) {'test'}
      config.stub(:arubacloud_password) {'password'}
      config.stub(:template_id) {'1'}
      config.stub(:service_type) {'1'}
    end
  end

  let(:env) do
    {}.tap do |env|
      env[:ui] = double
      env[:ui].stub(:info).with(anything)
      env[:ui].stub(:warn).with(anything)
      env[:machine] = double('machine')
      env[:machine].stub(:provider_config) { config }
      env[:arubacloud_compute] = double('arubacloud_compute')
    end
  end

  before(:all) do
    ConnectArubaCloud.send(:public, *ConnectArubaCloud.private_instance_methods)
  end
end