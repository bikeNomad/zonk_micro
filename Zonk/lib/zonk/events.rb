module Zonk
  # An EventPattern is used by Rule instances to classify Events.
  class EventPattern
    # :section: Compilation

    # Make a new EventPattern.
    # _source:: pattern for the event source
    # _kind:: pattern for the event kind. If _kind responds to include?,
    #         then that will be used for matching kinds.
    def initialize(_source, _kind)
      @source = _source
      @kinds = _kind
    end

    attr_reader :source, :kinds

    def to_a
      [ @source, @kinds ]
    end
  end

end
