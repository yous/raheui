# encoding: utf-8

module Raheui
  # Run Aheui code.
  class Runner
    # Point class for execution cursor position and delta of it.
    Point = Struct.new(:x, :y)

    # Numbers of required elements for each command.
    REQUIRED_STORE_SIZE = [
      0, 0, 2, 2, 2, 2, 1, 0, 1, 0, # ㄱ ㄲ ㄴ ㄷ ㄸ ㄹ ㅁ ㅂ ㅃ ㅅ
      1, 0, 2, 0, 1, 0, 2, 2, 0     # ㅆ ㅇ ㅈ ㅉ ㅊ ㅋ ㅌ ㅍ ㅎ
    ]

    # Delta values of each medial consonant.
    MEDIAL_DELTAS = [
      [1, 0], nil, [2, 0], nil,        # ㅏ ㅐ ㅑ ㅒ
      [-1, 0], nil, [-2, 0], nil,      # ㅓ ㅔ ㅕ ㅖ
      [0, -1], nil, nil, nil, [0, -2], # ㅗ ㅘ ㅙ ㅚ ㅛ
      [0, 1], nil, nil, nil, [0, 2],   # ㅜ ㅝ ㅞ ㅟ ㅠ
      [:+, :-], [:-, :-], [:-, :+]     # ㅡ ㅢ ㅣ
    ]

    # Numbers of strokes of each final consonant.
    FINAL_STROKES = [
      0,                            # No final consonant.
      2, 4, 4, 2, 5, 5, 3, 5, 7, 9, # ㄱ ㄲ ㄳ ㄴ ㄵ ㄶ ㄷ ㄹ ㄺ ㄻ
      9, 7, 9, 9, 8, 4, 4, 6, 2, 4, # ㄼ ㄽ ㄾ ㄿ ㅀ ㅁ ㅂ ㅄ ㅅ ㅆ
      1, 3, 4, 3, 4, 4, 3           # ㅇ ㅈ ㅊ ㅋ ㅌ ㅍ ㅎ
    ]

    private_constant :REQUIRED_STORE_SIZE, :MEDIAL_DELTAS, :FINAL_STROKES

    # Initialize a Runner. Get a Code instance and initialize Stores.
    #
    # code - The Code instance to execute.
    def initialize(code)
      @code = code
    end

    # Run the Aheui Code.
    #
    # Returns the Integer exit code.
    def run
      reset
      step until @finished
      @selected_store.pop || 0
    end

    private

    # Reset cursor and Stores. Select first Store.
    #
    # Returns nothing.
    def reset
      @cursor = Point.new(0, 0)
      @delta = Point.new(0, 1)
      @stores = Code::FINAL_CONSONANTS.times.map do |consonant|
        case consonant
        when 21 then Queue.new # ㅇ
        when 27 then Port.new  # ㅎ
        else         Stack.new
        end
      end
      @selected_store = @stores[0]
      @finished = false
    end

    # Process current character which cursor points to and move cursor.
    #
    # Returns nothing.
    def step
      consonants = @code[@cursor.x, @cursor.y]
      unless consonants.empty?
        initial, medial, final = consonants
        @delta.x, @delta.y = delta(medial)
        if @selected_store.size < REQUIRED_STORE_SIZE[initial]
          @delta.x, @delta.y = -@delta.x, -@delta.y
        else
          process(initial, final)
        end
      end
      move
    end

    # Process a Korean alphabet.
    #
    # initial - An Integer index of initial consonant of the Korean alphabet.
    # final   - An Integer index of final consonant of the Korean alphabet.
    #
    # Returns nothing.
    def process(initial, final)
      case initial
      when 2 # ㄴ
        operate(:/)
      when 3 # ㄷ
        operate(:+)
      when 4 # ㄸ
        operate(:*)
      when 5 # ㄹ
        operate(:%)
      when 6 # ㅁ
        op = @selected_store.pop
        if final == 21 # ㅇ
          IO.print_int(op)
        elsif final == 27 # ㅎ
          IO.print_chr(op)
        end
      when 7 # ㅂ
        op = if final == 21 # ㅇ
               IO.read_int
             elsif final == 27 # ㅎ
               IO.read_chr
             else
               FINAL_STROKES[final]
             end
        @selected_store.push(op)
      when 8 # ㅃ
        @selected_store.push_dup
      when 9 # ㅅ
        @selected_store = @stores[final]
      when 10 # ㅆ
        op = @selected_store.pop
        @stores[final].push(op)
      when 12 # ㅈ
        op1 = @selected_store.pop
        op2 = @selected_store.pop
        @selected_store.push(op2 >= op1 ? 1 : 0)
      when 14 # ㅊ
        op = @selected_store.pop
        @delta.x, @delta.y = -@delta.x, -@delta.y if op == 0
      when 16 # ㅌ
        operate(:-)
      when 17 # ㅍ
        @selected_store.swap
      when 18 # ㅎ
        @finished = true
      end
    end

    # Helper method for basic operators. +, -, *, / and % can be processed.
    #
    # method - A Symbol method to execute.
    #
    # Examples
    #
    #   operate(:+)
    #
    #   operate(:-)
    #
    #   operate(:*)
    #
    #   operate(:/)
    #
    #   operate(:%)
    #
    # Returns nothing.
    def operate(method)
      op1 = @selected_store.pop
      op2 = @selected_store.pop
      @selected_store.push([op2, op1].reduce(method))
    end

    # Get delta x and y position for next move.
    #
    # medial - An Integer index of medial consonant of the Korean alphabet.
    #
    # Examples
    #
    #   delta(0)
    #   # => [1, 0]
    #
    # Returns an Array of Integer delta x and y position.
    def delta(medial)
      delta = MEDIAL_DELTAS[medial]
      if delta
        x, y = delta
        x = x == :+ ? @delta.x : -@delta.x if x.is_a?(Symbol)
        y = y == :+ ? @delta.y : -@delta.y if y.is_a?(Symbol)
        [x, y]
      else
        [@delta.x, @delta.y]
      end
    end

    # Move cursor to proper position. Wrap the position if it goes to outside of
    # the code.
    #
    # Returns nothing.
    def move
      @cursor.x = wrap(@cursor.x + @delta.x, @code.width)
      @cursor.y = wrap(@cursor.y + @delta.y, @code.height)
    end

    # Wrap a number to be between 0 and max value excluding max value. If the
    # number is negative, it goes to max - 1. If the number is bigger than or
    # equal to max value, it goes to zero.
    #
    # num - An Integer to be wrapped.
    # max - An Integer max value.
    #
    # Returns an Integer between 0 and max - 1.
    def wrap(num, max)
      if num < 0
        max - 1
      elsif num >= max
        0
      else
        num
      end
    end
  end
end
