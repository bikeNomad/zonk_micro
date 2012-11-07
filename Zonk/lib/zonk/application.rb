
module Zonk

  # An Application is the representation of a Zonk program.
  class Application < Base
    include Zonk

    # :section: Application Definition
    # These methods assist with the compile-time structure building

    def add_task(_task)
      return _task if @tasks.include? _task
      @tasks << _task
      _task.owner = self
      _task
    end

    def initialize(_name = nil, _owner = nil)
      super
      @tasks = []
    end

    attr_reader :tasks, :target

    def owner=(_owner)
      super
      _owner.add_application(self)
    end
  end
end
