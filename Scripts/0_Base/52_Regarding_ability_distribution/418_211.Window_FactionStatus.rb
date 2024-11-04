# encoding: utf-8
# Name: 211.Window_FactionStatus
# Size: 1941
class Window_FactionStatus < Window_Base
  attr_reader :faction
  def initialize
    h = fitting_height(1)
    super(0,Graphics.height-h,Graphics.width, h)
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
  
  def faction=(faction)
    @faction=faction
    # 메뉴 배경을 반투명하게 변경
    self.back_opacity = 192
    create_background
    refresh
  end
  
  def refresh
    contents.clear
    return unless @faction
    draw_reputation
    #draw_reputation_text
  end
  
  def draw_reputation
    draw_rep_gauge(10, 0, contents.width - 20, line_height-8, @faction.reputation.to_f/SZS_Factions::MaxReputation, hp_gauge_color1, hp_gauge_color2)
    change_color(system_color)
    #draw_current_and_max_values4(96, 0, 232, @faction.reputation, SZS_Factions::MaxReputation, normal_color, normal_color)
    draw_current_and_max_values4(0, 0, contents.width, @faction.reputation, SZS_Factions::MaxReputation, normal_color, normal_color)
  end
  
  def draw_rep_gauge(x, y, width, height, rate, color1, color2)
    rate = 1 if rate > 1
    fill_w = (width * rate).to_i
    gauge_y = y+(line_height-height)/2
    contents.fill_rect(x, gauge_y, width, height, gauge_back_color)
    contents.gradient_fill_rect(x, gauge_y, fill_w, height, 
    SZS_Factions::Levels[faction.level][:bar_color1] || SZS_Factions::Default_BarColor1, 
    SZS_Factions::Levels[faction.level][:bar_color2] || SZS_Factions::Default_BarColor2)
  end
  
  def draw_reputation_text
    x = contents.width/3*2+8
    txt = SZS_Factions::Levels[faction.level][:name]
    fc = Color.new(0,0,0,96)
    draw_text(x,-2,contents.width-x,line_height, txt,1)
  end
end