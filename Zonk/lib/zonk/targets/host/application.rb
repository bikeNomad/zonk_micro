module Zonk

  class Application < Base

    # :section: Runtime Support
    # These methods are used on the host(PC) side to run the app there.

    def initialize_target
      super
    end
  end

  class Target < Base
    def run!
    end
  end

end
