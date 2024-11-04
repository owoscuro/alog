# encoding: utf-8
# Name: 118.Game_Map
# Size: 103760
#==============================================================================
# spawn_event_location(x, y, event_id)
# spawn_event_location(x, y, event_id, map_id)
#
# spawn_event_region(region_id, event_id)
# spawn_event_region(region_id, event_id, map_id)
#==============================================================================

class Game_Map
  attr_reader :max_width, :max_height
  
  attr_reader :region_tile_mapping
  attr_reader :has_fog, :fog_a_name, :fog_a_move, :fog_a_opacity
  attr_reader :fog_a_z, :fog_a_color, :fog_b_name, :fog_b_move
  attr_reader :fog_b_opacity, :fog_b_z, :fog_b_color, :fog_c_name
  attr_reader :fog_c_move, :fog_c_opacity, :fog_c_z, :fog_c_color
  
  attr_accessor :map
  attr_accessor :event_enemies, :enemies, :events_withtags
  
  attr_accessor :effectlist
  attr_accessor :r_events
  
  attr_accessor :char_effects2
  attr_accessor :light_source
  attr_accessor :shadow_options
  attr_accessor :shad_id_ro

  #-----------------------------------------------------------------------------
  # * 이벤트 랜덤 배치 시작
  #-----------------------------------------------------------------------------
  alias :th_random_event_positions_setup_events :setup_events
  def setup_events
    setup_region_tile_mapping
    th_random_event_positions_setup_events
  end

  alias :setup_ve_light_effects :setup
  def setup(map_id)
    # 몬스터 랜덤 배치 변수 대입
    $game_variables[31] = rand(9) + 1
    
    #print("118.Game_Map - 몬스터 생성, %s \n" % [$game_variables[31]]);

    @event_enemies.clear
    @enemies.clear
    @events_withtags.clear

    # 캐릭터 효과 관련, 원본 위치는 아래
    reset_char_effects2;    do_all_chareffects
    setup_lights_effect
    
    # 지형 효과 관련
    @effectlist = []
    @r_events = {}
    
    setup_ve_light_effects(map_id)
    
    @eid = 0
    
    if $game_temp.loadingg != nil
      @event_enemies.each do |event|
        event.resetdeadpose
      end
      $game_temp.loadingg = nil
    end
    
    # 해당 맵 유지 시간 초기화
    $game_switches[191] = false
    $game_variables[32] = 0
    
    # 히든 몬스터 등장 적용
    $game_variables[86] = 99
    
    # 자동 공격 취소
    $game_switches[197] = false
    $game_switches[196] = false

    # 포그 효과 관련
    @map.get_fog_info;      @has_fog = @map.can_fog
    setup_fog_a;            setup_fog_b;              setup_fog_c

    @events.values.each do |e|
      next if e.list.nil?
      if e.list[0].code == 108
        if e.list[0].parameters[0] =~ /<speed:(.*)>/
          e.event_speed = $1.to_f
        end
        if e.list[0].parameters[0] =~ /<nextframe:(.*)>/
          e.next_frame = $1.to_f
        end
      end
    end
    
    SceneManager.scene.spriteset.refresh_effects if SceneManager.scene_is?(Scene_Map)

    # 천둥, 번개 화면 스플래쉬 리셋
    color = Color.new(0,0,0,0)
    $game_map.screen.start_flash(color,0)
        
    clear_picture_position rescue nil
  end
  
  def setup_region_tile_mapping
    #print("118.Game_Map - 맵 번호를 대입한다. \n");
    @region_tile_mapping = {}
    (0..63).each {|i| @region_tile_mapping[i] = []}
    for x in 0..data.xsize
      for y in 0..data.ysize
        # 태그 값으로 대입 실험
        @region_tile_mapping[terrain_tag(x, y)] << [x,y]
        @region_tile_mapping[region_id(x, y)] << [x,y] if 8 > $game_map.terrain_tag(x, y)
      end
    end
  end
  
  alias falcaopearl_enemycontrol_ini initialize
  def initialize
    set_max_screen
    
    @event_enemies = []
    @enemies = []
    @events_withtags = []
    
    @shad_id_ro = []
    @light_source = []
    @shadow_options = [80,10,false]
    @char_effects2 = [false,false,false,false]
    
    falcaopearl_enemycontrol_ini
  end
  
  def set_max_screen
    @max_width  = (Graphics.width / 32).truncate
    @max_height = (Graphics.height / 32).truncate
  end

  def region_event(dx, dy, event_id, map_id)
    map_id = @map_id if map_id == 0
    map = $data_spawn_map
    event = generated_region_event(map, event_id)

    @eid += 1
    @effectlist.push(@eid)
    @effectlist.shift if @effectlist.count > Region_Effects::MAX_EFFECTS

    @r_events[@eid] = Game_Event.new(@map_id, event)
    @r_events[@eid].moveto(dx, dy)
    SceneManager.scene.spriteset.refresh_region_effects

    @eid = 0 if @eid >= Region_Effects::MAX_EFFECTS
  end
  
  def generated_region_event(map, event_id)
    for key in map.events
      event = key[1]
      next if event.nil?
      return event if event.id == event_id
    end
    return nil
  end
  
  alias galv_region_effects_gm_refresh refresh
  def refresh
    @r_events.each_value {|event| event.refresh }
    galv_region_effects_gm_refresh
  end
  
  alias galv_region_effects_gm_update_events update_events
  def update_events
    @r_events.each_value {|event| event.update }
    galv_region_effects_gm_update_events
  end
  
  alias falcaopearl_damage_floor damage_floor?
  def damage_floor?(x, y)
    return if $game_player.hookshoting[1]
    falcaopearl_damage_floor(x, y)
  end

  def clear_picture_position
    #print("118.Game_Map - clear_picture_position \n");
    pictures = $game_troop.screen.pictures if SceneManager.scene_is?(Scene_Battle)
    pictures = $game_map.screen.pictures if SceneManager.scene_is?(Scene_Map)
    return if pictures == nil
    pictures.each {|p| 
    p.position = [-1000,nil,0,0] if p.position[0] > 0 or p.position[1] == nil}    
  end

  #-----------------------------------------------------------------------------
  # 주변 이벤트 검색
  #-----------------------------------------------------------------------------
  def rose_event_sc
    #print("118.Game_Map - rose_event_sc \n");
    $game_variables[275] = 0
    $game_variables[276] = 0
    $game_map.events.values.each do |event|
      if event != nil
        if $game_player.obj_size?(event, 4)
          if event.name =~ /<enemy: /i
            $game_variables[275] += 1 if !event.battler.object
          elsif event.name =~ /<enemy: 28>/i or event.name =~ /여관/i or event.name =~ /창문/i or event.name =~ /문/i
          elsif event.character_name != "!$A_Warp" and event.character_name != "$Sign_9" and
              event.character_name != "!Torchlight_0" and event.character_name != "!Torchlight_1" and 
              event.character_name != "!Torchlight_2" and event.character_name != "!Torchlight_3" and 
              event.character_name != "!Torchlight_4" and event.character_name != "!$Torchlight4" and
              event.character_name != "!$Map_Window_1" and event.character_name != "!$Map_Window_2" and
              event.character_name != "!$Map_Window_3" and event.character_name != "!$Map_Window_4" and
              event.character_name != "!$Map_Window_5" and event.character_name != "!Trap_1" and 
              event.character_name != "!Door_1" and event.character_name != "!Door_2" and 
              event.character_name != "!Door_3" and event.character_name != "!Trap_2" and
              event.character_name != "!$Quest" and event.character_name != "Sign3_Quest_Scroll" and
              event.character_name != "!$Other_27" and event.character_name != "!$Other_27_2" and
              event.character_name != "!Trap_1_2" and event.character_name != "!Trap_2_2" and
              event.character_name != ""
            # 위 오브젝트가 아니라면 npc가 있는 것으로 간주한다.
            $game_variables[276] += 1
          end
        end
      else
        $game_variables[276] += 1
      end
    end
  end
  
  def rose_event_sc_8
    #print("118.Game_Map - rose_event_sc_8 \n");
    $game_variables[275] = 0
    $game_variables[276] = 0
    $game_map.events.values.each do |event|
      if event != nil
        if $game_player.obj_size?(event, 8)
          if event.name =~ /<enemy: /i
            $game_variables[275] += 1 if !event.battler.object
          elsif event.name =~ /<enemy: 28>/i or event.name =~ /여관/i or event.name =~ /창문/i or event.name =~ /문/i
          elsif event.character_name != "!$A_Warp" and event.character_name != "$Sign_9" and
              event.character_name != "!Torchlight_0" and event.character_name != "!Torchlight_1" and 
              event.character_name != "!Torchlight_2" and event.character_name != "!Torchlight_3" and 
              event.character_name != "!Torchlight_4" and event.character_name != "!$Torchlight4" and
              event.character_name != "!$Map_Window_1" and event.character_name != "!$Map_Window_2" and
              event.character_name != "!$Map_Window_3" and event.character_name != "!$Map_Window_4" and
              event.character_name != "!$Map_Window_5" and event.character_name != "!Trap_1" and 
              event.character_name != "!Door_1" and event.character_name != "!Door_2" and 
              event.character_name != "!Door_3" and event.character_name != "!Trap_2" and
              event.character_name != "!$Quest" and event.character_name != "Sign3_Quest_Scroll" and
              event.character_name != "!$Other_27" and event.character_name != "!$Other_27_2" and
              event.character_name != "!Trap_1_2" and event.character_name != "!Trap_2_2" and
              event.character_name != ""
            # 위 오브젝트가 아니라면 npc가 있는 것으로 간주한다.
            $game_variables[276] += 1
          end
        end
      else
        $game_variables[276] += 1
      end
    end
  end
  
  # 경비병 검문 진행
  def rose_event_guard
    $game_map.events.values.each do |event|
      if event != nil
        if $game_player.obj_size?(event, 7)
          if event.character_name == "$People_535"
            print("118.Game_Map - %s 실행 \n" % [event.name]);
            $game_map.events[event.id].start
          end
        end
      end
    end
  end
  # 셀프 스위치
  #$game_self_switches[[$game_map.map_id, event.id, "A"]] = false
        
  # 스텟 초기화
  def rose_steat_reset
    #print("118.Game_Map - rose_steat_reset \n");
    at = $game_variables[126].to_i
    $game_actors[at].clear_distribution_values
    $game_actors[at].restore_distribution_values
  end
  
  # 스킬 초기화
  def rose_skill_reset
    #print("118.Game_Map - rose_skill_reset \n");
    at = $game_variables[126].to_i
    if at != 7
      con_list = IMIR_SkillPoint::Conditions[1]
    else
      con_list = IMIR_SkillPoint::Conditions[at]
    end
    for i in 1..$data_skills.size-1
      next if !$game_actors[at].skill_learn?($data_skills[i])
      sk_it_id = $data_skills[i]
      if 100 != con_list[sk_it_id.id][0] and con_list[sk_it_id.id][0] != nil
        $game_actors[at].forget_skill(i)
        $game_actors[at].skill_point += con_list[sk_it_id.id][0]
        $game_actors[at].skill_point2 -= con_list[sk_it_id.id][0]
        $game_actors[at].assigned_skill = nil
        $game_actors[at].assigned_skill2 = nil
        $game_actors[at].assigned_skill3 = nil
        $game_actors[at].assigned_skill4 = nil
        $game_actors[at].assigned_skill5 = nil
        $game_actors[at].assigned_skill6 = nil
        $game_actors[at].assigned_skill7 = nil
        $game_actors[at].assigned_skill8 = nil
      end
      break if i >= $data_skills.size-1
    end
  end
  
  # 용병 등급 조절
  def rose_mercenary(index = 0)
    @ro_mer = 0
    $game_variables[90] = ""
    $game_variables[91] = 0
    $game_party.members.each do |actor|
      if index == 1
        if $game_actors[actor.id].nickname == "용병 : 코퍼"
          @ro_mer += 1
          if $game_actors[actor.id].repute >= 100
            if $game_variables[90] == ""
              $game_variables[90] += "#{$game_actors[actor.id].name}"
            else
              $game_variables[90] += ", " + "#{$game_actors[actor.id].name}"
            end
            $game_variables[91] = 1
            $game_actors[actor.id].nickname = "용병 : 아이언"
            if actor.id == 7
              $game_party.lose_item($data_items[311], 10)
              $game_party.gain_item($data_items[312], 1)
              $game_party.gain_medal(33)
            end
          end
        end
      elsif index == 2
        if $game_actors[actor.id].nickname == "용병 : 아이언"
          @ro_mer += 1
          if $game_actors[actor.id].repute >= 300
            if $game_variables[90] == ""
              $game_variables[90] += "#{$game_actors[actor.id].name}"
            else
              $game_variables[90] += ", " + "#{$game_actors[actor.id].name}"
            end
            $game_variables[91] = 1
            $game_actors[actor.id].nickname = "용병 : 실버"
            if actor.id == 7
              $game_party.lose_item($data_items[312], 10)
              $game_party.gain_item($data_items[313], 1)
              $game_party.gain_medal(34)
            end
          end
        end
      end
    end
    if @ro_mer == 0
      $game_variables[91] = 2
    end
  end
  
