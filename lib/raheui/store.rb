# encoding: utf-8
module Raheui
  # Base Store class for Aheui. Every child classes should implement push and
  # pop method.
  class Store
    BASE_METHODS = [:push, :pop]
    private_constant :BASE_METHODS

    # Initialize a Stack.
    def initialize
      check_base_methods
      @store = []
    end

    # Push the last element to Store.
    def push_dup
      push(@store.last) if @store.size > 0
    end

    # Swap the last two elements of Store.
    def swap
      @store[-1], @store[-2] = @store[-2], @store[-1] if @store.size > 1
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
