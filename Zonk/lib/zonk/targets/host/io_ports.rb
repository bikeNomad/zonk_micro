module Zonk # :nodoc:
  # :section: Runtime Support (Host-Side Common)

  class InputPort
    protected

    def check_override_value(val)
      return nil if val.nil?
      check_range(val, value_range, "#{name}: override")
    end

    def initialize_target
      super
      @override = nil
      @last_value = nil
    end

    attr_reader :last_value

    def check_value(val)
      check_range(val, value_range, name)
    end

    public

    def value
      @last_value = (overridden? ? @override : real_value)
    end

    # val_or_nil: nil: no override
    # non-nil: new value
    def override(val_or_nil)
      @override = check_override_value(val_or_nil)
    end

    def overridden?
      !@override.nil?
    end

  end

  class OutputPort
    protected

    def initialize_target
      super
    end

    public

    def value=(val)
      if overridden? 
        @override = check_override_value(val) 
      else
        self.real_value=(check_value(val))
      end
      @last_value = val
    end

    # Lie about output value without setting output
    def override(val_or_nil)
      return if @override == val_or_nil
      super
      if val_or_nil.nil?  # no longer overridden
        self.real_value = @last_value
      end
    end
  end

end

