require 'pp'
require "zonk"

$app=
  Zonk::application('myapp') do
  # self is the Application
  # Task1
  define_task('task1') do
    # self is the Task
    $input1 =
      add_digital_input_port('input1')
    $output1 =
      add_digital_output_port('output1')

    # Table1
    define_table('table1') do
      # self is the Table
      rules do |evt|
        # self is the Table
        case evt
        when EventPattern.new(port('input1'), :went_high)
          message("in first rule")
          # TODO make output of #is_high, etc. into objects?
        when EventPattern.new(port('input1'), :went_low)
          message("in second rule")
        else
          message("no match")
        end
      end
    end
  end

  define_target('testtarget') do
    helpers do
      def add_input_pin(_name) add_pin(InputPin.new(_name, self)) end
      def add_output_pin(_name) add_pin(OutputPin.new(_name, self)) end
    end

    add_input_pin("pin1")
    add_output_pin("pin2")
  end

end

$task = $app.tasks.first
$table = $task.tables.first
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
