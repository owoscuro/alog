# encoding: utf-8
# Name: 115.Game_Party
# Size: 24459
#-------------------------------------------------------------------------------
# open_storage(이름, 이름_창, 카테고리, 골드)
#     name = 스토리지의 이름
#     name_window = (true or false) 이름 창을 표시하려면 true
#     category = (true or false)    카테고리 창을 표시하려면 true
#     gold = (true or false)        범주 창에 금을 표시하려면 true
#
# open_storage(까마귀 여관 창고, true, true, false)
#
# 특정 저장소에서 항목을 추가하거나 제거하려면 스크립트 호출에서 이 명령을 사용하십시오.
#
# open_storage(까마귀 여관 창고, true, true, false)
# storage_add_item(name, :item, id, amount)
# storage_remove_item(name, :item, id, amount)
#     name = 스토리지의 이름
#     type = 항목의 유형은(:item, :weapon, :armor)일 수 있습니다.
#     id = 항목의 데이터베이스 ID
#     amount = 추가하거나 제거할 금액
#
# 특정 저장소의 모든 항목과 금을 제거하려면 스크립트 호출에서 이 명령을 사용하십시오.
#     clear_storage(name)
#     name = 스토리지의 이름
#
# 특정 저장소에 있는 항목의 양을 확인하려면 스크립트 호출에서 이 명령을 사용하십시오.
#     storage_item_number(name, :item, id)
#     name = 스토리지의 이름
#     type = 항목의 유형은(:item, :weapon, :armor)일 수 있습니다.
#     id = 항목의 데이터베이스 ID
#
# 특정 스토리지에서 골드를 추가하거나 제거하려면 스크립트 호출에서 이 명령을 사용하십시오.
#     storage_add_gold(name, amount)
#     storage_remove_gold(name, amount)
#     name = 스토리지의 이름
#     amount = 추가하거나 제거할 금액
#
# 특정 저장소에 있는 금의 양을 확인하려면 스크립트 호출에서 이 명령을 사용하십시오.
#     storage_gold_number(name)
#     name = 스토리지의 이름
#
# 창고에 보관할 수 있는 각 아이템의 최대 수량을 설정하고 싶다면,
# 이 메모 태그를 사용합니다. 메모가 사용되지 않으면 기본 최대값을 사용합니다.
#
# <storagemax: X> were X = the max.
#-------------------------------------------------------------------------------

$imported ||= {}
$imported[:Bravo_Storage] = true

