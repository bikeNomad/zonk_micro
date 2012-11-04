module Zonk # :nodoc:

  # Each Zonk Application has at least one Task.
  # A Task owns TaskPorts and at least one Table.
  class Task < Base
    include Zonk
    # :section: Compilation and Introspection

    # Return a list of ports with all of the given capabilities
    def ports_with_capabilities(*capabilities)
      ncapabilities = capabilities.size
      @ports.values.select { |port| (port.capabilities & capabilities).size == ncapabilities }
    end

    def initialize(_name = nil, _owner = nil)
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

    def owner=(_owner)
      super
      _owner.add_task(self)
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
      return port if @ports.has_value? port
      @ports[port.name.to_s] = port
      port.owner= self
      port
    end

    # Add the given table
    def add_table(table)
      return table if @tables.has_value? table
      @tables[table.name.to_s] = table
      table.owner= self
      table
    end

    def add_timer(timer_or_ticker)
      return timer_or_ticker if @timers.has_value? timer_or_ticker
      @timers[timer_or_ticker.name.to_s] = timer_or_ticker
      timer_or_ticker.owner= self
      timer_or_ticker
    end

  end
end
