# encoding: utf-8
# Name: 207.Window_EquipItem
# Size: 2364
class Window_EquipItem < Window_ItemList
  def col_max
    return 1
  end
  
  def slot_id=(slot_id)
    return if @slot_id == slot_id
    @slot_id = slot_id
    @last_item = nil
    self.oy = 0
    refresh
  end
  
  def draw_item(index)
    item = @data[index]
    rect = item_rect(index)
    rect.width -= 4
    if item.nil?
      draw_remove_equip(rect)
      return
    end
    dw = contents.width - rect.x - 24
    draw_item_name(item, rect.x, rect.y, enable?(item), dw)
    # 아래 적용시 아이템의 수량을 표기한다.
    #draw_item_number(rect, item)
  end
  
  def draw_remove_equip(rect)
    text = YEA::EQUIP::REMOVE_EQUIP_TEXT
    rect.x += 4
    rect.width -= 24
    draw_text(rect, text)
  end
  
  def enable?(item)
    if item.nil? && !@actor.nil?
      etype_id = @actor.equip_slots[@slot_id]
      return YEA::EQUIP::TYPES[etype_id][1]
    end
    return @actor.equippable?(item)
  end
  
  def show
    @last_item = 0
    update_help
    super
  end
  
  def update_help
    super
    return if @actor.nil?
    return if @status_window.nil?
    return if @last_item == item
    @last_item = item
    temp_actor = Marshal.load(Marshal.dump(@actor))
    temp_actor.force_change_equip(@slot_id, item)
    @status_window.set_temp_actor(temp_actor)
  end
  
  def include?(item)
    return true if item == nil
    # 방패 슬롯에 착용할 아이템이 방패 봉인 아이템인지 확인
    if @actor.equip_slots[@slot_id] == 0
      @ro_armo_sld = []
      item.features.each do |feature, i|
        @ro_armo_sld.push(feature.code)
      end
      return false if @ro_armo_sld.include?(54) and @actor.equips[1] != nil
    end
    if @actor.equip_slots[@slot_id] == 1
      @ro_armo_sld = []
      item.features.each do |feature, i|
        @ro_armo_sld.push(feature.code)
      end
      #print("207.Window_EquipItem - %s \n" % [@ro_armo_sld]);
      return false if @ro_armo_sld.include?(54)
    end
    return false unless item.is_a?(RPG::EquipItem)
    return false if @slot_id < 0
    return false if (item.etype_id != @actor.equip_slots[@slot_id]) and 
      not (@actor.skill_learn?($data_skills[85]) and (@actor.equip_slots[@slot_id] == 1 and item.etype_id == 0))
    return @actor.equippable?(item, @actor.equip_slots[@slot_id])
  end
end