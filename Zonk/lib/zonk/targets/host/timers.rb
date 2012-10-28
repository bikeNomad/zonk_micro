module Zonk
  class StopTimerException < Exception
  end

  # retriggerable one-shot Timer
  class Timer
    # optional _block is called upon a timeout
    def initialize(_name, _period, &_block)
      @name = _name
      @period = _period
      @expires = nil
      @thread = nil
      @timed_out = false
      @block = _block
      @repeats = false
    end
    attr_reader :name, :period, :expires, :timed_out, :repeats

    # start or restart my timing.
    # I will timeout in @period seconds.
    def trigger
      @timed_out = false
      @expires = Time.now + @period
      unless @thread
        @thread = Thread.new do
          begin
            begin
              sleepytime = @expires - Time.now
              while sleepytime > 0.0
                sleep(sleepytime)
                sleepytime = @expires - Time.now
              end
              @timed_out = true
              @expires += @period if @repeats
              @block.call if @block
            end while @repeats
          rescue StopTimerException
            @expires=nil
          ensure
            @thread = nil
          end
        end
      end
    end

    def timeout_after(_period)
      @expires = Time.now + _period
      @period = _period
      trigger
    end

    def reset
      if @thread
        @thread.raise(StopTimerException.new)
      end
    end

  end

  # Timer that repeats
  class Ticker < Timer
    def initialize(_name, _period, &_block)
      super
      @repeats = true
    end

    def start
      trigger
    end

    def stop
      reset
    end

  end
end
