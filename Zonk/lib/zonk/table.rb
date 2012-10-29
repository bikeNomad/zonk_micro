require_relative 'rules'

module Zonk
  # Target ActionCompiler subclasses should inherit from this
  class ActionCompiler < BasicObject

    def initialize(_table)
      @rule = _table.current_rule
      @task = _table.owner
      @port_names = ::Regexp.new('\A(' + @task.port_names.join('|') + ')\Z')
      @timer_names = ::Regexp.new('\A(' + @task.timer_names.join('|') + ')\Z')
      @table_names = ::Regexp.new('\A(' + @task.table_names.join('|') + ')\Z')
    end

    KERNEL_DELEGATE = [:puts, :p]

    def method_missing(name, *args, &block)
      ::Kernel.p ['MM', name, *args, block]
      if KERNEL_DELEGATE.include? name
        ::Kernel.send(name, *args, block)
      else
        name = name.id2name
        case name
        when 'port'
          @task.port_named(args[0])
        when 'message'
          ::Kernel.puts *args
        when @port_names
          @rule.add_action(:port, name, *args)
        when @timer_names
          @rule.add_action(:timer, name, *args)
        when @table_names
          @rule.add_action(:table, name, *args)
        else
          self
        end
      end
    end

    def respond_to_missing?(name, include_private = false)
      KERNEL_DELGATE.include?(name) or 
        @port_names.match?(name.to_s) or
        @timer_names.match?(name.to_s) or
        @table_names.match?(name.to_s) or
        super
    end

    def self.const_missing(name)
      @rule.add_action(:const, name)
      self
    end

  end

  # A Table is a <i>decision table</i> consisting of Rule instances
  class Table < Base
    include Zonk

    class << self
      attr_accessor :compiler_class
    end

    def initialize
      super
      @rules = []
      @current_rule = nil
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

    # Return my task's port with the given _name
    def port(_name)
      task.port(_name)
    end

    # enqueue a message onto my task's message queue
    def message(*args)
      task.message("#{name}: " + sprintf(*args))
    end

    # Add a single rule
    def on_event(_src, _kind, *_conds, &block)
      self.class.compiler_class = ActionCompiler
      # raise "no compiler class set!" unless self.class.compiler_class
      $stderr.puts("compiling block #{block.source_location} with #{self.class.compiler_class}")
      begin
        rule = Rule.new(_src, _kind, _conds)
        @current_rule = rule
        compiler = self.class.compiler_class.new(self)
        compiler.instance_eval(&block)
        @rules << rule
        pp rule
      rescue
        $stderr.puts("Exception #{$!} in action compilation #{block.source_location}")
      ensure
        @current_rule = nil
      end
    end

  end

end
