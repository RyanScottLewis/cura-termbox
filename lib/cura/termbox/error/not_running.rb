require "cura/termbox/error/base" if Kernel.respond_to?(:require)

module Cura
  module Error
    module Termbox
      class NotRunning < Base
        def to_s
          "Termbox adapter is not running."
        end
      end
    end
  end
end
