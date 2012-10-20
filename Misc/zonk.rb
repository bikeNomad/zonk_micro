module Zonk

class Input
  def initialize
    @lastValue = nil
    @value = nil
  end

  attr_reader :value, :lastValue

  def scan
  end
end

class FakeInput < Input
  def initialize
    super
  end

  def setTo(level)
    @value = level
  end
end

class Output < FakeInput
  def initialize
    super
  end
end

class DigitalInput < FakeInput
  def wentLow
  end

  def wentHigh
  end

  def isHigh
  end

  def isLow
  end
end

class DigitalOutput < Output
end

class Event
  def initialize
  end
end

class DecisionTable
  def initialize(_task, _name, &_block)
    @name = _name
    @block = _block
    @task = _task
    @task.add_table(_name, self)
  end

  attr_reader :name, :task, :block

  def switch_to(other_table)
    @task.switch_to(other_table)
  end

  def exit
    self.handle_event('exit')
  end

  def enter
    self.handle_event('entry')
  end
end

class Task
  def initialize(_name)
    @name = _name
    @table = nil
    @tables = {}
  end

  attr_reader :name, :table, :tables

  def add_table(_name, _table)
    @tables[_name] = _table
    @table = _table if @table.nil?
  end

  def table_named(_name)
    t = @tables[_name]
    raise "no table named #{_name}!" if t.nil?
    t
  end

  def switch_to(other_table_name)
    @table.exit
    (@table = table_named(other_table_name)).enter
  end

  def handle_event(ev)
    raise 'no table!' if table.nil?
  end
end

end # module Zonk
