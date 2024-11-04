# encoding: utf-8
# Name: 296_2. Menu-Update
# Size: 14010
module Galv_Menu
  CURRENCY_ICON = 361       # Icon to display instead of currency vocab.
                            # Change this to 0 to use currency vocab instead.

  PORTRAIT_X_OFFSET = 0     # add a positive or negative number to offset 
  PORTRAIT_Y_OFFSET = 0     # each portrait's postion if the portraits you use
                            # do not line up with your screen width/height.
                            
  PORTRAIT_HEIGHT = 400     # So you can tweak the height of the portraits.
  
  NUMBER_OF_ACTORS = 4      # number of actors visible before scrolling
end

class Window_MenuCommand < Window_Command
  def window_width
    return 160
  end
  
  def window_height
    Graphics.height - 72
  end
end

class Window_MenuStatus < Window_Selectable
  def window_width
    Graphics.width
  end
  
  def window_height
    Graphics.height - 72
  end
  
  def item_height
    (height - standard_padding * 2)
  end
  
  def draw_portrait(actor, x, y, enabled = true)
    # 오류 방지 추가
    return unless $data_actors[actor.id]
    
    @ro_x = 336 + 144
    @ro_y = Graphics.height * -0.04 + 100
    
    x += 5
    y = 63
    
    # 빙결, 석화 상태인지 확인, 행동불가인지 확인
    @ro_x -= 62 if actor.id == 7 and ($game_actors[7].state?(133) or $game_actors[7].state?(11))
    
    @self_face_x = 162
    @self_face_y = $game_actors[actor.id].height.split("cm")
    @self_face_y = @self_face_y[0].to_i - Graphics.height * 0.4

    bitmap_base = nil
    
    if Graphics.height == 640
      bitmap_base = Cache.picture("Actor_Base_2") rescue nil
    elsif Graphics.height == 704
      bitmap_base = Cache.picture("Actor_Base_1") rescue nil
    else
      bitmap_base = Cache.picture("Actor_Base") rescue nil
    end
    
    bitmap = nil
    
    if actor.id == 7
      bitmap = Cache.picture($game_variables[443]) rescue nil # 몸통
      rect = Rect.new(@ro_x, @ro_y + @self_face_y + 70, 125, bitmap_base.height)
      contents.blt(x, y, bitmap, rect, 255) if bitmap != nil
      bitmap = Cache.picture($game_variables[444]) rescue nil # 표정
      contents.blt(x, y, bitmap, rect, 255) if bitmap != nil
      bitmap = Cache.picture($game_variables[445]) rescue nil # 성인용품
      contents.blt(x, y, bitmap, rect, 255) if bitmap != nil
      bitmap = Cache.picture($game_variables[446]) rescue nil # 발그레
      contents.blt(x, y, bitmap, rect, 255) if bitmap != nil
      bitmap = Cache.picture($game_variables[447]) rescue nil # 방어구
      contents.blt(x, y, bitmap, rect, 255) if bitmap != nil
    else
      filename = "Actor#{actor.id}"
      bitmap = Cache.face(filename) rescue nil
      rect = Rect.new(@self_face_x, @ro_y + @self_face_y, 125, bitmap_base.height)
      contents.blt(x, y, bitmap, rect, 255) if bitmap != nil
    end
    
    rect = Rect.new(0, 0, bitmap_base.width, bitmap_base.height)
    contents.blt(x, y, bitmap_base, rect, 255) if bitmap_base != nil
    bitmap.dispose
  end
  
  def tweak
    if Galv_Menu::NUMBER_OF_ACTORS <= 3
      return -2
    else
      return 0
    end
  end
  
  def draw_actor_portrait(actor, x, y, enabled = true)
    draw_portrait(actor, x, y, enabled)
  end
  
  def draw_item(index)
    actor = $game_party.members[index]
    # 오류 방지 추가
    #return unless $data_actors[actor.id]
    enabled = $game_party.members.include?(actor)
    if enabled
      rect = item_rect(index)
      draw_item_background(index)
      draw_actor_portrait(actor, rect.x + 1, rect.y + 1, enabled)
      draw_actor_simple_status_ro(actor, rect.x + 1, rect.y - 70)
    end
  end
  
  def draw_actor_simple_status_ro(actor, x, y)
    draw_actor_name_ro(actor, x, y + 70)
    draw_actor_class_ro(actor, x, y + 70 + 17)
    
    draw_actor_level_ro(actor, x, y + 70 + 24 * 2)
    draw_actor_icons_ro(actor, x + 15, y + Graphics.height - 24 * 5 - 10)
    
    draw_actor_hp_ro(actor, x, y + Graphics.height - 24 * 4)
    draw_actor_mp_ro(actor, x, y + Graphics.height - 24 * 3 - 2)
    draw_actor_tp_ro(actor, x, y + Graphics.height - 24 * 2 - 4)
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: draw_gauge
  #--------------------------------------------------------------------------
  def draw_gauge_ro(dx, dy, dw, rate, color1, color2)
    dw -= 2 if YEA::CORE::GAUGE_OUTLINE
    fill_w = [(dw * rate).to_i, dw].min
    gauge_h = YEA::CORE::GAUGE_HEIGHT
    gauge_y = dy + 24 - 2 - gauge_h
    if YEA::CORE::GAUGE_OUTLINE
      outline_colour = gauge_back_color
      outline_colour.alpha = translucent_alpha
      contents.fill_rect(dx, gauge_y-1, dw+2, gauge_h+2, outline_colour)
      dx += 1
    end
    p gauge_back_color()
    contents.fill_rect(dx, gauge_y, dw, gauge_h, gauge_back_color)
    contents.gradient_fill_rect(dx, gauge_y, fill_w, gauge_h, color1, color2)
  end
  
  #--------------------------------------------------------------------------
  # * Overwrite: Draw actor level
  #--------------------------------------------------------------------------
  def draw_actor_level_ro(actor, x, y, width = col_width, height = 5)
    draw_gauge_ro(x + 2, y - 14, width - 4, exp_rate(actor), exp_gauge1, exp_gauge2)
    
    change_color(text_color(14))
    draw_text(x + 2, y - 16, width, 24, Vocab::level, 0)
    draw_text(x - 2, y - 14, width, 24, actor.level.group, 2)
    
    # 해상도 변경시
    if Graphics.height == 640 or Graphics.height == 704
      fo_lin = 17
      contents.font.size = 19
    else
      fo_lin = 11
      contents.font.size = 17
    end
    
    # 오류 방지 추가 -------------------------------------------------------------
    if actor.drunk == nil or actor.drunk_max == nil
      actor.drunk = 0
      actor.drunk_max = 100
    end
    
    change_color(normal_color)
    draw_current_and_max_values_ro(x, 17 * 4 + fo_lin, width - 3, actor.hunger.to_i, actor.hunger_max.to_i, normal_color, normal_color)
    draw_current_and_max_values_ro(x, 17 * 6 + fo_lin, width - 3, actor.thirst.to_i, actor.thirst_max.to_i, normal_color, normal_color)
    draw_current_and_max_values_ro(x, 17 * 8 + fo_lin, width - 3, actor.sleep.to_i, actor.sleep_max.to_i, normal_color, normal_color)
    draw_current_and_max_values_ro(x, 17 * 10 + fo_lin, width - 3, actor.temper.to_i, actor.temper_max.to_i, normal_color, normal_color)
    draw_current_and_max_values_ro(x, 17 * 12 + fo_lin, width - 3, actor.stress.to_i, actor.stress_max.to_i, normal_color, normal_color)
    draw_current_and_max_values_ro(x, 17 * 14 + fo_lin, width - 3, actor.hygiene.to_i, actor.hygiene_max.to_i, normal_color, normal_color)
    draw_current_and_max_values_ro(x, 17 * 16 + fo_lin, width - 3, actor.sexual.to_i, actor.sexual_max.to_i, normal_color, normal_color)
    draw_current_and_max_values_ro(x, 17 * 18 + fo_lin, width - 3, actor.piety.to_i, actor.piety_max.to_i, normal_color, normal_color)
    draw_current_and_max_values_ro(x, 17 * 20 + fo_lin, width - 3, actor.drunk.to_i, actor.drunk_max.to_i, normal_color, normal_color)
    
