# /* Colors (see struct tb_cell's fg and bg fields). */
# #define TB_DEFAULT 0x00
# #define TB_BLACK   0x01
# #define TB_RED     0x02
# #define TB_GREEN   0x03
# #define TB_YELLOW  0x04
# #define TB_BLUE    0x05
# #define TB_MAGENTA 0x06
# #define TB_CYAN    0x07
# #define TB_WHITE   0x08
#
# /* Attributes, it is possible to use multiple attributes by combining them
#  * using bitwise OR ('|'). Although, colors cannot be combined. But you can
#  * combine attributes and a single color. See also struct tb_cell's fg and bg
#  * fields.
#  */
# #define TB_BOLD      0x0100
# #define TB_UNDERLINE 0x0200
# #define TB_REVERSE   0x0400
#
# #define TB_OUTPUT_CURRENT   0
# #define TB_OUTPUT_NORMAL    1
# #define TB_OUTPUT_256       2
# #define TB_OUTPUT_216       3
# #define TB_OUTPUT_GRAYSCALE 4
#
# /* Sets the termbox output mode. Termbox has three output options:
#  * 1. TB_OUTPUT_NORMAL     => [1..8]
#  *    This mode provides 8 different colors:
#  *      black, red, green, yellow, blue, magenta, cyan, white
#  *    Shortcut: TB_BLACK, TB_RED, ...
#  *    Attributes: TB_BOLD, TB_UNDERLINE, TB_REVERSE
#  *
#  *    Example usage:
#  *        tb_change_cell(x, y, '@', TB_BLACK | TB_BOLD, TB_RED);
#  *
#  * 2. TB_OUTPUT_256        => [0..256]
#  *    In this mode you can leverage the 256 terminal mode:
#  *    0x00 - 0x07: the 8 colors as in TB_OUTPUT_NORMAL
#  *    0x08 - 0x0f: TB_* | TB_BOLD
#  *    0x10 - 0xe7: 216 different colors
#  *    0xe8 - 0xff: 24 different shades of grey
#  *
#  *    Example usage:
#  *        tb_change_cell(x, y, '@', 184, 240);
#  *        tb_change_cell(x, y, '@', 0xb8, 0xf0);
#  *
#  * 2. TB_OUTPUT_216        => [0..216]
#  *    This mode supports the 3rd range of the 256 mode only.
#  *    But you don't need to provide an offset.
#  *
#  * 3. TB_OUTPUT_GRAYSCALE  => [0..23]
#  *    This mode supports the 4th range of the 256 mode only.
#  *    But you dont need to provide an offset.
#  *
#  * Execute build/src/demo/output to see its impact on your terminal.
#  *
#  * If 'mode' is TB_OUTPUT_CURRENT, it returns the current output mode.
#  *
#  * Default termbox output mode is TB_OUTPUT_NORMAL.
#  */
# SO_IMPORT int tb_select_output_mode(int mode);

if Kernel.respond_to?(:require)
  require "termbox"
  require "cura/color"
end

