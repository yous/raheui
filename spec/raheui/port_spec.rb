# encoding: utf-8
require 'spec_helper'

describe Raheui::Port do
  describe '#push' do
    it { is_expected.to respond_to(:push) }
  end

  describe '#pop' do
    it { is_expected.to respond_to(:pop) }
  end
end
