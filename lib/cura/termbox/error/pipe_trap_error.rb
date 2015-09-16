if Kernel.respond_to?(:require)
  require "cura/termbox/error/base"
end

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
