
module Zonk

  # An Application is the representation of a Zonk program.
  class Application < Base
    include Zonk

    # :section: Application Definition
    # These methods assist with the compile-time structure building

    def add_target(_target)
      raise "target already defined" if @target
      @target = _target
      _target.owner = self
      _target
    end

    def add_task(_task)
      return _task if @tasks.include? _task
      @tasks << _task
      _task.owner = self
      _task
    end

    def initialize(_name = nil, _owner = nil)
      super
      @tasks = []
      @target = nil
      @pin_map = {}
      @port_map = {}
    end

    def owner=(_owner)
      super
      _owner.add_application(self)
    end

    # _pinname is the name of a pin in my target
    # _port is 
    def map_pin_to_port(_pinname, _port)
      raise "pin not owned by target" if _pin.target != target
      raise "no target" unless target
      @pin_map[_pin] = _port
      @port_map[_port] = _pin
    end

    attr_reader :tasks, :target

  end
end
