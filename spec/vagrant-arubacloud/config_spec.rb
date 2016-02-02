require 'spec_helper'
require 'vagrant-arubacloud/config'
require 'fog/arubacloud'


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

    describe 'validation' do
      let(:machine) { double('machine') }
      let(:validation_errors) { subject.validate(machine)['ArubaCloud Provider'] }
      let(:error_message) { double('error message') }

      # prepare the subject with all expected properties
      before(:each) do
        machine.stub_chain(:env, :root_path).and_return '/'
        subject.arubacloud_username = 'foo'
        subject.arubacloud_password = 'bar'
        subject.admin_password = 'foobar'
        subject.template_id = 1
        subject.package_id = 1
      end

      subject do
        super().tap do |o|
          o.finalize!
        end
      end

      context 'with invalid key' do
        it 'should raise an error' do
          subject.nonsense1 = true
          subject.nonsense2 = false
          I18n.should_receive(:t).with(
              'vagrant.config.common.bad_field',
              { :fields => 'nonsense1, nonsense2' }
          ).and_return error_message
          validation_errors.first.should == error_message
        end
      end

      context 'with good values' do
        it 'should validate' do
          validation_errors.should be_empty
        end
      end

      context 'the arubacloud_username' do
        it 'should error if not given' do
          subject.arubacloud_username = nil
          I18n.should_receive(:t).with('vagrant_arubacloud.config.arubacloud_username_required')
          .and_return error_message
          validation_errors.first.should == error_message
        end
      end

      context 'the arubacloud_password' do
        it 'should error if not given' do
          subject.arubacloud_password = nil
          I18n.should_receive(:t).with('vagrant_arubacloud.config.arubacloud_password_required')
          .and_return error_message
          validation_errors.first.should == error_message
        end
      end

      context 'the admin_password' do
        it 'should error it not given' do
          subject.admin_password = nil
          I18n.should_receive(:t).with('vagrant_arubacloud.config.admin_password_required')
          .and_return error_message
          validation_errors.first.should == error_message
        end
      end

      context 'the template_id' do
        it 'should error if not given' do
          subject.template_id = nil
          I18n.should_receive(:t).with('vagrant_arubacloud.config.template_id_required')
          .and_return error_message
          validation_errors.first.should == error_message
        end
      end

      context 'the package_id' do
        it 'should error if not given' do
          subject.package_id = nil
          I18n.should_receive(:t).with('vagrant_arubacloud.config.package_id_required')
          .and_return error_message
          validation_errors.first.should == error_message
        end
      end

      context 'the url' do
        it 'should validate if nil' do
          subject.url = nil
          validation_errors.should be_empty
        end
      end
    end
  end
end

