# encoding: utf-8
# Name: Game_BattlerBase
# Size: 34904
#==============================================================================
# ** Game_BattlerBase
#------------------------------------------------------------------------------
#  This base class handles battlers. It mainly contains methods for calculating
# parameters. It is used as a super class of the Game_Battler class.
#==============================================================================

class Game_BattlerBase
  #--------------------------------------------------------------------------
  # * Constants (Features)
  #--------------------------------------------------------------------------
  FEATURE_ELEMENT_RATE  = 11              # Element Rate
  FEATURE_DEBUFF_RATE   = 12              # Debuff Rate
  FEATURE_STATE_RATE    = 13              # State Rate
  FEATURE_STATE_RESIST  = 14              # State Resist
  FEATURE_PARAM         = 21              # Parameter
  FEATURE_XPARAM        = 22              # Ex-Parameter
  FEATURE_SPARAM        = 23              # Sp-Parameter
  FEATURE_ATK_LK        = 24              # 치명타 공격 비율
  FEATURE_ATK_ELEMENT   = 31              # Atk Element
  FEATURE_ATK_STATE     = 32              # Atk State
  FEATURE_ATK_SPEED     = 33              # Atk Speed
  FEATURE_ATK_TIMES     = 34              # Atk Times+
  FEATURE_STYPE_ADD     = 41              # Add Skill Type
  FEATURE_STYPE_SEAL    = 42              # Disable Skill Type
  FEATURE_SKILL_ADD     = 43              # Add Skill
  FEATURE_SKILL_SEAL    = 44              # Disable Skill
  FEATURE_EQUIP_WTYPE   = 51              # Equip Weapon
  FEATURE_EQUIP_ATYPE   = 52              # Equip Armor
  FEATURE_EQUIP_FIX     = 53              # Lock Equip
  FEATURE_EQUIP_SEAL    = 54              # Seal Equip
  FEATURE_SLOT_TYPE     = 55              # Slot Type
  FEATURE_ACTION_PLUS   = 61              # Action Times+
  FEATURE_SPECIAL_FLAG  = 62              # Special Flag
  FEATURE_COLLAPSE_TYPE = 63              # Collapse Effect
  FEATURE_PARTY_ABILITY = 64              # Party Ability
  #--------------------------------------------------------------------------
  # * Constants (Feature Flags)
  #--------------------------------------------------------------------------
  FLAG_ID_AUTO_BATTLE   = 0               # auto battle
  FLAG_ID_GUARD         = 1               # guard
  FLAG_ID_SUBSTITUTE    = 2               # substitute
  FLAG_ID_PRESERVE_TP   = 3               # preserve TP
  #--------------------------------------------------------------------------
  # * Constants (Starting Number of Buff/Debuff Icons)
  #--------------------------------------------------------------------------
  ICON_BUFF_START       = 64              # buff (16 icons)
  ICON_DEBUFF_START     = 80              # debuff (16 icons)
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :hp                       # HP
  attr_reader   :mp                       # MP
  attr_reader   :tp                       # TP
  #--------------------------------------------------------------------------
  # * Access Method by Parameter Abbreviations
  #--------------------------------------------------------------------------
  def mhp;  param(0);   end               # MHP  Maximum Hit Points
  def mmp;  param(1);   end               # MMP  Maximum Magic Points
  def atk;  param(2);   end               # ATK  ATtacK power
  def def;  param(3);   end               # DEF  DEFense power
  def mat;  param(4);   end               # MAT  Magic ATtack power
  def mdf;  param(5);   end               # MDF  Magic DeFense power
  def agi;  param(6);   end               # AGI  AGIlity
  def luk;  param(7);   end               # LUK  LUcK
  def hit;  xparam(0);  end               # HIT  HIT rate
  def eva;  xparam(1);  end               # EVA  EVAsion rate
  def cri;  xparam(2);  end               # CRI  CRItical rate
  def cev;  xparam(3);  end               # CEV  Critical EVasion rate
  def mev;  xparam(4);  end               # MEV  Magic EVasion rate
  def mrf;  xparam(5);  end               # MRF  Magic ReFlection rate
  def cnt;  xparam(6);  end               # CNT  CouNTer attack rate
  def hrg;  xparam(7);  end               # HRG  Hp ReGeneration rate
  def mrg;  xparam(8);  end               # MRG  Mp ReGeneration rate
  def trg;  xparam(9);  end               # TRG  Tp ReGeneration rate
  def tgr;  sparam(0);  end               # TGR  TarGet Rate
  def grd;  sparam(1);  end               # GRD  GuaRD effect rate
  def rec;  sparam(2);  end               # REC  RECovery effect rate
  def pha;  sparam(3);  end               # PHA  PHArmacology
  def mcr;  sparam(4);  end               # MCR  Mp Cost Rate
  def tcr;  sparam(5);  end               # TCR  Tp Charge Rate
  def pdr;  sparam(6);  end               # PDR  Physical Damage Rate
  def mdr;  sparam(7);  end               # MDR  Magical Damage Rate
  def fdr;  sparam(8);  end               # FDR  Floor Damage Rate
  def exr;  sparam(9);  end               # EXR  EXperience Rate
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    @hp = @mp = @tp = 0
    @hidden = false
    clear_param_plus
    clear_states
    clear_buffs
  end
  #--------------------------------------------------------------------------
  # * Clear Values Added to Parameter
  #--------------------------------------------------------------------------
  def clear_param_plus
    @param_plus = [0] * 8
  end
  #--------------------------------------------------------------------------
  # * Clear State Information
  #--------------------------------------------------------------------------
  def clear_states
    @states = []
    @state_turns = {}
    @state_steps = {}
  end
  #--------------------------------------------------------------------------
  # * Erase States
  #--------------------------------------------------------------------------
  def erase_state(state_id)
    @states.delete(state_id)
    @state_turns.delete(state_id)
    @state_steps.delete(state_id)
  end
  #--------------------------------------------------------------------------
  # * Clear Buff Information
  #--------------------------------------------------------------------------
  def clear_buffs
    @buffs = Array.new(8) { 0 }
    @buff_turns = {}
  end
  #--------------------------------------------------------------------------
  # * Check State
  #--------------------------------------------------------------------------
  def state?(state_id)
    @states.include?(state_id)
  end
  #--------------------------------------------------------------------------
  # * Check K.O. State
  #--------------------------------------------------------------------------
  def death_state?
    state?(death_state_id)
  end
  #--------------------------------------------------------------------------
  # * Get State ID of K.O.
  #--------------------------------------------------------------------------
  def death_state_id
    return 1
  end
  #--------------------------------------------------------------------------
  # * 현재 상태를 객체 배열로 가져오기
  #--------------------------------------------------------------------------
  def states
    @states.collect {|id| $data_states[id] }
  end
  #--------------------------------------------------------------------------
  # * 아이콘 번호의 배열로 현재 상태 가져오기
  #--------------------------------------------------------------------------
  def state_icons
    icons = states.collect {|state| state.icon_index }
    icons.delete(0)
    icons
  end
  #--------------------------------------------------------------------------
  # * Get Current Buffs/Debuffs as an Array of Icon Numbers
  #--------------------------------------------------------------------------
  def buff_icons
    icons = []
    @buffs.each_with_index {|lv, i| icons.push(buff_icon_index(lv, i)) }
    icons.delete(0)
    icons
  end
  #--------------------------------------------------------------------------
  # * Get Icon Number Corresponding to Buff/Debuff
  #--------------------------------------------------------------------------
  def buff_icon_index(buff_level, param_id)
    if buff_level > 0
      return ICON_BUFF_START + (buff_level - 1) * 8 + param_id
    elsif buff_level < 0
      return ICON_DEBUFF_START + (-buff_level - 1) * 8 + param_id 
    else
      return 0
    end
  end
  #--------------------------------------------------------------------------
  # * Get Array of All Objects Retaining Features
  #--------------------------------------------------------------------------
  def feature_objects
    states
  end
  #--------------------------------------------------------------------------
  # * 모든 기능 개체의 배열 가져오기
  #--------------------------------------------------------------------------
  def all_features
    feature_objects.inject([]) {|r, obj| r + obj.features }
  end
  #--------------------------------------------------------------------------
  # * 기능 개체 배열 가져오기(기능 코드 제한)
  #--------------------------------------------------------------------------
  def features(code)
    all_features.select {|ft| ft.code == code }
  end
  #--------------------------------------------------------------------------
  # * 기능 개체 배열 가져오기(기능 코드 및 데이터 ID 제한)
  #--------------------------------------------------------------------------
  def features_with_id(code, id)
    all_features.select {|ft| ft.code == code && ft.data_id == id }
  end
  #--------------------------------------------------------------------------
  # * 특성 값의 보수 계산
  #--------------------------------------------------------------------------
  def features_pi(code, id)
    features_with_id(code, id).inject(1.0) {|r, ft| r *= ft.value }
  end
  #--------------------------------------------------------------------------
  # * 특성 값의 합계 계산(데이터 ID 지정)
  #--------------------------------------------------------------------------
  def features_sum(code, id)
    features_with_id(code, id).inject(0.0) {|r, ft| r += ft.value }
  end
  #--------------------------------------------------------------------------
  # * 추가한 합산 계산식
  #--------------------------------------------------------------------------
  def features_sum2(code, id)
    features_with_id(code, id).inject(1.0) {|r, ft| r += (ft.value - 1.0) }
  end
  #--------------------------------------------------------------------------
  # * 특성 값의 합계 계산(데이터 ID 지정되지 않음)
  #--------------------------------------------------------------------------
  def features_sum_all(code)
    features(code).inject(0.0) {|r, ft| r += ft.value }
  end
  #--------------------------------------------------------------------------
  # * Calculate Set Sum of Features
  #--------------------------------------------------------------------------
  def features_set(code)
    features(code).inject([]) {|r, ft| r |= [ft.data_id] }
  end
  #--------------------------------------------------------------------------
  # * Get Base Value of Parameter
  #--------------------------------------------------------------------------
  def param_base(param_id)
    return 0
  end
  #--------------------------------------------------------------------------
  # * Get Added Value of Parameter
  #--------------------------------------------------------------------------
  def param_plus(param_id)
    @param_plus[param_id]
  end
  #--------------------------------------------------------------------------
  # * Get Reduced Value of Parameter
  #--------------------------------------------------------------------------
  def param_min(param_id)
    return 0 if param_id == 1  # MMP
    return 1
  end
  #--------------------------------------------------------------------------
  # * Get Maximum Value of Parameter
  #--------------------------------------------------------------------------
  def param_max(param_id)
    return 999999 if param_id == 0  # MHP
    return 9999   if param_id == 1  # MMP
    return 999
  end
  #--------------------------------------------------------------------------
  # * 파라미터 변화율 얻기
  #--------------------------------------------------------------------------
  def param_rate(param_id)
    #features_pi(FEATURE_PARAM, param_id)
    # 능력치 % 합산으로 변경
    features_sum2(FEATURE_PARAM, param_id)
  end
  #--------------------------------------------------------------------------
  # * 파라미터 버프/디버프로 인한 변화율 구하기
  #--------------------------------------------------------------------------
  def param_buff_rate(param_id)
    @buffs[param_id] * 0.25 + 1.0
  end
  #--------------------------------------------------------------------------
  # * 매개변수 가져오기
  #--------------------------------------------------------------------------
  def param(param_id)
    value = param_base(param_id) + param_plus(param_id)
    value += param_rate(param_id) * param_base(param_id)
    value += param_buff_rate(param_id) * param_base(param_id)
    
    #value *= param_rate(param_id) * param_buff_rate(param_id)
    [[value, param_max(param_id)].min, param_min(param_id)].max.to_i
  end
  #--------------------------------------------------------------------------
  # * Ex 매개변수 가져오기
  #--------------------------------------------------------------------------
  def xparam(xparam_id)
    features_sum(FEATURE_XPARAM, xparam_id)
  end
  #--------------------------------------------------------------------------
  # * Sp 매개변수 가져오기
  #--------------------------------------------------------------------------
  def sparam(sparam_id)
    features_pi(FEATURE_SPARAM, sparam_id)
  end
  #--------------------------------------------------------------------------
  # * 요소 비율 가져오기
  #--------------------------------------------------------------------------
  def element_rate(element_id)
    features_pi(FEATURE_ELEMENT_RATE, element_id)
  end
  #--------------------------------------------------------------------------
  # * 디버프율 받기
  #--------------------------------------------------------------------------
  def debuff_rate(param_id)
    features_pi(FEATURE_DEBUFF_RATE, param_id)
  end
  #--------------------------------------------------------------------------
  # * 주 비율 가져오기
  #--------------------------------------------------------------------------
  def state_rate(state_id)
    features_pi(FEATURE_STATE_RATE, state_id)
  end
  #--------------------------------------------------------------------------
  # * 저항할 상태 배열 가져오기
  #--------------------------------------------------------------------------
  def state_resist_set
    features_set(FEATURE_STATE_RESIST)
  end
  #--------------------------------------------------------------------------
  # * 상태가 저항하는지 확인
  #--------------------------------------------------------------------------
  def state_resist?(state_id)
    state_resist_set.include?(state_id)
  end
  #--------------------------------------------------------------------------
  # * 공격 요소 가져오기
  #--------------------------------------------------------------------------
  def atk_elements
    features_set(FEATURE_ATK_ELEMENT)
  end
  #--------------------------------------------------------------------------
  # * 공격 상태 가져오기
  #--------------------------------------------------------------------------
  def atk_states
    features_set(FEATURE_ATK_STATE)
  end
  #--------------------------------------------------------------------------
  # * 공격 상태 호출 비율 가져오기
  #--------------------------------------------------------------------------
  def atk_states_rate(state_id)
    features_sum(FEATURE_ATK_STATE, state_id)
  end
  #--------------------------------------------------------------------------
  # * Get Attack Speed
  #--------------------------------------------------------------------------
  def atk_speed
    features_sum_all(FEATURE_ATK_SPEED)
  end
  #--------------------------------------------------------------------------
  # * 추가 공격 시간 확보
  #--------------------------------------------------------------------------
  def atk_times_add
    features_sum_all(FEATURE_ATK_TIMES)
    #[features_sum_all(FEATURE_ATK_TIMES), 0].max
  end
  #--------------------------------------------------------------------------
  # * 추가된 기술 유형 가져오기
  #--------------------------------------------------------------------------
  def added_skill_types
    features_set(FEATURE_STYPE_ADD)
  end
  #--------------------------------------------------------------------------
  # * 기술 유형이 비활성화되어 있는지 확인
  #--------------------------------------------------------------------------
  def skill_type_sealed?(stype_id)
    features_set(FEATURE_STYPE_SEAL).include?(stype_id)
  end
  #--------------------------------------------------------------------------
  # * Get Added Skills
  #--------------------------------------------------------------------------
  def added_skills
    features_set(FEATURE_SKILL_ADD)
  end
  #--------------------------------------------------------------------------
  # * 스킬이 비활성화되었는지 확인
  #--------------------------------------------------------------------------
  def skill_sealed?(skill_id)
    features_set(FEATURE_SKILL_SEAL).include?(skill_id)
  end
  #--------------------------------------------------------------------------
  # * 무기 장착 가능 여부 확인
  #--------------------------------------------------------------------------
  def equip_wtype_ok?(wtype_id)
    features_set(FEATURE_EQUIP_WTYPE).include?(wtype_id)
  end
  #--------------------------------------------------------------------------
  # * 갑옷을 장착할 수 있는지 확인
  #--------------------------------------------------------------------------
  def equip_atype_ok?(atype_id)
    features_set(FEATURE_EQUIP_ATYPE).include?(atype_id)
  end
  #--------------------------------------------------------------------------
  # * 장비가 잠겨 있는지 확인
  #--------------------------------------------------------------------------
  def equip_type_fixed?(etype_id)
    features_set(FEATURE_EQUIP_FIX).include?(etype_id)
  end
  #--------------------------------------------------------------------------
  # * 장비가 봉인되었는지 확인
  #--------------------------------------------------------------------------
  def equip_type_sealed?(etype_id)
    features_set(FEATURE_EQUIP_SEAL).include?(etype_id)
  end
  #--------------------------------------------------------------------------
  # * 슬롯 유형 가져오기
  #--------------------------------------------------------------------------
  def slot_type
    features_set(FEATURE_SLOT_TYPE).max || 0
  end
  #--------------------------------------------------------------------------
  # * 이중 사용 여부 확인
  #--------------------------------------------------------------------------
  def dual_wield?
    slot_type == 1
  end
  #--------------------------------------------------------------------------
  # * 추가 작업 시간 확률 배열 가져오기
  #--------------------------------------------------------------------------
  def action_plus_set
    features(FEATURE_ACTION_PLUS).collect {|ft| ft.value }
  end
  def action_plus_set2
    value = 0
    value = action_plus_set.inject(:+)
    value.to_f
  end
  #--------------------------------------------------------------------------
  # * Determine if Special Flag
  #--------------------------------------------------------------------------
  def special_flag(flag_id)
    features(FEATURE_SPECIAL_FLAG).any? {|ft| ft.data_id == flag_id }
  end
  #--------------------------------------------------------------------------
  # * Get Collapse Effect
  #--------------------------------------------------------------------------
  def collapse_type
    features_set(FEATURE_COLLAPSE_TYPE).max || 0
  end
  #--------------------------------------------------------------------------
  # * Determine Party Ability
  #--------------------------------------------------------------------------
  def party_ability(ability_id)
    features(FEATURE_PARTY_ABILITY).any? {|ft| ft.data_id == ability_id }
  end
  #--------------------------------------------------------------------------
  # * Determine if Auto Battle
  #--------------------------------------------------------------------------
  def auto_battle?
    special_flag(FLAG_ID_AUTO_BATTLE)
  end
  #--------------------------------------------------------------------------
  # * Determine if Guard
  #--------------------------------------------------------------------------
  def guard?
    special_flag(FLAG_ID_GUARD) && movable?
  end
  #--------------------------------------------------------------------------
  # * Determine if Substitute
  #--------------------------------------------------------------------------
  def substitute?
    special_flag(FLAG_ID_SUBSTITUTE) && movable?
  end
  #--------------------------------------------------------------------------
  # * Determine if Preserve TP
  #--------------------------------------------------------------------------
  def preserve_tp?
    special_flag(FLAG_ID_PRESERVE_TP)
  end
  #--------------------------------------------------------------------------
  # * 매개변수 증가
  #--------------------------------------------------------------------------
  def add_param(param_id, value)
    @param_plus[param_id] += value
    refresh
  end
  #--------------------------------------------------------------------------
  # * Change HP
  #--------------------------------------------------------------------------
  def hp=(hp)
    @hp = hp
    refresh
  end
  #--------------------------------------------------------------------------
  # * Change MP
  #--------------------------------------------------------------------------
  def mp=(mp)
    @mp = mp
    refresh
  end
  #--------------------------------------------------------------------------
  # * Change HP (for Events)
  #     value:         Amount of increase/decrease
  #     enable_death:  Allow knockout
  #--------------------------------------------------------------------------
  def change_hp(value, enable_death)
    if !enable_death && @hp + value <= 0
      self.hp = 1
    else
      self.hp += value
    end
  end
  #--------------------------------------------------------------------------
  # * Change TP
  #--------------------------------------------------------------------------
  def tp=(tp)
    @tp = [[tp, max_tp].min, 0].max
  end
  #--------------------------------------------------------------------------
  # * Get Maximum Value of TP
  #--------------------------------------------------------------------------
  def max_tp
    return 100
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    state_resist_set.each {|state_id| erase_state(state_id) }
    @hp = [[@hp, mhp].min, 0].max
    @mp = [[@mp, mmp].min, 0].max
    @hp == 0 ? add_state(death_state_id) : remove_state(death_state_id)
  end
  #--------------------------------------------------------------------------
  # * Recover All
  #--------------------------------------------------------------------------
  def recover_all
    clear_states
    @hp = mhp
    @mp = mmp
  end
  #--------------------------------------------------------------------------
  # * Get Percentage of HP
  #--------------------------------------------------------------------------
  def hp_rate
    @hp.to_f / mhp
  end
  #--------------------------------------------------------------------------
  # * Get Percentage of MP
  #--------------------------------------------------------------------------
  def mp_rate
    mmp > 0 ? @mp.to_f / mmp : 0
  end
  #--------------------------------------------------------------------------
  # * Get Percentage of TP
  #--------------------------------------------------------------------------
  def tp_rate
    @tp.to_f / 100
  end
  #--------------------------------------------------------------------------
  # * Hide
  #--------------------------------------------------------------------------
  def hide
    @hidden = true
  end
  #--------------------------------------------------------------------------
  # * Appear
  #--------------------------------------------------------------------------
  def appear
    @hidden = false
  end
  #--------------------------------------------------------------------------
  # * Get Hide State
  #--------------------------------------------------------------------------
  def hidden?
    @hidden
  end
  #--------------------------------------------------------------------------
  # * 존재 확인
  #--------------------------------------------------------------------------
  def exist?
    !hidden?
  end
  #--------------------------------------------------------------------------
  # * 무능력 판정
  #--------------------------------------------------------------------------
  def dead?
    exist? && death_state?
  end
  #--------------------------------------------------------------------------
  # * 생존을 결정
  #--------------------------------------------------------------------------
  def alive?
    exist? && !death_state?
  end
  #--------------------------------------------------------------------------
  # * 정규성 결정
  #--------------------------------------------------------------------------
  def normal?
    exist? && restriction == 0
  end
  #--------------------------------------------------------------------------
  # * Determine if Command is Inputable
  #--------------------------------------------------------------------------
  def inputable?
    normal? && !auto_battle?
  end
  #--------------------------------------------------------------------------
  # * 조치가 가능한지 확인
  #--------------------------------------------------------------------------
  def movable?
    exist? && restriction < 4
  end
  #--------------------------------------------------------------------------
  # * 문자가 혼란스러운지 확인
  #--------------------------------------------------------------------------
  def confusion?
    exist? && restriction >= 1 && restriction <= 3
  end
  #--------------------------------------------------------------------------
  # * 혼란 수준 얻기
  #--------------------------------------------------------------------------
  def confusion_level
    confusion? ? restriction : 0
  end
  #--------------------------------------------------------------------------
  # * Determine if Actor or Not
  #--------------------------------------------------------------------------
  def actor?
    return false
  end
  #--------------------------------------------------------------------------
  # * Determine if Enemy
  #--------------------------------------------------------------------------
  def enemy?
    return false
  end
  #--------------------------------------------------------------------------
  # * 상태 정렬
  # @states 배열의 내용을 우선 순위가 높은 상태로 정렬합니다.
  # 먼저 옵니다.
  #--------------------------------------------------------------------------
  def sort_states
    @states = @states.sort_by {|id| [-$data_states[id].priority, id] }
  end
  #--------------------------------------------------------------------------
  # * 제한 받기
  # 현재 추가된 상태에서 가장 큰 제한을 가져옵니다.
  #--------------------------------------------------------------------------
  def restriction
    states.collect {|state| state.restriction }.push(0).max
  end
  #--------------------------------------------------------------------------
  # * 가장 중요한 상태 연속 메시지 가져오기
  #--------------------------------------------------------------------------
  def most_important_state_text
    states.each {|state| return state.message3 unless state.message3.empty? }
    return ""
  end
  #--------------------------------------------------------------------------
  # * 스킬 요구 무기가 장착되어 있는지 확인
  #--------------------------------------------------------------------------
  def skill_wtype_ok?(skill)
    return true
  end
  #--------------------------------------------------------------------------
  # * Calculate Skill's MP Cost
  #--------------------------------------------------------------------------
  def skill_mp_cost(skill)
    (skill.mp_cost * mcr).to_i
  end
  #--------------------------------------------------------------------------
  # * Calculate Skill's TP Cost
  #--------------------------------------------------------------------------
  def skill_tp_cost(skill)
    skill.tp_cost
  end
  #--------------------------------------------------------------------------
  # * 기술 사용 비용을 지불할 수 있는지 확인
  #--------------------------------------------------------------------------
  def skill_cost_payable?(skill)
    # 생존의 달인 스킬
    if skill.id == 241
      $game_switches[106] == true && tp >= skill_tp_cost(skill) && mp >= skill_mp_cost(skill)
    else
      tp >= skill_tp_cost(skill) && mp >= skill_mp_cost(skill)
    end
  end
  #--------------------------------------------------------------------------
  # * Pay Cost of Using Skill
  #--------------------------------------------------------------------------
  def pay_skill_cost(skill)
    self.mp -= skill_mp_cost(skill)
    self.tp -= skill_tp_cost(skill)
  end
  #--------------------------------------------------------------------------
  # * 스킬/아이템 사용 가능 시기 확인
  #--------------------------------------------------------------------------
  def occasion_ok?(item)
    $game_party.in_battle ? item.battle_ok? : item.menu_ok?
  end
  #--------------------------------------------------------------------------
  # * 스킬/아이템 공통 사용 조건 확인
  #--------------------------------------------------------------------------
  def usable_item_conditions_met?(item)
    #item.effects.code.include?(44)
    #print("Game_BattlerBase - %s \n" % [item.effects]);
    #print("Game_BattlerBase - %s \n" % [item.effects.include?("#<RPG::UsableItem::Effect:0x109b8240 @code=44")]);
    
    #item.effects.each {|effects| 
    #print("Game_BattlerBase - %s \n" % [effects.code == 44]);
    #if effects.code == 44
      #print("Game_BattlerBase - %s \n" % [$game_switches[152]]);
    #  movable? && occasion_ok?(item) and $game_switches[152] == false
    #else
    #  movable? && occasion_ok?(item)
    #end
    #}
    
    # 아래는 원본이다.
    movable? && occasion_ok?(item)
  end
  #--------------------------------------------------------------------------
  # * 스킬 사용 조건 확인
  #--------------------------------------------------------------------------
  def skill_conditions_met?(skill)
    usable_item_conditions_met?(skill) &&
    skill_wtype_ok?(skill) && skill_cost_payable?(skill) &&
    !skill_sealed?(skill.id) && !skill_type_sealed?(skill.stype_id)
  end
  #--------------------------------------------------------------------------
  # * 아이템 사용 조건 확인
  #--------------------------------------------------------------------------
  def item_conditions_met?(item)
    usable_item_conditions_met?(item) && $game_party.has_item?(item)
  end
  #--------------------------------------------------------------------------
  # * 스킬/아이템 사용성 결정
  #--------------------------------------------------------------------------
  def usable?(item)
    # 커먼 이벤트 예약이 된 경우 취소
    item.effects.each {|effects| 
      return false if effects.code == 44 and $game_temp.common_event_reserved?
    }
    # 아래는 원본이다.
    return skill_conditions_met?(item) if item.is_a?(RPG::Skill)
    return item_conditions_met?(item)  if item.is_a?(RPG::Item)
    return false
  end
  #--------------------------------------------------------------------------
  # * Determine if Equippable
  #--------------------------------------------------------------------------
  def equippable?(item)
    return false unless item.is_a?(RPG::EquipItem)
    return false if equip_type_sealed?(item.etype_id)
    return equip_wtype_ok?(item.wtype_id) if item.is_a?(RPG::Weapon)
    return equip_atype_ok?(item.atype_id) if item.is_a?(RPG::Armor)
    return false
  end
  #--------------------------------------------------------------------------
  # * Get Skill ID of Normal Attack
  #--------------------------------------------------------------------------
  def attack_skill_id
    return 1
  end
  #--------------------------------------------------------------------------
  # * Get Skill ID of Guard
  #--------------------------------------------------------------------------
  def guard_skill_id
    return 2
  end
  #--------------------------------------------------------------------------
  # * 일반 공격의 유용성 결정
  #--------------------------------------------------------------------------
  def attack_usable?
    usable?($data_skills[attack_skill_id])
  end
  #--------------------------------------------------------------------------
  # * Determine Usability of Guard
  #--------------------------------------------------------------------------
  def guard_usable?
    usable?($data_skills[guard_skill_id])
  end
end