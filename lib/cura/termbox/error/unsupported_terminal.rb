require "cura/termbox/error/base" if Kernel.respond_to?(:require)

module Cura
  module Error
    module Termbox
      class UnsupportedTerminal < Base
        def to_s
          "The current terminal is unsupported."
        end
      end
    end
  end
end
