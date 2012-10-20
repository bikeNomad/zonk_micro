# I/O base classes
module Zonk
  class Input
    include Zonk

  protected
    def real_value
      subclass_responsibility
    end

    attr_reader :last_value

  public
    def initialize
      @override = nil
      @last_value = nil
    end

    def value
      @last_value = (overridden? ? @override : real_value)
    end

    # val_or_nil: nil: no override
    # non-nil: new value
    def override(val_or_nil)
      @override = val_or_nil
    end

    def overridden?
      !@override.nil?
    end
  end

  class Output < Input
  protected
    # set actual output
    def real_value=(val)
      subclass_responsibility
    end

  public
    def value=(val)
      if overridden? 
        @override = val
      else
        self.real_value=(val)
      end
      @last_value = val
    end

    def override(val_or_nil)
      return if @override == val_or_nil
      super
      if val_or_nil.nil?  # no longer overridden
        self.real_value = @last_value
      end
    end

  end
end
