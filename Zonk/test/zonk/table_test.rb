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
      task1 = Task.new('task1', myapp)
        table1 = Table.new('table1', task1)
          rule1 = Rule.new('rule1', table1)
          rule1.set_event(true, :yourself)
          rule2 = Rule.new('rule2', table1)
          rule2.set_event(true, :yourself)
    assert_equal(1, table1.event_patterns.size, "must fold repeated event patterns")
  end
end
