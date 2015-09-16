if Kernel.respond_to?(:require)
  require "cura/error/base"
end

module Cura
  module Error
    module Termbox
      
      # The base class for Cura::Termbox errors.
      class Base < Error::Base
        
      end
      
    end
  end
end
