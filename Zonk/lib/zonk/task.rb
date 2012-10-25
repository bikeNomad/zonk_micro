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

    # Run this task
    def run!
    end

  end

end
