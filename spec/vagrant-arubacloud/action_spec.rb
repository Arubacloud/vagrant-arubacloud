require 'spec_helper'
require 'vagrant'
require 'vagrant-arubacloud/action'

describe VagrantPlugins::ArubaCloud::Action do
  let(:builder) do
    double('builder').tap do |builder|
      builder.stub(:use)
    end
  end

  before :each do
    Action.stub(:new_builder) { builder }
  end

  describe 'action_destroy' do
    it 'add others middleware to builder' do
      expect(builder).to receive(:use).with(ConfigValidate)
      expect(builder).to receive(:use).with(ConnectArubaCloud)
      expect(builder).to receive(:use).with(Call, ReadState)
      # TODO, Impove this test to check what's happen after ReadState
      Action.action_destroy
    end
  end
end