module Zonk
  # A Rule is a Singleton that has an Event pattern,
  # an optional Condition, and a collection of Actions.
  class Rule < Base
    def initialize
      super
      @rules = []
    end

    attr_reader :rules

    def enter_table
    end

    def exit_table
    end

  end
end
