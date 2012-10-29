module Zonk
  # A Rule is an object that has an EventPattern,
  # an optional Condition, and a collection of Actions.
  class Rule
    protected

    # :section: Compilation

    def make_conditions(arr)
      arr.flatten.each_slice(2).collect do |rcvr,sel|
        Condition.new(rcvr, sel.to_sym)
      end
    end

    # target must define
    # initialize_target

    def initialize(_src, _kind, _conds, _actions = [])
      @pattern = EventPattern.new(_src, _kind)
      @condition = CompositeCondition.new(*make_conditions(_conds))
      @actions = _actions
      initialize_target
    end

    public

    attr_reader :pattern, :actions, :condition

    def add_action(*args)
      pp [self, :add_action, *args]
      @actions << args
    end

  end

end