=begin
    change_color(normal_color)
    draw_current_and_max_values_ro(x, 17 * 4 + fo_lin, width - 3, actor.hunger, 1300, normal_color, normal_color)
    draw_current_and_max_values_ro(x, 17 * 6 + fo_lin, width - 3, actor.thirst, 1100, normal_color, normal_color)
    draw_current_and_max_values_ro(x, 17 * 8 + fo_lin, width - 3, actor.sleep, 900, normal_color, normal_color)
    draw_current_and_max_values_ro(x, 17 * 10 + fo_lin, width - 3, actor.temper, 100, normal_color, normal_color)
    draw_current_and_max_values_ro(x, 17 * 12 + fo_lin, width - 3, actor.stress, 100, normal_color, normal_color)
    draw_current_and_max_values_ro(x, 17 * 14 + fo_lin, width - 3, actor.hygiene, 100, normal_color, normal_color)
    draw_current_and_max_values_ro(x, 17 * 16 + fo_lin, width - 3, actor.sexual, 100, normal_color, normal_color)
    draw_current_and_max_values_ro(x, 17 * 18 + fo_lin, width - 3, actor.piety, 100, normal_color, normal_color)
    draw_current_and_max_values_ro(x, 17 * 20 + fo_lin, width - 3, actor.drunk, 100, normal_color, normal_color)