=begin
  # 패치로 인해 동료 캐릭터 리셋
  def rose_NPC_reset
    # 팔로워 초기화
    @base_equip_slots = YEA::EQUIP::DEFAULT_BASE_SLOTS.clone
    (1...$data_actors.size).each do |actor_id|
      if actor_id != 7 and $game_actors[actor_id].name != "" and $game_actors[actor_id].name != nil
        if $game_party.members.include?($game_actors[actor_id])
          @base_equip_slots.size.times do |i|
            $game_actors[actor_id].change_equip_by_id(i, 0)
          end
          a = $game_actors[actor_id].level
          $game_actors[actor_id].setup(actor_id)
          $game_actors[actor_id].set_custom_bio[22] = 24
          $game_actors[actor_id].set_custom_bio[24] = 1
          $game_actors[actor_id].change_level(a, false)
        else
          $game_actors[actor_id].setup(actor_id)
          $game_actors[actor_id].set_custom_bio[22] = 0
          $game_actors[actor_id].set_custom_bio[24] = 0
        end
        
        # 랜덤으로 성격을 지정한다.
        if $game_actors[actor_id].set_custom_bio[29] == nil or $game_actors[actor_id].set_custom_bio[29] == 0
          $game_actors[actor_id].set_custom_bio[29] = rand(19) + 1
          print("118.Game_Map - ");
          print("%s의 성격 입력 %s, %s \n" % [$game_actors[actor_id].name, actor_id, $game_actors[actor_id].set_custom_bio[29]]);
          case $game_actors[actor_id].set_custom_bio[29]
            when 1; $game_actors[actor_id].learn_skill(533)
            when 2; $game_actors[actor_id].learn_skill(534)
            when 3; $game_actors[actor_id].learn_skill(535)
            when 4; $game_actors[actor_id].learn_skill(536)
            when 5; $game_actors[actor_id].learn_skill(537)
            when 6; $game_actors[actor_id].learn_skill(538)
            when 7; $game_actors[actor_id].learn_skill(539)
            when 8; $game_actors[actor_id].learn_skill(540)
            when 9; $game_actors[actor_id].learn_skill(541)
            when 10; $game_actors[actor_id].learn_skill(542)
            when 11; $game_actors[actor_id].learn_skill(543)
            when 12; $game_actors[actor_id].learn_skill(544)
            when 13; $game_actors[actor_id].learn_skill(545)
            when 14; $game_actors[actor_id].learn_skill(546)
            when 15; $game_actors[actor_id].learn_skill(547)
            when 16; $game_actors[actor_id].learn_skill(548)
            when 17; $game_actors[actor_id].learn_skill(549)
            when 18; $game_actors[actor_id].learn_skill(550)
            when 19; $game_actors[actor_id].learn_skill(551)
            when 20; $game_actors[actor_id].learn_skill(532)
          end
        end
      end
    end
  end
