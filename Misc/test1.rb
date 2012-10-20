require 'zonk'
require 'target1'

include Zonk

class Task1 < Task
  def initialize(_name)
    super
    @input1 = DigitalInput.new
    @input2 = DigitalInput.new
    @output1 = DigitalOutput.new
    @event1 = input1.wentLow
    @event2 = input1.wentHigh

    @table1 = DecisionTable.new(self, 'table1') do |ev|
      case ev
      when 'entry'
      when 'exit'
      when event1
        if input2
        end
      when event2
        switch_to('table2')
      end
    end

  end

  attr_accessor :input1, :input2, :output1, :event1, :event2, :table1

end
