if Kernel.respond_to?(:require)
  require "cura/termbox/error/base"
end

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
