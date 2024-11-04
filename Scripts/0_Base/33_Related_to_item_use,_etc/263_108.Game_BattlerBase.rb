# encoding: utf-8
# Name: 108.Game_BattlerBase
# Size: 16917
class Game_BattlerBase
  #--------------------------------------------------------------------------
  # * 아이템, 스킬의 사용 조건을 확인한다.
  #--------------------------------------------------------------------------
  def usable?(item)
    if self.is_a?(Game_Actor)
      if SceneManager.scene_is?(Scene_Map) == false
        if item.is_a?(RPG::Skill) or item.is_a?(RPG::Item)
          # 커먼 이벤트 예약이 된 경우 취소
          item.effects.each {|effects| 
            return false if effects.code == 44 and $game_temp.common_event_reserved?
          }
        end
      end
      # 패시브 스킬이면 사용 할 수 없다.
      return false if item.is_a?(RPG::Skill) && item.passive?

      #print("108.Game_BattlerBase - 아이템 사용 확인 \n");
      itemcost = item.tool_data("Tool Item Cost = ")
      invoke = item.tool_data("Tool Invoke Skill = ")
      not_state = item.tool_data("Tool Not state = ")
      eq_number = item.tool_data("Tool Eq number = ", false)
      if item.is_a?(RPG::Skill)
        # 사용 금지 상태이상 확인
        if not_state != nil and not_state != 0 and self.state?(not_state)
          return false
        end
        # 필요한 방어구 확인
        if eq_number != nil and eq_number != 0
          if self.equips[3] != nil and self.equips[3].equip_number.include?(eq_number)
            #print("108.Game_BattlerBase - 필요 방어구 확인, %s \n" % [self.equips[3].name]);
          else
            return false
          end
        end
        # 필요한 아이템 확인
        if itemcost != nil and itemcost != 0
          #print("108.Game_BattlerBase - 필요 아이템 확인, %s \n" % [itemcost]);
          return false if item_conditions_met?($data_items[itemcost]) == false
        end
      end
      # 아래는 원본이다.
      if item.is_a?(RPG::Skill)
        return false if skill_conditions_met?(item) == false
      elsif item.is_a?(RPG::Item)
        return false if item_conditions_met?(item) == false
      end
      
      return true
    else
      return true
    end
  end
  
  #-----------------------------------------------------------------------------
  # 보너스 매개변수를 계산합니다.
  #-----------------------------------------------------------------------------
  def param_bonus_objects
    states
  end
  
  def param_bonus(param_id)
    return 0 if @check_param_bonus
    @check_param_bonus = true
    val = param_bonus_objects.inject(0) do |r, bonus_obj|
      bonus_obj.param_bonuses.inject(r) do |r2, obj|
        obj.param_id == param_id ? r2 += obj.value(self) : r2
      end
    end
    @check_param_bonus = false
    return val
  end
  #--------------------------------------------------------------------------
  # ● 통상 능력치의 취득
  #--------------------------------------------------------------------------
  alias :th_param_bonuses_param_plus :param_plus
  def param(param_id)
    value = param_base(param_id) + param_plus(param_id)
    
    # 상태이상 능력치 추가
    if param_bonus(param_id) != 0 and (param_bonus(param_id) - value) >= 1
      value += (param_bonus(param_id) - value)
    end
    
    value *= passive_param_rate_base(param_id)
    value += passive_param_base(param_id)
    value *= param_rate(param_id) * param_buff_rate(param_id)

    [[value, param_max(param_id)].min, param_min(param_id)].max.to_i
  end
  #--------------------------------------------------------------------------
  # ● 추가 능력치의 취득
  #--------------------------------------------------------------------------
  alias p_xparam xparam
  def xparam(xparam_id)
    n = p_xparam(xparam_id)
    n += passive_xparam_base(xparam_id)/100
    return n
  end
  #--------------------------------------------------------------------------
  # ● 특수 능력치의 취득
  #--------------------------------------------------------------------------
  alias p_sparam sparam
  def sparam(sparam_id)
    n = p_sparam(sparam_id)
    n += passive_sparam_base(sparam_id)/100
    return n
  end
  #--------------------------------------------------------------------------
  # ● 속성 유효도의 취득
  #--------------------------------------------------------------------------
  alias p_element_rate element_rate
  def element_rate(element_id)
    n = p_element_rate(element_id)
    n += passive_element_rate(element_id)/100
    return n
  end
  #--------------------------------------------------------------------------
  # ● 약체 유효도의 취득
  #--------------------------------------------------------------------------
  alias p_debuff_rate debuff_rate
  def debuff_rate(param_id)
    n = p_debuff_rate(param_id)
    n += passive_debuff_rate(param_id)/100
    return n
  end
  #--------------------------------------------------------------------------
  # ● 스테이트 유효도의 취득
  #--------------------------------------------------------------------------
  alias p_state_rate state_rate
  def state_rate(state_id)
    n = p_state_rate(state_id)
    n += passive_state_rate(state_id)/100
    return n
  end
  #--------------------------------------------------------------------------
  # ● 무효화하는 스테이트의 배열을 취득 
  #--------------------------------------------------------------------------
  alias p_state_resist_set state_resist_set
  def state_resist_set
    obj_set = p_state_resist_set.dup
    if passive_state_resist != []
      passive_state_resist.each { |k| obj_set.push(k) }
    end
    return obj_set
  end
  #--------------------------------------------------------------------------
  # ● 공격시 속성의 취득 
  #--------------------------------------------------------------------------
  alias p_atk_elements atk_elements
  def atk_elements
    obj_set = p_atk_elements.dup
    if passive_atk_element != []
      passive_atk_element.each { |k| obj_set.push(k) }
    end
    return obj_set
  end
  #--------------------------------------------------------------------------
  # ● 공격시 스테이트의 취득 
  #--------------------------------------------------------------------------
  alias p_atk_states atk_states
  def atk_states
    obj_set = p_atk_states.dup
    if passive_atk_state != []
      passive_atk_state.each { |k| obj_set.push(k) }
    end
    return obj_set
  end
  #--------------------------------------------------------------------------
  # ● 공격시 스테이트의 발동율 취득 
  #--------------------------------------------------------------------------
  alias p_atk_states_rate atk_states_rate
  def atk_states_rate(state_id)
    obj = p_atk_states_rate(state_id)
    obj += passive_atk_state_rate(state_id)
    return obj
  end
  #--------------------------------------------------------------------------
  # ● 공격 속도 보정의 취득       
  #--------------------------------------------------------------------------
  alias p_atk_speed atk_speed
  def atk_speed
    n = p_atk_speed
    n += passive_atsp
    return n
  end
  #--------------------------------------------------------------------------
  # ● 공격 추가 회수의 취득
  #--------------------------------------------------------------------------
  alias p_atk_times_add atk_times_add
  def atk_times_add
    n = p_atk_times_add
    n += passive_atnu
    return n
  end
  #--------------------------------------------------------------------------
  # ● 추가 스킬 타입의 취득 
  #--------------------------------------------------------------------------
  alias p_added_skill_types added_skill_types
  def added_skill_types
    obj_set = p_added_skill_types.dup
    if passive_added_stypes != nil
      passive_added_stypes.each { |k| obj_set.push(k) }
    end
    return obj_set
  end
  #--------------------------------------------------------------------------
  # ● 스킬 타입 봉인 셋
  #--------------------------------------------------------------------------
  def skill_type_sealed
    features_set(FEATURE_STYPE_SEAL)
  end
  #--------------------------------------------------------------------------
  # ● 스킬 타입 봉인의 판정
  #--------------------------------------------------------------------------
  def skill_type_sealed?(stype_id)
    obj_set = skill_type_sealed.dup
    if passive_stypes_sealed != nil
      passive_stypes_sealed.each { |k| obj_set.push(k) }
    end
    return obj_set.include?(stype_id)
  end
  #--------------------------------------------------------------------------
  # ● 추가 스킬의 취득
  #--------------------------------------------------------------------------
  alias p_added_skills added_skills
  def added_skills
    obj_set = p_added_skills.dup
    if passive_added_skills != nil
      passive_added_skills.each { |k| obj_set.push(k) }
    end
    return obj_set
  end
  #--------------------------------------------------------------------------
  # ● 스킬 봉인 셋
  #--------------------------------------------------------------------------
  def skill_sealed
    features_set(FEATURE_SKILL_SEAL)
  end
  #--------------------------------------------------------------------------
  # ● 스킬 봉인의 판정
  #--------------------------------------------------------------------------
  def skill_sealed?(skill_id)
    obj_set = skill_sealed.dup
    if passive_skill_sealed != nil
      passive_skill_sealed.each { |k| obj_set.push(k) }
    end
    return obj_set.include?(skill_id)
  end
  #--------------------------------------------------------------------------
  # ● 무기 장비 가능의 셋
  #--------------------------------------------------------------------------
  def equip_wtype_set
    features_set(FEATURE_EQUIP_WTYPE)
  end
  #--------------------------------------------------------------------------
  # ● 무기 장비 가능의 판정 
  #--------------------------------------------------------------------------
  def equip_wtype_ok?(wtype_id)
    obj_set = equip_wtype_set.dup
    if passive_wtype != nil
      passive_wtype.each { |k| obj_set.push(k) }
    end
    return obj_set.include?(wtype_id)
  end
  #--------------------------------------------------------------------------
  # ● 방어구 장비 가능의 셋
  #--------------------------------------------------------------------------
  def equip_atype_set
    features_set(FEATURE_EQUIP_ATYPE)
  end
  #--------------------------------------------------------------------------
  # ● 방어구 장비 가능의 판정
  #--------------------------------------------------------------------------
  def equip_atype_ok?(atype_id)
    obj_set = equip_atype_set.dup
    if passive_atype != nil
      passive_atype.each { |k| obj_set.push(k) }
    end
    return obj_set.include?(atype_id)
  end
  #--------------------------------------------------------------------------
  # ● 장비 고정의 셋
  #--------------------------------------------------------------------------
  def equip_type_fixed_set
    features_set(FEATURE_EQUIP_FIX)
  end
  #--------------------------------------------------------------------------
  # ● 장비 고정의 판정
  #--------------------------------------------------------------------------
  def equip_type_fixed?(etype_id)
    obj_set = equip_type_fixed_set.dup
    if passive_efixed != nil
      passive_efixed.each { |k| obj_set.push(k) }
    end
    return obj_set.include?(etype_id)
  end
  #--------------------------------------------------------------------------
  # ● 장비 봉인의 셋
  #--------------------------------------------------------------------------
  def equip_type_sealed_set
    features_set(FEATURE_EQUIP_SEAL)
  end
  #--------------------------------------------------------------------------
  # ● 장비 봉인의 판정
  #--------------------------------------------------------------------------
  def equip_type_sealed?(etype_id)
    obj_set = equip_type_sealed_set.dup
    if passive_esealed != nil
      passive_esealed.each { |k| obj_set.push(k) }
    end
    return obj_set.include?(etype_id)
  end
  #--------------------------------------------------------------------------
  # ● 쌍수검의 판정
  #--------------------------------------------------------------------------
  def dual_wield?
    return true if passive_dbwp != 0
    # 이도류 스킬 습득 여부 확인
    #return true if skill_learn?($data_skills[85])
    return slot_type == 1
  end
  
  def atk_element_rate(id); features_sum(FEATURE_ATK_ELEMENT, id); end
  def atk_lk; features_pi(FEATURE_SPARAM, 24);  end
  
  alias falcaopearl_erasestate erase_state
  def erase_state(state_id)
    #print("108.Game_BattlerBase - ");
    #print("상태이상 제거 %s \n" % [state_id]);
    falcaopearl_erasestate(state_id)
    if self.is_a?(Game_Actor)
      $game_player.refresh_skillbar = 4
    end
  end
  
  alias game_battlerbase_equip_type_fixed_aee equip_type_fixed?
  def equip_type_fixed?(etype_id)
    #print("108.Game_BattlerBase - ");
    #print("장비 결정 타입 %s \n" % [etype_id]);
    #return true if restriction >= 4  # 행동불가인지 확인
    return true if fixed_etypes.include?(etype_id) if actor?
    return game_battlerbase_equip_type_fixed_aee(etype_id)
  end
  
  alias game_battlerbase_equip_type_sealed_aee equip_type_sealed?
  def equip_type_sealed?(etype_id)
    #print("108.Game_BattlerBase - ");
    #print("장비 봉인 타입 %s \n" % [etype_id]);
    #return true if restriction >= 4  # 행동불가인지 확인
    return true if sealed_etypes.include?(etype_id) if actor?
    return game_battlerbase_equip_type_sealed_aee(etype_id)
  end
  
  def max_tp
    return 99
  end
  
  def tp_rate
    @tp.to_f / max_tp
  end
  
  def param_max(param_id)
    return 999999999 if param_id == 0  # MHP
    return 999999999 if param_id == 1  # MMP
    return 999999999
  end
  
  #--------------------------------------------------------------------------
  # ● 능력치에 가산하는 값을 클리어
  #--------------------------------------------------------------------------
  alias clear_param_plus_KMS_DistributeParameter clear_param_plus
  def clear_param_plus
    clear_param_plus_KMS_DistributeParameter

    clear_distribution_values
    calc_distribution_values
  end
  
  #--------------------------------------------------------------------------
  # ○ 파라미터 분배에 관한 값을 클리어
  #--------------------------------------------------------------------------
  def clear_distribution_values
    @distributed_count = {}
    KMS_DistributeParameter::PARAMS.each { |param|
      @distributed_count[param] = 0
    }
  end
  
  #--------------------------------------------------------------------------
  # ○ 파라미터 분배에 관한 값을 체크
  #--------------------------------------------------------------------------
  def check_distribution_values
    last_distributed_count = @distributed_count
    clear_distribution_values
    @distributed_count = last_distributed_count if last_distributed_count != nil
  end
  
  #--------------------------------------------------------------------------
  # ○ 다양한 수정 값 계산
  #--------------------------------------------------------------------------
  def calc_distribution_values
    # 상속 대상으로 정의
  end
  
  #--------------------------------------------------------------------------
  # ○ 배분에 의한 상승치 취득
  #     param : パラメータの Symbol
  #--------------------------------------------------------------------------
  def distributed_param(param)
    return 0
  end
  
  #--------------------------------------------------------------------------
  # ○ 분류에 대한 정보 얻기
  #--------------------------------------------------------------------------
  def distribution_info
    info = KMS_DistributeParameter::DistInfo.new
    info.count = @distributed_count.clone if @distributed_count != nil
    info.hp    = self.hp
    info.mp    = self.mp
    return info
  end
  
  #--------------------------------------------------------------------------
  # ○ 분류에 대한 정보 설정
  #--------------------------------------------------------------------------
  def set_distribution_info(info)
    return unless info.is_a?(KMS_DistributeParameter::DistInfo)
    @distributed_count = info.count
    calc_distribution_values
    self.hp = info.hp
    self.mp = info.mp
  end
end