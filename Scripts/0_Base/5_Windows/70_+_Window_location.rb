# encoding: utf-8
# Name: + Window_location
# Size: 4783
# encoding: utf-8
# Name: + Window_location
# Size: 4583
class Window_location < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(0, 0, window_width, 72)
    draw_item_time
  end
  
  def window_width
    Graphics.width
  end

  def refresh
    draw_item_time
  end
  
  #--------------------------------------------------------------------------
  # * draw item
  #--------------------------------------------------------------------------
  def draw_item_time
    contents.clear if contents != nil
    
    sw = Graphics.width / 2
    
    text1 = Lang::TEXTS[:interface][:window_location][:location]
    text2 = location?
    # 지역
    change_color(system_color)
    draw_text(4, 0, sw, line_height, text1, 0)
    change_color(normal_color)
    draw_text(4, 0, sw - 50, line_height, text2, 2)
    
    # 몇일
    text6 = Lang::TEXTS[:interface][:window_location][:date]
    change_color(system_color)
    draw_text(sw, 0, sw, 24, text6, 0)
    
    change_color(normal_color)
    text7 = HM_SEL::top_calendar_line2?
    text7 = text7.to_s
    draw_text(sw, 0, sw - 50, 24, text7, 2)
    
    text3 = Lang::TEXTS[:interface][:window_location][:playing_time]
    text4 = game_time
    
    # 플레이 시간
    change_color(system_color)
    draw_text(4, line_height, sw, line_height, text3, 0)
    change_color(normal_color)
    draw_text(4, line_height, sw - 50, line_height, text4, 2)
    
    # 시간 값
    text3_2 = Lang::TEXTS[:interface][:window_location][:time]
    change_color(system_color)
    draw_text(sw, line_height, sw, line_height, text3_2, 0)
    text4_2 = $game_variables[HM_SEL::MIN]
    if $game_variables[HM_SEL::HOUR] >= 12
      if $game_variables[HM_SEL::HOUR] >= 13
        text4 = $game_variables[HM_SEL::HOUR] - 12
      else
        text4 = $game_variables[HM_SEL::HOUR]
      end
      text4 = text4.to_s + 'h ' + text4_2.to_s + 'min (PM)'
    else
      text4 = $game_variables[HM_SEL::HOUR]
      text4 = text4.to_s + 'h ' + text4_2.to_s + 'min (AM)'
    end
    change_color(normal_color)
    draw_text(sw, line_height, sw - 50, line_height, text4, 2)
  end
  
  #--------------------------------------------------------------------------
  # * location
  #--------------------------------------------------------------------------
  def location?
    # 구매한 땅, 엑터 이름으로 지정
    if $game_map.map_id == 141
      text  = $game_actors[18].name
      return text
    elsif $game_map.map_id == 144
      text  = $game_actors[17].name
      return text
    # 세라이튼 집
    elsif $game_map.map_id == 398 or $game_map.map_id == 399
      text  = $game_map.display_name
      #text  = $game_actors[16].name if $game_self_switches[[395, 13, "A"]] and $game_map.map_id == 399
      #text  = $game_actors[16].name if $game_self_switches[[395, 12, "A"]] and $game_map.map_id == 398
      text  = $game_actors[16].name if $game_variables[147] == $game_map.map_id
      return text
    # 바일라스 집
    elsif $game_map.map_id == 403 or $game_map.map_id == 404
      text  = $game_map.display_name
      #text  = $game_actors[16].name if $game_self_switches[[76, 36, "A"]] and ($game_map.map_id == 403 or $game_map.map_id == 404)
      text  = $game_actors[16].name if $game_variables[147] == $game_map.map_id
      text  = $game_actors[16].name if $game_variables[147] + 1 == $game_map.map_id
      return text
    # 슬라인 집
    elsif $game_map.map_id == 400
      text  = $game_map.display_name
      #text  = $game_actors[16].name if $game_self_switches[[264, 8, "A"]] and $game_map.map_id == 400
      text  = $game_actors[16].name if $game_variables[147] == $game_map.map_id
      return text
    # 팔세린 집
    elsif $game_map.map_id == 316 or $game_map.map_id == 272
      text  = $game_map.display_name
      #text  = $game_actors[16].name if $game_self_switches[[264, 8, "A"]] and $game_map.map_id == 316
      #text  = $game_actors[16].name if $game_self_switches[[264, 9, "A"]] and $game_map.map_id == 272
      text  = $game_actors[16].name if $game_variables[147] == $game_map.map_id
      return text
    elsif $game_map.display_name != nil
      return $game_map.display_name
    else
      return " "
    end
    #return " " if $game_map.display_name.empty?
  end
  
  #--------------------------------------------------------------------------
  # update
  #--------------------------------------------------------------------------
  def update
    super
    draw_item_time
  end
end