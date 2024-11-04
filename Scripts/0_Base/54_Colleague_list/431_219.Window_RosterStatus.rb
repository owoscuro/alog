# encoding: utf-8
# Name: 219.Window_RosterStatus
# Size: 8978
class Window_RosterStatus < Window_Selectable
  def initialize(actor)
    super(0, 0, Graphics.width - 176, Graphics.height)
    @actor = actor
    refresh
  end
  
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
  end
  
  def refresh
    contents.clear
    reset_font_settings
    contents.font.size -= 2
    if ROSTER::USE_BASIC
      if @actor.discovered
        draw_actor_portrait4(@actor, -30, line_height * 1)
      elsif ROSTER::UNDISCOVERED_FACE
        draw_actor_portrait4(99, -30, line_height * 1)
      end
    end
    draw_actor_bmbiography
    draw_actor_biography
    draw_block3(line_height * 12)
  end
  
  def draw_actor_bio_info(id, x, y, width = 100)
    #print("066.동료 명단 바이오 - %s \n" % [id])
    case id
    when :blank; return y + line_height
    when :hblank; return dy + line_height/2
    when :align
      return y unless $imported[:bm_align]
      text1 = BM::STATUS::BIO_INFO_TEXT[id]
      text2 = eval("@actor.#{id}_name")
    when :age, :birthplace, :height, :nickname
      text1 = BM::STATUS::BIO_INFO_TEXT[id]
      text2 = eval("@actor.#{id}")
      #print("219.Window_RosterStatus - %s \n" % [text1])
      if text1 == "나이" and text2 == "0살"
        text2 = "???살"
      end
    when :gender
      return y unless $imported["BubsGenderFunctions"]
      text1 = BM::STATUS::BIO_INFO_TEXT[id]
      text2 = eval("@actor.#{id}")
    when :custom_bio1, :custom_bio2, :custom_bio3, :custom_bio10
      return y unless BM::STATUS::CBIO_INFO_TEXT.include?(id)
      text1 = BM::STATUS::CBIO_INFO_TEXT[id]
      text2 = eval("@actor.#{id}")
=begin
    else
      return y unless BM::STATUS::CBIO_INFO_TEXT.include?(id)
      text1 = BM::STATUS::CBIO_INFO_TEXT[id]
      text2 = eval("@actor.#{id}")
