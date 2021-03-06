# encoding: utf-8

shared_examples 'a store' do
  describe '#push' do
    it { is_expected.to respond_to(:push) }
  end

  describe '#pop' do
    it { is_expected.to respond_to(:pop) }

    context 'with no elements' do
      it { expect(subject.pop).to be_nil }
    end
  end

  describe '#push_dup' do
    it { is_expected.to respond_to(:push_dup) }

    context 'with no elements' do
      it "doesn't push" do
        subject.push_dup
        expect(subject.size).to be_zero
      end
    end
  end

  describe '#swap' do
    it { is_expected.to respond_to(:swap) }

    context 'with no elements' do
      it "doesn't modify store" do
        subject.swap
        expect(subject.size).to be_zero
      end
    end
  end

  describe '#size' do
    context 'with no elements' do
      it { expect(subject.size).to be_zero }

      it 'returns 0 after pop' do
        subject.pop
        expect(subject.size).to be_zero
      end
    end
  end
end
