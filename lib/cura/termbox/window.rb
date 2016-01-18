require "termbox" if Kernel.respond_to?(:require)

module Cura
  module Termbox
    # Termbox specific mixins for Cura::Window.
    module Window
      # Get the width of this window.
      #
      # @return [Integer]
      def width
        ::Termbox.tb_width
      end

      # Get the height of this window.
      #
      # @return [Integer]
      def height
        ::Termbox.tb_height
      end
    end
  end
end
