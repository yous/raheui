# encoding: utf-8

require 'optparse'

module Raheui
  # Handle command line options.
  class Option
    # Initialize a Option.
    def initialize
      @options = {}
    end

    # Parse the passed arguments to a Hash.
    #
    # args - An Array of Strings containing options.
    #
    # Returns an Array consists of a Hash options and an Array of String
    #   remaining arguments.
    def parse(args)
      OptionParser.new do |opts|
        opts.banner = 'Usage: raheui [options] [file]'

        add_options(opts)
      end.parse!(args)
      [@options, args]
    end

    private

    # Add command line options to OptionParser.
    #
    # opts - An OptionParser object to add options.
    #
    # Returns nothing.
    def add_options(opts)
      opts.on('-h', '--help', 'Print this message.') do
        puts opts
        exit 0
      end

      opts.on('-v', '--version', 'Print version.') do
        puts Version::STRING
        exit 0
      end
    end
  end
end
