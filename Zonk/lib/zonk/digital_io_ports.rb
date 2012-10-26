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

    def off?
      value == false
    end

  end

  class DigitalOutputPort < OutputPort
    def value_range
      [ false, true ]
    end

    # Return true if my value is true
    def on?
      value == true
    end

    def off?
      value == false
    end

  end

end
