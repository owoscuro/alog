# encoding: utf-8
# Name: 133.Game_LightBitmap
# Size: 2587
class Game_LightBitmap
  attr_reader   :light
  attr_reader   :bitmap
  attr_reader   :opacity
  attr_reader   :x
  attr_reader   :y
  
  def initialize(light)
    @light = light
    init_basic
    update
  end
  
  def init_basic
    @bitmap   = Cache.lights(@light.name)
    @target   = set_target
    @opacity  = @light.opacity
    @speed    = @light.speed
    #@variance = 0.0
    @light.opacity_duration = 0
    @light.opacity_target   = 0
  end
  
  def width
    @bitmap.width * @light.zoom / 100.0
  end
  
  def height
    @bitmap.height * @light.zoom / 100.0
  end
  
  def update
    # --------------------------------------------------------------------------
    # 아래는 시간 가속중이 아닌 경우에만 적용
    # --------------------------------------------------------------------------
    if $game_switches[283] == false
      update_position
      update_opacity
      #update_variance
    end
  end
  
  def update_position
    @target.is_a?(Game_Character) ? character_position : map_position
  end
  
  def character_position
    @x = $game_map.adjust_x(@target.real_x) * 32  - width / 2  + @light.x + 16
    @y = $game_map.adjust_y(@target.real_y) * 32  - height / 2 + @light.y + 16
  end
  
  def map_position
    if @target != nil
      @x = $game_map.adjust_x(@target[:x]) * 32 - width / 2  + @light.x + 16
      @y = $game_map.adjust_y(@target[:y]) * 32 - height / 2 + @light.y + 16
    end
  end
  
  def change_opacity(op, d)
    @light.opacity_target   = op
    @light.opacity_duration = [d, 0].max
    @light.opacity = @light.opacity_target if @light.opacity_duration == 0
  end
  
  def update_opacity
    return if @light.opacity_duration == 0
    d = @light.opacity_duration
    @light.opacity = (@light.opacity * (d - 1) + @light.opacity_target) / d
    @light.opacity_duration -= 1
  end
  
=begin
  def update_variance
    @variance += @speed 
    @speed *= -1 if @variance.abs > @light.variance.abs
    @opacity = [[@light.opacity + @variance, 0].max, 255].min
  end
=end

  def dispose
    @bitmap.dispose
  end
  
  def set_target
    if @light.info.keys.include?(:actor)
      n = @light.info[:actor] == 0 ? 0 : @light.info[:actor] - 1
      target = $game_map.actors[n]
    elsif @light.info.keys.include?(:event)
      target = $game_map.events[@light.info[:event]]
    elsif @light.info.keys.include?(:vehicle)
      target = $game_map.vehicles[@light.info[:vehicle]]
    else
      target = @light.info
    end
    target
  end
end