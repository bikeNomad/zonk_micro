# :title: Zonk Infrastructure
require 'singleton'
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

  # \Base class for customizable parts like Task, Target, and Table
  class Base
    include Zonk

    class << self
      protected

      def direct_subclasses
        @direct_subclasses ||= []
      end

      # Ensure that new subclasses are initialized correctly
      def inherited(subclass)
        super
        subclass.reset!
        direct_subclasses << subclass
      end

      # make this class a singleton
      def reset!
        include Singleton unless self.ancestors.include?(Singleton)
      end

      public

      # Return direct and indirect subclasses
      def subclasses
        subs = []
        direct_subclasses.each do |k|
          subs << k
          subs.concat(k.subclasses)
        end
        subs
      end

      def indirect_subclasses
        subclasses - direct_subclasses
      end

      def subinstances
        subclasses.map(&:instance)
      end

      def indirect_subinstances
        indirect_subclasses.map(&:instance)
      end
  
      # Return the single instance of a new subclass of class 'base'.
      #
      # The new subclass is extended by modules given in 'extensions' (if any),
      # then it is made into a singleton instance.
      #
      # The singleton instance then is named as _name, and evaluates the optional block.
      def make_singleton_of(_name, base, extensions, &block)
        newklass = Class.new(base)
        newklass.class_eval <<EOF
          def self.to_s
            "#<#{base.to_s}:<#{_name}>>"
          end
          def self.inspect
            "#<#{base.to_s}:<#{_name}>>"
          end
EOF
        newklass.class_eval do
          def inspect
            ary = []
            for iv in instance_variables
              iv = iv.to_s
              ary.push format("%s=%s", iv, eval(iv).to_s)
            end
            format("#<%s: %s>", self.class, ary.join(", "))
          end
          include(Zonk)
          include(*extensions) if extensions.any?
        end
        newklass.instance.instance_eval do
          @name = _name
        end
        newklass.instance.instance_eval(&block) if block_given?
        newklass.instance
      end

      # Makes the methods defined in the block and in the Modules given
      # in 'extensions' available in this class
      def helpers(*extensions, &block)
        class_eval(&block)   if block_given?
        include(*extensions) if extensions.any?
      end

      def application(_name, base=Application, &block)
        make_singleton_of(_name, base, [], &block)
      end

    end # Zonk::Base class

    protected

    def make_singleton_of(_name, base, extensions, &block)
      self.class.make_singleton_of(_name, base, extensions, &block)
    end

    # self.reset!

    def initialize  # :notnew: :nodoc:
      @name = nil
      @owner = nil
    end

    public

    attr_reader :name, :owner

    # Makes the methods defined in the block and in the Modules given
    # in 'extensions' available in this class
    def helpers(*extensions, &block)
      self.class.helpers(*extensions, &block)
    end

  end # Zonk::Base

  # Create a new Zonk application.
  # The optional block is evaluated in the new app's class scope.
  # Returns the sole instance of the new singleton class.
  def self.application(_name, base=Application, &block)
    Base::application(_name, base=Application, &block)
  end

end # module Zonk
