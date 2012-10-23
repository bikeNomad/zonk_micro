require "minitest/autorun"
require "zonk"

class TestZonkIO < MiniTest::Unit::TestCase
  include Zonk

  def test_input_override
    input = DigitalInput.new
    assert_raises(SubclassResponsibility) { input.value }
    input.override(true)
    assert_equal(input.value, true, "override must match")
    assert(input.overridden?, "must show as overridden")
    input.override(false)
    assert(input.overridden?, "must show as overridden")
    assert_equal(input.value, false, "override must match")
    input.override(nil)
    refute(input.overridden?, "must show as no longer overridden")
    assert_raises(SubclassResponsibility) { input.value }
  end

  def test_output_override
    output = DigitalOutput.new
    assert_raises(SubclassResponsibility) { output.value }
    output.override(true)
    assert_equal(output.value, true, "override must match")
    assert(output.overridden?, "must show as overridden")
    output.override(false)
    assert(output.overridden?, "must show as overridden")
    assert_equal(output.value, false, "override must match")
    assert_raises(SubclassResponsibility) { output.override(nil) }
    refute(output.overridden?, "must show as no longer overridden")
    assert_raises(SubclassResponsibility) { output.value }
  end

  def test_output_setting
    output = DigitalOutput.new
    assert_equal(output.overridden?, false)
    assert_raises(SubclassResponsibility) { output.value= true }
    output.override(true)
    assert_equal(output.value, true, "override must match")
    output.value= true
    assert_equal(output.value, true, "value override must match")
    output.value= false
    assert_equal(output.value, false, "value override must match")
    assert_raises(SubclassResponsibility) { output.override(nil) }
    assert_raises(SubclassResponsibility) { output.value= true }
  end

  def test_output_range_check
    output = DigitalOutput.new
    assert_raises(ValueRangeError, "must check for valid range") { output.value= 3 }
    output.override(true)
    assert_raises(ValueRangeError, "must check for valid range") { output.value= 3 }
    assert_raises(ValueRangeError, "must check for valid override range") { output.override(3) }
  end

end
