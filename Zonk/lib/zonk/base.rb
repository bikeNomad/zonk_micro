# Zonk basic structure
module Zonk
  class SubclassResponsibility < RuntimeError
    def initialize(msg=nil)
      super(msg || "subclass responsibility: #{caller(2)[0].sub(/.*`(\w+)'.*/, '\1')}")
    end
  end

  def subclass_responsibility
    raise SubclassResponsibility.exception
  end

  class ValueRangeError < RuntimeError
    def initialize(value, expected_range, msg = nil)
      msg += ": " unless msg.nil?
      super("#{msg}value #{value} not in range #{expected_range.inspect}")
    end
  end

  def out_of_range(value, expected_range, msg = nil)
    raise ValueRangeError.exception(value, expected_range, msg)
  end
end
