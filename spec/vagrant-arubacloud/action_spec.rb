# coding: utf-8
require 'spec_helper'
require 'vagrant'
require 'vagrant-arubacloud/action'


RSpec.describe VagrantPlugins::ArubaCloud::Action do

  let(:builder) do
    double('builder').tap do |builder|
      #builder.stub(:use)
      allow(builder).to receive(:use)
    end
  end

  before :each do
    allow(Vagrant::Action::Builder).to receive(:new_builder) {   builder }
  end

  describe 'action_read_ssh_info' do
    it 'add others middleware to builder' do
      expect(builder).to receive(:use).with(ConfigValidate)
      expect(builder).to receive(:use).with(ConnectArubaCloud)
      expect(builder).to receive(:use).with(ReadSSHInfo)
      unless ( u  = VagrantPlugins::ArubaCloud::Action.action_read_ssh_info).nil?
        u.stack.each do |x|
          builder.send("use", x.first)
        end
      end
    end
  end

  describe 'action_read_state' do
    it 'add others middleware to builder' do
      expect(builder).to receive(:use).with(ConfigValidate)
      expect(builder).to receive(:use).with(ConnectArubaCloud)
      expect(builder).to receive(:use).with(ReadState)
      unless ( u  = VagrantPlugins::ArubaCloud::Action.action_read_state).nil?
        u.stack.each do |x|
          builder.send("use", x.first)
        end
      end
    end
  end

  describe 'action_destroy' do
    it 'add others middleware to builder' do
      expect(builder).to receive(:use).with(ConfigValidate)
      expect(builder).to receive(:use).with(Call)
      unless ( u  = VagrantPlugins::ArubaCloud::Action.action_destroy).nil?
        u.stack.each do |x|
          builder.send("use", x.first)
        end
      end
    end
  end

  describe 'action_list_servers' do
    it 'add others middleware to builder' do
      expect(builder).to receive(:use).with(ConnectArubaCloud)
      expect(builder).to receive(:use).with(ListServers)
      unless ( u  = VagrantPlugins::ArubaCloud::Action.action_list_servers).nil?
        u.stack.each do |x|
          builder.send("use", x.first)
        end
      end
    end
  end

  describe 'action_list_templates' do
    it 'add others middleware to builder' do
      expect(builder).to receive(:use).with(ConnectArubaCloud)
      expect(builder).to receive(:use).with(ListTemplates)
      unless ( u  = VagrantPlugins::ArubaCloud::Action.action_list_templates).nil?
        u.stack.each do |x|
          builder.send("use", x.first)
        end
      end
    end
  end

  describe 'action_halt' do
    it 'add others middleware to builder' do
      expect(builder).to receive(:use).with(ConfigValidate)
      expect(builder).to receive(:use).with(Call)
      unless ( u  = VagrantPlugins::ArubaCloud::Action.action_halt).nil?
        u.stack.each do |x|
          builder.send("use", x.first)
        end
      end
    end
  end

  describe 'action_start' do
    it 'add others middleware to builder' do
      expect(builder).to receive(:use).with(ConfigValidate)
      expect(builder).to receive(:use).with(Call)
      unless ( u  = VagrantPlugins::ArubaCloud::Action.action_start).nil?
        u.stack.each do |x|
          builder.send("use", x.first)
        end
      end
    end
  end

  describe 'action_provision' do
    it 'add others middleware to builder' do
      expect(builder).to receive(:use).with(ConfigValidate)
      expect(builder).to receive(:use).with(Call)
      unless ( u  = VagrantPlugins::ArubaCloud::Action.action_provision).nil?
        u.stack.each do |x|
          builder.send("use", x.first)
        end
      end
    end
  end

  describe 'action_reload' do
    it 'add others middleware to builder' do
      expect(builder).to receive(:use).with(ConfigValidate)
      expect(builder).to receive(:use).with(ConnectArubaCloud)
      unless ( u  = VagrantPlugins::ArubaCloud::Action.action_reload).nil?
        u.stack.each do |x|
          builder.send("use", x.first)
        end
      end
    end
  end

  describe 'action_ssh' do
    it 'add others middleware to builder' do
      expect(builder).to receive(:use).with(ConfigValidate)
      expect(builder).to receive(:use).with(Call)
      unless ( u  = VagrantPlugins::ArubaCloud::Action.action_ssh).nil?
        u.stack.each do |x|
          builder.send("use", x.first)
        end
      end
    end
  end

  describe 'action_ssh_run' do
    it 'add others middleware to builder' do
      expect(builder).to receive(:use).with(ConfigValidate)
      expect(builder).to receive(:use).with(Call)
      unless ( u  = VagrantPlugins::ArubaCloud::Action.action_ssh_run).nil?
        u.stack.each do |x|
          builder.send("use", x.first)
        end
      end
    end
  end

  describe 'action_up' do
    it 'add others middleware to builder' do
      expect(builder).to receive(:use).with(ConfigValidate)
      expect(builder).to receive(:use).with(Call)
      unless ( u  = VagrantPlugins::ArubaCloud::Action.action_up).nil?
        u.stack.each do |x|
          builder.send("use", x.first)
        end
      end
    end
  end

end
