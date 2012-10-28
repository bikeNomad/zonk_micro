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

    def initialize
      super
      # Hash of ports
      # portname => TaskPort
      @ports = {}
      # My table definitions
      @tables = []
      # My timer definitions
      @timers = []
    end

    # :section: Structure Queries
    # These methods answer construction-time queries

    alias :application :owner

    attr_reader :ports, :tables, :timers

    # Return all of my ports that are output-capable.
    def outputs
      ports_with_capabilities(:output)
    end

    # Return all of my ports that are input-capable.
    def inputs
      ports_with_capabilities(:input)
    end

    # Return all of the event patterns from my current table
    def event_patterns
      return [] if current_table.nil?
      current_table.event_patterns
    end

    # Return my port with the given _name, or nil
    def port_named(_name)
      @ports[_name]
    end

    # Alias for easier typing
    alias :port :port_named

    # :section: Task Definition
    # These methods build the structures that define a Task

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

    # Add a Ticker
    def add_ticker(_name, _period)
      t = Ticker.new(_name, _period)
      @timers << t
      t
    end

    # Add a Timer
    def add_timer(_name, _period)
      t = Timer.new(_name, _period)
      @timers << t
      t
    end

  end

end
