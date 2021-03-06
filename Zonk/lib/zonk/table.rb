require_relative 'rules'

module Zonk
  # A Table is a <i>decision table</i> consisting of Rule instances
  class Table < Base
    include Zonk

    def initialize(_name = nil, _owner = nil)
      @rules = []
      super
    end

    def owner=(_owner)
      super
      _owner.add_table(self)
    end

    attr_reader :rules, :current_rule

    alias :task :owner

    # Return all of my unique event patterns
    def event_patterns
      h = {}
      rules.each do |rule|
        p = rule.pattern
        h[p.to_a] = p
      end
      h.values
    end

    def add_rule(rule)
      return if @rules.include? rule
      @rules << rule
    end

  end
end
