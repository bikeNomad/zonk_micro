require 'zonk/io_ports'

module Zonk
  class DigitalInputPort < InputPort
    def value_range
      [ false, true ]
    end

    # Return true if my value is true
    def on?
      value == true
    end

    alias :is_on :on?

    def off?
      value == false
    end

    alias :is_off :off?

  end

  class DigitalOutputPort < OutputPort
    def value_range
      [ false, true ]
    end

    # Return true if my value is true
    def on?
      value == true
    end

    alias :is_on :on?

    def off?
      value == false
    end

    alias :is_off :off?

  end

end
