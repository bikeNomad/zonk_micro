module Zonk
  class Task
    def ports_with_capabilities(*capabilities)
      @ports.reject { |port| (port.capabilities & capabilities).empty? }
    end

    def initialize
      @ports = []
      @events = []
      @tables = []
      @current_table = nil
    end

    attr_reader :ports, :events, :tables, :current_table

    def outputs
      ports_with_capabilities(:output)
    end

    def inputs
      ports_with_capabilities(:input)
    end

    def timers
      ports_with_capabilities(:timer)
    end
  end

  class TaskPort
    include Zonk

    @subclasses = []

    class << self

      def all_capabilities
        subclasses.collect { |klass| klass.capabilities }.flatten.uniq
      end

      def subclasses
        @subclasses
      end

      def add_subclass(klass)
        @subclasses << klass
      end

      def capabilities
        subclass_responsibility
      end
    end

    def capabilities
      self.class.capabilities
    end

    def initialize(_name = '')
      @name = _name
    end

    attr_reader :name

  end

end

