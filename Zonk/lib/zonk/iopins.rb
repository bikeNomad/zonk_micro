module Zonk

  class Pin
    include Zonk

    def initialize(_name, _target)
      @name = _name
      @target = nil
    end

    attr_reader :name, :target

    def capabilities
      subclass_responsibility
    end
  end

  class InputPin < Pin
  end

  class OutputPin < Pin
  end

end
