# Connects a Zonk Task to a Target
module Zonk
  class TaskToTargetConnection
    def initialize(_task, _target)
      @task = _task
      @target = _target
      @available_pins = @target.pins
      @connections = {} # task object => pin
    end

    def connect_outputs
      # possible_pins = @available_pins.select { |pin| }
      # connected_pins = {}
      @task.outputs.each do |output|
      end
    end

    def connect_inputs
    end

    def connect_timers
    end

    def connect
      connect_timers
      connect_outputs
      connect_inputs
    end
  end
end
