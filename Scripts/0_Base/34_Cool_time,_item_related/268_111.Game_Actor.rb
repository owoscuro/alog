# encoding: utf-8
# Name: 111.Game_Actor
# Size: 2672
# encoding: utf-8
# Name: 111.Game_Actor
# Size: 2632
class Game_Actor
  def initialize(actor_id)
    super()
    setup(actor_id)
    set_params
    @last_skill = Game_BaseItem.new
    $data_classes[@class_id].learnings.each do |i|
      i.note.gsub!(/(\d+)/) { i.level = $1.to_i }
    end
  end
  
  def equip_slots
    return [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
  end
  
  def change_equip(slot_id, item)
    if restriction >= 4 and !dead? # 행동불가인지 확인
      # 오류 메세지 표시 실험 -----------------------
      $game_temp.pop_w(180, 'SYSTEM', "  No es posible cambiar el equipo. ")
      # -------------------------------------------
      Sound.play_buzzer
      return false
    end
    return unless trade_item_with_party(item, equips[slot_id])
    return if (item && equip_slots[slot_id] != item.etype_id) and
      not (skill_learn?($data_skills[85]) and (equip_slots[slot_id] == 1 and item.etype_id == 0))
    @equips[slot_id].object = item
    refresh
  end
  
  def release_unequippable_items(item_gain = true)
    @equips.each_with_index do |item, i|
      if !equippable?(item.object,equip_slots[i]) || (item.object.etype_id != equip_slots[i] and
          not (skill_learn?($data_skills[85]) and (equip_slots[i] == 1 and item.object.etype_id == 0)))
        trade_item_with_party(nil, item.object) if item_gain
        item.object = nil
      end
    end
  end
  
  def slot_list(etype_id)
    result = []
    equip_slots.each_with_index {|e, i| result.push(i) if e == etype_id or ((e == 1 and etype_id == 0) and skill_learn?($data_skills[85]))}
    result
  end

  def param_max(param_id)
    return 999999999 if param_id == 0  # MHP
    return super
  end

  def set_params
    return if $data_actors[@actor_id].name == "" or $data_actors[@actor_id].name == nil
    print("111.Game_Actor - ");
    print("%s 능력치 분배 확인 \n" % [$data_actors[@actor_id].name]);
    $data_actors[@actor_id].max_level = YY::MAX_LEVEL
    @mmm = Array.new(8)
    (0..7).each {|i| @mmm[i] = $data_classes[@class_id].params[i,1] }
    $data_classes[@class_id].params.resize(8,YY::MAX_LEVEL + 1) 
    (100..YY::MAX_LEVEL).each do |i|
      $data_classes[@class_id].params[0,i] = @mmm[0]+i*50
      $data_classes[@class_id].params[1,i] = @mmm[1]+i*10
      (2..5).each {|j| $data_classes[@class_id].params[j,i] = @mmm[j]+i*5/4 }
      (6..7).each {|j| $data_classes[@class_id].params[j,i] = @mmm[j]+i*5/2 }
    end
  end
  
  alias ed_battlend_recover on_battle_end
  def on_battle_end
  end
  
  alias ed_level_up level_up
  def level_up
    ed_level_up
  end
end