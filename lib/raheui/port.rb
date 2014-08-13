# encoding: utf-8
module Raheui
  # Port class for Aheui.
  class Port < Store
    # Do nothing with push.
    def push(*_args); end

    # Do nothing with pop.
    def pop; end
  end
end
