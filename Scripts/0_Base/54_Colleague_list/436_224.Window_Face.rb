# encoding: utf-8
# Name: 224.Window_Face
# Size: 1541
class Window_Face < Window_Base
  alias :bm_menu_init :initialize
  def initialize
    super(0, 0, 160, Graphics.height - 72)
    @actor = nil
    alignment = 0
    # 메뉴 배경을 반투명하게 변경
    self.back_opacity = 192
    create_background
    refresh
  end
  
  # 메뉴 배경을 반투명하게 변경
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
  
  def dispose_background
    @background_sprite.dispose
  end
  
  #--------------------------------------------------------------------------
  # ● 윈도우폭의 취득
  #--------------------------------------------------------------------------
  def window_width
    return 160
  end
  
  def refresh
    contents.clear
    if @actor
      $game_variables[126] = @actor.id
      draw_actor_portrait3(@actor, 14, -10, enabled = true)
      if Graphics.height == 640
        ro_heit = 49
      elsif Graphics.height == 704
        ro_heit = 84
      else
        ro_heit = 0
      end
      text2 = sprintf("%s",@actor.skill_point)
      draw_text(25, line_height * 13 + 17 + ro_heit, width = 160, line_height, text2)
      text3 = sprintf("%s",@actor.skill_point2)
      draw_text(25, line_height * 16 + 23 + ro_heit, width = 160, line_height, text3)
    end
  end
  
  def open
    refresh
    super
  end
  
  def actor=(actor)
    @actor = actor
    refresh
  end
end