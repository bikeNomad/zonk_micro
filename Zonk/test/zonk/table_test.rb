require "minitest/autorun"
require "zonk"

unless Object.instance_methods.include?(:yourself)
  class Object
    def yourself
      self
    end
  end
end

class TestTables < MiniTest::Unit::TestCase
include Zonk
  def test_event_patterns
    myapp = Application.new
      task1 = Task.new
        table1 = Table.new
          rule1 = Rule.new
          rule1.set_event(true, :yourself)
          table1.add_rule(rule1)
          rule2 = Rule.new
          rule2.set_event(true, :yourself)
          table1.add_rule(rule2)
        task1.add_table(table1)
      myapp.add_task(task1)
    assert_equal(1, table1.event_patterns.size, "must fold repeated event patterns")
  end
end
