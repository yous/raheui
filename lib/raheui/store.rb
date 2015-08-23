# encoding: utf-8

require 'forwardable'

module Raheui
  # Base Store class for Aheui. Every child classes should implement push, pop
  # and swap method.
  class Store
    extend Forwardable

    # Delegates size to @store.
    def_delegator :@store, :size

    # Initialize a Stack.
    def initialize
      @store = []
    end

    # Base method push.
    #
    # Raises NotImplementedError.
    def push
      fail NotImplementedError, '#push is not implemented'
    end

    # Base method pop.
    #
    # Raises NotImplementedError.
    def pop
      fail NotImplementedError, '#pop is not implemented'
    end

    # Base method push_dup.
    #
    # Raises NotImplementedError.
    def push_dup
      fail NotImplementedError, '#push_dup is not implemented'
    end

    # Base method swap.
    #
    # Raises NotImplementedError.
    def swap
      fail NotImplementedError, '#swap is not implemented'
    end
  end
end
