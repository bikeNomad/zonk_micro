module Zonk

  class Table < Base

    # :section: Runtime Support

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

    # enqueue a message onto my task's message queue
    def message(*args)
      task.message("#{name}: " + sprintf(*args))
    end

    # called upon entry to the table
    def enter_table
      # TODO enqueue table entry event
    end

    # called upon exit from the table
    def exit_table
      # TODO enqueue table exit event
    end

  end
end
