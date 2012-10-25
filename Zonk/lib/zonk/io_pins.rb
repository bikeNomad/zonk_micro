module Zonk

  class Pin
    include Zonk

    def initialize(_name, _target)
      @name = _name
      @target = _target
    end

    attr_reader :name, :target

    def capabilities
      subclass_responsibility
    end
  end

  class InputPin < Pin
    def capabilities
      [ :input ]
    end
  end

  class OutputPin < InputPin
    def capabilities
      [ :output, :input ]
    end
  end

end
