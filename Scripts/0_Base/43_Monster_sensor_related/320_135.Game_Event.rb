# encoding: utf-8
# Name: 135.Game_Event
# Size: 25769
class Game_Event < Game_Character
  attr_accessor :enemy, :move_type, :page, :deadposee
  attr_accessor :being_targeted, :agroto_f
  attr_accessor :start_delay, :epassive, :erased, :killed, :boom_grabdata
  attr_accessor :allow_update
  attr_reader   :token_weapon, :token_armor,:token_item,:token_skill,:boom_start
  attr_reader   :hook_pull, :hook_grab, :event, :knockdown_enable, :boom_grab
  attr_reader   :respawn_anim
  
  @@clone_pattern = CloneEvents::CLONE_MAP.nil? ? 
    (CloneEvents::USE_NAME ? CloneEvents::PATT_MAP_NAME : CloneEvents::PATT_MAP_ID) : 
    (CloneEvents::USE_NAME ? CloneEvents::PATT_NAME : CloneEvents::PATT_ID)
  
  alias falcaopearlabs_iniev initialize
  def initialize(map_id, event)
    @shadow = false
    @inrangeev = nil
    @being_targeted = false
    @agroto_f = nil
    @epassive = false
    @touch_damage = 0
    @start_delay = 0
    @touch_atkdelay = 0
    @killed = false
    @knockdown_enable = false
    @deadposee = false
    @respawn_anim = 0
    
    falcaopearlabs_iniev(map_id, event)
    
    check_clone
    
    @ignore_antilag = true if event.name =~ /<global>/i
    @parallel_mode = @trigger == 3 || @trigger == 4 || @ignore_antilag
    #@parallel_mode = true
    @allow_update = true
    update_on_screen_event

    register_enemy(event)
    randomize_position
  end
  
  def check_clone
    if @event && @event.pages[0].list && @event.pages[0].list[0].code == 108
      @event.pages[0].list[0].parameters[0].gsub!(@@clone_pattern) do
        clone_map = CloneEvents::CLONE_MAP.nil? ? $1.to_i : CloneEvents::CLONE_MAP
        clone_name = (CloneEvents::CLONE_MAP.nil? ? $2.to_s : $1.to_s).downcase
        DataManager.clone_map_events(clone_map) if !$data_clones.has_key?(clone_map)
        @event.pages = Array.new($data_clones[clone_map][clone_name].pages.clone)
        # -------------------------------------
        # MOG 센서와의 호환성
        # -------------------------------------
        db_event = $data_clones[clone_map][clone_name]
        name_plus = db_event.name[/<sensor\d+>/i]
        @event.name += name_plus if name_plus
      end
    end
    @page = nil
    refresh
  end

  # 해당 이벤트가 화면에 포함되어 있는지 확인
  def near_the_screen?(dx = nil, dy = nil)
    dx = [Graphics.width * 1.2, $game_map.width * 256].min/32 - 5 if dx.nil?
    dy = [Graphics.height * 1.2, $game_map.height * 256].min/32 - 5 if dy.nil?
    #print("135.Game_Event - near_the_screen? %s, %s \n" % [dx, dy])
    #dx = [Graphics.width, $game_map.width * 256].min/32 - 5 if dx.nil?
    #dy = [Graphics.height, $game_map.height * 256].min/32 - 5 if dy.nil?
    ax = $game_map.adjust_x(@real_x) - Graphics.width / 2 / 32
    ay = $game_map.adjust_y(@real_y) - Graphics.height / 2 / 32
    ax >= -dx && ax <= dx && ay >= -dy && ay <= dy
  end

  #-----------------------------------------------------------------------------
  # * 이벤트 현재 페이지의 공헌도 진영 ID 가져오기 시작
  #-----------------------------------------------------------------------------
  def faction
    @page.list.map{|l| l.parameters}.each do |line|
      next if line[0].nil?
      if line[0] =~ /<faction:\s*(\d+)\s*>/i
        fac_id = $1.to_i
        return fac_id if SZS_Factions::Factions[fac_id]
      end
    end
    return nil
  end

  def randomize_position
    return if @page.nil?
    return if $game_switches[TH::Random_Event_Positions::Disable_Switch] || !@page.random_position?
    #print("052 - Game_Event - randomize_position \n");
    if @page.random_position_type == :start
      return if $game_system.random_position_event[[@map_id, @id]]
    elsif @page.random_position_type == :init
      return if @position_randomized
    end
    @position_randomized = true
    srand
    $game_system.random_position_event[[@map_id, @id]] = true
    begin
      pos = get_random_position
      return unless pos
    end while !$game_map.events_xy(pos[0], pos[1]).empty?
    moveto(pos[0], pos[1])
  end
  
  def get_random_position
    arr = $game_map.region_tile_mapping[@page.random_position_region]
    return arr.delete_at(rand(arr.length))
  end
  
  def name
    @event ? @event.name : ""
  end

  def update_on_screen_event
    @allow_update = false unless @parallel_mode
    if @parallel_mode == true
      @allow_update = true
    else
      max_w = $game_map.max_width + 64 ; max_h = $game_map.max_height + 32
      out = PearlAntilag::OutRange
      sx = (screen_x / 32).to_i
      sy = (screen_y / 32).to_i
      if sx.between?(0 - out, max_w + out) and sy.between?(0 - out, max_h + out)
        @allow_update = true
      end
    end
  end

  def create_token_arrays
    @token_weapon = []
    @token_armor  = []
    @token_item   = []
    @token_skill  = []
  end
  
  alias falcaopearl_setup_page_settings setup_page_settings
  def setup_page_settings
    create_token_arrays
    
    falcaopearl_setup_page_settings
    
    # 정기, 자동 이벤트는 무조건 진행되도록 수정
    @parallel_mode = @trigger == 3 || @trigger == 4 || @ignore_antilag
    
    @hook_pull = string_data("<hook_pull: ") == "true"
    @hook_grab = string_data("<hook_grab: ") == "true"
    @boom_grab = string_data("<boom_grab: ") == "true"
    @boom_start = string_data("<boomed_start: ") == "true"
    @direction_fix = false if @hook_grab
    
    if @hook_pull || @hook_grab || @boom_grab || @boom_start
    #if has_token? || @hook_pull || @hook_grab || @boom_grab || @boom_start
      $game_map.events_withtags.push(self) unless
      $game_map.events_withtags.include?(self)
    end
    
    # 캐릭터 효과 적용
    setup_character_ex_effects
    randomize_position if @page.random_position_type == :page
  end
  
  def has_token?
    !@token_weapon.empty? || !@token_armor.empty? || !@token_item.empty? ||
    !@token_skill.empty?
  end
  
  def register_enemy(event)
    if !$game_system.remain_killed[$game_map.map_id].nil? and
      $game_system.remain_killed[$game_map.map_id].include?(self.id)
      return
    end
    
    @enemy = Game_Enemy.new(0, $1.to_i) if event.name =~ /<enemy: (.*)>/i

    if @enemy != nil
      passive = @enemy.enemy.tool_data("Enemy Passive = ", false)
      @epassive = true if passive == "true"
      touch = @enemy.enemy.tool_data("Enemy Touch Damage Range = ")
      @sensor = @enemy.esensor
      @touch_damage = touch if touch != nil
      $game_map.event_enemies.push(self) # 새로운 별도의 적 목록
      $game_map.enemies.push(@enemy)     # 재사용 대기시간에 사용된 적
      @event.pages.each do |page|
        if page.condition.self_switch_valid and
          page.condition.self_switch_ch == PearlKernel::KnockdownSelfW
          @knockdown_enable = true
          break
        end
      end
      pose = @enemy.enemy.tool_data("Enemy Dead Pose = ", false) == "true"
      @deadposee = true if pose and @knockdown_enable
    end
  end
  
  def update_state_effects
    @killed ? return : super
  end
  
  def collapsing?
    return true if @killed
    return false
  end
  
  # 몬스터 대상 확인, 철문도 공격 대상으로 설정
  def enemy_ready?
    return false if @character_name == ""
    return false if @enemy.nil?
    return false if @enemy.nil? || @page.nil? || collapsing? || (@enemy.object and @enemy.enemy_id != 135)
    return true
  end
  
  def battler
    return @enemy
  end
  
  def apply_respawn
    @through = @die_through
    @through = false if @through.nil?
    @die_through = nil
    @secollapse = nil
    @erased = false ; @opacity = 255
    @zoomfx_x = 1.0 ; @zoomfx_y = 1.0
    @killed = false
    @priority_type = 1 if @deadposee
    resetdeadpose
    refresh
  end
  
  def resetdeadpose
    if @deadposee
      $game_self_switches[[$game_map.map_id, @id, PearlKernel::KnockdownSelfW]] = false
    end
  end
  
  def kill_enemy
    @secollapse = nil
    @killed = true
    @priority_type = 0 if @deadposee
    gain_exp
    run_assigned_commands
  end
  
  def run_assigned_commands
    transform = @enemy.enemy.tool_data("Enemy Die Transform = ")
    switch = @enemy.enemy.tool_data("Enemy Die Switch = ")
    $game_switches[switch] = true if switch != nil
    variable = @enemy.enemy.tool_data("Enemy Die Variable = ")
    $game_variables[variable] += 1 if variable != nil

    # 특정 맵에서만 카운터 증가
    monster_common_id = @enemy.enemy.tool_data("Enemy Die Common = ")
    
    # 몬스터 처치시 커먼이벤트 있을 경우 해당 몬스터 id 변수에 저장
    if monster_common_id != nil and @enemy != nil
      $game_variables[211] = @enemy.enemy.id
      $game_temp.reserve_common_event(monster_common_id)
    end

    self_sw = @enemy.enemy.tool_data("Enemy Die Self Switch = ", false)

    # 지하수로 쇠창살 파괴
    if $game_map.map_id == 184 and @enemy.enemy.name =~ /철창/i
      $game_switches[261] = true
    end
    
    if self_sw.is_a?(String)
      $game_self_switches[[$game_map.map_id, self.id, self_sw]] = true
      apply_respawn
      $game_map.event_enemies.delete(self)
      $game_map.enemies.delete(@enemy)
      unless $game_system.remain_killed.has_key?($game_map.map_id)
        $game_system.remain_killed[$game_map.map_id] = []
      end
      $game_system.remain_killed[$game_map.map_id].push(self.id) unless
      $game_system.remain_killed[$game_map.map_id].include?(self.id)
      @enemy = nil
    else
      erase unless @deadposee
      respawn = @enemy.enemy.tool_data("Enemy Respawn Seconds = ")
      animation = @enemy.enemy.tool_data("Enemy Respawn Animation = ")
      @respawn_count = respawn * 60 unless respawn.nil?
      @respawn_anim = animation unless animation.nil?
    end    
    if respawn != nil
      erase unless @deadposee
      respawn = @enemy.enemy.tool_data("Enemy Respawn Seconds = ")
      animation = @enemy.enemy.tool_data("Enemy Respawn Animation = ")
      @respawn_count = respawn * 60 unless respawn.nil?
      @respawn_anim = animation unless animation.nil?
    end
    if transform != nil
      @enemy = Game_Enemy.new(0, transform)
      apply_respawn
    end
  end
  
  def gain_exp
    return if @enemy.exp == 0
    @maber_exp = $game_party.members.size
    @maber_exp = 1 if 1 > @maber_exp
    $game_party.battle_members.each do |actor|
      @enemy_va_exp = (((@enemy.exp * 0.01) * (100 + $game_variables[169])).to_f / @maber_exp).round
      actor.gain_exp(@enemy_va_exp)
    end
    #print("135.Game_Event - 도감 시작 준비 \n");
    # 몬스터 도감에 추가
    #$game_troop.members.each do |enemy|
      rpg_enemy = $data_enemies[@enemy.enemy.id]
      if !rpg_enemy.nil? and !rpg_enemy.skip
        unless $game_party.bestiary_include?(rpg_enemy.shown_id)
          $game_party.add_enemy($data_enemies[rpg_enemy.shown_id])
        end
        $game_party.bestiary.each do |entry|
          next unless entry.enemy_id == rpg_enemy.shown_id
          entry.kills += 1
          case entry.kills
          when Venka::Bestiary::Show_Elements
            entry.elements.size.times {|i| entry.elements[i] = true}
          when Venka::Bestiary::Show_States
            entry.states.size.times {|i| entry.states[i] = true}
          end
        end
      end
    #end
    # 지역 공헌도 추가, 더하기
    $game_factions = Game_Factions.new if $game_factions == nil
    if $game_variables[157]-1 >= 1
      $game_factions.gain_reputation(($game_variables[157]-1).to_i, @enemy_va_exp * 20)
    end
  end

  def gain_gold
    return if @enemy.gold == 0
    $game_party.gain_gold(@enemy.gold)
  end
  
  alias falcaopearlabs_updatev update
  def update
    # 진행 중지 -----------------------------------------------------------------
    return if HM_SEL::time_stop?
    # --------------------------------------------------------------------------
    # 아래는 시간 가속중이 아닌 경우에만 적용
    # --------------------------------------------------------------------------
    if $game_switches[283] == false and Graphics.frame_count % 2 == 0
      @start_delay -= 1 if @start_delay > 0
      @touch_atkdelay -= 1 if @touch_atkdelay > 0
      update_enemy_sensor unless @enemy.nil?
      update_enemy_touch_damage unless @enemy.nil?
    end
    unless @parallel_mode
      update_on_screen_event
      return unless @allow_update
    end
    falcaopearlabs_updatev
  end

  def update_enemy_touch_damage
    return unless @touch_damage > 0
    return unless @character_name != ""
    return if @epassive || @killed
    return if @touch_atkdelay > 0
    return if @enemy == nil
    target = $game_player
    # 파리인 경우 악취 상태인 경우에만 데미지 적용
    if @enemy.name =~ /파리/i and !target.battler.nil? and !target.battler.dead?
      return if !target.battler.state?(134)
    end
    execute_touch_damage(target) if obj_size?(target, @touch_damage)
  end
  
  # 터치 함정 부분
  def execute_touch_damage(target)
    target.battler.attack_apply(@enemy)
    target.pop_damage
    @touch_atkdelay = 50
    return if target.battler.result.hp_damage == 0
  end

  # 적 센서
  def update_enemy_sensor
    return if battler == nil
    return if @hookshoting[0]
    return if @epassive
    
    # --------------------------------------------------------------------------
    # 오크통, 상자 같은 함정 셀프 스위치 리셋
    # --------------------------------------------------------------------------
    self_10_sw = @enemy.enemy.tool_data("Enemy Die 10 Switch = ")
    
    # 타겟 지정
    #@agroto_f.nil? ? target = $game_player : target = @agroto_f
    
    @agroto_f = nil
    target = $game_player
    
    # 프레임 조작 실험
    if $game_party.members.size > 1 and rand(10) >= 4 #and $sel_time_frame_30 == 2
      @rand_follow = []
      (1...$game_party.members.size).each do |index|
      #(1...$game_party.max_battle_members).each do |index|
        @rand_follow.push(Game_Follower.new(index, @rand_follow[-1]))
        @agroto_f = $game_player.followers[rand(@rand_follow.length)]
        target = @agroto_f
      end
    end
    
