# encoding: utf-8
# Name: 127.Game_Enemy
# Size: 7350
class Game_Enemy < Game_Battler
  attr_accessor :battler_graphic, :breath_enable, :object, :invin, :collapse_type
  attr_accessor :die_animation
  attr_accessor :body_sized, :esensor, :boss_hud, :k_back_dis
  attr_reader   :lowhp_10, :lowhp_25, :lowhp_50, :lowhp_75
  
  alias falcaopearl_enemy_ini initialize
  def initialize(index, enemy_id)
    falcaopearl_enemy_ini(index, enemy_id)
    @battler_graphic = enemy.tool_data("Enemy Battler = ",false) == "true"
    @breath_enable = enemy.tool_data("Enemy Breath = ",false) == "true"
    @object = enemy.tool_data("Enemy Object = ", false) == "true"
    @invin = enemy.tool_data("Enemy Invin = ", false) == "true"
    @collapse_type = enemy.tool_data("Enemy Collapse Type = ", false)
    @die_animation = enemy.tool_data("Enemy Die Animation = ")
    @body_sized = enemy.tool_data("Enemy Body Increase = ")
    @boss_hud = enemy.tool_data("Enemy Boss Bar = ", false) == "true"
    @esensor = enemy.tool_data("Enemy Sensor = ")
    @esensor = PearlKernel::Sensor if @esensor.nil?
    @body_sized = 0 if @body_sized.nil?
    @k_back_dis = enemy.tool_data("Enemy Knockback Disable = ",false) == "true"
    @lowhp_75 = enemy.tool_data("Enemy Lowhp 75% Switch = ")
    @lowhp_50 = enemy.tool_data("Enemy Lowhp 50% Switch = ")
    @lowhp_25 = enemy.tool_data("Enemy Lowhp 25% Switch = ")
    @lowhp_10 = enemy.tool_data("Enemy Lowhp 10% Switch = ")
  end
  
  alias falcaopearl_Enemy_refresh refresh
  def refresh
    falcaopearl_Enemy_refresh
  end
  
  #--------------------------------------------------------------------------
  # ● 상태이상 능력치 추가
  #--------------------------------------------------------------------------
  alias :th_parameter_bonuses_param_bonus_objects :param_bonus_objects
  def param_bonus_objects
    feature_objects
  end
  #--------------------------------------------------------------------------
  # ● 패시브 param의 취득
  #--------------------------------------------------------------------------
  def passive_param_base(param_id)
    return 0
  end  
  #--------------------------------------------------------------------------
  # ● 패시브 param 비율의 취득
  #--------------------------------------------------------------------------
  def passive_param_rate_base(param_id)
    return 1
  end
  #--------------------------------------------------------------------------
  # ● 패시브 xparam의 취득
  #--------------------------------------------------------------------------
  def passive_xparam_base(xparam_id)
    return 0
  end
  #--------------------------------------------------------------------------
  # ● 패시브 sparam의 취득
  #--------------------------------------------------------------------------
  def passive_sparam_base(sparam_id)
    return 0
  end
  #--------------------------------------------------------------------------
  # ● 속성 유효도의 취득
  #--------------------------------------------------------------------------
  def passive_element_rate(element_id)
    return 0
  end
  #--------------------------------------------------------------------------
  # ● 약체 유효도의 취득
  #--------------------------------------------------------------------------
  def passive_debuff_rate(param_id)
    return 0
  end
  #--------------------------------------------------------------------------
  # ● 스테이트 유효도의 취득
  #--------------------------------------------------------------------------
  def passive_state_rate(state_id)
    return 0
  end
  #--------------------------------------------------------------------------
  # ● 무효화하는 스테이트의 배열을 취득
  #--------------------------------------------------------------------------
  def passive_state_resist
    return []
  end
  #--------------------------------------------------------------------------
  # ● 공격속성의 배열을 취득
  #--------------------------------------------------------------------------
  def passive_atk_element
    return []
  end
  #--------------------------------------------------------------------------
  # ● 공격상태의 배열을 취득
  #--------------------------------------------------------------------------
  def passive_atk_state
    return []
  end
  #--------------------------------------------------------------------------
  # ● 공격상태의 발동율 취득
  #--------------------------------------------------------------------------
  def passive_atk_state_rate(state_id)
    return 0
  end
  #--------------------------------------------------------------------------
  # ● 공격속도의 발동율 취득
  #--------------------------------------------------------------------------
  def passive_atsp
    return 0
  end
  #--------------------------------------------------------------------------
  # ● 공격횟수의 발동율 취득
  #--------------------------------------------------------------------------
  def passive_atnu
    return 0
  end  
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 스킬타입 추가
  #--------------------------------------------------------------------------
  def passive_added_stypes
    return []
  end
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 스킬타입 봉인
  #--------------------------------------------------------------------------
  def passive_stypes_sealed
    return []
  end
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 스킬추가
  #--------------------------------------------------------------------------
  def passive_added_skills
    return []
  end
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 스킬봉인
  #--------------------------------------------------------------------------
  def passive_skill_sealed
    return []
  end  
  #--------------------------------------------------------------------------
  # ● 무기 장비 가능의 판정 
  #--------------------------------------------------------------------------
  def passive_wtype
    return []
  end
  #--------------------------------------------------------------------------
  # ● 방어구 장비 가능의 판정
  #--------------------------------------------------------------------------
  def passive_atype
    return []
  end
  #--------------------------------------------------------------------------
  # ● 장비 고정의 판정
  #--------------------------------------------------------------------------
  def passive_efixed
    return []
  end
  #--------------------------------------------------------------------------
  # ● 장비 봉인의 판정 
  #--------------------------------------------------------------------------
  def passive_esealed
    return []
  end
  #--------------------------------------------------------------------------
  # ● 이도류의 판정
  #--------------------------------------------------------------------------
  def passive_dbwp
    return 0
  end
end