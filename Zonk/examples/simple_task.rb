require 'pp'
require "zonk"
require "zonk/targets/host_simulation"
include Zonk

$app = Application.new('myapp')
$task = Task.new('task1', $app)
in1 = $task.add_port(DigitalInputPort.new('input1'))
out1 = $task.add_port(DigitalOutputPort.new('output1'))
out2 = $task.add_port(DigitalOutputPort.new('output2'))

$table = Table.new('table1', $task)

rule1 = Rule.new('rule1', $table)
rule1.set_event(in1, :went_high)
rule1.set_conditions(out1, :off?, out2, :off?)

rule1.add_action(:message, 'in first rule')
rule1.add_action(:port, 'output2', :set_port_value, true)

rule2 = Rule.new('rule2', $table)
rule2.set_event(in1, :went_high)
rule2.set_conditions(out2, :on?)
rule2.add_action(:message, 'in second rule')
rule2.add_action(:port, 'output2', :set_port_value, true)

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
