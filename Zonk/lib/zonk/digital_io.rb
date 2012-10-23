require 'zonk/io'

module Zonk
  class DigitalInput < Input
    def value_range
      [ false, true ]
    end
  end

  class DigitalOutput < Output
    def value_range
      [ false, true ]
    end
  end

end
