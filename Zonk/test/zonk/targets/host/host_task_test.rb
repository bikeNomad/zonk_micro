require "minitest/autorun"
require "zonk"
require "zonk/targets/host"

class TestTasks < MiniTest::Unit::TestCase
  include Zonk

  def test_task_operation
    myapp = Application.new('myapp')
    task1 = Task.new('task1')
    myapp.add_task(task1)

    assert_empty(task1.ports, "must have no ports yet")
    assert_empty(task1.events, "must have no events yet")
    assert_empty(task1.tables, "must have no tables yet")
    assert_nil(task1.current_table, "must have no current table yet")
    assert_empty(task1.outputs, "must have no output ports yet")
    assert_empty(task1.inputs, "must have no input ports yet")
    assert_empty(task1.timers, "must have no timers yet")

    port1 = DigitalInputPort.new('port1')
    task1.add_port(port1)

    assert_equal(1, task1.ports.size, "must have one port")
    assert_same(port1, task1.ports.first, "first port must be port1")
    assert_same(port1, task1.port('port1'), "port must be findable")
    assert_equal(1, task1.inputs.size, "must have one input port")
    assert_equal(0, task1.outputs.size, "must have no output ports")

    # adding one output port adds 1 to both outputs and inputs
    # counts
    port2 = DigitalOutputPort.new('port2')
    task1.add_port(port2)

    assert_equal(2, task1.inputs.size, "must have two input ports")
    assert_equal(1, task1.outputs.size, "must have one output ports")

  end
end
