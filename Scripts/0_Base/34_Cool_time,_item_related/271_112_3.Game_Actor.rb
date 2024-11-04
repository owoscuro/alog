# encoding: utf-8
# Name: 112_3.Game_Actor
# Size: 4656
class Game_Actor < Game_Battler
  alias :th_instance_items_init_equips :init_equips
  def init_equips(equips)
    @equips = Array.new(equip_slots.size) { Game_BaseItem.new }
    instance_equips = check_instance_equips(equips)
    equip_extra_starting_equips
    th_instance_items_init_equips(instance_equips)
  end

  def equip_extra_starting_equips
    for equip_id in actor.extra_starting_equips
      armour = $data_armors[equip_id]
      next if armour.nil?
      etype_id = armour.etype_id
      next unless equip_slots.include?(etype_id)
      slot_id = empty_slot(etype_id)
      @equips[slot_id].set_equip(etype_id == 0, armour.id)
    end
    refresh
  end
  
  def check_instance_equips(equips)
    new_equips = []
    equips.each_with_index do |item_id, i|
      etype_id = index_to_etype_id(i)
      slot_id = empty_slot(etype_id)
      if etype_id == 0
        equip = $data_weapons[item_id]
      else
        equip = $data_armors[item_id]
      end
      new_equips << InstanceManager.get_instance(equip)
    end
    return new_equips.collect {|obj| obj ? obj.id : 0}
  end
  
  alias :th_instance_items_change_equip :change_equip
  def change_equip(slot_id, item)
    new_item = item
    if item && InstanceManager.instance_enabled?(item) && $game_party.has_item?(item) && item.is_template?
      new_item = $game_party.find_instance_item(item)
    end
    th_instance_items_change_equip(slot_id, new_item)
  end
  
  alias :th_instance_items_trade_item_with_party :trade_item_with_party
  def trade_item_with_party(new_item, old_item)    
    if new_item && InstanceManager.instance_enabled?(new_item) && $game_party.has_item?(new_item) && new_item.is_template?
      new_item = $game_party.find_instance_item(new_item)
    end
    th_instance_items_trade_item_with_party(new_item, old_item)
  end
  
  def instance_weapons_include?(id)
    weapons.any? {|obj| obj.template_id == id } 
  end

  def instance_armors_include?(id)
    armors.any? {|obj| obj.template_id == id } 
  end
  
  def equip_slots
    return equip_slots_dual if dual_wield?
    return equip_slots_normal
  end
  
  def equip_slots_normal
    return self.actor.base_equip_slots if self.actor.base_equip_slots != []
    return self.class.base_equip_slots
  end
  
  def equip_slots_dual
    array = equip_slots_normal.clone
    array[1] = 0 if array.size >= 2
    return array
  end
  
  def fixed_etypes
    array = []
    array |= self.actor.fixed_equip_type
    array |= self.class.fixed_equip_type
    for equip in equips
      next if equip.nil?
      array |= equip.fixed_equip_type
    end
    for state in states
      next if state.nil?
      array |= state.fixed_equip_type
    end
    return array
  end
  
  def sealed_etypes
    array = []
    array |= self.actor.sealed_equip_type
    array |= self.class.sealed_equip_type
    for equip in equips
      next if equip.nil?
      array |= equip.sealed_equip_type
    end
    for state in states
      next if state.nil?
      array |= state.sealed_equip_type
    end
    return array
  end

  alias game_actor_force_change_equip_aee force_change_equip
  def force_change_equip(slot_id, item)
    @equips[slot_id] = Game_BaseItem.new if @equips[slot_id].nil?
    game_actor_force_change_equip_aee(slot_id, item)
  end
  
  alias game_actor_weapons_aee weapons
  def weapons
    anti_crash_equips
    return game_actor_weapons_aee
  end
  
  alias game_actor_armors_aee armors
  def armors
    anti_crash_equips
    return game_actor_armors_aee
  end
  
  alias game_actor_equips_aee equips
  def equips
    anti_crash_equips
    return game_actor_equips_aee
  end
  
  def anti_crash_equips
    for i in 0...@equips.size
      next unless @equips[i].nil?
      @equips[i] = Game_BaseItem.new
    end
  end

  #--------------------------------------------------------------------------
  # 가온데 정렬 추가 수정
  #--------------------------------------------------------------------------
  def alignment
    return 1
  end
end

#===============================================================================
# 코어 장비 슬롯과의 호환성
#===============================================================================
if $imported["TH_CoreEquipSlots"]
  class Game_Actor < Game_Battler
    def init_equips(equips)
      @equips = Array.new(initial_slots.size) {|i| Game_EquipSlot.new(initial_slots[i]) }
      instance_equips = check_instance_equips(equips)
      th_instance_items_init_equips(instance_equips)
    end
  end
end