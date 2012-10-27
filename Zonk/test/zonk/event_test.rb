require "minitest/autorun"
require 'zonk'

class TestEvents < MiniTest::Unit::TestCase
  include Zonk

  def test_event_pattern_matching
    p = EventPattern.new(1, 2)
    e = Event.new(1, 2)
    assert_operator(p, :match_event, e, "simple match must succeed")

    p = EventPattern.new(1, 3)
    e = Event.new(1, 2)
    refute_operator(p, :match_event, e, "simple mismatch must fail")

    p = EventPattern.new(1, [1, 2])
    e = Event.new(1, 1)
    assert_operator(p, :match_event, e, "includes? match must succeed")
    e = Event.new(1, 2)
    assert_operator(p, :match_event, e, "includes? match must succeed")

    p = EventPattern.new(Fixnum, 2)
    e = Event.new(1234, 2)
    assert_operator(p, :match_event, e, "class/object match must succeed")
    e = Event.new(1234.5, 2)
    refute_operator(p, :match_event, e, "class/object mismatch must fail")

    p = EventPattern.new(Object, 2)
    e = Event.new(1234, 2)
    assert_operator(p, :match_event, e, "class/object match must succeed")
    e = Event.new('abc', 2)
    assert_operator(p, :match_event, e, "class/object match must succeed")
    e = Event.new(BasicObject.new, 2)
    refute_operator(p, :match_event, e, "class/object mismatch must fail")
  end

  def test_event_timestamping
    e1 = Event.new(1, 2)
    sleep(0.01)
    e2 = Event.new(1, 2)
    assert_operator(e1, :<, e2, "timestamps must be ordered")
    refute_operator(e1, :>, e2, "timestamps must be ordered")
    e1 = Event.new(1, 2)
    sleep(0)
    e2 = Event.new(1, 2)
    assert_operator(e1, :<, e2, "timestamps must be ordered")
    refute_operator(e1, :>, e2, "timestamps must be ordered")
    assert_in_delta(e1.timestamp, e2.timestamp, 0.01, "timestamps must be close")
  end
end
