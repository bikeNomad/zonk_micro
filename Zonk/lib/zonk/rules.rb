module Zonk
  # A Rule is an object that has an EventPattern,
  # an optional Condition, and a collection of Actions.
  class Rule
    def make_conditions(arr)
      arr.flatten.each_slice(2).collect do |rcvr,sel|
        Condition.new(rcvr, sel.to_sym)
      end
    end

    def initialize(_src, _kind, *_conds, &block)
      @pattern = EventPattern.new(_src, _kind)
      @actions = block
      @condition = CompositeCondition.new(*make_conditions(_conds))
    end

    attr_reader :pattern, :actions, :condition

    # TODO combine match_event and do_actions_for?

    # Return true if Event 'evt' matches my event pattern
    # and my condition (which is possibly empty) is not false
    def match_event(evt)
      @pattern.match_event(evt) && @condition.value
    end

    def do_actions_for(evt)
      @actions.call(evt)
    end
  end

end
