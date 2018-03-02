require 'spec_helper'
require 'vagrant-arubacloud/config'
require 'fog/arubacloud'
require 'vagrant'

RSpec.describe VagrantPlugins::ArubaCloud::Config do
  describe 'defaults' do

    subject do
      super().tap do |o|
        o.finalize!
      end
    end

    it :arubacloud_username do
      subject.expect(:arubacloud_username).to be_nil
    end
    it :arubacloud_password do
      subject.expect(:arubacloud_password).to be_nil
    end
    it :url do
      subject.expect(:url).to be_nil
    end
    it :endpoint do
      subject.expect(:endpoint).to be_nil
    end
    it :server_name do
      subject.expect(:server_name).to be_nil
    end
    it :template_id do
      subject.expect(:template_id).to be_nil
    end
    it :package_id do
      subject.expect(:package_id).to be_nil
    end

    describe 'overriding default' do
      [:arubacloud_username,
      :arubacloud_password,
      :url,
      :endpoint,
      :server_name,
      :template_id,
      :package_id].each do |attribute|
        it "should not default #{attribute} if overridden" do
          subject.send("#{attribute}=".to_sym, 'foo')
          subject.finalize!
          subject.expect("#{attribute}").to eq('foo')
        end
      end
    end

    subject do
      super().tap do |o|
        o.finalize!
      end
    end

    describe 'validation' do
      let(:machine) { double('machine') }
      let(:validation_errors) { subject.validate(machine)['ArubaCloud Provider'] }
      let(:error_message) { double('error message') }

      # prepare the subject with all expected properties
      before(:each) do
        allow(machine).to receive_message_chain(:env, :root_path) { '/' }
        allow(machine).to receive_message_chain("config.ssh.password") { "pussysecret"  }
        subject.arubacloud_username = 'foo'
        subject.arubacloud_password = 'bar'
        subject.template_id = 1
        subject.package_id = 'small'
        subject.service_type = 1
        subject.cpu_number = 1
        subject.ram_qty = 1
        subject.hds = [{:type => 1, :size => 50}]
      end

      subject do
        super().tap do |o|
          o.finalize!
        end
      end

      context 'with good values' do
        it "arubacloud_username" do
          expect(validation_errors).to be_empty
        end
      end

      context 'with invalid key' do
        it 'should raise an error' do
          subject.nonsense1 = true
          subject.nonsense2 = false
          expect(I18n).to receive(:t).with('vagrant.config.common.bad_field', { :fields => 'nonsense1, nonsense2' }).and_return error_message
          validation_errors.first == error_message
        end
      end

      context 'the arubacloud_username' do
        it 'should error if not given' do
          subject.arubacloud_username = nil
          expect(I18n).to receive(:t).with('vagrant_arubacloud.config.arubacloud_username_required').and_return :error_message
          validation_errors.first  == error_message
        end
      end

      context 'the arubacloud_password' do
        it 'should error if not given' do
          subject.arubacloud_password = nil
          expect(I18n).to receive(:t).with('vagrant_arubacloud.config.arubacloud_password_required').and_return error_message
          validation_errors.first == error_message
        end
      end

      context 'the template_id' do
        it 'should error if not given' do
          subject.template_id = nil
          expect(I18n).to receive(:t).with('vagrant_arubacloud.config.template_id_required').and_return error_message
          validation_errors.first  == error_message
        end
      end

      context 'the service_type' do
        it 'should error if not given' do
          subject.service_type = nil
          expect(I18n).to receive(:t).with('vagrant_arubacloud.config.service_type_required').and_return error_message
          validation_errors.first  == error_message
        end
      end

      describe 'smart create' do
        context 'the package_id' do
          it 'should error if not given' do
            subject.package_id = nil
            subject.service_type = 4
            expect(I18n).to receive(:t).with('vagrant_arubacloud.config.package_id_required').and_return error_message
            validation_errors.first  == error_message
          end
        end
      end

      describe 'pro create' do
        before(:each) do
          subject.service_type = 1
        end

        context 'the cpu_number' do
          it 'should error if not given' do
            subject.cpu_number = nil
            expect(I18n).to receive(:t).with('vagrant_arubacloud.config.cpu_number_required').and_return error_message
            validation_errors.first  == error_message
          end
        end
        context 'the ram_qty' do
          it 'should error if not given' do
            subject.ram_qty = nil
            expect(I18n).to receive(:t).with('vagrant_arubacloud.config.ram_qty_required').and_return error_message
            validation_errors.first == error_message
          end
        end
        context 'the package_id' do
          it 'should valid if not given' do
            subject.package_id = nil
            expect(validation_errors).to  be_empty
          end
        end
        context 'the hds configuration' do
          it 'should error if its not an array' do
            subject.hds = 'test'
            expect(I18n).to receive(:t).with('vagrant_arubacloud.config.hds_conf_must_be_array').and_return error_message
            validation_errors.first == error_message
          end
        end
        context 'the hds configuration' do
          it 'should error if not given' do
            subject.hds = nil
            expect(I18n).to receive(:t).with('vagrant_arubacloud.config.hds_conf_required').and_return error_message
            validation_errors.first  == error_message
          end
        end
      end
    end
  end
end

