require 'zonk'
require 'treetop'

# included by 
# Zonk::Grammar::GrammarParser (see lib/grammar.tt)

module Zonk
module Grammar

class ZonkGrammarNode < Treetop::Runtime::SyntaxNode
  class << self
    def output_stream
      @output_stream ||= $stdout
    end
    def output_stream=(s)
      @output_stream = s
    end
    def reserved_words
      @reserved_words ||= %w(digital_input digital_output analog_input analog_output timer
        ticker rule table task application when if then and true false
        on ON On off OFF Off)
    end
    def ports
      @ports ||= {}
    end
    def reserved_word?(w)
      reserved_words.include?(w)
    end
    def port_type(pn)
      ports[pn]
    end
  end

  def reserved_word?(w)
    self.class.reserved_words.include?(w)
  end

  def port_type(pn)
    self.class.port_type(pn)
  end
  
  def remember_port(pn,pk)
    self.class.ports[pn] = pk
    puts("remember #{pn} #{pk}")
  end

  def printf(*args)
    ZonkGrammarNode.output_stream.printf(*args)
  end

  def instantiate(owner=nil)
    owner_str = owner ? ", #{owner.name.text_value}" : ''
    printf("%s = %s.new('%s'%s)\n", name.text_value, model_class.name, name.text_value, owner_str)
  end
end

class ApplicationNode < ZonkGrammarNode
  def model_class
    Application
  end

  def instantiate(owner=nil)
    super
    tasks.elements.each { |task| task.instantiate(self) }
  end
end

class TaskNode < ZonkGrammarNode
  def model_class
    Task
  end

  def instantiate(owner=nil)
    super
    ports.elements.each { |port| port.instantiate(self) }
    tables.elements.each { |table| table.instantiate(self) }
  end
end

class PortNode  < ZonkGrammarNode
  def model_class
    case elements.first.text_value
    when 'digital_input'
      Zonk::DigitalInputPort
    when 'digital_output'
      Zonk::DigitalOutputPort
    when 'analog_input'
      Zonk::AnalogInputPort
    when 'analog_output'
      Zonk::AnalogOutputPort
    when 'ticker'
      Zonk::Ticker
    when 'timer'
      Zonk::Timer
    else
      raise "unknown port kind #{elements.first.text_value}"
    end
  end

  def initialize(*args)
    super
    remember_port(elements[2].text_value, elements[0].text_value)
  end
end

class TableNode < ZonkGrammarNode
  def model_class
    Table
  end

  def instantiate(owner=nil)
    super
    rules.elements.each { |rule| rule.instantiate(self) }
  end
end

class RuleNode < ZonkGrammarNode
  def model_class
    Rule
  end

  def instantiate(owner=nil)
    super
    printf("%s.set_event(%s)\n", name.text_value, event.as_args.join(', '))
    printf("%s.set_conditions(%s)\n", name.text_value, condition.as_args.join(", "))
    printf("%s.add_action(%s)\n",
                         name.text_value,
                         actions.elements.collect { |act| act.as_args }.join(", "))
  end
end

class WordNode < ZonkGrammarNode
  def is_reserved
    ZonkGrammarNode.reserved_word?(text_value)
  end
  def port_type
    ZonkGrammarNode.port_type(text_value)
  end
end

class NameNode < WordNode
end

# rule boolean_literal
module BooleanLiteralNode
  def literal_value
    case text_value
    when 'true', '1', /on/i
      true
    when 'false', '0', /off/i
      false
    else
      raise "not a boolean literal: #{text_value}"
    end
  end
end

end
end

