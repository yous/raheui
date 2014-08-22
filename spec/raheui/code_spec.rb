# encoding: utf-8
require 'spec_helper'

describe Raheui::Code do
  shared_examples 'a code' do
    subject(:code) { Raheui::Code.new(code_str) }
    let(:consonants) { code.method(:consonants) }

    describe '#[]' do
      it 'returns item at given position' do
        code_str.lines.each_with_index do |line, y|
          line.chomp.chars.each_with_index do |ch, x|
            expect(code[x, y]).to match_array(consonants.call(ch))
          end
        end
      end

      it 'returns item at given negative position' do
        max_y = code_str.lines.count
        code_str.lines.each_with_index do |line, y|
          max_x = line.chomp.chars.count
          line.chomp.chars.each_with_index do |ch, x|
            expected = consonants.call(ch)
            expect(code[x - max_x, y]).to match_array(expected)
            expect(code[x, y - max_y]).to match_array(expected)
            expect(code[x - max_x, y - max_y]).to match_array(expected)
          end
        end
      end

      it 'returns an empty array if there is no item at given position' do
        max_x = code_str.lines.max_by { |line| line.chomp.size }.size
        max_y = code_str.lines.count
        expect(code[0, max_y]).to match_array([])
        expect(code[max_x, 0]).to match_array([])
        expect(code[max_x, max_y]).to match_array([])
      end
    end
  end

  describe Raheui::Code, 'with aheui code' do
    let(:code_str) { '아희' }
    it_behaves_like 'a code'
  end

  describe Raheui::Code, 'with hello world code' do
    let(:code_str) do
      <<-CODE
밤밣따빠밣밟따뿌
빠맣파빨받밤뚜뭏
돋밬탕빠맣붏두붇
볻뫃박발뚷투뭏붖
뫃도뫃희멓뭏뭏붘
뫃봌토범더벌뿌뚜
뽑뽀멓멓더벓뻐뚠
뽀덩벐멓뻐덕더벅
      CODE
    end

    it_behaves_like 'a code'
  end

  describe '#consonants' do
    subject { Raheui::Code.new('') }
    let(:consonants) { subject.method(:consonants) }
    before(:example) do
      stub_const('INITIAL_COUNT', Raheui::Code.const_get(:INITIAL_COUNT))
      stub_const('MEDIAL_COUNT', Raheui::Code.const_get(:MEDIAL_COUNT))
      stub_const('FINAL_COUNT', Raheui::Code.const_get(:FINAL_COUNT))
    end

    it 'returns consonants of Korean alphabet' do
      examples = [
        # 가
        [0, 0, 0],
        # 힣
        [INITIAL_COUNT - 1, MEDIAL_COUNT - 1, FINAL_COUNT - 1]
      ]
      examples.concat(10.times.map do
        [rand(INITIAL_COUNT), rand(MEDIAL_COUNT), rand(FINAL_COUNT)]
      end)
      examples.each do |initial, medial, final|
        alphabet = (
          0xAC00 +
            initial * MEDIAL_COUNT * FINAL_COUNT +
            medial * FINAL_COUNT +
            final
        ).chr(Encoding::UTF_8)
        expect(consonants.call(alphabet)).to match_array(
                                               [initial, medial, final])
      end
    end

    it 'returns an empty array for non-Korean alphabet' do
      examples = [*0..127, 0xAC00 + INITIAL_COUNT * MEDIAL_COUNT * FINAL_COUNT]
      examples.concat(%w(あ 漢 　 å ★).map(&:ord))
      examples.each do |ch|
        expect(consonants.call(ch)).to match_array([])
      end
    end
  end
end
