module Zonk
  # A CompositeCondition is an AND-combination of Conditions.
  class CompositeCondition
    def initialize(*conds)
      @conditions = conds
    end

    attr_reader :conditions

    # Add another
    def &(cond)
      case cond
      when Condition
        @conditions << cond
      when CompositeCondition
        @conditions.concat(cond.conditions)
      when false
        # TODO diagnose this?
        @conditions << false
      when true
        # nothing to do
      else
        raise "can't happen"
      end
    end

    alias :and :&

    # convert to bool
    def value
      @conditions.all? { |cond| cond.value }
    end

    def ===(bool)
      value == bool
    end
  end

  # A Condition represents a single testable condition.
  # Conditions can be composed using logical operators.
  class Condition
    def initialize(rcvr, sym)
      @method = rcvr.method(sym)
    end

    def value
      begin
        @method.call
      rescue
        $stderr.puts("Exception #{$!} evaluating #{@method} receiver #{@method.receiver}")
        false
      end
    end

    def ===(bool)
    end

    def &(other)
    end

    alias :and :&
  end
end
