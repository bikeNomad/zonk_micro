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
    _t = self
    Zonk::application('myapp') do
      define_task('task1') do
        table1 = define_table('table1') do
          on_event(true, :yourself) { |evt| }
          on_event(true, :yourself) { }
        end
        _t.assert_equal(1, table1.event_patterns.size, "must fold repeated event patterns")
      end
    end
  end

end
