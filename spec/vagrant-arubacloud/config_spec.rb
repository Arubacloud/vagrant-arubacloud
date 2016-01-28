require 'spec_helper'
require 'vagrant-arubacloud/config'

describe VagrantPlugins::ArubaCloud::Config do
  describe 'defaults' do
    subject do
      super().tap do |o|
        o.finalize!
      end
    end

    its(:arubacloud_username) { should be_nil }
    its(:arubacloud_password) { should be_nil }
    its(:url) { should be_nil }
    its(:server_name) { should be_nil }
    its(:template_id) { should be_nil}
    its(:package_id) { should be_nil }
    its(:admin_password) { should be_nil }

    describe 'overriding default' do
      [:arubacloud_username,
      :arubacloud_password,
      :url,
      :server_name,
      :template_id,
      :package_id,
      :admin_password].each do |attribute|
        it "should not default #{attribute} if overridden" do
          subject.send("#{attribute}=".to_sym, 'foo')
          subject.finalize!
          subject.send(attribute).should == 'foo'
        end
      end
    end


  end
end

