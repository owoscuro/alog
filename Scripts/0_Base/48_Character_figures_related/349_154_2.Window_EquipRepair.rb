# encoding: utf-8
# Name: 154_2.Window_EquipRepair
# Size: 1941
class Window_EquipRepair < Window_ItemList
  def enable?(item)
    # 소지금 초과시 빨간색으로 표시 적용
    $game_switches[141] = false if $game_switches[141] == true
    return true if item.is_a?(RPG::EquipItem) && item.can_repair? && $game_party.gold >= item.repair_price
    return false
  end
  
  def col_max
    return 2
  end

  def draw_item(index)
    item = @data[index]
    if item
      rect = item_rect(index)
      rect.width -= 4
      draw_item_name(item, rect.x, rect.y, enable?(item), rect.width)
      # 아래 적용시 아이템의 수량을 표기한다.
      #draw_item_number(rect, item)
      ro_item_pr = 1 - (item.durability.to_f/item.max_durability).to_f
      ro_item_pr = (item.price * ro_item_pr).to_i
      #ro_item_pr = ((ro_item_pr * TH_Instance::Scene_Repair::Price_Mod) / (500 - $game_variables[163])).to_i * 3 + 1
      # 수리 가격 수정
      ro_item_pr = (ro_item_pr * ($game_variables[163] * 0.01).to_f).to_i
      draw_currency_value(ro_item_pr, "", rect.x, rect.y, rect.width, 0) if item.can_repair?
    end
  end

  def update_help
    unless item
      @help_window.set_text(TH_Instance::Scene_Repair::No_Selected_Item, nil)
    else
      # 내구도가 0이 아닌 경우 메세지 실험
      if item.can_repair?
        contents.clear
        refresh
        item = @data[index]
        rect = item_rect(index)
        rect.width -= 4
        draw_item_name(item, rect.x, rect.y, enable?(item), rect.width)
        @help_window.set_text(TH_Instance::Scene_Repair::Selected_Item, nil)
      else
        contents.clear
        refresh
        @help_window.set_text(TH_Instance::Scene_Repair::Can_Not_Repair, nil)
      end
    end
  end
  
  def include?(item)
    #item.is_a?(RPG::EquipItem)
    item.is_a?(RPG::EquipItem) && !item.is_a?(RPG::Item) && !item.nil? && item.use_durability && item.can_repair?
  end
end