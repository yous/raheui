# encoding: utf-8
module Raheui
  # Stack class for Aheui.
  class Stack < Store
    extend Forwardable

    # Delegates push, pop to @store.
    delegate [:push, :pop] => :@store
  end
end
