module Zonk
  # A Rule is an object that has an EventPattern,
  # an optional Condition, and a collection of Actions.
  class Rule < Base
    protected
    # :section: Compilation

    def make_conditions(arr)
      arr.flatten.each_slice(2).collect do |rcvr,sel|
        Condition.new(port(rcvr), sel.to_sym)
      end
    end

    def port(s)
      (String === s) ? task.port_named(s) : s
    end

    # target must define
    # initialize_target
    public

    def initialize(_name = nil, _owner = nil)
      super
      @pattern = nil
      @condition = CompositeCondition.new
      @actions = []
    end

    def owner=(_owner)
      super
      _owner.add_rule(self)
    end

    def set_event(_src, _kind)
      @pattern = EventPattern.new(port(_src), _kind)
    end

    def set_conditions(*_conds)
      @condition = CompositeCondition.new(*make_conditions(_conds))
    end

    attr_reader :pattern, :actions, :condition
    alias :table :owner

    # save my actions list
    def add_actions(*args)
      @actions << args
    end

    def task
      table.task
    end

  end
end
