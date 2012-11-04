module Zonk
  class Timer < TaskPort
    def initialize(_name = nil, _owner = nil)
      super
      @period = nil
      @repeats = false
    end

    attr_reader :period, :repeats

    def set_period(_period)
      @period = _period
    end
  end

  class Ticker < Timer
    def initialize(_name = nil, _owner = nil)
      super
      @repeats = true
    end
  end
end
