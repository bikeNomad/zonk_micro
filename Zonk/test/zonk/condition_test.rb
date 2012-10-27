require "minitest/autorun"
require "zonk"

unless Object.instance_methods.include?(:yourself)
  class Object
    def yourself
      self
    end
  end
end

class TestZonkConditions < MiniTest::Unit::TestCase
  include Zonk

  def test_simple_condition
    cond = Condition.new(false, :yourself)
    assert_same(cond.value, false, "must see false")

    cond = Condition.new(nil, :yourself)
    assert_same(cond.value, false, "must see nil as false")

    cond = Condition.new(true, :yourself)
    assert_same(cond.value, true, "must see true")
  end

  def test_combining_conditions
    c1 = Condition.new(true, :yourself)
    c2 = Condition.new(true, :yourself)
    cc = c1 & c2
    assert_instance_of(CompositeCondition, cc, "'&' must make a CompositeCondition out of two Conditions")
    assert_same(cc.value, c1.value & c2.value, "'&' operator must work right")

    c2 = Condition.new(false, :yourself)
    cc = c1 & c2
    assert_same(cc.value, c1.value & c2.value, "'&' operator must work right")
    cc = c2 & c1
    assert_same(cc.value, c2.value & c1.value, "'&' operator must work right")

    c1 = Condition.new(true, :yourself)
    c2 = Condition.new(true, :yourself)
    c3 = Condition.new(false, :yourself)
    cc = c1 & c2 & c3
    assert_instance_of(CompositeCondition, cc, "'&' must make a CompositeCondition out of two Conditions")
    assert_equal(3, cc.conditions.count)
    assert_same(cc.value, c1.value & c2.value & c3.value, "'&' operator must work right")
    assert_same(cc.value, false, "'&' operator must work right")
    assert(cc.value === false, "'===' operator must work right")

    # NOTE this doesn't work right!
    # cc = c1 and c2
    # assert_instance_of(CompositeCondition, cc, "'and' must make a CompositeCondition out of two Conditions")

    cc = c1.and c2
    assert_instance_of(CompositeCondition, cc, "'.and' must make a CompositeCondition out of two Conditions")
    assert_equal(2, cc.conditions.count)
  end
end

