# encoding: utf-8
module Raheui
  # Stack class for Aheui.
  class Stack < Store
    # Delegates push, pop to @store.
    delegate [:push, :pop] => :@store

    # Swap the last two elements of Stack.
    def swap
      @store[-1], @store[-2] = @store[-2], @store[-1] if size > 1
    end
  end
end
