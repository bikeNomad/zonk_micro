module Zonk
  class Rule
    protected

    # :section: Runtime Support

    def initialize_target
    end

    public

    # TODO combine match_event and do_actions_for?

    # Return true if Event 'evt' matches my event pattern
    # and my condition (which is possibly empty) is not false
    def match_event(evt)
      @pattern.match_event(evt) && @condition.value
    end

    # TODO
    def do_actions_for(evt)
      return unless match_event(evt)
      # $stderr.puts("doing #{@actions.inspect}")
      @actions.each do |act|
        self.port(act[0]).value= eval(act[1])
      end
    end
  end

end
