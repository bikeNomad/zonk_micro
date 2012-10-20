# I/O base classes
module Zonk
  class Input
    include Zonk

  protected
    def real_value
      subclass_responsibility
    end

  public
    def initialize
      @override = nil
      @last_value = nil
    end

    def value
      overridden? ? @override : real_value
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
      unless overridden? 
        real_value=(val)
      else
        @override = val
      end
    end

    def override(val_or_nil)
      return if @override == val_or_nil
      if val_or_nil.nil?
        real_value = @last_value
      else
        @last_value = real_value
      end
    end

  end
end
