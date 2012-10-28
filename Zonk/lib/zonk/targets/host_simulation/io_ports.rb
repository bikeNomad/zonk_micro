module Zonk # :nodoc:
  # :section: Runtime Support (Host-Side Simulation)
  # These methods allow code running on the host to operate on simulated
  # hardware.

  class DigitalInputPort < InputPort
    protected
    def real_value
      @override
    end

    def initialize_target
      super
      @last_value = false
      @override = false
    end
  end

  class DigitalOutputPort < OutputPort
    protected
    # set actual output
    def real_value=(val)
      @override = val
    end

    def initialize_target
      super
      @last_value = false
      @override = false
    end
  end
end
