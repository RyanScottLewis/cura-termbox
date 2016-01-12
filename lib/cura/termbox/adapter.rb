if Kernel.respond_to?(:require)
  require "cura/adapter"
  
  require "cura/event/key_down"
  require "cura/event/mouse_button"
  require "cura/event/mouse_wheel_down"
  require "cura/event/mouse_wheel_up"
  require "cura/event/resize"
  
  require "cura/termbox/error/unsupported_terminal"
  require "cura/termbox/error/failed_to_open_tty"
  require "cura/termbox/error/pipe_trap_error"
  require "cura/termbox/error/not_running"
  
  require "cura/termbox/component/base"
  
  require "cura/termbox/pencil"
  require "cura/termbox/window"
  
  require "termbox"
end

module Cura
  module Termbox
    
    # Cura adapter for Termbox.
    class Adapter < Cura::Adapter
      
      mixin Cura::Pencil => Termbox::Pencil
      mixin Cura::Window => Termbox::Window
      mixin Cura::Component::Base => Termbox::Component::Base
      
      def setup
        case ::Termbox.tb_init
          when ::Termbox::TB_EUNSUPPORTED_TERMINAL then raise Termbox::Error::UnsupportedTerminal
          when ::Termbox::TB_EFAILED_TO_OPEN_TTY   then raise Termbox::Error::FailedToOpenTTY
          when ::Termbox::TB_EPIPE_TRAP_ERROR      then raise Termbox::Error::PipeTrapError
        end
        
        ::Termbox.tb_select_input_mode(::Termbox::TB_INPUT_ESC | ::Termbox::TB_INPUT_MOUSE)
        # ::Termbox.tb_select_output_mode(::Termbox::TB_OUTPUT_216)
        ::Termbox.tb_select_output_mode(::Termbox::TB_OUTPUT_256)

        super
      end
      
      def clear
        ::Termbox.tb_clear
      end
      
      def present
        ::Termbox.tb_present
      end
      
      def cleanup
        ::Termbox.tb_shutdown
        
        super
      end
      
      def set_cursor(x, y)
        ::Termbox.tb_set_cursor(x, y)
      end
      
      def hide_cursor
        ::Termbox.tb_set_cursor(::Termbox::TB_HIDE_CURSOR, ::Termbox::TB_HIDE_CURSOR)
      end
      
      def poll_event
        event = ::Termbox::Event.new
        ::Termbox.tb_poll_event(event)
        
        convert_termbox_event_to_cura_event(event)
      end
      
      def peek_event(milliseconds)
        event = ::Termbox::Event.new
        ::Termbox.tb_peek_event(event, milliseconds)
        
        convert_termbox_event_to_cura_event(event)
      end
      
      protected
      
      def convert_termbox_event_to_cura_event(event)
        return nil if event.nil? # TODO: Would it even be nil? Wouldnt it be -1 on errors?
        
        event = case event[:type]
          when ::Termbox::TB_EVENT_KEY
            if event[:key] != 0
              name = convert_termbox_key_to_cura_key_name(event[:key])
              
              name.nil? ? convert_termbox_control_key_to_cura_event(event[:key]) : Event::KeyDown.new(name: name)
            elsif event[:ch] != 0
              character = event[:ch].chr
              key_name = Cura::Key.name_from_character(character)
              
              Event::KeyDown.new(name: key_name)
            end
          when ::Termbox::TB_EVENT_MOUSE
            case event[:key]
              when ::Termbox::TB_KEY_MOUSE_LEFT       then Event::MouseButton.new(name: :left, state: :down, x: event[:x], y: event[:y])
              when ::Termbox::TB_KEY_MOUSE_MIDDLE     then Event::MouseButton.new(name: :middle, state: :down, x: event[:x], y: event[:y])
              when ::Termbox::TB_KEY_MOUSE_RIGHT      then Event::MouseButton.new(name: :right, state: :down, x: event[:x], y: event[:y])
              when ::Termbox::TB_KEY_MOUSE_RELEASE    then Event::MouseButton.new(state: :up, x: event[:x], y: event[:y])
              when ::Termbox::TB_KEY_MOUSE_WHEEL_UP   then Event::MouseWheelUp.new(x: event[:x], y: event[:y])
              when ::Termbox::TB_KEY_MOUSE_WHEEL_DOWN then Event::MouseWheelDown.new(x: event[:x], y: event[:y])
            end
          when ::Termbox::TB_EVENT_RESIZE then Event::Resize.new(width: event[:w], height: event[:h])
        end
        
        event
      end
      
      def convert_termbox_control_key_to_cura_event(key)
        case key
          # when ::Termbox::TB_KEY_CTRL_2                  then Event::KeyDown.new( name: :"2", control: true ) # clash with 'CTRL_TILDE'
          # when ::Termbox::TB_KEY_CTRL_3                  then Event::KeyDown.new( name: :"3", control: true ) # clash with 'ESC'
          # when ::Termbox::TB_KEY_CTRL_4                  then Event::KeyDown.new( name: :"4", control: true ) # clash with 'CTRL_BACKSLASH'
          # when ::Termbox::TB_KEY_CTRL_5                  then Event::KeyDown.new( name: :"5", control: true ) # clash with 'CTRL_RSQ_BRACKET'
          when ::Termbox::TB_KEY_CTRL_6                  then Event::KeyDown.new(name: :"6", control: true)
          # when ::Termbox::TB_KEY_CTRL_7                  then Event::KeyDown.new( name: :"7", control: true ) # clash with 'CTRL_SLASH' # clash with 'CTRL_UNDERSCORE'
          # when ::Termbox::TB_KEY_CTRL_8                  then Event::KeyDown.new( name: :"8", control: true ) # clash with 'TB_KEY_BACKSPACE2'
          when ::Termbox::TB_KEY_CTRL_A                  then Event::KeyDown.new(name: :A, control: true)
          when ::Termbox::TB_KEY_CTRL_B                  then Event::KeyDown.new(name: :B, control: true)
          when ::Termbox::TB_KEY_CTRL_C                  then Event::KeyDown.new(name: :C, control: true)
          when ::Termbox::TB_KEY_CTRL_D                  then Event::KeyDown.new(name: :D, control: true)
          when ::Termbox::TB_KEY_CTRL_E                  then Event::KeyDown.new(name: :E, control: true)
          when ::Termbox::TB_KEY_CTRL_F                  then Event::KeyDown.new(name: :F, control: true)
          when ::Termbox::TB_KEY_CTRL_G                  then Event::KeyDown.new(name: :G, control: true)
          # when ::Termbox::TB_KEY_CTRL_H                  then Event::KeyDown.new( name: :H, control: true ) # clash with 'CTRL_BACKSPACE'
          # when ::Termbox::TB_KEY_CTRL_I                  then Event::KeyDown.new( name: :I, control: true ) # clash with 'TAB'
          when ::Termbox::TB_KEY_CTRL_J                  then Event::KeyDown.new(name: :J, control: true)
          when ::Termbox::TB_KEY_CTRL_K                  then Event::KeyDown.new(name: :K, control: true)
          when ::Termbox::TB_KEY_CTRL_L                  then Event::KeyDown.new(name: :L, control: true)
          # when ::Termbox::TB_KEY_CTRL_M                  then Event::KeyDown.new( name: :M, control: true ) # clash with 'ENTER'
          when ::Termbox::TB_KEY_CTRL_N                  then Event::KeyDown.new(name: :N, control: true)
          when ::Termbox::TB_KEY_CTRL_O                  then Event::KeyDown.new(name: :O, control: true)
          when ::Termbox::TB_KEY_CTRL_P                  then Event::KeyDown.new(name: :P, control: true)
          when ::Termbox::TB_KEY_CTRL_Q                  then Event::KeyDown.new(name: :Q, control: true)
          when ::Termbox::TB_KEY_CTRL_R                  then Event::KeyDown.new(name: :R, control: true)
          when ::Termbox::TB_KEY_CTRL_S                  then Event::KeyDown.new(name: :S, control: true)
          when ::Termbox::TB_KEY_CTRL_T                  then Event::KeyDown.new(name: :T, control: true)
          when ::Termbox::TB_KEY_CTRL_U                  then Event::KeyDown.new(name: :U, control: true)
          when ::Termbox::TB_KEY_CTRL_V                  then Event::KeyDown.new(name: :V, control: true)
          when ::Termbox::TB_KEY_CTRL_W                  then Event::KeyDown.new(name: :W, control: true)
          when ::Termbox::TB_KEY_CTRL_X                  then Event::KeyDown.new(name: :X, control: true)
          when ::Termbox::TB_KEY_CTRL_Y                  then Event::KeyDown.new(name: :Y, control: true)
          when ::Termbox::TB_KEY_CTRL_Z                  then Event::KeyDown.new(name: :Z, control: true)
          when ::Termbox::TB_KEY_CTRL_BACKSLASH          then Event::KeyDown.new(name: :backslash, control: true) # clash with 'CTRL_4'
          when ::Termbox::TB_KEY_CTRL_LSQ_BRACKET        then Event::KeyDown.new(name: :left_bracket, control: true) # clash with 'ESC'
          when ::Termbox::TB_KEY_CTRL_RSQ_BRACKET        then Event::KeyDown.new(name: :right_bracket, control: true) # clash with 'CTRL_5'
          when ::Termbox::TB_KEY_CTRL_SLASH              then Event::KeyDown.new(name: :slash, control: true) # clash with 'CTRL_7'
          when ::Termbox::TB_KEY_CTRL_TILDE              then Event::KeyDown.new(name: :tilde, control: true) # clash with 'CTRL_2'
          when ::Termbox::TB_KEY_CTRL_UNDERSCORE         then Event::KeyDown.new(name: :underscore, control: true) # clash with 'CTRL_7' # clash with 'CTRL_SLASH'
        end
      end
      
      def convert_termbox_key_to_cura_key_name(key)
        case key
          when ::Termbox::TB_KEY_F1          then :f1
          when ::Termbox::TB_KEY_F2          then :f2
          when ::Termbox::TB_KEY_F3          then :f3
          when ::Termbox::TB_KEY_F4          then :f4
          when ::Termbox::TB_KEY_F5          then :f5
          when ::Termbox::TB_KEY_F6          then :f6
          when ::Termbox::TB_KEY_F7          then :f7
          when ::Termbox::TB_KEY_F8          then :f8
          when ::Termbox::TB_KEY_F9          then :f9
          when ::Termbox::TB_KEY_F10         then :f10
          when ::Termbox::TB_KEY_F11         then :f11
          when ::Termbox::TB_KEY_F12         then :f12
          when ::Termbox::TB_KEY_F12         then :f12
          when ::Termbox::TB_KEY_INSERT      then :insert
          when ::Termbox::TB_KEY_DELETE      then :delete
          when ::Termbox::TB_KEY_HOME        then :home
          when ::Termbox::TB_KEY_END         then :end
          when ::Termbox::TB_KEY_PGUP        then :page_up
          when ::Termbox::TB_KEY_PGDN        then :page_down
          when ::Termbox::TB_KEY_ARROW_UP    then :up
          when ::Termbox::TB_KEY_ARROW_DOWN  then :down
          when ::Termbox::TB_KEY_ARROW_LEFT  then :left
          when ::Termbox::TB_KEY_ARROW_RIGHT then :right
          when ::Termbox::TB_KEY_BACKSPACE   then :backspace
          when ::Termbox::TB_KEY_BACKSPACE2  then :backspace
          when ::Termbox::TB_KEY_ENTER       then :enter
          when ::Termbox::TB_KEY_ESC         then :escape
          when ::Termbox::TB_KEY_SPACE       then :space
          when ::Termbox::TB_KEY_TAB         then :tab
        end
      end
      
    end
    
  end
end
