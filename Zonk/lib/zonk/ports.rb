module Zonk # :nodoc:

  # A TaskPort is a connection from a Task to a Target or other Task
  # instances. Each input TaskPort must be connected to something.
  # It is possible to have an output TaskPort that is not connected.
  class TaskPort
    include Zonk

    def capabilities
      subclass_responsibility
    end

    def initialize(_name = '')
      @name = _name
    end

    attr_reader :name

  end

end
