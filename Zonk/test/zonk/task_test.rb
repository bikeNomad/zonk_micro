require "minitest/autorun"
require "zonk"

class TestTasks < MiniTest::Unit::TestCase
  include Zonk

  def test_app_construction
    tester = self   # must do this for access in instance_eval and class_eval blocks
    Zonk::application('myapp') do
      # self is application instance
      tester.assert_kind_of(Zonk::Application, self, "self inside application block must be Application")
      tester.refute_instance_of(Zonk::Application, self, "self inside application block must be subinstance of Application")
      tester.assert_raises(TypeError, "app must be uncloneable") { self.clone }
      tester.assert_includes(self.class.ancestors, Singleton, "self inside application block must be Singleton")
      tester.assert_empty(self.tasks)
      tester.assert_nil(self.target)

      task1 = define_task('task1') do
        # self is task instance
        tester.assert_kind_of(Zonk::Task, self, "self inside define_task block must be Task")
        tester.refute_instance_of(Zonk::Task, self, "self inside define_task block must be subinstance of Task")
        tester.assert_raises(TypeError, "task must be uncloneable") { self.clone }
      end

      tester.refute_empty(self.tasks)
      tester.assert_equal(self.tasks.first, task1)

      target1 = define_target('testtarget') do
        # self is target instance
        tester.assert_kind_of(Zonk::Target, self, "self inside define_task block must be Target")
        tester.refute_instance_of(Zonk::Target, self, "self inside define_task block must be subinstance of Target")
        tester.refute_respond_to(self, :add_input_pin, "must not yet know add_input_pin")
        target_instance = self

        helpers do
          # self is target class
          tester.assert_kind_of(Class, self, "self inside define_target helpers block must be Class")
          tester.refute_respond_to(self.instance, :add_input_pin, "must not yet know add_input_pin")
          tester.assert_same(target_instance, self.instance, "helpers block must be class side of target")
          pre_count = self.instance_methods.count

          def add_input_pin(_name) add_pin(InputPin.new(_name, self)) end
          def add_output_pin(_name) add_pin(OutputPin.new(_name, self)) end

          post_count = self.instance_methods.count
          tester.assert_equal(pre_count + 2, post_count, "must have just added two methods to class")
        end

        tester.assert_respond_to(self, :add_input_pin, "must now know add_input_pin")
        tester.assert_empty(self.pins, "no pins yet")

        pin1 = add_input_pin("pin1")
        add_output_pin("pin2")

        tester.assert_equal(2, self.pins.count, "must now have two pins")
        tester.assert_includes(self.pin_names, "pin1", "must have pin1 by name")
        tester.assert_includes(self.pins, pin1, "must have pin1 by value")
        tester.assert_same(pin1, self.pin_named("pin1"), "must find pin1 by name")
      end

      tester.refute_nil(self.target)
      tester.assert_equal(self.target, target1)
      tester.assert_raises(RuntimeError, "app must accept only one target") { define_target('extratarget') { } }

    end
  end

end
