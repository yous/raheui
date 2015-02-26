# encoding: utf-8

require 'spec_helper'

describe Raheui::IO do
  describe '.read_int' do
    let(:value) { rand(-100..100) }

    it { is_expected.to respond_to(:read_int) }

    it 'reads an integer' do
      allow($stdin).to receive(:gets).with(no_args).once
        .and_return("#{value}\n")
      expect(subject.read_int).to be(value)
    end
  end

  describe '.read_chr' do
    it { is_expected.to respond_to(:read_chr) }

    it 'reads an ASCII code' do
      [0, *32..126].each do |value|
        allow($stdin).to receive(:getc).with(no_args).once
          .and_return(value.chr)
        expect(subject.read_chr).to be(value)
      end
    end

    it 'reads an control character' do
      [*1..31, *127..159].each do |value|
        allow($stdin).to receive(:getc).with(no_args).once
          .and_return(value.chr)
        expect(subject.read_chr).to be(value)
      end
    end

    it 'reads an unicode character' do
      [*10.times.map { rand(160..0xD7FF).chr(Encoding::UTF_8) }.uniq,
       # Range 0xD800..0xDFFF is used by UTF-16.
       *10.times.map { rand(0xE000..0x10FFFF).chr(Encoding::UTF_8) }.uniq,
       '가', 'あ', '漢', '　', 'å', '★'].each do |chr|
        allow($stdin).to receive(:getc).with(no_args).once
          .and_return(chr)
        expect(subject.read_chr).to be(chr.ord)
      end
    end
  end

  describe '.print_int', :mocked_stdout do
    let(:value) { rand(-100..100) }

    it { is_expected.to respond_to(:print_int) }

    it 'prints an integer' do
      expect(subject.print_int(value)).to be_nil
      expect($stdout.string).to eq(value.to_s)
    end
  end

  describe '.print_chr', :mocked_stdout do
    it { is_expected.to respond_to(:print_chr) }

    [0, *32..126].each do |value|
      it "prints an ASCII character corresponding character code #{value}" do
        expect(subject.print_chr(value)).to be_nil
        expect($stdout.string).to eq(value.chr)
      end
    end

    [*1..31, *127..159].each do |value|
      it "prints an control character corresponding character code #{value}" do
        expect(subject.print_chr(value)).to be_nil
        expect($stdout.string).to eq(value.chr(Encoding::UTF_8))
      end
    end

    [*10.times.map { rand(160..0xD7FF) }.uniq,
     # Range 0xD800..0xDFFF is used by UTF-16.
     *10.times.map { rand(0xE000..0x10FFFF) }.uniq,
     *['가', 'あ', '漢', '　', 'å', '★'].map(&:ord)].each do |value|
      it "prints an unicode character corresponding character code #{value}" do
        expect(subject.print_chr(value)).to be_nil
        expect($stdout.string).to eq(value.chr(Encoding::UTF_8))
      end
    end

    [*10.times.map { rand(0xD800..0xDFFF) }.uniq,
     0x110000].each do |value|
      it "prints an #{format('[U+%04X]', value)} when RangeError is raised" do
        expect(subject.print_chr(value)).to be_nil
        expect($stdout.string).to eq(format('[U+%04X]', value))
      end
    end
  end
end
