module Zonk
  # An EventPattern is used by Rule instances to classify Events.
  class EventPattern
    # Make a new EventPattern.
    # _source:: pattern for the event source
    # _kind:: pattern for the event kind. If _kind responds to include?,
    #         then that will be used for matching kinds.
    def initialize(_source, _kind)
      @source = _source
      @kinds = _kind
    end

    attr_reader :source, :kinds

    # Returns true if both the source and kind of evt
    # match my source and kinds patterns.
    def match_event(evt)
      return false unless @source === evt.source
      if @kinds.respond_to?(:include?)
        @kinds.include?(evt.kind)
      else
        @kinds === evt.kind
      end
    end

    def ===(other)
      return false unless other.class == self.class
      @source === other.source && @kinds === other.kinds
    end

    def to_a
      [ @source, @kinds ]
    end
  end

  # An Event is a timestamped record of an occurrence of something
  # reported by some object.
  class Event
    include Comparable

    # Initialize a new Event.
    # _source:: the reporter or source of the Event
    # _kind:: the kind of event
    # _data:: optional data attached to the Event
    def initialize(_source, _kind, _detected=Time.now, _data=nil)
      @source = _source
      @kind = _kind
      @timestamp = _detected
      @data = _data
    end

    # Compare Event timestamps numerically
    def <=>(other)
      return timestamp <=> other.timestamp if other.respond_to?(:timestamp)
      return timestamp <=> other if other.is_a?(Numeric)
      super
    end

    attr_reader :source, :kind, :data, :timestamp
  end
end
