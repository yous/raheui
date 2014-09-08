# encoding: utf-8

module Raheui
  # Store code object.
  class Code
    extend Forwardable

    # Count of initial, medial and final consonant of Korean alphabet.
    INITIAL_CONSONANTS = 19
    MEDIAL_CONSONANTS = 21
    FINAL_CONSONANTS = 28

    # Returns the Integer width of code.
    attr_reader :width

    # Returns the Integer height of code.
    attr_reader :height

    # Initialize a Code. Separate Korean alphabet into consonants. Calculate the
    # width and height of code.
    #
    # str - The String raw text of code.
    #
    # Examples
    #
    #   Code.new('아희')
    #
    #   Code.new(
    #     <<-CODE
    #   밤밣따빠밣밟따뿌
    #   빠맣파빨받밤뚜뭏
    #   돋밬탕빠맣붏두붇
    #   볻뫃박발뚷투뭏붖
    #   뫃도뫃희멓뭏뭏붘
    #   뫃봌토범더벌뿌뚜
    #   뽑뽀멓멓더벓뻐뚠
    #   뽀덩벐멓뻐덕더벅
    #     CODE
    #   )
    def initialize(str)
      @matrix = str.lines.map do |line|
        line.chomp.chars.map { |ch| consonants(ch) }
      end
      @height = @matrix.size
      if @height.zero?
        @width = 1
        @height = 1
      else
        @width = @matrix.map(&:size).max
      end
    end

    # Get consonants of the given position.
    #
    # x - The Integer position of x coordinate.
    # y - The Integer position of y coordinate.
    #
    # Examples
    #
    #   code = Code.new('아희')
    #   code[0, 0]
    #   # => [11, 0, 0]
    #   code[1, 0]
    #   # => [18, 19, 0]
    #   code[0, 1]
    #   # => []
    #   code[1, 1]
    #   # => []
    #
    # Returns an Array consists of consonants or an empty Array when there is no
    #   element in the position.
    def [](x, y)
      @matrix.fetch(y, []).fetch(x, [])
    end

    private

    # Separate Korean alphabet into consonants.
    #
    # ch - The String character to separate.
    #
    # Examples
    #
    #   consonants('가')
    #   # => [0, 0, 0]
    #
    #   consonants('힣')
    #   # => [18, 20, 27]
    #
    #   consonants('a')
    #   # => []
    #
    # Returns an Array of index of consonants or empty Array if the character is
    #   not an Korean alphabet.
    def consonants(ch)
      case ch.ord
      when 44_032..55_203 # '가'..'힣'
        index = ch.ord - 44_032 # 가
        [index / (MEDIAL_CONSONANTS * FINAL_CONSONANTS),
         (index / FINAL_CONSONANTS) % MEDIAL_CONSONANTS,
         index % FINAL_CONSONANTS]
      else
        []
      end
    end
  end
end
