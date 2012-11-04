# :title: I/O base classes

require_relative 'task'
require_relative 'ports'

module Zonk # :nodoc:

  class InputPort < TaskPort
  protected
    def real_value
      subclass_responsibility
    end

    def value_range
      subclass_responsibility
    end

  public
    def capabilities
      [ :input ]
    end

    # Targets must define:
    # value()

  end

  class OutputPort < InputPort
  protected
    # set actual output
    def real_value=(val)
      subclass_responsibility
    end

  public
    def capabilities
      [ :output, :input ]
    end


    # Targets must define:
    # value=()

  end
end
