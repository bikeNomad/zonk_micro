module Zonk # :nodoc:

  # Each Zonk Application has at least one Task.
  # A Task is a Singleton class/instance that owns TaskPorts and at
  # least one Table.
  class Task < Base
    include Zonk
    # :section: Compilation and Introspection

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
      @tables = {}
      # My timer definitions
      # name => Timer/Ticker
      @timers = {}
    end

    # :section: Structure Queries
    # These methods answer construction-time queries

    alias :application :owner

    def tables
      @tables.values
    end

    def table_names
      @tables.keys
    end

    def timer_names
      @timers.keys
    end

    def timers
      @timers.values
    end

    # Return all of my ports that are output-capable.
    def outputs
      ports_with_capabilities(:output)
    end

    # Return all of my ports that are input-capable.
    def inputs
      ports_with_capabilities(:input)
    end

    def ports
      @ports.values
    end

    def port_names
      @ports.keys
    end

    # Return all of the event patterns from my current table
    def event_patterns
      return [] if current_table.nil?
      current_table.event_patterns
    end

    # Return my port with the given _name, or nil
    def port_named(_name)
      @ports[_name.to_s]
    end

    # Alias for easier typing
    alias :port :port_named

    def table_named(_name)
      @tables[_name.to_s]
    end

    def timer_named(_name)
      @timers[_name.to_s]
    end

    # :section: Task Definition
    # These methods build the structures that define a Task

    # Add the given port
    def add_port(port)
      @ports[port.name.to_s] = port
      port
    end

    # Add the given table
    def add_table(table)
      @tables[table.name.to_s] = table
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
      _name = _name.to_s
      t = Ticker.new(_name, _period)
      @timers[_name] = t
      t
    end

    # Add a Timer
    def add_timer(_name, _period)
      _name = _name.to_s
      t = Timer.new(_name, _period)
      @timers[_name] = t
      t
    end

  end

end
