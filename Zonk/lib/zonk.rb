# :title:Top-level include file for Zonk
require_relative 'zonk/base'
require_relative 'zonk/ports'
require_relative 'zonk/io_ports'
require_relative 'zonk/digital_io_ports'
require_relative 'zonk/trace'
require_relative 'zonk/table'
require_relative 'zonk/task'
require_relative 'zonk/connection'
require_relative 'zonk/io_pins'
require_relative 'zonk/target'
require_relative 'zonk/application'

# Namespace for all Zonk classes
module Zonk
  VERSION = '1.0.0'
end

include Zonk
