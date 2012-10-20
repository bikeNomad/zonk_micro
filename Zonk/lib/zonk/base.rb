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
end
