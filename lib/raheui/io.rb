# encoding: utf-8
module Raheui
  # IO methods for user input and output.
  module IO
    # Read an Integer from user input.
    #
    # Returns the Integer user entered.
    def self.read_int
      $stdin.gets.to_i
    end

    # Read an character from user input.
    #
    # Returns the Integer character code of the character user entered.
    def self.read_chr
      $stdin.getc.ord
    end

    # Print an Integer.
    #
    # value - The Integer to print.
    #
    # Examples
    #
    #   IO.print_int(42)
    #   # 42=> nil
    #
    # Returns nothing.
    def self.print_int(value)
      $stdout.print value
    end

    # Print an character from character code.
    #
    # value - The Integer character code to print.
    #
    # Examples
    #
    #   IO.print_chr(97)
    #   # a=> nil
    #
    #   IO.print_chr(0xAC00)
    #   # 가=> nil
    #
    #   # Rescue RangeError
    #   IO.print_chr(-1)
    #   # [U+..FF]=> nil
    #
    #   # Rescue RangeError
    #   IO.print_chr(0x110000)
    #   # [U+110000]=> nil
    #
    # Returns nothing.
    def self.print_chr(value)
      $stdout.print value.chr(Encoding::UTF_8)
    rescue RangeError
      $stdout.print format('[U+%04X]', value)
    end
  end
end
