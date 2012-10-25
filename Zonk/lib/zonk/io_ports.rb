# :title: I/O base classes

require_relative 'task'
require_relative 'ports'

module Zonk # :nodoc:

  class InputPort < TaskPort
  protected
    def real_value
      subclass_responsibility
    end

    def value_range
      subclass_responsibility
    end

    def check_value(val)
      if value_range.include?(val)
        val
      else
        out_of_range(val, value_range, name)
      end
    end

    def check_override_value(val)
      return nil if val.nil?
      return val if value_range.include?(val)
      out_of_range(val, value_range, name + ": override")
    end

    attr_reader :last_value

  public
    def capabilities
      [ :input ]
    end

    def initialize(_name = '')
      super
      @override = nil
      @last_value = nil
    end

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

  class OutputPort < InputPort
  protected
    # set actual output
    def real_value=(val)
      subclass_responsibility
    end

  public
    def capabilities
      [ :output, :input ]
    end

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
