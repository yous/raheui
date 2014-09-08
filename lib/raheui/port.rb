# encoding: utf-8

module Raheui
  # Port class for Aheui.
  class Port < Store
    # Do nothing with push.
    def push(*_args); end

    # Do nothing with pop.
    def pop; end

    # Do nothing with swap.
    def swap; end
  end
end
