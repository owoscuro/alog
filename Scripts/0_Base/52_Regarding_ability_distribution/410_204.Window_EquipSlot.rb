# encoding: utf-8
# Name: 204.Window_EquipSlot
# Size: 1639
class Window_EquipSlot < Window_Selectable
  def initialize(dx, dy, dw)
    super(dx, dy, dw, Graphics.height - dy)
    @actor = nil
    refresh
  end
  
  def window_height
    return self.height
  end
  
  def visible_line_number
    return item_max
  end
  
  def refresh
    create_contents
    super
  end
  
  def draw_item(index)
    return unless @actor
    colour = Color.new(0, 0, 0, translucent_alpha/2)
    rect2 = item_rect_for_text(index)
    rect2.x = 0
    rect2.y += 1
    rect = item_rect_for_text(index)
    change_color(system_color, enable?(index))
    item = @actor.equips[index]
    dx = rect.x + 24
    dw = contents.width
    if item.nil?
      draw_icon(slot_icon(index), rect.x, rect.y, enable?(index))
      draw_nothing_equip(dx, rect.y, false, dw) if $imported["YEA-AceEquipEngine"]
    else      
      draw_item_name(item, dx, rect.y, enable?(index), dw)
    end
  end
  
  def draw_nothing_equip(dx, dy, enabled, dw)
    change_color(normal_color, enabled)
    text = YEA::EQUIP::NOTHING_TEXT
    draw_text(dx, dy, dw - 24, line_height, text)
  end

  def draw_item_name(item, x, y, enabled = true, width = contents.width)
    return unless item
    draw_icon(item.icon_index, x - 24, y, enabled)
    # 레어도 색상 추가
    change_color(item.rarity_colour, enabled)
    # 아이템 이름 좌표 수정 실험
    draw_text(x + 5, y, width, line_height, item.name)
    # 레어도 색상 추가 실험
		change_color(normal_color, enabled)
  end
  
  def slot_icon(index)
    @actor ?  Icon::etype(@actor.equip_slots[index]) : 0
  end
end