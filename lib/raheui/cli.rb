# encoding: utf-8
module Raheui
  # Handle command line interfaces logic.
  class CLI
    # Initialize a CLI.
    def initialize
      @options = {}
    end

    # Entry point for the applicaiton logic. Process command line arguments and
    # run the Aheui code.
    #
    # args - An Array of Strings user passed.
    #
    # Returns an Integer UNIX exit code.
    def run(args = ARGV)
      @options, paths = Option.new.parse(args)
      source = if paths.empty?
                 $stdin.read
               else
                 File.read(paths[0])
               end
      runner = Runner.new(Code.new(source))
      runner.run
    end
  end
end
