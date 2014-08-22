# encoding: utf-8
require 'spec_helper'
require 'raheui/shared_store'

describe Raheui::Queue do
  it_behaves_like 'a store'

  describe '#push' do
    context 'with no elements' do
      let(:element) { rand(10) }

      it 'returns an array with the pushed element' do
        expect(subject.push(element)).to match_array([element])
      end
    end

    context 'with one element' do
      let(:element) { rand(10) }

      before(:example) { subject.push(42) }

      it 'returns an array with the pushed element at first' do
        expect(subject.push(element)).to match_array([element, 42])
      end
    end
  end

  describe '#pop' do
    context 'with no elements' do
      it 'returns first pushed element' do
        subject.push(42)
        expect(subject.pop).to be(42)
      end
    end

    context 'with one element' do
      let(:element) { rand(10) }

      before(:example) { subject.push(element) }

      it 'returns the element' do
        expect(subject.pop).to be(element)
      end

      it 'returns first pushed element' do
        subject.push(42)
        expect(subject.pop).to be(element)
        expect(subject.pop).to be(42)
      end

      it 'returns nil after a pop call' do
        subject.pop
        expect(subject.pop).to be(nil)
      end
    end

    context 'with more than one element' do
      let(:one) { rand(10) }
      let(:two) { rand(10...20) }

      before(:example) do
        subject.push(one)
        subject.push(two)
      end

      it 'returns the elements in pushed order' do
        expect(subject.pop).to be(one)
        expect(subject.pop).to be(two)
      end

      it 'returns first pushed element' do
        subject.push(42)
        expect(subject.pop).to be(one)
        expect(subject.pop).to be(two)
        expect(subject.pop).to be(42)
      end
    end
  end

  describe '#push_dup' do
    context 'with one element' do
      let(:element) { rand(10) }

      before(:example) { subject.push(element) }

      it 'pushes the last element' do
        subject.push_dup
        expect(subject.pop).to be(element)
        expect(subject.pop).to be(element)
      end

      it 'pushes last pushed element' do
        subject.push(42)
        subject.push_dup
        expect(subject.pop).to be(element)
        expect(subject.pop).to be(42)
        expect(subject.pop).to be(42)
      end
    end
  end

  describe '#swap' do
    context 'with one element' do
      let(:element) { rand(10) }

      before(:example) { subject.push(element) }

      it "doesn't modify store" do
        subject.swap
        expect(subject.pop).to be(element)
      end
    end

    context 'with two elements' do
      let(:one) { rand(10) }
      let(:two) { rand(10...20) }

      before(:example) do
        subject.push(one)
        subject.push(two)
      end

      it 'swaps the last two elements' do
        subject.swap
        expect(subject.pop).to be(two)
        expect(subject.pop).to be(one)
      end
    end

    context 'with more than two elements' do
      let(:one) { rand(10) }
      let(:two) { rand(10...20) }
      let(:three) { rand(20...30) }

      before(:example) do
        subject.push(one)
        subject.push(two)
        subject.push(three)
      end

      it 'swaps the last two elements' do
        subject.swap
        expect(subject.pop).to be(one)
        expect(subject.pop).to be(three)
        expect(subject.pop).to be(two)
      end
    end
  end
end
