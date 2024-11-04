# encoding: utf-8
# Name: 147.Sprite_Light
# Size: 2406
class Sprite_Light < Sprite_Base
  attr_reader :lights
  
  def initialize(shade, viewport)
    super(viewport)
    @shade = shade
    self.bitmap     = Bitmap.new(Graphics.width, Graphics.height)
    self.blend_type = @shade.blend
    self.opacity    = @shade.opacity
    self.z = 0
    @lights = {}
  end
  
  def map_x
    $game_map.adjust_x($game_map.display_x)
  end
  
  def map_y
    $game_map.adjust_y($game_map.display_y) 
  end
  
  def update
    super
    # --------------------------------------------------------------------------
    # 아래는 시간 가속중이 아닌 경우에만 적용
    # --------------------------------------------------------------------------
    if $game_switches[283] == false
      self.ox = map_x
      self.oy = map_y
      update_opacity
      update_lights
    end
  end
  
  def update_lights
    rect = Rect.new(map_x, map_y, Graphics.width, Graphics.height)
    self.bitmap.fill_rect(rect, color)
    draw_light_effects
  end
  
  def color
    @shade.color
  end
  
  def draw_light_effects
    @lights.values.each do |light|
      light.update
      next if !on_screen?(light)
      draw_light(light)
    end
  end
  
  def on_screen?(light)
    if light.x != nil and light.y != nil
      ax1 = light.x
      ay1 = light.y
      ax2 = light.x + light.width
      ay2 = light.y + light.height
      bx1 = map_x
      by1 = map_y
      bx2 = map_x + Graphics.width
      by2 = map_y + Graphics.height
      check1 = ax1.between?(bx1, bx2) || ax2.between?(bx1, bx2) ||
               ax1 < bx1 && ax2 > bx2
      check2 = ay1.between?(by1, by2) || ay2.between?(by1, by2) ||
               ay1 < by1 && ay2 > by2
      check1 && check2
    end
  end
  
  def draw_light(light)
    img  = light.bitmap
    rect = Rect.new(light.x, light.y, light.width, light.height)
    self.bitmap.stretch_blt(rect, img, img.rect, light.opacity)
  end
  
  def update_opacity
    @shade.update
    self.opacity    = @shade.opacity
    self.blend_type = @shade.blend
  end
  
  def create_light(light)
    remove_light(light.id)
    @lights[light.id] = Game_LightBitmap.new(light)
  end
  
  def remove_light(id)
    @lights.delete(id) if @lights[id]
  end
  
  def dispose
    super
    @lights.values.each {|light| light.dispose unless light.bitmap.disposed? }
  end
end