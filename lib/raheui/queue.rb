# encoding: utf-8
module Raheui
  # Queue class for Aheui.
  class Queue < Store
    extend Forwardable

    # Delegates push to @store.
    def_delegator :@store, :push

    # Dequeue from the Queue.
    def pop
      @store.shift
    end
  end
end
