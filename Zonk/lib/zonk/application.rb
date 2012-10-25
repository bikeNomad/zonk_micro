
module Zonk
  class Application < Base
    include Zonk

    def add_target(_target)
      raise "target already defined" if @target
      @target = _target
      theapp = self
      _target.instance_eval { @owner = theapp }
      _target
    end

    def add_task(_task)
      @tasks << _task
      theapp = self
      _task.instance_eval { @owner = theapp }
      _task
    end

    def initialize
      super
      @tasks = []
      @target = nil
      @pin_map = {}
      @port_map = {}
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

    # returns a singleton instance of subclass of Task
    def define_task(_name, base = Task, *extensions, &block)
      newtask = make_singleton_of(_name, base, extensions, &block)
      self.add_task(newtask)
      newtask
    end

    # returns a singleton instance of subclass of Target
    def define_target(_name, base = Target, *extensions, &block)
      newtarget = make_singleton_of(_name, base, extensions, &block)
      self.add_target(newtarget)
      newtarget
    end

  end
end
