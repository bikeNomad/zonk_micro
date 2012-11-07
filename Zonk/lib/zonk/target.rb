require_relative 'base'

module Zonk
  # definition of a particular kind of target
  class Target < Base
    include Zonk
    protected
    # add the given pin
    def add_pin(_pin)
      raise "pin named #{_pin.name} already added" if @pins.include?(_pin.name)
      @pins[_pin.name] = _pin
    end

    public
    def initialize
      super
      @pins = {}  # pin name => pin
      @application = nil
      @pin_map = {}   # pin => port
      @port_map = {}  # port => pin
    end

    # return all of my pins' names
    def pin_names
      @pins.keys
    end

    def pins
      @pins.values
    end

    def pin_named(_name)
      @pins[_name]
    end

    def add_application(app)
      @application = app
    end

    def connect_pin_to_port(pin, port)
      @pin_map[pin] = port
      @port_map[port] = pin
    end

  end
end

