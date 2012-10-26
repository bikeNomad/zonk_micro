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

    def match_event(evt)
      @pattern === evt
    end

    def do_actions_for(evt)
      @actions.call(evt)
    end
  end

end
