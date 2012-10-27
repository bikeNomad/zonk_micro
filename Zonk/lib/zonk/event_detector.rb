module Zonk
  # The EventDetector is used by Tasks to monitor their Event sources
  # (TaskPorts and Timers) for specific events of interest
  class EventDetector
    def initialize
      # tasks that I need to look at
      @tasks = []
      # task subscriptions by source/selector
      # [source,selector(s)] => [task1, task2, ...]
      @subscribers = Hash.new { |h,k| h[k] = [] }
      @thread = nil
      @running = false
      # My scan period in seconds
      @scan_period = 0.01
    end

    attr_reader :running, :subscribers, :tasks, :scan_period

    # add the given task to my list
    def add_task(_task)
      raise "too late to add task" if running
      tasks << _task
    end

    # delete inactive tasks; ask all active tasks
    # for their event patterns
    def update_subscribers
      tasks.reject! { |task| !task.running }
      subscribers.clear
      tasks.each do |task|
        task.event_patterns.each do |pat|
          subscribers[pat.to_a] << task
        end
      end
    end

    # Returns single Symbol for kind detected, or nil
    def detect_pattern(src, kind)
      retval = 
      case kind
      when Symbol
        src.method(kind).call
      when Proc
        src.instance_eval(kind)
      when Method
        src.call
      else
        raise "don't know how to detect pattern #{src.inspect} / #{kind.inspect}"
      end
      retval ? kind : nil
    end

    # Returns single Symbol for kind detected, or nil
    def detect_first_pattern(src, kinds)
      if kinds.respond_to?(:detect)
        kinds.detect { |kind| detect_pattern(src, kind) }
      else
        detect_pattern(src, kinds)
      end
    end

    # run myself as an independent thread
    def run!
      raise "already running" if running || @thread
      @thread = Thread.new do
        begin
          @running = true
          next_scan = Time.now + @scan_period
          while running do
            # wait for next poll
            sleepytime = next_scan-Time.now
            sleep(sleepytime) if sleepytime > 0.0
            this_scan = Time.now
            next_scan = this_scan + @scan_period
            # do poll
            update_subscribers
            subscribers.each_pair do |pattern,tasks|
              src, kinds = *pattern
              kind = nil
              if (kind = detect_first_pattern(src, kinds))
                evt = Event.new(src, kind, this_scan)
                tasks.each { |task| task.add_event(evt) }
              end
            end
          end
        rescue => exc
          $stderr.puts "#{self.inspect}: exception #{exc.message}"
        ensure
          @running = false
          @thread = nil
        end
      end
    end
  end
end