=end
    end
    cw = text_size(text1).width
    change_color(system_color)
    draw_text(x+3, y-2, width, line_height, text1)
    if text1 != "" and text1 != nil
      change_color(normal_color)
      if @actor.discovered
        if text1 != "하루 고용 가격"
          draw_text(x + cw-3, y-2, width-cw, line_height, text2, 2)
        else
          if text2.to_i >= 1
            draw_currency_value(text2, "", x + cw-3, y-2, width-cw, 4)
          else
            draw_text(x + cw-3, y-2, width-cw, line_height, "???", 2)
          end
        end
      else
        draw_text(x + cw-3, y-2, width-cw, line_height, "???", 2)
      end
    end
    return y + line_height
  end
  
  def draw_actor_bmbiography
    reset_font_settings
    y = line_height * 1 + 26
    contents.font.size = BM::STATUS::BIO_FONT_SIZE
    bio_info_list = BM::STATUS::BIO_INFO
    if BM::STATUS::ACTOR_BIO_INFO.include?(@actor.id)
      bio_info_list = BM::STATUS::ACTOR_BIO_INFO[@actor.id]
    end
    for id in bio_info_list
      y = draw_actor_bio_info(id, 260, y, contents.width-272)
      break if y + line_height > contents.height
    end
    reset_font_settings
  end
  
  def draw_actor_biography
    fmt = YEA::STATUS::BIOGRAPHY_NICKNAME_TEXT
    text = sprintf(fmt, @actor.name, @actor.nickname)
    contents.font.size = YEA::STATUS::BIOGRAPHY_NICKNAME_SIZE
    if @actor.discovered
      draw_text(240, 0, 200, line_height*2, text, 1)
    else
      draw_text(240, 0, 200, line_height*2, "???", 1)
    end
    contents.font.size = BM::STATUS::BIO_FONT_SIZE
    reset_font_settings
  end
  
  def draw_block3(y)
    draw_parameters(8, y)
    if @actor.discovered
      draw_equipments(contents.width / 3 - 55, y)
    end
  end
  
  def draw_actor_param(actor, x, y, param_id)
    change_color(system_color)
    draw_text(x, y, contents.width / 4 - 80, line_height, Vocab::param(param_id))
    change_color(normal_color)
    if @actor.discovered
      draw_text(x + 40, y, contents.width / 4 - 80, line_height, actor.param(param_id), 2)
    else
      draw_text(x + 40, y, contents.width / 4 - 80, line_height, "???", 2)
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
  
  def draw_basic_info(x, y)
    draw_actor_level(@actor, x, y + line_height * 0)
    draw_actor_hp(@actor, x, y + line_height * 2)
    draw_actor_mp(@actor, x, y + line_height * 3)
  end
  
  def draw_parameters(x, y)
    6.times {|i| 
    if Graphics.height == 640
      contents.font.size = 22
      draw_actor_param(@actor, x, y + line_height * i + 4, i + 2)
    elsif Graphics.height == 704
      contents.font.size = 25
      draw_actor_param(@actor, x, y + line_height * i + 8, i + 2)
    else
      contents.font.size = 19
      draw_actor_param(@actor, x, y + line_height * i, i + 2)
    end
    }
  end
  
  def draw_equipments(x, y)
    iter = 0
    iter2 = 0
    dw = contents.width / 3 + 30
    x = contents.width / 4 - 20
    reset_font_settings
    change_color(system_color)
    contents.font.size = 25
    draw_text(x + (dw * iter2), y, dw, line_height, '  ' + "#{@actor.name}" + ' 착용 장비')
    
    if Graphics.height == 704
      y += line_height * 1.5
      contents.font.size = 21
    elsif Graphics.height == 640
      y += line_height * 1.6
      contents.font.size = 25
    else
      y += line_height * 1.4
      contents.font.size = 19
    end
    
    change_color(normal_color)
    variable_id = 0
    @actor.equips.each do |item|
      if item != nil
        draw_item_name(item, x + (dw * iter2) + 8, y + line_height * iter, enabled = true, width = dw)
      else
        draw_icon(slot_icon(variable_id), x + (dw * iter2) + 8, y + line_height * iter, true)
        draw_nothing_equip(x + (dw * iter2) + 8, y + line_height * iter, false, dw) if $imported["YEA-AceEquipEngine"]
      end
      variable_id += 1
      if iter2 == 0
        iter2 = 1
      else
        iter2 = 0
        if Graphics.height == 640 or Graphics.height == 704
          iter += 1.4
        else
          iter += 1.2
        end
      end
    end
  end
  
  def draw_nothing_equip(dx, dy, enabled, dw)
    change_color(normal_color, false)
    text = YEA::EQUIP::NOTHING_TEXT
    draw_text(dx+25, dy, dw + 40, line_height, text)
  end
  
  def slot_icon(index)
    Icon::etype(@actor.equip_slots[index])
  end
  
  def draw_description(x, y)
    if @actor.discovered
      draw_text_ex(x, y, @actor.description)
    end
  end
  
  def draw_text_ex(x, y, text)
    text = convert_escape_characters(text)
    pos = {:x => x, :y => y, :new_x => x, :height => calc_line_height(text)}
    process_character(text.slice!(0, 1), text, pos) until text.empty?
  end
  
  alias ros_draw_actor_name draw_actor_name
  def draw_actor_name(a, x, y)
    return ros_draw_actor_name(a,x,y) if @actor.discovered
    draw_text(x,y,contents.width,line_height,"?????")
  end
  
  alias ros_draw_actor_class draw_actor_class
  def draw_actor_class(a, x, y)
    return ros_draw_actor_class(a,x,y) if @actor.discovered
    draw_text(x,y,contents.width,line_height,"?????")
  end
  
  alias ros_draw_actor_nickname draw_actor_nickname
  def draw_actor_nickname(a, x, y)
    return ros_draw_actor_nickname(a,x,y) if @actor.discovered
    draw_text(x,y,contents.width,line_height,"?????")
  end
  
  def draw_actor_level(actor, x, y)
    change_color(system_color)
    draw_text(x, y, 32, line_height, Vocab::level_a)
    change_color(normal_color)
    if @actor.discovered
      draw_text(x + 32, y, 24, line_height, actor.level, 2)
    else
      draw_text(x + 32, y, 24, line_height, "???", 2)
    end
  end
  
  def draw_actor_hp(actor, x, y, width = 124)
    draw_gauge(x, y, width, 1, hp_gauge_color1, hp_gauge_color2)
    change_color(system_color)
    draw_text(x, y, 30, line_height, Vocab::hp_a)
    draw_current_and_max_values(x, y, width, actor.mhp, actor.mhp, hp_color(actor), normal_color)
  end
    
  def draw_actor_mp(actor, x, y, width = 124)
    draw_gauge(x, y, width, 1, mp_gauge_color1, mp_gauge_color2)
    change_color(system_color)
    draw_text(x, y, 30, line_height, Vocab::mp_a)
    draw_current_and_max_values(x, y, width, actor.mmp, actor.mmp, mp_color(actor), normal_color)
  end
    
  def draw_current_and_max_values(x, y, width, current, max, color1, color2)
    change_color(color1)
    xr = x + width
    if @actor.discovered
      draw_text(xr - 92, y, 42, line_height, current, 2)
      change_color(color2)
      draw_text(xr - 52, y, 12, line_height, " / ", 2)
      draw_text(xr - 42, y, 42, line_height, max, 2)
    else
      draw_text(xr - 92, y, 42, line_height, "???", 2)
      change_color(color2)
      draw_text(xr - 52, y, 12, line_height, " / ", 2)
      draw_text(xr - 42, y, 42, line_height, "???", 2)
    end
  end
end