# encoding: utf-8
# Name: Game_Battler
# Size: 45474
#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  A battler class with methods for sprites and actions added. This class 
# is used as a super class of the Game_Actor class and Game_Enemy class.
#==============================================================================

class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # * Constants (Effects)
  #--------------------------------------------------------------------------
  EFFECT_RECOVER_HP     = 11              # HP Recovery
  EFFECT_RECOVER_MP     = 12              # MP Recovery
  EFFECT_GAIN_TP        = 13              # TP Gain
  EFFECT_ADD_STATE      = 21              # Add State
  EFFECT_REMOVE_STATE   = 22              # Remove State
  EFFECT_ADD_BUFF       = 31              # Add Buff
  EFFECT_ADD_DEBUFF     = 32              # Add Debuff
  EFFECT_REMOVE_BUFF    = 33              # Remove Buff
  EFFECT_REMOVE_DEBUFF  = 34              # Remove Debuff
  EFFECT_SPECIAL        = 41              # Special Effect
  EFFECT_GROW           = 42              # Raise Parameter
  EFFECT_LEARN_SKILL    = 43              # Learn Skill
  EFFECT_COMMON_EVENT   = 44              # Common Events
  #--------------------------------------------------------------------------
  # * Constants (Special Effects)
  #--------------------------------------------------------------------------
  SPECIAL_EFFECT_ESCAPE = 0               # Escape
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :battler_name             # battle graphic filename
  attr_reader   :battler_hue              # battle graphic hue
  attr_reader   :action_times             # action times
  attr_reader   :actions                  # combat actions (action side)
  attr_reader   :speed                    # action speed
  attr_reader   :result                   # action result (target side)
  attr_accessor :last_target_index        # last target
  attr_accessor :animation_id             # animation ID
  attr_accessor :animation_mirror         # animation flip horizontal flag
  attr_accessor :sprite_effect_type       # sprite effect
  attr_accessor :magic_reflection         # reflection flag
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    @battler_name = ""
    @battler_hue = 0
    @actions = []
    @speed = 0
    @result = Game_ActionResult.new(self)
    @last_target_index = 0
    @guarding = false
    clear_sprite_effects
    super
  end
  #--------------------------------------------------------------------------
  # * Clear Sprite Effects
  #--------------------------------------------------------------------------
  def clear_sprite_effects
    @animation_id = 0
    @animation_mirror = false
    @sprite_effect_type = nil
  end
  #--------------------------------------------------------------------------
  # * Clear Actions
  #--------------------------------------------------------------------------
  def clear_actions
    @actions.clear
  end
  #--------------------------------------------------------------------------
  # * Clear State Information
  #--------------------------------------------------------------------------
  def clear_states
    super
    @result.clear_status_effects
  end
  #--------------------------------------------------------------------------
  # * Add State
  #--------------------------------------------------------------------------
  def add_state(state_id)
    # 마력 보호막, 죽음의 한기
    if state_id != 67 and state_id != 173 and state_id != 174
      if state_addable?(state_id)
        add_new_state(state_id) unless state?(state_id)
        reset_state_counts(state_id)
        @result.added_states.push(state_id).uniq!
      end
    else
      if self.state?(67) == true and state_id == 67
        self.remove_state(67)
      elsif self.state?(173) == true and state_id == 173
        self.remove_state(173)
      elsif self.state?(174) == true and state_id == 174
        self.remove_state(174)
      else
        add_new_state(state_id) unless state?(state_id)
        reset_state_counts(state_id)
        @result.added_states.push(state_id).uniq!
      end
    end
    # 단축키창을 새로고침한다.
    if self.is_a?(Game_Player)
      @actor.apply_usability
      @pearl_tool_sprite = Sprite_PearlTool.new(@viewport2)
      @pearl_tool_sprite.refresh_icons
    end
  end
  #--------------------------------------------------------------------------
  # * 상태를 추가할 수 있는지 확인
  #--------------------------------------------------------------------------
  def state_addable?(state_id)
    alive? && $data_states[state_id] && !state_resist?(state_id) &&
      !state_removed?(state_id)# && !state_restrict?(state_id)
  end
  #--------------------------------------------------------------------------
  # * 동일한 작업 중에 제거된 상태 확인
  #--------------------------------------------------------------------------
  def state_removed?(state_id)
    @result.removed_states.include?(state_id)
  end
  #--------------------------------------------------------------------------
  # * 조치 제한으로 제거된 상태 확인
  #--------------------------------------------------------------------------
  def state_restrict?(state_id)
    #$data_states[state_id].remove_by_restriction && restriction > 0
  end
  #--------------------------------------------------------------------------
  # * Add New State
  #--------------------------------------------------------------------------
  def add_new_state(state_id)
    die if state_id == death_state_id
    @states.push(state_id)
    #on_restrict if restriction > 0
    #sort_states
    refresh
  end
  #--------------------------------------------------------------------------
  # * 조치 제한 발생 시 수행되는 처리
  #--------------------------------------------------------------------------
  def on_restrict
    clear_actions
    #states.each do |state|
    #  remove_state(state.id) if state.remove_by_restriction
    #end
  end
  #--------------------------------------------------------------------------
  # * 상태 카운트 재설정(턴 및 걸음 수)
  #--------------------------------------------------------------------------
  def reset_state_counts(state_id)
    state = $data_states[state_id]
    variance = 1 + [state.max_turns - state.min_turns, 0].max
    @state_turns[state_id] = state.min_turns + rand(variance)
    @state_steps[state_id] = state.steps_to_remove
  end
  #--------------------------------------------------------------------------
  # * 상태 제거
  #--------------------------------------------------------------------------
  def remove_state(state_id)
    if state?(state_id)
      revive if state_id == death_state_id
      erase_state(state_id)
      refresh
      @result.removed_states.push(state_id).uniq!
      # 단축키창을 새로고침한다.
      if self.is_a?(Game_Player)
        @actor.apply_usability
        @pearl_tool_sprite = Sprite_PearlTool.new(@viewport2)
        @pearl_tool_sprite.refresh_icons
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Knock Out
  #--------------------------------------------------------------------------
  def die
    @hp = 0
    clear_states
    clear_buffs
  end
  #--------------------------------------------------------------------------
  # * Revive from Knock Out
  #--------------------------------------------------------------------------
  def revive
    @hp = 1 if @hp == 0
  end
  #--------------------------------------------------------------------------
  # * Escape
  #--------------------------------------------------------------------------
  def escape
    hide if $game_party.in_battle
    clear_actions
    clear_states
    Sound.play_escape
  end
  #--------------------------------------------------------------------------
  # * Add Buff
  #--------------------------------------------------------------------------
  def add_buff(param_id, turns)
    return unless alive?
    @buffs[param_id] += 1 unless buff_max?(param_id)
    erase_buff(param_id) if debuff?(param_id)
    overwrite_buff_turns(param_id, turns)
    @result.added_buffs.push(param_id).uniq!
    refresh
  end
  #--------------------------------------------------------------------------
  # * Add Debuff
  #--------------------------------------------------------------------------
  def add_debuff(param_id, turns)
    return unless alive?
    @buffs[param_id] -= 1 unless debuff_max?(param_id)
    erase_buff(param_id) if buff?(param_id)
    overwrite_buff_turns(param_id, turns)
    @result.added_debuffs.push(param_id).uniq!
    refresh
  end
  #--------------------------------------------------------------------------
  # * Remove Buff/Debuff
  #--------------------------------------------------------------------------
  def remove_buff(param_id)
    return unless alive?
    return if @buffs[param_id] == 0
    erase_buff(param_id)
    @buff_turns.delete(param_id)
    @result.removed_buffs.push(param_id).uniq!
    refresh
  end
  #--------------------------------------------------------------------------
  # * Erase Buff/Debuff
  #--------------------------------------------------------------------------
  def erase_buff(param_id)
    @buffs[param_id] = 0
    @buff_turns[param_id] = 0
  end
  #--------------------------------------------------------------------------
  # * Determine Buff Status
  #--------------------------------------------------------------------------
  def buff?(param_id)
    @buffs[param_id] > 0
  end
  #--------------------------------------------------------------------------
  # * Determine Debuff Status
  #--------------------------------------------------------------------------
  def debuff?(param_id)
    @buffs[param_id] < 0
  end
  #--------------------------------------------------------------------------
  # * Determine if Buff Is at Maximum Level
  #--------------------------------------------------------------------------
  def buff_max?(param_id)
    @buffs[param_id] == 2
  end
  #--------------------------------------------------------------------------
  # * Determine if Debuff Is at Maximum Level
  #--------------------------------------------------------------------------
  def debuff_max?(param_id)
    @buffs[param_id] == -2
  end
  #--------------------------------------------------------------------------
  # * Overwrite Buff/Debuff Turns
  #    Doesn't overwrite if number of turns would become shorter.
  #--------------------------------------------------------------------------
  def overwrite_buff_turns(param_id, turns)
    @buff_turns[param_id] = turns if @buff_turns[param_id].to_i < turns
  end
  #--------------------------------------------------------------------------
  # * Update State Turn Count
  #--------------------------------------------------------------------------
  def update_state_turns
    states.each do |state|
      @state_turns[state.id] -= 1 if @state_turns[state.id] > 0
    end
  end
  #--------------------------------------------------------------------------
  # * Update Buff/Debuff Turn Count
  #--------------------------------------------------------------------------
  def update_buff_turns
    @buff_turns.keys.each do |param_id|
      @buff_turns[param_id] -= 1 if @buff_turns[param_id] > 0
    end
  end
  #--------------------------------------------------------------------------
  # * 전투 상태 제거
  #--------------------------------------------------------------------------
  def remove_battle_states
    states.each do |state|
      remove_state(state.id) if state.remove_at_battle_end
    end
  end
  #--------------------------------------------------------------------------
  # * Remove All Buffs/Debuffs
  #--------------------------------------------------------------------------
  def remove_all_buffs
    @buffs.size.times {|param_id| remove_buff(param_id) }
  end
  #--------------------------------------------------------------------------
  # * 자동으로 상태 제거
  # 타이밍: 타이밍 (1: 액션 종료 2: 턴 종료)
  #--------------------------------------------------------------------------
  def remove_states_auto(timing)
    states.each do |state|
      if @state_turns[state.id] == 0 && state.auto_removal_timing == timing
        remove_state(state.id)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Automatically Remove Buffs/Debuffs
  #--------------------------------------------------------------------------
  def remove_buffs_auto
    @buffs.size.times do |param_id|
      next if @buffs[param_id] == 0 || @buff_turns[param_id] > 0
      remove_buff(param_id)
    end
  end
  #--------------------------------------------------------------------------
  # * Remove State by Damage
  #--------------------------------------------------------------------------
  def remove_states_by_damage
    states.each do |state|
      if state.remove_by_damage && rand(100) < state.chance_by_damage
        remove_state(state.id)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Determine Action Times
  #--------------------------------------------------------------------------
  def make_action_times
    action_plus_set.inject(1) {|r, p| rand < p ? r + 1 : r }
  end
  #--------------------------------------------------------------------------
  # * Create Battle Action
  #--------------------------------------------------------------------------
  def make_actions
    clear_actions
    return unless movable?
    @actions = Array.new(make_action_times) { Game_Action.new(self) }
  end
  #--------------------------------------------------------------------------
  # * Determine Action Speed
  #--------------------------------------------------------------------------
  def make_speed
    @speed = @actions.collect {|action| action.speed }.min || 0
  end
  #--------------------------------------------------------------------------
  # * Get Current Action
  #--------------------------------------------------------------------------
  def current_action
    @actions[0]
  end
  #--------------------------------------------------------------------------
  # * Remove Current Action
  #--------------------------------------------------------------------------
  def remove_current_action
    @actions.shift
  end
  #--------------------------------------------------------------------------
  # * 강제 조치
  #--------------------------------------------------------------------------
  def force_action(skill_id, target_index)
    clear_actions
    action = Game_Action.new(self, true)
    action.set_skill(skill_id)
    #print("Game_Battler - %s \n" % [target_index]);
    if target_index == -2
      action.target_index = last_target_index
    elsif target_index == -1
      action.decide_random_target
    else
      action.target_index = target_index
    end
    @actions.push(action)
  end
  #--------------------------------------------------------------------------
  # * Calculate Damage
  #--------------------------------------------------------------------------
  def make_damage_value(user, item)
    value = item.damage.eval(user, self, $game_variables)
    value *= item_element_rate(user, item)
    # 데미지 속성 비율 값 대입
    @result.damage_el = item_element_rate(user, item)
    #value *= pdr if item.physical?
    #value *= mdr if item.magical?
    #value *= rec if item.damage.recover?
    value = apply_critical(value, user) if @result.critical
    # 치명타 원본 계산 공식
    #value = apply_critical(value) if @result.critical
    value = apply_variance(value, item.damage.variance)
    value *= user.pdr if item.physical?
    #print("Game_Battler - %s, %s \n" % [user.pdr, item.physical?]);
    value *= user.mdr if item.magical?
    #print("Game_Battler - %s, %s \n" % [user.mdr, item.magical?]);
    value *= rec if item.damage.recover?
    value = apply_guard(value)
    # 주먹으로 공격한 경우
    if user.is_a?(Game_Actor)
      #print("Game_Battler - %s, %s \n" % [item.is_a?(RPG::Weapon), item.id]);
      if item.is_a?(RPG::Skill) and item.id == 1 and $game_actors[user.id].equips[0] == nil
        #print("Game_Battler - %s, 주먹을 사용 \n" % [user.name]);
        value = 1
      # 양손이 무기인 경우 공격력 최종적으로 60%만 적용
      elsif $game_actors[user.id].equips[0].is_a?(RPG::Weapon) and $game_actors[user.id].equips[1].is_a?(RPG::Weapon)
        value *= 0.7
      end
      # 업적 추가
      if user.is_a?(Game_Player)
        if item.damage.element_id == 5  # 뇌 속성
          if user.state?(24) == true    # 젖음 상태
            $game_party.gain_medal(23)
          end
        end
      end
    end
    @result.make_damage(value.to_i, item)
  end
  #--------------------------------------------------------------------------
  # * 스킬/아이템에 대한 요소 수정자 가져오기
  #--------------------------------------------------------------------------
  def item_element_rate(user, item)
    if item.damage.element_id < 0
      user.atk_elements.empty? ? 1.0 : elements_max_rate(user.atk_elements)
    else
      element_rate(item.damage.element_id)
    end
  end
  #--------------------------------------------------------------------------
  # * 최대 원소 조정량 얻기
  # elements : 속성 ID의 배열
  # 모든 요소 정렬의 가장 효과적인 조정을 반환합니다.
  #--------------------------------------------------------------------------
  def elements_max_rate(elements)
    elements.inject([0.0]) {|r, i| r.push(element_rate(i)) }.max
  end
  #--------------------------------------------------------------------------
  # * Apply Critical
  #--------------------------------------------------------------------------
  # 치명타 원본 계산 공식
  #def apply_critical(damage)
  #  damage * 3
  #end
  def apply_critical(damage, user)
    #damage * (1.3 + (user.luk * 0.001))
    damage * (user.atk_lk + (user.luk * 0.001)).to_i
  end
  #--------------------------------------------------------------------------
  # * 분산 적용
  #--------------------------------------------------------------------------
  def apply_variance(damage, variance)
    amp = [damage.abs * variance / 100, 0].max.to_i
    var = rand(amp + 1) + rand(amp + 1) - amp
    damage >= 0 ? damage + var : damage - var
  end
  #--------------------------------------------------------------------------
  # * Applying Guard Adjustment
  #--------------------------------------------------------------------------
  def apply_guard(damage)
    damage / (damage > 0 && guard? ? 2 * grd : 1)
  end
  #--------------------------------------------------------------------------
  # * 데미지 처리
  # @result.hp_damage @result.mp_damage @result.hp_drain
  # @result.mp_drain은 호출 전에 설정해야 합니다.
  #--------------------------------------------------------------------------
  def execute_damage(user)
    on_damage(@result.hp_damage) if @result.hp_damage > 0
    # ------------------------------------------------------------------------
    # 특수 상태이상 적용
    # ------------------------------------------------------------------------
    # 마력 보호막, 피해 경감
    if self.state?(67) == true
      #print("원래 데미지 %s / %s \n" % [@result.hp_damage, @result.mp_damage]);
      @result.mp_damage = (self.mmp * 0.05).to_i
      #print("소비된 MP %s \n" % [@result.mp_damage]);
      @ro_mi_damage = (@result.hp_damage * (self.mp / 100 * 0.01)).to_i
      #print("경감된 데미지 %s \n" % [@ro_mi_damage]);
      @result.hp_damage = @result.hp_damage - @ro_mi_damage
      #print("경감된 데미지 %s / %s \n" % [@result.hp_damage, @result.mp_damage]);
      self.remove_state(67) if self.mmp * 0.05 >= self.mp
      self.hp -= @result.hp_damage #if @result.hp_damage >= 1
      self.mp -= @result.mp_damage #if @result.mp_damage >= 1
      #print("Game_Battler 적용 1 - %s, %s \n" % [self.id, @result.hp_damage]);
    else
      self.hp -= @result.hp_damage
      self.mp -= @result.mp_damage
      #print("Game_Battler 적용 2 - %s, %s \n" % [self.id, @result.hp_damage]);
    end
    # 피해 감소
    if self.state?(166) # 철웅성, 피해 감소 5%
      @result.hp_damage -= (@result.hp_damage * 0.05).to_i if @result.hp_damage >= 1
      @result.hp_damage = 0 if 1 > @result.hp_damage
      #print("Game_Battler 적용 3 - %s, %s \n" % [self.id, @result.hp_damage]);
    end
    # ------------------------------------------------------------------------
    user.hp += @result.hp_drain
    user.mp += @result.mp_drain
  end
  #--------------------------------------------------------------------------
  # * Use Skill/Item
  #    연기하는 쪽을 불러 사용자가 아닌 다른 사람에게 효과를 적용합니다.
  #--------------------------------------------------------------------------
  def use_item(item)
    # 게임 맵에서만 적용되는 부분이다.
    pay_skill_cost(item) if item.is_a?(RPG::Skill)
    consume_item(item)   if item.is_a?(RPG::Item)
    #print("Game_Battler Use Skill/Item : (%s) \n" % [item.name]);
    #item.effects.each {|effect| item_global_effect_apply(effect) }
  end
  #--------------------------------------------------------------------------
  # * 아이템 소비
  #--------------------------------------------------------------------------
  def consume_item(item)
    $game_party.consume_item(item)
  end
  #--------------------------------------------------------------------------
  # * 이용자 외 이용효과 적용
  #--------------------------------------------------------------------------
  def item_global_effect_apply(effect)
    # 게임 맵에서만 적용되는 부분이다.
    #if effect.code == EFFECT_COMMON_EVENT
    #  #print("Game_Battler 이용자 외 이용효과 적용 : (%s) \n" % [effect.data_id]);
    #  $game_temp.reserve_common_event(effect.data_id)
    #end
  end
  #--------------------------------------------------------------------------
  # * 테스트 스킬/아이템 적용
  # 예를 들어 캐릭터가 이미 완전히 치유되었는지 확인하는 데 사용됩니다.
  # 더 이상 복구할 수 없습니다.
  #--------------------------------------------------------------------------
  def item_test(user, item)
    return false if item.for_dead_friend? != dead?
    return true if $game_party.in_battle
    return true if item.for_opponent?
    return true if item.damage.recover? && item.damage.to_hp? && hp < mhp
    return true if item.damage.recover? && item.damage.to_mp? && mp < mmp
    return true if item_has_any_valid_effects?(user, item)
    return false
  end
  #--------------------------------------------------------------------------
  # * 스킬/아이템에 유효한 효과가 있는지 확인
  #--------------------------------------------------------------------------
  def item_has_any_valid_effects?(user, item)
    item.effects.any? {|effect| item_effect_test(user, item, effect) }
  end
  #--------------------------------------------------------------------------
  # * 스킬/아이템의 역습율 계산
  #--------------------------------------------------------------------------
  def item_cnt(user, item)
    return 0 unless item.physical?          # Hit type is not physical
    return 0 unless opposite?(user)         # No counterattack on allies
    return cnt                              # Return counterattack rate
  end
  #--------------------------------------------------------------------------
  # * 스킬/아이템 반사율 계산
  #--------------------------------------------------------------------------
  def item_mrf(user, item)
    return mrf if item.magical?     # Return magic reflection if magic attack
    return 0
  end
  #--------------------------------------------------------------------------
  # * 스킬/아이템 적중률 계산
  #--------------------------------------------------------------------------
  def item_hit(user, item)
    rate = item.success_rate * 0.01     # Get success rate
    rate *= user.hit if item.physical?  # Physical attack: Multiply hit rate
    return rate                         # Return calculated hit rate
  end
  #--------------------------------------------------------------------------
  # * 스킬/아이템의 회피율 계산
  #--------------------------------------------------------------------------
  def item_eva(user, item)
    return eva if item.physical?    # Return evasion if physical attack
    return mev if item.magical?     # Return magic evasion if magic attack
    return 0
  end
  #--------------------------------------------------------------------------
  # * 스킬/아이템의 크리티컬 확률 계산
  #--------------------------------------------------------------------------
  def item_cri(user, item)
    item.damage.critical ? user.cri * (1 - cev) : 0
  end
  #--------------------------------------------------------------------------
  # * 일반 공격 효과 적용
  #--------------------------------------------------------------------------
  def attack_apply(attacker)
    item_apply(attacker, $data_skills[attacker.attack_skill_id])
  end
  #--------------------------------------------------------------------------
  # * Apply Effect of Skill/Item
  #--------------------------------------------------------------------------
  def item_apply(user, item)
    @result.clear
    @result.used = item_test(user, item)
    @result.missed = (@result.used && rand >= item_hit(user, item))
    @result.evaded = (!@result.missed && rand < item_eva(user, item))
    if @result.hit?
      unless item.damage.none?
        @result.critical = (rand < item_cri(user, item))
        make_damage_value(user, item)
        execute_damage(user)
      end
      item.effects.each {|effect| item_effect_apply(user, item, effect) }
      item_user_effect(user, item)
    end
  end
  #--------------------------------------------------------------------------
  # * Test Effect
  #--------------------------------------------------------------------------
  def item_effect_test(user, item, effect)
    case effect.code
    when EFFECT_RECOVER_HP
      hp < mhp || effect.value1 < 0 || effect.value2 < 0
    when EFFECT_RECOVER_MP
      mp < mmp || effect.value1 < 0 || effect.value2 < 0
    when EFFECT_ADD_STATE
      !state?(effect.data_id)
    when EFFECT_REMOVE_STATE
      state?(effect.data_id)
    when EFFECT_ADD_BUFF
      !buff_max?(effect.data_id)
    when EFFECT_ADD_DEBUFF
      !debuff_max?(effect.data_id)
    when EFFECT_REMOVE_BUFF
      buff?(effect.data_id)
    when EFFECT_REMOVE_DEBUFF
      debuff?(effect.data_id)
    when EFFECT_LEARN_SKILL
      actor? && !skills.include?($data_skills[effect.data_id])
    else
      true
    end
  end
  #--------------------------------------------------------------------------
  # * Apply Effect
  #--------------------------------------------------------------------------
  def item_effect_apply(user, item, effect)
    method_table = {
      EFFECT_RECOVER_HP    => :item_effect_recover_hp,
      EFFECT_RECOVER_MP    => :item_effect_recover_mp,
      EFFECT_GAIN_TP       => :item_effect_gain_tp,
      EFFECT_ADD_STATE     => :item_effect_add_state,
      EFFECT_REMOVE_STATE  => :item_effect_remove_state,
      EFFECT_ADD_BUFF      => :item_effect_add_buff,
      EFFECT_ADD_DEBUFF    => :item_effect_add_debuff,
      EFFECT_REMOVE_BUFF   => :item_effect_remove_buff,
      EFFECT_REMOVE_DEBUFF => :item_effect_remove_debuff,
      EFFECT_SPECIAL       => :item_effect_special,
      EFFECT_GROW          => :item_effect_grow,
      EFFECT_LEARN_SKILL   => :item_effect_learn_skill,
      EFFECT_COMMON_EVENT  => :item_effect_common_event,
    }
    method_name = method_table[effect.code]
    #print("Game_Battler - %s, %s \n" % [method_name, effect.code]);
    #if method_name == "item_effect_common_event"
    #  #print("Game_Battler 커먼 이벤트 실행 - %s \n" % [effect.data_id]);
    #  SceneManager.goto(Scene_Map)
    #  $game_temp.reserve_common_event(effect.data_id)
    #else
      send(method_name, user, item, effect) if method_name
    #end
  end
  #--------------------------------------------------------------------------
  # * [HP Recovery] Effect
  #--------------------------------------------------------------------------
  def item_effect_recover_hp(user, item, effect)
    value = (mhp * effect.value1 + effect.value2) * rec * self.tgr
    #value = (mhp * effect.value1 + effect.value2) * rec * pha
    #print("Game_Battler - %s, %s, %s, %s \n" % [effect.value1, effect.value2, rec, pha]);
    # Alog https://arca.live/b/alog
    #value *= user.pha if item.is_a?(RPG::Item)
    value = value.to_i
    @result.hp_damage -= value
    @result.success = true
    self.hp += value
    
    #print("Game_Battler - %s, %s \n" % [user.id, user.is_a?(Game_Actor)]);
    # 친밀도 증가
