# encoding: utf-8
# Name: 161.Window_FileStatus
# Size: 10926
# encoding: utf-8
# Name: 161.Window_FileStatus
# Size: 10915
class Window_FileStatus < Window_Base
  def initialize(dx, dy, file_window)
    super(dx, dy, Graphics.width - dx, Graphics.height - dy)
    @file_window = file_window
    @current_index = @file_window.index
    refresh
  end
  
  def update
    super
    return if @file_window.index < 0
    return if @current_index == @file_window.index
    @current_index = @file_window.index
    refresh
  end
  
  def refresh
    contents.clear
    reset_font_settings
    @header = DataManager.load_header(@file_window.index)
    # 세이브 에디터 방지용 데이터 획득
    $ro_rodel_rosepa = @header if @header != nil
    if @header.nil?
      draw_empty
    else
      draw_save_contents
    end
  end
  
  def draw_empty
    colour = Color.new(0, 0, 0, translucent_alpha/2)
    rect = Rect.new(0, 0, contents.width, contents.height)
    contents.fill_rect(rect, colour)
    text = YEA::SAVE::EMPTY_TEXT
    change_color(system_color)
    draw_text(rect, text, 1)
  end
  
  def draw_save_slot(dx, dy, dw)
    reset_font_settings
    change_color(system_color)
    text = sprintf(YEA::SAVE::SLOT_NAME, "")
    draw_text(dx, dy, dw, line_height, text)
    cx = text_size(text).width
    change_color(normal_color)
    draw_text(dx+cx, dy, dw-cx, line_height, (@file_window.index+1).group, 2)
  end
  
  def draw_save_playtime(dx, dy, dw)
    return if @header[:playtime_s].nil?
    reset_font_settings
    change_color(system_color)
    draw_text(dx, dy, dw, line_height, YEA::SAVE::PLAYTIME, 0)
    change_color(normal_color)
    draw_text(dx, dy, dw, line_height, @header[:playtime_s], 2)
  end
  
  def draw_save_playtime2(dx, dy, dw)
    return if @header[:variables].nil?
    reset_font_settings
    change_color(system_color)
    draw_text(dx, dy, dw, line_height, "Fecha", 0)
    change_color(normal_color)
    draw_text(dx, dy, dw, line_height, @header[:variables][168], 2)
  end
  
  def draw_save_total_saves(dx, dy, dw)
    return if @header[:system].nil?
    reset_font_settings
    change_color(system_color)
    text = YEA::SAVE::TOTAL_SAVE
    draw_text(dx, dy, dw, line_height, text)
    cx = text_size(text).width
    change_color(normal_color)
    draw_text(dx+cx, dy, dw-cx, line_height, @header[:system].save_count.group, 2)
  end
  
  def draw_save_gold(dx, dy, dw, tepy)
    return if @header[:party].nil?
    reset_font_settings
    change_color(system_color)
    draw_text(dx, dy, dw, line_height, YEA::SAVE::TOTAL_GOLD)
    change_color(normal_color)
    text = @header[:party].gold.group
    p text
    draw_currency_value(text.to_i, "", dx, dy, dw, tepy)
  end
  
  def draw_save_location(dx, dy, dw)
    return if @header[:map].nil?
    return if @header[:actors].nil?
    reset_font_settings
    change_color(system_color)
    draw_text(dx, dy, dw, line_height, YEA::SAVE::LOCATION)
    change_color(normal_color)
    cx = text_size(YEA::SAVE::LOCATION).width
    return if $data_mapinfos[@header[:map].map_id].nil?
    # 구매한 땅, 액터 이름으로 지정
    text = nil
    if @header[:map].map_id == 141
      text = @header[:actors][18].name
    elsif @header[:map].map_id == 144
      text = @header[:actors][17].name
    # 세라이튼 집
    elsif @header[:map].map_id == 398 or @header[:map].map_id == 399
      text = @header[:map].display_name
      text = @header[:actors][16].name if @header[:variables][147] == @header[:map].map_id
    # 바일라스 집
    elsif @header[:map].map_id == 403 or @header[:map].map_id == 404
      text = @header[:map].display_name
      text = @header[:actors][16].name if @header[:variables][147] == @header[:map].map_id
      text = @header[:actors][16].name if @header[:variables][147] + 1 == @header[:map].map_id
    # 슬라인 집
    elsif @header[:map].map_id == 400
      text = @header[:map].display_name
      text = @header[:actors][16].name if @header[:variables][147] == @header[:map].map_id
    # 팔세린 집
    elsif @header[:map].map_id == 316 or @header[:map].map_id == 272
      text = @header[:map].display_name
      text = @header[:actors][16].name if @header[:variables][147] == @header[:map].map_id
    end
    if text == nil or text == ""
      # 맵 이름 수정
      temp_map_name = @header[:map].display_name.split(" (")
      text  = temp_map_name[0].to_s
      if temp_map_name[1] != nil
        text += " (#{@header[:variables][106]}, #{@header[:variables][107]})"
      end
      text = $data_mapinfos[@header[:map].map_id].name if text == ""
    end
    draw_text(dx+cx, dy, dw-cx, line_height, text, 2)
  end
  
  def draw_save_characters(dx, dy)
    return if @header[:party].nil?
    reset_font_settings
    make_font_smaller
    dw = (contents.width - dx) / @header[:party].max_battle_members
    dx += dw / 3
    for member in @header[:party].battle_members
      next if member.nil?
      member = @header[:actors][member.id]
      change_color(normal_color)
      draw_actor_graphic(member, dx, dy)
      text = member.name
      draw_text(dx-dw/2, dy, dw, line_height, text, 1)
      text = member.level.group
      draw_text(dx-dw/2, dy-line_height, dw, line_height, text, 2)
      cx = text_size(text).width
      change_color(system_color)
      text = Vocab::level_a
      draw_text(dx-dw/2, dy-line_height, dw-cx, line_height, text, 2)
      dx += dw
    end
  end
  
  def slot_icon(index)
    return if @header[:actors].nil?
    @header[:actors][7] ? Icon::etype(@header[:actors][7].equip_slots[index]) : 0
  end
  
  def draw_nothing_equip(dx, dy, enabled, dw)
    change_color(normal_color, false)
    text = YEA::EQUIP::NOTHING_TEXT
    draw_text(dx+25, dy, dw, line_height, text)
  end
  
  def draw_save_column1(dx, dy, dw)
    return if @header[:actors_equips].nil?
    reset_font_settings
    change_color(system_color)
    draw_text(dx, dy, dw, line_height, "  Equipo de Erni")
    change_color(normal_color)
    
    if Graphics.height == 640
      dy += line_height + 13
      contents.font.size = 20
    elsif Graphics.height == 704
      dy += line_height + 11
      contents.font.size = 18
    else
      dy += line_height + 9
      contents.font.size = 17
    end
    
    for variable_id in 0..5
      value = @header[:actors_equips][variable_id]
      if value != nil
        draw_item_name(value, dx, dy, enabled = true, width = dw)
      else
        draw_icon(slot_icon(variable_id), dx, dy, true)
        draw_nothing_equip(dx, dy, false, dw)
      end
      if Graphics.height == 640
        dy += line_height + 13
      elsif Graphics.height == 704
        dy += line_height + 11
      else
        dy += line_height + 9
      end
    end
  end
  
  def draw_save_column2(dx, dy, dw)
    return if @header[:actors_equips].nil?
    reset_font_settings
    
    if Graphics.height == 640
      dy += line_height + 13
      contents.font.size = 20
    elsif Graphics.height == 704
      dy += line_height + 11
      contents.font.size = 18
    else
      dy += line_height + 9
      contents.font.size = 17
    end
    
    for variable_id in 6..11
      value = @header[:actors_equips][variable_id]
      if value != nil
        draw_item_name(value, dx, dy, enabled = true, width = dw)
      else
        draw_icon(slot_icon(variable_id), dx, dy, true)
        draw_nothing_equip(dx, dy, false, dw)
      end
      if Graphics.height == 544
        dy += line_height + 9
      elsif Graphics.height == 640
        dy += line_height + 13
      elsif Graphics.height == 704
        dy += line_height + 11
      else
        dy += line_height + 9
      end
    end
  end
  
  def draw_save_column3(dx, dy, dw)
    return if @header[:variables].nil?
    reset_font_settings
    change_color(system_color)
    draw_text(dx, dy, dw, line_height, "  Información del Mundo")
    change_color(normal_color)
    
    if Graphics.height == 640
      dy += line_height + 13
      contents.font.size = 22
    elsif Graphics.height == 704
      dy += line_height + 17
      contents.font.size = 24
    else
      dy += line_height + 9
      contents.font.size = 20
    end

    draw_text(dx, dy, dw, line_height, "Dificultad")
    if @header[:variables][18] == 0
      draw_text(dx, dy, dw, line_height, "FÁCIL", 2)
    elsif @header[:variables][18] == 1
      draw_text(dx, dy, dw, line_height, "NORMAL", 2)
    elsif @header[:variables][18] == 2
      draw_text(dx, dy, dw, line_height, "DIFÍCIL", 2)
    elsif @header[:variables][18] == 3
      draw_text(dx, dy, dw, line_height, "MUY FÁCIL", 2)
    elsif @header[:variables][18] == 4
      draw_text(dx, dy, dw, line_height, "INFIERNO", 2)
    elsif @header[:variables][18] == 5
      draw_text(dx, dy, dw, line_height, "LUNÁTICO", 2)
    end

    if Graphics.height == 640
      dy += line_height + 13
    elsif Graphics.height == 704
      dy += line_height + 17
    else
      dy += line_height + 9
    end
    
    value = @header[:variables][99]
    draw_text(dx, dy, dw, line_height, "Nivel Mundial")
    draw_text(dx, dy, dw, line_height, value, 2)
  end
  
  def draw_column_data(data, dx, dy, dw)
    return if @header[:variables].nil?
    reset_font_settings
    for variable_id in data
      next if $data_system.variables[variable_id].nil?
      change_color(system_color)
      name = $data_system.variables[variable_id]
      draw_text(dx, dy, dw, line_height, name, 0)
      value = @header[:variables][variable_id]
      if value.is_a? Numeric then value = value.group end
      change_color(normal_color)
      draw_text(dx, dy, dw, line_height, value, 2)
      dy += line_height
    end
  end
  
  def draw_horz_line(y)
    line_y = y + line_height / 2 - 1
    contents.fill_rect(0, line_y, contents_width, 2, line_color)
  end
  
  def line_color
    color = normal_color
    color.alpha = 48
    color
  end
  
  def draw_save_contents
    draw_save_slot(8, 0, contents.width/2-25)
    draw_save_total_saves(8, line_height, contents.width/2-25)
    draw_save_location(8, line_height*2, contents.width/2-25)
    
    draw_save_playtime(contents.width/2+8, 0, contents.width/2-25)
    draw_save_playtime2(contents.width/2+8, line_height, contents.width/2-25)
    draw_save_gold(contents.width/2+8, line_height*2, contents.width/2-25, 1)
    
    draw_horz_line(line_height*3)
    
    draw_save_characters(0, line_height*5 + line_height/3)
    
    draw_horz_line(line_height*6)

    draw_save_column1((contents.width/3)*0, line_height*7, contents.width/3)
    draw_save_column2((contents.width/3)*1, line_height*7, contents.width/3)
    draw_save_column3((contents.width/3)*2, line_height*7, contents.width/3-15)
  end
end