class Game_Party < Game_Unit
  attr_accessor :actors
  attr_accessor :base_inv
  attr_reader   :storage_name
  attr_reader   :medals                 # 획득 한 업적 메달
  attr_reader   :new_medals             # 신규 획득 업적 메달
  attr_accessor :medal_info_count       # 업적 메달 정보 표시 카운트
  attr_accessor :medal_info_opacity     # 업적 메달 정보 표시 불투명도
  attr_accessor :checkpoint_life
  attr_reader   :checkpoint_mapid
  attr_reader   :checkpoint_x
  attr_reader   :checkpoint_y
  attr_reader   :checkpoint_dir
  
  alias bravo_storage_initialize initialize
  def initialize
    bravo_storage_initialize
    #print("115.Game_Party - ");
    #print("파티 관련 값 초기화 진행 \n");
    @checkpoint_life ||= 0
    @storage_gold = {}
    @storage_items = {}
    @storage_weapons = {}
    @storage_armors = {}
    @storage_name = nil
    @base_inv = (Theo::LimInv::DynamicSlot ? 0 : Theo::LimInv::Default_FreeSlot)
    @medals = []
    @new_medals = []
    @medal_info_count = 0
    @medal_info_opacity = 0
    refresh_graphic_equip
  end
  
  def set_checkpoint
    @checkpoint_mapid = $game_map.map_id
    @checkpoint_x = $game_player.x
    @checkpoint_y = $game_player.y
    @checkpoint_dir = $game_player.direction
  end

  def increase_steps
    #print("115.Game_Party - increase_steps \n");
    
    # 메뉴 선택 리셋
    $game_variables[62] = 99 if $game_variables[62] != 99

    # 좌표 갱신
    $game_variables[125] = $game_player.x + $game_player.y + $game_variables[99]

    # 경비병 검문 지역 이전의 좌표만 저장
    if $game_map.region_id($game_player.x,$game_player.y) != 34
      $game_variables[392] = $game_player.x
      $game_variables[393] = $game_player.y
    end
    
    # 지하수로 기믹 좌표 확인
    if $game_map.map_id == 185 and $game_self_switches[[185, 20, "A"]] == false
      for e in $game_map.event_enemies.select{|e| $game_player.obj_size?(e, 3) and (e.x - $game_player.x).abs < 2 and (e.y - $game_player.y).abs < 2 and e.character_name == "!$Other_34_2"}
        case e.direction
          when 2
            if e.pattern == 0
              if (e.x == $game_player.x and e.y - 1 == $game_player.y) or 
                (e.x + 1 == $game_player.x and e.y - 1 == $game_player.y)
                $game_self_switches[[185, 20, "A"]] = true
                return
              end
            elsif e.pattern == 1
              if (e.x == $game_player.x and e.y - 1 == $game_player.y) or 
                (e.x + 1 == $game_player.x and e.y - 1 == $game_player.y) or 
                (e.x - 1 == $game_player.x and e.y - 1 == $game_player.y)
                $game_self_switches[[185, 20, "A"]] = true
                return
              end
            elsif e.pattern == 2
              if (e.x == $game_player.x and e.y + 1 == $game_player.y) or 
                (e.x + 1 == $game_player.x and e.y + 1 == $game_player.y) or 
                (e.x - 1 == $game_player.x and e.y + 1 == $game_player.y)
                $game_self_switches[[185, 20, "A"]] = true
                return
              end
            end
          when 4
            if e.pattern == 2
              if (e.x + 1 == $game_player.x and e.y == $game_player.y) or 
                (e.x == $game_player.x and e.y + 1 == $game_player.y)
                $game_self_switches[[185, 20, "A"]] = true
                return
              end
            end
          when 6
            if e.pattern == 0
              if (e.x - 1 == $game_player.x and e.y == $game_player.y) or 
                (e.x + 1 == $game_player.x and e.y == $game_player.y)
                $game_self_switches[[185, 20, "A"]] = true
                return
              end
            elsif e.pattern == 1
              if (e.x == $game_player.x and e.y + 1 == $game_player.y)
                $game_self_switches[[185, 20, "A"]] = true
                return
              end
            elsif e.pattern == 2
              if (e.x + 1 == $game_player.x and e.y + 1 == $game_player.y) or 
                (e.x - 1 == $game_player.x and e.y + 1 == $game_player.y)
                $game_self_switches[[185, 20, "A"]] = true
                return
              end
            end
          when 8
            if e.pattern == 2
              if (e.x - 1 == $game_player.x and e.y == $game_player.y) or 
                (e.x + 1 == $game_player.x and e.y == $game_player.y) or 
                (e.x == $game_player.x and e.y + 1 == $game_player.y)
                $game_self_switches[[185, 20, "A"]] = true
                return
              end
            end
        end
      end
    end
    
    # 미끄러지는 지역
    if $game_switches[96] != true
      # 이동속도 기본값
      $game_player.event_speed = 4
      # 방어중 이동속도 감소
      $game_player.event_speed -= 2 if Keyboard.press?(Key::Armor[0])
      # 절제, 식탐에 의한 이동속도 조절 실험
      #$game_player.event_speed += 0.5 if $game_actors[7].skill_learn?($data_skills[331])
      #$game_player.event_speed -= 0.5 if $game_actors[7].skill_learn?($data_skills[332])
      # 허기, 갈증, 피로에 의한 이동속도 조절
      $game_player.event_speed -= 0.1 if ($game_actors[7].hunger_rate).to_i >= 80
      $game_player.event_speed -= 0.1 if ($game_actors[7].thirst_rate).to_i >= 80
      $game_player.event_speed -= 0.1 if ($game_actors[7].sleep_rate).to_i >= 80
      # 체온에 따른 이동속도 조절
      $game_player.event_speed -= 0.1 if $game_actors[7].temper.to_i < 40
      $game_player.event_speed -= 0.2 if $game_actors[7].temper.to_i < 30
      $game_player.event_speed -= 0.3 if $game_actors[7].temper.to_i < 20
      # 무게가 많이 오버한 경우 이속 추가 감소
      $game_player.event_speed -= 1 if $game_party.total_inv_size >= $game_party.inv_max * 1.5
      $game_player.event_speed -= 1 if $game_party.total_inv_size >= $game_party.inv_max * 2
      $game_player.event_speed -= 1 if $game_party.total_inv_size >= $game_party.inv_max * 2.5
      $game_player.event_speed -= 2 if $game_party.total_inv_size >= $game_party.inv_max * 3
      # 최종 이동속도 값 적용
      $game_player.event_speed += $game_actors[7].atk_times_add
      #print("115.Game_Party - 이동속도 갱신, %s \n" % [$game_player.move_speed, $game_player.event_speed]);
      $game_player.move_speed = $game_player.event_speed
    end
    
    #members.each do |actor|
    $game_party.battle_members.each do |actor|
      next if actor.dead?
      # 친밀도 감소 확인
      #print("115.Game_Party - 스텝 확인, %s \n" % [actor.name]);
      if actor.id != 7
        $game_actors[actor.id].set_custom_bio[21] = $game_actors[actor.id].set_custom_bio[21].to_i
        if $game_actors[actor.id].set_custom_bio[21] >= 1
          if actor.hunger_rate.to_i >= 50 or actor.thirst_rate.to_i >= 50 or actor.sleep_rate.to_i >= 50
            $game_actors[actor.id].set_custom_bio[21] = $game_actors[actor.id].set_custom_bio[21].to_i - 1
          elsif actor.stress_rate.to_i >= 50
            $game_actors[actor.id].set_custom_bio[21] = $game_actors[actor.id].set_custom_bio[21].to_i - 1
          elsif actor.cold_rate.to_i >= 10
            $game_actors[actor.id].set_custom_bio[21] = $game_actors[actor.id].set_custom_bio[21].to_i - 1
          else
            $game_actors[actor.id].set_custom_bio[21] = $game_actors[actor.id].set_custom_bio[21].to_i + 1
          end
        end
        $game_actors[actor.id].set_custom_bio[21] = 0 if 0 > $game_actors[actor.id].set_custom_bio[21]
      elsif actor.id == 7
        # 임신 여부, 유산
        if $game_actors[7].state?(138) and $game_party.item_number($data_items[68]) != 0 and rand(100) == 100
          $game_variables[167] = 0
          $game_party.gain_item($data_items[69], 1)
          $game_party.lose_item($data_items[68], 1)
        end
        if $game_party.item_number($data_items[69]) >= 1
          actor.stress += 4
        end
        if $game_variables[167] != 0 and actor.state?(156) == false
          actor.add_state(156); gain_medal(11)
        elsif $game_variables[167] == 0 and actor.state?(156) == true
          actor.remove_state(156)
        end
        # 촉수 갑옷인 경우 추가 증가 실험
        if $game_variables[114] == "I"
          actor.hunger += 0.5
          actor.thirst += 0.5
          actor.sleep += 0.1
          actor.sexual += 0.1
          actor.temper += 0.1
        end
      end
      
      # 움직일 경우
      actor.temper += 0.1 # 체온 증가
      actor.drunk -= 0.1 if actor.drunk != nil # 취기 감소
      
      # 월드맵인 경우 추가 증가 실험
      if $game_switches[50] == true
        actor.hunger += 1
        actor.thirst += 0.8
        actor.sleep += 0.4
      else
        # 대시 사용중 추가 증가 실험
        if Input.press?(:A)
          actor.hunger += 0.4
          actor.thirst += 0.3
          actor.sleep += 0.2
          actor.sexual -= 0.2
          actor.temper += 0.1
        else
          actor.hunger += 0.4
          actor.thirst += 0.2
          actor.sleep += 0.1
        end
      end
      
      if actor.hp > actor.mhp * 0.3
        if actor.equips[3] != nil
          at_eq_3 = (1 - (actor.equips[3].durability.to_f / actor.equips[3].max_durability)).round(3)
        else
          at_eq_3 = 0
        end
        if $game_variables[21] >= 1
          # 밤 성욕
          at_eq_exey = (100 - actor.equipment_equip_sexy).to_f * 0.002
          at_eq_exey = (at_eq_exey + (at_eq_exey * at_eq_3)).round(3)
          actor.sexual += at_eq_exey
          actor.sexual += $game_variables[21] * 0.02
          actor.temper -= 0.1
        else
          # 낮에 움직일 경우 기본 체온 증가
          at_eq_exey = (100 - actor.equipment_equip_sexy).to_f * 0.001
          at_eq_exey = (at_eq_exey + (at_eq_exey * at_eq_3)).round(3)
          actor.sexual += at_eq_exey
          actor.sexual += $game_variables[21] * 0.01
          actor.temper += 0.1
        end
      else
        actor.temper -= 0.1
      end
      
      # 신체 강화를 습득한 경우 수치 감소 실험
      @ro_skill_learn = 0.0
      @ro_skill_learn += 0.1 if actor.skill_learn?($data_skills[79])
      @ro_skill_learn += 0.1 if actor.skill_learn?($data_skills[80])
      @ro_skill_learn += 0.1 if actor.skill_learn?($data_skills[81])
      # 집 소유자 버프
      @ro_skill_learn += 0.1 if actor.state?(97)
      if @ro_skill_learn != 0.0
        actor.hunger -= @ro_skill_learn
        actor.thirst -= @ro_skill_learn
        actor.sleep -= @ro_skill_learn
        actor.temper -= @ro_skill_learn if actor.temper > 60
        actor.temper += @ro_skill_learn if 40 > actor.temper
      end
      
      # 스트레스 받는 조건
      if actor.hunger_rate >= 80 or actor.thirst_rate >= 80 or
        actor.sleep_rate >= 80 or actor.temper > 60 or 40 > actor.temper or
        actor.mhp * 0.6 >= actor.hp or actor.state?(29)
        # 젖은 상태인 경우 위생 수치는 감소, 심신 수치 증가
        if actor.state?(24) == true
          actor.hygiene -= 0.5
          actor.stress += 0.1
        end
        # 장비 미착용시 스트레스
        if !actor.skill_learn?($data_skills[420]) # 노출증 스킬
          if actor.equips[0] == nil or actor.equips[0] == 0 or
            actor.equips[3] == nil or actor.equips[3] == 0 or
            actor.equips[4] == nil or actor.equips[4] == 0
            actor.stress += 0.1
          end
        else
          if actor.equips[3] == nil or actor.equips[3] == 0
            actor.stress -= 0.2
          end
        end
      end
      # 정액 범벅인 경우
      if actor.state?(105) == true or actor.state?(104) == true or actor.state?(103) == true or actor.state?(102) == true or actor.state?(101) == true
        actor.hygiene += 0.1
        actor.stress += 0.1
        actor.temper += 0.1
      end
      # 큰 상처, 출혈인 경우
      if actor.state?(136) or actor.state?(13)
        actor.stress += 0.1
        actor.temper -= 1
        actor.drunk -= 1 if actor.drunk != nil # 취기 감소
      end
      # 화상인 경우
      actor.temper += 25 if actor.state?(132)
      # 빙결인 경우
      actor.temper -= 25 if actor.state?(133)
      # 분노인 경우
      actor.temper += 0.3 if actor.state?(12)
        
      # 마력 체온 상태이상
      if actor.state?(174)
        if actor.temper < 50
          actor.temper += ((50 - actor.temper) * 0.5).to_i
        end
        if actor.temper > 50
          actor.temper -= ((actor.temper - 50) * 0.5).to_i
        end
      end
      
      # 체온 낮은 상태면 감기 기운 증가 및 감기 또는 저체온증 적용
      if actor.temper < 30
        actor.cold += 0.1
        actor.drunk -= 1 if actor.drunk != nil # 취기 감소
      elsif actor.temper > 55
        actor.cold -= 0.1
      end
        
      if actor.drunk != nil
        # 취기
        if actor.state?(149) == false and actor.drunk >= 10
          actor.add_state(149)
        elsif actor.state?(149) == true and actor.drunk < 10
          actor.remove_state(149)
        end
        # 만취
        if actor.state?(155) == false and actor.drunk >= 50
          actor.add_state(155)
        elsif actor.state?(155) == true and actor.drunk < 50
          actor.remove_state(155)
        end
      end
      
      # 감기, 저체온증
      if actor.state?(79) == false and actor.cold >= 50
        actor.add_state(79)
      elsif actor.state?(80) == false and actor.cold >= 70
        actor.add_state(80)
      elsif actor.state?(79) == true and actor.cold < 30
        actor.remove_state(79)
      elsif actor.state?(80) == true and actor.cold < 10
        actor.remove_state(80)
      end

      # 욕구 최소, 최대 값 확인 및 갱신
      actor.check_death
    end
  end
  
  def refresh_graphic_equip
    for actor in members
      #print("115.Game_Party - ");
      #print("캐릭터 그래픽 새로고침 적용 \n");
      actor.refresh_graphic_equip
    end
  end
  
  def can_drop?(item)
    return false unless item 
    return false if item.is_a?(RPG::Item) && item.key_item?
    return false unless has_item?(item)
    return true
  end
  
  def drop_item(item, amount=1)
    return unless can_drop?(item)
    #print("115.Game_Party - ");
    #print("아이템 %s 제거 \n" % [item.name]);
    # 새로운 아이템 획득 스위치 true 적용
    $game_switches[58] = true if $game_switches[58] == false
    drop_amount = [amount, item_number(item)].min
    # 아이템 드롭 이벤트 생성하지 않고 바로 제거 한다.
    $game_party.lose_item(item, drop_amount) 
  end
  
  #--------------------------------------------------------------------------
  # ○ 업적 메달 획득 시작
  #--------------------------------------------------------------------------
  def gain_medal(medal_id)
    return if @medals.any? {|medal| medal[0] == medal_id }
    t = Time.now.strftime("%Y/%m/%d %H:%M")
    @medals.push([medal_id, t])
    @new_medals.push([medal_id, t])
  end
  
  #--------------------------------------------------------------------------
  # ○ 업적 메달 정보의 삭제
  #--------------------------------------------------------------------------
  def delete_new_medal
    @new_medals.shift
  end
  
  #--------------------------------------------------------------------------
  # ○ 동료 명단 시작
  #--------------------------------------------------------------------------
  def setup_starting_members
    @actors = $data_system.party_members.clone
    @actors.each do |actor|
      $game_actors[actor].discovered = true
    end
  end
  
  def add_actor(actor_id)
    @actors.push(actor_id) unless @actors.include?(actor_id)
    $game_actors[actor_id].discovered = true
    $game_player.refresh
    $game_map.need_refresh = true
  end
  
  alias falcaopearl_swap_order swap_order
  def swap_order(index1, index2)
    member = $game_party.battle_members
    falcaopearl_swap_order(index1, index2) if !member[index1].dead? and !member[index2].dead?
  end
  
  def set_skill(actor_id, sid, slot)
    actor = $game_actors[actor_id] ; skill = $data_skills[sid]
    return unless actor.skill_learn?(skill)
    case slot
    when Key::Skill[1].to_sym  then actor.assigned_skill  = skill
    when Key::Skill2[1].to_sym then actor.assigned_skill2 = skill
    when Key::Skill3[1].to_sym then actor.assigned_skill3 = skill
    when Key::Skill4[1].to_sym then actor.assigned_skill4 = skill
    when Key::Skill5[1].to_sym then actor.assigned_skill5 = skill
    when Key::Skill6[1].to_sym then actor.assigned_skill6 = skill
    when Key::Skill7[1].to_sym then actor.assigned_skill7 = skill
    when Key::Skill8[1].to_sym then actor.assigned_skill8 = skill
    end
  end
  
  def set_item(actor_id, item_id, slot)
    actor = $game_actors[actor_id] ; item = $data_items[item_id]
    return unless has_item?(item)
    case slot
    when Key::Item[1].to_sym  then actor.assigned_item   = item
    when Key::Item2[1].to_sym then actor.assigned_item2  = item
    end
  end
  
  def set_weapon(actor_id, item_id, slot)
    actor = $game_actors[actor_id] ; item = $data_weapons[item_id]
    return unless has_item?(item)
    actor.change_equip(0,item)
  end
  
  def init_storage(name)
    @storage_gold[name] ||= 0
    @storage_items[name] ||= {}
    @storage_weapons[name] ||= {}
    @storage_armors[name] ||= {}
  end
  
  def inv_max
    return @base_inv unless Theo::LimInv::DynamicSlot
    return members.inject(0) {|total,member| total + member.inv_max} + @base_inv
  end
  
  def inv_maxed?
    inv_max <= total_inv_size
  end
  
  def total_inv_size
    result = all_items.inject(0) {|total,item| total + 
      (item_number(item) * item.inv_size)}
    result += members.inject(0) {|total,member| total + member.equip_size}
    result
  end

  # 적용시 최대 소지량 이상 구매 불가능
  #alias theo_liminv_max_item max_item_number
  #def max_item_number(item)
  #  $BTEST ? theo_liminv_max_item(item) : inv_max_item(item) + item_number(item)
  #end

  # 아이템 최대 소지량 10000개로 수정
  def max_item_number(item)
    return item.item_max
  end
  
  def inv_max_item(item)
    return 9999999 if item.nil? || item.inv_size == 0
    free_slot / item.inv_size
  end

  def free_slot
    inv_max - total_inv_size
  end

  # 적용시 최대 소지량 이상 구매 불가능
  #alias theo_liminv_item_max? item_max?
  #def item_max?(item)
  #  $BTEST ? theo_liminv_item_max?(item) : inv_maxed?
  #end
  
  def near_maxed?
    free_slot.to_f / inv_max <= Theo::LimInv::NearMaxed_Percent/100.0
  end
  
  def item_size(item)
    return 0 unless item
    item.inv_size * item_number(item)
  end
  
  #--------------------------------------------------------------------------
  # 가온데 정렬 추가 수정
  #--------------------------------------------------------------------------
  def alignment
    return 1
  end
  
  def storage_name=(name)
    return if @storage_name == name
    @storage_name = name
    init_storage(name)
  end
  
  def clear_storage(name)
    @storage_gold[name] = 0
    @storage_items[name] = {}
    @storage_weapons[name] = {}
    @storage_armors[name] = {}
  end
  
  def storage_items
    @storage_items[@storage_name].keys.sort.collect {|id| $data_items[id] }
  end
  
  def storage_weapons
    @storage_weapons[@storage_name].keys.sort.collect {|id| $data_weapons[id] }
  end
  
  def storage_armors
    @storage_armors[@storage_name].keys.sort.collect {|id| $data_armors[id] }
  end
  
  def storage_equip_items
    storage_weapons + storage_armors
  end
  
  def storage_all_items
    storage_items + storage_equip_items
  end
  
  def storage_item_container(item_class)
    return @storage_items[@storage_name]   if item_class == RPG::Item
    return @storage_weapons[@storage_name] if item_class == RPG::Weapon
    return @storage_armors[@storage_name]  if item_class == RPG::Armor
    return nil
  end
  
  def storage_gold
    @storage_gold[@storage_name]
  end
  
  def storage_gain_gold(amount)
    @storage_gold[@storage_name] = [[@storage_gold[@storage_name] + amount, 0].max, BRAVO_STORAGE::GOLD_MAX].min
  end
  
  def storage_lose_gold(amount)
    storage_gain_gold(-amount)
  end
  
  #--------------------------------------------------------------------------
  # * 저장소에 있는 최대 항목 수 가져오기
  #--------------------------------------------------------------------------
  def storage_max_item_number(item)
    return item.storage_max
  end
  
  #--------------------------------------------------------------------------
  # * 최대 품목 수를 보유하고 있는지 확인
  #--------------------------------------------------------------------------
  def storage_item_max?(item)
    storage_item_number(item) >= storage_max_item_number(item)
  end
  
  def storage_item_number(item)
    container = storage_item_container(item.class)
    container ? container[item.id] || 0 : 0
  end
  
  def storage_gain_item(item, amount)
    container = storage_item_container(item.class)
    return unless container
    last_number = storage_item_number(item)
    new_number = last_number + amount
    container[item.id] = [[new_number, 0].max, storage_max_item_number(item)].min
    container.delete(item.id) if container[item.id] == 0
  end
  
  def storage_lose_item(item, amount)
    storage_gain_item(item, -amount)
  end
end