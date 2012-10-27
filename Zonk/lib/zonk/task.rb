module Zonk # :nodoc:

  # Each Zonk Application has at least one Task.
  # A Task is a Singleton class/instance that owns TaskPorts and at
  # least one Table.
  class Task < Base
    include Zonk
    # Return a list of ports with all of the given capabilities
    def ports_with_capabilities(*capabilities)
      ncapabilities = capabilities.size
      @ports.values.select { |port| (port.capabilities & capabilities).size == ncapabilities }
    end

    # Enqueue the given event for later processing
    def add_event(evt)
      @events << evt
      evt
    end

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
          switch_to_table(@tables.first)
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

    def initialize
      super
      # Hash of ports
      # portname => TaskPort
      @ports = {}
      # Queue of incoming events
      @events = Queue.new
      @messages = Queue.new
      # My tables
      @tables = []
      # Which table is current
      @current_table = nil
      @thread = nil
      @running = false
    end

    alias :application :owner

    attr_reader :ports, :events, :tables, :current_table, :running, :thread, :messages

    # Return all of my ports that are output-capable.
    def outputs
      ports_with_capabilities(:output)
    end

    # Return all of my ports that are input-capable.
    def inputs
      ports_with_capabilities(:input)
    end

    # Return all of my ports that are timer-capable.
    def timers
      ports_with_capabilities(:timer)
    end

    # Return all of the event patterns from my current table
    def event_patterns
      return [] if current_table.nil?
      current_table.event_patterns
    end

    # Change the current table to 'table'.
    def switch_to_table(table)
      current_table.exit_table unless current_table.nil?
      @current_table = table
      current_table.enter_table
    end

    # Add the given port
    def add_port(port)
      @ports[port.name] = port
      port
    end

    # Add the given table
    def add_table(table)
      @tables << table
      table
    end

    # Return my port with the given _name, or nil
    def port_named(_name)
      @ports[_name]
    end

    # Alias for easier typing
    alias :port :port_named

    # Returns a singleton instance of subclass of Table
    def define_table(_name, base = Table, *extensions, &block)
      new_table = make_singleton_of(_name, base, extensions)
      add_table(new_table)
      the_task = self
      new_table.instance_eval { @owner = the_task }
      new_table.instance_eval(&block)
      new_table
    end

    # Add a DigitalInputPort with the given _name
    def add_digital_input_port(_name)
      add_port(DigitalInputPort.new(_name))
    end

    # Add a DigitalOutputPort with the given _name
    def add_digital_output_port(_name)
      add_port(DigitalOutputPort.new(_name))
    end

  end

end
