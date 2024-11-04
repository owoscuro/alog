# encoding: utf-8
# Name: 215.Window_Help_Map
# Size: 1040
class Window_Help_Map < Window_Base
  include Lune_Map
  def initialize
    super(0, Graphics.height - 90, Graphics.width, Graphics.height)
    self.opacity = 0
    refresh(nil)
  end
  
  def refresh(index)
    unless index == nil
      self.contents.clear
      colour = Color.new(0, 0, 0, translucent_alpha/2)
      
      rect = Rect.new(0, - 15, Graphics.width, fitting_height(1))
      contents.fill_rect(rect, colour)

      rect = Rect.new(0, 15, Graphics.width, fitting_height(1))
      contents.fill_rect(rect, colour)
      
      contents.font.name = "한컴 윤체 L"
      contents.font.size = 26
      contents.font.bold = true
      contents.font.color = (text_color(3))
      draw_text(10, - 10, Graphics.width, fitting_height(1), $lune_map_info[index]['Desc'], 0)
      
      contents.font.bold = false
      contents.font.color = (text_color(0))
      contents.font.size = 22
      draw_text(10, 20, Graphics.width, fitting_height(1), $lune_map_info[index]['Desc2'], 0)
    end
  end
end