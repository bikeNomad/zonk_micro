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

    c3 = Condition.new(true, :yourself)
    c4 = Condition.new(true, :yourself)
    cc2 = cc & (c3 & c4)
    assert_instance_of(CompositeCondition, cc2, "combining two CompositeConditions should merge conditions")
    assert_equal(4, cc2.conditions.count, "combining two CompositeConditions should merge conditions")
    
  end

  def test_compare
    c1 = Condition.new(true, :yourself)
    c2 = Condition.new(true, :yourself)
    cc = c1 & c2

    assert_same(true === cc, true == cc)
    assert_same(false === cc, false == cc)
    assert_same(cc === true, cc.value == true)
  end

  def test_exceptions
    e1 = RuntimeError.new
    c2 = Condition.new(e1, :raise)
    assert_same(false, c2.value)

    c1 = Condition.new(true, :yourself)
    assert_raises(RuntimeError, "combining with non-bool should raise exception") { c1 & 3 }

    c2 = Condition.new(true, :yourself)
    cc = c1 & c2
    assert_raises(RuntimeError, "combining with non-bool should raise exception") { cc & 3 }
  end
end

