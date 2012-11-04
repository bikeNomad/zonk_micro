require "minitest/autorun"
require "zonk"
require "zonk/targets/host"

class TestRules < MiniTest::Unit::TestCase
  include Zonk

  def setup
    @task = Task.new('task', nil)
    @table = Table.new('table', @task)
    @p1 = DigitalInputPort.new('p1', @task)
    @p2 = DigitalOutputPort.new('p2', @task)
    @p3 = DigitalOutputPort.new('p3', @task)
    @p1.override(false)
    @p2.override(false)
    @p3.override(false)
    @rule = Rule.new('rule1', @table)
  end

  def test_rule_without_conditions
    @rule.set_event(@p1, :went_on)
    assert(@rule.match_event(Event.new(@p1, :went_on)))
    refute(@rule.match_event(Event.new(@p1, :went_off)))
  end

  def test_rule_with_conditions
    @rule.set_event(@p1, :went_on)
    @rule.set_conditions([@p2, :off?])
    # now, p1 must get the :went_on event while p2 is off
    assert(@rule.match_event(Event.new(@p1, :went_on)))
    refute(@rule.match_event(Event.new(@p1, :went_off)))

    @p2.override(true)
    assert(@p2.on?)
    refute(@rule.match_event(Event.new(@p2, :went_on)))
    refute(@rule.match_event(Event.new(@p2, :went_off)))
  end

  def test_rule_actions
    @rule.set_event("p1", :went_on)
    assert(@rule.match_event(Event.new(@p1, :went_on)))
    assert(@rule.match_event(Event.new(@p1, "went_on")))
    refute(@rule.match_event(Event.new(@p1, :went_off)))

    @rule.set_conditions(["p2", "is_off"], ["p3", "is_off"])
    assert_same(true, @rule.condition.value, "must detect IO conditions")
    
    assert(@rule.match_event(Event.new(@p1, :went_on)))
    assert(@rule.match_event(Event.new(@p1, "went_on")))
    refute(@rule.match_event(Event.new(@p1, "went_off")))

    @p2.override(true)
    refute(@rule.match_event(Event.new(@p1, :went_on)))
    refute(@rule.match_event(Event.new(@p1, "went_off")))

    @p2.override(false)
    @rule.add_actions(["p2", "true"], ["p3", "true"])
    assert(@rule.actions)

    refute(@p2.is_on)
    refute(@p3.is_on)
    @rule.do_actions_for(Event.new(@p1, :went_on))
    assert(@p2.is_on)
    assert(@p3.is_on)
  end
end

