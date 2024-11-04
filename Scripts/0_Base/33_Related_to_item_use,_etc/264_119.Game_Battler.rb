# encoding: utf-8
# Name: 119.Game_Battler
# Size: 3473
class Game_Battler < Game_BattlerBase
  alias :process_weapon_durability_mdv :make_damage_value
  def make_damage_value(user, item)
    process_weapon_durability_mdv(user, item)
    user.process_weapon_durability(item) if user.actor? && @result.hit?
    self.process_armor_durability(item) if self.actor? && @result.hit?
  end

  def process_weapon_durability(item)
    return unless item.is_a?(RPG::Skill)
    weapons.each do |i|
      next unless can_process_weapon_durability(i, item)
      process_individual_weapon_durability(i, item)
    end
  end
  
  def process_armor_durability(item)
    return unless item.is_a?(RPG::Skill)
    armors.each do |i|
      next unless can_process_armor_durability(i, item)
      process_individual_armor_durability(i, item)
    end
  end
  
  def can_process_weapon_durability(weapon, skill)
    return false unless weapon
    return false unless weapon.use_durability
    return true
  end
  
  def can_process_armor_durability(armor, skill)
    return false unless armor
    return false unless armor.use_durability
    return false unless reduce_durability_rate(armor, skill)
    return true
  end
  
  #-----------------------------------------------------------------------------
  # * 무기 내구도 감소 부분
  #-----------------------------------------------------------------------------
  def process_individual_weapon_durability(weapon, skill)
    # 의상 변경 스킬이 아닌 경우에만 내구도 감소
    if skill.id != 396 and rand(100) >= 70
      weapon.durability -= weapon_durability_cost(weapon, skill).to_i
      weapon.durability = 0 if weapon.durability < 0
      weapon.refresh_name
      weapon.refresh_price
      weapon.break_by_durability(self) if weapon.durability.zero?
    end
  end
  
  #-----------------------------------------------------------------------------
  # * 방어구 내구도 감소 부분
  #-----------------------------------------------------------------------------
  def process_individual_armor_durability(armor, skill)
    # 의상 변경 스킬이 아닌 경우에만 내구도 감소
    if skill.id != 396 and rand(100) >= 70
      armor.durability -= armor_durability_damage(armor, skill)
      armor.durability = 0 if armor.durability < 0
      armor.refresh_name
      armor.refresh_price
      armor.break_by_durability(self) if armor.durability.zero? and armor.durability >= 10
    end
  end
  
  def reduce_durability_rate(armor, skill)
    # 일반 공격은 요소 -1 이고 요소가 없는 0 으로 변경되었습니까?
    ele = skill.damage.element_id == -1 ? 0 : skill.damage.element_id
    # 착용한 방어구 확인 내구도 갱신 실험
    if armor != nil and self.equips[3] != nil
      if self.equips[3].id == armor.id
        $game_variables[118] = (armor.durability.to_f / armor.max_durability * 100).to_i
      end
    end
    # 노출도 대입
    $game_variables[121] = (100 - ($game_actors[7].equipment_equip_sexy)*$game_variables[118]/100).to_i
    return true if ele != 0 and ele != nil
    return false
  end
  
  def weapon_durability_cost(weapon, skill)
    cost = skill.weapon_durability_cost
    cost += weapon.skill_durability_mod(skill.id)
    cost = 0 if cost < 0
    return cost
  end
  
  def armor_durability_damage(armor, skill)
    damg = skill.armor_durability_damage
    damg = 0 if damg < 0
    return damg
  end
end