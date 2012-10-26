module Zonk
  # A Rule is a Singleton that has an EventPattern,
  # an optional Condition, and a collection of Actions.
  class Rule < Base
    def initialize
      super
      @event_pattern = nil
      @condition = nil
      @actions = []
    end

    attr_reader :event_pattern, :condition, :actions
  end
end