=end

  # 해당 캐릭터 커스텀 바이오 값 확인
  def rose_NPC_reset_2
    # 추가된 액터
    $game_actors[22].setup(22) if $game_actors[22].nickname == ""
    $game_actors[12].setup(12) if $game_actors[12].nickname == ""
    $game_actors[13].setup(13) if $game_actors[13].nickname == ""
    $game_actors[14].setup(14) if $game_actors[14].nickname == ""
    
    (1...$data_actors.size).each do |actor_id|
      if actor_id != 7 and $game_actors[actor_id].nickname != "" and $game_actors[actor_id].nickname != nil
        for i in 1..30
          if $game_actors[actor_id].set_custom_bio[i] == nil or $game_actors[actor_id].set_custom_bio[i] == ""
            print("118.Game_Map - ");
            print("%s의 커스텀 바이오 입력 %s \n" % [$game_actors[actor_id].name, i]);
            $game_actors[actor_id].set_custom_bio[i] = 0
          end
        end
        # 랜덤으로 성격을 지정한다.
        if $game_actors[actor_id].set_custom_bio[29] == nil or $game_actors[actor_id].set_custom_bio[29] == 0
          $game_actors[actor_id].set_custom_bio[29] = rand(19) + 1
          print("118.Game_Map - ");
          print("%s의 성격 입력 %s, %s \n" % [$game_actors[actor_id].name, actor_id, $game_actors[actor_id].set_custom_bio[29]]);
          case $game_actors[actor_id].set_custom_bio[29]
            when 1; $game_actors[actor_id].learn_skill(533)
            when 2; $game_actors[actor_id].learn_skill(534)
            when 3; $game_actors[actor_id].learn_skill(535)
            when 4; $game_actors[actor_id].learn_skill(536)
            when 5; $game_actors[actor_id].learn_skill(537)
            when 6; $game_actors[actor_id].learn_skill(538)
            when 7; $game_actors[actor_id].learn_skill(539)
            when 8; $game_actors[actor_id].learn_skill(540)
            when 9; $game_actors[actor_id].learn_skill(541)
            when 10; $game_actors[actor_id].learn_skill(542)
            when 11; $game_actors[actor_id].learn_skill(543)
            when 12; $game_actors[actor_id].learn_skill(544)
            when 13; $game_actors[actor_id].learn_skill(545)
            when 14; $game_actors[actor_id].learn_skill(546)
            when 15; $game_actors[actor_id].learn_skill(547)
            when 16; $game_actors[actor_id].learn_skill(548)
            when 17; $game_actors[actor_id].learn_skill(549)
            when 18; $game_actors[actor_id].learn_skill(550)
            when 19; $game_actors[actor_id].learn_skill(551)
            when 20; $game_actors[actor_id].learn_skill(532)
          end
        end
      end
    end
  end
  
  # 동료 거주지에 대기중
  def rose_NPC_spen
    (1...$data_actors.size).each do |actor_id|
      if $game_actors[actor_id].name != "" and $game_actors[actor_id].name != nil
        if actor_id != 7 and $game_actors[actor_id].set_custom_bio[24] == 4
          $game_map.spawn_event_region(23, actor_id, 190)
        end
      end
    end
  end
  
  # 죽은 자의 소생 남자
  def rose_fm_resurr
    @data = []
    $game_variables[160] = 0
    (1...$data_actors.size).each do |actor_id|
      if $game_actors[actor_id].name != "" and $game_actors[actor_id].name != nil and $game_actors[actor_id].nickname != "딸" and $game_actors[actor_id].nickname != "아들"
        if actor_id != 7 and $game_actors[actor_id].set_custom_bio[1] == "인간, 남성" and $game_actors[actor_id].set_custom_bio[24] == 2
          @data << actor_id
        end
      end
    end
    if @data.empty?
      $game_party.gain_item($data_items[297], 1)
    else
      $game_variables[160] = @data[rand(@data.size)]
      $game_actors[$game_variables[160]].set_custom_bio[22] = 0
      $game_actors[$game_variables[160]].set_custom_bio[24] = 0
      $game_temp.reserve_common_event(265)
      $game_temp.reserve_common_event(267)
    end
  end
  
  # 죽은 자의 소생 여자
  def rose_ff_resurr
    @data = []
    $game_variables[160] = 0
    (1...$data_actors.size).each do |actor_id|
      if $game_actors[actor_id].name != "" and $game_actors[actor_id].name != nil and $game_actors[actor_id].nickname != "딸" and $game_actors[actor_id].nickname != "아들"
        if actor_id != 7 and $game_actors[actor_id].set_custom_bio[1] != "인간, 남성" and $game_actors[actor_id].set_custom_bio[24] == 2
          @data << actor_id
        end
      end
    end
    if @data.empty?
      $game_party.gain_item($data_items[297], 1)
    else
      $game_variables[160] = @data[rand(@data.size)]
      $game_actors[$game_variables[160]].set_custom_bio[22] = 0
      $game_actors[$game_variables[160]].set_custom_bio[24] = 0
      $game_temp.reserve_common_event(265)
      $game_temp.reserve_common_event(267)
    end
  end
  
  # 해당 등급 몇명인지 확인
  def rose_mercenary_ok(index = "")
    $game_party.members.each do |actor|
      #print("118.Game_Map - %s, %s \n" % [actor.nickname, index]);
      if actor.nickname =~ /#{index}/i
      #if $game_actors[actor.id].nickname =~ /"#{index}"/i
        $game_variables[91] += 1
      end
    end
  end

  # 특정 상태이상 몇명인지 확인
  def rose_at_state(index = 0)
    $game_variables[275] = 0
    $game_party.members.each do |actor|
      if $game_actors[actor.id].state?(index)
        $game_variables[275] += 1
      end
    end
  end
  
  def rose_NPC_children_test
    $game_party.members.each do |actor|
      if $game_actors[actor.id].nickname == "딸"
        # 해당 자녀의 친부와 npc 이름이 같은지 확인
        $game_actors[actor.id].set_custom_bio[25] = $game_variables[29]
      end
      if $game_actors[actor.id].nickname == "아들"
        # 해당 자녀의 친부와 npc 이름이 같은지 확인
        $game_actors[actor.id].set_custom_bio[25] = $game_variables[29]
      end
    end
  end
  
  # 해당 캐릭터 커스텀 바이오 값 확인
  def rose_NPC_children
    $game_variables[263] = 0
    $game_variables[264] = 0
    $game_variables[141] = 0
    $game_party.members.each do |actor|
      if $game_actors[actor.id].nickname == "딸"
        # 해당 자녀의 친부와 npc 이름이 같은지 확인
        if $game_actors[actor.id].set_custom_bio[25] == $game_variables[29]
          $game_variables[263] = actor.id
          if $game_actors[actor.id].set_custom_bio[7].to_i >= 1
            $game_variables[141] = $game_actors[actor.id].set_custom_bio[7].to_i
          end
        end
      end
      if $game_actors[actor.id].nickname == "아들"
        # 해당 자녀의 친부와 npc 이름이 같은지 확인
        if $game_actors[actor.id].set_custom_bio[25] == $game_variables[29]
          $game_variables[264] = actor.id
          if $game_actors[actor.id].set_custom_bio[7].to_i >= 1
            $game_variables[141] = $game_actors[actor.id].set_custom_bio[7].to_i
          end
        end
      end
    end
  end
  
  def rose_NPC_stend(pic_name = "")
    #print("118.Game_Map - %s \n" % [pic_name]);
    # 캐릭터에 대한 정보가 없을 경우 캐릭터 정보를 갱신한다.
    pic_name_ok = nil
    pic_name_ok = Cache.picture(pic_name) rescue nil
    if pic_name == ""
      $game_map.screen.pictures[22].show($game_variables[88],0,$game_variables[291],$game_variables[293],70,70,255,0)
    elsif pic_name_ok == nil
      $game_actors[$game_variables[126]].setup($game_variables[126])
      pic_name_ok = $game_actors[$game_variables[126]].set_custom_bio[23]
      $game_variables[88] = pic_name_ok
      $game_map.screen.pictures[22].show($game_variables[88],0,$game_variables[291],$game_variables[293],70,70,255,0)
    else
      pic_name_ok = $game_actors[$game_variables[126]].set_custom_bio[23]
      $game_variables[88] = pic_name_ok
      $game_map.screen.pictures[22].show($game_variables[88],0,$game_variables[291],$game_variables[293],70,70,255,0)
    end
  end
  
  def rose_Actor7_H_log
    # 배열로 변경
    if $game_actors[7].set_custom_bio[20] == 0 or $game_actors[7].set_custom_bio[20] == nil or $game_actors[7].set_custom_bio[20] == "?"
      $game_actors[7].set_custom_bio[20] = []
    end
    # 20명이 넘은 경우 첫번째를 제거한다.
    if $game_actors[7].set_custom_bio[20].length >= 20
      $game_actors[7].set_custom_bio[20].delete_at(0)
    end
    # 상대방 이름을 배열에 추가
    $game_actors[7].set_custom_bio[20].push($game_variables[29])
    # 중복값 제거
    $game_actors[7].set_custom_bio[20].uniq
    print("%s \n" % [$game_actors[7].set_custom_bio[20]])
  end
  
  def rose_delivery(index)
    # 배열로 변경
    if $game_actors[7].set_custom_bio[20] == 0 or $game_actors[7].set_custom_bio[20] == nil or $game_actors[7].set_custom_bio[20] == "?"
      $game_actors[7].set_custom_bio[20] = []
    end
    # 만약에 사망했었던 상태라면 초기화를 한다.
    if $game_actors[index].set_custom_bio[24] == 2
      $game_actors[index].setup(index)
    end
    $game_party.add_actor(index)
    # 해당 자녀를 고용한 상태로 변경
    $game_actors[index].set_custom_bio[24] = 1
    # 자녀의 이름을 대입한다.
    $game_variables[29] = $game_actors[index].name.to_s
    # 출산한 맵 이름을 대입한다.
    temp_map_name = $game_map.display_name.split(" (")
    $game_actors[index].set_birthplace = temp_map_name[0].to_s
    
    # 친부, 친모를 대입한다.
    if !$game_actors[7].set_custom_bio[20].empty?
      $game_actors[7].set_custom_bio[20].shuffle
      $game_actors[index].set_custom_bio[25] = $game_actors[7].set_custom_bio[20][0]
    end
    if $game_actors[index].set_custom_bio[25] == 0 or $game_actors[index].set_custom_bio[25] == nil
      $game_actors[index].set_custom_bio[25] = "불명"
    end
    $game_actors[index].set_custom_bio[26] = $game_actors[7].name
  end
  
  #-----------------------------------------------------------------------------
  # 에르니 H 씬 이미지
  #-----------------------------------------------------------------------------
  def rose_H_Actor7_room
    #print("118.Game_Map - rose_H_Actor7_room \n");
    # 해상도 그림 비율
    if Graphics.height == 704
      he_ro_x = 33;         he_ro_y = 79
      he_ro_zoom_x = 1.152; he_ro_zoom_y = 1.298
    elsif Graphics.height == 640
      he_ro_x = 105;        he_ro_y = 48
      he_ro_zoom_x = 1.27;  he_ro_zoom_y = 1.178
    else
      he_ro_x = 0;          he_ro_y = 0
      he_ro_zoom_x = 1.0;   he_ro_zoom_y = 1.0
    end
    # 임신 여부
    if $game_party.item_number($data_items[68]) != 0
      ro_baby = "B_"
    else
      ro_baby = ""
    end
    # 여관방 뒤치기
    if $game_variables[58] == 1
      if $game_variables[69] <= 2
        $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'back_room_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      else
        $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'back_room_end_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      end
    elsif $game_variables[58] == 2
      if $game_variables[69] <= 2
        $game_map.screen.pictures[22].show("H_Actor7/H_Actor7_back_room2_",0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      else
        $game_map.screen.pictures[22].show("H_Actor7/H_Actor7_back_room2_end_",0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      end
    end
  end
  
  #-----------------------------------------------------------------------------
  # 에르니 화면 사정 이팩트
  #-----------------------------------------------------------------------------
  def rose_Screen_semen
    # 기본 그림 비율
    #he_ro_x = 0;            he_ro_y = 0
    #he_ro_zoom_x = 1.0;     he_ro_zoom_y = 1.0
    # 해상도 그림 비율
    #if Graphics.height == 544
    #  he_ro_x = 0;          he_ro_y = 0
    #  he_ro_zoom_x = 1.0;   he_ro_zoom_y = 1.0
    #elsif Graphics.height == 704
    #  he_ro_x = 33;         he_ro_y = 79
    #  he_ro_zoom_x = 1.152; he_ro_zoom_y = 1.298
    #elsif Graphics.height == 640
    #  he_ro_x = 105;        he_ro_y = 48
    #  he_ro_zoom_x = 1.27;  he_ro_zoom_y = 1.178
    #end
    #$game_map.screen.pictures[25].show('H_Actor7/Screen_semen_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,55,0)
  end
  
  #-----------------------------------------------------------------------------
  # 에르니 배틀퍽 진입씬 이미지
  #-----------------------------------------------------------------------------
  def rose_H_Actor7_take_off
    #print("118.Game_Map - rose_H_Actor7_take_off \n");
    # 해상도 그림 비율
    if Graphics.height == 704
      he_ro_x = 33;         he_ro_y = 79
      he_ro_zoom_x = 1.152; he_ro_zoom_y = 1.298
    elsif Graphics.height == 640
      he_ro_x = 105;        he_ro_y = 48
      he_ro_zoom_x = 1.27;  he_ro_zoom_y = 1.178
    else
      he_ro_x = 0;          he_ro_y = 0
      he_ro_zoom_x = 1.0;   he_ro_zoom_y = 1.0
    end
    $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_take_off_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
  end
  
  #-----------------------------------------------------------------------------
  # 에르니 착유, 젖짜기씬 이미지
  #-----------------------------------------------------------------------------
  def rose_H_Actor7_Weave
    #print("118.Game_Map - rose_H_Actor7_Weave \n");
    # 해상도 그림 비율
    if Graphics.height == 704
      he_ro_x = 33;         he_ro_y = 79
      he_ro_zoom_x = 1.152; he_ro_zoom_y = 1.298
    elsif Graphics.height == 640
      he_ro_x = 105;        he_ro_y = 48
      he_ro_zoom_x = 1.27;  he_ro_zoom_y = 1.178
    else
      he_ro_x = 0;          he_ro_y = 0
      he_ro_zoom_x = 1.0;   he_ro_zoom_y = 1.0
    end
    # 임신 여부
    if $game_party.item_number($data_items[68]) != 0
      ro_baby = "B_"
    else
      ro_baby = ""
    end
    if $game_variables[56] == 0
      $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'Weave_self_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
    else
      $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'Weave_A' + $game_variables[56].to_s + '_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
    end
  end
  
  #-----------------------------------------------------------------------------
  # 에르니 샤워씬 이미지
  #-----------------------------------------------------------------------------
  def rose_H_Actor7_Shw
    #print("118.Game_Map - rose_H_Actor7_Shw \n");
    # 해상도 그림 비율
    if Graphics.height == 704
      he_ro_x = 33;         he_ro_y = 79
      he_ro_zoom_x = 1.152; he_ro_zoom_y = 1.298
    elsif Graphics.height == 640
      he_ro_x = 105;        he_ro_y = 48
      he_ro_zoom_x = 1.27;  he_ro_zoom_y = 1.178
    else
      he_ro_x = 0;            he_ro_y = 0
      he_ro_zoom_x = 1.0;     he_ro_zoom_y = 1.0
    end
    # 임신 여부
    if $game_party.item_number($data_items[68]) != 0
      ro_baby = "B_"
    else
      ro_baby = ""
    end
    if $game_variables[62] == 1
      $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'shower_A_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
    else
      $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'shower_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
    end
  end
  
  #-----------------------------------------------------------------------------
  # 에르니 출산씬 이미지
  #-----------------------------------------------------------------------------
  def rose_H_Actor7_Del
    #print("118.Game_Map - rose_H_Actor7_Del \n");
    # 해상도 그림 비율
    if Graphics.height == 704
      he_ro_x = 33;         he_ro_y = 79
      he_ro_zoom_x = 1.152; he_ro_zoom_y = 1.298
    elsif Graphics.height == 640
      he_ro_x = 105;        he_ro_y = 48
      he_ro_zoom_x = 1.27;  he_ro_zoom_y = 1.178
    else
      he_ro_x = 0;          he_ro_y = 0
      he_ro_zoom_x = 1.0;   he_ro_zoom_y = 1.0
    end
    $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_delivery_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
  end
  
  #-----------------------------------------------------------------------------
  # 에르니 H 씬 이미지
  #-----------------------------------------------------------------------------
  def rose_H_Actor7
    #print("118.Game_Map - rose_H_Actor7 \n");
    # 해상도 그림 비율
    if Graphics.height == 704
      he_ro_x = 33;         he_ro_y = 79
      he_ro_zoom_x = 1.152; he_ro_zoom_y = 1.298
    elsif Graphics.height == 640
      he_ro_x = 105;        he_ro_y = 48
      he_ro_zoom_x = 1.27;  he_ro_zoom_y = 1.178
    else
      he_ro_x = 0;          he_ro_y = 0
      he_ro_zoom_x = 1.0;   he_ro_zoom_y = 1.0
    end
        
    # 임신 여부
    if $game_party.item_number($data_items[68]) != 0
      ro_baby = "B_"
    else
      ro_baby = ""
    end
    # 자위
    if $game_variables[58] == 1
      if $game_variables[69] == 1
        $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'large_reel_A_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      elsif $game_variables[69] == 2 or $game_variables[69] == 4 or $game_variables[69] == 5
        $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'large_reel_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      elsif $game_variables[69] == 3
        $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'large_reel_end_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      end
      # 모유 효과 적용
      if $game_variables[327] >= 10 and $game_variables[69] == 3
        $game_variables[328] += 2 # 최대 모유 보유량
        $game_variables[327] -= 2 # 모유 소비
        $game_map.screen.pictures[23].show('H_Actor7/H_Actor7_B_large_reel_Mk_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      elsif $game_variables[327] >= 30
        $game_variables[328] += 4 # 최대 모유 보유량
        $game_variables[327] -= 4 # 모유 소비
        $game_map.screen.pictures[23].show('H_Actor7/H_Actor7_B_large_reel_Mk_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      end
    # 자위 2
    elsif $game_variables[58] == 2
      if $game_variables[69] == 1
        $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_large_down_A_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      elsif $game_variables[69] == 2 or $game_variables[69] == 4 or $game_variables[69] == 5
        $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_large_down_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      elsif $game_variables[69] == 3
        $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_large_down_end_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      end
    # 뒤치기 2
    elsif $game_variables[58] == 3
      if $game_variables[69] == 1
        $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_kick_back2_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      elsif $game_variables[69] == 2 or $game_variables[69] == 4 or $game_variables[69] == 5
        $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_kick_back2_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      elsif $game_variables[69] == 3
        $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_kick_back2_end_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      end
    # 뒤치기 3
    elsif $game_variables[58] == 4
      if $game_variables[69] == 1
        $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_kick_back3_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      elsif $game_variables[69] == 2 or $game_variables[69] == 4 or $game_variables[69] == 5
        $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_kick_back3_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      elsif $game_variables[69] == 3
        $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_kick_back3_end_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      end
    # 아래 1
    elsif $game_variables[58] == 5
      if $game_variables[69] == 1
        $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'under_A_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      elsif $game_variables[69] == 2 or $game_variables[69] == 4 or $game_variables[69] == 5
        $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'under_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      elsif $game_variables[69] == 3
        $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'under_end_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      end
      # 모유 효과 적용
      if $game_variables[327] >= 10 and $game_variables[69] == 3
        $game_variables[328] += 2 # 최대 모유 보유량
        $game_variables[327] -= 2 # 모유 소비
        $game_map.screen.pictures[23].show('H_Actor7/H_Actor7_B_under_Mk_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      elsif $game_variables[327] >= 30
        $game_variables[328] += 4 # 최대 모유 보유량
        $game_variables[327] -= 4 # 모유 소비
        $game_map.screen.pictures[23].show('H_Actor7/H_Actor7_B_under_Mk_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      end
    # 아래 2
    elsif $game_variables[58] == 6
      if $game_variables[69] == 1
        $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'under2_A_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      elsif $game_variables[69] == 2 or $game_variables[69] == 4 or $game_variables[69] == 5
        $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'under2_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      elsif $game_variables[69] == 3
        $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'under2_end_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      end
      # 모유 효과 적용
      if $game_variables[327] >= 10 and $game_variables[69] == 3
        $game_variables[328] += 2 # 최대 모유 보유량
        $game_variables[327] -= 2 # 모유 소비
        $game_map.screen.pictures[23].show('H_Actor7/H_Actor7_B_under2_Mk_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      elsif $game_variables[327] >= 30
        $game_variables[328] += 4 # 최대 모유 보유량
        $game_variables[327] -= 4 # 모유 소비
        $game_map.screen.pictures[23].show('H_Actor7/H_Actor7_B_under2_Mk_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      end
    # 아래 3
    elsif $game_variables[58] == 7
      if $game_variables[69] == 1
        $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'under3_A_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      elsif $game_variables[69] == 2 or $game_variables[69] == 4 or $game_variables[69] == 5
        $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'under3_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      elsif $game_variables[69] == 3
        $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'under3_end_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      end
      # 모유 효과 적용
      if $game_variables[327] >= 10 and $game_variables[69] == 3
        $game_variables[328] += 2 # 최대 모유 보유량
        $game_variables[327] -= 2 # 모유 소비
        $game_map.screen.pictures[23].show('H_Actor7/H_Actor7_B_under3_Mk_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      elsif $game_variables[327] >= 30
        $game_variables[328] += 4 # 최대 모유 보유량
        $game_variables[327] -= 4 # 모유 소비
        $game_map.screen.pictures[23].show('H_Actor7/H_Actor7_B_under3_Mk_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      end
    # 뒤치기 1
    elsif $game_variables[58] == 8
      if $game_variables[69] == 1
        $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'kick_back_A_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      elsif $game_variables[69] == 2 or $game_variables[69] == 4 or $game_variables[69] == 5
        $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'kick_back_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      elsif $game_variables[69] == 3
        $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'kick_back_end_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      end
      # 모유 효과 적용
      if $game_variables[327] >= 10 and $game_variables[69] == 3
        $game_variables[328] += 2 # 최대 모유 보유량
        $game_variables[327] -= 2 # 모유 소비
        $game_map.screen.pictures[23].show('H_Actor7/H_Actor7_B_kick_back_Mk_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      elsif $game_variables[327] >= 30
        $game_variables[328] += 4 # 최대 모유 보유량
        $game_variables[327] -= 4 # 모유 소비
        $game_map.screen.pictures[23].show('H_Actor7/H_Actor7_B_kick_back_Mk_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      end
    # 뒤치기 4
    elsif $game_variables[58] == 9
      if $game_variables[69] == 1
        $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'kick_back4_A_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      elsif $game_variables[69] == 2 or $game_variables[69] == 4 or $game_variables[69] == 5
        $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'kick_back4_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      elsif $game_variables[69] == 3
        $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'kick_back4_end_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      end
    # 뒤치기 5
    elsif $game_variables[58] == 10
      if $game_variables[69] == 1
        $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'kick_back5_A_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      elsif $game_variables[69] == 2 or $game_variables[69] == 4 or $game_variables[69] == 5
        $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'kick_back5_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      elsif $game_variables[69] == 3
        $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'kick_back5_end_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      end
      # 모유 효과 적용
      if $game_variables[327] >= 10 and $game_variables[69] == 3
        $game_variables[328] += 2 # 최대 모유 보유량
        $game_variables[327] -= 2 # 모유 소비
        $game_map.screen.pictures[23].show('H_Actor7/H_Actor7_B_kick_back5_Mk_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      elsif $game_variables[327] >= 30
        $game_variables[328] += 4 # 최대 모유 보유량
        $game_variables[327] -= 4 # 모유 소비
        $game_map.screen.pictures[23].show('H_Actor7/H_Actor7_B_kick_back5_Mk_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      end
    # 기승위 1
    elsif $game_variables[58] == 11
      if $game_variables[69] == 1
        $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'ride_A_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      elsif $game_variables[69] == 2 or $game_variables[69] == 4 or $game_variables[69] == 5
        $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'ride_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      elsif $game_variables[69] == 3
        $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'ride_end_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      end
      # 모유 효과 적용
      if $game_variables[327] >= 10 and $game_variables[69] == 3
        $game_variables[328] += 2 # 최대 모유 보유량
        $game_variables[327] -= 2 # 모유 소비
        $game_map.screen.pictures[23].show('H_Actor7/H_Actor7_B_ride_Mk_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      elsif $game_variables[327] >= 30
        $game_variables[328] += 4 # 최대 모유 보유량
        $game_variables[327] -= 4 # 모유 소비
        $game_map.screen.pictures[23].show('H_Actor7/H_Actor7_B_ride_Mk_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      end
    # 정상 1
    elsif $game_variables[58] == 12
      if $game_variables[69] == 1
        $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'down_A_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      elsif $game_variables[69] == 2 or $game_variables[69] == 4 or $game_variables[69] == 5
        $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'down_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      elsif $game_variables[69] == 3
        $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'down_end_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      end
      # 모유 효과 적용
      if $game_variables[327] >= 10 and $game_variables[69] == 3
        $game_variables[328] += 2 # 최대 모유 보유량
        $game_variables[327] -= 2 # 모유 소비
        $game_map.screen.pictures[23].show('H_Actor7/H_Actor7_B_down_Mk_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      elsif $game_variables[327] >= 30
        $game_variables[328] += 4 # 최대 모유 보유량
        $game_variables[327] -= 4 # 모유 소비
        $game_map.screen.pictures[23].show('H_Actor7/H_Actor7_B_down_Mk_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
      end
    end
  end
  
  #-----------------------------------------------------------------------------
  # 에르니 펠라 이미지
  #-----------------------------------------------------------------------------
  def rose_H_Actor7_fella
    # 해상도 그림 비율
    if Graphics.height == 704
      he_ro_x = 33;         he_ro_y = 79
      he_ro_zoom_x = 1.152; he_ro_zoom_y = 1.298
    elsif Graphics.height == 640
      he_ro_x = 105;        he_ro_y = 48
      he_ro_zoom_x = 1.27;  he_ro_zoom_y = 1.178
    else
      he_ro_x = 0;          he_ro_y = 0
      he_ro_zoom_x = 1.0;   he_ro_zoom_y = 1.0
    end
    
    if $game_variables[58] == 1
      $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_fella_t1_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
    elsif $game_variables[58] == 2
      $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_fella_t2_',0,he_ro_x,he_ro_y,100*he_ro_zoom_x,100*he_ro_zoom_y,255,0)
    end
  end
  
  # 펠라 종료
  def rose_H_Actor7_fella_real_end
    # 해상도 그림 비율
    if Graphics.height == 704
      he_ro_x = 0;              he_ro_y = 79
      he_ro_zoom_x = 1.152;     he_ro_zoom_y = 1.297
    elsif Graphics.height == 640
      he_ro_x = 0;              he_ro_y = 48
      he_ro_zoom_x = 1.27;      he_ro_zoom_y = 1.177
    else
      he_ro_x = 0;              he_ro_y = 0
      he_ro_zoom_x = 1.0;       he_ro_zoom_y = 1.0
    end
    
    #if $game_variables[58] == 1
      $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_fella_real_end_',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
    #end
  end
  
  def rose_H_Actor7_large_reel_end
    #print("118.Game_Map - rose_H_Actor7_large_reel_end \n");
    # 해상도 그림 비율
    if Graphics.height == 704
      he_ro_x = 0;              he_ro_y = 79
      he_ro_zoom_x = 1.152;     he_ro_zoom_y = 1.297
    elsif Graphics.height == 640
      he_ro_x = 0;              he_ro_y = 48
      he_ro_zoom_x = 1.27;      he_ro_zoom_y = 1.177
    else
      he_ro_x = 0;              he_ro_y = 0
      he_ro_zoom_x = 1.0;       he_ro_zoom_y = 1.0
    end
    
    # 모유 이미지가 있으면 제거
    $game_map.screen.pictures[23].erase if !$game_map.screen.pictures[23].nil?
    
    # 임신 여부
    if $game_party.item_number($data_items[68]) != 0
      ro_baby = "B_"
    else
      ro_baby = ""
    end
    case rand(5)
      when 0
        if $game_variables[67] >= 28
          case $game_variables[57]
            when 0; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'large_reel_real_end_A',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
            when 1; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'large_reel_real_end_AB',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
            when 2; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'large_reel_real_end_AC',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
          end
        elsif $game_variables[67] >= 8
          case $game_variables[57]
            when 0; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'large_reel_real_end',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
            when 1; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'large_reel_real_end_B',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
            when 2; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'large_reel_real_end_C',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
          end
        else
          case $game_variables[57]
            when 0; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'large_reel_real_end_Z',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
            when 1; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'large_reel_real_end_ZB',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
            when 2; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'large_reel_real_end_ZC',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
          end
        end
      when 1
        if $game_variables[67] >= 28
          case $game_variables[57]
            when 0; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_large_reel_real_end2_A',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
            when 1; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_large_reel_real_end2_AB',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
            when 2; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_large_reel_real_end2_AC',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
          end
        elsif $game_variables[67] >= 8
          case $game_variables[57]
            when 0; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_large_reel_real_end2',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
            when 1; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_large_reel_real_end2_B',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
            when 2; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_large_reel_real_end2_C',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
          end
         else
          case $game_variables[57]
            when 0; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_large_reel_real_end2_Z',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
            when 1; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_large_reel_real_end2_ZB',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
            when 2; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_large_reel_real_end2_ZC',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
          end
        end
      when 2
        if $game_variables[67] >= 28
          case $game_variables[57]
            when 0; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'large_reel_real_end3_A',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
            when 1; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'large_reel_real_end3_AB',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
            when 2; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'large_reel_real_end3_AC',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
          end
        elsif $game_variables[67] >= 8
          case $game_variables[57]
            when 0; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'large_reel_real_end3',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
            when 1; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'large_reel_real_end3_B',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
            when 2; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'large_reel_real_end3_C',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
          end
        else
          case $game_variables[57]
            when 0; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'large_reel_real_end3_Z',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
            when 1; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'large_reel_real_end3_ZB',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
            when 2; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'large_reel_real_end3_ZC',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
          end
        end
      when 3
        if $game_variables[67] >= 28
          case $game_variables[57]
            when 0; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'large_reel_real_end4_A',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
            when 1; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'large_reel_real_end4_AB',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
            when 2; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'large_reel_real_end4_AC',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
          end
        elsif $game_variables[67] >= 8
          case $game_variables[57]
            when 0; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'large_reel_real_end4',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
            when 1; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'large_reel_real_end4_B',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
            when 2; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'large_reel_real_end4_C',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
          end
        else
          case $game_variables[57]
            when 0; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'large_reel_real_end4_Z',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
            when 1; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'large_reel_real_end4_ZB',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
            when 2; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'large_reel_real_end4_ZC',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
          end
        end
      else
        if $game_variables[67] >= 28
          case $game_variables[57]
            when 0; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'large_reel_real_end5_A',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
            when 1; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'large_reel_real_end5_AB',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
            when 2; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'large_reel_real_end5_AC',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
          end
        elsif $game_variables[67] >= 8
          case $game_variables[57]
            when 0; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'large_reel_real_end5',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
            when 1; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'large_reel_real_end5_B',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
            when 2; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'large_reel_real_end5_C',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
          end
        else
          case $game_variables[57]
            when 0; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'large_reel_real_end5_Z',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
            when 1; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'large_reel_real_end5_ZB',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
            when 2; $game_map.screen.pictures[22].show('H_Actor7/H_Actor7_' + ro_baby + 'large_reel_real_end5_ZC',0,-25+he_ro_x,he_ro_y,110*he_ro_zoom_x,110*he_ro_zoom_y,255,0)
          end
        end
    end
  end
  
  #-----------------------------------------------------------------------------
  # 에르니 이미지 리셋
  #-----------------------------------------------------------------------------
  def rose_reset_picture
    #print("118.Game_Map - rose_reset_picture \n");
    $game_map.screen.pictures[2].erase if !$game_map.screen.pictures[2].nil?
    $game_map.screen.pictures[3].erase if !$game_map.screen.pictures[3].nil?
    $game_map.screen.pictures[4].erase if !$game_map.screen.pictures[4].nil?
    $game_map.screen.pictures[5].erase if !$game_map.screen.pictures[5].nil?
    $game_map.screen.pictures[6].erase if !$game_map.screen.pictures[6].nil?
    $game_map.screen.pictures[7].erase if !$game_map.screen.pictures[7].nil?
    $game_map.screen.pictures[8].erase if !$game_map.screen.pictures[8].nil?
    $game_map.screen.pictures[9].erase if !$game_map.screen.pictures[9].nil?
    $game_map.screen.pictures[10].erase if !$game_map.screen.pictures[10].nil?
    $game_variables[115] = $game_variables[84]
    $game_variables[116] = $game_variables[87]
  end
  
  def rose_reset_picture_0
    #print("118.Game_Map - rose_reset_picture_0 \n");
    $game_variables[115] = $game_variables[84]
    $game_variables[116] = $game_variables[87]
  end
  
  #-----------------------------------------------------------------------------
  # 에르니 공격시, 피격시 이미지 떨림
  #-----------------------------------------------------------------------------
  def rose_atk_def_picture
    return if $game_switches[200] != true
    #print("118.Game_Map - rose_atk_def_picture \n");
    # 높이 리셋
    $game_variables[116] = $game_variables[87]
    
    $game_variables[110] = rand(50) - 25
    if 0 >= $game_variables[110]
      if $game_variables[112] >= $game_variables[110]
        $game_variables[115] += $game_variables[112]
      else
        $game_variables[115] += $game_variables[110]
      end
    else
      if $game_variables[110] >= $game_variables[111]
        $game_variables[115] += $game_variables[111]
      else
        $game_variables[115] += $game_variables[110]
      end
    end
    $game_variables[110] = rand(50) - 25
    if 0 >= $game_variables[110]
      if $game_variables[112] >= $game_variables[110]
        $game_variables[116] += $game_variables[112]
      else
        $game_variables[116] += $game_variables[110]
      end
    else
      if $game_variables[110] >= $game_variables[111]
        $game_variables[116] += $game_variables[111]
      else
        $game_variables[116] += $game_variables[110]
      end
    end
  end
  
  #-----------------------------------------------------------------------------
  # 에르니 죽음 화면 이펙트
  #-----------------------------------------------------------------------------
  def rose_dead_picture
    #print("118.Game_Map - rose_dead_picture \n");
    # 기본 그림 비율
    $game_map.screen.pictures[49].erase if !$game_map.screen.pictures[49].nil?
    $game_map.screen.pictures[49].show("HUD_State_Dead",0,-5,-5,105,105,0,0)
  end
  
  #-----------------------------------------------------------------------------
  # 에르니 눈 깜빡임
  #-----------------------------------------------------------------------------
  def rose_picture_ice
    return if $game_switches[55] == false
    #print("118.Game_Map - 눈 깜빡임 진행 \n");
    ro_ice = "99"
    ro_ice_img = ""
    # 에르니 이미지 표시 확인
    $game_switches[200] == true ? ro_ice_op = 255 : ro_ice_op = 0
    
    if $game_switches[46] != true and $game_switches[47] != true
    
      if $game_map.screen.pictures[4].name == "face/Battler_Actor7_Face_1(HP20)"
        ro_ice = "(HP20)"
      elsif $game_map.screen.pictures[4].name == "face/Battler_Actor7_Face_1(HP40)"
        ro_ice = "(HP40)"
      elsif $game_map.screen.pictures[4].name == "face/Battler_Actor7_Face_1(HP100)"
        ro_ice = "(HP100)"
      elsif $game_map.screen.pictures[4].name == "face/Battler_Actor7_Face_1(HP100)_2"
        ro_ice = "(HP100)_2"
      elsif $game_map.screen.pictures[4].name == "face/Battler_Actor7_Face_1(HP100)_3"
        ro_ice = "(HP100)_3"
      elsif $game_map.screen.pictures[4].name == "face/Battler_Actor7_Face_1(HP100)_4"
        ro_ice = "(HP100)_4"
      elsif $game_map.screen.pictures[4].name == "face/Battler_Actor7_Face_1(HP100)_5"
        ro_ice = "(HP100)_5"
      elsif $game_map.screen.pictures[4].name == "face/Battler_Actor7_Face_1(HP100)_6"
        ro_ice = "(HP100)_6"
      end
    
      if ro_ice != "99"
        ro_ice_img = 'Battler_Actor7_Face_1' + ro_ice + '(2)'
        $game_map.screen.pictures[4].show("face/"+ro_ice_img,0,$game_variables[115],$game_variables[116],$game_variables[83],$game_variables[83],255,0)
        wait(2)
        ro_ice_img = 'Battler_Actor7_Face_1' + ro_ice + '(3)'
        $game_map.screen.pictures[4].show("face/"+ro_ice_img,0,$game_variables[115],$game_variables[116],$game_variables[83],$game_variables[83],255,0)
        wait(2)
        ro_ice_img = 'Battler_Actor7_Face_1' + ro_ice + '(4)'
        $game_map.screen.pictures[4].show("face/"+ro_ice_img,0,$game_variables[115],$game_variables[116],$game_variables[83],$game_variables[83],255,0)
        wait(4)
        ro_ice_img = 'Battler_Actor7_Face_1' + ro_ice + '(3)'
        $game_map.screen.pictures[4].show("face/"+ro_ice_img,0,$game_variables[115],$game_variables[116],$game_variables[83],$game_variables[83],255,0)
        wait(1)
        ro_ice_img = 'Battler_Actor7_Face_1' + ro_ice + '(2)'
        $game_map.screen.pictures[4].show("face/"+ro_ice_img,0,$game_variables[115],$game_variables[116],$game_variables[83],$game_variables[83],255,0)
        wait(1)
        ro_ice_img = 'Battler_Actor7_Face_1' + ro_ice
        $game_map.screen.pictures[4].show("face/"+ro_ice_img,0,$game_variables[115],$game_variables[116],$game_variables[83],$game_variables[83],255,0)
        # 깜빡임 수치 0 리셋
        $game_variables[268] = 0
      end
    end
  end
  
  def wait(duration)
    #print("118.Game_Map - wait \n");
    duration.times { Fiber.yield }
  end
  
  #-----------------------------------------------------------------------------
  # 에르니 숨결 이미지
  #-----------------------------------------------------------------------------
  def rose_picture_face
    #print("118.Game_Map - 숨결 이미지 진행 \n");
    ro_baby = ""
    # 기본 포즈, 공격 포즈, 피격 포즈
    ro_posy_type = "1("
    ro_posy_type = "3(" if $game_switches[46] == true and SceneManager.scene_is?(Scene_Map)
    ro_posy_type = "2(" if $game_switches[47] == true and SceneManager.scene_is?(Scene_Map)
    # 임신 여부
    if $game_party.item_number($data_items[68]) != 0
      ro_baby = "B_"
    end

    case $game_variables[117]
    when 6
      # 에르니 이미지 표시 확인
      $game_switches[200] == true ? ro_ice_op = 100 : ro_ice_op = 0
      $game_map.screen.pictures[8].show("face/Battler_Actor7_Face_B",0,$game_variables[115],$game_variables[116],$game_variables[83],$game_variables[83],ro_ice_op,0) if ro_posy_type == "1("
      $game_map.screen.pictures[8].show("face/Battler_Actor7_Face_3_B",0,$game_variables[115],$game_variables[116],$game_variables[83],$game_variables[83],ro_ice_op,0) if ro_posy_type == "3("
      if ro_posy_type == "2(" and $game_actors[7].state?(133) == true
        $game_map.screen.pictures[8].show("face/Battler_Actor7_Face_2_B_S1",0,$game_variables[115],$game_variables[116],$game_variables[83],$game_variables[83],ro_ice_op,0)
      elsif ro_posy_type == "2("
        $game_map.screen.pictures[8].show("face/Battler_Actor7_Face_2_B",0,$game_variables[115],$game_variables[116],$game_variables[83],$game_variables[83],ro_ice_op,0)
      end
    when 4
      # 에르니 이미지 표시 확인
      $game_switches[200] == true ? ro_ice_op = 150 : ro_ice_op = 0
      $game_map.screen.pictures[8].show("face/Battler_Actor7_Face_B",0,$game_variables[115],$game_variables[116],$game_variables[83],$game_variables[83],ro_ice_op,0) if ro_posy_type == "1("
      $game_map.screen.pictures[8].show("face/Battler_Actor7_Face_3_B",0,$game_variables[115],$game_variables[116],$game_variables[83],$game_variables[83],ro_ice_op,0) if ro_posy_type == "3("
      if ro_posy_type == "2(" and $game_actors[7].state?(133) == true
        $game_map.screen.pictures[8].show("face/Battler_Actor7_Face_2_B_S1",0,$game_variables[115],$game_variables[116],$game_variables[83],$game_variables[83],ro_ice_op,0)
      elsif ro_posy_type == "2("
        $game_map.screen.pictures[8].show("face/Battler_Actor7_Face_2_B",0,$game_variables[115],$game_variables[116],$game_variables[83],$game_variables[83],ro_ice_op,0)
      end
    when 2
      # 에르니 이미지 표시 확인
      $game_switches[200] == true ? ro_ice_op = 255 : ro_ice_op = 0
      $game_map.screen.pictures[8].show("face/Battler_Actor7_Face_B",0,$game_variables[115],$game_variables[116],$game_variables[83],$game_variables[83],ro_ice_op,0) if ro_posy_type == "1("
      $game_map.screen.pictures[8].show("face/Battler_Actor7_Face_3_B",0,$game_variables[115],$game_variables[116],$game_variables[83],$game_variables[83],ro_ice_op,0) if ro_posy_type == "3("
      if ro_posy_type == "2(" and $game_actors[7].state?(133) == true
        $game_map.screen.pictures[8].show("face/Battler_Actor7_Face_2_B_S1",0,$game_variables[115],$game_variables[116],$game_variables[83],$game_variables[83],ro_ice_op,0)
      elsif ro_posy_type == "2("
        $game_map.screen.pictures[8].show("face/Battler_Actor7_Face_2_B",0,$game_variables[115],$game_variables[116],$game_variables[83],$game_variables[83],ro_ice_op,0)
      end
    else
      # 에르니 이미지 표시 확인
      $game_switches[200] == true ? ro_ice_op = 50 : ro_ice_op = 0
	    $game_map.screen.pictures[8].show("face/Battler_Actor7_Face_B",0,$game_variables[115],$game_variables[116],$game_variables[83],$game_variables[83],ro_ice_op,0) if ro_posy_type == "1("
	    $game_map.screen.pictures[8].show("face/Battler_Actor7_Face_3_B",0,$game_variables[115],$game_variables[116],$game_variables[83],$game_variables[83],ro_ice_op,0) if ro_posy_type == "3("
      if ro_posy_type == "2(" and $game_actors[7].state?(133) == true
        $game_map.screen.pictures[8].show("face/Battler_Actor7_Face_2_B_S1",0,$game_variables[115],$game_variables[116],$game_variables[83],$game_variables[83],ro_ice_op,0)
      elsif ro_posy_type == "2("
        $game_map.screen.pictures[8].show("face/Battler_Actor7_Face_2_B",0,$game_variables[115],$game_variables[116],$game_variables[83],$game_variables[83],ro_ice_op,0)
      end
    end
    $game_variables[448] = $game_map.screen.pictures[8].name if !$game_map.screen.pictures[8].nil?
  end
  
  #-----------------------------------------------------------------------------
  # 휴식 가능 여부 확인
  #-----------------------------------------------------------------------------
  def rose_state_ok?
    #print("118.Game_Map - rose_state_ok? \n");
    $game_party.members.each do |actor|
      if actor.state?(13) or actor.state?(116) or actor.state?(135) or
         actor.state?(136) or actor.state?(146) or actor.state?(132) or
         actor.state?(133) or actor.state?(2)
        return true
      end
    end
    return false
  end
  
  #-----------------------------------------------------------------------------
  # 착용 방어구 id 적용, 0 이면 알몸 상태
  #-----------------------------------------------------------------------------
  def rose_amor_picture
    #print("118.Game_Map - rose_amor_picture \n");
    ro_amor_img = ""
    # 기본 포즈, 공격 포즈, 피격 포즈
    ro_posy_type = "1("
    ro_posy_type = "3(" if $game_switches[46] == true and SceneManager.scene_is?(Scene_Map)
    ro_posy_type = "2(" if $game_switches[47] == true and SceneManager.scene_is?(Scene_Map)
    # 방어구 번호
    ro_amor_ng = 0
    # 임신 여부
    ro_amor_ng = $game_variables[114]
    # 방어구 내구도 갱신
    if $game_actors[7].equips[3] != nil
      $game_variables[118] = ($game_actors[7].equips[3].durability.to_f / $game_actors[7].equips[3].max_durability * 100).to_i
    end
    # 에르니 이미지 표시 확인
    $game_switches[200] == true ? ro_ice_op = 255 : ro_ice_op = 0
    
    if 1 > $game_variables[118] or ro_amor_ng == 0 or $game_actors[7].equips[3] == nil
      $game_map.screen.pictures[7].show("amor/Battler_Actor7(ZERO)",0,$game_variables[115],$game_variables[116],$game_variables[83],$game_variables[83],ro_ice_op,0) if !$game_map.screen.pictures[7].nil?
      ro_amor_ng = 0
    elsif ro_amor_ng == 0 and ro_amor_va? == true
      $game_map.screen.pictures[7].show("amor/Battler_Actor7(ZERO)",0,$game_variables[115],$game_variables[116],$game_variables[83],$game_variables[83],ro_ice_op,0) if !$game_map.screen.pictures[7].nil?
    else
      if ro_posy_type == "1(" and ro_down? == true and ro_amor_ng != 0
        # 힘든 상태, 추가된 의상 적용
        if 20 >= $game_variables[118]
          ro_amor_img = '_0(' + "#{ro_amor_ng}" + '10)'
        elsif 50 >= $game_variables[118]
          ro_amor_img = '_0(' + "#{ro_amor_ng}" + '40)'
        else
          ro_amor_img = '_0(' + "#{ro_amor_ng}" + '100)'
        end
      else
        if 20 >= $game_variables[118]
          ro_amor_img = '_' + ro_posy_type + "#{ro_amor_ng}" + '10)'
        elsif 50 >= $game_variables[118]
          ro_amor_img = '_' + ro_posy_type + "#{ro_amor_ng}" + '40)'
        else
          ro_amor_img = '_' + ro_posy_type + "#{ro_amor_ng}" + '100)'
        end
      end
      # 악취, 상처, 큰 상처, 출혈인 경우
      if $game_actors[7].state?(134) == true or $game_actors[7].state?(135) == true or
        $game_actors[7].state?(136) == true or $game_actors[7].state?(13) == true
        if $game_party.item_number($data_items[68]) == 0
          $game_map.screen.pictures[7].show("amor(134)/Battler_Actor7"+ro_amor_img,0,$game_variables[115],$game_variables[116],$game_variables[83],$game_variables[83],ro_ice_op,0)
        else
          # 임신 중, 해당 의상 있으면 적용 없으면 알몸 적용
          if (Cache.picture("amor(134)/Battler_Actor7_B"+ro_amor_img) rescue nil)
            $game_map.screen.pictures[7].show("amor(134)/Battler_Actor7_B"+ro_amor_img,0,$game_variables[115],$game_variables[116],$game_variables[83],$game_variables[83],ro_ice_op,0)
          else
            # 임시
            ro_amor_ng = "ZZZ"
            if ro_posy_type == "1(" and ro_down? == true and ro_amor_ng != 0
              # 힘든 상태, 추가된 의상 적용
              if 20 >= $game_variables[118]
                ro_amor_img = '_0(' + "#{ro_amor_ng}" + '10)'
              elsif 50 >= $game_variables[118]
                ro_amor_img = '_0(' + "#{ro_amor_ng}" + '40)'
              else
                ro_amor_img = '_0(' + "#{ro_amor_ng}" + '100)'
              end
            else
              if 20 >= $game_variables[118]
                ro_amor_img = '_' + ro_posy_type + "#{ro_amor_ng}" + '10)'
              elsif 50 >= $game_variables[118]
                ro_amor_img = '_' + ro_posy_type + "#{ro_amor_ng}" + '40)'
              else
                ro_amor_img = '_' + ro_posy_type + "#{ro_amor_ng}" + '100)'
              end
            end
            $game_map.screen.pictures[7].show("amor(134)/Battler_Actor7"+ro_amor_img,0,$game_variables[115],$game_variables[116],$game_variables[83],$game_variables[83],ro_ice_op,0)
            #$game_map.screen.pictures[7].show("amor/Battler_Actor7(ZERO)",0,$game_variables[115],$game_variables[116],$game_variables[83],$game_variables[83],ro_ice_op,0)
          end
        end
      else
        if $game_party.item_number($data_items[68]) == 0
          $game_map.screen.pictures[7].show("amor/Battler_Actor7"+ro_amor_img,0,$game_variables[115],$game_variables[116],$game_variables[83],$game_variables[83],ro_ice_op,0)
        else
          # 임신 중, 해당 의상 있으면 적용 없으면 알몸 적용
          if (Cache.picture("amor/Battler_Actor7_B"+ro_amor_img) rescue nil)
            $game_map.screen.pictures[7].show("amor/Battler_Actor7_B"+ro_amor_img,0,$game_variables[115],$game_variables[116],$game_variables[83],$game_variables[83],ro_ice_op,0)
          else
            # 임시
            ro_amor_ng = "ZZZ"
            if ro_posy_type == "1(" and ro_down? == true and ro_amor_ng != 0
              # 힘든 상태, 추가된 의상 적용
              if 20 >= $game_variables[118]
                ro_amor_img = '_0(' + "#{ro_amor_ng}" + '10)'
              elsif 50 >= $game_variables[118]
                ro_amor_img = '_0(' + "#{ro_amor_ng}" + '40)'
              else
                ro_amor_img = '_0(' + "#{ro_amor_ng}" + '100)'
              end
            else
              if 20 >= $game_variables[118]
                ro_amor_img = '_' + ro_posy_type + "#{ro_amor_ng}" + '10)'
              elsif 50 >= $game_variables[118]
                ro_amor_img = '_' + ro_posy_type + "#{ro_amor_ng}" + '40)'
              else
                ro_amor_img = '_' + ro_posy_type + "#{ro_amor_ng}" + '100)'
              end
            end
            $game_map.screen.pictures[7].show("amor/Battler_Actor7"+ro_amor_img,0,$game_variables[115],$game_variables[116],$game_variables[83],$game_variables[83],ro_ice_op,0)
            #$game_map.screen.pictures[7].show("amor/Battler_Actor7(ZERO)",0,$game_variables[115],$game_variables[116],$game_variables[83],$game_variables[83],ro_ice_op,0)
          end
        end
      end
    end
    $game_variables[447] = $game_map.screen.pictures[7].name if !$game_map.screen.pictures[7].nil?
  end
  
  #-----------------------------------------------------------------------------
  # 에르니 발그레
  #-----------------------------------------------------------------------------
  def rose_state_face
    #print("118.Game_Map - rose_state_face \n");
    # 기본 포즈, 공격 포즈, 피격 포즈
    ro_posy_type = "1("
    ro_posy_type = "3(" if $game_switches[46] == true and SceneManager.scene_is?(Scene_Map)
    ro_posy_type = "2(" if $game_switches[47] == true and SceneManager.scene_is?(Scene_Map)
    # 에르니 이미지 표시 확인
    $game_switches[200] == true ? ro_ice_op = 255 : ro_ice_op = 0

    # 알몸이거나, 발정상태면 유혹 스위치 on
    if $game_variables[118] < 40 or ro_amor_va? == true or $game_actors[7].state?(23)
      # 유혹 스위치 ON
      $game_switches[227] = true
    else
      # 유혹 스위치 ON
      $game_switches[227] = false
    end

    # 에르니가 알몸 상태, 성욕 상태
    if $game_actors[7].sexual_rate >= 55 or $game_switches[227] == true or $game_actors[7].state?(79) or $game_actors[7].state?(80) or $game_variables[121] >= 50
      # 발그레 이미지 적용
      if $game_switches[46] != true and $game_switches[47] != true
        $game_map.screen.pictures[6].show("face/Battler_Actor7_Face_A",0,$game_variables[115],$game_variables[116],$game_variables[83],$game_variables[83],ro_ice_op,0)
      elsif $game_switches[46] == true
        $game_map.screen.pictures[6].show("face/Battler_Actor7_Face_3A",0,$game_variables[115],$game_variables[116],$game_variables[83],$game_variables[83],ro_ice_op,0)
      elsif $game_switches[47] == true
        $game_map.screen.pictures[6].show("face/Battler_Actor7_Face_2A",0,$game_variables[115],$game_variables[116],$game_variables[83],$game_variables[83],ro_ice_op,0)
      end
    elsif !$game_map.screen.pictures[6].nil?
      # 발그레 이미지 삭제
      $game_map.screen.pictures[6].show("face/Battler_Actor7_Face(ZERO)",0,$game_variables[115],$game_variables[116],$game_variables[83],$game_variables[83],0,0)
    end
    # 발그레 이미지 변수에 저장
    $game_variables[446] = $game_map.screen.pictures[6].name if !$game_map.screen.pictures[6].nil?
  end
  
  #-----------------------------------------------------------------------------
  # 알몸, 다운 포즈, 상태이상(체력 20% 이하) 확인
  #-----------------------------------------------------------------------------
  def ro_amor_va?
    #print("118.Game_Map - ro_amor_va? \n");
    return true if $game_actors[7].state?(22) == true or $game_variables[114] == nil or $game_variables[114] == 0
    return false
  end
  
  #-----------------------------------------------------------------------------
  # 힘든 포즈
  #-----------------------------------------------------------------------------
  def ro_down?
    #print("118.Game_Map - ro_down? \n");
    if $game_variables[265] >= 2 or $game_variables[117] >= 2
      # 방어구 번호
      ro_amor_ng = 0
      # 임신 여부
      if $game_party.item_number($data_items[68]) == 0
        ro_amor_ng = $game_variables[114]
        return true if Cache.picture('amor/Battler_Actor7_0(' + "#{ro_amor_ng}" + '100)') rescue nil
      else
        ro_amor_ng = $game_variables[114]
        return true if Cache.picture('amor/Battler_Actor7_B_0(' + "#{ro_amor_ng}" + '100)') rescue nil
      end
    end
    return false
  end
  
  #-----------------------------------------------------------------------------
  # 상태이상 힘든 포즈
  #-----------------------------------------------------------------------------
  def ro_state_down?
    #print("118.Game_Map - ro_state_down? \n");
    return true if $game_actors[7].state?(136) == true or $game_actors[7].state?(13) == true or $game_variables[114] == "I"
    return false
  end
  
  #-----------------------------------------------------------------------------
  # 에르니 몸통 변경
  #-----------------------------------------------------------------------------
  def rose_body_face
    #print("118.Game_Map - rose_body_face \n");
    ro_name = ""
    ro_face_name = ""
    ro_baby = ""
    # 기본 포즈, 공격 포즈, 피격 포즈
    ro_posy_type = "1("
    ro_posy_type = "3(" if $game_switches[46] == true and SceneManager.scene_is?(Scene_Map)
    ro_posy_type = "2(" if $game_switches[47] == true and SceneManager.scene_is?(Scene_Map)
    # 임신 여부
    if $game_party.item_number($data_items[68]) != 0
      ro_baby = "B_"
    end
    # 방어구 번호
    ro_amor_ng = 0
    
    # 보지 악세사리
    ro_bg = ""
    ro_bg = $game_variables[322]
    ro_bg_name = ""
    ro_bg_name_ok = ""

    # 에르니 이미지 표시 확인
    $game_switches[200] == true ? ro_ice_op = 255 : ro_ice_op = 0
    if !$game_map.screen.pictures[3].nil?
      if ro_down? == true or ro_amor_va? == true and ro_posy_type == "1("
        # 큰 상처, 상처, 작은 상처, 기본
        if ro_state_down? == true
          ro_name = 'Battler_Actor7_0_1(' + ro_baby + 'HP20)'
        elsif $game_actors[7].state?(135) == true
          ro_name = 'Battler_Actor7_0_1(' + ro_baby + 'HP40)'
        elsif $game_actors[7].state?(120) == true
          ro_name = 'Battler_Actor7_0_1(' + ro_baby + 'HP60)'
        else
          ro_name = 'Battler_Actor7_0_1(' + ro_baby + 'HP100)'
        end
      elsif ro_amor_va? == true and ro_posy_type == "1("
        # 큰 상처, 상처, 작은 상처, 기본
        if ro_state_down? == true
          ro_name = 'Battler_Actor7_0(' + ro_baby + 'HP20)'
        elsif $game_actors[7].state?(135) == true
          ro_name = 'Battler_Actor7_0(' + ro_baby + 'HP40)'
        elsif $game_actors[7].state?(120) == true
          ro_name = 'Battler_Actor7_0(' + ro_baby + 'HP60)'
        else
          ro_name = 'Battler_Actor7_0(' + ro_baby + 'HP100)'
        end
      else
        # 큰 상처, 상처, 작은 상처, 기본
        if ro_state_down? == true
          ro_name = 'Battler_Actor7_' + ro_posy_type + ro_baby + 'HP20)'
        elsif $game_actors[7].state?(135) == true
          ro_name = 'Battler_Actor7_' + ro_posy_type + ro_baby + 'HP40)'
        elsif $game_actors[7].state?(120) == true
          ro_name = 'Battler_Actor7_' + ro_posy_type + ro_baby + 'HP60)'
        else
          ro_name = 'Battler_Actor7_' + ro_posy_type + ro_baby + 'HP100)'
        end
      end
      if SceneManager.scene_is?(Scene_Map)
        if $game_switches[47] == true
          #빙결 상태인 경우
          ro_name += '_S1' if $game_actors[7].state?(133) == true
          #석화 상태인 경우
          ro_name += '_S2' if $game_actors[7].state?(11) == true
        end
        # 빙결 효과 이미지 적용
        if $game_actors[7].state?(133) == true
          $game_map.screen.pictures[9].show("body/Battler_Ef_S1",0,$game_variables[115],$game_variables[116],$game_variables[83],$game_variables[83],ro_ice_op,1)
        elsif $game_actors[7].state?(133) == false
          $game_map.screen.pictures[9].show("body/Battler_Ef_S1",0,$game_variables[115],$game_variables[116],$game_variables[83],$game_variables[83],0,1)
        end
      end
      # 몸통 변경 적용
      $game_map.screen.pictures[3].show("body/"+ro_name,0,$game_variables[115],$game_variables[116],$game_variables[83],$game_variables[83],ro_ice_op,0)
    end
    # 보지 악세사리 이미지 적용
    if $game_variables[322] != 0
      if ro_posy_type == "1(" and ro_amor_va? == true
        if $game_variables[265] >= 4
          ro_bg_name = '0_1_bg_T' + "#{ro_bg}"
        else
          ro_bg_name = '0_bg_T' + "#{ro_bg}"
        end
      else
        if ro_posy_type == "1("
          ro_bg_name = '1_bg_T' + "#{ro_bg}"
        elsif ro_posy_type == "2("
          ro_bg_name = '2_bg_T' + "#{ro_bg}"
        elsif ro_posy_type == "3("
          ro_bg_name = '3_bg_T' + "#{ro_bg}"
        end
      end
      ro_bg_name_ok = Cache.picture("body_bg/"+ro_bg_name) rescue nil
      if ro_bg_name != "" and ro_bg_name_ok != "" and ro_bg_name_ok != nil
        $game_map.screen.pictures[5].show("body_bg/"+ro_bg_name,0,$game_variables[115],$game_variables[116],$game_variables[83],$game_variables[83],ro_ice_op,0)
      else
        $game_map.screen.pictures[5].show("body_bg/bg_(ZERO)",0,$game_variables[115],$game_variables[116],$game_variables[83],$game_variables[83],0,0)
      end
    else
      $game_map.screen.pictures[5].show("body_bg/bg_(ZERO)",0,$game_variables[115],$game_variables[116],$game_variables[83],$game_variables[83],0,0)
    end
    #-----------------------------------------------------------------------------
    # 빙결, 석화 상태 표정 고정
    #-----------------------------------------------------------------------------
    if SceneManager.scene_is?(Scene_Map) and ($game_actors[7].state?(133) == true or $game_actors[7].state?(11) == true)
      ro_face_name = 'Battler_Actor7_Face_' + ro_posy_type + 'HP40)'
    else
    #-----------------------------------------------------------------------------
    # 에르니 상처 변수, 표정 변경
    #-----------------------------------------------------------------------------
    if !$game_map.screen.pictures[4].nil?
      # 큰 상처, 상처, 작은 상처, 기본
      if ro_state_down? == true
        ro_face_name = 'Battler_Actor7_Face_' + ro_posy_type + 'HP20)'
        # 에르니 출혈+상처 변수
        $game_variables[269] = 4
      elsif $game_actors[7].state?(135) == true or $game_actors[7].state?(120) == true
        ro_face_name = 'Battler_Actor7_Face_' + ro_posy_type + 'HP40)'
        # 에르니 출혈+상처 변수
        $game_variables[269] = 2
      else
        # 에르니 출혈+상처 변수
        $game_variables[269] = 0
        case $game_variables[117]
          when 4..6
            ro_face_name = 'Battler_Actor7_Face_' + ro_posy_type + 'HP40)'
          when 2
            ro_face_name = 'Battler_Actor7_Face_' + ro_posy_type + 'HP20)'
          else
            if 2 >= $game_variables[265] and ro_posy_type == "1("
              if ro_amor_va? == true or $game_variables[121] >= 50
                ro_face_name = 'Battler_Actor7_Face_' + ro_posy_type + 'HP100)_5'
              elsif $game_actors[7].state?(30) or $game_actors[7].state?(84)
                ro_face_name = 'Battler_Actor7_Face_' + ro_posy_type + 'HP100)_6'
              else
                ro_face_name = 'Battler_Actor7_Face_' + ro_posy_type + 'HP100)_2'
              end
            elsif 4 >= $game_variables[265]
              # 에르니가 알몸 상태
              if ro_amor_va? == true and ro_posy_type == "1("
                ro_face_name = 'Battler_Actor7_Face_' + ro_posy_type + 'HP100)_3'
              else
                ro_face_name = 'Battler_Actor7_Face_' + ro_posy_type + 'HP100)'
              end
            else
              if ro_posy_type == "1("
                ro_face_name = 'Battler_Actor7_Face_' + ro_posy_type + 'HP100)_4'
              else
                ro_face_name = 'Battler_Actor7_Face_' + ro_posy_type + 'HP100)'
              end
            end
          end
        end
      end
    end
    # 표정 변경 적용
    $game_map.screen.pictures[4].show("face/"+ro_face_name,0,$game_variables[115],$game_variables[116],$game_variables[83],$game_variables[83],ro_ice_op,0)
    # 표정, 몸통, 성인 악세사리 변수에 저장
    $game_variables[443] = $game_map.screen.pictures[3].name if !$game_map.screen.pictures[3].nil?
    $game_variables[444] = $game_map.screen.pictures[4].name if !$game_map.screen.pictures[4].nil?
    $game_variables[445] = $game_map.screen.pictures[5].name if !$game_map.screen.pictures[5].nil?
  end
  
  def spawn_event(dx, dy, event_id, map_id)
    # 설치할 장소가 부적합하면 취소
    if !$game_player.collide_with_characters?(dx, dy) and $game_player.map_passable?(dx, dy, $game_player.direction)
      #print("118.Game_Map - %s, %s, %s, %s \n" % [dx, dy, event_id, map_id])
      $game_variables[105] = 0
      map_id = @map_id if map_id == 0
      map = load_data(sprintf("Data/Map%03d.rvdata2", map_id))
      event = generated_event(map, event_id)
      return if event.nil?
      key_id = 1 if $game_map.events.empty?
      key_id = $game_map.events.keys.max + 1 if !$game_map.events.empty?
      event = clone_event(event, key_id)
      @events[key_id] = Game_Event.new(@map_id, event)
      @events[key_id].moveto(dx, dy)
      @events[key_id].knockdown_data[0] = 0
      $game_self_switches[[$game_map.map_id, event.id, "A"]] = false
      $game_self_switches[[$game_map.map_id, event.id, "B"]] = false
      $game_self_switches[[$game_map.map_id, event.id, "C"]] = false
      $game_self_switches[[$game_map.map_id, event.id, "D"]] = false
      SceneManager.scene.spriteset.refresh_characters
    else
      $game_variables[105] = 1
      return
    end
  end
  
  def spawn_event2(dx, dy, event_id, map_id, id)
    map_id = @map_id if map_id == 0
    map = load_data(sprintf("Data/Map%03d.rvdata2", map_id))
    event = generated_event(map, event_id)
    return if event.nil?
    key_id = id
    event = clone_event(event, key_id)
    @events[key_id] = Game_Event.new(@map_id, event)
    @events[key_id].moveto(dx, dy)
    @events[key_id].knockdown_data[0] = 0
    SceneManager.scene.spriteset.refresh_characters
  end

  def generated_event(map, event_id)
    for key in map.events
      event = key[1]
      next if event.nil?
      return event if event.id == event_id
    end
    return nil
  end
  
  def spawn_event_region(reg_id, event_id, map_id)
    tile = get_random_region_tile(reg_id)
    return if tile.nil?
    spawn_event(tile[0], tile[1], event_id, map_id)
  end
  
  def get_random_region_tile(reg_id)
    tiles = []
    for i in 0...width
      for j in 0...height
        next unless region_id(i, j) == reg_id
        next if $game_player.collide_with_characters?(i, j)
        next if i == $game_player.x && j == $game_player.y
        tiles.push([i, j])
      end
    end
    return tiles.sample
  end
  
  def clone_event(event, id)	
	  cloned_event = Marshal.load(Marshal.dump(event))
	  cloned_event.id = id
	  return cloned_event
  end
  
  def adjust_tile_slide_x
    @display_x != 0 && @display_x != (@map.width - screen_tile_x) && !scrolling?
  end
  
  def adjust_tile_slide_y
    @display_y != 0 && @display_y != (@map.height - screen_tile_y) && !scrolling?
  end
  
  def event_list
    events.values
  end
  
  def note
    @map ? @map.note : ""
  end
  
  def map_events
    @map.events
  end
  
  def actors
    [$game_player] + $game_player.followers.visible_followers
  end

  def setup_fog_a
    @fog_a_name = @map.fog_a_name;    @fog_a_move = @map.fog_a_move
    @fog_a_opacity = @map.fog_a_opac
    @fog_a_z = 1
    @fog_a_color = @map.fog_a_color
    @fog_a_loop_x = @fog_a_move[0] != 0 ? true : false
    @fog_a_loop_y = @fog_a_move[1] != 0 ? true : false
    @fog_a_sx = @fog_a_move[0];    @fog_a_sy = @fog_a_move[1]
    @fog_a_x = 0
    @fog_a_y = 0
  end

  def setup_fog_b
    @fog_b_name = @map.fog_b_name;    @fog_b_move = @map.fog_b_move
    @fog_b_opacity = @map.fog_b_opac
    @fog_b_z = 1
    @fog_b_color = @map.fog_b_color
    @fog_b_loop_x = @fog_b_move[0] != 0 ? true : false
    @fog_b_loop_y = @fog_b_move[1] != 0 ? true : false
    @fog_b_sx = @fog_b_move[0];    @fog_b_sy = @fog_b_move[1]
    @fog_b_x = 0
    @fog_b_y = 0
  end

  def setup_fog_c
    @fog_c_name = @map.fog_c_name;    @fog_c_move = @map.fog_c_move
    @fog_c_opacity = @map.fog_c_opac
    @fog_c_z = 1
    @fog_c_color = @map.fog_c_color
    @fog_c_loop_x = @fog_c_move[0] != 0 ? true : false
    @fog_c_loop_y = @fog_c_move[1] != 0 ? true : false
    @fog_c_sx = @fog_c_move[0];    @fog_c_sy = @fog_c_move[1]
    @fog_c_x = 0
    @fog_c_y = 0
  end

  alias :sdp_for_fog    :set_display_pos
  def set_display_pos(x, y)
    sdp_for_fog(x, y)
  end

  alias :s_d_for_fog    :scroll_down
  def scroll_down(distance)
    last_y = @display_y
    s_d_for_fog(distance)
    fog_scroll_down(distance, last_y)
  end
  
  alias :s_r_for_fog    :scroll_right
  def scroll_right(distance)
    last_x = @display_x
    s_r_for_fog(distance)
    fog_scroll_right(distance, last_x)
  end

  def fog_scroll_down(distance, last_y)
    value = @display_y - last_y
    @fog_a_y += value ; @fog_b_y += value ; @fog_c_y += value 
  end
  
  alias :s_l_for_fog    :scroll_left
  def scroll_left(distance)
    last_x = @display_x
    s_l_for_fog(distance)
    fog_scroll_left(distance, last_x)
  end
  
  def fog_scroll_left(distance, last_x)
    value = @display_x - last_x
    @fog_a_x += value ; @fog_b_x += value ; @fog_c_x += value 
  end
  
  def fog_scroll_right(distance, last_x)
    value = @display_x - last_x
    @fog_a_x += value ; @fog_b_x += value ; @fog_c_x += value 
  end
  
  alias :s_u_for_fog    :scroll_up
  def scroll_up(distance)
    last_y = @display_y
    s_u_for_fog(distance)
    fog_scroll_up(distance, last_y)
  end
  
  def fog_scroll_up(distance, last_y)
    value = @display_y - last_y
    @fog_a_y += value ; @fog_b_y += value ; @fog_c_y += value 
  end
  
  #alias :update_for_fog :update_parallax
  def update_parallax
    #print("118.Game_Map - update_parallax \n");
    # 날씨가 안좋으면 구름 이미지 변경
    if @fog_a_name == "cloud>" and $game_variables[12] != 0
      @fog_a_name = "cloud_w>"
    elsif @fog_a_name == "cloud_w>" and $game_variables[12] == 0
      @fog_a_name = "cloud>"
    elsif @fog_a_name == "cloud_2>" and $game_variables[12] != 0
      @fog_a_name = "cloud_2_w>"
    elsif @fog_a_name == "cloud_2_w>" and $game_variables[12] == 0
      @fog_a_name = "cloud_2>"
    end
    update_fog
  end
  
  # $game_variables[12] 현재 날씨
  def update_fog
    @fog_a_x += ((@fog_a_sx + (5-$game_variables[12])/10).to_f / 128.0).round(3)
    @fog_a_y += ((@fog_a_sy + (5-$game_variables[12])/10).to_f / 128.0).round(3)
    @fog_b_x += ((@fog_b_sx + (5-$game_variables[12])/10).to_f / 128.0).round(3)
    @fog_b_y += ((@fog_b_sy + (5-$game_variables[12])/10).to_f / 128.0).round(3)
    @fog_c_x += ((@fog_c_sx + (5-$game_variables[12])/10).to_f / 128.0).round(3)
    @fog_c_y += ((@fog_c_sy + (5-$game_variables[12])/10).to_f / 128.0).round(3)
  end
  
  def fog_a_x;    @fog_a_x;  end
  def fog_a_y;    @fog_a_y;  end
  def fog_b_x;    @fog_b_x;  end
  def fog_b_y;    @fog_b_y;  end
  def fog_c_x;    @fog_c_x;  end
  def fog_c_y;    @fog_c_y;  end
  
  def reset_char_effects2
    #print("118.Game_Map - reset_char_effects2 \n");
    @shad_id_ro = []
    @light_source = []
    @shadow_options = [80,10,false]
    @char_effects2 = [false,false,false,false]
  end
  
  def setup_lights_effect
    setup_map_shade(note)
    setup_map_lights(:actor, note)
    setup_map_lights(:event, note)
    setup_map_lights(:vehicle, note)
    setup_map_lights(:map, note)
    setup_map_lantern(:actor, note)
    setup_map_lantern(:event, note)
    setup_map_lantern(:vehicle, note)
  end
  
  def setup_map_shade(text)
    shade = @screen.shade
    if $game_variables[155] != $game_variables[153] or $game_variables[399] != $game_map.map_id
      # 외부인 경우
      if !$game_map.map.no_weather
        #print("118.Game_Map - setup_map_shade, 외부 \n");
        case $game_variables[6]
          when 0..2;       red   = -60;    green = 70;     blue  = 90
          when 3..4;       red   = 10;     green = 15;     blue  = 20
          when 5..7;       red   = 30;     green = 10;     blue  = 10
          when 8..10;      red   = 40;     green = 0;      blue  = 5
          when 11..16;     red   = 0;      green = 0;      blue  = 0
          when 17..19;     red   = 0;      green = 10;     blue  = 10
          when 20;         red   = 0;      green = 20;     blue  = 30
          when 21;         red   = -10;    green = 30;     blue  = 40
          when 22..23;     red   = -20;    green = 40;     blue  = 60
          when 24;         red   = -40;    green = 60;     blue  = 70
          else;            red   = 0;      green = 20;     blue  = 30
        end
        shade.blend = 2
        shade.set_color(red, green, blue)
        shade.opacity = $game_variables[82]
        # 중단하도록 새로운 맵, 조명 대입
        $game_variables[155] = $game_variables[153]
        shade.show
      # 동굴인 경우
      elsif $game_map.map.no_weather and $game_map.map.is_forest?
        # 동굴 조명 효과 적용
        #print("118.Game_Map - setup_map_shade, 동굴 \n");
        case $game_variables[153]
          when 0;        red   = -40;    green = 60;     blue  = 70
          when 1;        red   = -80;    green = 170;    blue  = -120
          when 2;        red   = 170;    green = -80;    blue  = -120
          when 3;        red   = -120;   green = -80;    blue  = 170
          else;          red   = -40;    green = 60;     blue  = 70
        end
        shade.blend = 2
        shade.set_color(red, green, blue)
        shade.opacity = $game_variables[82]
        # 중단하도록 새로운 맵, 조명 대입
        $game_variables[155] = $game_variables[153]
        shade.show
      # 내부
      elsif $game_map.map.no_weather
        #print("118.Game_Map - setup_map_shade, 내부 \n");
        red   = 40;     green = 0;      blue  = 5
        shade.blend = 2
        shade.set_color(red, green, blue)
        shade.opacity = $game_variables[82]
        # 중단하도록 새로운 맵, 조명 대입
        $game_variables[155] = $game_variables[153]
        shade.show
      end
    end
  end
  
  def do_shadows(refresh = true)
    @events.values.each { |e|
      next if !e.list
      if e.list[0].code == 108 && e.list[0].parameters[0] =~ /<shadow>/
        e.shadow = true
      else
        e.shadow = false
      end
    }
    if refresh
      SceneManager.scene.spriteset.refresh_effects
    end
  end
  
  def do_all_chareffects
    do_shadows(false)
  end
  
  def setup_map_lights(type, text)
    value  = get_regexp_value(type)
    text.scan(get_all_values("#{value} LIGHT")) do 
      light = setup_light($1.dup, type)
      @screen.lights[light.id] = light if light.id
    end
  end
  
  def setup_map_lantern(type, text)
    value  = get_regexp_value(type)
    regexp = /<#{value} LANTERN (\d+): (\d+)>/i  
    text.scan(regexp) do |index_r, opacity|
    target = get_font(type, index_r.to_i)
      next unless target
      # 동료 조명 추가 실험
      target.index_r = index_r.to_i
      target.lantern = opacity.to_i
      # 116.Game_CharacterBase 에서 랜던 업데이트
      target.update_lantern
    end
  end
  
  def get_regexp_value(type)
    case type
    when :actor   then "ACTOR"
    when :event   then "EVENT"
    when :vehicle then "VEHICLE"
    when :map     then "MAP"
    end
  end
  
  def setup_light(info, type)
    light = Game_LightEffect.new
    light.name     = info =~ /NAME: #{get_filename}/i ? $1.dup : ""
    light.id       = info =~ /ID: (\w+)/i         ? $1.to_s : 0
    light.id       = info =~ /ID: (\d+)/i         ? $1.to_i : light.id
    light.x        = info =~ /POS X: ([+-]?\d+)/i ? $1.to_i : 0
    light.y        = info =~ /POS Y: ([+-]?\d+)/i ? $1.to_i : 0
    light.speed    = info =~ /SPEED: (\d+)/i      ? $1.to_i : 0
    light.zoom     = info =~ /ZOOM: (\d+)/i       ? $1.to_f : 100.0
    light.opacity  = info =~ /OPACITY: (\d+)/i    ? $1.to_i : 192
    #light.variance = info =~ /VAR: (\d+)/i        ? $1.to_i : 0
    if type == :map
      map_x = info =~ /MAP X: (\d+)/i ? $1.to_i : 0
      map_y = info =~ /MAP Y: (\d+)/i ? $1.to_i : 0
      light.info = {x: map_x, y: map_y}
    else
      index = info =~ /INDEX: (\d+)/i ? $1.to_i : 0
      light.info = {type => index}
    end
    light
  end
  
  def set_light(id, name, info, op = 0, x = 0, y = 0, v = 0, s = 0, z = 100)
    light = Game_LightEffect.new
    light.id       = id
    light.name     = name
    light.info     = info
    light.opacity  = op.to_i
    light.x        = x.to_i
    light.y        = y.to_i
    #light.variance = v.to_i
    light.speed    = s.to_i
    light.zoom     = z.to_f
    light
  end
  
  def get_font(type, i)
    case type
    when :actor   then actors[i - 1]
    when :event   then events[i]
    when :vehicle then vehicles[i]  
    end
  end
  
  def delta_x(x1, x2)
    result = x1 - x2
    if $game_map.loop_horizontal? && result.abs > $game_map.width / 2
      if result < 0
        result += $game_map.width
      else
        result -= $game_map.width
      end
    end
    result        
  end
  
  def delta_y(y1, y2)
    result = y1 - y2
    if $game_map.loop_vertical? && result.abs > ($game_map.height / 2)
      if result < 0
        result += $game_map.height
      else
        result -= $game_map.height
      end
    end
    result        
  end
  
  def distance(x1, y1, x2, y2)
    delta_x(x1, x2).abs + delta_y(y1, y2).abs
  end
  
  def each_neighbor(node, char = $game_player)
    x = node.point.x
    y = node.point.y
    nodes = []
    4.times {|i|
      i += 1
      new_x = round_x_with_direction(x, i * 2)
      new_y = round_y_with_direction(y, i * 2)
      next unless char.passable?(x, y, i * 2)
      nodes.push(Node.new(Point.new(new_x, new_y)))
    }
    nodes
  end
  
  # 아래 수정된 라인(거리 매개변수 추가)
  def find_path(tx, ty, sx, sy, dist, char = $game_player)
    start = Node.new(Point.new(sx, sy))
    goal = Node.new(Point.new(tx, ty))
    return [] if start == goal or (dist > 0 and start.point.distance(goal.point) <= dist)
    return [] if ![2, 4, 6, 8].any? {|i| char.passable?(tx, ty, i) }
    
    open_set = [start]
    closed_set = []
    path = []
    iterations = 0
    loop do
      return [] if iterations >= Jet::Pathfinder::MAXIMUM_ITERATIONS
      return [] if iterations == Jet::Pathfinder::MAXIMUM_ITERATIONS
      iterations += 1
      current = open_set.min
      return [] unless current
      each_neighbor(current, char).each {|node|
        # 아래 수정된 줄(거리 처리 추가)
        if node == goal or (dist > 0 and node.point.distance(goal.point) <= dist)
          node.parent = current
          node.mark_path
          return recreate_path(node)
        end
        next if closed_set.include?(node)
        cost = current.cost + 1
        if open_set.include?(node)
          if cost < node.cost
            node.parent = current
            node.cost = cost
          end
        else
          open_set << node
          node.parent = current
          node.cost = cost
          node.cost_estimated = node.point.distance(goal.point)
        end
      }
      closed_set << open_set.delete(current)
    end
  end
  
  def recreate_path(node)
    path = []
    hash = {[1, 0] => 3, [-1, 0] => 2, [0, 1] => 1, [0, -1] => 4}
    until node.nil?
      pos = node.point
      node = node.parent
      next if node.nil?
      ar = [pos.x <=> node.point.x, pos.y <=> node.point.y]
      path.push(RPG::MoveCommand.new(hash[ar]))
    end
    return path
  end
end