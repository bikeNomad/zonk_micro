require 'pp'
require "zonk"

$app = Zonk::application('myapp') do
  pp "in application", self

  define_task('task1') do
    pp "in define_task", self
  end

  define_target('testtarget') do
    pp "in define_targets", self

    helpers do
      pp "in helpers", self

      def add_input_pin(_name) add_pin(InputPin.new(_name, self)) end
      def add_output_pin(_name) add_pin(OutputPin.new(_name, self)) end
    end

    add_input_pin("pin1")
    add_output_pin("pin2")
  end

end
