module Zonk
  # A CompositeCondition is an AND-combination of Conditions.
  # An empty CompositeCondition will evaluate as true.
  class CompositeCondition
    def initialize(*conds)
      @conditions = conds
      self
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
      self
    end

    alias :and :&

    # convert to bool
    def value
      @conditions.all? do |cond|
        begin
          cond.value
        rescue
          false
        end
      end
    end

    # compare with bool
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
        @method.call == true
      rescue
        # $stderr.puts("Exception #{$!} evaluating #{@method} receiver #{@method.receiver}")
        false
      end
    end

    def ===(bool)
      value == bool
    end

    def &(other)
      return CompositeCondition.new(self) & other
    end

    # NOTE that you can't just go
    # c1 and c2
    # and expect it to work!
    alias :and :&
  end
end
