# encoding: utf-8

require 'forwardable'

module Raheui
  # Base Store class for Aheui. Every child classes should implement push, pop
  # and swap method.
  class Store
    extend Forwardable

    BASE_METHODS = [:push, :pop, :swap]
    private_constant :BASE_METHODS

    # Delegates size to @store.
    def_delegator :@store, :size

    # Initialize a Stack.
    def initialize
      check_base_methods
      @store = []
    end

    # Push the last element to Store.
    def push_dup
      push(@store.last) if size > 0
    end

    private

    # Check whether base methods are implemented.
    #
    # Returns nothing.
    # Raises NotImplementedError if base methods are not implemented.
    def check_base_methods
      errors = []
      BASE_METHODS.each do |method|
        errors << method unless respond_to?(method)
      end
      return if errors.empty?
      fail NotImplementedError, 'base methods are not implemented:' \
                                " #{errors.join(', ')}"
    end
  end
end