=end

    # 해상도 변경시
    if Graphics.height == 640 or Graphics.height == 704
      contents.font.size = 21
    else
      contents.font.size = 17
    end
    
    x += 140
    
    change_color(system_color)
    draw_text(x, 17 * 3 + fo_lin, width, 24, "Hambre", 0)
    draw_text(x, 17 * 5 + fo_lin, width, 24, "Sed", 0)
    draw_text(x, 17 * 7 + fo_lin, width, 24, "Fatiga", 0)
    draw_text(x, 17 * 9 + fo_lin, width, 24, "Temperatura corporal", 0)
    draw_text(x, 17 * 11 + fo_lin, width, 24, "Mente y cuerpo", 0)
    draw_text(x, 17 * 13 + fo_lin, width, 24, "Higiene", 0)
    draw_text(x, 17 * 15 + fo_lin, width, 24, "Deseo sexual", 0)
    draw_text(x, 17 * 17 + fo_lin, width, 24, "Devoción", 0)
    draw_text(x, 17 * 19 + fo_lin, width, 24, "Embriaguez", 0)
  end
  
  #--------------------------------------------------------------------------
  # * 메뉴창 상태이상 아이콘 수량 수정
  #--------------------------------------------------------------------------
  def draw_actor_icons_ro(actor, x, y, height = 130)
    @as = []
    @i2 = 0
    #@as = actor.state_icons if actor.state_icons != nil
    @as = actor.state_icons if !actor.state_icons.empty?
    print("@as - %s \n" % [@as])
    if !@as.empty?
      icons = (@as)[0, contents.height / 24]
      print("icons - %s \n" % [icons])
      icons.each_with_index {|n, i|
        @st_y_1 = y - 24 * i
        if @st_y_1 >= 70
          @icon_ro = n
          if @icon_ro > 5280
            @icon_ro = 1
          else
            @icon_ro += 1
          end
          bitmap = Cache.system("icon/"+"#{@icon_ro}") rescue nil
          if bitmap != nil
            rect = Rect.new(0, 0, 24, 24)
            contents.blt(x-3, @st_y_1, bitmap, rect, 255)
          end
        else
          @st_y_2 = y - 24 * @i2
          @icon_ro = n
          if @icon_ro > 5280
            @icon_ro = 1
          else
            @icon_ro += 1
          end
          bitmap = Cache.system("icon/"+"#{@icon_ro}") rescue nil
          if bitmap != nil
            rect = Rect.new(0, 0, 24, 24)
            contents.blt(x+29, @st_y_2, bitmap, rect, 255)
          end
          @i2 += 1
        end
      }
    end
  end
  
  def col_width
    window_width / Galv_Menu::NUMBER_OF_ACTORS - standard_padding - 2
  end
  
  def draw_actor_hp_ro(actor, x, y, width = col_width)
    draw_gauge_ro(x + 2, y, width - 4, actor.hp_rate, hp_gauge_color1, hp_gauge_color2)
    change_color(system_color)
    draw_text(x, y, 30, 24, Vocab::hp_a)
    draw_current_and_max_values(x, y, width, actor.hp, actor.mhp, hp_color(actor), normal_color)
  end

  def draw_actor_mp_ro(actor, x, y, width = col_width)
    draw_gauge_ro(x + 2, y, width - 4, actor.mp_rate, mp_gauge_color1, mp_gauge_color2)
    change_color(system_color)
    draw_text(x, y, 30, 24, Vocab::mp_a)
    draw_current_and_max_values(x, y, width, actor.mp, actor.mmp, mp_color(actor), normal_color)
  end

  def draw_actor_tp_ro(actor, x, y, width = col_width)
    draw_gauge_ro(x + 2, y, width - 4, actor.tp_rate, tp_gauge_color1, tp_gauge_color2)
    change_color(system_color)
    draw_text(x, y, 30, 24, Vocab::tp_a)
    change_color(tp_color(actor))
    draw_text(x - 5, y, width, 24, actor.tp.to_i, 2)
  end
  
  def draw_current_and_max_values(x, y, width = col_width, current, max, color1, color2)
    change_color(color1)
