module Cura
  module Termbox
    module Component
      
      module Base
        
        def self.included(base)
          base.instance_eval do
            remove_method(:foreground)
            remove_method(:background)
          end
        end
        
        # Get the foreground color of this component.
        #
        # @return [Color]
        def foreground
          get_or_inherit_color(:foreground, Cura::Color.white)
        end
        
        # Get the background color of this component.
        #
        # @return [Color]
        def background
          get_or_inherit_color(:background, Cura::Color.black)
        end
        
      end
      
    end
  end
end
