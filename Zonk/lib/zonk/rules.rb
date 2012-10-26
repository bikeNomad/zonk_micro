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

    alias :table :owner

    def task
      table.owner
    end

    def on_event(_source, _kind)
      @event_pattern = EventPattern.new(_source, _kind)
    end

    def if_condition(cond)
      @condition = cond
    end

  end
end
