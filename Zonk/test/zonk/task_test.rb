require "minitest/autorun"
require "zonk"

class TestTasks < MiniTest::Unit::TestCase
  include Zonk

  def test_app_construction
    _t = self   # must do this for access in instance_eval and class_eval blocks
    Zonk::application('myapp') do
      # self is application instance
      _t.assert_kind_of(Zonk::Application, self, "self inside application block must be Application")
      _t.refute_instance_of(Zonk::Application, self, "self inside application block must be subinstance of Application")
      _t.assert_raises(TypeError, "app must be uncloneable") { self.clone }
      _t.assert_includes(self.class.ancestors, Singleton, "self inside application block must be Singleton")
      _t.assert_empty(self.tasks)
      _t.assert_nil(self.target)

      task1 = define_task('task1') do
        # self is task instance
        _t.assert_kind_of(Zonk::Task, self, "self inside define_task block must be Task")
        _t.refute_instance_of(Zonk::Task, self, "self inside define_task block must be subinstance of Task")
        _t.assert_raises(TypeError, "task must be uncloneable") { self.clone }
      end

      _t.refute_empty(self.tasks, "must have defined a task")
      _t.assert_equal(1, self.tasks.size, "must have defined a task")
      _t.assert_equal(self.tasks.first, task1, "first task must be task1")

      target1 = define_target('testtarget') do
        # self is target instance
        _t.assert_kind_of(Zonk::Target, self, "self inside define_task block must be Target")
        _t.refute_instance_of(Zonk::Target, self, "self inside define_task block must be subinstance of Target")
        _t.refute_respond_to(self, :add_input_pin, "must not yet know add_input_pin")
        target_instance = self

        helpers do
          # self is target class
          _t.assert_kind_of(Class, self, "self inside define_target helpers block must be Class")
          _t.refute_respond_to(self.instance, :add_input_pin, "must not yet know add_input_pin")
          _t.assert_same(target_instance, self.instance, "helpers block must be class side of target")
          pre_count = self.instance_methods.count

          def add_input_pin(_name) add_pin(InputPin.new(_name, self)) end
          def add_output_pin(_name) add_pin(OutputPin.new(_name, self)) end

          post_count = self.instance_methods.count
          _t.assert_equal(pre_count + 2, post_count, "must have just added two methods to class")
        end

        _t.assert_respond_to(self, :add_input_pin, "must now know add_input_pin")
        _t.assert_empty(self.pins, "no pins yet")

        pin1 = add_input_pin("pin1")
        add_output_pin("pin2")

        _t.assert_equal(2, self.pins.count, "must now have two pins")
        _t.assert_includes(self.pin_names, "pin1", "must have pin1 by name")
        _t.assert_includes(self.pins, pin1, "must have pin1 by value")
        _t.assert_same(pin1, self.pin_named("pin1"), "must find pin1 by name")
      end

      _t.refute_nil(self.target)
      _t.assert_equal(self.target, target1)
      _t.assert_raises(RuntimeError, "app must accept only one target") { define_target('extratarget') { } }

    end
  end

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

          def add_input_port(_name) add_port(Inputport.new(_name, self)) end
          def add_output_port(_name) add_port(Outputport.new(_name, self)) end

          post_count = self.instance_methods.count
          _t.assert_equal(pre_count + 2, post_count, "must have just added two methods to class")
        end
      end
    end
  end

  def test_multiple_tasks
    _t = self
    Zonk::application('myapp') do
      task1 = define_task('task1') { }

      _t.refute_empty(self.tasks, "must have defined a task")
      _t.assert_equal(1, self.tasks.size, "must have defined a task")
      _t.assert_equal(self.tasks.first, task1, "first task must be task1")

      task2 = define_task('task2') { }

      _t.assert_equal(2, self.tasks.size, "must have defined another task")
      _t.assert_equal(self.tasks.last, task2, "second task must be task2")
    end
  end
end

