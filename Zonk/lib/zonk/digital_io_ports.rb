require 'zonk/io_ports'

module Zonk
  class DigitalInputPort < InputPort
    def value_range
      [ false, true ]
    end
  end

  class DigitalOutputPort < OutputPort
    def value_range
      [ false, true ]
    end
  end

end
