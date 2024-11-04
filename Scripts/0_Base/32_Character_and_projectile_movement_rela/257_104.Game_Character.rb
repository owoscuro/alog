# encoding: utf-8
# Name: 104.Game_Character
# Size: 16786
#-------------------------------------------------------------------------------
# jump_to(x,y)      # 해당 x,y 위치로 점프
# jump_to_char(id)  # 해당 id 또는 -1 플레이어의 이벤트로 점프
# jump_forward(x)   # x 타일만큼 앞으로 점프
#
# move_toward_event(id)     # 해당 id로 이벤트를 향해 발걸음을 옮깁니다.
# move_away_from_event(id)  # 해당 id로 이벤트에서 멀어집니다.
# turn_toward_event(id)     # 해당 id를 가진 이벤트 쪽으로 턴
#
# move_toward_xy(x,y)       # x,y 좌표를 향한 단계
# move_away_from_xy(x,y)    # x,y 좌표에서 멀어짐
#
# fadeout(speed)            # 지정된 속도로 이벤트를 페이드 아웃
# fadein(speed)             # 지정된 속도로 이벤트에서 페이드
#
# repeat(x)       # this와 end_repeat 사이의 모든 명령을 반복합니다.
# end_repeat      # x번 반복합니다.
#
# repeat_next(x)            # 다음 이동 명령을 x번 반복합니다.
#
# char_level(x)   # 캐릭터의 레벨을 x(0-2)로 변경
#                 # 0 = 아래 1 = 플레이어 2와 동일 = 위
#
# anim(id)        # 캐릭터에서 해당 id로 애니메이션 재생
# balloon(id)     # 플레이어 위에 해당 id를 가진 풍선을 팝니다.
#
# wait(a,b)       # b와 b 사이의 임의의 양의 프레임을 기다립니다.
#
# self_switch("switch",status)    # 자체 스위치를 켜거나 끕니다(true 또는 false).
# self_switch("switch",status,x)  # 이벤트 ID x에 대한 자체 스위치를 켜고 끕니다.
#
# set_char("Charset",index,col,dir) # 이벤트 그래픽을 임의의 charset 포즈로 변경
#                                   # 인덱스 = charset의 문자(1-8)
#                                   # col = 그래픽의 열/단계(1-3)
#                                   # dir = 방향(2,4,6,8)
#
# restore_char    # 이벤트 애니메이션을 복원합니다(set_char에 의해 비활성화됨).
#
# activate_event(type)          # 다른 이벤트를 활성화합니다...
#                               # 유형 0이 그 아래에 있고 유형 1이 앞에 있습니다.
#                               # 참고: 이동 경로가 "완료 대기
#                               # 그러면 다른 이벤트는 현재까지 시작되지 않습니다.
#                               # 이동 경로가 완료되었습니다.
#
# random_region(x,x,x)    # region id에서만 임의의 방향으로 이동
#                         # NPC가 속한 위치를 유지하기 위해 지정(x').
#
# set_char("Damage3",5,1,4) # 5번째 액터, 왼쪽, Damage3의 1열
# self_switch("A",true)     # 자체 스위치 A를 켭니다.
# self_switch("C",false)    # 자체 스위치 C를 끕니다.
# fadeout(10)               # 속도 10에서 이벤트를 점차적으로 페이드 아웃
# anim(66)                  # id가 66인 애니메이션 재생
# wait(50,100)              # 50과 100 사이의 임의의 양의 프레임을 기다립니다.
# char_level(0)             # 아래 플레이어로 레벨 설정
# random_region(1,2,3,4,5)  # 이 영역에서 임의의 방향으로 이동합니다.
# repeat_next(9)            # 다음 이동 명령을 9번 반복합니다.
#
#  repeat(10)               # 전진과 회전을 10회 반복합니다.
#  - Move Forward
#  - Turn 90 degrees left
#  end_repeat
#
# move_toward_xy(10,5)     # x10, y5 좌표의 타일 쪽으로 이동
# move_toward_xy($game_varables[1],$game_varables[2])  # 위와 동일하게 사용
#-------------------------------------------------------------------------------

# 점프 금지 영역을 정의하는 데 사용할 수 있는 영역
NO_JUMP_REGIONS = [1,5]

# 점프 스위치 토글, 이 스위치가 켜져 있으면 점프가 허용되지 않습니다.
TOGGLE_JUMP_SWITCH = 50

# 이름에 이 문자열이 포함된 이벤트를 사용하면 플레이어가 이벤트를 건너뛸 수 있습니다.
JUMP_EVENT_STRING = "<block>"