=begin
    # 팔로우가 죽은 상태면 타겟을 변경 한다.
    if target.battler == nil
      @agroto_f = nil
      target = $game_player
    elsif target.battler.state?(1) == true
      @agroto_f = nil
      target = $game_player
    end
=end
    
    # 몬스터 센서 수치 적용
    data = [$game_map.map_id, @id, PearlKernel::Enemy_Sensor]
    @sensor = @enemy.esensor

    # D 는 완전히 죽은 상태로 리젠, 반응등 안됨 적용 22.08.27 추가
    if !battler.state?(1) and $game_self_switches[[data[0], data[1], "D"]] == true
      $game_map.event_enemies.delete(self)
      $game_map.enemies.delete(@enemy)
      return
    end
    
    # 일반 몬스터가 아닌 경우만 적용
    if self_10_sw != 3 and self_10_sw != nil and self_10_sw != 8
      @agroto_f = nil
      target = $game_player
      if obj_size?(target, 11)
        # 오크통
        if self_10_sw == 1 and (battler.mhp*0.8) >= battler.hp and $game_self_switches[[data[0], data[1], data[2]]] == false
          # 오크통 폭발 준비
          $game_self_switches[[data[0], data[1], data[2]]] = true
          @inrangeev = true
        elsif self_10_sw == 1 and battler.state?(132) == true and $game_self_switches[[data[0], data[1], data[2]]] == false
          # 오크통 폭발 준비
          $game_self_switches[[data[0], data[1], data[2]]] = true
          @inrangeev = true
        elsif self_10_sw == 1 and battler.mhp == battler.hp and $game_self_switches[[data[0], data[1], data[2]]] == true
          # 오크통 폭발 취소
          $game_self_switches[[data[0], data[1], data[2]]] = false
          @inrangeev = nil
        # 덫, 지뢰 함정
        elsif self_10_sw == 5
          if obj_size?(target, @sensor) or (battler.mhp*0.5) >= battler.hp or collide_with_characters?(self.x, self.y) or $game_player.follower_passable?(self.x, self.y)
            # 덫, 지뢰 함정 센서 진행
            $game_self_switches[[data[0], data[1], data[2]]] = true
            @inrangeev = true
          end
        # 화살 함정
        elsif self_10_sw == 7
          if (battler.mhp*0.5) >= battler.hp or collide_with_characters?(self.x, self.y) or $game_player.follower_passable?(self.x, self.y)
            # 화살 함정 센서 진행
            $game_self_switches[[data[0], data[1], data[2]]] = true
            @inrangeev = true
          elsif obj_size?(target, @sensor) and $game_self_switches[[data[0], data[1], data[2]]] == false
            # 화살 함정 센서 진행
            $game_self_switches[[data[0], data[1], data[2]]] = true
            @inrangeev = true
          elsif !obj_size?(target, @sensor) and $game_self_switches[[data[0], data[1], data[2]]] == true
            # 화살 함정 센서 종료
            $game_self_switches[[data[0], data[1], data[2]]] = false
            @inrangeev = nil
          end
        # 횃불, 양초
        elsif self_10_sw == 4 and $game_self_switches[[data[0], data[1], "D"]] == false
          if battler.hp < 1
            # 양초 사망
            $game_self_switches[[data[0], data[1], "D"]] = true
            @inrangeev = nil
          end
          if obj_size?(target, @sensor) and $sel_time_frame == 7
            # 양초 온기 상태이상 적용 진행
            unless @list.nil?
              for command in @list
                if command.code == 108 && command.parameters[0].include?("[light")
                  $game_party.members.each {|actor|already_dead = actor.dead?
                  actor.add_state(123)
                  actor.perform_collapse_effect if actor.dead? and !already_dead
                  }
                  $game_party.clear_results
                  return
                end
              end
            end
          end
        # 문, 파리
        elsif self_10_sw == 6 and battler.hp < 1 and $game_self_switches[[data[0], data[1], "D"]] == false
          # 문, 파리 사망
          $game_self_switches[[data[0], data[1], "D"]] = true
          @inrangeev = nil
        # 상자
        elsif self_10_sw == 2 and obj_size?(target, @sensor)
          if battler.hp == 0
            # 상자 폭발 준비
            $game_self_switches[[data[0], data[1], data[2]]] = true
            @inrangeev = true
          end
        end
      end
    # ----------------------------------------------------------------------------
    # 함정이 아닌 기본 몬스터인 경우
    # ----------------------------------------------------------------------------
    elsif @sensor != nil and battler.dead? == false and battler != nil

      # 일반 몬스터, 3번 몬스터가 아니면 취소
      return if self_10_sw != 3 and self_10_sw != nil

      # 플레이어의 상태 이상에 따른 센서 적용
      if self_10_sw == 3 and $sel_time_frame == 20
        @sensor -= 1 if $game_actors[7].state?(134) == true   # 악취 1 감소
        @sensor -= 3 if $game_actors[7].state?(66) == true    # 기척차단 3 감소
        @sensor += 4 if $game_actors[7].state?(137) == true   # 달거리 4 증가
        @sensor += 4 if $game_actors[7].state?(13) == true    # 출혈 4 증가
        @sensor += 3 if $game_actors[7].state?(23) == true    # 발정 3 증가
        @sensor += 2 if $game_actors[7].state?(135) == true   # 상처 2 증가
        @sensor += 4 if $game_actors[7].state?(115) == true   # 달달함 4 증가

        # 몬스터의 상태 이상에 따른 센서 적용
        @sensor = 2 if battler.state?(3) == true              # 실명 2 로 고정
        @sensor = 2 if 2 >= @sensor
      end

      # 풀 체력인데, 시체 상태라면 다시 살린다.
      if battler.hp == battler.mhp and $game_self_switches[[$game_map.map_id, self.id, "C"]] = true
        $game_self_switches[[$game_map.map_id, self.id, "C"]] = false
      end
          
      if !obj_size?(target, @sensor+4) and $game_self_switches[[data[0], data[1], data[2]]] == true
        # 실명 상태, 에르니 사망한 상태 추격 종료
        if battler.state?(3) == true or $game_switches[44] == true
          $game_self_switches[[data[0], data[1], data[2]]] = false
          @inrangeev = nil
        # 최대 체력인 경우 추격 종료
        elsif !obj_size?(target, @sensor) and battler.hp == battler.mhp and $game_switches[190] == false
          $game_self_switches[[data[0], data[1], data[2]]] = false
          @inrangeev = nil
        end
      else
        # 타겟이 센서 범위에 있다, 추격 진행
        if $game_self_switches[[data[0], data[1], data[2]]] == false
          if obj_size?(target, @sensor) or battler.hp != battler.mhp or $game_switches[190] == true
            $game_self_switches[[data[0], data[1], data[2]]] = true
            @inrangeev = true
          end
        # 빙결, 석화 상태 및 행동 불가 상태이상인 경우
        elsif battler.restriction >= 4
          #print("032 + Game_Event - %s, 행동 불가 상태 \n" % [battler.name]);
          $game_self_switches[[data[0], data[1], data[2]]] = false
          @inrangeev = nil
        end
      end
    end
  end

  def on_battle_pixel?(out=0)
    w = Graphics.width + out; h = Graphics.height + out
    return true if screen_x.between?(0 - out,w) and screen_y.between?(0 - out,h)
    return false
  end

  def cmt_data(comment)
    return 0 if @list.nil? or @list.size <= 0
    for item in @list
      if item.code == 108 or item.code == 408
        return $1.to_i if item.parameters[0] =~ /#{comment}(.*)>/i
      end
    end
    return 0
  end

  def string_data(comment)
    return nil if @list.nil? or @list.size <= 0
    for item in @list
      if item.code == 108 or item.code == 408
        return $1.to_s if item.parameters[0] =~ /#{comment}(.*)>/i
      end
    end
    return nil
  end

  # 이벤트 이동 중지
  alias falcaopearl_update_self_movement update_self_movement
  def update_self_movement
    return if !@boom_grabdata.nil?
    return if force_stopped? || @blowpower[0] > 0
    falcaopearl_update_self_movement
  end
  
  alias :clear_starting_flag_ve_light_effects :clear_starting_flag
  def clear_starting_flag
    clear_starting_flag_ve_light_effects
    @lantern = 0
    $game_map.screen.remove_light.push("EV#{@id}")
    refresh_lights if @page
  end
  
  def refresh_lights
    case note
    when /[light 2]/i
      set_light("EV#{@id}", "torch_m_3", 255, 25, 1)
    when /[light 3]/i
      set_light("EV#{@id}", "light_s", 255, 25, 1)
    when /[light 8]/i
      set_light("EV#{@id}", "torch_m", 255, 25, 1)
    when /[light 6]/i
      set_light("EV#{@id}", "light_s_3", 255, 25, 1)
    when /[light 5]/i
      set_light("EV#{@id}", "light_s_4", 255, 25, 1)
    end
  end
  
  # 반짝이는 효과, s 값 ' + Game_LightBitmap' 갱신하지 않는다.
  def set_light(id, name, op = 255, v = 0, s = 0, x = 0, y = 0, z = 100)
    value = [id, name, {:event => @id}, op, x, y, v, s, z].compact
    $game_map.screen.lights[id] = $game_map.set_light(*value)
    $game_map.screen.remove_light.delete(id)
  end
  
  def name
    @event.name
  end
  
  def event?
    return true
  end
  
  def erased?
    @erased
  end
  
  def setup_character_ex_effects
    return if @list == nil
    for command in @list
      if command.code == 108
         if command.parameters[0] =~ /<Effects = ([^>]*)>/
            @effects = [$1,0,true]
         end   
         if command.parameters[0] =~ /<Zoom = (\d+)>/i 
            @zoom_x = $1.to_i
            @zoom_y = @zoom_x
         end   
         if command.parameters[0] =~ /<Opacity = (\d+)>/i 
            @opacity = $1.to_i
         end   
         if command.parameters[0] =~ /<Blend Type = (\d+)>/i
            #print("097_2.캐릭터 효과 - 블렌드 타입 적용 \n")
            @blend_type = $1.to_i
         end 
         if command.parameters[0] =~ /<Mirror = (\w+)>/i
            @mirror = $1
         end
      end
    end
  end

  # 이벤트의 주석을 확인한다.
  def note
    return ""     if !@page || !@page.list || @page.list.size <= 0
    return @notes if @notes && @page.list == @note_page
    #print("135.Game_Event - 주석 확인 \n");
    @note_page = @page.list.dup
    comment_list = []
    @page.list.each do |item|
      next unless item && (item.code == 108 || item.code == 408)
      comentario = item.parameters[0]
      arg = comentario.split
      if arg[0].include?("[light")
        comment_list.push(item.parameters[0])
      end
      if arg[0] == "[name]"
        if arg[3] != nil
          @namepop = arg[1]+" "+arg[2]+" "+arg[3]
        elsif arg[2] != nil
          @namepop = arg[1]+" "+arg[2]
        else
          @namepop = arg[1]
        end
      elsif arg[0] == "[at_name]"
        @namepop = $game_actors[arg[1].to_i].name
      elsif arg[0] == "[q_name]"
        @namepop = arg[1].to_i
      # 의뢰, 퀘스트 이모티콘
      elsif arg[0] == "[qest_id]"
        @qest_id = 0
        @qest_id = arg[1].to_i
        @namepop = "Q"
      end
    end
    @notes = comment_list.join("\r\n")
    @notes
  end
end