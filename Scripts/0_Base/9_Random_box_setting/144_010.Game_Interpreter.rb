# encoding: utf-8
# Name: 010.Game_Interpreter
# Size: 24623
class Game_Interpreter
  def set_pictures
    # 스탠딩 이미지 비율 적용
    $game_variables[83] = 70 if $game_variables[83] == 0
    return $game_troop.screen.pictures if SceneManager.scene_is?(Scene_Battle)
    return $game_map.screen.pictures if SceneManager.scene_is?(Scene_Map)
  end

  def picture_effect(id,type, power = nil,speed = nil,misc = nil)
    pictures = set_pictures
    return if pictures.nil?
    power = set_standard_power(type) if power == nil
    power = 1 if type == 4 and power < 1
    speed = set_standard_speed(type) if speed == nil
    # 의상도 같은 효과
    pictures[id].effect_ex[0] = nil if type == 1
    pictures[id].effect_ex[1] = nil if type == 0
    pictures[id].effect_ex[type] = [power,speed,0]
    if id != 22 and id != 3
      pictures[id].effect_ex[type] = [0,0,0,power * 0.00005,speed, 0,0] if [2,3].include?(type)
    elsif id == 22
      pictures[id].effect_ex[type] = [0,0,0,$game_variables[103] * 0.00005,speed, 0,0] if [2,3].include?(type)
    elsif id == 3
      pictures[id].effect_ex[type] = [0,0,0,$game_variables[103] * 0.00005,10, 0,0] if [2,3].include?(type)
    end
    if id == 3
      pictures[2].effect_ex[type] = pictures[3].effect_ex[type]
      pictures[4].effect_ex[type] = pictures[3].effect_ex[type]
      pictures[5].effect_ex[type] = pictures[3].effect_ex[type]
      pictures[6].effect_ex[type] = pictures[3].effect_ex[type]
      pictures[7].effect_ex[type] = pictures[3].effect_ex[type]
      pictures[8].effect_ex[type] = pictures[3].effect_ex[type]
      pictures[9].effect_ex[type] = pictures[3].effect_ex[type]
      pictures[10].effect_ex[type] = pictures[3].effect_ex[type]
    end
    
    pictures[15].effect_ex[type] = [0,0,0,power * 0.00005,speed, 0,0] if [2,3].include?(type) and id == 14
    
    pictures[id].effect_ex[type] = [255,0,0,255 / power, power,speed,0] if type == 4
    pictures[id].effect_ex[type] = [0,0,power,speed,0] if type == 5
    pictures[id].effect_ex[type] = [true,power * 10,speed * 100] if type == 6
    pictures[id].anime_frames = [true,[],power,0,0,speed,0] if type == 7
    
    pictures[15].anime_frames = [true,[],power,0,0,speed,0] if type == 7 and id == 14
    pictures[15].effect_ex[type] = pictures[id].effect_ex[type] if id == 14
  end

  def set_standard_power(type)
    return 6   if type == 2
    return 30  if type == 3
    return 120 if type == 4
    return 10
  end   
  
  def set_standard_speed(type)
    return 3 if [0,1].include?(type)
    return 0 if [2,3,4].include?(type)
    return 2 if type == 5
    return 0 if type == 7
    return 10
  end  
  
  def picture_position(id,target_id)
    pictures = set_pictures
    return if pictures.nil?
    pictures[id].position = [0,nil,0,0] if [-2,0].include?(pictures[id].position[0])
    if id == 3
      pictures[2].position = pictures[3].position
      pictures[4].position = pictures[3].position
      pictures[5].position = pictures[3].position
      pictures[6].position = pictures[3].position
      pictures[7].position = pictures[3].position
      pictures[8].position = pictures[3].position
    end
    pictures[id].effect_ex.clear
    if id == 3
      pictures[2].effect_ex.clear
      pictures[4].effect_ex.clear
      pictures[5].effect_ex.clear
      pictures[6].effect_ex.clear
      pictures[7].effect_ex.clear
      pictures[8].effect_ex.clear
    end
    target = 0 ; target = $game_player if target_id == -1
    if target_id > 0
    $game_map.events.values.each do |e| target = e if e.id == target_id end
    end
    pictures[id].position[0] = target_id
    pictures[id].position[1] = target
    if id == 3
      pictures[2].position[0] = target_id
      pictures[2].position[1] = target
      pictures[4].position[0] = target_id
      pictures[4].position[1] = target
      pictures[5].position[0] = target_id
      pictures[5].position[1] = target
      pictures[6].position[0] = target_id
      pictures[6].position[1] = target
      pictures[7].position[0] = target_id
      pictures[7].position[1] = target
      pictures[8].position[0] = target_id
      pictures[8].position[1] = target
      pictures[9].position[0] = target_id
      pictures[9].position[1] = target
      pictures[10].position[0] = target_id
      pictures[10].position[1] = target
    end
  end

  def set_picture_z(value)
    $game_system.picture_screen_z = value
  end

  def picture_effects_clear(id)
    pictures = set_pictures
    return if pictures.nil?
    pictures[id].effect_ex.clear ; pictures[id].anime_frames.clear
    if id == 3
      pictures[2].effect_ex.clear ; pictures[3].anime_frames.clear
      pictures[4].effect_ex.clear ; pictures[3].anime_frames.clear
      pictures[5].effect_ex.clear ; pictures[3].anime_frames.clear
      pictures[6].effect_ex.clear ; pictures[3].anime_frames.clear
      pictures[7].effect_ex.clear ; pictures[3].anime_frames.clear
      pictures[8].effect_ex.clear ; pictures[3].anime_frames.clear
      pictures[9].effect_ex.clear ; pictures[3].anime_frames.clear
      pictures[10].effect_ex.clear ; pictures[3].anime_frames.clear
    end
    pictures[id].position = [0,nil,0,0]
    if id == 3
      pictures[2].position = [0,nil,0,0]
      pictures[4].position = [0,nil,0,0]
      pictures[5].position = [0,nil,0,0]
      pictures[6].position = [0,nil,0,0]
      pictures[7].position = [0,nil,0,0]
      pictures[8].position = [0,nil,0,0]
      pictures[9].position = [0,nil,0,0]
      pictures[10].position = [0,nil,0,0]
    end
  end
  
  #--------------------------------------------------------------------------
  # 가온데 정렬 추가 수정
  #--------------------------------------------------------------------------
  def alignment
    return 1
  end
  
  def comment_call
    call_create_lights
    call_change_shade_opacity
    call_change_shade_tone
    call_change_light_opacity
    call_remove_light
  end
  
  def call_create_lights
    $game_map.setup_map_shade(note)
    $game_map.setup_map_lights(:actor, note)
    $game_map.setup_map_lights(:event, note)
    $game_map.setup_map_lights(:vehicle, note)
    $game_map.setup_map_lights(:map, note)
    $game_map.setup_map_lantern(:actor, note)
    $game_map.setup_map_lantern(:event, note)
    $game_map.setup_map_lantern(:vehicle, note)
  end
  
  def call_change_shade_opacity
    return if !$game_map.screen.shade.visible
    note.scan(/<SHADE OPACITY: ((?:\d+,? *){2})>/i) do
      if $1 =~ /(\d+) *,? *(\d+)?/i
        duration = $2 ? $2.to_i : 0
        $game_map.screen.shade.change_opacity($1.to_i, duration)
      end
    end
  end
  
  def call_change_shade_tone
    return if !$game_map.screen.shade.visible
    note.scan(/<SHADE TONE: ((?:\d+,? *){4})>/i) do
      if $1 =~ /(\d+) *, *(\d+) *, *(\d+) *, *(\d+)/i
        $game_map.screen.shade.change_color($1.to_i, $2.to_i, $3.to_i, $4.to_i)
      end
    end
  end
  
  def call_change_light_opacity
    return if !$game_map.screen.shade.visible
    note.scan(/<LIGHT OPACITY (\d+): ((?:\d+,? *){2})>/i) do
      light = $game_map.screen.lights[$1.to_i]
      if light && $2 =~ /(\d+) *,? *(\d+)?/i
        duration = $2 ? $2.to_i : 0
        light.change_opacity($1.to_i, duration)
      end
    end
  end
  
  def call_remove_light
    note.scan(/<REMOVE LIGHT: (\d+)>/i) do 
      $game_map.screen.remove_light.push($1.to_i)
    end
  end
  
  def set_prefix(equip, id)
    equip.prefix_id = id
  end
  
  def set_suffix(equip, id)
    equip.suffix_id = id
  end
  
  def open_storage(name, name_window = true, category = true, gold = true)
    $game_party.storage_name = name
    $game_temp.storage_name_window = name_window
    $game_temp.storage_category = category
    $game_temp.storage_gold = gold
    SceneManager.call(Scene_Storage)
  end
  
  def open_storage2(name, name_window = true, category = true, gold = true)
    $game_party.storage_name = name
    $game_temp.storage_name_window = name_window
    $game_temp.storage_category = category
    $game_temp.storage_gold = gold
    SceneManager.call(Scene_Storage_2)
  end
  
  def clear_storage(name)
    $game_party.clear_storage(name)
  end
  
  def storage_add_item(name, type, id, amount)
    $game_party.storage_name = name
    case type
    when :item, "포션", "음식", "기타"
      item = $data_items[id]
    when :weapon
      item = $data_weapons[id]
    when :armor
      item = $data_armors[id]
    end
    $game_party.storage_gain_item(item, amount)
  end
  
  def storage_remove_item(name, type, id, amount)
    $game_party.storage_name = name
    case type
    when :item, "포션", "음식", "기타"
      item = $data_items[id]
    when :weapon
      item = $data_weapons[id]
    when :armor
      item = $data_armors[id]
    end
    $game_party.storage_lose_item(item, amount)
  end
  
  def storage_item_number(name, type, id)
    $game_party.storage_name = name
    case type
    when :item, "포션", "음식", "기타"
      item = $data_items[id]
    when :weapon
      item = $data_weapons[id]
    when :armor
      item = $data_armors[id]
    end
    $game_party.storage_item_number(item)
  end
  
  def storage_add_gold(name, amount)
    $game_party.storage_name = name
    $game_party.storage_gain_gold(amount)
  end
  
  def storage_remove_gold(name, amount)
    $game_party.storage_name = name
    $game_party.storage_lose_gold(amount)
  end
  
  def storage_gold_number(name)
    $game_party.storage_name = name
    $game_party.storage_gold
  end
  
  def command_319
    actor = $game_actors[@params[0]]
    return if actor.nil?
    if @params[1] == 0 && @params[2] != 0
      item = $data_weapons[@params[2]]
      return unless actor.equip_slots.include?(0)
      slot_id = actor.empty_slot(0)
    elsif @params[2] != 0
      item = $data_armors[@params[2]]
      return unless actor.equip_slots.include?(item.etype_id)
      slot_id = actor.empty_slot(item.etype_id)
    else
      slot_id = @params[1]
    end
    actor.change_equip_by_id(slot_id, @params[2])
  end
  
  alias :th_instance_items_command_111 :command_111
  def command_111
    result = false
    case @params[0]
    when 4
      actor = $game_actors[@params[1]]
      if actor
        case @params[2]
        when 0  # in party
          result = ($game_party.members.include?(actor))
        when 1  # name
          result = (actor.name == @params[3])
        when 2  # Class
          result = (actor.class_id == @params[3])
        when 3  # Skills
          result = (actor.skill_learn?($data_skills[@params[3]]))
        when 4  # Weapons
          result = (actor.instance_weapons_include?(@params[3]))
        when 5  # Armors
          result = (actor.instance_armors_include?(@params[3]))
        when 6  # States
          result = (actor.state?(@params[3]))
        end
      end
    end
    @branch[@indent] = result

    # 통과되지 않았으므로 다른 조건을 확인합시다.
    th_instance_items_command_111 if !result
  end
  
  #--------------------------------------------------------------------------
  # * 액터의 무게 가중치 제한 변경
  #--------------------------------------------------------------------------
  def change_weight_limit(actor_id, amount)
    $game_actors[actor_id].weight_mod += amount
    if $game_actors[actor_id].available_weight < 0
      if $game_party.in_battle
        Graphics.freeze
        SceneManager.scene.info_viewport.visible = false
        SceneManager.scene.log_window.visible = false
        hide_extra_gauges if $imported["YEA-BattleEngine"]
        SceneManager.snapshot_for_background
        $game_party.menu_actor = $game_actors[actor_id]
        old_scene = SceneManager.scene
        SceneManager.call(Scene_Equip)
        SceneManager.scene.main
        SceneManager.force_recall(old_scene)
        show_extra_gauges if $imported["YEA-BattleEngine"]
        SceneManager.scene.info_viewport.visible = true
        SceneManager.scene.log_window.visible = true
        SceneManager.scene.status_window.refresh
        SceneManager.scene.perform_transition
      else
        $game_party.menu_actor = self
        old_scene = SceneManager.scene
        SceneManager.call(Scene_Equip)
        SceneManager.scene.main
        SceneManager.force_recall(old_scene)
        SceneManager.scene.perform_transition
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * 액터 그래픽 변경
  #--------------------------------------------------------------------------
  alias jene_command_322 command_322
  def command_322
    if $game_switches[184] == true
      actor = $game_actors[@params[0]]
      if actor && Jene::CHANGE_DEFAULT_GRAPHIC && 
        ($game_switches[Jene::CHANGE_DEFAULT_GRAPHIC_SWITCH] ||
        Jene::CHANGE_DEFAULT_GRAPHIC_SWITCH == 0)
        actor.set_default_graphic(@params[1], @params[2], @params[3], @params[4])
      end
      jene_command_322
    end
  end
  
  #--------------------------------------------------------------------------
  # * 해당 이벤트 공헌도 지역 확인
  #--------------------------------------------------------------------------
  def event
    $game_map.events[@event_id] || nil
  end
  
  #--------------------------------------------------------------------------
  # ○ 업적 메달 획득
  #--------------------------------------------------------------------------
  def gain_medal(medal_id)
    $game_party.gain_medal(medal_id)
  end
  
  #--------------------------------------------------------------------------
  # * 신규 광원 관련
  #--------------------------------------------------------------------------
  alias :command_108_ve_basic_module :command_108
  def command_108
    command_108_ve_basic_module
    comment_call
  end
  
  def note
    @comments ? @comments.join("\r\n") : ""
  end
  
  # 약초, 독초, 버섯 획득
  Candidate = [
    109,110,111,112,113,114,
    109,110,111,112,113,114,
    109,110,111,112,113,114,
    109,110,111,112,113,114,
    93,94,95,96,97,98,99,100,
    153,154,155,156
    ]
    
  # 광물 획득 : 돌, 철광석, 댄버라이트
  Candidate_s0 = [
    120,120,120,121,121,121,126
    ]
  # 광물 획득 : 돌, 철광석, 댄버라이트, 석탄, 금덩어리, 아라고나이트
  Candidate_s1 = [
    120,120,120,121,121,121,126,
    122,122,123,123,124,
    116,117,118,119
    ]
  # 광물 획득 : 돌, 대톨라이트, 온석면, 암염
  Candidate_s2 = [
    120,120,120,125,125,127,127,
    116,117,118,119,150,150
    ]
  # 광물 획득 : 돌, 은빛 광물, 백연석, 미스릴, 티타늄, 우라늄
  Candidate_s3 = [
    120,120,120,131,131,131,129,129,
    120,120,120,131,131,131,129,129,
    120,120,120,131,131,131,129,129,
    120,120,120,131,131,131,129,129,
    130,473,474,116,117,118,119
    ]
  # 광물 획득 : 돌, 형석, 석탄, 미스릴, 티타늄, 우라늄
  Candidate_s4 = [
    120,120,120,128,128,122,122,
    120,120,120,128,128,122,122,
    120,120,120,128,128,122,122,
    130,473,474,116,117,118,119
    ]
  # 광물 획득 : 광물 및 보석 포함, 티타늄, 우라늄
  Candidate_s10 = [
    120,121,122,123,124,125,126,127,128,129,130,131,
    120,121,122,123,124,125,126,127,128,129,130,131,
    120,121,122,123,124,125,126,127,128,129,130,131,
    120,121,122,123,124,125,126,127,128,129,130,131,
    120,121,122,123,124,125,126,127,128,129,130,131,
    120,121,122,123,124,125,126,127,128,129,130,131,
    120,121,122,123,124,125,126,127,128,129,130,131,
    120,121,122,123,124,125,126,127,128,129,130,131,
    120,121,122,123,124,125,126,127,128,129,130,131,
    138,139,140,141,142,143,144,145,146,473,474,473,474
    ]
    
  # 장작 관련 획득
  Candidate3 = [
    133,134,135,136,133,134,135,136
    ]
    
  # 상자 획득, 마결정 추가
  Candidate4 = [
    1,1,1,1,1,2,2,2,3,3,1,1,1,1,1,5,5,5,5,6,6,6,6,6,15,15,15,19,19,19,
    24,24,24,24,24,24,24,24,24,24,36,36,36,36,36,37,37,37,37,38,38,38,
    48,48,48,48,48,48,48,48,48,48,50,50,50,50,50,50,50,50,19,19,19,19,
    60,60,60,60,61,61,61,61,61,61,61,61,61,62,62,62,62,122,122,122,268,
    75,75,76,99,100,93,94,95,96,97,98,99,100,134,135,136,268,268,268,268,
    93,94,95,96,97,98,99,100,93,94,95,96,97,98,99,100,93,94,95,96,97,98,
    109,110,111,112,113,114,109,110,111,112,113,114,109,110,111,112,113,
    120,121,122,122,122,120,121,122,122,122,120,121,122,122,122,120,121,
    123,123,131,124,114,109,110,111,112,113,114,268,268,268,268,221,133,
    133,134,135,136,133,134,135,136,133,134,135,136,133,134,135,136,261,
    138,139,140,141,142,143,144,145,146,148,221,221,260,261,260,261,260,
    153,154,155,156,153,154,155,156,153,154,155,156,153,154,155,156,261,
    159,160,159,160,159,160,159,160,159,160,159,160,260,261,260,261,260,
    205,205,205,205,205,215,215,215,215,215,215,215,221,221,221,221,226,
    224,225,226,224,225,226,224,225,226,224,225,473,474,
    448,449,450,451,452,453,454
    ]
    
  # 상자 보석함 : 티타늄, 우라늄 추가, 마결정 추가
  Candidate5 = [
    138,139,140,141,142,143,144,145,146,148,473,474,150,
    448,449,450,451,452,453,454
    ]
    
  # 빈병
  Candidate6 = [
    1,2,8,11,17,18,19,20,23,25,26,28,29,30,31,32,33,104,105,106,107,108,109,
    110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,
    258
    ]
    
  # 훔치기
  Candidate_thievery1 = [
    159,160,161,162,159,160,161,162,159,160,161,162,
    182,183,184,185,150
    ]
  Candidate_thievery2 = [
    174,175,176
    ]
  Candidate_thievery3 = [
    190,191,192,193,194,195,196,197,
    190,203,205,190,203,205
    ]
  Candidate_thievery4 = [
    212,213,214,215,216,217,218,219,220,221,222
    ]
  Candidate_thievery5 = [
    224,225,226,227,228,229,60,62,24,25,26,27,28,29,1,2,3,5,6,7,
    60,24,1,2,5,6,60,24,1,2,5,6,60,24,1,2,5,6
    ]
    
  # 무기 랜덤
  Candidate_w1 = [
    1,2,7,8,13,14,19,20,25,26,31,32,37,38,43,44,49,50
    ]
  Candidate_w2 = [
    1,2,7,8,13,14,19,20,25,26,31,32,37,38,43,44,49,50,
    3,4,9,10,15,16,21,22,27,28,33,34,39,40,45,46,51,52
    ]
  Candidate_w3 = [
    1,2,7,8,13,14,19,20,25,26,31,32,37,38,43,44,49,50,
    3,4,9,10,15,16,21,22,27,28,33,34,39,40,45,46,51,52,
    5,6,11,12,17,18,23,24,29,30,35,36,41,42,47,48,53,54
    ]
    
  # 방어구 랜덤
  Candidate_a1 = [
    1,2,3,4,5,6,7,8,9,11,26,21,41,42,43,46,47,48,127,128,129,130,131,175
    ]
  Candidate_a2 = [
    1,2,3,4,5,6,7,8,9,11,26,21,41,42,43,46,47,48,127,128,129,130,131,175,
    10,13,14,15,16,17,18,27,28,36,37,38,44,49,59,78,89,115,121,132,133,135,
    167,176,177,183
    ]
  Candidate_a3 = [
    1,2,3,4,5,6,7,8,9,11,26,21,41,42,43,46,47,48,127,128,129,130,131,175,
    10,13,14,15,16,17,18,27,28,36,37,38,44,49,59,78,89,115,121,132,133,135,
    167,176,177,183,
    19,20,22,23,24,25,29,31,32,33,34,39,50,64,87,114,116,118,120,124,125,138,
    143,163,164,165,168,178,179,180
    ]
    
  # 장신구 랜덤
  Candidate_j1 = [
    68,69,70,75,79,80,85,86,94,95,96,98,100
    ]
  Candidate_j2 = [
    68,69,70,75,79,80,85,86,94,95,96,98,100,
    51,54,55,63,74,76,81,82,93
    ]
  Candidate_j3 = [
    68,69,70,75,79,80,85,86,94,95,96,98,100,
    51,54,55,63,74,76,81,82,93,
    57,60,61,65,66,67,78,83,84,88,89,90,91,97
    ]
    
  # 포션 랜덤
  Candidate_p1 = [
    1,2,3,5,6,7,11,12,13,14,15,16,17,1,2,5,6
    ]
    
  def gain_random
    str = @params[0]
    item_candidate6 = Candidate.clone
    @params[3] = rand(3) + 1
    @params[0] = item_candidate6[rand(item_candidate6.size)]
    @params[1] = 0; @params[2] = 0; command_126; @params[0] = str
  end
  
  def gain_random2
    str = @params[0]
    item_candidate6 = Candidate_s0.clone if $game_variables[152] == 0
    item_candidate6 = Candidate_s1.clone if $game_variables[152] == 1
    item_candidate6 = Candidate_s2.clone if $game_variables[152] == 2
    item_candidate6 = Candidate_s3.clone if $game_variables[152] == 3
    item_candidate6 = Candidate_s4.clone if $game_variables[152] == 4
    item_candidate6 = Candidate_s10.clone if $game_variables[152] == 10
    @params[3] = rand(3) + 1
    @params[0] = item_candidate6[rand(item_candidate6.size)]
    @params[1] = 0; @params[2] = 0; command_126; @params[0] = str
  end
  
  def gain_random3
    str = @params[0]
    item_candidate6 = Candidate3.clone
    @params[3] = rand(3) + 1
    @params[0] = item_candidate6[rand(item_candidate6.size)]
    @params[1] = 0; @params[2] = 0; command_126; @params[0] = str
  end
  
  def gain_random4
    str = @params[0]
    item_candidate6 = Candidate4.clone
    @params[3] = rand(3) + 1
    @params[0] = item_candidate6[rand(item_candidate6.size)]
    @params[1] = 0; @params[2] = 0; command_126; @params[0] = str
  end
  
  def gain_random5
    str = @params[0]
    item_candidate6 = Candidate5.clone
    @params[3] = rand(3) + 1
    @params[0] = item_candidate6[rand(item_candidate6.size)]
    @params[1] = 0; @params[2] = 0; command_126; @params[0] = str
  end
  
  def gain_random6
    str = @params[0]
    item_candidate6 = Candidate6.clone
    @params[3] = rand(3) + 1
    @params[0] = item_candidate6[rand(item_candidate6.size)]
    @params[1] = 0; @params[2] = 0; command_126; @params[0] = str
  end
  
  def gain_t1
    str = @params[0]
    item_candidate6 = Candidate_thievery1.clone
    @params[3] = rand(3) + 1
    @params[0] = item_candidate6[rand(item_candidate6.size)]
    @params[1] = 0; @params[2] = 0; command_126; @params[0] = str
  end
  
  def gain_t2
    str = @params[0]
    item_candidate6 = Candidate_thievery2.clone
    @params[3] = rand(3) + 1
    @params[0] = item_candidate6[rand(item_candidate6.size)]
    @params[1] = 0; @params[2] = 0; command_126; @params[0] = str
  end
  
  def gain_t3
    str = @params[0]
    item_candidate6 = Candidate_thievery3.clone
    @params[3] = rand(3) + 1
    @params[0] = item_candidate6[rand(item_candidate6.size)]
    @params[1] = 0; @params[2] = 0; command_126; @params[0] = str
  end
  
  def gain_t4
    str = @params[0]
    item_candidate6 = Candidate_thievery4.clone
    @params[3] = rand(3) + 1
    @params[0] = item_candidate6[rand(item_candidate6.size)]
    @params[1] = 0; @params[2] = 0; command_126; @params[0] = str
  end
  
  def gain_t5
    str = @params[0]
    item_candidate6 = Candidate_thievery5.clone
    @params[3] = rand(3) + 1
    @params[0] = item_candidate6[rand(item_candidate6.size)]
    @params[1] = 0; @params[2] = 0; command_126; @params[0] = str
  end
  
  def gain_w1
    str = @params[0]
    item_candidate6 = Candidate_w1.clone
    @params[3] = 1
    @params[0] = item_candidate6[rand(item_candidate6.size)]
    @params[1] = 0; @params[2] = 0; command_127; @params[0] = str
  end
  
  def gain_w2
    str = @params[0]
    item_candidate6 = Candidate_w2.clone
    @params[3] = 1
    @params[0] = item_candidate6[rand(item_candidate6.size)]
    @params[1] = 0; @params[2] = 0; command_127; @params[0] = str
  end
  
  def gain_w3
    str = @params[0]
    item_candidate6 = Candidate_w3.clone
    @params[3] = 1
    @params[0] = item_candidate6[rand(item_candidate6.size)]
    @params[1] = 0; @params[2] = 0; command_127; @params[0] = str
  end
  
  def gain_a1
    str = @params[0]
    item_candidate6 = Candidate_a1.clone
    @params[3] = 1
    @params[0] = item_candidate6[rand(item_candidate6.size)]
    @params[1] = 0; @params[2] = 0; command_128; @params[0] = str
  end
  
  def gain_a2
    str = @params[0]
    item_candidate6 = Candidate_a2.clone
    @params[3] = 1
    @params[0] = item_candidate6[rand(item_candidate6.size)]
    @params[1] = 0; @params[2] = 0; command_128; @params[0] = str
  end
  
  def gain_a3
    str = @params[0]
    item_candidate6 = Candidate_a3.clone
    @params[3] = 1
    @params[0] = item_candidate6[rand(item_candidate6.size)]
    @params[1] = 0; @params[2] = 0; command_128; @params[0] = str
  end
  
  def gain_j1
    str = @params[0]
    item_candidate6 = Candidate_j1.clone
    @params[3] = 1
    @params[0] = item_candidate6[rand(item_candidate6.size)]
    @params[1] = 0; @params[2] = 0; command_128; @params[0] = str
  end
  
  def gain_j2
    str = @params[0]
    item_candidate6 = Candidate_j2.clone
    @params[3] = 1
    @params[0] = item_candidate6[rand(item_candidate6.size)]
    @params[1] = 0; @params[2] = 0; command_128; @params[0] = str
  end
  
  def gain_j3
    str = @params[0]
    item_candidate6 = Candidate_j3.clone
    @params[3] = 1
    @params[0] = item_candidate6[rand(item_candidate6.size)]
    @params[1] = 0; @params[2] = 0; command_128; @params[0] = str
  end
  
  def gain_p1
    str = @params[0]
    item_candidate6 = Candidate_p1.clone
    @params[3] = 1
    @params[0] = item_candidate6[rand(item_candidate6.size)]
    @params[1] = 0; @params[2] = 0; command_126; @params[0] = str
  end
end