class Game_Character < Game_CharacterBase
  def jump_to(x,y)
    sx = distance_x_from(x)
    sy = distance_y_from(y)
    jump(-sx,-sy)
  end

  # 아이템 드롭, 해당 id 로 점프
  def jump_to_char(id)
    if id <= 0
      sx = distance_x_from($game_player.x)
      sy = distance_y_from($game_player.y)
    else
      sx = distance_x_from($game_map.events[id].x)
      sy = distance_y_from($game_map.events[id].y)
    end
    jump2(-sx,-sy)
  end

  # 오토타겟 타겟 없는 경우에만 적용
  def move_forward2
    sx = self.x
    sy = self.y
    case @direction
      when 2; sy += 1
      when 8; sy -= 1
      when 4; sx -= 1
      when 6; sx += 1
    end
    if NO_JUMP_REGIONS.include?($game_map.terrain_tag(sx,sy)) and !$game_map.passable?(self.x,self.y,@direction)
      jump2(0,0)
      @tool_distance = 0
    elsif !map_passable?(self.x,self.y,@direction)
      jump2(0,0)
      @tool_distance = 0
    else
      move_forward
      @tool_distance -= 1 if @tool_distance >= 1
    end
  end
  
  # 좌표랑 거리 계산
  def obj_size_xy?(target_x, target_y, size)
    return false if size.nil?
    distance = (self.x - target_x).abs + (self.y - target_y).abs
    enable   = (distance <= size-1)
    return true if enable
    return false
  end
  
  # 오토타겟 발사체 빗나감
  def jump_miss(x_plus, y_plus, ro_di)
    # 거리 계산
    condxy = [x_plus, y_plus]
    jx = + eval_distance(condxy)[0] if condxy[0] > @x
    jx = - eval_distance(condxy)[0] if condxy[0] <= @x
    jy = + eval_distance(condxy)[1] if condxy[1] > @y
    jy = - eval_distance(condxy)[1] if condxy[1] <= @y
    case rand(3)
      when 0; jy -= 1;
      when 1; jy += 1;
      when 2; jx -= 1;
      when 3; jx += 1;
    end
    for i in 1..ro_di
      if can_jump3?(jx, jy) == true and ro_di >= ((jx > 0 ? jx : jx * -1) + (jy > 0 ? jy : jy * -1))/1.5
        jump2(jx, jy)
        @tool_distance = 0
        return
      elsif i >= ro_di
        move_forward2
        return
      else
        distance = ((@x - jx).abs + (@y - jy).abs)
        if distance > ro_di or can_jump3?(jx, jy) == false
          jx -= 1 if jx + @x > @x
          jx += 1 if jx + @x < @x
          jy -= 1 if jy + @y > @y
          jy += 1 if jy + @y < @y
        end
      end
    end
  end

  # 오토타겟 발사체 명중
  def jump_m(x_plus, y_plus, ro_di)
    # 거리 계산
    condxy = [x_plus, y_plus]
    jx = + eval_distance(condxy)[0] if condxy[0] > @x
    jx = - eval_distance(condxy)[0] if condxy[0] <= @x
    jy = + eval_distance(condxy)[1] if condxy[1] > @y
    jy = - eval_distance(condxy)[1] if condxy[1] <= @y
    for i in 1..ro_di
      if can_jump3?(jx, jy) == true and ro_di >= ((jx > 0 ? jx : jx * -1) + (jy > 0 ? jy : jy * -1))/1.5
        jump2(jx, jy)
        @tool_distance = 0
        return
      elsif i >= ro_di
        move_forward2
        return
      else
        distance = ((@x - jx).abs + (@y - jy).abs)
        if distance > ro_di or can_jump3?(jx, jy) == false
          jx -= 1 if jx + @x > @x
          jx += 1 if jx + @x < @x
          jy -= 1 if jy + @y > @y
          jy += 1 if jy + @y < @y
        end
      end
    end
  end

  # 점프시 장애물 있는지 확인
  def jump(x_plus, y_plus)
    for i in 1..10
      if can_jump2?(x_plus, y_plus) == true
        jump2(x_plus, y_plus)
        return
      elsif can_jump2?(x_plus, y_plus) == false
        case @direction
          when 2; y_plus -= 1;
          when 8; y_plus += 1;
          when 4; x_plus += 1;
          when 6; x_plus -= 1;
        end
      end
      if i >= 10
        jump2(0, 0)
        return
      end
    end
  end
  
  # 원본 점프
  def jump2(x_plus, y_plus)
    # 방향 전환 불가능
    @direction_fix = true
    if x_plus.abs > y_plus.abs
      set_direction(x_plus < 0 ? 4 : 6) if x_plus != 0
    else
      set_direction(y_plus < 0 ? 8 : 2) if y_plus != 0
    end
    @x += x_plus
    @y += y_plus
    distance = Math.sqrt(x_plus * x_plus + y_plus * y_plus).round
    # 점프 높이 수정 실험
    @jump_peak = rand(7) + 3 + distance - (@move_speed/2)
    @jump_count = @jump_peak * 2
    @stop_count = 0
    straighten
    # 방향 전환 가능
    @direction_fix = false
    # 남은 이동 거리 제거
    @tool_distance = 0
  end
  
  # 본체가 점프시 속도 조절된 점프 적용
  def jump3(x_plus, y_plus)
    # 속도 조절
    @move_speed = 2
    if x_plus.abs > y_plus.abs
      set_direction(x_plus < 0 ? 4 : 6) if x_plus != 0
    else
      set_direction(y_plus < 0 ? 8 : 2) if y_plus != 0
    end
    @x += x_plus
    @y += y_plus
    distance = Math.sqrt(x_plus * x_plus + y_plus * y_plus).round
    # 점프 높이 수정 실험
    @jump_peak = 5 + distance
    @jump_count = @jump_peak * 2
    @stop_count = 0
    straighten
  end

  # 오토타겟 전용
  def can_jump3?(x,y)
    return false if !$game_map.passable?(@x+x/2,@y+y/2,@direction) and NO_JUMP_REGIONS.include?($game_map.terrain_tag(@x+x/2,@y+y/2))
    return false if !$game_map.passable?(@x+x,@y+y,@direction) and NO_JUMP_REGIONS.include?($game_map.terrain_tag(@x+x,@y+y))
    return true if map_passable?(@x+x,@y+y,@direction)# && !sp_cwc2(@x+x/2,@y+y/2)
  end
  
  # 타일 맵 id 읽기로 변경 실험
  def can_jump2?(x,y)
    return false if !$game_map.passable?(@x+x/2,@y+y/2,@direction) and NO_JUMP_REGIONS.include?($game_map.terrain_tag(@x+x/2,@y+y/2))
    return false if !$game_map.passable?(@x+x,@y+y,@direction) and NO_JUMP_REGIONS.include?($game_map.terrain_tag(@x+x,@y+y))
    return true if map_passable?(@x+x,@y+y,@direction) && !collide_with_characters?(@x+x,@y+y) && !sp_cwc(@x+x/2,@y+y/2)
  end

  # 타일 맵 id 읽기로 변경 실험, 이벤트 충돌까지 확인
  def can_jump?(x,y)
    return false if !$game_map.passable?(@x+x/2,@y+y/2,@direction) and NO_JUMP_REGIONS.include?($game_map.terrain_tag(@x+x/2,@y+y/2))
    return false if !$game_map.passable?(@x+x,@y+y,@direction) and NO_JUMP_REGIONS.include?($game_map.terrain_tag(@x+x,@y+y))
    return true if map_passable?(@x+x,@y+y,@direction) && !collide_with_characters?(@x+x,@y+y) && !sp_cwc(@x+x/2,@y+y/2)
  end

  def sp_cwc2(x, y)
    $game_map.events_xy_nt(x, y).any? do |event|
      next if event.list[0].code == 108 && event.list[0].parameters[0] != "<block>"
      event.normal_priority?
    end
  end

  def sp_cwc(x, y)
    $game_map.events_xy_nt(x, y).any? do |event|
      next if event.list[0].code == 108 && event.list[0].parameters[0] != "<block>"
      event.normal_priority? || self.is_a?(Game_Event)
    end
  end

  # 넉백 점프 실험
  def jump_forward_blowpower(count)
    sx = 0; sy = 0
    case @direction
      when 2; sy = -count
      when 8; sy = count
      when 4; sx = count
      when 6; sx = -count
    end
    jump_blowpower(sx, sy, count)
  end

  # 넉백 점프, 장애물 있으면 넉백 수치 감소
  def jump_blowpower(x_plus, y_plus, count)
    for i in 1..count
      if can_jump3?(x_plus, y_plus)
        jump2(x_plus, y_plus)
        return
      else
        case @direction
          when 2
            y_plus += 1 if -1 > y_plus
          when 8
            y_plus -= 1 if y_plus > 1
          when 4
            x_plus -= 1 if x_plus > 1
          when 6
            x_plus += 1 if -1 > x_plus
        end
      end
      if i >= count
        jump2(0, 0)
        return
      end
    end
  end

  # 수치 만큼 점프 실험
  def jump_forward(count)
    sx = 0; sy = 0
    case @direction
      when 2; sy = count
      when 8; sy = -count
      when 4; sx = -count
      when 6; sx = count
    end
    if 1 >= count and can_jump2?(sx, sy)
      jump2(sx, sy)
    else
      for i in 1..count
        if can_jump2?(sx, sy)
          jump2(sx, sy)
          return
        elsif i >= count
          jump2(0, 0)
          return
        else
          distance = ((@x - sx).abs + (@y - sy).abs)
          if distance > count or can_jump2?(sx, sy) == false
            sx -= 1 if sx + @x > @x
            sx += 1 if sx + @x < @x
            sy -= 1 if sy + @y > @y
            sy += 1 if sy + @y < @y
          end
        end
      end
    end
  end

  def set_char(name,index,pattern,direction)
    @gstop = true
    @direction = direction
    @pattern = pattern - 1
    @character_name = name
    @character_index = index - 1
  end
   
  def restore_char
    @gstop = false
  end
   
  alias galv_move_extras_gc_update_anime_pattern update_anime_pattern
  def update_anime_pattern
    return if @gstop
    galv_move_extras_gc_update_anime_pattern
  end
  
  # 플레이어에게 전진
  def move_toward_event(id)
    @agroto_f.nil? ? target = $game_player : target = @agroto_f
    # 플레이어 좌표 추가
    if target != nil
      move_toward_xy(target.x,target.y)
    end
  end
   
  def move_toward_xy(sx,sy)
    sx = distance_x_from(sx)
    sy = distance_y_from(sy)
    move_straight(4, false) if sx == 1
    move_straight(6, false) if sx == -1
    move_straight(8, false) if sy == 1
    move_straight(2, false) if sy == -1
  end
 
  def turn_toward_event(id)
    turn_toward_character($game_map.events[id])
  end
   
  def move_away_from_event(id)
    move_away_from_xy($game_map.events[id].x,$game_map.events[id].y)
  end
   
  def move_away_from_xy(sx,sy)
    sx = distance_x_from(sx)
    sy = distance_y_from(sy)
    if rand(1) == 1
      if sx.abs > sy.abs
        move_straight(sx > 0 ? 6 : 4)
        move_straight(sy > 0 ? 2 : 8) if !@move_succeed && sy != 0
      elsif sy != 0
        move_straight(sy > 0 ? 2 : 8)
        move_straight(sx > 0 ? 6 : 4) if !@move_succeed && sx != 0
      end
    else
      if sy.abs > sx.abs
        move_straight(sy > 0 ? 2 : 8)
        move_straight(sx > 0 ? 6 : 4) if !@move_succeed && sx != 0
      elsif sx != 0
        move_straight(sx > 0 ? 6 : 4)
        move_straight(sy > 0 ? 2 : 8) if !@move_succeed && sy != 0
      end
    end
  end

  def self_switch(switch,status,id = @id)
    return if $game_self_switches[[@map_id,id,switch]].nil?
    $game_self_switches[[@map_id,id,switch]] = status
  end
   
  def fadeout(speed)
    @opacity -= (speed)
    @move_route_index -= 1 if @opacity > 0
  end
  
  def fadein(speed)
    @opacity += (speed)
    @move_route_index -= 1 if @opacity < 255
  end
   
  def repeat_next(times)
    @crepeat_next = times - 1
  end
  
  def repeat(times)
    @crepeats = times - 1
    @index_position = @move_route_index
  end
  
  def end_repeat
    if @crepeats > 0
      @crepeats -= 1
      @move_route_index = @index_position if @index_position
    else
      @index_position = nil
    end
  end
  
  def char_level(type)
    @priority_type = type
  end
  
  def anim(id)
    @animation_id = id
  end
  
  def balloon(id)
    @balloon_id = id
  end
  
  def wait(low,high)
    @wait_count = (rand(low - high) + low).to_i
  end
  
  alias galv_move_extras_gc_init_private_members init_private_members
  def init_private_members
    @crepeats = 0
    @crepeat_next = 0
    galv_move_extras_gc_init_private_members
  end
  
  alias galv_move_extras_gc_process_move_command process_move_command
  def process_move_command(command)
    if @crepeat_next > 0
      @move_route_index -= 1
      @crepeat_next -= 1
    end
    galv_move_extras_gc_process_move_command(command)
  end
  
  # 플레이어와 방향 동일하게 변경
  def turn_toward_dir
    @ro_org_direction = @direction
    @direction = $game_player.direction
    move_straight(@direction)
    @direction = @ro_org_direction
  end
  
  # 플레이어와 방향 반대로 변경
  def turn_toward_rdir
    @ro_org_direction = @direction
    @direction = $game_player.direction
    move_straight(10 - @direction)
    @direction = @ro_org_direction
  end
  
  def activate_event(type)
    sx = 0; sy = 0
    if type != 0
      case @direction
      when 2; sy = 1
      when 8; sy = -1
      when 4; sx = -1
      when 6; sx = 1
      end
    end
    $game_map.events_xy(@x + sx, @y + sy).each do |event|
      event.start unless event.id == @id
    end
  end

  def random_region(*args)
    r = [*args]
    dir = 2 + rand(4) * 2
    sx = 0; sy = 0
    case dir
    when 2; sy = 1
    when 8; sy = -1
    when 4; sx = -1
    when 6; sx = 1
    end
    return if !r.include?($game_map.region_id(@x + sx, @y + sy))
    move_straight(dir, false)
  end
end