require "minitest/autorun"
require "zonk"
require "zonk/targets/host"

class TestTasks < MiniTest::Unit::TestCase
  include Zonk

  def test_task_operation
    _t = self
    Zonk::application('myapp') do
      task1 = define_task('task1') do
        # self is task instance
        _t.assert_empty(ports, "must have no ports yet")
        _t.assert_empty(events, "must have no events yet")
        _t.assert_empty(tables, "must have no tables yet")
        _t.assert_nil(current_table, "must have no current table yet")
        task_instance = self

        helpers do
          # self is task class
          _t.assert_kind_of(Class, self, "self inside define_task helpers block must be Class")
          _t.refute_respond_to(self.instance, :add_input_port, "must not yet know add_input_port")
          _t.assert_same(task_instance, self.instance, "helpers block must be class side of target")
          pre_count = self.instance_methods.count

          def add_input_port(_name) add_port(DigitalInputPort.new(_name)) end
          def add_output_port(_name) add_port(DigitalOutputPort.new(_name)) end

          post_count = self.instance_methods.count
          _t.assert_equal(pre_count + 2, post_count, "must have just added two methods to class")
        end

        _t.assert_empty(outputs, "must have no output ports yet")
        _t.assert_empty(inputs, "must have no input ports yet")
        _t.assert_empty(timers, "must have no timers yet")

        port1 = add_input_port('port1')
        _t.assert_equal(1, ports.size, "must have one port")
        _t.assert_same(port1, ports.first[1], "first port must be port1")
        _t.assert_same(port1, port('port1'), "port must be findable")

        _t.assert_equal(1, inputs.size, "must have one input port")
        _t.assert_equal(0, outputs.size, "must have no output ports")

        # adding one output port adds 1 to both outputs and inputs
        # counts
        add_output_port('port2')

        _t.assert_equal(2, inputs.size, "must have two input ports")
        _t.assert_equal(1, outputs.size, "must have one output ports")

      end # define_task('task1')
      _t.assert_same(self, task1.owner, "task must be owned by app")
    end
  end

end

