# encoding: utf-8
# Name: 120.Game_Character
# Size: 11296
class Game_Character
  attr_accessor :namepop    # 팝업 텍스트
  attr_accessor :qest_id    # 의뢰 이모티콘 관련
  attr_accessor :mrbt       # 미니 대화

  def move_straight(d, turn_ok = true)
    @move_succeed = passable?(@x, @y, d)
    x2 = $game_map.round_x_with_direction(@x, d)
    y2 = $game_map.round_y_with_direction(@y, d)
    if self.is_a?(Game_Follower) and self.targeted_character.nil? and $game_player.collide?(x2,y2) and $game_player.follower_passable?(x2,y2)
    elsif @move_succeed
      set_direction(d)
      @x = $game_map.round_x_with_direction(@x, d)
      @y = $game_map.round_y_with_direction(@y, d)
      @real_x = $game_map.x_with_direction(@x, reverse_dir(d))
      @real_y = $game_map.y_with_direction(@y, reverse_dir(d))
      increase_steps
    elsif turn_ok
      set_direction(d)
      check_event_trigger_touch_front
    end
  end
  
  def find_path(x, y, dist = 0)
    # 플레이어 혹은 팔로워 좌표 추적 추가
    if x == 0 and y == 0
      @agroto_f.nil? ? target = $game_player : target = @agroto_f
      # 플레이어 좌표도 추가
      if target != nil
        tx = target.x
        ty = target.y
        path = $game_map.find_path(tx, ty, self.x, self.y, dist + rand(4)).reverse
      end
    elsif x == -1 and y != 0
      event = $game_map.events[y]
      return unless event.is_a?(Game_Event)
      tx = event.x
      ty = event.y
      path = $game_map.find_path(tx, ty, self.x, self.y, dist).reverse
    elsif x >= 1 and y >= 1
      path = $game_map.find_path(x, y, self.x, self.y, dist).reverse
    end
    if path != nil and @move_route != nil
      if !@move_route.repeat
        @move_route.list.delete_at(@move_route_index)
        @move_route.list.insert(@move_route_index, *path)
        @move_route_index -= 1
      elsif path.length > 0
        process_move_command(path[0])
        @move_route_index -= 1
      end
    end
  end
  
  def find_path_r_id(r_id, dist = 0)
    event = $game_map.events[r_id]
    return unless event.is_a?(Game_Event)
    tx = event.x
    ty = event.y
    path = $game_map.find_path(tx, ty, self.x, self.y, dist).reverse
    if path != nil and @move_route != nil
      if !@move_route.repeat
        @move_route.list.delete_at(@move_route_index)
        @move_route.list.insert(@move_route_index, *path)
        @move_route_index -= 1
      elsif path.length > 0
        process_move_command(path[0])
        @move_route_index -= 1
      end
    end
  end
  
  def find_direction_to(goal_x, goal_y)
    search_limit = Pathfind.limit
    map_width = $game_map.width
    node_list = []
    open_list = []
    closed_list = []
    start = {}
    best = start
    
    # 아래 원본
    return 0 if @x == goal_x and @y == goal_y
    
    start[:parent] = nil
    start[:x] = @x
    start[:y] = @y

    # F = G + H
    # G = 시작점으로부터 목표 타일까지의 이동 비용; 생성된 경로 (장애물 피하는 경로)
    # 대각선 방향은 0, 수평은 수직은 1
    # H = 시작점으로부터 목표 타일까지의 이동 비용 (장애물 무시)
    # 대각선 방향을 무시하고 수평, 수직 이동 비용만 계산 1
    start[:g] = 0
    
    start[:f] = $game_map.distance(start[:x], start[:y], goal_x, goal_y)
    
    # 시작점을 열린 목록에 추가한다.    
    node_list.push(start)
    open_list.push(start[:y] * map_width + start[:x])
    
    while node_list.size > 0
      
      base_index = 0
      for i in (0...node_list.size)
        # F 비용 값이 가장 작은 노드를 찾는다.
        if node_list[i][:f] < node_list[base_index][:f]
          base_index = i
        end
      end
      
      # 현재 기준 노드를 설정한다.
      current = node_list[base_index]
      x1 = current[:x]
      y1 = current[:y]
      pos1 = y1 * map_width + x1
      g1 = current[:g]
      
      # F 비용이 가장 작은 노드를 열린 목록에서 빼고 닫힌 목록에 추가한다.
      node_list.delete_at(base_index)
      open_list.delete_at(open_list.index(pos1))
      closed_list.push(pos1)
      
      # 현재 노드가 목적지라면 베스트이므로 빠져나간다.
      if current[:x] == goal_x and current[:y] == goal_y
        best = current
        break
      end
      
      # g 비용이 12보다 커지면 최적화 문제로 탐색하지 않는다
      next if g1 >= search_limit
      
      # 인접한 4개의 타일을 열린 목록에 추가한다.
      for j in (0...4)
        direction = 2 + j * 2
        
        x2 = $game_map.round_x_with_direction(x1, direction)
        y2 = $game_map.round_y_with_direction(y1, direction)
        
        pos2 = y2 * map_width + x2
        
        # 닫힌 목록에 이미 있으면 무시한다.
        next if closed_list.include?(pos2)
        
        # 지나갈 수 없는 경우 무시한다.
        next if !$game_map.passable2?(x1, y1, direction)   # 이벤트 여부
        next if !$game_map.passable?(x1, y1, direction)
        
        # 동료만 해당, 동료끼리 겹치지 않도록 추가
        #next if self.is_a?(Game_Follower) and self.targeted_character.nil? and $game_player.collide?(x2,y2) and $game_player.follower_passable?(x2,y2)
        #next if self.is_a?(Game_Follower) and !$game_player.follower_fighting? and $game_player.collide?(x2,y2) and $game_player.follower_passable?(x2,y2)
        
        # 픽셀 무브 실험
        #next if !map_passable?(x1, y1, direction)         # 충돌 여부
        #next if counter_tile_area?(x2, y2)                # 카운터 타일 여부
        #next if collide_with_events?(x2, y2)              # 이벤트 여부

        # g 비용을 1 늘린다 (이동 했다고 가정)
        g2 = g1 + 1
        
        # 열린 목록에서 해당 노드의 인덱스 값을 찾는다 (int or nil)
        index2 = open_list.index(pos2) || -1
        
        # 노드를 찾을 수 없었거나, 새로운 찾은 노드의 이동 비용이 작을 경우
        if (index2 < 0) or (g2 < node_list[index2][:g])
          neighbor = {}
          if index2 >= 0
            # 이미 열린 목록에 있는 노드를 선택한다.
            neighbor = node_list[index2]
          else
            # 열린 목록에 방금 찾은 인접 타일을 추가한다.
            neighbor = {}
            node_list.push(neighbor)
            open_list.push(pos2)
          end
          
          # 새로 찾은 인접 노드의 부모가 이전 타일로 설정된다.
          neighbor[:parent] = current
          
          # 인접 타일의 F 비용이 계산된다.
          neighbor[:x] = x2
          neighbor[:y] = y2
          neighbor[:g] = g2
          
          # F값 = 이동 비용 + 장애물을 무시한 실제 거리
          neighbor[:f] = g2 + $game_map.distance(x2, y2, goal_x, goal_y)

          # best가 nil이거나, 인접 타일의 실제 거리 값이 더 짧으면
          if best.nil? or (neighbor[:f] - neighbor[:g]) < (best[:f] - best[:g])
            # 인접 타일을 베스트 노드로 설정
            best = neighbor
          end
        end
      end
    end
    
    # 최단 거리 노드 값을 가져온다.
    node = best
    
    # 노드의 부모 노드로 거슬러 올라간다, 딱 한 칸만 거슬러 올라간다.
    while node[:parent] and node[:parent] != start
      node = node[:parent] 
    end
    
    # 거리 차 계산
    delta_x1 = $game_map.delta_x(node[:x], start[:x])
    delta_y1 = $game_map.delta_y(node[:y], start[:y])
    
    # 최단 거리 노드가 아래 쪽에 있다.
    if delta_y1 > 0
      return 2     
    # 최단 거리 노드가 왼쪽에 있다.
    elsif delta_x1 < 0
      return 4
    # 최단 거리 노드가 오른쪽 쪽에 있다.
    elsif delta_x1 > 0
      return 6
    # 최단 거리 노드가 위 쪽에 있다.
    elsif delta_y1 < 0
      return 8
    end
    
    # 그래도 찾지 못했다면, 장애물을 고려하지 않는 거리가 가장 가까운 곳으로 이동한다.
    delta_x2 = distance_x_from(goal_x)
    delta_y2 = distance_y_from(goal_y)
    if delta_x2.abs > delta_y2.abs
      return delta_x2 > 0 ? 4 : 6
    elsif delta_y2 != 0
      return delta_y2 > 0 ? 8 : 2
    end
    
    # 이동 불가능
    return 0
  end
  
  def pathfind(x, y)
    if x == 0 and y == 0
      @agroto_f.nil? ? target = $game_player : target = @agroto_f
      # 플레이어 좌표도 추가
      x = target.x
      y = target.y
    end
    
    dir = find_direction_to(x.round, y.round)
    
    rx2 = distance_x_from(x.round)
    ry2 = distance_y_from(y.round)
 
    if $game_map.passable?(x.round, y.round, dir) and $game_map.passable2?(x.round, y.round, dir)
      case dir
      when 2
        if -2 > rx2 and $game_map.passable2?(x.round, y.round, dir)
          move_diagonal(6, 2)
        elsif rx2 > 2 and $game_map.passable2?(x.round, y.round, dir)
          move_diagonal(4, 2)
        else
          move_straight(dir)
        end
      when 4
        if -2 > ry2 and $game_map.passable2?(x.round, y.round, dir)
          move_diagonal(4, 2)
        elsif ry2 > 2 and $game_map.passable2?(x.round, y.round, dir)
          move_diagonal(4, 8)
        else
          move_straight(dir)
        end
      when 6
        if -2 > ry2 and $game_map.passable2?(x.round, y.round, dir)
          move_diagonal(6, 2)
        elsif ry2 > 2 and $game_map.passable2?(x.round, y.round, dir)
          move_diagonal(6, 8)
        else
          move_straight(dir)
        end
      when 8
        if -2 > rx2 and $game_map.passable2?(x.round, y.round, dir)
          move_diagonal(6, 8)
        elsif rx2 > 2 and $game_map.passable2?(x.round, y.round, dir)
          move_diagonal(4, 8)
        else
          move_straight(dir)
        end
      end
    end
  end
  
  # 출구 찾기
  def pathfind_wp(x, y)
    di = 500
    @rand_wp = []
    loop do
      di -= 1
      # 워프 이미지의 캐릭터를 선택한다.
      for event in $game_map.events.values.select{|event|
        obj_size_ok?(event, di) and event.character_name == "!$A_Warp"}
        if !@rand_wp.include?(event.id)
          @rand_wp.push(event.id)
        end
      end
      if 1 > di
        find_path_r_id(@rand_wp[0], 0)
        break
      end
    end
  end
  
  def pathfind_v(target)
    if target == 0 and y == 0
      @agroto_f.nil? ? target = $game_player : target = @agroto_f
    end
    if target.is_a?(Integer)
      return if target == 0
      target = (target == -1) ? $game_player : $game_map.events[target]
    end    
    dx = target.x
    dy = target.y
    dr = target.direction
    if $game_map.passable?(dx, dy, dr)
      dir = find_direction_to(dx, dy)
      move_straight(dir) if dir > 0
    end
  end
  
  def pathfind_ev(event_id)
    event = $game_map.events[event_id]
    return if not event
    tx = event.x
    ty = event.y
    dir = find_direction_to(tx, ty)
    move_straight(dir) if dir > 0
  end
end