require 'zonk'
require 'thread'

module Zonk # :nodoc:
  class Task < Base
    # :section: Runtime Support
    # These methods are used at runtime, and run on the host (PC) side

    # Add target-specific initialization
    def initialize_target
      super
      # Queue of incoming events
      @events = Queue.new
      @messages = Queue.new
      # Which table is current
      @current_table = nil
      @thread = nil
      @running = false
    end

    attr_reader :events, :current_table, :running, :thread, :messages

    # Enqueue the given event for later processing
    def add_event(evt)
      @events << evt
      evt
    end

    # Change the current table to 'table'.
    def switch_to_table(table)
      current_table.exit_table unless current_table.nil?
      @current_table = table
      current_table.enter_table
    end

    # enqueue a message
    def message(*args)
      msg = sprintf(*args)
      @messages << msg
      msg
    end

    # Process each event off my queue
    def run!
      raise "already running" if @running || @thread
      raise "no tables" if @tables.empty?
      @thread = Thread.new do
        begin
          message("Task #{name} thread started")
          switch_to_table(tables.first)
          @running = true
          while @running do
            evt = @events.pop
            begin
              current_table.process_event(evt)
            rescue => exc
              # TODO wrap this into an Event
              add_event(exc)
              message("Task #{name} thread exception: #{exc.message}")
              break
            end
            Thread.pass
          end
        ensure
          @running = false
          @thread = nil
        end
        message("Task #{name} thread ended")
      end
    end

    # Ask my thread to terminate
    def terminate!
      return unless @running && @thread
      message("#{name}: asking #{@thread} to die")
      @running = false
    end

  end

end
