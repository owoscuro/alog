# encoding: utf-8
# Name: 166.Window_EventWindow 
# Size: 2469
class Window_EventWindow < Window_Selectable
  def initialize
    dw = YEA::EVENT_WINDOW::WINDOW_WIDTH
    super(0, -0, dw, fitting_height(YEA::EVENT_WINDOW::MAX_LINES))
    self.x -= 12
    self.opacity = 0
    self.contents_opacity = 0
    self.z = 1001
    @visible_counter = 0
    modify_skin
    deactivate
  end
  
  def modify_skin
    dup_skin = self.windowskin.dup
    dup_skin.clear_rect(64,  0, 64, 64)
    dup_skin.clear_rect(64, 64, 32, 32)
    self.windowskin = dup_skin
  end
  
  def item_max
    return $game_temp.event_window_data ? $game_temp.event_window_data.size : 1
  end
  
  def update
    super
    self.visible = show_window?
    update_visible_counter
    update_contents_opacity
  end
  
  def show_window?
    # H 씬 진행중이면 아이템 획득 로그 생략
    return false if $game_switches[189] == true # 추가
    return false if $game_message.visible
    return true
  end
  
  def update_visible_counter
    return if @visible_counter <= 0
    if @visible_counter == YEA::EVENT_WINDOW::VISIBLE_TIME
      RPG::SE.new("Item3", 100).play rescue nil
    end
    @visible_counter -= 1
  end
  
  def update_contents_opacity
    return if @visible_counter > 0
    return if self.contents_opacity <= 0
    self.contents_opacity -= YEA::EVENT_WINDOW::WINDOW_FADE
  end
  
  def instant_hide
    @visible_counter = 0
    self.contents_opacity = 0
  end
  
  def add_text(text)
    $game_temp.add_event_window_data(text)
    refresh
    self.contents_opacity = 255
    @visible_counter = YEA::EVENT_WINDOW::VISIBLE_TIME
    change_y_position
    select(item_max - 1)
  end
  
  def change_y_position
    maximum = [item_max, YEA::EVENT_WINDOW::MAX_LINES].min
    self.y = Graphics.height - fitting_height(maximum) - 12 - 50
  end
  
  def refresh
    create_contents
    draw_all_items
  end
  
  def draw_item(index)
    #return if index.nil?
    $game_temp.clear_event_window_data if $game_temp.event_window_data.nil?
    item = $game_temp.event_window_data[index]
    return if item.nil?
    rect = item_rect(index)
    draw_background(rect)
    rect.x += 4
    rect.width -= 8
    # 아래가 원본
    draw_text_ex(rect.x, rect.y, item)
  end
  
  def draw_background(rect)
    back_colour1 = Color.new(0, 0, 0, 96)
    back_colour2 = Color.new(0, 0, 0, 0)
    contents.gradient_fill_rect(rect, back_colour1, back_colour2)
  end
end