=begin
    if user.is_a?(Game_Actor)
      if user.id != 7
        $game_variables[126] = user.id if $game_variables[126] == 0
        $game_actors[$game_variables[126]].set_custom_bio[21] = $game_actors[$game_variables[126]].set_custom_bio[21].to_i
        if $game_actors[$game_variables[126]].mhp - value >= $game_actors[$game_variables[126]].hp
          $game_actors[$game_variables[126]].set_custom_bio[21] = $game_actors[$game_variables[126]].set_custom_bio[21].to_i + value.to_i
        end
      end
    end
=end
  end
  #--------------------------------------------------------------------------
  # * [MP Recovery] Effect
  #--------------------------------------------------------------------------
  def item_effect_recover_mp(user, item, effect)
    value = (mmp * effect.value1 + effect.value2) * rec * self.tgr
    #value = (mmp * effect.value1 + effect.value2) * rec * pha
    # Alog https://arca.live/b/alog
    #value *= user.pha if item.is_a?(RPG::Item)
    value = value.to_i
    @result.mp_damage -= value
    @result.success = true if value != 0
    self.mp += value
    
    #print("Game_Battler - %s, %s \n" % [user.id, user.is_a?(Game_Actor)]);
    # 친밀도 증가
=begin
    if user.is_a?(Game_Actor)
      if user.id != 7
        $game_variables[126] = user.id if $game_variables[126] == 0
        $game_actors[$game_variables[126]].set_custom_bio[21] = $game_actors[$game_variables[126]].set_custom_bio[21].to_i
        if $game_actors[$game_variables[126]].mmp - value >= $game_actors[$game_variables[126]].mp
          $game_actors[$game_variables[126]].set_custom_bio[21] = $game_actors[$game_variables[126]].set_custom_bio[21].to_i + value.to_i
        end
      end
    end
