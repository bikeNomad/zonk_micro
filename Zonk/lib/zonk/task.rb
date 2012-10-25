module Zonk # :nodoc:

  # Each Zonk Application has at least one Task.
  # A Task is a Singleton class/instance that owns TaskPorts and at
  # least one Table.
  class Task < Base
    include Zonk
    # return a list of ports with all of the given capabilities
    def ports_with_capabilities(*capabilities)
      ncapabilities = capabilities.size
      @ports.select { |port| (port.capabilities & capabilities).size == ncapabilities }
    end

    def initialize
      super
      @ports = []
      @events = []
      @tables = []
      @current_table = nil
    end

    attr_reader :ports, :events, :tables, :current_table

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

    # Change the current table to 'table'.
    def switch_to_table(table)
      current_table.exit_table unless current_table.nil?
      @current_table = table
      current_table.enter_table
    end

    def add_port(port)
      @ports << port
      port
    end

    def add_event(evt)
      @events << evt
      evt
    end

    # TODO when do we call switch_to_table()?
    def add_table(table)
      @tables << table
      table
    end

    # returns a singleton instance of subclass of Table
    def define_table(_name, base = Table, *extensions, &block)
      new_table = make_singleton_of(_name, base, extensions, &block)
      self.add_table(new_table)
      the_task = self
      new_table.instance_eval { @owner = the_task }
      new_table
    end

  end

end
