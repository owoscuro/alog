# encoding: utf-8
# Name: 155.Window_ItemList
# Size: 1118
class Window_ItemList < Window_Selectable
  def draw_item(index)
    item = @data[index]
    return if item.nil?
    rect = item_rect(index)
    rect.width -= 4
    draw_item_name(item, rect.x, rect.y, enable?(item), rect.width - 24)
    # 아래 적용시 아이템의 수량을 표기한다.
    if item.is_a?(RPG::Weapon) and item.etype_id == 0 and SceneManager.scene_is?(Scene_Item)
      # 무기는 수량 생략
    elsif item.is_a?(RPG::Armor) and item.etype_id >= 1 and SceneManager.scene_is?(Scene_Item)
      # 방어구는 수량 생략
    else
      draw_item_number(rect, item)
    end
  end
  
  def draw_item_number(rect, item)
    text = sprintf(YEA::CORE::ITEM_AMOUNT, $game_party.item_number(item).group)
    draw_text(rect, text, 2)
  end
  
  alias :th_map_drops_process_handling :process_handling
  def process_handling
    return unless open? && active
    return process_drop_item if handle?(:drop) && Keyboard.trigger?(:kC)
    th_map_drops_process_handling
  end
  
  def process_drop_item
    Input.update
    deactivate
    call_handler(:drop)
  end
end