=end
  end
  #--------------------------------------------------------------------------
  # * [TP Gain] Effect
  #--------------------------------------------------------------------------
  def item_effect_gain_tp(user, item, effect)
    value = effect.value1.to_i
    @result.tp_damage -= value
    @result.success = true if value != 0
    self.tp += value
  end
  #--------------------------------------------------------------------------
  # * [Add State] Effect
  #--------------------------------------------------------------------------
  def item_effect_add_state(user, item, effect)
    if effect.data_id == 0
      item_effect_add_state_attack(user, item, effect)
    else
      #print("Game_Battler - 오류 확인 %s \n" % [user]);
      item_effect_add_state_normal(user, item, effect)
    end
  end
  #--------------------------------------------------------------------------
  # * [Add State] Effect: Normal Attack
  #--------------------------------------------------------------------------
  def item_effect_add_state_attack(user, item, effect)
    user.atk_states.each do |state_id|
      chance = effect.value1
      chance *= 1 * state_rate(state_id)
      chance *= 1 * user.atk_states_rate(state_id)
      chance *= 1 * luk_effect_rate(user)
      if rand < chance
        add_state(state_id)
        #print("Game_Battler - 오류 확인 1 %s \n" % [user]);
        @result.success = true
      end
    end
  end
  #--------------------------------------------------------------------------
  # * [Add State] Effect: Normal
  #--------------------------------------------------------------------------
  def item_effect_add_state_normal(user, item, effect)
    chance = effect.value1
    chance *= 1 * state_rate(effect.data_id) if opposite?(user)
    chance *= 1 * luk_effect_rate(user)      if opposite?(user)
    if rand < chance
      add_state(effect.data_id)

      # 업적 추가
      if self.is_a?(Game_Actor)
        if self.id == 7
          # 상처, 출혈 상태
          if effect.data_id == 13 or effect.data_id == 120 or effect.data_id == 135 or effect.data_id == 136
            $game_variables[329] += 1
            if $game_variables[329] >= 100
              $game_party.gain_medal(28)
            end
          end
        end
      end
      
      #print("Game_Battler - 오류 확인 2 %s \n" % [user]);
      @result.success = true
    end
  end
  #--------------------------------------------------------------------------
  # * [Remove State] Effect
  #--------------------------------------------------------------------------
  def item_effect_remove_state(user, item, effect)
    chance = effect.value1
    if rand < chance
      remove_state(effect.data_id)
      @result.success = true
    end
  end
  #--------------------------------------------------------------------------
  # * [Buff] Effect
  #--------------------------------------------------------------------------
  def item_effect_add_buff(user, item, effect)
    add_buff(effect.data_id, effect.value1)
    @result.success = true
  end
  #--------------------------------------------------------------------------
  # * [Debuff] Effect
  #--------------------------------------------------------------------------
  def item_effect_add_debuff(user, item, effect)
    chance = debuff_rate(effect.data_id) * luk_effect_rate(user)
    if rand < chance
      add_debuff(effect.data_id, effect.value1)
      @result.success = true
    end
  end
  #--------------------------------------------------------------------------
  # * [Remove Buff] Effect
  #--------------------------------------------------------------------------
  def item_effect_remove_buff(user, item, effect)
    remove_buff(effect.data_id) if @buffs[effect.data_id] > 0
    @result.success = true
  end
  #--------------------------------------------------------------------------
  # * [Remove Debuff] Effect
  #--------------------------------------------------------------------------
  def item_effect_remove_debuff(user, item, effect)
    remove_buff(effect.data_id) if @buffs[effect.data_id] < 0
    @result.success = true
  end
  #--------------------------------------------------------------------------
  # * [Special Effect] Effect
  #--------------------------------------------------------------------------
  def item_effect_special(user, item, effect)
    case effect.data_id
    when SPECIAL_EFFECT_ESCAPE
      escape
    end
    @result.success = true
  end
  #--------------------------------------------------------------------------
  # * [파라미터 상승] 효과
  #--------------------------------------------------------------------------
  def item_effect_grow(user, item, effect)
    add_param(effect.data_id, effect.value1.to_i)
    #print("Game_Battler %s, %s \n" % [effect.data_id, effect.value1.to_i]);
    @result.success = true
  end
  #--------------------------------------------------------------------------
  # * [Learn Skill] Effect
  #--------------------------------------------------------------------------
  def item_effect_learn_skill(user, item, effect)
    # Alog https://arca.live/b/alog
    # 아이템 사용시 스킬 배우는걸 삭제로 변경 실험
    if effect.data_id != 328
      learn_skill(effect.data_id) if user.is_a?(Game_Actor)
    else
      forget_skill(effect.data_id) if user.is_a?(Game_Actor)
    end
    @result.success = true
  end
  #--------------------------------------------------------------------------
  # * [Common Event] Effect
  #--------------------------------------------------------------------------
  def item_effect_common_event(user, item, effect)
  #def item_effect_common_event(user = 7, item = 0, effect = nil)
    # Scene_ItemBase 에서 실행하는 커먼 이벤트를 생략하고,
    # 여기서 바로 커먼 이벤트를 강제로 실행한다.
    if effect.data_id != nil
      #print("Game_Battler - %s, %s, %s \n" % [user, item, effect.data_id]);
      
      # 메뉴창에서 사용시 mp, tp 소모 적용
      if !SceneManager.scene_is?(Scene_Map)
        pay_skill_cost(item) if item.is_a?(RPG::Skill)
        #consume_item(item)   if item.is_a?(RPG::Item)
        $game_temp.reserve_common_event(effect.data_id)
      end
      
      if !item.is_a?(RPG::Skill)
        $game_temp.reserve_common_event(effect.data_id)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Effect of Skill/Item on Using Side
  #--------------------------------------------------------------------------
  def item_user_effect(user, item)
    user.tp += item.tp_gain * user.tcr
  end
  #--------------------------------------------------------------------------
  # * Get Effect Change Rate by Luck
  #--------------------------------------------------------------------------
  def luk_effect_rate(user)
    [1.0 + (user.luk - luk) * 0.001, 0.0].max
  end
  #--------------------------------------------------------------------------
  # * Determine if Hostile Relation
  #--------------------------------------------------------------------------
  def opposite?(battler)
    actor? != battler.actor? || battler.magic_reflection
  end
  #--------------------------------------------------------------------------
  # * Effect When Taking Damage on Map
  #--------------------------------------------------------------------------
  def perform_map_damage_effect
  end
  #--------------------------------------------------------------------------
  # * Initialize TP
  #--------------------------------------------------------------------------
  def init_tp
    # Alog https://arca.live/b/alog
    #self.tp = rand * 25
  end
  #--------------------------------------------------------------------------
  # * Clear TP
  #--------------------------------------------------------------------------
  def clear_tp
    # Alog https://arca.live/b/alog
    #self.tp = 0
  end
  #--------------------------------------------------------------------------
  # * Charge TP by Damage Suffered
  #--------------------------------------------------------------------------
  def charge_tp_by_damage(damage_rate)
    # Alog https://arca.live/b/alog
    #self.tp += 50 * damage_rate * tcr
  end
  #--------------------------------------------------------------------------
  # * 재생성 HP
  #--------------------------------------------------------------------------
  def regenerate_hp
    damage = -(mhp * hrg).to_i
    damage = damage - self.def.to_i if damage > self.def.to_i
    perform_map_damage_effect if $game_party.in_battle && damage > 0
    @result.hp_damage = [damage, max_slip_damage].min
    # ------------------------------------------------------------------------
    # 특수 상태이상 적용
    # ------------------------------------------------------------------------
    # 자연 회복, 재생비율은 제외된다.
    if 0 >= @result.hp_damage
      # 치명상, 피바다의 혈투, 완벽한 전사
      if self.state?(118) or self.state?(167) or self.state?(61)
        @result.hp_damage = 0
        return
      end
    end
    # ------------------------------------------------------------------------
    # Alog https://arca.live/b/alog
    # 재생비율 데미지가 100 이상인 경우 100 으로 변경 실험
    @result.hp_damage = (mhp * 0.1).to_i if @result.hp_damage > (mhp * 0.1)
    @result.hp_damage = 100 if @result.hp_damage > 100

    if 1 > @result.hp_damage
      self.hp != self.mhp ? self.hp -= @result.hp_damage : @result.hp_damage = 0
    else
      self.hp >= 1 ? self.hp -= @result.hp_damage : @result.hp_damage = 0
    end

    # 상태이상으로는 죽지 않으며 hp 1을 남김 실험
    die if 0 >= self.hp
  end
  #--------------------------------------------------------------------------
  # * 슬립 데미지의 최대값 얻기
  #--------------------------------------------------------------------------
  def max_slip_damage
    $data_system.opt_slip_death ? hp : [hp - 1, 0].max
  end
  #--------------------------------------------------------------------------
  # * Regenerate MP
  #--------------------------------------------------------------------------
  def regenerate_mp
    @result.mp_damage = -(mmp * mrg).to_i
    # 치명상 상태인 경우 자연 회복, 재생비율은 제외된다.
    if self.state?(118) and 0 >= @result.mp_damage
      @result.mp_damage = 0
      return
    end
    # Alog https://arca.live/b/alog
    # 재생비율 데미지가 100 이상인 경우 100 으로 변경 실험
    @result.mp_damage = mmp*0.1 if @result.mp_damage > (mmp*0.1)
    @result.mp_damage = 100 if @result.mp_damage > 100
    
    if 1 > @result.mp_damage
      self.mp != self.mmp ? self.mp -= @result.mp_damage : @result.mp_damage = 0
    else
      self.mp >= 1 ? self.mp -= @result.mp_damage : @result.mp_damage = 0
    end
  end
  #--------------------------------------------------------------------------
  # * Regenerate TP
  #--------------------------------------------------------------------------
  def regenerate_tp
    # 치명상 상태인 경우 자연 회복, 재생비율은 제외된다.
    return if self.state?(118)
    # Alog https://arca.live/b/alog
    if 1 > 100 * trg
      self.tp += 100 * trg if self.tp != self.mtp
    else
      self.tp += 100 * trg
    end
  end
  #--------------------------------------------------------------------------
  # * Regenerate All
  #--------------------------------------------------------------------------
  def regenerate_all
    if alive?
      #print("Game_Battler - 회복력을 확인한다. \n");
      regenerate_hp
      regenerate_mp
      regenerate_tp
    end
  end
  #--------------------------------------------------------------------------
  # * Processing at Start of Battle
  #--------------------------------------------------------------------------
  def on_battle_start
    init_tp unless preserve_tp?
  end
  #--------------------------------------------------------------------------
  # * Processing at End of Action
  #--------------------------------------------------------------------------
  def on_action_end
    @result.clear
    #remove_states_auto(1)
    #remove_buffs_auto
  end
  #--------------------------------------------------------------------------
  # * Processing at End of Turn
  #--------------------------------------------------------------------------
  def on_turn_end
    @result.clear
    regenerate_all
    #update_state_turns
    #update_buff_turns
    #remove_states_auto(2)
  end
  #--------------------------------------------------------------------------
  # * 전투의 끝에서 처리
  #--------------------------------------------------------------------------
  def on_battle_end
    @result.clear
    remove_battle_states
    #remove_all_buffs
    clear_actions
    clear_tp unless preserve_tp?
    appear
  end
  #--------------------------------------------------------------------------
  # * Processing When Suffering Damage
  #--------------------------------------------------------------------------
  def on_damage(value)
    remove_states_by_damage
    charge_tp_by_damage(value.to_f / mhp)
  end
end