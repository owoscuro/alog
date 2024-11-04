# encoding: utf-8
# Name: 116.Game_CharacterBase
# Size: 80105
# encoding: utf-8
# Name: 116.Game_CharacterBase
# Size: 80088
($imported ||= {})["Falcao Pearl ABS Liquid"] = true

class Game_CharacterBase
  include CHARACTER_EX_EFFECTS_COMMAND
  
  attr_accessor :ms_speed_trail_enable, :ms_speed_trail_rhythm,
                :ms_speed_trail_delay, :ms_speed_trail_blend_type,
                :ms_speed_trail_opacity, :ms_speed_trail_wave_amp,
                :ms_speed_trail_wave_length, :ms_speed_trail_wave_speed,
                :ms_speed_trail_blur_level, :ms_speed_trail_limit,
                :ms_speed_trail_color
  attr_accessor :move_speed
  attr_accessor :move_frequency
  attr_accessor :lantern
  attr_accessor :index_r
  attr_accessor :just_hitted, :anime_speed, :blowpower, :targeting, :x, :y
  attr_accessor :battler_guarding, :knockdown_data, :colapse_time, :opacity
  attr_accessor :zoomfx_x, :zoomfx_y, :targeted_character, :stuck_timer
  attr_accessor :send_dispose_signal, :follower_attacktimer, :stopped_movement, :stopped_movement_2
  attr_accessor :hookshoting, :battler_chain, :pattern, :user_move_distance
  attr_accessor :move_speed, :through, :being_grabbed, :making_spiral
  attr_accessor :direction, :direction_fix, :zfx_bol, :buff_pop_stack
  attr_accessor :die_through, :target_index, :using_custom_g, :combodata
  attr_accessor :originalasp, :doingcombo, :angle_fx
  attr_accessor :user_iconset, :pro_iconset, :respawn_count
  attr_accessor :tool_distance
  attr_accessor :event_speed
  attr_accessor :next_frame
  
  attr_accessor :effects, :opacity, :erased, :zoom_x
  attr_accessor :zoom_y, :mirror, :angle, :blend_type
  
  alias falcaopearl_abmain_ini initialize
  def initialize
    @zfx_bol = false
    @just_hitted = 0
    @anime_speed = 0
    @respawn_count = 0
    @blowpower = [0, dir=2, dirfix=false, s=4, wait_reset=0]
    @user_casting = [0, nil]
    @send_dispose_signal = false
    @targeting = [false, item=nil, char=nil]
    @stopped_movement = 0
    @stopped_movement_2 = 0
    @follower_attacktimer = 0
    set_hook_variables
    @target_index = 0
    @using_custom_g = false
    @combodata = []
    @angle = 0
    @angle_fx = 0.0
    @zoom_x = 1.00
    @zoom_y = 1.00
    @zoomfx_x = 1.0
    @zoomfx_y = 1.0
    @stuck_timer = 0
    @battler_guarding = [false, nil]
    @knockdown_data = [0, nil, nil, nil, nil]
    @state_poptimer = [0, 0]
    @making_spiral = false
    @buff_pop_stack = []
    @doingcombo = 0
    @range_view = 2
    @originalasp = 0
    @tool_distance = 0
    @effects = ["",0,false]
    @mirror = false
    
    falcaopearl_abmain_ini
    
    @event_speed = 0
    @next_frame = 1
  end
  
  alias :init_public_members_ve_light_effects :init_public_members
  def init_public_members
    init_public_members_ve_light_effects
    @lantern = 0
    # 팔로워 조명 추가 실험
    @index_r = ""
  end
  
  def player?
    return false
  end
  
  def event?
    return false
  end
  
  def follower?
    return false
  end
  
  def vehicle?
    return false
  end
  
  def frames
    return 3
  end
  
  def hue
    @hue ? @hue : 0
  end
  
  alias :update_ve_light_effects :update
  def update
    update_ve_light_effects
    # --------------------------------------------------------------------------
    # 아래는 시간 가속중이 아닌 경우에만 적용
    # --------------------------------------------------------------------------
    if $game_switches[283] == false or $game_map.map_id == 21
      update_falcao_pearl_abs
      # 프레임 조작
      #return unless Graphics.frame_count % 2 == 0
      update_character_ex_effects
      update_lantern
    end
  end
  
  def update_lantern(forced = false)
    diag = $imported[:ve_diagonal_move] && diagonal?
    if @lantern != 0 && ((!diag && @lantern_direction != @direction) ||
       (diag && @lantern_direction != @diagonal) || forced)
      @lantern_direction = (diag ? @diagonal : @direction)
      light = setup_lantern
      $game_map.screen.lights[light.id] = light if light != nil
    elsif @lantern == 0 && @lantern_direction
      id = event? ? "EL#{@id}" : "AL#{@id}"
      $game_map.screen.remove_light.push(id) if $game_map.screen.remove_light
      @lantern_direction = nil
    end
    $game_map.screen.shade.show
    if $game_variables[30] != $game_variables[6] or $game_variables[399] != $game_map.map_id
      # 외부인 경우
      if !$game_map.map.no_weather
      #print("116.Game_CharacterBase - update_lantern, 외부 \n");
        case $game_variables[6]
          when 0..2;        $game_variables[82] = 250
            red   = -60;    green = 70;     blue  = 90
          when 3..4;        $game_variables[82] = 170
            red   = 10;     green = 15;     blue  = 20
          when 5..7;        $game_variables[82] = 40
            red   = 30;     green = 10;     blue  = 10
          when 8..10;       $game_variables[82] = 20
            red   = 40;     green = 0;      blue  = 5
          when 11..16;      $game_variables[82] = 0
            red   = 0;      green = 0;      blue  = 0
          when 17..19;      $game_variables[82] = 20
            red   = 0;      green = 10;     blue  = 10
          when 20;          $game_variables[82] = 100
            red   = 0;      green = 20;     blue  = 30
          when 21;          $game_variables[82] = 140
            red   = -10;    green = 30;     blue  = 40
          when 22..23;      $game_variables[82] = 200
            red   = -20;    green = 40;     blue  = 60
          when 24;          $game_variables[82] = 240
            red   = -40;    green = 60;     blue  = 70
          else;             $game_variables[82] = 20
            red   = 0;      green = 20;     blue  = 30
          end
        $game_map.screen.shade.blend = 2
        $game_map.screen.shade.set_color(red, green, blue)
        # 중단하도록 이전 시간 대입
        $game_variables[30] = $game_variables[6]
        $game_variables[399] = $game_map.map_id
      # 동굴인 경우
      elsif $game_map.map.no_weather and $game_map.map.is_forest?
        #print("116.Game_CharacterBase - update_lantern, 동굴 \n");
        case $game_variables[153]
          when 0;           $game_variables[82] = 240
            red   = -40;    green = 60;     blue  = 70
          when 1;           $game_variables[82] = 240
            red   = -80;    green = 170;     blue  = -120
          when 2;           $game_variables[82] = 240
            red   = 170;    green = -80;     blue  = -120
          when 3;           $game_variables[82] = 240
            red   = -120;   green = -80;     blue  = 170
          else;             $game_variables[82] = 240
            red   = -40;    green = 60;     blue  = 70
        end
        $game_map.screen.shade.blend = 2
        $game_map.screen.shade.set_color(red, green, blue)
        # 중단하도록 이전 시간 대입
        $game_variables[30] = $game_variables[6]
        $game_variables[399] = $game_map.map_id
      # 내부
      elsif $game_map.map.no_weather
        #print("116.Game_CharacterBase - update_lantern, 내부 \n");
        $game_variables[82] = 40
        red   = 40;     green = 0;      blue  = 5
        # 고양이 눈
        if $game_actors[7].skill_learn?($data_skills[325])
          $game_variables[82] -= 48
          $game_variables[82] = 0 if 1 > $game_variables[82]
        end
        $game_map.screen.shade.blend = 2
        $game_map.screen.shade.set_color(red, green, blue)
        # 중단하도록 이전 시간 대입
        $game_variables[30] = $game_variables[6]
        $game_variables[399] = $game_map.map_id
      end
    end
    # 고양이 눈
    if $game_actors[7].skill_learn?($data_skills[325])
      $game_map.screen.shade.opacity = $game_variables[82] - 48
    else
      $game_map.screen.shade.opacity = $game_variables[82]
    end
  end

  def setup_lantern
    #print("116.Game_CharacterBase - 플레이어, 동료, 이벤트 랜턴 적용 \n");
    # 팔로워 조명 추가
    id = event? ? "EL#{@id}" : "AL#{@index_r}"
    type = event? ? :event : :actor
    name = 'torch_m'
    
    # 조명 아이템 초기화
    @zoom_eq = ""
    
    # 조명 아이템 입력
    if @index_r != nil
      if $game_party.battle_members[@index_r.to_i-1] != nil
        if $game_actors[$game_party.members()[@index_r.to_i-1].id].equips[9] != nil
          @zoom_eq = $game_actors[$game_party.members()[@index_r.to_i-1].id].equips[9].equip_number
        end
      end
    end

    # 조명 아이템 적용
    zoom = 100 if @zoom_eq == ""
    zoom = 160 if @zoom_eq == "192"
    zoom = 180 if @zoom_eq == "193"
    zoom = 240 if @zoom_eq == "194"

    if $game_actors[7].skill_learn?($data_skills[65])
      zoom += 100
    end

    # 조명 아이템 입력
    if @index_r != nil
      if $game_party.battle_members[@index_r.to_i-1] != nil
        value = [id, name, {type => @index_r.to_i}, @lantern, 0, 0, 0, 0, zoom]
        $game_map.set_light(*value)
      end
    end
  end
  
  def clear_effects
    @effects = ["",0,false]
    @zoom_x = 1.00
    @zoom_y = 1.00
    @mirror = false
    @angle = 0
    @opacity = 255
    @blend_type = 0
  end
  
  # 이동 속도 최종 결정
  def real_move_speed
    if $game_variables[MOVE_CONTROL::DASH_PLUS] >= 0
      if self.battler.is_a?(Game_Actor)
        dash_plus = 1 + ($game_variables[MOVE_CONTROL::DASH_PLUS] * 0.1)
        @move_speed + (dash? ? dash_plus : 0)
      elsif self.battler.is_a?(Game_Enemy)
        @move_speed + @event_speed
      else
        @move_speed
      end
    end
  end
  
  def update_anime_count
    if moving? && @walk_anime
      @anime_count += @next_frame + 0.5
    elsif @step_anime || @pattern != @original_pattern
      @anime_count += @next_frame
    end
  end
  
  def set_hook_variables
    @hookshoting = [on=false, hooking=false, grabing=false, delay=0]
    @battler_chain = []
    @user_move_distance = [steps=0, speed=nil, trought=nil, cor=nil, evmove=nil]
    @being_grabbed = false
  end
 
  # 발사체 좌표 확인
  def projectiles_xy_nt(x, y)
    $game_player.projectiles.select {|pro| pro.pos_nt?(x, y) }
  end
  
  # 발사체와 충돌
  def collide_with_projectiles?(x, y)
    projectiles_xy_nt(x, y).any? do |pro|
      pro.normal_priority? || self.is_a?(Projectile)
    end
  end
  
  def zoom(x, y)
    @zoomfx_x = x
    @zoomfx_y = y
  end
  
  alias falcaopearl_collide_with collide_with_characters?
  def collide_with_characters?(x, y)
    return true if collide_with_projectiles?(x, y)
    falcaopearl_collide_with(x, y)
  end
  
  # 문자 직선 및 대각선을 따르십시오.
  def follow_char(character)
    sx = distance_x_from(character.x)
    sy = distance_y_from(character.y)
    if sx != 0 && sy != 0
      move_diagonal(sx > 0 ? 4 : 6, sy > 0 ? 8 : 2)
    elsif sx != 0
      move_straight(sx > 0 ? 4 : 6)
    elsif sy != 0
      move_straight(sy > 0 ? 8 : 2)
    end
  end

  # 화면에 배틀러가 있는지 여부
  def on_battle_screen?(out = 0)
    max_w = (Graphics.width / 32).to_i - 1
    max_h = (Graphics.height / 32).to_i - 1
    sx = (screen_x / 32).to_i
    sy = (screen_y / 32).to_i
    if sx.between?(0 - out, max_w + out) and sy.between?(0 - out, max_h + out)
      return true
    end
    return false
  end

  # 특정 타일로 점프
  def jumpto_tile(x, y)
    jumpto(0, [x, y])
  end

  # 점프, 0 = 게임 플레이어, 1 이상 이벤트 ID
  def jumpto(char_id, tilexy=nil)
    char_id > 0 ? char = $game_map.events[char_id] : char = $game_player
    tilexy.nil? ? condxy = [char.x, char.y] : condxy = [tilexy[0], tilexy[1]]
    jx = + eval_distance(tilexy.nil? ? char : tilexy)[0] if condxy[0] >= @x
    jy = - eval_distance(tilexy.nil? ? char : tilexy)[1] if condxy[1] <= @y
    jx = - eval_distance(tilexy.nil? ? char : tilexy)[0] if condxy[0] <= @x
    jy = - eval_distance(tilexy.nil? ? char : tilexy)[1] if condxy[1] <= @y
    jx = - eval_distance(tilexy.nil? ? char : tilexy)[0] if condxy[0] <= @x
    jy = + eval_distance(tilexy.nil? ? char : tilexy)[1] if condxy[1] >= @y
    jx = + eval_distance(tilexy.nil? ? char : tilexy)[0] if condxy[0] >= @x
    jy = + eval_distance(tilexy.nil? ? char : tilexy)[1] if condxy[1] >= @y
    @direction_fix = true       # 방향 전환 고정
    jump(jx, jy)
    turn_toward_event(char_id)  # 플레이어 방향 전환
    @direction_fix = false      # 방향 전환 고정 해제
  end

  # 적중률 낮은 경우
  def jumpto_miss(char_id, tilexy=nil)
    char_id > 0 ? char = $game_map.events[char_id] : char = $game_player
    case rand(7)
      when 0
    tilexy.nil? ? condxy = [char.x+1, char.y] : condxy = [tilexy[0]+1, tilexy[1]]
      when 1
    tilexy.nil? ? condxy = [char.x-1, char.y] : condxy = [tilexy[0]-1, tilexy[1]]
      when 2
    tilexy.nil? ? condxy = [char.x, char.y+1] : condxy = [tilexy[0], tilexy[1]+1]
      when 3
    tilexy.nil? ? condxy = [char.x, char.y-1] : condxy = [tilexy[0], tilexy[1]-1]
      when 4
    tilexy.nil? ? condxy = [char.x-1, char.y-1] : condxy = [tilexy[0]-1, tilexy[1]-1]
      when 5
    tilexy.nil? ? condxy = [char.x+1, char.y-1] : condxy = [tilexy[0]+1, tilexy[1]-1]
      when 6
    tilexy.nil? ? condxy = [char.x-1, char.y+1] : condxy = [tilexy[0]-1, tilexy[1]+1]
      when 7
    tilexy.nil? ? condxy = [char.x+1, char.y+1] : condxy = [tilexy[0]+1, tilexy[1]+1]
    end
    jx = + eval_distance(tilexy.nil? ? char : tilexy)[0] if condxy[0] >= @x
    jy = - eval_distance(tilexy.nil? ? char : tilexy)[1] if condxy[1] <= @y
    jx = - eval_distance(tilexy.nil? ? char : tilexy)[0] if condxy[0] <= @x
    jy = - eval_distance(tilexy.nil? ? char : tilexy)[1] if condxy[1] <= @y
    jx = - eval_distance(tilexy.nil? ? char : tilexy)[0] if condxy[0] <= @x
    jy = + eval_distance(tilexy.nil? ? char : tilexy)[1] if condxy[1] >= @y
    jx = + eval_distance(tilexy.nil? ? char : tilexy)[0] if condxy[0] >= @x
    jy = + eval_distance(tilexy.nil? ? char : tilexy)[1] if condxy[1] >= @y
    @direction_fix = true       # 방향 전환 고정
    jump(jx, jy)
    turn_toward_event(char_id)  # 플레이어 방향 전환
    @direction_fix = false      # 방향 전환 고정 해제
  end

  # 점프 2, 0 = 게임 플레이어, 1 이상 이벤트 ID
  def jumpto2(char_id, tilexy=nil)
    char_id > 0 ? char = $game_map.events[char_id] : char = $game_player
    tilexy.nil? ? condxy = [char.x, char.y] : condxy = [tilexy[0], tilexy[1]]
    jx = + eval_distance(tilexy.nil? ? char : tilexy)[0] if condxy[0] >= @x
    jy = - eval_distance(tilexy.nil? ? char : tilexy)[1] if condxy[1] <= @y
    jx = - eval_distance(tilexy.nil? ? char : tilexy)[0] if condxy[0] <= @x
    jy = - eval_distance(tilexy.nil? ? char : tilexy)[1] if condxy[1] <= @y
    jx = - eval_distance(tilexy.nil? ? char : tilexy)[0] if condxy[0] <= @x
    jy = + eval_distance(tilexy.nil? ? char : tilexy)[1] if condxy[1] >= @y
    jx = + eval_distance(tilexy.nil? ? char : tilexy)[0] if condxy[0] >= @x
    jy = + eval_distance(tilexy.nil? ? char : tilexy)[1] if condxy[1] >= @y
    jump3(jx, jy)
    if not moving?
      self.move_backward
    end
  end

  # 거리 계산
  def eval_distance(target)
    if target.is_a?(Array)
      distance_x = (@x - target[0]).abs
      distance_y = (@y - target[1]).abs
    else
      distance_x = (@x - target.x).abs
      distance_y = (@y - target.y).abs
      # 타겟 거리 제한
      if PearlKernel.tool_distance != nil
        @tool_distance = PearlKernel.tool_distance
        if @tool_distance >= 1
          distance_x -= distance_x - @tool_distance if distance_x > @tool_distance
          distance_y -= distance_y - @tool_distance if distance_y > @tool_distance
        end
      end
    end
    return [distance_x, distance_y] 
  end

  # 게임 플레이어와 팔로워가 작업을 실행 중인지 확인
  def battler_acting?
    return true if @user_casting[0] >= 1 || @targeting[0]
    return true if @knockdown_data[0] >= 1 and battler.deadposing.nil?
    return true if @anime_speed.to_i >= 1
    return true if @hookshoting[0] || @making_spiral
    # 멤버가 2명 이상인 경우에만 팔로워 시스템 작동
    if self.is_a?(Game_Player) and $game_party.members.size >= 2
      $game_player.followers.each {|f| return true if f.battler_acting?}
    end
    return false
  end
  
  def battler
  end
  
  def use_weapon(id)
    return unless tool_can_use?
    process_tool_action($data_weapons[id])
  end
  def use_item(id)
    return unless tool_can_use?
    process_tool_action($data_items[id])
  end
  def use_skill(id)
    return unless tool_can_use?
    process_tool_action($data_skills[id]) if id != nil and id != 'nil' and id != 0
  end
  def use_armor(id)
    return unless tool_can_use?
    process_tool_action($data_armors[id]) if id != nil and id != 'nil' and id != 0
  end

  def rand_weapon(*args)
    return unless tool_can_use?
    process_tool_action($data_weapons[args[rand(args.size)]])
  end
  def rand_item(*args)
    return unless tool_can_use?
    process_tool_action($data_items[args[rand(args.size)]])
  end
  def rand_skill(*args)
    return unless tool_can_use?
    process_tool_action($data_skills[args[rand(args.size)]])
  end
  def rand_armor(*args)
    return unless tool_can_use?
    process_tool_action($data_armors[args[rand(args.size)]])
  end
  
  def tool_can_use?
    #print("116.Game_CharacterBase - tool_can_use? 시작 \n");
    return false if @hookshoting[0] || @making_spiral
    return false if @user_casting[0] >= 1 || @targeting[0]
    return false if battler.nil?
    return false if battler.dead?
    if @doingcombo >= 1 || @battler_guarding[0]
      #print("116.Game_CharacterBase - doingcombo[%s]로 취소 \n" % [@doingcombo]);
      return false
    end
    return false if $game_message.busy?
    #print("116.Game_CharacterBase - tool_can_use? 종료 \n");
    return true
  end
  
  # 타겟을 선택
  def load_target_selection(item)
    @targeting[0] = true; @targeting[1] = item
    if self.is_a?(Game_Player)
      $game_player.pearl_menu_call = [:battler, 2]
    elsif self.is_a?(Game_Follower)
      @targeting[2] = @targeted_character
      #print("116.Game_CharacterBase - 스킬 타겟 대상 %s \n" % [@targeting[2]]);
      @targeting = [false, item=nil, char=nil] if @targeting[2].nil?
    elsif self.is_a?(Projectile)
      if user.is_a?(Game_Player)
        user.targeting[0] = true; user.targeting[1] = item
        $game_player.pearl_menu_call = [:battler, 2]
      end
      if user.is_a?(Game_Follower)
        @targeting[2] = user.targeted_character
        @targeting = [false, item=nil, char=nil] if @targeting[2].nil?
      end
    end
  end
  
  def playdead
    @angle_fx = 90
  end

  def resetplaydead
    @angle_fx = 0.0
  end

  # 작업 취소
  def force_cancel_actions
    #@user_casting[0] = 0
    @anime_speed = 0
  end

  def speed(x)
    @move_speed = x
  end

  def anima(x)
    @animation_id = x
  end

  # 근접 매개변수 적용
  def apply_weapon_param(weapon, add)
    id = 0
    if weapon != nil  # 오류 수정
      for param in weapon.params
        add ? battler.add_param(id, param) : battler.add_param(id, -param)
        id += 1
      end
    end
  end

  # 데미지, 손상 텍스트를 표시
  def pop_damage(custom=nil)
    $game_player.damage_pop.push(DamagePop_Obj.new(self, custom))
  end

  # 대상이 이동할 수 없는지 확인
  def force_stopped?
    return true if @user_casting[0] > 0   # 캐스팅 시간이 있는 경우 이동 금지
    return true if @stopped_movement > 0  # 경직시 이동 금지
    return true if @anime_speed.to_i > 0 || @knockdown_data[0] > 0 || @hookshoting[0] || @angle_fx != 0.0
    return true if @making_spiral
    if self.is_a?(Game_Actor)
      return true if self.actor.dead? # 사망한 경우 움직이지 않도록 수정
      return true if self.set_custom_bio[19].to_i == 1
    end
    return false
  end

  # 타겟을 대상으로 범위, 센서 확인
  def obj_size?(target, size)
    return false if size.nil?
    distance = (@x - target.x).abs + (@y - target.y).abs
    enable   = (distance <= size-1)
    return true if enable
    return false
  end

  # size, 범위 및 거리가 동일한지 확인
  def obj_size_ok?(target, size)
    return false if size.nil?
    distance = (@x - target.x).abs + (@y - target.y).abs
    enable   = (distance == size-1)
    return true if enable
    return false
  end
  
  # 좌표를 대상으로 범위, 센서 확인
  def obj_size_xy?(target_x, target_y, size)
    return false if size.nil?
    distance = (@x - target_x).abs + (@y - target_y).abs
    enable   = (distance <= size-1)
    return true if enable
    return false
  end

  # 대상의 몸 사이즈 확인
  def body_size?(target, size)
    distance = (@x - target[0]).abs + (@y - target[1]).abs
    enable   = (distance <= size-1)
    return true if enable
    return false
  end

  def faceto_face?(target)
    return true if @direction == 2 and target.direction == 8
    return true if @direction == 4 and target.direction == 6
    return true if @direction == 6 and target.direction == 4
    return true if @direction == 8 and target.direction == 2
    return false
  end

  def adjustcxy
    push_x, push_y =   0,   1 if @direction == 2
    push_x, push_y = - 1,   0 if @direction == 4
    push_x, push_y =   1,   0 if @direction == 6
    push_x, push_y =   0, - 1 if @direction == 8
    return [push_x, push_y]
  end

  def in_frontof?(target)
    return true if @direction == 2 and @x == target.x and (@y+1) == target.y
    return true if @direction == 4 and (@x-1) == target.x and @y == target.y
    return true if @direction == 6 and (@x+1) == target.x and @y == target.y
    return true if @direction == 8 and @x == target.x and (@y-1) == target.y
    return false
  end

  # 루프 맵을 무시하고 맵 가장자리 감지
  def facing_corners?
    case $game_map.map.scroll_type
    when 1 then return false if @direction == 2 || @direction == 8
    when 2 then return false if @direction == 4 || @direction == 6
    when 3 then return false
    end
    m = $game_map
    unless @x.between?(1, m.width - 2) && @y.between?(1, m.height - 2)
      return true if @x == 0 and @direction == 4
      return true if @y == 0 and @direction == 8
      return true if @x == m.width  - 1  and @direction == 6
      return true if @y == m.height - 1  and @direction == 2
    end
    return false
  end

  # 아이템 사용 가능 테스트
  def usable_test_passed?(item)
    #return true if battler.is_a?(Game_Enemy) && item.is_a?(RPG::Item)

    # 공격중, 혹은 캐스팅 중이면 이동 취소
    return false if self.anime_speed.to_i >= 1
    #return false if self.user_casting[0].to_i >= 1
    
    itemcost = item.tool_data("Tool Item Cost = ")
    #invoke = item.tool_data("Tool Invoke Skill = ")
        
    #if item.is_a?(RPG::Skill) || item.is_a?(RPG::Item)
      if battler.is_a?(Game_Actor)
        if itemcost != nil and itemcost != 0
          if !battler.usable?($data_items[itemcost]) or !battler.usable?(item)
            # 사용불가능한 경우 이모티콘 적용
            self.balloon_id = 25
            return false
          end
        elsif !battler.usable?(item)
          # 사용불가능한 경우 이모티콘 적용
          self.balloon_id = 25
          return false
        end
      else
        if !battler.usable?(item)
          # 사용불가능한 경우 이모티콘 적용
          self.balloon_id = 25
          return false
        end
      end
    #end
    return true
  end

  # 도구를 처리하고 사용할 수 있는지 확인
  def process_tool_action(item)
    PearlKernel.load_item(item)

    # 공격, 스킬 사거리 미달시 생략
    if item.is_a?(RPG::Skill) or item.is_a?(RPG::Item)
      if item.scope == 1 or item.scope == 2
        # 팔로어만 해당한다.
        if battler.is_a?(Game_Actor) and !battler.is_a?(Game_Player) and @targeted_character != nil
          @ro_dist = 0
          @ro_dist = item.tool_data("Tool Distance = ")
          @ro_dist += item.tool_data("Tool Size = ") if item.tool_data("Tool Size = ") >= 2
          @ro_dist = 1 if 1 > @ro_dist
          if obj_size?(@targeted_character, @ro_dist)
            turn_toward_event(@targeted_character)
          else
            #print("116.Game_CharacterBase - 거리 미달로 취소 \n");
            return
          end
          # 타겟 공격이 아닌데, 좌표가 달라서 공격, 스킬을 취소한다.
          if item.tool_data("Tool Target = ") != "true" and item.tool_data("Tool Special = ") != "autotarget"
            if self.x != @targeted_character.x and self.y != @targeted_character.y
              #print("116.Game_CharacterBase - 거리 미달로 취소 \n");
              return
            end
          end
        end
      end
    end
    
    return if !battler.tool_ready?(item)
    unless PearlKernel.has_data?
      return if item == nil
      if item.is_a?(RPG::Weapon) || item.is_a?(RPG::Armor)
        msgbox('Tool data missing') if $DEBUG
        return
      end
      if item.scope.between?(1, 6)
        msgbox('Tool data missing') if $DEBUG
        return
      elsif item.scope == 0 and self.is_a?(Game_Player)
            # 오류 메세지 표시 실험 -----------------------
          $game_temp.pop_w(180, 'SYSTEM', "  No tienes ningún ítem '%s'.  " % [item.name])
          # -------------------------------------------
          Sound.play_buzzer
          return
      elsif !battler.usable?(item) and self.is_a?(Game_Player)
        if battler.restriction >= 4  # Verificar si no puede actuar
          # Error: mostrar mensaje -----------------------
          $game_temp.pop_w(180, 'SYSTEM', "  No puedes actuar en este estado.  ")
          # -------------------------------------------
          Sound.play_buzzer
          return
        else
          # Error: mostrar mensaje -----------------------
          $game_temp.pop_w(180, 'SYSTEM', "  No tienes ningún ítem '%s'.  " % [item.name])
          # -------------------------------------------
          Sound.play_buzzer
        end
      end
    end
    
    if PearlKernel.has_data? and not usable_test_passed?(item)
      RPG::SE.new("Cursor1", 80).play if self.is_a?(Game_Player)
      return
    end
    
    if PearlKernel.has_data?
      @user_casting = [PearlKernel.tool_castime, item]
      #print("116.Game_CharacterBase - 캐스팅 시간 %s, 이름 %s \n" % [@user_casting[0], @user_casting[1].name]);
      # 지팡이 숙련도
      if self.is_a?(Game_Player) or self.is_a?(Game_Follower)
        if (battler.equips[0] != nil and battler.equips[0].wtype_id == 9) or
          (battler.equips[1] != nil and battler.equips[1].is_a?(RPG::Weapon) and battler.equips[1].wtype_id == 9)
          @tool_cast_pls = 0
          @tool_cast_pls += 3 if battler.skill_learn?($data_skills[485])
          @tool_cast_pls += 3 if battler.skill_learn?($data_skills[486])
          @tool_cast_pls += 3 if battler.skill_learn?($data_skills[487])
          @tool_cast_pls += 3 if battler.skill_learn?($data_skills[488])
          @tool_cast_pls += 30 if battler.skill_learn?($data_skills[489])
          if @user_casting[0].to_i >= 1
            @user_casting[0] = (@user_casting[0] - @tool_cast_pls).to_i
            @user_casting[0] = 0 if 0 >= @user_casting[0]
          end
        end
      end
    end
    
    # 업적 추가
    if battler != nil
      if self.is_a?(Game_Player) and item.is_a?(RPG::Item) and 10 >= battler.hp
        # 체력 회복 아이템
        item.effects.each_with_index do |effect|
          case effect.code
          when 11 # HP 회복
            # 구사일생 업적 획득
            $game_party.gain_medal(27)
          end
        end
      end
    end
    
    # 캐릭터 조작 금지 스위치, 스킬, 아이템 사용시 이름 대사, 외치기
    if $game_switches[52] == false and $game_message.visible == false
      if item.is_a?(RPG::Skill) or item.is_a?(RPG::Item)
        if self.is_a?(Game_Enemy) or self.is_a?(Game_Player) or self.is_a?(Game_Follower)
          # 콤보 관련된 스킬 이름은 표기 생략
          if item.name =~ /-/i or item.name =~ /대화/i
          else
            text = nil
            text = "#{item.name}!"
            self.mrbt = text if text != nil
          end
        end
      else
        text = nil
      end
      # 캐스팅 시간 확인
      if @user_casting[0].to_i >= 1
        @animation_id = 0
        @animation_id = PearlKernel.tool_castanimation
      else
        #print("116.Game_CharacterBase - 아이템 실행[1], %s \n" % [item]);
        load_abs_tool(item)
      end
    end
  end

  # 복근 도구 로드
  def load_abs_tool(item)
    # 경직이 생겨도 스킬 캔슬 안되도록 수정
    #print("116.Game_CharacterBase - 공격 1, %s \n" % [item.name]);
    
    if self.battler.is_a?(Game_Actor)
      if self.battler.skill_learn?($data_skills[491]) == false
        return if @stopped_movement > 0
      end
    elsif self.battler.is_a?(Game_Enemy) and self.battler.boss_hud == false
      return if @stopped_movement > 0
    end
    return if @knockdown_data[0] > 0
    
    #print("116.Game_CharacterBase - 아이템 실행[1], %s \n" % [item]);
    PearlKernel.load_item(item)
    
    return if self.is_a?(Game_Follower) and @targeted_character.nil?
    
    @test_ro_tool_target = PearlKernel.tool_target
    
    # 지옥 룬 나비 착용시 타겟 지정을 오토타겟으로 지정
    if self.is_a?(Game_Player)
      if $game_actors[7].equips[3] != nil and self.battler.id == 7 and item.is_a?(RPG::Skill)
        if $game_actors[7].equips[3].equip_number == "AE"
          if item.id == 34 or item.id == 35 or item.id == 42 or item.id == 227 or 
            item.id == 228 or item.id == 229
            @test_ro_tool_target = false
          end
        end
      end
    end
    
    if !@targeting[0] and self.battler.is_a?(Game_Actor)
      if $game_switches[200] == true
        # 타겟 지정 진행시 스탠딩 이미지 제거
        if @test_ro_tool_target == "true"
          $game_map.screen.pictures[10].erase
          $game_map.screen.pictures[9].erase
          $game_map.screen.pictures[8].erase
          $game_map.screen.pictures[7].erase
          $game_map.screen.pictures[6].erase
          $game_map.screen.pictures[5].erase
          $game_map.screen.pictures[4].erase
          $game_map.screen.pictures[3].erase
          $game_map.screen.pictures[2].erase
          # 에르니 이미지 변경시 갱신할 것, 스위치
          $game_switches[195] = true if $game_switches[195] == false
        end
      end
      # 스킬, 아이템 아이템에 타겟 적용
      if item.is_a?(RPG::Skill) or item.is_a?(RPG::Item)
        if @test_ro_tool_target == "true"
          if item.scope == 7 or item.scope == 9
            # 팔로워가 1명이면 그냥 에르니 선택하도록 수정
            if $game_party.members.size > 1
              # 팔로워 선택
              #print("116.Game_CharacterBase - load_target_selection[1] \n")
              load_target_selection(item)
              return
            end
          else
            # 적 선택
            load_target_selection(item)
            return
          end
        elsif item.scope == 7 or item.scope == 9
          if $game_party.members.size > 1
            # 팔로워 선택
            load_target_selection(item)
            return
          else
            # 동료가 1명이지만 커먼이벤트가 있는 스킬, 아이템인 경우 진행한다.
            item.effects.each {|effects| 
              if effects.code == 44 and !$game_temp.common_event_reserved?
                load_target_selection(item)
                return
              end
            }
          end
        end
      else
        # 호출된 스킬을 무기와 갑옷에 대상 구문 분석 적용
        invoke = PearlKernel.tool_invoke
        if invoke != nil && invoke > 0 && invoke != 1 && invoke != 2
          invokeskill = $data_skills[invoke]
          if @test_ro_tool_target == "true" || invokeskill.scope == 7 || invokeskill.scope == 9
            load_target_selection(item)
            return
          end
        # 호출하지 않고 일반 무기 및 갑옷에 대상 적용
        else
          if @test_ro_tool_target == "true"
            load_target_selection(item)
            return
          end
        end
      end
    end
    
    if item.is_a?(RPG::Skill) || item.is_a?(RPG::Item)
      #print("116.Game_CharacterBase - 스킬, 아이템 사용 %s \n" % [battler.id])
      battler.use_item(item)
      # 공격, 스킬 사거리 미달시 생략
      if item.scope == 1 or item.scope == 2
        if battler.is_a?(Game_Enemy)
          if !@enemy.object
            @agroto_f.nil? ? target = $game_player : target = @agroto_f
            @ro_dist = 0
            @ro_dist = item.tool_data("Tool Distance = ")
            @ro_dist += item.tool_data("Tool Size = ")
            @ro_dist += 3
            return if !obj_size?(target, @ro_dist)
          end
        elsif battler.is_a?(Game_Actor) and !battler.is_a?(Game_Player) and @targeted_character != nil
          @ro_dist = 0
          @ro_dist = item.tool_data("Tool Distance = ")
          @ro_dist += item.tool_data("Tool Size = ") if item.tool_data("Tool Size = ") >= 2
          @ro_dist = 1 if 1 > @ro_dist
          # 타겟이 있어서 방향을 전환한다.
          if obj_size?(@targeted_character, @ro_dist)
            turn_toward_event(@targeted_character)
          else
            #print("116.Game_CharacterBase - 거리 미달로 취소 \n");
            return
          end
          # 타겟 공격이 아닌데, 좌표가 달라서 공격, 스킬을 취소한다.
          if item.tool_data("Tool Target = ") != "true" and item.tool_data("Tool Special = ") != "autotarget"
            if self.x != @targeted_character.x and self.y != @targeted_character.y
              #print("116.Game_CharacterBase - 거리 미달로 취소 \n");
              return
            end
          end
        end
      end
    end
    
    # 도구에 데이터가 있는 경우 계속
    if PearlKernel.has_data?
      consume_ammo_item(item) if battler.is_a?(Game_Actor) and PearlKernel.tool_itemcost != 0
      
      # 해당 캐릭터의 민첩, 공격 속도 만큼 공격속도 감소
      @ro_atk_speed = (100 + battler.atk_speed - (battler.param(6)*0.01)).to_f / 100
      
      # 쿨다운 조절 부분
      @anime_speed = PearlKernel.user_animespeed.to_i
      
      # 쿨다운 적용한 부분
      @item_cool_rown = PearlKernel.tool_cooldown * @ro_atk_speed

      # 무기 타입 별로 공격속도 낮추기
      if battler.is_a?(Game_Actor) and battler.equips[0] != nil
        case battler.equips[0].wtype_id
          when 1; @item_cool_rown += 4 * 60   # 도끼
          when 2
            #@item_cool_rown += 0 * 60   # 너클
            @item_cool_rown -= 60 if battler.skill_learn?($data_skills[460])
            @item_cool_rown -= 60 if battler.skill_learn?($data_skills[461])
            @item_cool_rown -= 60 if battler.skill_learn?($data_skills[462])
            @item_cool_rown -= 60 if battler.skill_learn?($data_skills[463])
            @item_cool_rown -= 60 if battler.skill_learn?($data_skills[464])
            
            # 투기 상태 적용
            if battler.state?(199)
              battler.add_state(199)
            elsif !battler.state?(199) and battler.state?(198)
              battler.add_state(199); battler.remove_state(198)
            elsif !battler.state?(198) and battler.state?(197)
              battler.add_state(198); battler.remove_state(197)
            elsif !battler.state?(197) and battler.state?(196)
              battler.add_state(197); battler.remove_state(196)
            elsif !battler.state?(196) and battler.state?(195)
              battler.add_state(196); battler.remove_state(195)
            elsif !battler.state?(195) and battler.state?(194)
              battler.add_state(195); battler.remove_state(194)
            elsif !battler.state?(194) and battler.state?(193)
              battler.add_state(194); battler.remove_state(193)
            elsif !battler.state?(193) and battler.state?(192)
              battler.add_state(193); battler.remove_state(192)
            elsif !battler.state?(192) and battler.state?(191)
              battler.add_state(192); battler.remove_state(191)
            elsif !battler.state?(191) and battler.state?(190)
              battler.add_state(191); battler.remove_state(190)
            elsif !battler.state?(190)
              battler.add_state(190)
            end
            
          when 3; @item_cool_rown += 2 * 60   # 창
          when 4; @item_cool_rown += 4 * 60   # 검
          when 5
            @item_cool_rown += 4 * 60   # 도
            @add_state_rate = 0
            @add_state_rate += 1 if battler.skill_learn?($data_skills[453])
            @add_state_rate += 1 if battler.skill_learn?($data_skills[454])
            @add_state_rate += 1 if battler.skill_learn?($data_skills[455])
            @add_state_rate += 1 if battler.skill_learn?($data_skills[456])
            @add_state_rate += 1 if battler.skill_learn?($data_skills[457])
            if rand(9) >= @add_state_rate
              battler.add_state(185)      # 발도
            else
              battler.remove_state(185)   # 발도 상태 제거
            end
          when 6; @item_cool_rown += 2 * 60   # 활
          when 7; @item_cool_rown += 0 * 60   # 단검
          when 8; @item_cool_rown += 2 * 60   # 메이스
          when 9; @item_cool_rown += 2 * 60   # 지팡이
          else; @item_cool_rown += 2 * 60     # Otros
        end
        # 쿨타임 감소 스킬
        @item_cool_rown -= 60 if battler.skill_learn?($data_skills[322])
        @item_cool_rown -= 60 if battler.skill_learn?($data_skills[323])
      end
      
      @item_cool_rown = @item_cool_rown - (@item_cool_rown % 60)
      @item_cool_rown = 0 if 1 > @item_cool_rown

      battler.apply_cooldown(item, @item_cool_rown.to_i)
    end
    
    # 스프라이트 좌표 조작
    if @character_name != "!$A_Warp" and @character_name != "$Sign_9" and
      @character_name != "!Torchlight_0" and @character_name != "!Torchlight_1" and 
      @character_name != "!Torchlight_2" and @character_name != "!Torchlight_3" and 
      @character_name != "!Torchlight_4" and @character_name != "!$Torchlight4" and 
      @character_name != "!$Map_Window_1" and @character_name != "!$Map_Window_2" and 
      @character_name != "!$Map_Window_3" and @character_name != "!$Map_Window_4" and 
      @character_name != "!$Map_Window_5" and @character_name != "!Trap_1" and 
      @character_name != "!Door_1" and @character_name != "!Door_2" and 
      @character_name != "!Door_3" and @character_name != "!Trap_2" and
      @character_name != "!$Quest" and @character_name != "Sign3_Quest_Scroll" and
      @character_name != "!$Other_27" and @character_name != "!$Other_27_2" and
      @character_name != "!Trap_1_2" and @character_name != "!Trap_2_2"
      if $game_map.map_id == 21
        @next_x = -1
        @next_y = -17
      else
        if battler.is_a?(Game_Actor)
          @next_x_orj = 0
          @next_y_orj = 0
          @next_x = 0
          @next_y = -7
        elsif battler.is_a?(Game_Enemy)
          if @next_x_orj == 0 and @next_y_orj == 0
            @next_x = 0
            @next_y = -7
          elsif @next_x_orj != 0 or @next_y_orj != 0
            @next_x = @next_x_orj
            @next_y = @next_y_orj
          end
        end
        case self.direction
          when 2; @next_y += 10
          when 4; @next_x -= 10
          when 6; @next_x += 10
          when 8; @next_y -= 10
        end
      end
    end
    
    # 이도류 적용
    if battler.is_a?(Game_Actor)
      if battler.equips[1].is_a?(RPG::Weapon) and item.is_a?(RPG::Skill)
        #print("116.Game_CharacterBase - 스킬 타입, %s \n" % [item.stype_id]);
        create_projectile_object(item)
        create_anime_sprite_object(item)
        if item.stype_id == 1 or item.stype_id == 2
          create_projectile_object(item)
          create_anime_sprite_object(item)
        end
      else
        create_projectile_object(item)
        create_anime_sprite_object(item)
      end
    else
      create_projectile_object(item)
      create_anime_sprite_object(item)
    end
  end

  # 발사체 생성
  def create_projectile_object(item)
    if PearlKernel.tool_special == "hook"
      PearlKernel.tool_distance.times {|i|
      $game_player.projectiles.push(Projectile.new(self, item, i))}
      @hookshoting[0] = true
    elsif PearlKernel.tool_special == "triple"        # 발사체 3개
      for i in [:uno, :dos, :tres]
        $game_player.projectiles.push(Projectile.new(self, item, i))
      end
    elsif PearlKernel.tool_special == "quintuple"     # 발사체 5개
      for i in [:uno, :dos, :tres, :cuatro, :cinco]
        $game_player.projectiles.push(Projectile.new(self, item, i))
      end
    elsif PearlKernel.tool_special == "octuple"       # 발사체 8개
      for i in [:uno, :dos, :tres, :cuatro, :cinco, :seis, :siete, :ocho]
        $game_player.projectiles.push(Projectile.new(self, item, i))
      end
    else # 기본 발사체 로드
      $game_player.projectiles.push(Projectile.new(self, item))
    end
  end

  # 사용자 애니메이션 스프라이트 생성
  def create_anime_sprite_object(item)
    $game_player.anime_action.each {|i|
    if i.user == self
      if i.custom_graphic
        @transparent = false 
        i.user.using_custom_g = false
      end
      $game_player.anime_action.delete(i)
    end}
    if PearlKernel.user_graphic != "nil"
      return if PearlKernel.user_graphic.nil?
      $game_player.anime_action.push(Anime_Obj.new(self, item))
    end
    # 아이콘 스프라이트 생성
    if PearlKernel.user_graphic == "nil" and !item.tool_data("User Iconset = ", false).nil?
      return if PearlKernel.user_graphic.nil?
      $game_player.anime_action.push(Anime_Obj.new(self, item))
    end
  end

  # 탄약 아이템 소모
  def consume_ammo_item(item)
    itemcost = $data_items[PearlKernel.tool_itemcost]
    return if item.is_a?(RPG::Item) and item.consumable and item == itemcost
    battler.use_item(itemcost)
  end
  
  def update_character_ex_effects
    return if @effects == nil
    return if @erased or @effects[0] == ""
    check_new_effect if @effects[2]
    case @effects[0] 
    when "Breath";        update_breath_effect
    when "Ghost";         update_ghost_effect
    when "Big Breath";    update_big_breath_effect
    when "Slime Breath";  update_slime_breath_effect
    when "Spin Loop";     update_spin_loop_effect
    when "Swing Loop";    update_swing_loop_effect
    when "Crazy";         update_crazy_effect
    when "Appear";        update_appear_effect
    when "Disappear";     update_disappear_effect
    when "Swing";         update_swing_effect
    when "Spin";          update_spin_effect
    when "Dwarf";         update_dwarf_effect
    when "Giant";         update_giant_effect
    when "Normal";        update_normal_effect
    end
  end

  def check_new_effect
    #print("116.Game_CharacterBase - check_new_effect \n");
    @effects[2] = false
    @effects[1] = 0
    unless @effects[0] == "Normal"
           @opacity = 255
           @angle = 0
           @mirror = false
           unless (@effects[0] == "Dwarf" or @effects[0] == "Giant") 
                @zoom_x = 1.00
                @zoom_y = 1.00
           end
    end
    case @effects[0]
       when "Breath"
          @effects[1] = rand(60)
       when "Appear"
          @zoom_x = 0.1
          @zoom_y = 3.5
          @opacity = 0
       when "Ghost"
          @opacity = rand(255)
       when "Swing Loop"
          @angle = 20
          @effects[1] = rand(60)
       when "Spin Loop"
          @angle = rand(360)
       when "Slime Breath"
          @effects[1] = rand(60)
       when "Big Breath"
          @effects[1] = rand(60)
       when "Normal"
          pre_angle = 360 * (@angle / 360).truncate
          @angle = @angle - pre_angle
          @angle = 0 if @angle < 0
    end
  end  
  
  def update_breath_effect
    #print("116.Game_CharacterBase - update_breath_effect \n");
    @effects[1] += 1
    case @effects[1]
    when 0..25
      @zoom_y += 0.005
      if @zoom_y > 1.12
        @zoom_y = 1.12
        @effects[1] = 26
      end  
    when 26..50
      @zoom_y -= 0.005
      if @zoom_y < 1.0 
        @zoom_y = 1.0
        @effects[1] = 51
      end           
    else
      @zoom_x = 1
      @zoom_y = 1
      @effects[1] = 0 
    end
  end
  
  def update_ghost_effect
    #print("116.Game_CharacterBase - update_ghost_effect \n");
    @effects[1] += 1
    case @effects[1]
    when 0..55
      @opacity += 5
      @effects[1] = 56 if @opacity >= 255
    when 56..120
      @opacity -= 5
      @effects[1] = 121 if @opacity <= 0
    else
      @opacity = 0
      @effects[1] = 0
    end 
  end  

  def update_swing_loop_effect
    #print("116.Game_CharacterBase - update_swing_loop_effect \n");
    @effects[1] += 1
    case @effects[1]
    when 0..40
      @angle -= 1
      if @angle < -19
          @angle = -19
          @effects[1] = 41
      end  
    when 41..80 
      @angle += 1
      if @angle > 19
          @angle = 19
          @effects[1] = 81
      end   
    else
      @angle = 20
      @effects[1] = 0
    end
  end

  def update_swing_effect
    #print("116.Game_CharacterBase - update_swing_effect \n");
    @effects[1] += 1
    case @effects[1]
    when 0..20
      @angle -= 1
    when 21..60 
      @angle += 1
    when 61..80  
      @angle -= 1
    else
      clear_effects
    end
  end
  
  def update_spin_loop_effect
    #print("116.Game_CharacterBase - update_spin_loop_effect \n");
    @angle += 3
  end  
  
  def update_spin_effect
    #print("116.Game_CharacterBase - update_spin_effect \n");
    @angle += 10
    clear_effects if @angle >= 360
  end    
  
  def update_slime_breath_effect
    #print("116.Game_CharacterBase - update_slime_breath_effect \n");
    @effects[1] += 1
    case @effects[1]
    when 0..30
      @zoom_x += 0.005
      @zoom_y -= 0.005
      if @zoom_x > 1.145 
        @zoom_x = 1.145
        @zoom_y = 0.855
        @effects[1] = 31
      end             
    when 31..60
      @zoom_x -= 0.005
      @zoom_y += 0.005    
      if @zoom_x < 1.0
        @zoom_x = 1.0
        @zoom_y = 1.0
        @effects[1] = 61
      end             
    else
      @zoom_x = 1
      @zoom_y = 1.0
      @effects[1] = 0 
    end
  end  
 
  def update_big_breath_effect
    #print("116.Game_CharacterBase - update_big_breath_effect \n");
    @effects[1] += 1
    case @effects[1]
     when 0..30
       @zoom_x += 0.02
       @zoom_y = @zoom_x 
       if @zoom_x > 1.6
          @zoom_x = 1.6
          @zoom_y = @zoom_x
          @effects[1] = 31
       end
     when 31..60
       @zoom_x -= 0.02
       @zoom_y = @zoom_x 
       if @zoom_x < 1.0
          @zoom_x = 1.0
          @zoom_y = @zoom_x 
          @effects[1] = 61 
       end   
     else
       @zoom_x = 1
       @zoom_y = 1
       @effects[1] = 0 
    end
  end
  
  def update_disappear_effect
    #print("116.Game_CharacterBase - update_disappear_effect \n");
    @zoom_x -= 0.01
    @zoom_y += 0.05
    @opacity -= 3      
  end
  
  def update_appear_effect
    #print("116.Game_CharacterBase - update_appear_effect \n");
    @zoom_x += 0.02
    @zoom_x = 1.0 if @zoom_x > 1.0
    @zoom_y -= 0.05
    @zoom_y = 1.0 if @zoom_y < 1.0
    @opacity += 3
    clear_effects if @opacity >= 255
  end

  def update_crazy_effect
    #print("116.Game_CharacterBase - update_crazy_effect \n");
    @effects[1] += 1
    case @effects[1]
     when 1..5
       @mirror = false
     when 6..10
       @mirror = true
     else
       @mirror = false
       @effects[1] = 0 
    end
  end

  def update_dwarf_effect
    #print("116.Game_CharacterBase - update_dwarf_effect \n");
    if @zoom_x > 0.5
       @zoom_x -= 0.01
       @zoom_y -= 0.01
    end
  end

  def update_giant_effect
    #print("116.Game_CharacterBase - update_giant_effect \n");
    if @zoom_x < 1.8
       @zoom_x += 0.01
       @zoom_y += 0.01
    end
  end

  def update_normal_effect  
    #print("116.Game_CharacterBase - update_normal_effect \n");
    if @zoom_x > 1.0 
       @zoom_x -= 0.01
       @zoom_x = 1.0 if @zoom_x < 1.0  
    elsif @zoom_x < 1.0 
       @zoom_x += 0.01
       @zoom_x = 1.0 if @zoom_x > 1.0              
    end
    if @zoom_y > 1.0 
       @zoom_y -= 0.01
       @zoom_y = 1.0 if @zoom_y < 1.0  
    elsif @zoom_y < 1.0 
       @zoom_y += 0.01
       @zoom_y = 1.0 if @zoom_y > 1.0              
    end        
    if @opacity < 255
      @opacity += 2 
      @opacity = 255 if @opacity > 255
    end
    if @angle > 0 
      @angle -= 5 
      @angle = 0 if @angle < 0
    end
    if (@zoom_x == 1.0 and @zoom_y == 1.0 and @opacity == 255 and @angle == 0)
      clear_effects
    end
  end
  
  # 팔카오 펄 복근 메인 업데이트
  def update_falcao_pearl_abs
    # 진행 중지 -----------------------------------------------------------------
    return if HM_SEL::time_stop?
    return if battler.nil?
    # --------------------------------------------------------------------------
    update_pearlabs_timing
    if self.is_a?(Game_Follower) && self.visible?
      if @user_move_distance[0] > 0 and not moving?
        move_forward if battler.set_custom_bio[19].to_i != 1
        @user_move_distance[0] -= 1
      end
    else
      if @user_move_distance[0] > 0 and not moving?
        move_forward
        @user_move_distance[0] -= 1
      end
    end
    update_followers_attack if self.is_a?(Game_Follower) && self.visible?
    if @targeting[2] != nil
      load_abs_tool(@targeting[1]) if battler.is_a?(Game_Actor)
      @targeting = [false, item = nil, char = nil]
    end
    update_battler_collapse if @knockdown_data[1] != nil
    update_state_effects2
    @combodata.each {|combo|
    if combo[1] != "nil"
      #print("116.Game_CharacterBase - 콤보 데이터 %s, %s, %s, %s \n" % [combo[0], combo[1], combo[2], combo[3]]);
      if combo[3] > 0
        combo[3] -= 1
        if combo[3] == 0
          perform_combo(combo[0], combo[1], combo[2])
          @combodata.delete(combo)
        end
        break
      end
    # 후크, 갈고리 콤보는 유지한다.
    elsif !@hookshoting[0]
      @combodata.delete(combo)
    end
    }
  end

  def perform_combo(kind, id, jumpp)
    if jumpp == 'jump'
      jump(0, 0)
      move_forward
    end
    case kind
      when :weapon then use_weapon(id)
      when :armor  then use_armor(id)
      when :item   then use_item(id)
      when :skill  then use_skill(id)
    end
    @doingcombo = 12
  end

  # 팔로워 장비
  def fo_tool
    # 무기 없으면 주먹으로 변경
    if actor.primary_use == 1
      if actor.equips[0] != nil
        return actor.equips[0]
      else
        return $data_weapons[130]
      end
    end
    return actor.equips[1]       if actor.primary_use == 2
    return actor.assigned_item   if actor.primary_use == 3
    return actor.assigned_item2  if actor.primary_use == 4
    return actor.assigned_skill  if actor.primary_use == 5
    return actor.assigned_skill2 if actor.primary_use == 6
    return actor.assigned_skill3 if actor.primary_use == 7
    return actor.assigned_skill4 if actor.primary_use == 8
    return actor.assigned_skill5 if actor.primary_use == 9
    return actor.assigned_skill6 if actor.primary_use == 10
    return actor.assigned_skill7 if actor.primary_use == 11
    return actor.assigned_skill8 if actor.primary_use == 12
    return actor.assigned_item3  if actor.primary_use == 13
    return actor.assigned_item4  if actor.primary_use == 14
  end

  # 팔로워 공격 엔진
  def update_followers_attack
    # 진행 중지 -----------------------------------------------------------------
    return if HM_SEL::time_stop?
    # --------------------------------------------------------------------------
    if @targeted_character != nil
      if fo_tool.nil? || battler.dead? || $game_switches[283] == true || $game_switches[196] == false
        #print("116.Game_CharacterBase - 타겟을 지운다. \n");
        @targeted_character = nil
        return
      end
    end
    # 경직, 캐스팅이 있는 경우 팔로워 공격 취소
    if @stopped_movement > 0 or @user_casting[0].to_i >= 1
      #print("116.Game_CharacterBase - 경직, 캐스팅 시간 있어서 공격 취소 \n");
      return
    end
    # --------------------------------------------------------------------------
    if @follower_attacktimer > 0
      @follower_attacktimer -= 1
      if @follower_attacktimer == 40 and !moving?
        r = rand(3)
        if battler.set_custom_bio[19].to_i != 1
          move_random if r == 0 || r == 1
          move_away_from_character(@targeted_character) if !@targeted_character.nil? and r == 2
        end
      end
    end
    
    if @targeted_character != nil and @targeted_character.is_a?(Game_Player)
      if all_enemies_dead?
        delete_targetf
        return
      end
      use_predefined_tool
      return
    end

    # 스킬이 적을 위한 것이라면 계속
    if @targeted_character != nil
      use_predefined_tool
      return if @targeted_character.nil?
      # 대상이 죽은 경우 재설정
      if @targeted_character.collapsing?
        #print("116.Game_CharacterBase - 타겟이 죽어서 행동 취소한다. \n");
        force_cancel_actions
        delete_targetf
      end
    elsif $game_switches[283] == false
      # 팔로워가 선택한 대상을 선택
      $game_player.followers.each do |follower|
        if !follower.targeted_character.nil?
          # 맵 이동 가능 여부
          $game_switches[143] = false
          # 대상이 죽은 경우 패스
          if follower.targeted_character.collapsing?
            follower.targeted_character = nil
          end
          next if follower.targeted_character.is_a?(Game_Player)
          if follower.stuck_timer >= 10
            follower.targeted_character = nil
            return
          end
          @targeted_character = follower.targeted_character
          break
        end
      end
    end
  end

  # 도구 사용 준비
  def setup_followertool_usage
    @range_view = 2
    @range_view = 6 if fo_tool.tool_data("Tool Target = ", false) == "true" ||
    fo_tool.tool_data("Tool Special = ", false) == "autotarget"

    if fo_tool.is_a?(RPG::Skill) || fo_tool.is_a?(RPG::Item)
      if fo_tool.scope.between?(1, 6)
        setup_target 
      else ; @targeted_character = $game_player
        @range_view = 6
      end
    # 인보크 팔로워를 위한 준비 도구
    elsif fo_tool.is_a?(RPG::Weapon) || fo_tool.is_a?(RPG::Armor)
      invoke = fo_tool.tool_data("Tool Invoke Skill = ")
      if invoke > 0
        if $data_skills[invoke].scope.between?(1, 6)
          setup_target
        else ; @targeted_character = $game_player
          @range_view = 6
        end
      else
        # 인보크 스킬이 아니라 적 타겟을 설정하기만 하면 됩니다.
        setup_target
      end
    end
  end

  # 미리 정의된 도구를 사용
  def use_predefined_tool
    update_follower_movement
    return if @targeted_character.nil?
    #update_follower_movement
    
    # 타겟 추적시 거리 리셋
    @ro_dist = 1
    @ro_dist = $game_actors[actor.id].set_custom_bio[18].to_i
    @ro_dist = 1 if @ro_dist == 0
    
    #print("116.Game_CharacterBase - %s, 를 사용한다. \n" % [actor.primary_use]);
    
    # 팔로워 공격 진행
    if obj_size?(@targeted_character, @ro_dist + 1) && @follower_attacktimer == 0
      turn_toward_character(@targeted_character)
      #actor.primary_use = rand(11) + 1
      use_weapon(fo_tool.id) if actor.primary_use == 1
      use_weapon(fo_tool.id) if actor.primary_use == 2
      use_item(fo_tool.id)   if actor.primary_use == 3 || actor.primary_use == 4
      if actor.primary_use == 5 || actor.primary_use == 6 || actor.primary_use == 7 || actor.primary_use == 8 ||
        actor.primary_use == 9 || actor.primary_use == 10 || actor.primary_use == 11 || actor.primary_use == 12
        use_skill(fo_tool.id)
      end
      @follower_attacktimer = 70
    end
  
    # 자동 전투 off 면 기존 타겟 제거
    if self.actor.dead? or $game_switches[196] == false
      #print("116.Game_CharacterBase - 행동, 타겟 취소 \n");
      force_cancel_actions
      delete_targetf
    end
  end
  
  def all_enemies_dead?
    for event in $game_map.event_enemies.select{|event| event.enemy_ready? and event.on_battle_screen?}
      return false if $game_player.obj_size?(event,PearlKernel::PlayerRange+1)
    end
    return true
  end
  
  def delete_targetf
    @targeted_character = nil
  end
  
  # 팔로워 이동 공격
  def reset_targeting_settings(target)
    target.being_targeted = false if target.is_a?(Game_Event) or $game_switches[283] == true or $game_switches[196] == false
    delete_targetf
    @stuck_timer = 0
  end

  def update_follower_movement
    # 진행 중지 -----------------------------------------------------------------
    return if HM_SEL::time_stop?
    # --------------------------------------------------------------------------
    target = @targeted_character
    
    return if target.is_a?(Game_Player)
    return if stopped_any?
    return if moving?
    return if @anime_speed.to_i >= 1
    return if @user_casting[0].to_i >= 1
    
    # 팔로워가 공격을 진행한 이후면 이동 취소
    return if @follower_attacktimer >= 1
    
    if $game_switches[196] == false
      reset_targeting_settings(target)
      return
    end
    
    # 팔로워가 도구를 사용할 수 없는 경우
    unless usable_test_passed?(fo_tool)
      if SceneManager.scene_is?(Scene_Map)
        reset_targeting_settings(target)
        #@balloon_id = PearlKernel::FailBalloon
        return
      end
    end

    return if target.nil?
    
    # 타겟 추적시 거리 리셋
    @ro_dist = 1
    @ro_dist = battler.set_custom_bio[18].to_i
    @ro_dist = 1 if @ro_dist == 0
    
    @stuck_timer += 1 if !obj_size?(target, @ro_dist) and !moving?
    
    if moving? || @anime_speed.to_i > 0 || @making_spiral || @hookshoting[0] ||
      @knockdown_data[0] > 0
      @stuck_timer = 0
    end
    
    #return if moving?

    if fo_tool.tool_data("Tool Target = ", false) == "true" || fo_tool.tool_data("Tool Special = ", false) == "autotarget" || target.is_a?(Game_Player)
      # 스킬 타겟 트루 매직 사용
      cpu_reactiontype(1, target, 0)
      return
    end
    
    if fo_tool.is_a?(RPG::Skill) || fo_tool.is_a?(RPG::Item)
      fo_tool.scope.between?(1, 6) ? cpu_reactiontype(2, target, @ro_dist) : cpu_reactiontype(1, target, @ro_dist)
    else
      # 표적이 없는 무기 갑옷용
      cpu_reactiontype(2, target, @ro_dist)
    end

    #return if target.is_a?(Game_Player)
    #return if stopped_any?
    
    # 팔로워가 공격을 진행한 이후면 이동 취소
    #return if @follower_attacktimer >= 1

    # 팔로워 공격 ai 설정
    if !moving? and target != nil
    #if !moving? and target != nil and 1 > @anime_speed.to_i
      case rand(40)
        when 1
          if battler.set_custom_bio[19].to_i != 1
            move_backward
          end
        when 2
          setup_target
        when 3
          if !moving?
            if @ro_dist >= 3 and obj_size?(target, @ro_dist - 2) and rand(10) == 10
              move_backward
            elsif !obj_size?(target, @ro_dist) and battler.set_custom_bio[19].to_i != 1
              pathfind(target.x + rand(1) - 1, target.y + rand(1) - 1)
              #find_path(target.x + rand(1) - 1, target.y + rand(1) - 1, @ro_dist)
            end
          end
        else
          if !moving?
            if @ro_dist >= 3 and obj_size?(target, @ro_dist - 2) and rand(10) == 10
              move_backward
            elsif !obj_size?(target, @ro_dist) and battler.set_custom_bio[19].to_i != 1
              pathfind(target.x, target.y)
              #find_path(target.x, target.y, @ro_dist)
            end
          else
            turn_toward_event(target)
          end
        end
      turn_toward_event(target)
    end
  end

  # CPU 반응
  def cpu_reactiontype(type, target, dist)
    # 진행 중지 -----------------------------------------------------------------
    return if HM_SEL::time_stop?
    return if target == nil
    return if battler.set_custom_bio[19].to_i == 1
    # 팔로워 이동 스킬, 무기 사거리 적용 ---------------------------------------------
    #print("116.Game_CharacterBase - ");
    if !moving?
      if type == 1
        if !obj_size?(target, @ro_dist)
          #print("CPU 반응[type, 1], 타겟 - 접근 \n");
          move_toward_character(target)
        else
          #print("CPU 반응[type, 1], 타겟 - 방향 전환 \n");
          turn_toward_event(target)
        end
      elsif type == 2
        if !obj_size?(target, @ro_dist)
          #print("CPU 반응[type, 2], 타겟 - 좌표 이동 \n");
          pathfind(target.x, target.y)
        else
          #print("CPU 반응[type, 2], 타겟 - 방향 전환 \n");
          turn_toward_event(target)
        end
      end
    else
      #print("CPU 반응[moving?], 타겟 - 방향 전환 \n");
      turn_toward_event(target)
    end
  end

  # 파워 블로우, 넉백
  def update_blow_power_effect
    # 생략
  end

  # 진주 타이밍
  def update_pearlabs_timing
    # 피격 시간 감소
    @just_hitted -= 1 if @just_hitted >= 1
    # 빙고 콤보 시간 감소
    @doingcombo -= 1 if @doingcombo >= 1
    # 경직 시간 감소
    if @stopped_movement >= 1
      @stopped_movement -= 1
      if battler.is_a?(Game_Actor)
        @stopped_movement -= 1 if battler.skill_learn?($data_skills[371])
        @stopped_movement -= 1 if battler.skill_learn?($data_skills[372])
        @stopped_movement -= 1 if battler.skill_learn?($data_skills[373])
        @stopped_movement -= 1 if battler.skill_learn?($data_skills[374])
        @stopped_movement -= 1 if battler.skill_learn?($data_skills[375])
      end
    end
    # 후크 액션 시간 감소
    if @hookshoting[3] > 0
      @hookshoting[3] -= 1
      if @hookshoting[3] == 0
        @hookshoting = [false, false, false, 0] 
        @user_move_distance[3].being_grabbed = false if
        @user_move_distance[3].is_a?(Game_Event)
        @user_move_distance[3] = nil
      end
    end
    # 애니메이션 시간 감소
    if @anime_speed.to_i >= 1
      @pattern = 0 
      @anime_speed -= 1
    end
    # 캐스팅 시간 감소
    if @user_casting[1] != nil
      #print("116.Game_CharacterBase - ");
      #print("캐스팅 시간 감소 진행 %s \n" % [@user_casting[0]]);
      if @user_casting[0].to_i >= 1
        @user_casting[0] -= 1
        if 0 >= @user_casting[0]
          load_abs_tool(@user_casting[1])
          #print("스킬 사용 1, @user_casting 초기화 \n");
          @user_casting = [0, nil]
        end
      elsif !self.is_a?(Game_Player) and self.is_a?(Game_Actor)
        load_abs_tool(@user_casting[1])
        #print("스킬 사용 2, @user_casting 초기화 \n");
        @user_casting = [0, nil]
      end
    end
    update_knockdown if @knockdown_data[0] > 0
  end
  
  def all_fourdead?
    m = $game_party.battle_members
    return true if m[0].dead? && m[1].dead? && m[2].dead? && m[3].dead?
    return false
  end
  
  def update_battler_collapse
    if @knockdown_data[1] != nil
      force_cancel_actions
      if battler.is_a?(Game_Enemy)
        # 몬스터 사망시 겹치기 및 효과 적용
        @die_through = @through if @die_through.nil?
        # 아래 조건 생략시 계속 죽는다, 경험치도 계속 들어온다.
        if @knockdown_data[1] != nil and @killed == false
          #print("116.Game_CharacterBase - ");
          #print("몬스터 사망 진행, %s \n" % [battler.name]);
          apply_collapse_anime(battler.collapse_type)
          @secollapse = true
          self.kill_enemy
          @through = true
        end
      end
    end
  end

  # 사망 적용
  def apply_collapse_anime(type)
    if @deadposee
      #print("116.Game_CharacterBase - ");
      #print("사망 적용, 피 애니메이션 진행 \n");
      @animation_id = 178 if !battler.object
      @knockdown_data[0] = 2
    end
  end

  # 사망 확인
  def update_knockdown
    @knockdown_data[0] -= 1
    @knockdown_data[0] <= 0 ? knowdown_effect(2) : knowdown_effect(1)
    if @knockdown_data[1] != nil
      #print("116.Game_CharacterBase - ");
      #print("사망 확인, 패턴, 방향 대입 \n");
      @pattern = @knockdown_data[2]
      @direction = @knockdown_data[3]
    end
  end

  # 사망 이팩트
  def knowdown_effect(type)
    return if self.is_a?(Projectile)
    if battler.is_a?(Game_Enemy)
      self_sw = PearlKernel::KnockdownSelfW
      if self.knockdown_enable and battler.dead?
        force_cancel_actions
        @knockdown_data[1] = self_sw
        @knockdown_data[2] = @pattern
        @knockdown_data[3] = @direction
        @next_y_orj += 7
        if @knockdown_data[1] != nil
          $game_self_switches[[$game_map.map_id, self.id, @knockdown_data[1]]] = true
        else
          $game_self_switches[[$game_map.map_id, self.id, "C"]] = true
        end
        self.through = true
        self.direction_fix = true
        self.refresh
        #print("116.Game_CharacterBase - ");
        #print("몬스터 사망 확인, %s \n" % [battler.name]);
        # 업적 추가
        if battler.name =~ /도적/i
          $game_variables[330] += 1
          if $game_variables[330] >= 500
            $game_party.gain_medal(25)
          end
        elsif battler.name =~ /철창/i
          $game_variables[333] += 1
          if $game_variables[333] >= 100
            $game_party.gain_medal(30)
          end
        elsif battler.name =~ /고블린/i
          $game_variables[334] += 1
          if $game_variables[334] >= 1000
            $game_party.gain_medal(31)
          end
        end
      end
    end
  end

  # 상태이상 적용 확인
  def update_state_effects2
    # 캐릭터 조작 금지 스위치, 퀘스트 보드
    return if $game_switches[52] == true or $game_switches[186] == true
    if $sel_time_frame_10 == 2
      if $game_switches[86] == false and $game_switches[94] == true
        if $game_variables[12] == 1 or $game_variables[12] == 2 or $game_variables[12] == 3
          battler.add_state(24)
        else
          battler.remove_state(24)
        end
      end
      # ------------------------------------------------------------------------
      # 특수 상태이상 적용
      # ------------------------------------------------------------------------
      # 회복
      if battler.state?(168) # 마력 활성화, 초당 mp 2% 회복
        battler.mp += (battler.mmp * 0.02).to_i
      end
      if battler.state?(169) # 재생의 바람, 초당 hp, mp 1% 회복
        battler.hp += (battler.mhp * 0.01).to_i
        battler.mp += (battler.mmp * 0.01).to_i
      end
      # ------------------------------------------------------------------------
    end
    if !battler.state?(1)
      # 자연 회복, 도트 데미지 적용
      if $game_switches[50] == true
        if $sel_time_frame == 1;  battler.regenerate_hp;  pop_damage; end;
        if $sel_time_frame == 5;  battler.regenerate_mp;  pop_damage; end;
        if $sel_time_frame == 9;  battler.regenerate_tp;  pop_damage; end;
      else
        if $sel_time_frame == 10;  battler.regenerate_hp;  pop_damage; end;
        if $sel_time_frame == 50;  battler.regenerate_mp;  pop_damage; end;
        if $sel_time_frame == 90;  battler.regenerate_tp;  pop_damage; end;
      end
    elsif battler.is_a?(Game_Actor)
      if PearlKernel.knock_actor(self.actor) != nil
        # 팔로워 사망시 커먼이벤트 진행
        if battler != nil and battler.dead?
          # 동료 사망 진행
          if $game_party.members.include?($game_actors[battler.id])
            # 동료를 타겟으로 했었던 몬스터들 타겟 갱신
            for event in $game_map.event_enemies.select{|event| event.agroto_f == self}
              if event.agroto_f == self
                event.agroto_f = nil
              end
            end
            force_cancel_actions
            @through = true
            $game_variables[126] = battler.id
            
            if $game_actors[battler.id].set_custom_bio[24] != 2
              # 팔로워 초기화
              @base_equip_slots = YEA::EQUIP::DEFAULT_BASE_SLOTS.clone
              @base_equip_slots.size.times do |i|
                if $game_actors[battler.id].equips[i] != 0 and $game_actors[battler.id].equips[i] != nil
                  $game_actors[battler.id].change_equip_by_id(i, 0)
                end
              end
            end
            
            $game_actors[battler.id].setup(battler.id)
            $game_actors[battler.id].add_state(1)
            
            $game_actors[battler.id].set_custom_bio[22] = 0
            $game_actors[battler.id].set_custom_bio[24] = 2
            
            @stopped_movement = 0
            
            battler.deadposing = $game_map.map_id
            @character_name = "#{self.battler.character_name}" + '_Dead'
            @knockdown_data[1] = @character_name
            @knockdown_data[4] = @character_index
            @knockdown_data[2] = @pattern
            @knockdown_data[3] = @direction
            set_graphic(@character_name, @character_index)
            
            $game_temp.reserve_common_event(263)
            
            print("확인 %s \n" % [$game_actors[battler.id].set_custom_bio[24]])
          end
        end
      end
    end
    # 상태 설정 업데이트
    if $sel_time_frame_10 == 7
      update_state_action_steps
    end
    if $sel_time_frame == ($game_switches[50] == true ? 15 : 60) or $sel_time_frame == 120
      # 캐릭터 대사 출력, 조작 금지 스위치가 아닌 경우
      if battler.is_a?(Game_Actor) and $game_switches[52] == false and rand(20) >= 18
        self.mrbt = $game_map.rose_actor_mrbt(battler)
      end
      # 상태이상 남은 시간 업데이트
      for state in battler.states
        state_ro_no = true
        if battler.is_a?(Game_Actor)
          # 상태이상 무기 제한 확인
          if self.actor.equips[0] != nil
            at_wt_1 = self.actor.equips[0].wtype_id
          else
            at_wt_1 = nil
          end
          sk_wt_1 = []
          sk_wt_1 << state.tool_data("Tool Wtype_1 = ").to_i
          sk_wt_1 << state.tool_data("Tool Wtype_2 = ").to_i
          sk_wt_1 << state.tool_data("Tool Wtype_3 = ").to_i
          sk_wt_1 << state.tool_data("Tool Wtype_4 = ").to_i
          sk_wt_2 = 0
          sk_wt_2 = state.tool_data("Tool Shield = ").to_i
          if sk_wt_2 == 1 and self.actor.equips[1] == nil
            state_ro_no = false
          end
          sk_wt_3 = 0
          sk_wt_3 = state.tool_data("Tool Wtype_1 = ").to_i
          sk_wt_3 += state.tool_data("Tool Wtype_2 = ").to_i
          sk_wt_3 += state.tool_data("Tool Wtype_3 = ").to_i
          sk_wt_3 += state.tool_data("Tool Wtype_4 = ").to_i
          if sk_wt_3 != 0
            state_ro_no = false if !sk_wt_1.include?(at_wt_1) or at_wt_1 == nil
          end
          battler.remove_state(state.id) if state_ro_no == false
        end
        
        # 상태이상 종료 확인 및 경직 관련
        if state.remove_by_walking and battler.state?(state.id)
          if !battler.state_steps[state.id].nil? && battler.state_steps[state.id] > 0
            # 에크티의 표식이 아닌 경우 상태이상 초 감소
            battler.state_steps[state.id] -= 1 if state.id != 161
          elsif battler.state_steps[state.id] == 0
            battler.remove_state(state.id)
            # 복통인 경우 식중독으로 변경
            if state.id == 82 and 2 >= rand(10)
              battler.add_state(78) # 식중독
            end
            pop_damage
          end
          # 행동 제한 상태이상인 경우
          if state.restriction == 4 and !battler.state?(1)
            # 보스 몬스터는 경직 안됨
            if battler.is_a?(Game_Enemy) and battler.boss_hud
              @stopped_movement = 0
            elsif state != nil and battler != nil and battler.state_steps[state.id].to_i >= 1
              @stopped_movement = battler.state_steps[state.id].to_i * 60
              #@stopped_movement = 250
            end
          end
          # 오브젝트면 경직 0 으로 리셋, 상태이상 제거
          if battler.is_a?(Game_Enemy) and battler.object
            battler.remove_state(state.id)
            @stopped_movement = 0
          end
        end
      end
    end
  end

  # 상태이상 설정
  def update_state_action_steps
    # 배틀러가 죽은 상태인지 확인한다.
    if battler.dead? and battler.state?(1)
      if @killed == false and @knockdown_data[1] == nil
        if battler.is_a?(Game_Enemy) and self.knockdown_enable
          force_cancel_actions  # 사망시 행동 취소
          @knockdown_data[0] = 2
        elsif battler.is_a?(Game_Actor) and PearlKernel.knock_actor(self.actor) != nil
          force_cancel_actions  # 사망시 행동 취소
          @knockdown_data[0] = 2
        end
      end
    # 배틀러가 살아 있는 경우에만 아래를 진행한다.
    elsif !battler.dead? and !battler.state?(1) and battler.states.length >= 1
      # 상처 상태이상 업그레이드
      if battler.state?(136)
        battler.remove_state(135) if battler.state?(135)
        battler.remove_state(120) if battler.state?(120)
      elsif battler.state?(135)
        battler.remove_state(120) if battler.state?(120)
      end
      # 방패 사용 및 방어 확인
      if !battler.state?(9) and @battler_guarding[0] != false
        @battler_guarding[0] = false
        @battler_guarding[1] = nil
      end
      # 배틀러 상태이상 이모티콘 적용
      if battler.state?(132);     self.balloon_id = 23    # 화상
      elsif battler.state?(7);    self.balloon_id = 26    # 마비
      elsif battler.state?(13);   self.balloon_id = 30    # 출혈
      elsif battler.state?(133);  self.balloon_id = 27    # 빙결
      elsif battler.state?(8);    self.balloon_id = 26    # 스턴
      elsif battler.state?(6);    self.balloon_id = 10    # 수면
      elsif battler.state?(5);    self.balloon_id = 7     # 혼란
      elsif battler.state?(4);    self.balloon_id = 11    # 침묵
      # 플레이어 공포에 걸린 경우 도망
      elsif battler.state?(138) and !moving?
        self.balloon_id = 22
        di = 0
        loop do
          di += 1
          for event in $game_map.event_enemies.select{|event| obj_size?(event, di) and event.enemy_ready? and event.on_battle_screen?}
            if moving? == false
              @autotargeting = [true, event]
              move_away_from_xy(@autotargeting[1].x,@autotargeting[1].y)
              break
            end
          end
          if di >= 15
            break
          end
        end
      # 취기에 걸린 경우 랜덤 이동
      elsif battler.state?(149) and !moving?
        move_random if rand(10) == 1
      end
    end
  end

  alias falcaopearl_update_anime_pattern update_anime_pattern
  def update_anime_pattern
    return if @anime_speed.to_i > 0 || @knockdown_data[0] > 0
    falcaopearl_update_anime_pattern
  end

  # 게임 플레이어 호출에서 재설정
  def reset_knockdown_actors
    #print("116.Game_CharacterBase - ");
    # 리셋 노크 다운
    if @knockdown_data[1] != nil
      #print("플레이어 호출 재설정, %s \n" % [self.battler.name]);
      @knockdown_data[0] = 0
      knowdown_effect(2)
    end
    # 포스 클리어 노크 다운
    $game_player.followers.each do |follower|
      if follower.knockdown_data[1] != nil
        #print("팔로워 호출 재설정, %s \n" % [self.battler.name]);
        follower.knockdown_data[0] = 0
        follower.knowdown_effect(2)
      end
    end
  end

  # 녹다운 적 게임 플레이어 호출 재설정
  def reset_knockdown_enemies
    $game_map.events.values.each do |event|
      if event.knockdown_data[1] != nil
        event.knockdown_data[0] = 0
        event.knowdown_effect(2)
      end
      if event.deadposee and event.killed
        $game_self_switches[[$game_map.map_id, event.id,
        PearlKernel::KnockdownSelfW]] = false
      end
    end
  end

  # 전역 설정
  def pearl_abs_global_reset
    # 진행 중지 -----------------------------------------------------------------
    return if HM_SEL::time_stop?
    # --------------------------------------------------------------------------
    # 행동 취소
    #force_cancel_actions
    # 팔로워 방패 적용
    battler.remove_state(9) if @battler_guarding[0]
    @battler_guarding = [false, nil]
    @making_spiral = false
    set_hook_variables
    @using_custom_g = false
    $game_player.followers.each do |f|
      f.targeted_character = nil if !f.targeted_character.nil?
      f.stuck_timer = 0 if f.stuck_timer > 0
      f.follower_attacktimer = 0 if f.follower_attacktimer > 0
      f.force_cancel_actions unless f.visible?
      f.battler.remove_state(9) if f.battler_guarding[0]
      f.battler_guarding = [false, nil]
      f.set_hook_variables
      f.making_spiral = false
    end
    reset_knockdown_actors
    reset_knockdown_enemies
    $game_player.projectiles.clear
    $game_player.damage_pop.clear
    $game_player.anime_action.clear
    @send_dispose_signal = true
  end
end