require "cura/termbox/error/base" if Kernel.respond_to?(:require)

module Cura
  module Error
    module Termbox
      class FailedToOpenTTY < Base
        def to_s
          "Could not open TTY."
        end
      end
    end
  end
end
