require 'pp'
require "zonk"
require "zonk/targets/host_simulation"

$app=
Zonk::application('myapp') do # self is the Application

  define_task('task1') do # self is the Task
    add_digital_input_port('input1')
    add_digital_output_port('output1')
    add_digital_output_port('output2')

    define_table('table1') do # self is the Table
      # Rule 1
      on_event(port('input1'), :went_high,
               port('output1'), :on?,
               port('output2'), :on?) do
        message("in first rule")
      end

      # Rule 2
      on_event(port('input1'), :went_high,
               port('output1'), :on?,
               port('output2'), :on?) do
        message("in first rule")
      end

    end
  end

  define_target('testtarget') do  # self is the Target
    helpers do
      def add_input_pin(_name) add_pin(InputPin.new(_name, self)) end
      def add_output_pin(_name) add_pin(OutputPin.new(_name, self)) end
    end

    add_input_pin("pin1")
    add_output_pin("pin2")
  end

  # TODO connect pins to ports

end

$task = $app.tasks.first
$table = $task.tables.first
$input1 = $task.port('input1')
$output1 = $task.port('output1')
$input1.override(false)
$output1.override(false)
$thread1 = $task.run!
$task.add_event(Event.new($input1, :went_high))
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
