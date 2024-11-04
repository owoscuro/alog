# encoding: utf-8
# Name: 023.RPG_Armor
# Size: 3972
module InstanceManager
  class << self
    alias :instance_weapon_durability_setup :setup_weapon_instance
    alias :instance_armor_durability_setup :setup_armor_instance
  end

  def self.setup_weapon_instance(obj)
    instance_weapon_durability_setup(obj)
    obj.repair if obj.use_durability
  end
  
  def self.setup_armor_instance(obj)
    instance_armor_durability_setup(obj)
    obj.repair if obj.use_durability
  end
end

class RPG::Armor
  attr_accessor :durability
  attr_accessor :use_durability
  
  def repair
    @durability = max_durability
    refresh_name
    refresh_price
  end
  
  def can_repair?
    @durability < max_durability
  end

  def repair_price
    @durability.zero? ? @non_durability_price : (@non_durability_price - @price)
  end

  alias :repair_price_mod :repair_price
  def repair_price
    # 수리비 추가 요금 실험
    return ((repair_price_mod * TH_Instance::Scene_Repair::Price_Mod) / (500 - $game_variables[163])).to_i * 3 + 1
  end
    
  def broken_armor_text(actor)
    Sound.play_buzzer
    # 오류 메세지 표시 실험 -----------------------
    $game_temp.pop_w(180, 'SYSTEM', 
    "  ¡El '%s' de '%s' ha sido destruido!  " % [actor.name, @non_durability_name])
    # -------------------------------------------
  end
  
  def break_by_durability(actor)
    actor.equips.each_index do |i|
      if actor.equips[i] == self
        actor.change_equip(i, nil)
        if TH_Instance::Armor::Destroy_Broken_Armor
          $game_party.gain_item(self, -1)
        else
          if broken_armor_change
            $game_party.gain_item(self, -1)
            broke_version = InstanceManager.get_instance($data_armors[broken_armor_change])
            $game_party.gain_item(broke_version, 1) 
          end
        end
        broken_armor_text(actor)
        break
      end
    end
  end
  
  def durability_suffix
    return TH_Instance::Armor::Dur_Suf % [@durability, @max_durability]
  end
  
  def apply_durability_suffix(name)
    name = name + durability_suffix
  end
  
  alias :sel_durability_make_name :make_name
  def make_name(name)
    name = sel_durability_make_name(name)
    @non_durability_name = name
    name = apply_durability_suffix(name) if use_durability
    name
  end
  
  def apply_durability_price(price)
    # 상점 품목에 인챈트 추가시 오류
    if SceneManager.scene_is?(Scene_RepairEquip)
      if @durability.zero? && @non_durability_price != nil
        price = price
      else
        price = (price * (@durability.to_f/max_durability).to_f).to_i
      end
    elsif @non_durability_price != nil
      price = (price * (max_durability.to_f/max_durability).to_f).to_i
    else
      price = (price * (@durability.to_f/max_durability).to_f).to_i
    end
    price
  end
  
  alias :sel_durability_make_price :make_price
  def make_price(price)
    price = sel_durability_make_price(price)
    @non_durability_price = price
    price = apply_durability_price(price) if use_durability
    price
  end
  
  def use_durability
    if @use_durability.nil?
      default = TH_Instance::Armor::Durability_Setting
      @note =~ /<set[-_ ]?durability>/i ? @use_durability = !default : @use_durability = default
    end
    @use_durability
  end
  
  def max_durability
    @note =~ /<max[-_ ]?durability:\s*(.*)\s*>/i ? @max_durability = $1.to_i : @max_durability = TH_Instance::Armor::Default_Durability if @max_durability.nil?
    @max_durability
  end
  
  def broken_armor_change
    @note =~ /<broken[-_ ]?armor[-_ ]?change:\s*(.*)\s*>/i ? @broken_armor_change = $1.to_i : @broken_armor_change = false if @broken_armor_change.nil?
    @broken_armor_change
  end
  
  def elem_dura_rate(element_id)
    if @elem_dura_rate.nil?
      @elem_dura_rate = []
      (0...$data_system.elements.size).each do |i|
        @note =~ TH_Instance::Armor.elem_dura_rate(i) ? @elem_dura_rate[i] = $1.to_f : @elem_dura_rate[i] = 0.0
      end
    end
    @elem_dura_rate[element_id]
  end
end