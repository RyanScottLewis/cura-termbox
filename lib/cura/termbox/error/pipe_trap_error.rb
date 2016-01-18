require "cura/termbox/error/base" if Kernel.respond_to?(:require)

module Cura
  module Error
    module Termbox
      class PipeTrapError < Base
        def to_s
          "Pipe trap error."
        end
      end
    end
  end
end
