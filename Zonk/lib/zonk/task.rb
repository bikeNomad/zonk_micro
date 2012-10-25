module Zonk
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

