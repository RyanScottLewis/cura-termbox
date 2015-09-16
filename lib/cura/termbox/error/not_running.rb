if Kernel.respond_to?(:require)
  require "cura/termbox/error/base"
end

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
