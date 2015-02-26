# encoding: utf-8

describe Raheui::Code do
  shared_examples 'a code' do
    subject(:code) { Raheui::Code.new(code_str) }
    let(:consonants) { code.method(:consonants) }

    it 'has width which is maximum line length of code with minimum value 1' do
      width = code_str.lines.map { |line| line.chomp.size }.max || 1
      expect(code.width).to be(width)
    end

    it 'has height which is number of lines with minimum value 1' do
      height = [code_str.lines.count, 1].max
      expect(code.height).to be(height)
    end

    describe '#[]' do
      it 'returns item at given position' do
        code_str.lines.each_with_index do |line, y|
          line.chomp.chars.each_with_index do |ch, x|
            expect(code[x, y]).to match_array(consonants.call(ch))
          end
        end
      end

      it 'returns item at given negative position' do
        code_str.lines.each_with_index do |line, y|
          max_x = line.chomp.chars.count
          line.chomp.chars.each_with_index do |ch, x|
            expected = consonants.call(ch)
            expect(code[x - max_x, y]).to match_array(expected)
            expect(code[x, y - code.height]).to match_array(expected)
            expect(code[x - max_x, y - code.height]).to match_array(expected)
          end
        end
      end

      it 'returns an empty array if there is no item at given position' do
        expect(code[0, code.height]).to match_array([])
        expect(code[code.width, 0]).to match_array([])
        expect(code[code.width, code.height]).to match_array([])
      end
    end
  end

  describe Raheui::Code, 'with empty code' do
    let(:code_str) { '' }
    it_behaves_like 'a code'
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
      stub_const('INITIAL_CONSONANTS', Raheui::Code::INITIAL_CONSONANTS)
      stub_const('MEDIAL_CONSONANTS', Raheui::Code::MEDIAL_CONSONANTS)
      stub_const('FINAL_CONSONANTS', Raheui::Code::FINAL_CONSONANTS)
    end

    it 'returns consonants of Korean alphabet' do
      examples = [
        # 가
        [0, 0, 0],
        # 힣
        [INITIAL_CONSONANTS - 1, MEDIAL_CONSONANTS - 1, FINAL_CONSONANTS - 1]
      ]
      examples.concat(10.times.map do
        [rand(INITIAL_CONSONANTS),
         rand(MEDIAL_CONSONANTS),
         rand(FINAL_CONSONANTS)]
      end.uniq)
      examples.each do |initial, medial, final|
        alphabet = (
          0xAC00 +
            initial * MEDIAL_CONSONANTS * FINAL_CONSONANTS +
            medial * FINAL_CONSONANTS +
            final
        ).chr(Encoding::UTF_8)
        expect(consonants.call(alphabet))
          .to match_array([initial, medial, final])
      end
    end

    it 'returns an empty array for non-Korean alphabet' do
      examples = [
        *0..127,
        0xAC00 + INITIAL_CONSONANTS * MEDIAL_CONSONANTS * FINAL_CONSONANTS
      ]
      examples.concat(%w(あ 漢 　 å ★).map(&:ord))
      examples.each do |ch|
        expect(consonants.call(ch)).to match_array([])
      end
    end
  end
end
