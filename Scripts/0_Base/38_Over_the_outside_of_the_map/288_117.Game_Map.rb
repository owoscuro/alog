# encoding: utf-8
# Name: 117.Game_Map
# Size: 312
class Game_Map
  def scroll_down(distance)
    @display_y += distance
    @display_y %= @map.height * 256
    @parallax_y += distance if @parallax_loop_y
  end
  
  def scroll_right(distance)
    @display_x += distance
    @display_x %= @map.width * 256
    @parallax_x += distance if @parallax_loop_x
  end
end