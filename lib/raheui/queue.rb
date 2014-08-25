# encoding: utf-8
module Raheui
  # Queue class for Aheui.
  class Queue < Store
    # Delegates push to @store.
    def_delegator :@store, :push

    # Dequeue from the Queue.
    def pop
      @store.shift
    end

    # Swap the first two elements of Queue.
    def swap
      @store[0], @store[1] = @store[1], @store[0] if size > 1
    end
  end
end
