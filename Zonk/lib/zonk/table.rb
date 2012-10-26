require_relative 'rules'

module Zonk
  # A Table is a <i>decision table</i> consisting of Rule instances
  class Table < Base
    include Zonk

    def initialize
      super
      # a Proc which can handle events
      @rules = nil
    end

    alias :task :owner

    # Set my rules to the given block,
    # or return my rules proc
    def rules
      if block_given?
        new_rules = Proc.new
        raise "rules block must take one parameter" if new_rules.arity != 1
        raise "rules already defined" if @rules
        @rules = new_rules
      else
        @rules
      end
    end

    # called upon entry to the table
    def enter_table
      # TODO enqueue table entry event
    end

    # called upon exit from the table
    def exit_table
      # TODO enqueue table exit event
    end

    def process_event(evt)
      @rules.call(evt)  if @rules
    end

    # Return my task's port with the given _name
    def port(_name)
      task.port(_name)
    end

    def message(*args)
      task.message(*args)
    end

  end
end
