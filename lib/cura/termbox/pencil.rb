require "cura/termbox/color_mapper" if Kernel.respond_to?(:require)

module Cura
  module Termbox
    # TODO: terminal_code(9) should be 9 or 256 depending on the termbox configuration
    module Pencil
      # Change a point relative to this component's coordinates.
      def draw_point(x, y, color=Cura::Color.black)
        x     = x.to_i
        y     = y.to_i
        color = ColorMapper.code(color, 256) if color.is_a?(Color)

        ::Termbox.tb_change_cell(x, y, 0, color, color)
      end

      # Change a rectangle of points relative to this component's coordinates.
      def draw_rectangle(x, y, width, height, color=Cura::Color.black)
        x      = x.to_i
        y      = y.to_i
        width  = width.to_i
        height = height.to_i
        color = ColorMapper.code(color, 256) if color.is_a?(Color)

        width  = 1 if width < 1
        height = 1 if height < 1

        width.times do |x_offset|
          height.times do |y_offset|
            ::Termbox.tb_change_cell(x + x_offset, y + y_offset, 0, color, color)
          end
        end
      end

      def draw_character(x, y, character, foreground=Cura::Color.black, background=Cura::Color.white, bold=false, underline=false)
        x          = x.to_i
        y          = y.to_i
        foreground = ColorMapper.code(foreground, 256) if foreground.is_a?(Color)
        background = ColorMapper.code(background, 256) if background.is_a?(Color)

        character = character.to_s[0].codepoints.first
        character ||= 0

        foreground |= ::Termbox::TB_BOLD if bold
        foreground |= ::Termbox::TB_UNDERLINE if underline

        ::Termbox.tb_change_cell(x, y, character, foreground, background)
      end

      def draw_text(x, y, text, foreground=Cura::Color.black, background=Cura::Color.white, bold=false, underline=false)
        text.to_s.each_char do |character|
          draw_character(x, y, character, foreground, background, bold, underline)
        end
      end
    end
  end
end
