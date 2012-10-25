require 'pp'
require "zonk"

$app = Zonk::application('myapp') do
  pp self

  task('task1') do
    pp self
  end

  target('testtarget') do
    pp self

    def add_input_pin(_name); add_pin(InputPin.new(_name, self)); end
    def add_output_pin(_name); add_pin(OutputPin.new(_name, self)); end

    add_input_pin("pin1")
    add_output_pin("pin2")

    pp self
  end

end
