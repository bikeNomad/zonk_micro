# :title: Zonk Infrastructure
require 'pp'

module Zonk
  # Error raised for missing methods
  class SubclassResponsibility < RuntimeError
    def initialize(msg=nil)
      super(msg || "subclass responsibility: #{caller(2)[0].sub(/.*`(\w+)'.*/, '\1')}")
    end
  end

  # raise a SubclassResponsibility exception
  def subclass_responsibility
    raise SubclassResponsibility.exception
  end

  # Error for out-of-range values
  class ValueRangeError < RuntimeError
    def initialize(value, expected_range, msg = nil)
      msg += ": " unless msg.nil?
      super("#{msg}value #{value} not in range #{expected_range.inspect}")
    end
  end

  # raise an out-of-range exception
  def out_of_range(value, expected_range, msg = nil)
    raise ValueRangeError.exception(value, expected_range, msg)
  end

  # check the given 'value' against 'expected_range'
  # Returns value if it's included in 'expected_range'.
  # Otherwise, raises a ValueRangeError.
  def check_range(value, expected_range, msg = nil)
    if expected_range.include? value
      value
    else
      out_of_range(value, expected_range, msg)
    end
  end

  class Base
    include Zonk
    protected

    # defined in subclasses by target modules
    def initialize_target
    end

    public

    def owner=(_owner)
      return if @owner == _owner
      raise "already owned by #{@owner.inspect}" unless @owner.nil?
      @owner = _owner
    end

    def initialize(_name = nil, _owner = nil)
      @name = _name
      @owner = nil
      self.owner= _owner if _owner
      initialize_target
    end

    attr_accessor :name
    attr_reader :owner

    # Makes the methods defined in the block and in the Modules given
    # in 'extensions' available in this class
    def self.helpers(*extensions, &block)
      class_eval(&block)   if block_given?
      include(*extensions) if extensions.any?
    end

    # Makes the methods defined in the block and in the Modules given
    # in 'extensions' available in this class
    def helpers(*extensions, &block)
      self.class.helpers(*extensions, &block)
    end

  end # Zonk::Base

end # module Zonk
