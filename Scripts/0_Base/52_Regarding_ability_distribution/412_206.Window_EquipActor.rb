# encoding: utf-8
# Name: 206.Window_EquipActor
# Size: 8214
# encoding: utf-8
# Name: 206.Window_EquipActor
# Size: 8142
class Window_EquipActor < Window_Base
  attr_reader   :slot_window
  attr_reader   :actor
  def initialize(dx, dy)
    window_height = Graphics.height - dy
    super(dx, dy, window_width, window_height)
    @actor = nil
    @slot_id = 0
  end
  
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
  end
  
  def slot_window=(slot_window)
    @slot_window = slot_window
    update
  end
  
  def update
    super    
    @slot_id = @slot_window.index if @slot_window
    update_cursor
  end
  
  def window_width
    return Graphics.width - BM::EQUIP::COMMAND_SIDE_OPTIONS[:width]
  end
  
  def item_max
    @actor ? @actor.equip_slots.size : 0
  end
  
  def item
    @actor ? @actor.equips[index] : nil
  end
  
  def refresh
    contents.clear
    return unless @actor
    draw_all_items
  end
  
  def draw_all_items
    return unless @actor
    contents.font.size = 18
      change_color(normal_color)
      pos = 0
      if @temp_actor
        change_color(param_change_color(@temp_actor.available_weight - actor.available_weight))
		n = "Peso #{@temp_actor.available_weight.to_i} / #{actor.max_weight_limit.to_i}, Protección Térmica #{actor.equipment_equip_temper.to_s}, Exposición #{(100 - actor.equipment_equip_sexy).to_s}"
		draw_text(10 + pos, -4, text_size(n).width + 30, line_height, n)
        pos += text_size(n).width
      else
        # 해상도 좌표
        dx_ro = Graphics.width * 0.366 + 50
        dx_dw = contents.width - dx_ro
        
        if Graphics.height == 640
          line_2 = 1.2
          contents.font.size = 22
        elsif Graphics.height == 704
          line_2 = 1.4
          contents.font.size = 24
        else
          line_2 = 1
          contents.font.size = 20
        end
        
        change_color(system_color)
        draw_text(dx_ro + 5, line_height * line_2, dx_dw, line_height, "Límite Peso Inv.")
        draw_text(dx_ro + 5, line_height * 3 * line_2, dx_dw, line_height, "Peso Equip.")
        draw_text(dx_ro + 5, line_height * 5 * line_2, dx_dw, line_height, "Prot Térmica")
        draw_text(dx_ro + 5, line_height * 7 * line_2, dx_dw, line_height, "Exposición")
        draw_text(dx_ro + 5, line_height * 9 * line_2, dx_dw, line_height, "Vel Movim.")        
        change_color(normal_color)
        change_color(param_change_color(0 - 1)) if $game_party.total_inv_size >= $game_party.inv_max * 0.8
        draw_text(dx_ro, line_height*2*line_2, dx_dw, line_height, "#{$game_party.total_inv_size} / #{$game_party.inv_max}", 2)
        change_color(normal_color)
        change_color(param_change_color(0 - 1)) if (actor.max_weight_limit.to_i - actor.available_weight.to_i) >= actor.max_weight_limit.to_i * 0.8
        draw_text(dx_ro, line_height*4*line_2, dx_dw, line_height, "#{actor.max_weight_limit.to_i - actor.available_weight.to_i} / #{actor.max_weight_limit.to_i}", 2)
        change_color(normal_color)
        change_color(param_change_color(0 - 1)) if actor.equipment_equip_temper < 5
        draw_text(dx_ro, line_height*6*line_2, dx_dw, line_height, "#{actor.equipment_equip_temper.to_s}", 2)
        change_color(normal_color)
        change_color(param_change_color(0 - 1)) if (100 - actor.equipment_equip_sexy) > 80
        draw_text(dx_ro, line_height*8*line_2, dx_dw, line_height, "#{(100 - actor.equipment_equip_sexy).to_s}", 2)
        change_color(normal_color)
        change_color(param_change_color(0 - 1)) if 20 > ((actor.atk_times_add + 1) * 100).to_i
        draw_text(dx_ro, line_height*10*line_2, dx_dw, line_height, "#{(((actor.atk_times_add + 1) * 100).to_i)}"+'%', 2)
      end
    draw_equip_dummy(0, 0)
    draw_mini_face
    item_max.times {|i| draw_item(i) }
  end
  
  def draw_mini_face
    if BM::EQUIP::BODY_OPTIONS[:show_face]
      enabled = battle_party?(@actor)
      iwidth = BM::EQUIP::BODY_OPTIONS[:face_size]
      iheight = BM::EQUIP::BODY_OPTIONS[:face_size]
      image_rect = Rect.new(contents.width - iwidth, 0, iwidth, iheight)
      draw_icon_face(@actor, image_rect, enabled)
    end
  end
  
  def draw_item(index)
    return unless index != nil
    size = BM::EQUIP::BODY_ICON_SIZE
    x = @actor.equip_body_x[index].to_i
    y = @actor.equip_body_y[index].to_i
    mini_height = BM::EQUIP::MINI_FONT_SIZE
    contents.font.size = mini_height
    draw_text(x-16, y-16, size + 16*2, line_height, slot_name(index),1) if BM::EQUIP::BODY_OPTIONS[:show_text]
    draw_equip_icon(@actor.equips[index], x, y, enable?(index))
    reset_font_settings
  end
  
  def draw_equip_icon(item, x, y, enable)
    return unless item
    if item.e_image.nil?
      draw_item_image(item.icon_index, x, y, enable)
    else
      size = BM::EQUIP::BODY_ICON_SIZE
      target = Rect.new(x, y, size, size)
      bitmap = Cache.picture(item.e_image)
      contents.stretch_blt(target, bitmap, bitmap.rect, enable ? 255 : translucent_alpha)
    end
  end
  
  def draw_item_image(icon_index, x, y, enabled)
    size = BM::EQUIP::BODY_ICON_SIZE
    bitmap = Cache.system("Iconset")
    rect = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
    target = Rect.new(x, y, size, size)
    contents.stretch_blt(target, bitmap, rect, enabled ? 255 : translucent_alpha)
  end
  
  def update_cursor
    if @slot_id < 0
      cursor_rect.empty
    else
      x = @actor.equip_body_x[@slot_id].to_i
      y = @actor.equip_body_y[@slot_id].to_i
      size = BM::EQUIP::BODY_ICON_SIZE
      cursor_rect.set(x, y, size, size)
    end
  end
  
  def slot_name(index)
    @actor ? Vocab::etype(@actor.equip_slots[index]) : ""
  end
  
  def enable?(index)
    @actor ? @actor.equip_change_ok?(index) : false
  end
  
  def draw_equip_dummy(x, y)
    if Graphics.height == 640
      @self_face_x = Graphics.width * 0.3
      @ro_x = Graphics.width * 0.34
      @ro_y = Graphics.height * -0.04 + 80
    elsif Graphics.height == 704
      @self_face_x = Graphics.width * 0.36
      @ro_x = Graphics.width * 0.41
      @ro_y = Graphics.height * -0.04 + 40
    else
      @self_face_x = Graphics.width * 0.38
      @ro_x = Graphics.width * 0.47
      @ro_y = Graphics.height * -0.04 + 100
    end
    
    x = 42
    y = 22
    
    # 빙결, 석화 상태인지 확인, 행동불가인지 확인
    @ro_x -= 62 if actor.id == 7 and ($game_actors[7].state?(133) or $game_actors[7].state?(11))
    
    @self_face_y = $game_actors[actor.id].height.split("cm")
    @self_face_y = @self_face_y[0].to_i - Graphics.height * 0.4 + (@self_face_y[0].to_i - 155)
    #print("206.Window_EquipActor - %s \n" % [@self_face_y])
    
    if actor.id == 7
      bitmap = Cache.picture($game_variables[443]) # 몸통
      rect = Rect.new(@ro_x, @ro_y + @self_face_y + 70, Graphics.width * 0.366, Graphics.height * 0.9)
      contents.blt(x, y, bitmap, rect, 255)
      bitmap = Cache.picture($game_variables[444]) # 표정
      contents.blt(x, y, bitmap, rect, 255)
      bitmap = Cache.picture($game_variables[445]) # 성인용품
      contents.blt(x, y, bitmap, rect, 255)
      bitmap = Cache.picture($game_variables[446]) # 발그레
      contents.blt(x, y, bitmap, rect, 255)
      bitmap = Cache.picture($game_variables[447]) # 방어구
      contents.blt(x, y, bitmap, rect, 255)
    else
      filename = "Actor#{actor.id}"
      bitmap = Cache.face(filename)
      rect = Rect.new(@ro_x - @self_face_x, @ro_y + @self_face_y, Graphics.width * 0.366, Graphics.height * 0.9)
      #rect = Rect.new(@ro_x * 0.17 + @self_face_x, @ro_y + @self_face_y, Graphics.width * 0.366, Graphics.height * 0.9)
      contents.blt(x, y, bitmap, rect, 255)
    end
    
    if Graphics.height == 640
      bitmap = Cache.picture("Actor_Amor_2")
    elsif Graphics.height == 704
      bitmap = Cache.picture("Actor_Amor_1")
    else
      bitmap = Cache.picture("Actor_Amor")
    end
    
    rect = Rect.new(0, 0, bitmap.width, bitmap.height)
    contents.blt(x-41, y-4, bitmap, rect, 255)
    bitmap.dispose
  end
end