# encoding: utf-8
# Name: 101.Game_Temp
# Size: 1413
class Game_Temp
  attr_accessor :pop_windowdata, :loadingg
  attr_accessor :event_window_data
  attr_accessor :scene_status_index
  attr_accessor :scene_status_oy
  attr_accessor :storage_gold
  attr_accessor :storage_category
  attr_accessor :storage_name_window
  attr_accessor :eds_actor
  attr_accessor :scene_equip_index
  attr_accessor :scene_equip_oy
  attr_accessor :call_distribute_parameter  # 분배 화면 호출 플래그
  attr_accessor :call_menu                  # 기본 매뉴 수정 호출 플래그
  attr_accessor :menu_actor_index           # 각종 메뉴 화면용 액터 index

  alias bravo_storage_initialize initialize
  def initialize
    bravo_storage_initialize
    print("101.Game_Temp - ");
    print("생성 \n");
    @storage_gold = true
    @storage_category = true
    @storage_name_window = true
    @call_distribute_parameter = false      # 레벨 포인트 메뉴창
    @call_menu = true                       # 기본 매뉴 수정 호출 플래그
    @menu_actor_index = 0
  end
  
  def pop_w(time, name, text)
    return unless @pop_windowdata.nil?
    @pop_windowdata = [time, text, name]
  end
  
  def add_event_window_data(text)
    @event_window_data = [] if @event_window_data.nil?
    return if text == ""
    @event_window_data.push(text)
  end
  
  def clear_event_window_data
    @event_window_data = []
  end
end