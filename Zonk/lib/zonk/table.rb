module Zonk
  # A Table is a <i>decision table</i> consisting of Rule instances
  class Table < Base
    include Zonk

    def initialize
      super
      @rules = []
    end

    attr_reader :rules

    def enter_table
    end

    def exit_table
    end

  end
end
