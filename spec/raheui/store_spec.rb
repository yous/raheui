# encoding: utf-8

describe Raheui::Store do
  let(:error_msg) { '#%s is not implemented' }

  describe '#initialize' do
    it 'initializes @store' do
      expect(subject.instance_variable_get(:@store)).to eq([])
    end
  end

  describe '#size' do
    it 'responds to #size' do
      expect(subject).to respond_to(:size)
    end
  end

  %w(push pop push_dup swap).each do |base_method|
    describe "##{base_method}" do
      it 'raises NotImplementedError' do
        expect { subject.send(base_method.to_sym) }
          .to raise_error(NotImplementedError, format(error_msg, base_method))
      end
    end
  end
end