=begin
    xr = x + width
    if width < 100
      draw_text(xr - 40, y, 42, 24, current.to_i, 2)
    else
      draw_text(xr - 92, y, 42, 24, current.to_i, 2)
      change_color(color2)
      draw_text(xr - 52, y, 12, 24, "/", 2)
      draw_text(xr - 42, y, 42, 24, max.to_i, 2)
    end
=end
    @value = sprintf("%d / %d", current, max)
    draw_text(x - 5, y, width, 24, @value, 2)
  end
  
  def draw_current_and_max_values_ro(x, y, width = col_width, current, max, color1, color2)
    change_color(color1)
    @rate = (current.to_f / max.to_f) * 100
    @rate = 0 if 0 > @rate
    @rate = 100 if @rate > 100
    @value = sprintf("%1.0f%%", @rate)
    case @rate
      when 80..110 then change_color(knockout_color)
      when 70..79 then change_color(crisis_color)
    end
    draw_text(x, y, width, 24, @value, 2)
  end
  
  def draw_actor_name_ro(actor, x, y, width = col_width)
    contents.font.bold = true
    contents.font.size = 20
    change_color(hp_color(actor))
    draw_text(x, y, width, 24, actor.name, 1)
    change_color(normal_color)
    contents.font.bold = false
  end
  
  def draw_actor_class_ro(actor, x, y, width = col_width)
    contents.font.size = 18
    change_color(normal_color)
    actor.nickname = actor.class.name if actor.nickname == ""
    actor.repute = 0 if actor.repute == nil
    #text = sprintf("%s(%s)", actor.nickname, "#{(actor.repute).to_i}"+"점")
    text = sprintf("%s(%d puntos)", actor.nickname, actor.repute)
    draw_text(x, y, width, 24, text, 1)
  end
  
  def visible_line_number
    return 1
  end
  
  def col_max
    return Galv_Menu::NUMBER_OF_ACTORS
  end
  
  def spacing
    return 8
  end
  
  def contents_width
    (item_width + spacing) * item_max - spacing
  end
  
  def contents_height
    item_height
  end
  
  def top_col
    ox / (item_width + spacing)
  end
  
  def top_col=(col)
    col = 0 if col < 0
    @member_count = $game_party.members.count
    col = col_max + @member_count if col > col_max + @member_count
    self.ox = col * (item_width + spacing)
  end
  
  def bottom_col
    top_col + col_max - 1
  end
  
  def bottom_col=(col)
    self.top_col = col - (col_max - 1)
  end
  
  def ensure_cursor_visible
    self.top_col = index if index < top_col
    self.bottom_col = index if index > bottom_col
  end
  
  def item_rect(index)
    rect = super
    rect.x = index * (item_width + spacing)
    rect.y = 0
    rect
  end
  
  def alignment
    return 1
  end
  
  def cursor_down(wrap = false)
  end
  
  def cursor_up(wrap = false)
  end
  
  def cursor_pagedown
  end
  
  def cursor_pageup
  end
end