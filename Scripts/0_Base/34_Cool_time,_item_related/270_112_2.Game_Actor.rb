# encoding: utf-8
# Name: 112_2.Game_Actor
# Size: 64760
class Game_Actor < Game_Battler
  attr_reader   :available_skills
  
  attr_reader   :default_character_name           # 캐릭터 그래픽 파일명
  attr_reader   :default_character_index          # 캐릭터 그래픽 인덱스
  attr_reader   :default_face_name                # 얼굴 그래픽 파일 이름
  attr_reader   :default_face_index               # 얼굴 그래픽 인덱스
  
  attr_accessor :assigned_skill, :assigned_item, :primary_use
  attr_accessor :assigned_skill2, :assigned_item2, :usability
  attr_accessor :assigned_skill3, :assigned_skill4
  attr_accessor :assigned_skill5, :assigned_skill6
  attr_accessor :assigned_skill7, :assigned_skill8
  attr_accessor :assigned_item3, :assigned_item4
  
  # 동료 콤보 확장 추가
  attr_accessor :come_skill, :come_skill2, :come_skill3, :come_skill4
  attr_accessor :come_skill5, :come_skill6, :come_skill7, :come_skill8
  
  # 캐릭터 욕구
  attr_accessor :hunger,:hunger_max,:hunger_rate
  attr_accessor :thirst,:thirst_max,:thirst_rate
  attr_accessor :sleep,:sleep_max,:sleep_rate
  attr_accessor :repute,:repute_max,:repute_rate
  attr_accessor :sexual,:sexual_max,:sexual_rate
  attr_accessor :piety,:piety_max,:piety_rate
  attr_accessor :hygiene,:hygiene_max,:hygiene_rate
  attr_accessor :temper,:temper_max,:temper_rate
  attr_accessor :stress_rate,:stress,:stress_max
  attr_accessor :cold_rate,:cold,:cold_max
  attr_accessor :drunk_rate,:drunk,:drunk_max
  
  attr_accessor :equip_image
  attr_accessor :discovered
  attr_accessor :in_roster
  attr_accessor :weight_mod   # 장비 무게
  
  attr_accessor :skill_point  # 스킬포인트
  attr_accessor :skill_point2 # 스킬포인트
  
  #--------------------------------------------------------------------------
  # ○ 클래스 변수
  #--------------------------------------------------------------------------
  @@__distribute_gain_params = {}
  
  #--------------------------------------------------------------------------
  # ● 객체 초기화
  #--------------------------------------------------------------------------
  alias initialize_KMS_DistributeParameter initialize
  def initialize(actor_id)
    #print("112_2.Game_Actor - ");
    #print("%s 객체 초기화 진행 \n" % [$data_actors[actor_id].name]);
    @actor_id = actor_id
    @class_id = actor.class_id
    @available_skills = []
    initialize_KMS_DistributeParameter(actor_id)
  end
  
  alias falcaopearl_cooldown_setup setup
  def setup(actor_id)
    #print("112_2.Game_Actor - ");
    #print("%s 설정 입력 진행 \n" % [$data_actors[actor_id].name]);
    @usability = [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
    @primary_use = 1
    
    @hunger = 0;  @hunger_max = actor.hunger_max
    @thirst = 0;  @thirst_max = actor.thirst_max
    @sleep = 0;   @sleep_max = actor.sleep_max
    @repute = 0;  @repute_max = actor.repute_max
    @sexual = 0;  @sexual_max = actor.sexual_max
    @piety = 0;   @piety_max = actor.piety_max
    @hygiene = 0; @hygiene_max = actor.hygiene_max
    @temper = 50; @temper_max = actor.temper_max
    @stress = 20; @stress_max = actor.stress_max
    @cold = 0;    @cold_max = actor.cold_max
    @drunk = 0;   @drunk_max = actor.drunk_max
    
    @come_skill = nil;    @come_skill2 = nil
    @come_skill3 = nil;   @come_skill4 = nil
    @come_skill5 = nil;   @come_skill6 = nil
    @come_skill7 = nil;   @come_skill8 = nil
    
    actor = $data_actors[actor_id]
    @default_character_name = actor.character_name
    @default_character_index = actor.character_index
    @default_face_name = actor.face_name
    @default_face_index = actor.face_index
    @weight_mod = 0
    @equip_image = equip_image
    
    reset_passive_rev
    
    falcaopearl_cooldown_setup(actor_id)
    
    refresh_graphic_equip
    restore_passive_rev
    
    get_type = IMIR_SkillPoint::GetPointType
    @skill_point = 0
    @skill_point2 = 0
    case get_type
    when 0
      @skill_point += @level
    when 1
      @skill_point += @level * IMIR_SkillPoint::DefaultPoint
    when 2
      @skill_point += @level / 10
    end
  end
  
  def available_skills
    skills.select {|skill| skill_wtype_ok?(skill) && skill_cost_payable?(skill) &&
    !skill_sealed?(skill.id) && !skill_type_sealed?(skill.stype_id) }
  end
  
  alias learn_skill_passive_dummies_original learn_skill
  def learn_skill(skill_id)
    learn_skill_passive_dummies_original(skill_id)
    @available_skills = available_skills
  end
  
  alias forget_skill_passive_dummies_original forget_skill
  def forget_skill(skill_id)
    forget_skill_passive_dummies_original(skill_id)
    @available_skills = available_skills
    refresh
  end
  
  def passive_skills
    @skills.select {|skill| passive?(skill) }.collect {|id| $data_skills[id] }
  end
  
  #--------------------------------------------------------------------------
  # * 다양한 패시브 스킬 더미 획득
  #--------------------------------------------------------------------------
  def passive_skills_dummies
    @available_skills.select {|skill| skill.passive? }.collect {|id| $data_weapons[id.note_field[:passive]] }
  end
  
  def passive?(skill)
    $data_skills[skill].passive?
  end
  
  alias feature_objects_passive_dummies_original feature_objects
  def feature_objects
    feature_objects_passive_dummies_original + passive_skills_dummies
  end
  
  alias param_plus_passive_dummies_original param_plus
  def param_plus(param_id)
    passive_skills_dummies.compact.inject(param_plus_passive_dummies_original(param_id)) {|r, item| r += item.params[param_id] }
  end
  
  #--------------------------------------------------------------------------
  # ○ 상태이상 능력치 추가
  #--------------------------------------------------------------------------
  alias :th_parameter_bonuses_param_bonus_objects :param_bonus_objects
  def param_bonus_objects
    feature_objects
  end
  
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 수정치를 초기화
  #--------------------------------------------------------------------------
  def reset_passive_rev
    @passive_params = {}
    @passive_params_rate = {}
    @passive_xparams = {}
    @passive_sparams = {}
    @passive_elre = {}
    @passive_bfre = {}
    @passive_stre = {}
    @passive_stno = {}
    @passive_atel = {}
    @passive_atst = {}
    @passive_atsp = 0
    @passive_atnu = 0
    @passive_skty = {}
    @passive_skts = {}
    @passive_skpl = {}
    @passive_skse = {}
    @passive_wety = {}
    @passive_arty = {}
    @passive_eqfx = {}
    @passive_eqse = {}
    @passive_dbwp = 0
    
    PassiveSkill::PARAMS.each_key { |k|
      @passive_params[k] = 0
      @passive_params_rate[k] = 0
    }
    PassiveSkill::XPARAMS.each_key { |k| @passive_xparams[k] = 0 }
    PassiveSkill::SPARAMS.each_key { |k| @passive_sparams[k] = 0 }
    for i in 1..$data_system.elements.size
      @passive_elre[i] = 0
      @passive_atel[i] = 0
    end
    for i in 0..7
      @passive_bfre[i] = 0
    end
    for i in 1..$data_states.size
      @passive_stre[i] = 0
      @passive_stno[i] = 0
      @passive_atst[i] = 0
    end
    for i in 1..$data_system.skill_types.size
      @passive_skty[i] = 0
      @passive_skts[i] = 0
    end
    for i in 1..$data_skills.size
      @passive_skpl[i] = 0
      @passive_skse[i] = 0
    end
    for i in 1..$data_system.weapon_types.size
      @passive_wety[i] = 0
    end
    for i in 1..$data_system.armor_types.size
      @passive_arty[i] = 0
    end
    for i in 0..4 #.equip_slots.size
      @passive_eqfx[i] = 0
      @passive_eqse[i] = 0
    end
    
  end
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 수정치를 재설정  
  #--------------------------------------------------------------------------
  def restore_passive_rev
    reset_passive_rev

    # 수정치를 취득
    skills.each { |skill|
      next unless skill.passive
      next if skill.passive_wpm and not weapon_mastery?(skill)
      next if skill.passive_arm and not armor_mastery?(skill)

      skill.passive_params.each { |k, v| @passive_params[k] += v }
      skill.passive_params_rate.each { |k, v| @passive_params_rate[k] += v }
      skill.passive_xparams.each { |k, v| @passive_xparams[k] += v }
      skill.passive_sparams.each { |k, v| @passive_sparams[k] += v }
      skill.passive_elre.each{ |k, v| @passive_elre[k] += v }
      skill.passive_bfre.each{ |k, v| @passive_bfre[k] += v }
      skill.passive_stre.each{ |k, v| @passive_stre[k] += v }
      skill.passive_stno.each{ |k, v| @passive_stno[k] += v }
      skill.passive_atel.each{ |k, v| @passive_atel[k] += v }
      skill.passive_atst.each{ |k, v| @passive_atst[k] += v }
      @passive_atsp += skill.passive_atsp
      @passive_atnu += skill.passive_atnu
      skill.passive_skty.each{ |k, v| @passive_skty[k] += v }
      skill.passive_skts.each{ |k, v| @passive_skts[k] += v }
      skill.passive_skpl.each{ |k, v| @passive_skpl[k] += v }
      skill.passive_skse.each{ |k, v| @passive_skse[k] += v }
      skill.passive_wety.each{ |k, v| @passive_wety[k] += v }
      skill.passive_arty.each{ |k, v| @passive_arty[k] += v }
      skill.passive_eqfx.each{ |k, v| @passive_eqfx[k] += v }
      skill.passive_eqse.each{ |k, v| @passive_eqse[k] += v }
      @passive_dbwp += skill.passive_dbwp
    }
  end
  #--------------------------------------------------------------------------
  # ○ 웨폰 마스터리인가?
  #--------------------------------------------------------------------------
  def weapon_mastery?(skill)
    wpm = []
    skill.passive_wpm_set.each { |k, v| wpm.push(k) if v != 0 } 
    wpm_ans = false
    wpm.each { |k| wpm_ans = true if wtype_equipped?(k) }
    return wpm_ans    
  end
  #--------------------------------------------------------------------------
  # ● 방어구타입을 장착하고 있는가?
  #--------------------------------------------------------------------------
  def atype_equipped?(atype_id)
    armors.any? {|armor| armor.atype_id == atype_id }
  end
  #--------------------------------------------------------------------------
  # ○ 아머 마스터리인가?
  #--------------------------------------------------------------------------
  def armor_mastery?(skill)
    arm = []
    skill.passive_arm_set.each { |k, v| arm.push(k) if v != 0 } 
    arm_ans = false
    arm.each { |k| arm_ans = true if atype_equipped?(k) }
    return arm_ans    
  end
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬에 의한 param 수정치 (즉치)
  #--------------------------------------------------------------------------
  def passive_params
    restore_passive_rev if @passive_params == nil
    return @passive_params
  end
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬에 의한 param 수정치 (비율)
  #--------------------------------------------------------------------------
  def passive_params_rate
    restore_passive_rev if @passive_params_rate == nil
    return @passive_params_rate
  end
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬에 의한 xparam 수정치 (즉치)
  #--------------------------------------------------------------------------
  def passive_xparams
    restore_passive_rev if @passive_xparams == nil
    return @passive_xparams
  end
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬에 의한 param 수정치 (즉치)
  #--------------------------------------------------------------------------
  def passive_sparams
    restore_passive_rev if @passive_sparams == nil
    return @passive_sparams
  end
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 속성내성
  #--------------------------------------------------------------------------
  def passive_elre
    restore_passive_rev if @passive_elre == nil
    return @passive_elre
  end
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 약화내성
  #--------------------------------------------------------------------------
  def passive_bfre
    restore_passive_rev if @passive_bfre == nil
    return @passive_bfre
  end
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 상태내성
  #--------------------------------------------------------------------------
  def passive_stre
    restore_passive_rev if @passive_stre == nil
    return @passive_stre
  end
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 상태무효
  #--------------------------------------------------------------------------
  def passive_stno
    restore_passive_rev if @passive_stno == nil
    return @passive_stno
  end
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 공격속성
  #--------------------------------------------------------------------------
  def passive_atel
    restore_passive_rev if @passive_atel == nil
    return @passive_atel
  end
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 공격상태
  #--------------------------------------------------------------------------
  def passive_atst
    restore_passive_rev if @passive_atst == nil
    return @passive_atst
  end
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 공격속도
  #--------------------------------------------------------------------------
  def passive_atsp
    restore_passive_rev if @passive_atsp == nil
    return @passive_atsp
  end
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 공격횟수
  #--------------------------------------------------------------------------
  def passive_atnu
    restore_passive_rev if @passive_atnu == nil
    return @passive_atnu
  end
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 스킬타입 추가
  #--------------------------------------------------------------------------
  def passive_skty
    restore_passive_rev if @passive_skty == nil
    return @passive_skty
  end
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 스킬타입 봉인
  #--------------------------------------------------------------------------
  def passive_skts
    restore_passive_rev if @passive_skts == nil
    return @passive_skts
  end
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 스킬추가
  #--------------------------------------------------------------------------
  def passive_skpl
    restore_passive_rev if @passive_skpl == nil
    return @passive_skpl
  end
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 스킬봉인
  #--------------------------------------------------------------------------
  def passive_skse
    restore_passive_rev if @passive_skse == nil
    return @passive_skse
  end
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 무기타입
  #--------------------------------------------------------------------------
  def passive_wety
    restore_passive_rev if @passive_wety == nil
    return @passive_wety
  end
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 방어구타입
  #--------------------------------------------------------------------------
  def passive_arty 
    restore_passive_rev if @passive_arty == nil
    return @passive_arty 
  end
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 장비고정
  #--------------------------------------------------------------------------
  def passive_eqfx
    restore_passive_rev if @passive_eqfx == nil
    return @passive_eqfx
  end
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 장비봉인
  #--------------------------------------------------------------------------
  def passive_eqse
    restore_passive_rev if @passive_eqse == nil
    return @passive_eqse
  end
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 이도류
  #--------------------------------------------------------------------------
  def passive_dbwp
    restore_passive_rev if @passive_dbwp == nil
    return @passive_dbwp
  end
  #--------------------------------------------------------------------------
  # ● 패시브 param의 취득
  #--------------------------------------------------------------------------
  def passive_param_base(param_id)
    n = 0  
    case param_id
    when 0; n += passive_params[:mhp]
    when 1; n += passive_params[:mmp]
    when 2; n += passive_params[:atk]
    when 3; n += passive_params[:def]
    when 4; n += passive_params[:mat]
    when 5; n += passive_params[:mdf]
    when 6; n += passive_params[:agi]
    when 7; n += passive_params[:luk]
    end
    return n
  end
  #--------------------------------------------------------------------------
  # ● 패시브 param 비율의 취득
  #--------------------------------------------------------------------------
  def passive_param_rate_base(param_id)
    n = 100  
    case param_id
    when 0; n += passive_params_rate[:mhp]
    when 1; n += passive_params_rate[:mmp]
    when 2; n += passive_params_rate[:atk]
    when 3; n += passive_params_rate[:def]
    when 4; n += passive_params_rate[:mat]
    when 5; n += passive_params_rate[:mdf]
    when 6; n += passive_params_rate[:agi]
    when 7; n += passive_params_rate[:luk]
    end
    return n/100.to_f
  end
  #--------------------------------------------------------------------------
  # ● 패시브 xparam의 취득
  #--------------------------------------------------------------------------
  def passive_xparam_base(xparam_id)
    n = 0  
    case xparam_id
    when 0; n += passive_xparams[:hit]
    when 1; n += passive_xparams[:eva]
    when 2; n += passive_xparams[:cri]
    when 3; n += passive_xparams[:cev]
    when 4; n += passive_xparams[:mev]
    when 5; n += passive_xparams[:mrf]
    when 6; n += passive_xparams[:cnt]
    when 7; n += passive_xparams[:hrg]
    when 8; n += passive_xparams[:mrg]
    when 9; n += passive_xparams[:trg]
    end
    return n.to_f
  end
  #--------------------------------------------------------------------------
  # ● 패시브 sparam의 취득
  #--------------------------------------------------------------------------
  def passive_sparam_base(sparam_id)
    n = 0  
    case sparam_id
    when 0; n += passive_sparams[:tgr]
    when 1; n += passive_sparams[:grd]
    when 2; n += passive_sparams[:rec]
    when 3; n += passive_sparams[:pha]
    when 4; n += passive_sparams[:mcr]
    when 5; n += passive_sparams[:tcr]
    when 6; n += passive_sparams[:pdr]
    when 7; n += passive_sparams[:mdr]
    when 8; n += passive_sparams[:fdr]
    when 9; n += passive_sparams[:exr]
    end
    return n.to_f
  end
  #--------------------------------------------------------------------------
  # ● 속성 유효도의 취득
  #--------------------------------------------------------------------------
  def passive_element_rate(element_id)
    n = 0
    n += passive_elre[element_id] if passive_elre[element_id]
    return n.to_f
  end
  #--------------------------------------------------------------------------
  # ● 약체 유효도의 취득
  #--------------------------------------------------------------------------
  def passive_debuff_rate(param_id)
    n = 0
    n += passive_bfre[param_id] if passive_bfre[param_id]
    return n.to_f
  end
  #--------------------------------------------------------------------------
  # ● 스테이트 유효도의 취득
  #--------------------------------------------------------------------------
  def passive_state_rate(state_id)
    n = 0
    n += passive_stre[state_id] if passive_stre[state_id]
    return n.to_f
  end
  #--------------------------------------------------------------------------
  # ● 상태 무효화의 배열을 취득
  #--------------------------------------------------------------------------
  def passive_state_resist
    n_set = []
    for i in 1..$data_states.size
      n_set.push(i) if passive_stno[i] != 0
    end
    return n_set
  end
  #--------------------------------------------------------------------------
  # ● 공격 속성의 배열을 취득
  #--------------------------------------------------------------------------
  def passive_atk_element
    n_set = []
    for i in 1..$data_system.elements.size
      n_set.push(i) if passive_atel[i] != 0
    end
    return n_set
  end
  #--------------------------------------------------------------------------
  # ● 공격상태의 배열을 취득
  #--------------------------------------------------------------------------
  def passive_atk_state
    n_set = []
    for i in 1..$data_states.size
      n_set.push(i) if passive_atst[i] != 0
    end
    return n_set
  end
  #--------------------------------------------------------------------------
  # ● 공격상태의 발동율 취득
  #--------------------------------------------------------------------------
  def passive_atk_state_rate(state_id)
    n = 0
    n += passive_atst[state_id]
    return n.to_f
  end
  #--------------------------------------------------------------------------
  # ● 추가 스킬 타입의 취득 
  #--------------------------------------------------------------------------
  def passive_added_stypes
    n_set = []
    for i in 1..$data_system.skill_types.size
      n_set.push(i) if passive_skty[i] != 0
    end
    return n_set
  end
  #--------------------------------------------------------------------------
  # ● 스킬 타입 봉인의 취득  
  #--------------------------------------------------------------------------
  def passive_stypes_sealed
    n_set = []
    for i in 1..$data_system.skill_types.size
      n_set.push(i) if passive_skts[i] != 0
    end
    return n_set
  end
  #--------------------------------------------------------------------------
  # ● 추가 스킬의 취득
  #--------------------------------------------------------------------------
  def passive_added_skills
    n_set = []
    for i in 1..$data_skills.size
      n_set.push(i) if passive_skpl[i] != 0
    end
    return n_set
  end
  #--------------------------------------------------------------------------
  # ● 스킬 타입 봉인의 취득  
  #--------------------------------------------------------------------------
  def passive_skill_sealed
    n_set = []
    for i in 1..$data_skills.size
      n_set.push(i) if passive_skse[i] != 0
    end
    return n_set
  end
  #--------------------------------------------------------------------------
  # ● 무기 장비 가능의 셋 
  #--------------------------------------------------------------------------
  def passive_wtype
    n_set = []
    for i in 1..$data_system.weapon_types.size
      n_set.push(i) if passive_wety[i] != 0
    end
    return n_set
  end
  #--------------------------------------------------------------------------
  # ● 방어구 장비 가능의 셋
  #--------------------------------------------------------------------------
  def passive_atype
    n_set = []
    for i in 1..$data_system.armor_types.size
      n_set.push(i) if passive_arty[i] != 0
    end
    return n_set
  end
  #--------------------------------------------------------------------------
  # ● 장비 고정의 셋
  #--------------------------------------------------------------------------
  def passive_efixed
    n_set = []
    for i in 0..4 #.equip_slots.size
      n_set.push(i) if passive_eqfx[i] != 0
    end
    return n_set
  end
  #--------------------------------------------------------------------------
  # ● 장비 봉인의 셋
  #--------------------------------------------------------------------------
  def passive_esealed
    n_set = []
    for i in 0..4 #.equip_slots.size
      n_set.push(i) if passive_eqse[i] != 0
    end
    return n_set
  end
  #--------------------------------------------------------------------------
  # ● 스킬을 기억한다
  #     skill_id : 스킬 ID
  #--------------------------------------------------------------------------
  alias learn_skill_IMIR_PassiveSkill learn_skill
  def learn_skill(skill_id)
    learn_skill_IMIR_PassiveSkill(skill_id)
    restore_passive_rev
  end
  #--------------------------------------------------------------------------
  # ● 스킬을 잊는다
  #     skill_id : 스킬 ID
  #--------------------------------------------------------------------------
  alias forget_skill_IMIR_PassiveSkill forget_skill
  def forget_skill(skill_id)
    forget_skill_IMIR_PassiveSkill(skill_id)
    restore_passive_rev
  end
  #--------------------------------------------------------------------------
  # ● 장비의 강제변경
  #     slot_id : 장비슬롯 ID
  #     item    : 무기／방어구（nil 장비해제）
  #--------------------------------------------------------------------------
  alias p_force_change_equip force_change_equip
  def force_change_equip(slot_id, item)
    p_force_change_equip(slot_id, item)
    restore_passive_rev
  end
  #--------------------------------------------------------------------------
  # ● 장비의 파기
  #     item : 파기할 무기／장어구
  #--------------------------------------------------------------------------
  alias p_discard_equip discard_equip
  def discard_equip(item)
    p_discard_equip(item)
    restore_passive_rev
  end
  #--------------------------------------------------------------------------
  # ● 장비 할 수 없는 장비품을 제외한다
  #     item_gain : 제외한 장비품을 파티에 되돌린다
  #--------------------------------------------------------------------------
  alias p_release_unequippable_items release_unequippable_items
  def release_unequippable_items(item_gain = true)
    p_release_unequippable_items(item_gain = true)
    restore_passive_rev
  end
  #--------------------------------------------------------------------------
  # ● 장비를 모두 제외한다
  #--------------------------------------------------------------------------
  alias p_clear_equipments clear_equipments
  def clear_equipments
    #print("112_2.Game_Actor - 모든 장비 해제 \n");
    p_clear_equipments
    restore_passive_rev
  end
=begin
  #--------------------------------------------------------------------------
  # ● 최강장비
  #--------------------------------------------------------------------------
  alias p_optimize_equipments optimize_equipments
  def optimize_equipments
    p_optimize_equipments
    restore_passive_rev
  end
=end
  #--------------------------------------------------------------------------
  # ● 레벨업
  #--------------------------------------------------------------------------
  alias sp_level_up level_up
  def level_up
    sp_level_up
    get_type = IMIR_SkillPoint::GetPointType
    case get_type
    when 0
      @skill_point += 1
    when 1
      @skill_point += IMIR_SkillPoint::DefaultPoint
    when 2
      @skill_point += @level / 10
    end
  end
  
  def in_roster?
    @in_roster = true
    @in_roster
  end
  
  def base_weight_limit
    actor.weight_limit ? actor.weight_limit : self.class.weight_limit
  end
  
  def max_weight_limit
    if actor.id == 5
      base_weight_limit + @weight_mod + actor.weight_limit.to_i + 40
    else
      base_weight_limit + @weight_mod + actor.weight_limit.to_i
    end
  end
  
  def max_sexy_limit
    actor.sexy_limit
  end
  
  #--------------------------------------------------------------------------
  # * 모든 장비의 합한 무게
  #--------------------------------------------------------------------------
  def equipment_weight
    equips.compact.inject(0) {|r, item| r += item.weight }
  end
  
  def equipment_equip_temper
    equips.compact.inject(0) {|r, item| r += (item.equip_temper*(item.durability.to_f / item.max_durability * 100)/100).to_i }
  end
  
  def equipment_equip_sexy
    equips.compact.inject(0) {|r, item| r += item.equip_sexy }
  end
  
  # 성 도구 변수 확인
  def equipment_bg_equip_sexy
    equips.compact.inject(0) {|r, item| r += item.bg_equip_sexy }
  end
  
  #--------------------------------------------------------------------------
  # * 장비에 사용할 수 있는 무게
  #--------------------------------------------------------------------------
  def available_weight
    max_weight_limit - equipment_weight
  end
  
  def available_sexy
    return true if equipment_equip_sexy > max_sexy_limit
    return false
  end
  
  #--------------------------------------------------------------------------
  # <제한액터 1,2>
  # 배우 번호로 대상자를 제한
  # <제한직업 3>
  # 직업 번호로 대상자를 제한
  #--------------------------------------------------------------------------
  # ● 스킬/아이템 적용 테스트
  # 사용 대상이 전쾌하고 있을 때의 회복 금지 등을 판정한다.
  #--------------------------------------------------------------------------
  alias tmitactarget_game_actor_item_test item_test
  def item_test(user, item)
    tmitactarget_game_actor_item_test(user, item) && item_effectable?(item)
  end
  
  #--------------------------------------------------------------------------
  # ○ 아이템의 액터 제한을 판정한다.
  #--------------------------------------------------------------------------
  def item_effectable?(item)
    if /<제한액터\s*((?:\d+\s*\,*\s*)+)>/ =~ item.note
      return false unless $1.scan(/\d+/).include?(@actor_id.to_s)
    end
    if /<제한직업\s*((?:\d+\s*\,*\s*)+)>/ =~ item.note
      return false unless $1.scan(/\d+/).include?(@class_id.to_s)
    end
    true
  end

  #--------------------------------------------------------------------------
  # ● 장비의 변경（ID로 설정）
  #     slot_id : 장비슬롯 ID
  #     item_id : 무기／방어구 ID
  #--------------------------------------------------------------------------
  alias p_change_equip_by_id change_equip_by_id
  def change_equip_by_id(slot_id, item_id)
    p_change_equip_by_id(slot_id, item_id)
    #print("112_2.Game_Actor - ");
    #print("change_equip_by_id - %s, %s \n" % [slot_id, item_id]);
    restore_passive_rev
  end
  
  alias jene_change_equip change_equip
  def change_equip(slot_id, item)
    if item.nil? && !@optimize_clear
      etype_id = equip_slots[slot_id]
      return unless YEA::EQUIP::TYPES[etype_id][1]
    elsif item.nil? && @optimize_clear
      etype_id = equip_slots[slot_id]
      return unless YEA::EQUIP::TYPES[etype_id][2]
    end
    @equips[slot_id] = Game_BaseItem.new if @equips[slot_id].nil?
    
    jene_change_equip(slot_id, item)
    
    #print("112_2.Game_Actor - ");
    #print("change_equip - %s, %s \n" % [slot_id, item]);
    refresh_graphic_equip
    $game_player.refresh if slot_id == 3
    # 그림 변경, 캐릭터 조작 금지, 퀘스트 보드가 아닌 경우 진행
    if @actor_id == 7 and $game_switches[186] == false and $game_actors[7].restriction < 4  # 행동불가인지 확인
      # 알몸 상태이상 제거
      $game_actors[7].remove_state(22) if self.equips[3] != nil
      $game_map.rose_amor_picture
      $game_map.rose_state_face
      $game_map.rose_body_face
      $game_map.rose_picture_face
      # 착용한 장비 내역 대입
      $game_variables[192] = $game_actors[7].equips[0] if $game_actors[7].equips[0] != nil
      $game_variables[193] = $game_actors[7].equips[1] if $game_actors[7].equips[1] != nil
      $game_variables[176] = $game_actors[7].equips[2] if $game_actors[7].equips[2] != nil
      $game_variables[177] = $game_actors[7].equips[3] if $game_actors[7].equips[3] != nil
      $game_variables[178] = $game_actors[7].equips[4] if $game_actors[7].equips[4] != nil
      $game_variables[179] = $game_actors[7].equips[5] if $game_actors[7].equips[5] != nil
      $game_variables[180] = $game_actors[7].equips[6] if $game_actors[7].equips[6] != nil
      $game_variables[194] = $game_actors[7].equips[7] if $game_actors[7].equips[7] != nil
      $game_variables[195] = $game_actors[7].equips[8] if $game_actors[7].equips[8] != nil
      $game_variables[196] = $game_actors[7].equips[9] if $game_actors[7].equips[9] != nil
      $game_variables[197] = $game_actors[7].equips[10] if $game_actors[7].equips[10] != nil
    end
    restore_passive_rev
  end
  
  def graphic_equip(item)
    # 알몸인거 확인 실험
    if @actor_id == 7
      $game_variables[113] = 1
      $game_variables[114] = nil
      # 장비 관련 갱신 처리 스위치 온, 실험
      $game_switches[60] = true
    end
    return unless item.is_a?(RPG::Weapon) || item.is_a?(RPG::Armor)
    id = item.id
    for graphic in item.graphic_equip
      if @actor_id == graphic[0]
        # 방어구 변경시 진행 실험
        if @actor_id == 7
          $game_variables[113] = 1
          $game_variables[114] = item.equip_number
          # 장비 관련 갱신 처리 스위치 온, 실험
          $game_switches[60] = true
        end
        # 에르니 방어구 내구력 0 알몸으로 변경
        if @actor_id == 7 and $game_variables[118] >= 1
          set_graphic(graphic[1], graphic[2], @face_name, @face_index)
          break
        else
          $game_variables[113] = 1
          $game_variables[114] = nil
          # 장비 관련 갱신 처리 스위치 온, 실험
          $game_switches[60] = true
          set_graphic("Actor7", 0, "Actor7", 0)
          break
        end
      end
    end
  end
  
  def face_equip(item)
    return unless item.is_a?(RPG::Weapon) || item.is_a?(RPG::Armor)
    id = item.id
    for graphic in item.face_equip
      if @actor_id == graphic[0]
        # 방어구 변경시 진행 실험
        if @actor_id == 7
          $game_variables[114] = item.equip_number
          # 착용한 방어구 확인 내구도 갱신 실험
          if item != nil and self.equips[3] != nil
            if self.equips[3].id == item.id
              $game_variables[118] = (item.durability.to_f / item.max_durability * 100).to_i
            end
          end
          # 성 도구 변수 대입
          $game_variables[322] = $game_actors[7].equipment_bg_equip_sexy.to_i
          # 노출도 대입
          $game_variables[121] = (100 - ($game_actors[7].equipment_equip_sexy)*$game_variables[118]/100).to_i
        end
        # 에르니 방어구 내구력 0 알몸으로 변경
        if @actor_id == 7 and $game_variables[118] >= 1
          set_graphic(@character_name, @character_index, graphic[1], graphic[2])
          break
        else
          $game_variables[113] = 1
          $game_variables[114] = nil
          # 장비 관련 갱신 처리 스위치 온, 실험
          $game_switches[60] = true
          set_graphic("Actor7", 0, "Actor7", 0)
          break
        end
      end
    end
  end
  
  def refresh_graphic_equip
    set_graphic(@default_character_name, @default_character_index, @default_face_name, @default_face_index)
    for i in Jene::PRIORITY_EQUIP
      graphic_code = 'graphic_equip(equips[' + i.to_s + '])'
      face_code = 'face_equip(equips[' + i.to_s + '])'
      eval(graphic_code)
      eval(face_code)
    end
  end
  
  def set_default_graphic(character_name, character_index, face_name, face_index)
    @default_character_name = character_name
    @default_character_index = character_index
    @default_face_name = face_name
    @default_face_index = face_index
  end
  
  def equip_image
    if actor.equip_image != nil
      return actor.equip_image 
    elsif $data_classes[@class_id].equip_image != nil
      return $data_classes[@class_id].equip_image
    else
      return BM::EQUIP::BODY_OPTIONS[:image]
    end
  end
  
  alias :bm_cc :change_class
  def change_class(*args, &block)
    bm_cc(*args, &block)
    @equip_image = equip_image
  end
  
  def equip_body_x
    return self.actor.base_equip_body_x unless self.actor.equip_body_default
    return self.class.base_equip_body_x
  end
  
  def equip_body_y
    return self.actor.base_equip_body_y unless self.actor.equip_body_default
    return self.class.base_equip_body_y
  end
  
  #--------------------------------------------------------------------------
  # ○ 파라미터 증가량 일람 취득
  #--------------------------------------------------------------------------
  def gain_parameter_list
    key = "#{@actor_id}_#{@class_id}"
    unless @@__distribute_gain_params.has_key?(key)
      result = KMS_DistributeParameter::GAIN_PARAMS

      # 액터 고유
      list   = KMS_DistributeParameter::PERSONAL_GAIN_PARAMS[@actor_id]
      result = KMS_DistributeParameter.merge(result, list) if list != nil

      # 직업 고유
      list   = KMS_DistributeParameter::CLASS_GAIN_PARAMS[@class_id]
      result = KMS_DistributeParameter.merge(result, list) if list != nil

      @@__distribute_gain_params[key] = result
    end

    return @@__distribute_gain_params[key]
  end
  
  #--------------------------------------------------------------------------
  # ○ 파라미터 증가량 획득
  #--------------------------------------------------------------------------
  def gain_parameter(key)
    return gain_parameter_list.find { |v| v.key == key }
  end
  
  #--------------------------------------------------------------------------
  # ○ 다양한 수정 값 계산
  #--------------------------------------------------------------------------
  def calc_distribution_values
    @rp_cost = 0
    @distributed_param = {}
    KMS_DistributeParameter::PARAMS.each { |param|
      @distributed_param[param] = 0
    }

    gain_parameter_list.each { |gain|
      next if gain == nil
      cost = 0
      distributed_count(gain.key).times { |i|
        cost += Integer(gain.cost + gain.cost_rev * i)
        gain.params.each { |param, v|
          @distributed_param[param] += v.value + v.value_rev * i
        }
      }
      @rp_cost += [cost, 0].max
    }

    KMS_DistributeParameter::PARAMS.each { |param|
      @distributed_param[param] = @distributed_param[param]
    }
  end
  
  #--------------------------------------------------------------------------
  # ○ 다양한 수정 값 복구
  #--------------------------------------------------------------------------
  def restore_distribution_values
    calc_distribution_values
    self.hp = self.hp
    self.mp = self.mp
  end
  
  #--------------------------------------------------------------------------
  # ○ 배분에 의한 상승치 취득
  #--------------------------------------------------------------------------
  def distributed_param(param)
    return 0 if @distributed_param == nil
    return 0 if @distributed_param[param] == nil
    return @distributed_param[param]
  end
  #PARAM_SYMBOL  = [:mhp, :mmp, :atk, :def, :mat, :mdf, :agi, :luk]
  #XPARAM_SYMBOL = [:hit, :eva, :cri, :cev, :mev, :mrf, :cnt, :hrg, :mrg, :trg]
  #SPARAM_SYMBOL = [:tgr, :grd, :rec, :pha, :mcr, :tcr, :pdr, :mdr, :fdr, :exr]
  PARAM_SYMBOL  = [ :mhp, :mmp, :atk, :def, :mat, :mdf, :agi, :luk,
                    :hit, :eva, :cri, :cev, :mev, :hrg, :mrg, :mrf,
                    :grd, :rec, :pha, :mcr, :tcr, :trg, :tgr, :pdr, :mdr, :atk_lk, :weight_limit, :exr, 
                    :el_3, :el_4, :el_5, :el_6, :el_7, :el_8, :el_9, :el_10, :el_12,
                    :atk_times_add, :m_dex, :aps
  ]
  
  #--------------------------------------------------------------------------
  # ● 통상 능력치의 기본치 취득
  #--------------------------------------------------------------------------
  alias param_base_KMS_DistributeParameter param_base
  def param_base(param_id)
    n = param_base_KMS_DistributeParameter(param_id)
    if PARAM_SYMBOL[param_id] != nil and distributed_param(PARAM_SYMBOL[param_id]) != nil
      n = 0 if n == nil
      n += distributed_param(PARAM_SYMBOL[param_id]).to_f
      #print("112_2.Game_Actor - 능력치 확인 param_id(%s), n(%s) \n" % [param_id, n]);
    end
    return Integer(n)
  end
  
  #--------------------------------------------------------------------------
  # ● 명중률 획득
  #--------------------------------------------------------------------------
  alias hit_KMS_DistributeParameter hit
  def hit
    n = hit_KMS_DistributeParameter + distributed_param(:hit)
    return n
  end
  
  #--------------------------------------------------------------------------
  # ● 회피율 획득
  #--------------------------------------------------------------------------
  alias eva_KMS_DistributeParameter eva
  def eva
    n = eva_KMS_DistributeParameter + distributed_param(:eva)
    return n
  end
  
  #--------------------------------------------------------------------------
  # ● 치명타 비율 획득
  #--------------------------------------------------------------------------
  alias cri_KMS_DistributeParameter cri
  def cri
    n = cri_KMS_DistributeParameter + distributed_param(:cri)
    return n
  end
  
  #--------------------------------------------------------------------------
  # ● 치명타 회피율 획득
  #--------------------------------------------------------------------------
  alias cev_KMS_DistributeParameter cev
  def cev
    n = cev_KMS_DistributeParameter + distributed_param(:cev)
    return n
  end
  
  #--------------------------------------------------------------------------
  # ● 이동 속도 획득
  #--------------------------------------------------------------------------
  alias atk_times_add_KMS_DistributeParameter atk_times_add
  def atk_times_add
    n = atk_times_add_KMS_DistributeParameter + distributed_param(:atk_times_add)
    return n
  end
  
  #--------------------------------------------------------------------------
  # ● 마력 친화력
  #--------------------------------------------------------------------------
  #alias m_dex_KMS_DistributeParameter m_dex
  #def m_dex
  #  n = m_dex_KMS_DistributeParameter + distributed_param(:m_dex)
  #  return n
  #end
  
  #--------------------------------------------------------------------------
  # ● 치명타 공격 비율
  #--------------------------------------------------------------------------
  alias atk_lk_KMS_DistributeParameter atk_lk
  def atk_lk
    n = atk_lk_KMS_DistributeParameter + distributed_param(:atk_lk)
    return n
  end
  
  #--------------------------------------------------------------------------
  # ● 착용 무게 제한
  #--------------------------------------------------------------------------
  alias max_weight_limit_KMS_DistributeParameter max_weight_limit
  def max_weight_limit
    n = max_weight_limit_KMS_DistributeParameter + distributed_param(:weight_limit)
    return n
  end
  
  #--------------------------------------------------------------------------
  # ● 쿨타임 감소
  #--------------------------------------------------------------------------
  alias pha_KMS_DistributeParameter pha
  def pha
    n = pha_KMS_DistributeParameter + distributed_param(:pha)
    return n
  end
  
  #--------------------------------------------------------------------------
  # ● 경험치 획득 비율 획득
  #--------------------------------------------------------------------------
  alias exr_KMS_DistributeParameter exr
  def exr
    n = exr_KMS_DistributeParameter + distributed_param(:exr)
    return n
  end
  
  #--------------------------------------------------------------------------
  # ● 목표 비율 획득
  #--------------------------------------------------------------------------
  alias tgr_KMS_DistributeParameter tgr
  def tgr
    n = tgr_KMS_DistributeParameter + distributed_param(:tgr)
    return n
  end
  
  #--------------------------------------------------------------------------
  # ○ MaxRP 얻기
  #--------------------------------------------------------------------------
  def mrp
    n = Integer(eval(KMS_DistributeParameter::MAXRP_EXP))
    return [n + mrp_plus, 0].max
  end
  
  #--------------------------------------------------------------------------
  # ○ MaxRP 보정값 획득
  #--------------------------------------------------------------------------
  def mrp_plus
    @mrp_plus = 0 if @mrp_plus == nil
    return @mrp_plus
  end
  
  #--------------------------------------------------------------------------
  # ○ RP の取得
  #--------------------------------------------------------------------------
  def rp
    # 오류 수정
    calc_distribution_values if @rp_cost == nil
    return [mrp - @rp_cost, 0].max
  end
  
  #--------------------------------------------------------------------------
  # ○ 배분 횟수 취득
  #--------------------------------------------------------------------------
  def distributed_count(param)
    clear_distribution_values     if @distributed_count == nil
    @distributed_count[param] = 0 if @distributed_count[param] == nil
    return @distributed_count[param]
  end
  
  #--------------------------------------------------------------------------
  # ○ RP 증감
  #--------------------------------------------------------------------------
  def gain_rp(value)
    @mrp_plus = mrp_plus + value
  end
  
  #--------------------------------------------------------------------------
  # ○ 분배 횟수의 증감
  #--------------------------------------------------------------------------
  def gain_distributed_count(param, value = 1)
    n = distributed_count(param)
    @distributed_count[param] += value if n.is_a?(Integer)
  end
  
  #--------------------------------------------------------------------------
  # ○ RP 배분에 의한 성장 효과 적용
  #     param   : 배분 파라미터 (키)
  #     reverse : 역 가산의 경우는 true
  #--------------------------------------------------------------------------
  def rp_growth_effect(param, reverse = false)
    if reverse
      return if 1 > distributed_count(param)  # 역가산 불가
    else
      return unless can_distribute?(param)
    end
      
    if Input.press?(:SHIFT)
      10.times {
      gain = gain_parameter(param)
      return if gain == nil  # 잘못된 매개변수
      if reverse
        return if 1 > distributed_count(param)  # 역가산 불가
      else
        return unless can_distribute?(param)
      end
      gain_distributed_count(param, reverse ? -1 : 1)
      restore_distribution_values
      }
    else
      gain = gain_parameter(param)
      return if gain == nil  # 잘못된 매개변수
      if reverse
        return if 1 > distributed_count(param)    # 역가산 불가
        #return if distributed_count(param) == 0  # 역가산 불가
      else
        return unless can_distribute?(param)
      end
      gain_distributed_count(param, reverse ? -1 : 1)
      restore_distribution_values
    end
    #restore_distribution_values
  end
  
  #--------------------------------------------------------------------------
  # ○ 파라미터 배분 여부 판정
  #--------------------------------------------------------------------------
  def can_distribute?(param)
    gain = gain_parameter(param)
    return false if gain == nil                        # 잘못된 매개변수
    return false if self.rp < distribute_cost(param)   # RP 不足
    if gain.limit > 0
      return false if gain.limit <= distributed_count(param)  # 回数上限
    end

    return true
  end
  
  #--------------------------------------------------------------------------
  # ○ 파라미터 분배 비용 계산
  #--------------------------------------------------------------------------
  def distribute_cost(param)
    gain = gain_parameter(param)
    return 0 if gain == nil  # 無効なパラメータ

    n = gain.cost
    count = distributed_count(param)
    count = [count, gain.limit - 1].min if gain.limit > 0
    n += gain.cost_rev * count
    return [Integer(n), 0].max
  end
  
  #--------------------------------------------------------------------------
  # ○ 파라미터 배분 후 증가량 계산
  #--------------------------------------------------------------------------
  def distribute_gain(param, amt = 1)
    gain = gain_parameter(param)

    # 잘못된 매개변수
    return 0 if gain == nil

    result = {}
    KMS_DistributeParameter::PARAMS.each { |par|
      result[par] = distributed_param(par)
    }

    # 배분 불가
    if amt > 0
      return result if gain.limit > 0 && gain.limit == distributed_count(param)
    else
      return result if distributed_count(param) + amt < 0
    end

    last_hp = self.hp
    last_mp = self.mp
    last_count = distributed_count(param)
    rp_growth_effect(param)
    KMS_DistributeParameter::PARAMS.each { |par|
      result[par] = distributed_param(par) if gain.params.include?(par)
    }
    rp_growth_effect(param, true) if last_count < distributed_count(param)
    self.hp = last_hp
    self.mp = last_mp

    return result
  end
  
  alias falcaopearl_on_player_walk on_player_walk
  def on_player_walk
    @result.clear
    check_floor_effect
    return
    falcaopearl_on_player_walk
  end
  
  def apply_usability
    #apply_usabilityto_melee(0) # weapon
    #apply_usabilityto_melee(1) # armor
    @usability[2] = usable?(@assigned_item)    if !@assigned_item.nil?
    @usability[3] = usable?(@assigned_item2)   if !@assigned_item2.nil?
    @usability[4] = usable?(@assigned_skill)   if !@assigned_skill.nil?
    @usability[5] = usable?(@assigned_skill2)  if !@assigned_skill2.nil?
    @usability[6] = usable?(@assigned_skill3)  if !@assigned_skill3.nil?
    @usability[7] = usable?(@assigned_skill4)  if !@assigned_skill4.nil?
    @usability[8] = usable?(@assigned_skill5)  if !@assigned_skill5.nil?
    @usability[9] = usable?(@assigned_skill6)  if !@assigned_skill6.nil?
    @usability[10] = usable?(@assigned_skill7) if !@assigned_skill7.nil?
    @usability[11] = usable?(@assigned_skill8) if !@assigned_skill8.nil?
    @usability[13] = usable?(@assigned_item3)  if !@assigned_item3.nil?
    @usability[14] = usable?(@assigned_item4)  if !@assigned_item4.nil?
  end
  
  def apply_usabilityto_melee(index)
    if !equips[index].nil?
      invoke = equips[index].tool_data("Tool Invoke Skill = ")
      if invoke != nil and invoke != 0 and index == 0
        @usability[index] = usable?($data_skills[invoke])
      elsif index == 0
        @usability[index] = usable?($data_skills[1])
      end
      if invoke != nil and invoke != 0 and index == 1
        @usability[index] = usable?($data_skills[invoke])
      elsif index == 1
        @usability[index] = usable?($data_skills[2])
      end
    end
  end
  
  def check_death
    #print("112_2.Game_Actor - 생존 관련 갱신, check_death \n");
    @hunger =   [[@hunger,@hunger_max].min,0].max
    @thirst =   [[@thirst,@thirst_max].min,0].max
    @sleep =    [[@sleep,@sleep_max].min,0].max
    @repute =   [[@repute,@repute_max].min,0].max
    @sexual =   [[@sexual,@sexual_max].min,0].max
    @piety =    [[@piety,@piety_max].min,0].max
    @hygiene =  [[@hygiene,@hygiene_max].min,0].max
    @temper =   [[@temper,@temper_max].min,-100].max
    @stress =   [[@stress,@stress_max].min,0].max
    @cold =     [[@cold,@cold_max].min,0].max
    
    # 오류 방지
    @drunk = 0 if @drunk == nil
    @drunk_max = 100 if @drunk_max == nil
    @drunk =    [[@drunk,@drunk_max].min,0].max
    
    # 욕구 백분율 적용
    # 예 $game_actors[7].sleep_rate >= 85
    @hunger_rate =  (@hunger.to_f / @hunger_max * 100).to_i
    @thirst_rate =  (@thirst.to_f / @thirst_max * 100).to_i
    @sleep_rate =   (@sleep.to_f / @sleep_max * 100).to_i
    @repute_rate =  (@repute.to_i)
    @sexual_rate =  (@sexual.to_f / @sexual_max * 100).to_i
    @piety_rate =   (@piety.to_f / @piety_max * 100).to_i
    @hygiene_rate = (@hygiene.to_f / @hygiene_max * 100).to_i
    @stress_rate =  (@stress.to_f / @stress_max * 100).to_i
    @cold_rate =    (@cold.to_f / @cold_max * 100).to_i
    @drunk_rate =   (@drunk.to_f / @drunk_max * 100).to_i
    
    #print("112_2.Game_Actor - 욕구 관련, %s, %s \n" % [$game_switches[283], $game_variables[15]]);
    if $game_switches[283] == false and 1 > $game_variables[15]
      # 에르니 현재 체력 % 를 대입한다.
      $game_variables[119] = ($game_actors[7].hp.to_f / $game_actors[7].mhp * 100).round

      # 유혹 스위치 수치 입력
      sex_i = 0
      # 기본적으로 성욕% 를 +
      sex_i += $game_actors[7].sexual_rate.to_i
      # 악취 상태인 경우 -
      sex_i -= 30 if $game_actors[7].state?(134) == true
      # 달거리 상태인 경우 +
      sex_i += 30 if $game_actors[7].state?(137) == true
      # 혼란 상태인 경우 +
      sex_i += 40 if $game_actors[7].state?(5) == true
      # 수면 상태인 경우 +
      sex_i += 70 if $game_actors[7].state?(6) == true
      # 스턴 상태인 경우 +
      sex_i += 70 if $game_actors[7].state?(8) == true
      # 젖음 상태인 경우 +
      sex_i += 80 if $game_actors[7].state?(24) == true
      # 발정 상태인 경우 +
      sex_i += 100 if $game_actors[7].state?(23) == true
      # 알몸 상태인 경우 +
      sex_i += 100 if $game_actors[7].state?(22) == true
      # 정액 범벅 상태인 경우 -
      sex_i += 20 if $game_actors[7].state?(101) == true
      sex_i -= 30 if $game_actors[7].state?(102) == true
      sex_i -= 80 if $game_actors[7].state?(103) == true
      sex_i -= 100 if $game_actors[7].state?(104) == true
      
      $game_variables[267] = sex_i

      # 유혹 스위치 작동
      if !$game_switches[227] and sex_i >= 50 and !$game_actors[7].state?(105)
        $game_switches[227] = true
      elsif $game_switches[227]
        $game_switches[227] = false
      end

      # 탐지 스위치 작동
      if !$game_switches[230] and $game_actors[7].state?(34)
        $game_switches[230] = true
      elsif $game_switches[230]
        $game_switches[230] = false
      end

      # 최근 4대 욕구 합 계산
      $game_variables[265] = 0
      $game_variables[265] += 2 if ($game_actors[7].sleep_rate).to_i >= 50
      $game_variables[265] += 1 if ($game_actors[7].thirst_rate).to_i >= 50
      $game_variables[265] += 2 if ($game_actors[7].hunger_rate).to_i >= 50
      $game_variables[265] += 1 if ($game_actors[7].stress_rate).to_i >= 50

      # 체력에 따른 에르니 몸통 이미지 갱신 처리
      if 20 >= $game_variables[119] and $game_variables[117] != 2
        $game_variables[117] = 2
        $game_switches[195] = true
      elsif 40 >= $game_variables[119] and $game_variables[119] > 20 and $game_variables[117] != 4
        $game_variables[117] = 4
        $game_switches[195] = true
      elsif 60 >= $game_variables[119] and $game_variables[119] > 40  and $game_variables[117] != 6
        $game_variables[117] = 6
        $game_switches[195] = true
      elsif $game_variables[119] > 60 and $game_variables[117] != 1
        $game_variables[117] = 1
        $game_switches[195] = true
      end

      # 기존 상처에 현재 상처 값 대입한다.
      if $game_variables[120] != $game_variables[117]
        $game_switches[195] = true
        $game_variables[120] = $game_variables[117]
      end

      # 특정 상태이상시 욕구 수치 변경 추가
      if self.state?(138)   # 항복
        @stress += 1; @thirst += 2
      end
      if self.state?(13)    # 출혈
        @hunger += 4
      end

      # 심신 상태 추가
      if @stress_rate >= 80 or @stress_rate >= 80 or @stress_rate >= 80
        self.add_state(30) if self.state?(30) == false
      elsif @stress_rate < 80 and @stress_rate < 80 and @stress_rate < 80
        self.remove_state(30) if self.state?(30) == true
      end

      # 젖음 상태 추가
      if $game_switches[86] == false and $game_switches[94] == true and self.state?(24) == false and ($game_variables[12] == 1 or $game_variables[12] == 2 or $game_variables[12] == 3)
        self.add_state(24)
      elsif ($game_switches[86] != false or $game_switches[94] != true) and self.state?(24) == true and $game_variables[12] != 1 and $game_variables[12] != 2 and $game_variables[12] != 3
        self.remove_state(24)
      end

      # 플레이어 체력에 따라 상처 상태이상 추가
      if self.hp <= 10 and self.state?(135) == false
        self.add_state(135)
      elsif self.hp > 10 and self.state?(135) == true
        self.remove_state(135)
      end
      
      # 허기 상태 추가
      if @hunger_rate >= 95 and self.state?(26) == false
        self.add_state(26)
      elsif @hunger_rate < 95 and self.state?(26) == true
        self.remove_state(26)
      else
        # 배부름 상태 추가
        if @hunger_rate == 0 and self.state?(143) == false
          self.add_state(143)
        elsif @hunger_rate != 0 and self.state?(143) == true
          self.remove_state(143)
        end
      end
      
      # 갈증 상태 추가
      if @thirst_rate >= 95 and self.state?(27) == false
        self.add_state(27)
      elsif @thirst_rate < 95 and self.state?(27) == true
        self.remove_state(27)
      end
      
      # 피로함 상태 추가
      if @sleep_rate >= 95 and self.state?(28) == false
        self.add_state(28)
      elsif @sleep_rate < 95 and self.state?(28) == true
        self.remove_state(28)
      end
      
      # 성욕 상태 추가
      if @sexual_rate >= 95 and self.state?(23) == false
        self.add_state(23)
      elsif @sexual_rate < 95 and self.state?(23) == true
        self.remove_state(23)
      end
      
      # 경건 상태 추가, 플레이어 신앙심, 굳건한 용기 상태 추가
      if @piety_rate >= 95 and self.state?(88) == false and $game_variables[218] >= 10
        self.add_state(88)
      elsif @piety_rate < 95 and self.state?(88) == true
        self.remove_state(88)
      end
      
      # 위생 상태 추가
      if @hygiene + $game_variables[94] >= 80 and self.state?(134) == false
        self.add_state(134)
      elsif @hygiene + $game_variables[94] < 80 and self.state?(134) == true
        self.remove_state(134)
      end

      # 체온 수치에 따라 더위
      if @temper > 70
        self.add_state(126) if self.state?(126) == false
        self.remove_state(125) if self.state?(125) == true
        self.remove_state(124) if self.state?(124) == true
      else
        if @temper > 65
          self.add_state(125) if self.state?(125) == false
          self.remove_state(126) if self.state?(126) == true
          self.remove_state(124) if self.state?(124) == true
        else
          if @temper > 60
            self.add_state(124) if self.state?(124) == false
            self.remove_state(125) if self.state?(125) == true
            self.remove_state(126) if self.state?(126) == true
          else
            self.remove_state(124) if self.state?(124) == true
            self.remove_state(125) if self.state?(125) == true
            self.remove_state(126) if self.state?(126) == true
          end
        end
      end
    
      # 체온 수치에 따라 추위
      if @temper < 30
        self.add_state(129) if self.state?(129) == false
        self.remove_state(128) if self.state?(128) == true
        self.remove_state(127) if self.state?(127) == true
      else
        if @temper < 35
          self.add_state(128) if self.state?(128) == false
          self.remove_state(129) if self.state?(129) == true
          self.remove_state(127) if self.state?(127) == true
        else
          if @temper < 40
            self.add_state(127) if self.state?(127) == false
            self.remove_state(129) if self.state?(129) == true
            self.remove_state(128) if self.state?(128) == true
          else
            self.remove_state(129) if self.state?(129) == true
            self.remove_state(128) if self.state?(128) == true
            self.remove_state(127) if self.state?(127) == true
          end
        end
      end
    end
    # -------------------------------------------------------------------------
    # 휴식중일때 3대 욕구 변화 적용
    $game_switches[226] = true
    # -------------------------------------------------------------------------
  end
  
  def use_item(item)
    super(item)
    @hunger += item.user_hunger
    # 절제, 식탐, 폭식증에 의한 허기 증가 수치
    @hunger -= item.user_hunger / 2 if $game_variables[130] >= 5 or self.state?(215) == true
    @hunger += item.user_hunger * 0.5 if $game_variables[131] >= 5

    @thirst += item.user_thirst
    # 매독에 의한 갈증 증가 수치
    @thirst -= item.user_thirst / 2 if self.state?(217) == true
    
    @sleep += item.user_sleep
    @repute += item.user_repute
    @sexual += item.user_sexual
    @piety += item.user_piety
    @hygiene += item.user_hygiene
    @temper += item.user_temper
    @stress += item.user_stress
    @cold += item.user_cold
    
    if @drunk != nil
      @drunk = 0
      @drunk += item.user_drunk
    end

    check_death
  end
  
  def item_apply(user, item)
    super(user, item)
    if user != nil and user.is_a?(Game_Actor)
      # 절제, 식탐에 의한 허기 증가 수치
      @hunger += item.hunger
      @hunger -= item.hunger / 2 if $game_variables[130] >= 5 or self.state?(215) == true
      @hunger += item.hunger * 0.5 if $game_variables[131] >= 5

      @thirst += item.thirst
      # 매독에 의한 갈증 증가 수치
      @thirst -= item.thirst / 2 if self.state?(217) == true
      
      @sleep += item.sleep
      @repute += item.repute;       @sexual += item.sexual
      @piety += item.piety;         @hygiene += item.hygiene
      @temper += item.temper;       @stress += item.stress
      @cold += item.cold;           @drunk += item.drunk
      
      check_death
    end
  end
  
  def stress_rate;  (@stress.to_f / @stress_max * 100).to_i;    end
  def cold_rate;    (@cold.to_f / @cold_max * 100).to_i;        end
  def hunger_rate;  (@hunger.to_f / @hunger_max * 100).to_i;    end
  def thirst_rate;  (@thirst.to_f / @thirst_max * 100).to_i;    end
  def sleep_rate;   (@sleep.to_f / @sleep_max * 100).to_i;      end
  def repute_rate;  (@repute.to_f / @repute_max * 100).to_i;    end
  def sexual_rate;  (@sexual.to_f / @sexual_max * 100).to_i;    end
  def piety_rate;   (@piety.to_f / @piety_max * 100).to_i;      end
  def hygiene_rate; (@hygiene.to_f / @hygiene_max * 100).to_i;  end
  def drunk_rate
    # 오류 방지
    @drunk = 0 if @drunk == nil
    @drunk_max = 100 if @drunk_max == nil
    (@drunk.to_f / @drunk_max * 100).to_i
  end
end