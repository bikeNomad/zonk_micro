require "minitest/autorun"
require "zonk"
require "zonk/targets/host"

class TestRules < MiniTest::Unit::TestCase
  include Zonk

  def setup
    @p1 = DigitalInputPort.new('p1')
    @p2 = DigitalInputPort.new('p2')
    @p3 = DigitalOutputPort.new('p3')
    @p1.override(false)
    @p2.override(false)
    @p2.override(false)
  end

  def test_rule_without_conditions
    rule = Rule.new(@p1, :on?) { 1234 }
    assert(rule.match_event(Event.new(@p1, :on?)))
    refute(rule.match_event(Event.new(@p1, :off?)))
    assert_equal(1234, rule.do_actions_for(Event.new(@p1, :on)))
  end

  def test_rule_with_conditions
    rule = Rule.new(@p1, :on?, @p2, :off?) { 1234 }
    assert(rule.match_event(Event.new(@p1, :on?)))
    refute(rule.match_event(Event.new(@p1, :off?)))
    assert_equal(1234, rule.do_actions_for(Event.new(@p1, :on)))
    @p2.override(true)
    assert(@p2.on?)
    refute(rule.match_event(Event.new(@p1, :on?)))
    assert_equal(1234, rule.do_actions_for(Event.new(@p1, :on)))
  end
end

