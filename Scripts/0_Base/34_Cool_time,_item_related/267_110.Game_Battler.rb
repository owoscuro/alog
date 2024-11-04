# encoding: utf-8
# Name: 110.Game_Battler
# Size: 5805
# encoding: utf-8
# Name: 110.Game_Battler
# Size: 5426
class Game_Battler < Game_BattlerBase
  attr_reader   :state_steps
  attr_accessor :buff_turns, :buffs, :used_item, :deadposing
  attr_accessor :skill_cooldown, :item_cooldown, :weapon_cooldown
  #attr_accessor :skill_cooldown, :item_cooldown, :weapon_cooldown, :armor_cooldown
  
  alias falcaopearl_battler_ini initialize
  def initialize
    #print("110.Game_Battler - ");
    #print("쿨타임 리셋 진행 \n");
    @skill_cooldown = {}
    @item_cooldown = {}
    @weapon_cooldown = {}
    #@armor_cooldown = {}
    falcaopearl_battler_ini
  end

  alias falcaopearl_battler_refresh refresh
  def refresh
    falcaopearl_battler_refresh
  end

  alias falcaopearl_revive revive
  def revive
    # if SceneManager.scene_is?(Scene_Item) || SceneManager.scene_is?(Scene_Skill)
    #   $game_temp.pop_w(180, 'SYSTEM', 
    #   '  메뉴에서는 캐릭터를 소생시킬 수 없습니다.  ')
    #   return
    # end
    if SceneManager.scene_is?(Scene_Item) || SceneManager.scene_is?(Scene_Skill)
      $game_temp.pop_w(180, 'SYSTEM', 
      '  No se puede revivir a los personajes desde el menú.  ')
      return
    end

    falcaopearl_revive
    @deadposing = nil
  end
  
  alias falcaopearl_addnew add_new_state
  def add_new_state(state_id)
    falcaopearl_addnew(state_id)
     if self.is_a?(Game_Actor)
      #print("110.Game_Battler - ");
      #print("새로운 상태이상 %s, 스킬바 새로고침 적용 \n" % [state_id]);
      $game_player.refresh_skillbar = 4
    end
  end
  
  def tool_ready?(item)
    return false if item.is_a?(RPG::Skill)  and @skill_cooldown[item.id]
    return false if item.is_a?(RPG::Item)   and @item_cooldown[item.id]
    return false if item.is_a?(RPG::Weapon) and @weapon_cooldown[item.id]
    #return false if item.is_a?(RPG::Armor)  and @armor_cooldown[item.id]
    return true
  end
  
  def apply_cooldown(item, value)
    @skill_cooldown[item.id]  = value if item.is_a?(RPG::Skill)
    @item_cooldown[item.id]   = value if item.is_a?(RPG::Item)
    @weapon_cooldown[item.id] = value if item.is_a?(RPG::Weapon)
    #@armor_cooldown[item.id]  = value if item.is_a?(RPG::Armor)
  end
  
  # 장면 맵에서 사용되는 경우 상태에 대한 단계 설정을 초로 설정합니다.
  alias falcaopearl_stepsset reset_state_counts
  def reset_state_counts(state_id)
    falcaopearl_stepsset(state_id)
    state = $data_states[state_id]
    # 스턴 상태이상 시간 조절
    if state_id == 8
      @state_steps[state_id] = state.steps_to_remove * 3
    # 공포 상태이상 시간 조절, 행동 제한 상태이상인 경우
    elsif state_id == 138 or state.restriction == 4
      @state_steps[state_id] = state.steps_to_remove * 10
    # 충격 흡수 상태이상 시간 조절
    elsif state_id >= 177 and 181 >= state_id
      @state_steps[state_id] = state.steps_to_remove * 10
    # 발도, 투기 상태이상 시간 지정
    elsif state_id == 185 or (state_id >= 190 and 199 >= state_id)
      @state_steps[state_id] = state.steps_to_remove
    # 방어 상태이상 시간 지정
    elsif state_id == 9
      @state_steps[state_id] = state.steps_to_remove
    # 에크티 표식 랜덤 시간 적용
    elsif state_id == 161
      @state_steps[state_id] = state.steps_to_remove * (rand(20)+1)
      $game_variables[142] = @state_steps[state_id].to_i
    # 일반 상태이상은 60을 곱해서 분 단위로 만든다.
    else
      @state_steps[state_id] = state.steps_to_remove * 60
    end
  end

  # 항목을 항상 지도에 표시
  alias falcaopearl_occasion_ok occasion_ok?
  def occasion_ok?(item)
    return true if SceneManager.scene_is?(Scene_Map) ||
    SceneManager.scene_is?(Scene_QuickTool) || 
    SceneManager.scene_is?(Scene_CharacterSet)
    falcaopearl_occasion_ok(item)
  end
  
  # 사용성 설정 적용(스킬 바 아이콘 새로 고침에 사용)
  alias falcaopearl_usablecheck use_item
  def use_item(item)
    if self.is_a?(Game_Actor)
      # 오류 방지용 추가, 메뉴에서 사용시 적용하지 않는다.
      if SceneManager.scene_is?(Scene_Map)
        #print("110.Game_Battler - ");
        #print("%s 사용했다, 스킬 바 아이콘 새로 고침 \n" % [item.name]);
        falcaopearl_usablecheck(item)
        self.apply_usability #if self.is_a?(Game_Actor)
      end
    end
  end

  # 호출된 도구와 함께 사용되는 근접 공격 적용
  def melee_attack_apply(user, item_id)
    #print("110.Game_Battler - ");
    #print("%s 가 %s 사용했다. \n" % [user.name, $data_skills[item_id].name]);
    item_apply(user, $data_skills[item_id])
  end
  
  alias falcaopearl_itemapply item_apply
  def item_apply(user, item)
    #print("110.Game_Battler - item_apply %s \n" % [item.weight_mod]);
    
    # 아래 return if enemy? 를 살리면 몬스터에게 데미지가 안들어간다.
    #return if enemy?
    
    if user.is_a?(Game_Actor)
      if user.available_weight < 0
        # $game_temp.pop_w(180, 'SYSTEM', "  너무 무거워서 착용할 수 없습니다.  ")
        $game_temp.pop_w(180, 'SYSTEM', "  No puedes equiparlo porque es demasiado pesado.  ")
        $game_party.menu_actor = user
        #$game_party.menu_actor = self
        SceneManager.call(Scene_Equip)
      end
    end
    if item != nil and user != nil
      # 아래 조건은 마결정 조건
      if item.id >= 448 and 454 >= item.id
        # 인챈트시 사용되는 변수 대입
        $game_variables[74] = user.id
        $game_variables[73] = item.id - 447
      end
      @used_item = item
    end
    falcaopearl_itemapply(user, item)
  end
end