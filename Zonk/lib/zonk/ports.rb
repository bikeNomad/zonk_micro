module Zonk # :nodoc:

  # A TaskPort is a connection from a Task to a Target or other Task
  # instances. Each input TaskPort must be connected to something.
  # It is possible to have an output TaskPort that is not connected.
  class TaskPort < Base
    include Zonk
    protected

    def initialize_target
    end

    public

    def capabilities
      subclass_responsibility
    end

    def owner=(_owner)
      super
      _owner.add_port(self)
    end

  end

end
