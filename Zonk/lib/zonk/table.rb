require_relative 'rules'

module Zonk
  # A Table is a <i>decision table</i> consisting of Rule instances
  class Table < Base
    include Zonk

    def initialize
      super
      @rules = []
    end

    attr_reader :rules

    alias :task :owner

    # called upon entry to the table
    def enter_table
      # TODO enqueue table entry event
    end

    # called upon exit from the table
    def exit_table
      # TODO enqueue table exit event
    end

    # pass the given event 'evt' through my rules block
    def process_event(evt)
      return unless @rules
      matched = @rules.detect { |rule| rule.match_event(evt) }
      unless matched
        message("#{evt.inspect} not matched")
        return
      end
      matched.do_actions_for(evt)
    end

    # Return my task's port with the given _name
    def port(_name)
      task.port(_name)
    end

    # enqueue a message onto my task's message queue
    def message(*args)
      task.message("#{name}: " + sprintf(*args))
    end

    # Add a single rule
    def on_event(_src, _kind, *_conds, &block)
      @rules << Rule.new(_src, _kind, _conds, &block)
    end

  end
end
