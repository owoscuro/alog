# encoding: utf-8
# Name: 208.Window_EquipStatus
# Size: 9935
# encoding: utf-8
# Name: 208.Window_EquipStatus
# Size: 9954
class Window_EquipStatus < Window_Base
  attr_reader   :slot_window
  alias :bm_equip_init :initialize
  def initialize(dx, dy)
    @slot_id = 0
    @dy = dy
    bm_equip_init(dx, dy)
  end
  
  def draw_background_colour(dx, dy)
    colour = Color.new(0, 0, 0, translucent_alpha/2)
    rect = Rect.new(dx+1, dy+1, contents.width - 2, line_height - 2)
    contents.fill_rect(rect, colour)
  end
  
  def draw_param_name(dx, dy, param_id)
    contents.font.size = YEA::EQUIP::STATUS_FONT_SIZE
    change_color(system_color)
    draw_text(dx, dy, contents.width, line_height, Vocab::param(param_id))
  end
  
  def draw_current_param(dx, dy, param_id)
    change_color(normal_color)
    dw = (contents.width + 22) / 2
    draw_text(0, dy, dw, line_height, @actor.param(param_id).group, 2)
    reset_font_settings
  end
  
  def draw_new_param(dx, dy, param_id)
    contents.font.size = YEA::EQUIP::STATUS_FONT_SIZE
    new_value = @temp_actor.param(param_id)
    change_color(param_change_color(new_value - @actor.param(param_id)))
    draw_text(0, dy, contents.width-4, line_height, new_value.group, 2)
    reset_font_settings
  end
  
  def window_height
    Graphics.height - @dy
  end
  
  def window_width
    return Graphics.width
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
  
  def refresh
    contents.clear
    return unless @actor
    mini_height = BM::EQUIP::MINI_FONT_SIZE-1
    contents.font.size = mini_height
    draw_text(10, line_height - 28, window_width, line_height, "Item a Cambiar")
    reset_font_settings
    if @slot_id != nil
      if @actor
        item = @actor.equips[@slot_id]
      end
      if @temp_actor
        new_item = @temp_actor.equips[@slot_id]
        draw_item_name(new_item, 0, line_height+mini_height-21, true, window_width)
      end
    end
    i = 0
    h = contents.height - line_height * 2 - 8
    size = BM::EQUIP::MINI_FONT_SIZE - 1
    dh = line_height + mini_height - 21
    contents.font.size = dh
    for param_id in BM::EQUIP::PARAM_SHOWN
      case param_id
        when :hp,:maxhp then param_id = 0
        when :mp,:maxmp then param_id = 1
        when :atk then param_id = 2
        when :def then param_id = 3
        when :mat then param_id = 4
        when :mdf then param_id = 5
        when :agi then param_id = 6
        when :luk then param_id = 7
        when :el_3 then param_id = 12
        when :el_4 then param_id = 13
        when :el_5 then param_id = 14
        when :el_6 then param_id = 15
        when :el_7 then param_id = 16
        when :el_8 then param_id = 17
        when :el_9 then param_id = 18
        when :el_10 then param_id = 19
        when :el_12 then param_id = 20
        when :amove then param_id = 21
        when :aps then param_id = 22
      end
      draw_item(0, dh * i + contents.height - h - 9, param_id)
      i += 1
    end
  end
  
  def update_cursor
    mini_height = BM::EQUIP::MINI_FONT_SIZE
    if @slot_id < 0
      cursor_rect.empty
    else
      cursor_rect.set(0, line_height+mini_height-21, contents.width, line_height)
    end
  end
  
  def item
    @actor ? @actor.equips[index] : nil
  end
  
  def draw_item(dx, dy, param_id)
    case param_id
    when 0,1,2,3,4,5,6,7
      draw_param_name(dx + 4, dy, Vocab::param(param_id))
    when :hit, :eva, :cri, :cev, :mev, :mrf, :cnt, :hrg, :mrg, :trg
      draw_param_name(dx + 4, dy, Vocab::xparam_a(param_id))
    when :tgr, :grd, :rec, :pha, :mcr, :tcr, :pdr, :mdr, :fdr, :exr
      draw_param_name(dx + 4, dy, Vocab::sparam_a(param_id))
    when 12,13,14,15,16,17,18,19,20
      draw_param_name(dx + 4, dy, Vocab::sparam_f(param_id))
	when 21
	  draw_param_name(dx + 4, dy, "Vel Movimiento")
	when 22
	  draw_param_name(dx + 4, dy, "Probabilidad de Ignorar Knockback")
	when :atk_lk
	  draw_param_name(dx + 4, dy, "Ratio de Ataque Crítico")
    end
    drx = (contents.width) / 5
    draw_new_param(drx - 14, dy, param_id) if @temp_actor
    reset_font_settings
  end
  
  def draw_param_name(dx, dy, text)
    if $imported["YEA-AceEquipEngine"]
      contents.font.size = YEA::EQUIP::STATUS_FONT_SIZE - 2
    end
    change_color(system_color)
    dx_ro = contents.width / 2
    
    # 능력치 이름 표기
    if dy + 15 >= contents.height
      draw_text(dx + dx_ro, dy - (Graphics.height - 82), contents.width, line_height, text)
    else
      draw_text(dx + 5, dy, contents.width, line_height, text)
    end
  end
  
  def draw_current_param(dx, dy, param_id)
    case param_id
    when 0,1,2,3,4,5,6,7
      text = @actor.param(param_id).group
    when :hit, :eva, :cri, :cev, :mev, :mrf, :cnt, :hrg, :mrg, :trg
      value = eval("@actor.#{param_id}")
      text = sprintf("%d%", value * 100)
    when :tgr, :grd, :rec, :mcr, :tcr, :fdr, :exr
      value = eval("@actor.#{param_id}")
      text = sprintf("%d%", value * 100)
    when :pdr
      value = @actor.pdr
      text = sprintf("%d%", value)
    when :mdr
      value = @actor.mdr
      text = sprintf("%d%", value)
    when 12,13,14,15,16,17,18,19,20
      id = param_id - 9
      value = 100 - (100 * @actor.element_rate(id))
      text = sprintf("%d%%", value)
    when 21
      value = (@actor.atk_times_add + 1) * 100
      text = sprintf("%d%%", value)
    when 22
      value = @actor.action_plus_set2 * 10
      text = sprintf("%d%%", value)
    when :pha
      value = (@actor.atk_speed - @actor.pha) * -1
      text = sprintf("%d%%", value)
    when :atk_lk
      value = (@actor.atk_lk + (@actor.luk * 0.001)) * 100
      text = sprintf("%d%%", value)
    end
    change_color(normal_color)
    dw = (contents.width + 22) / 2
    draw_text(dx, dy, dw, line_height, text, 2)
    reset_font_settings
  end
  
  def window_width
    return Graphics.width - BM::EQUIP::COMMAND_SIDE_OPTIONS[:width]
  end
  
  def draw_new_param(dx, dy, param_id)
    case param_id
    when 0,1,2,3,4,5,6,7
      actor_value = @actor.param(param_id)
      temp_value = @temp_actor.param(param_id)
      text = temp_value.group
    when :hit, :eva, :cri, :cev, :mev, :mrf, :cnt, :hrg, :mrg, :trg
      actor_value = eval("@actor.#{param_id}")
      temp_value = eval("@temp_actor.#{param_id}")
      text = sprintf("%.1f%%", temp_value * 100)
    when :tgr, :grd, :rec, :mcr, :tcr, :fdr, :exr
      actor_value = eval("@actor.#{param_id}")
      temp_value = eval("@actor.#{param_id}")
      text = sprintf("%.1f%%", temp_value * 100)
    when :pdr
      actor_value = @actor.pdr * 100
      temp_value = @temp_actor.pdr * 100
      text = sprintf("%.1f%%", temp_value)
    when :mdr
      actor_value = @actor.mdr * 100
      temp_value = @temp_actor.mdr * 100
      text = sprintf("%.1f%%", temp_value)
    when 12,13,14,15,16,17,18,19,20
      id = param_id - 9
      actor_value = 100 - (100 * @actor.element_rate(id))
      temp_value = 100 - (100 * @temp_actor.element_rate(id))
      text = sprintf("%.1f%%", temp_value)
    when 21
      actor_value = (@actor.atk_times_add + 1) * 100
      temp_value = (@temp_actor.atk_times_add + 1) * 100
      text = sprintf("%.1f%%", temp_value)
    when 22
      actor_value = @actor.action_plus_set2 * 10
      temp_value = @temp_actor.action_plus_set2 * 10
      text = sprintf("%.1f%%", temp_value)
    when :pha
      actor_value = (@actor.atk_speed - @actor.pha) * -1
      temp_value = (@temp_actor.atk_speed - @temp_actor.pha) * -1
      text = sprintf("%.1f%%", temp_value)
    when :atk_lk
      actor_value = ((@actor.atk_lk + (@actor.luk * 0.001)) * 100).to_i
      temp_value = ((@temp_actor.atk_lk + (@temp_actor.luk * 0.001)) * 100).to_i
      text = sprintf("%.1f%%", temp_value)
    end
    if $imported["YEA-AceEquipEngine"]
      contents.font.size = YEA::EQUIP::STATUS_FONT_SIZE - 2
    end
    new_value = text
    change = temp_value.to_f - actor_value.to_f
    change_color(param_change_color(change))
    dx_ro = window_width / 2
    
    # 능력치 수치 표기
    if dy + 15 >= contents.height
      draw_text(dx_ro - 25, dy - (Graphics.height - 82), window_width / 2, line_height, text, 2)
    else
      draw_text(0 - 25, dy, window_width / 2, line_height, text, 2)
    end
    
    contents.font.size = BM::EQUIP::MINI_FONT_SIZE - 2
    if change != 0
      value = change
      # 변화값 표기 
      case param_id
      when :hit
        value = sprintf("%.1f%%", value * 10)
      when :eva, :cri, :cev, :mev, :mrf, :cnt, :hrg, :mrg, :trg
        value = sprintf("%.1f%%", value * 100)
      when :tgr, :grd, :rec, :mcr, :tcr, :fdr, :exr
        value = sprintf("%.1f%%", value * 100)
      when :pdr
        value = sprintf("%.1f%%", value.to_f)
      when :mdr
        value = sprintf("%.1f%%", value.to_f)
      when 12,13,14,15,16,17,18,19,20
        value = sprintf("%.1f%%", value)
      when 21
        value = sprintf("%.1f%%", value)
      when 22
        value = sprintf("%.1f%%", value)
      when :pha
        value = sprintf("%.1f%%", value)
      when :atk_lk
        value = sprintf("%.1f%%", value)
      end
      if change > 0
        value = "+#{value}"
      end
      # 하락, 상승 표기
      if dy + 15 >= contents.height
        draw_text(dx_ro - 25, dy - (Graphics.height - 82), window_width * 0.6, line_height, value, 1)
      else
        draw_text(-25, dy, window_width * 0.6, line_height, value, 1)
      end
    end
    w = contents.text_size(value).width
    reset_font_settings
    draw_icon(Icon.param_compare(change), contents.width-w-9, dy) if $imported[:bm_icon]    
  end  
end