module Cura
  module Termbox
    # A cached map comparing a color's rgb values with the 256 terminal color codes.
    module ColorMapper
      COLOR_CODES = [
        Color.new(0, 0, 0),
        Color.new(128, 0, 0),
        Color.new(0, 128, 0),
        Color.new(128, 128, 0),
        Color.new(0, 0, 128),
        Color.new(128, 0, 128),
        Color.new(0, 128, 128),
        Color.new(192, 192, 192),
        Color.new(128, 128, 128),
        Color.new(255, 0, 0),
        Color.new(0, 255, 0),
        Color.new(255, 255, 0),
        Color.new(0, 0, 255),
        Color.new(255, 0, 255),
        Color.new(0, 255, 255),
        Color.new(255, 255, 255),
        Color.new(0, 0, 0),
        Color.new(0, 0, 95),
        Color.new(0, 0, 135),
        Color.new(0, 0, 175),
        Color.new(0, 0, 215),
        Color.new(0, 0, 255),
        Color.new(0, 95, 0),
        Color.new(0, 95, 95),
        Color.new(0, 95, 135),
        Color.new(0, 95, 175),
        Color.new(0, 95, 215),
        Color.new(0, 95, 255),
        Color.new(0, 135, 0),
        Color.new(0, 135, 95),
        Color.new(0, 135, 135),
        Color.new(0, 135, 175),
        Color.new(0, 135, 215),
        Color.new(0, 135, 255),
        Color.new(0, 175, 0),
        Color.new(0, 175, 95),
        Color.new(0, 175, 135),
        Color.new(0, 175, 175),
        Color.new(0, 175, 215),
        Color.new(0, 175, 255),
        Color.new(0, 215, 0),
        Color.new(0, 215, 95),
        Color.new(0, 215, 135),
        Color.new(0, 215, 175),
        Color.new(0, 215, 215),
        Color.new(0, 215, 255),
        Color.new(0, 255, 0),
        Color.new(0, 255, 95),
        Color.new(0, 255, 135),
        Color.new(0, 255, 175),
        Color.new(0, 255, 215),
        Color.new(0, 255, 255),
        Color.new(95, 0, 0),
        Color.new(95, 0, 95),
        Color.new(95, 0, 135),
        Color.new(95, 0, 175),
        Color.new(95, 0, 215),
        Color.new(95, 0, 255),
        Color.new(95, 95, 0),
        Color.new(95, 95, 95),
        Color.new(95, 95, 135),
        Color.new(95, 95, 175),
        Color.new(95, 95, 215),
        Color.new(95, 95, 255),
        Color.new(95, 135, 0),
        Color.new(95, 135, 95),
        Color.new(95, 135, 135),
        Color.new(95, 135, 175),
        Color.new(95, 135, 215),
        Color.new(95, 135, 255),
        Color.new(95, 175, 0),
        Color.new(95, 175, 95),
        Color.new(95, 175, 135),
        Color.new(95, 175, 175),
        Color.new(95, 175, 215),
        Color.new(95, 175, 255),
        Color.new(95, 215, 0),
        Color.new(95, 215, 95),
        Color.new(95, 215, 135),
        Color.new(95, 215, 175),
        Color.new(95, 215, 215),
        Color.new(95, 215, 255),
        Color.new(95, 255, 0),
        Color.new(95, 255, 95),
        Color.new(95, 255, 135),
        Color.new(95, 255, 175),
        Color.new(95, 255, 215),
        Color.new(95, 255, 255),
        Color.new(135, 0, 0),
        Color.new(135, 0, 95),
        Color.new(135, 0, 135),
        Color.new(135, 0, 175),
        Color.new(135, 0, 215),
        Color.new(135, 0, 255),
        Color.new(135, 95, 0),
        Color.new(135, 95, 95),
        Color.new(135, 95, 135),
        Color.new(135, 95, 175),
        Color.new(135, 95, 215),
        Color.new(135, 95, 255),
        Color.new(135, 135, 0),
        Color.new(135, 135, 95),
        Color.new(135, 135, 135),
        Color.new(135, 135, 175),
        Color.new(135, 135, 215),
        Color.new(135, 135, 255),
        Color.new(135, 175, 0),
        Color.new(135, 175, 95),
        Color.new(135, 175, 135),
        Color.new(135, 175, 175),
        Color.new(135, 175, 215),
        Color.new(135, 175, 255),
        Color.new(135, 215, 0),
        Color.new(135, 215, 95),
        Color.new(135, 215, 135),
        Color.new(135, 215, 175),
        Color.new(135, 215, 215),
        Color.new(135, 215, 255),
        Color.new(135, 255, 0),
        Color.new(135, 255, 95),
        Color.new(135, 255, 135),
        Color.new(135, 255, 175),
        Color.new(135, 255, 215),
        Color.new(135, 255, 255),
        Color.new(175, 0, 0),
        Color.new(175, 0, 95),
        Color.new(175, 0, 135),
        Color.new(175, 0, 175),
        Color.new(175, 0, 215),
        Color.new(175, 0, 255),
        Color.new(175, 95, 0),
        Color.new(175, 95, 95),
        Color.new(175, 95, 135),
        Color.new(175, 95, 175),
        Color.new(175, 95, 215),
        Color.new(175, 95, 255),
        Color.new(175, 135, 0),
        Color.new(175, 135, 95),
        Color.new(175, 135, 135),
        Color.new(175, 135, 175),
        Color.new(175, 135, 215),
        Color.new(175, 135, 255),
        Color.new(175, 175, 0),
        Color.new(175, 175, 95),
        Color.new(175, 175, 135),
        Color.new(175, 175, 175),
        Color.new(175, 175, 215),
        Color.new(175, 175, 255),
        Color.new(175, 215, 0),
        Color.new(175, 215, 95),
        Color.new(175, 215, 135),
        Color.new(175, 215, 175),
        Color.new(175, 215, 215),
        Color.new(175, 215, 255),
        Color.new(175, 255, 0),
        Color.new(175, 255, 95),
        Color.new(175, 255, 135),
        Color.new(175, 255, 175),
        Color.new(175, 255, 215),
        Color.new(175, 255, 255),
        Color.new(215, 0, 0),
        Color.new(215, 0, 95),
        Color.new(215, 0, 135),
        Color.new(215, 0, 175),
        Color.new(215, 0, 215),
        Color.new(215, 0, 255),
        Color.new(215, 95, 0),
        Color.new(215, 95, 95),
        Color.new(215, 95, 135),
        Color.new(215, 95, 175),
        Color.new(215, 95, 215),
        Color.new(215, 95, 255),
        Color.new(215, 135, 0),
        Color.new(215, 135, 95),
        Color.new(215, 135, 135),
        Color.new(215, 135, 175),
        Color.new(215, 135, 215),
        Color.new(215, 135, 255),
        Color.new(215, 175, 0),
        Color.new(215, 175, 95),
        Color.new(215, 175, 135),
        Color.new(215, 175, 175),
        Color.new(215, 175, 215),
        Color.new(215, 175, 255),
        Color.new(215, 215, 0),
        Color.new(215, 215, 95),
        Color.new(215, 215, 135),
        Color.new(215, 215, 175),
        Color.new(215, 215, 215),
        Color.new(215, 215, 255),
        Color.new(215, 255, 0),
        Color.new(215, 255, 95),
        Color.new(215, 255, 135),
        Color.new(215, 255, 175),
        Color.new(215, 255, 215),
        Color.new(215, 255, 255),
        Color.new(255, 0, 0),
        Color.new(255, 0, 95),
        Color.new(255, 0, 135),
        Color.new(255, 0, 175),
        Color.new(255, 0, 215),
        Color.new(255, 0, 255),
        Color.new(255, 95, 0),
        Color.new(255, 95, 95),
        Color.new(255, 95, 135),
        Color.new(255, 95, 175),
        Color.new(255, 95, 215),
        Color.new(255, 95, 255),
        Color.new(255, 135, 0),
        Color.new(255, 135, 95),
        Color.new(255, 135, 135),
        Color.new(255, 135, 175),
        Color.new(255, 135, 215),
        Color.new(255, 135, 255),
        Color.new(255, 175, 0),
        Color.new(255, 175, 95),
        Color.new(255, 175, 135),
        Color.new(255, 175, 175),
        Color.new(255, 175, 215),
        Color.new(255, 175, 255),
        Color.new(255, 215, 0),
        Color.new(255, 215, 95),
        Color.new(255, 215, 135),
        Color.new(255, 215, 175),
        Color.new(255, 215, 215),
        Color.new(255, 215, 255),
        Color.new(255, 255, 0),
        Color.new(255, 255, 95),
        Color.new(255, 255, 135),
        Color.new(255, 255, 175),
        Color.new(255, 255, 215),
        Color.new(255, 255, 255),
        Color.new(8, 8, 8),
        Color.new(18, 18, 18),
        Color.new(28, 28, 28),
        Color.new(38, 38, 38),
        Color.new(48, 48, 48),
        Color.new(58, 58, 58),
        Color.new(68, 68, 68),
        Color.new(78, 78, 78),
        Color.new(88, 88, 88),
        Color.new(96, 96, 96),
        Color.new(102, 102, 102),
        Color.new(118, 118, 118),
        Color.new(128, 128, 128),
        Color.new(138, 138, 138),
        Color.new(148, 148, 148),
        Color.new(158, 158, 158),
        Color.new(168, 168, 168),
        Color.new(178, 178, 178),
        Color.new(188, 188, 188),
        Color.new(198, 198, 198),
        Color.new(208, 208, 208),
        Color.new(218, 218, 218),
        Color.new(228, 228, 228),
        Color.new(238, 238, 238)
      ]

      CACHE = {}

      class << self
        # Find the closest terminal color code from the given RGB values.
        #
        # @param [#to_i] number_of_colors The number of colors in the code list to search. 9 is Termbox without 256 colors enabled I.E. 3-bit.
        # @return [Integer]
        def code(color, _number_of_colors=256)
          code = CACHE[color.hex]

          if code.nil?
            # code = find_closest_code(rgb, number_of_colors)

            distances = COLOR_CODES.map { |code| code - color }
            code = distances.each_with_index.min[1]

            CACHE[color.hex] = code
          end

          code
        end

        protected

        def find_closest_code(rgb, number_of_colors=256)
          last = nil
          COLOR_CODES.first(number_of_colors).each_with_index do |color, code|
            difference = compare_rgb_array(rgb, color)

            last = { difference: difference, code: code } if last.nil? || difference < last[:difference]
          end

          last.nil? ? nil : last[:code]
        end

        def compare_rgb_array(a1, a2)
          Math.sqrt(
            (a1[0] - a2[0]).abs ^ 2 +
            (a1[1] - a2[1]).abs ^ 2 +
            (a1[2] - a2[2]).abs ^ 2
          )
        end
      end
    end
  end
end
