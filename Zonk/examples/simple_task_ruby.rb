require 'pp'
require "zonk"
require "zonk/targets/host_simulation"
include Zonk

$app = Application.new('myapp')
$task = Task.new('task1', $app)
in1 = DigitalInputPort.new('input1', $task)
out1 = DigitalOutputPort.new('output1', $task)
out2 = DigitalOutputPort.new('output2', $task)

$table = Table.new('table1', $task)

rule1 = Rule.new('rule1', $table)
rule1.set_event(in1, :went_high)
rule1.set_conditions([out1, :off?], [out2, :off?])

rule1.add_actions([:message, 'in first rule'])
rule1.add_actions(['output2', true])

rule2 = Rule.new('rule2', $table)
rule2.set_event(in1, :went_high)
rule2.set_conditions([out2, :on?])
rule2.add_actions([:message, 'in second rule'], ['output2', true])

$thread1 = $task.run!
$task.add_event(Event.new(in1, :went_high))
sleep(3)
$task.terminate!

unless $task.events.empty?
  puts "Events:"
  until $task.events.empty? do
    puts "\t" + $task.events.pop.inspect
  end
end

puts "Messages:"
until $task.messages.empty? do
  puts "\t" + $task.messages.pop
end
