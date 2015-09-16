if Kernel.respond_to?(:require)
  require "cura/termbox/error/base"
end

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
