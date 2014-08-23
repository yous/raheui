# encoding: utf-8
require 'spec_helper'

describe Raheui::Store do
  let(:base_methods) { Raheui::Store.const_get(:BASE_METHODS) }
  let(:error_msg) { 'base methods are not implemented: %s' }

  describe '#initialize' do
    it 'raises NotImplementedError' do
      expect { subject }.to raise_error(
                              NotImplementedError,
                              format(error_msg, base_methods.join(', ')))
    end

    context 'with implemented push' do
      let(:methods) { base_methods - [:push] }

      before(:context) { Raheui::Store.class_eval { def push; end } }
      after(:context) { Raheui::Store.class_eval { remove_method :push } }

      it 'raises NotImplementedError' do
        expect(base_methods - methods).to contain_exactly(:push)
        expect { subject }.to raise_error(
                                NotImplementedError,
                                format(error_msg, methods.join(', ')))
      end
    end

    context 'with implemented pop' do
      let(:methods) { base_methods - [:pop] }

      before(:context) { Raheui::Store.class_eval { def pop; end } }
      after(:context) { Raheui::Store.class_eval { remove_method :pop } }

      it 'raises NotImplementedError' do
        expect(base_methods - methods).to contain_exactly(:pop)
        expect { subject }.to raise_error(
                                NotImplementedError,
                                format(error_msg, methods.join(', ')))
      end
    end

    context 'with implemented all base methods' do
      before(:context) do
        Raheui::Store.class_eval do
          def push; end

          def pop; end
        end
      end

      after(:context) do
        Raheui::Store.class_eval do
          remove_method :push
          remove_method :pop
        end
      end

      it 'does not raise NotImplementedError' do
        expect { subject }.not_to raise_error
      end
    end
  end

  describe '#size' do
    it 'should respond to #size' do
      expect(Raheui::Store.instance_methods(false)).to include(:size)
    end
  end

  describe '#push_dup' do
    it 'should respond to #push_dup' do
      expect(Raheui::Store.instance_methods(false)).to include(:push_dup)
    end
  end

  describe '#swap' do
    it 'should respond to #swap' do
      expect(Raheui::Store.instance_methods(false)).to include(:swap)
    end
  end
end
