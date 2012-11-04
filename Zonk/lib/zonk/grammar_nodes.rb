require 'treetop'

# included by 
# Zonk::Grammar::GrammarParser (see lib/grammar.tt)

module Zonk
module Grammar

class ZonkGrammarNode < Treetop::Runtime::SyntaxNode
  def self.output_stream
    @output_stream ||= $stdout
  end

  def self.reserved_words
    @reserved_words ||= %w(digital_input digital_output analog_input analog_output timer
      ticker rule table task application when if then and true false
      on ON On off OFF Off)
  end

  def self.ports
    @ports ||= {}
  end

  def reserved_word?(w)
    self.class.reserved_words.include?(w)
  end

  def port_type(pn)
    self.class.ports[pn]
  end
  
  def remember_port(pn,pk)
    self.class.ports[pn] = pk
  end

  def printf(*args)
    ZonkGrammarNode.output_stream.printf(*args)
  end

  def instantiate
    output_stream.printf("%s = %s.new", name, model_class.name)
  end
end

class ApplicationNode < ZonkGrammarNode
  def model_class
    Application
  end

  def instantiate
    super
    tasks.elements.each do |task|
      task.instantiate
      printf("%s.add_task(%s)\n", name, task.name)
    end
  end
end

class TaskNode < ZonkGrammarNode
  def model_class
    Task
  end

  def instantiate
    super
    ports.elements.each do |port|
      port.instantiate
      case port.model_class
      when Ticker, Timer
        printf("%s.add_timer(%s)\n", name, port.name)
      else
        printf("%s.add_port(%s)\n", name, port.name)
      end
    end
    tables.elements.each do |table|
      table.instantiate
      printf("%s.add_table(%s)\n", name, table.name)
    end
  end
end

class PortNode < ZonkGrammarNode
  def model_class
    case elements.first.text_value
    when 'digital_input'
      DigitalInput
    when 'digital_output'
      DigitalOutput
    when 'analog_input'
      AnalogInput
    when 'analog_output'
      AnalogOutput
    when 'ticker'
      Ticker
    when 'timer'
      Timer
    else
      raise "unknown port kind #{elements.first.text_value}"
    end
  end
end

class TableNode < ZonkGrammarNode
  def model_class
    Table
  end
end

class RuleNode < ZonkGrammarNode
  def model_class
    Rule
  end
end

class ActionNode < ZonkGrammarNode
end

class NameNode < ZonkGrammarNode
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

def parse(text)
  parser = GrammarParser.new
end

end
end
