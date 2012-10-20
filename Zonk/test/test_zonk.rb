require "minitest/autorun"
require "zonk"

class TestZonkIO < MiniTest::Unit::TestCase
  include Zonk

  def test_input_override
    input = Input.new
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
    output = Output.new
    assert_raises(SubclassResponsibility) { output.value }
    output.override(true)
    assert_equal(output.value, true, "override must match")
    assert(output.overridden?, "must show as overridden")
    output.override(false)
    assert(output.overridden?, "must show as overridden")
    assert_equal(output.value, false, "override must match")
    output.override(nil)
    refute(output.overridden?, "must show as no longer overridden")
    assert_raises(SubclassResponsibility) { output.value }
  end

end
