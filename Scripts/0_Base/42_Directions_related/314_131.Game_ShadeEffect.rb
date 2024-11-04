# encoding: utf-8
# Name: 131.Game_ShadeEffect
# Size: 2049
class Game_ShadeEffect
  attr_reader   :visible
  attr_reader   :color
  attr_accessor :blend
  attr_accessor :opacity
  
  def initialize
    init_opacity
    init_color
  end
  
  def init_opacity
    @visible = false
    @opacity = 0
    @opacity_target   = 0
    @opacity_duration = 0
  end
  
  def init_color
    @blend = 0
    @color = Color.new(0, 0, 0, 0)
    @color_duration = 0
    @color_target   = Color.new(0, 0, 0, 0)
  end
  
  def show
    @visible = true
  end
  
  def hide
    @visible = false
  end
  
  def set_color(r = 0, g = 0, b = 0)
    @color        = get_colors(r, g, b)
    @color_target = @color.clone
  end
  
  def change_opacity(op, d)
    @opacity_target   = op
    @opacity_duration = [d, 0].max
    @opacity = @opacity_target if @opacity_duration == 0
  end
  
  def change_color(r, g, b, d)
    @color_target   = get_colors(r, g, b)
    @color_duration = [d, 0].max
    @color = @color_target.clone if @color_duration == 0
  end
  
  def get_colors(r, g, b)
    color = Color.new(255 - r, 255 - g, 255 - b, 255) if @blend == 2
    color = Color.new(r, g, b, 255) if @blend != 2
    color
  end
  
  def update
    # --------------------------------------------------------------------------
    # 아래는 시간 가속중이 아닌 경우에만 적용
    # --------------------------------------------------------------------------
    if $game_switches[283] == false
      update_opacity
      update_color
    end
  end
  
  def update_opacity
    return if @opacity_duration == 0
    d = @opacity_duration
    @opacity = (@opacity * (d - 1) + @opacity_target) / d
    @opacity_duration -= 1
  end
  
  def update_color
    return if @color_duration == 0
    d = @color_duration
    @color.red   = (@color.red   * (d - 1) + @color_target.red)   / d
    @color.green = (@color.green * (d - 1) + @color_target.green) / d
    @color.blue  = (@color.blue  * (d - 1) + @color_target.blue)  / d
    @color_duration -= 1
  end
end