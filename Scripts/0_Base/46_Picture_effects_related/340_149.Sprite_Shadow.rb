# encoding: utf-8
# Name: 149.Sprite_Shadow
# Size: 2175
class Sprite_Shadow < Sprite_Character
  def initialize(viewport, character = nil, source)
    @flicker = 0
    @famount = 0
    @aamount = 0
    @source = source
    super(viewport, character)
  end
  
  def blend_update
  end
  
  def setup_new_effect
  end

  def set_character_bitmap
    # 그림자의 그래픽 이름
    self.bitmap = Cache.character(@character_name)
    # 아래 추가, 그래픽이 없으면 진행하지 않는다.
    if @character_name != "" and @character_name != nil
      self.color = Color.new(0, 0, 0, 255)
      self.z = Galv_CEffects::SHADOW_Z
      self.wave_amp = 1 if $game_map.shadow_options[2]
      self.wave_speed = 1000
    end
    sign = @character_name[/^[\!\$]./]
    if sign && sign.include?('$')
      @cw = bitmap.width / 3
      @ch = bitmap.height / 4
    else
      @cw = bitmap.width / 12
      @ch = bitmap.height / 8
    end
    self.ox = @cw / 2
    self.oy = @ch
  end

  def update_position
    self.x = @character.screen_x
    self.y = @character.screen_y - 10
    if $game_map.light_source[@source] != nil
      get_angle #if Graphics.frame_count % 2 == 0
    else
      self.opacity = 0
    end
  end

  def get_angle
    x = $game_map.light_source[@source][0] - @character.real_x
    y = $game_map.light_source[@source][1] - @character.real_y
    #print("149.Sprite_Shadow - %s, %s \n" % [@source.x, @source.y]);
    self.opacity = $game_map.shadow_options[0] - Math::sqrt(x * x + y * y) * $game_map.shadow_options[1]
    if x == 0 && y == 0 || self.opacity <= 0
    # 제거 실험
    #elsif x >= 20 or y >= 20 or -20 >= x or -20 >= y
    #  self.bitmap.dispose
    else
      self.angle = Math::atan2(x, y) * 180 / Math::PI + @aamount
      self.zoom_y = 1
      if 70 >= self.opacity
        self.zoom_y = self.zoom_y * (self.opacity * 0.02)
      else
        self.zoom_y = self.zoom_y * ((140 - self.opacity) * 0.02)
      end
    end
  end
  
  def update_facing
    if @character.y < $game_map.light_source[@source][1]
      self.mirror = false
    else
      self.mirror = true
    end
  end
  
  def update_other
  end
end