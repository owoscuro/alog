# encoding: utf-8
# Name: 126.Game_Follower
# Size: 5908
class Game_Follower < Game_Character
  alias galv_reflect_gf_initialize initialize
  def initialize(member_index, preceding_character)
    galv_reflect_gf_initialize(member_index, preceding_character)
    @shadow = true
    @through = false
  end
  
  def battler
    return actor
  end
  
  alias falcaopearl_f_poses_refresh refresh
  def refresh
    return if @knockdown_data[0] > 0
    return if actor.nil?
    # H 씬 진행시에 장비 벗기는 경우에는 갱신하지 않는다.
    if SceneManager.scene_is?(Scene_Map) and $game_switches[52] == false
      print("126.Game_Follower - refresh \n");
      SceneManager.scene.spriteset.refresh_effects
    end
    falcaopearl_f_poses_refresh
  end
  
  def update_state_effects
    battler.dead? ? return : super
  end
  
  alias falcaopearl_follower_update update
  def update
    # 의뢰 게시판이 아닌 경우, 매춘시 동료 자리 비움 상태 확인
    if $game_map.map_id != 35 and $game_switches[48] == false
      # --------------------------------------------------------------------------
      # 아래는 시간 가속중이 아닌 경우에만 적용
      # --------------------------------------------------------------------------
      if $game_switches[283] == false
        if @targeted_character != nil
          if @targeted_character.character_name == ""
            @targeted_character = nil
          end
        end
        # 자동 전투 상태에서 취소할 경우 전투 취소 실험
        if @targeted_character == nil or $game_switches[196] == false or $game_switches[80] == true or $game_switches[182] == true
          if battler != nil and !moving?
            # 맵 이동 가능 여부
            obj_size?($game_player, 7) ? $game_switches[143] = true : $game_switches[143] = false
            # 동료의 타겟을 제거한다.
            @targeted_character = nil
            # 에르니에게 복귀, 따라간다.
            if !self.force_stopped? and !battler.dead? and !obj_size?($game_player, 3) and battler.set_custom_bio[19].to_i != 1
            #if !stopped_any? and !battler.dead? and !obj_size?($game_player, 3) and battler.set_custom_bio[19].to_i != 1
              pathfind(0, 0)
            end
          end
        end
        if $game_player.followers.gathering? || $game_player.hookshoting[1] || @hookshoting[1]
          @through = true
        else
          @through = false if @through
        end
        falcaopearl_follower_update
      end
      # 동료 투명 적용 부분
      if battler != nil and battler.is_a?(Game_Actor)
        #print("126.Game_Follower - 투명 여부 확인 \n");
        @transparent = lying_down? if visible? and $game_player.normal_walk?
        @transparent = false if $game_player.using_custom_g
      elsif @transparent == false or @through == true
        #@character_name = ""
        @through = false
        @transparent = true
      end
    else
      #print("126.Game_Follower - 의뢰 게시판 혹은 동료 자리 비움\n");
      @transparent = true
    end
    # 동료 그림자 적용
    if @shadow != !@transparent
      @shadow = !@transparent
      SceneManager.scene.spriteset.refresh_effects
    end
  end
  
  # 추종자를 피하여 전투에서 선행 캐릭터를 쫓습니다.
  #alias falcaopearl_chase_preceding_character chase_preceding_character
  def chase_preceding_character
    # 여기서 해결, 동료 자리 지키기
    if battler != nil and @transparent == false
      return if battler.set_custom_bio[19].to_i == 1
      return if @blowpower[0] > 0
      return if @targeted_character != nil or !@targeted_character.nil?
      if visible? and $game_player.follower_fighting?
        return if fo_tool.nil?
        return if battler.dead?
      end
    else
      unless moving?
        sx = distance_x_from(@preceding_character.x)
        sy = distance_y_from(@preceding_character.y)
        if sx != 0 && sy != 0
          move_diagonal(sx > 0 ? 4 : 6, sy > 0 ? 8 : 2)
        elsif sx != 0
          move_straight(sx > 0 ? 4 : 6)
        elsif sy != 0
          move_straight(sy > 0 ? 8 : 2)
        end
      end
    end
    #falcaopearl_chase_preceding_character
  end
  
  def lying_down?
    #print("126.Game_Follower - %s, %s \n" % [!battler.deadposing.nil?, battler.deadposing != $game_map.map_id]);
    #return true if battler.dead?
    return true if !battler.deadposing.nil? && battler.deadposing != $game_map.map_id
    return false
  end

  # 팔로어 대기 상태 여부
  def stopped_any?
    $game_player.followers.each do |follower|
      return true if follower.force_stopped?
    end
    return false
  end
  
  # 팔로어 대상 설정
  def setup_target
    #print("126.Game_Follower - setup_target \n");
    di = 0
    loop do
      di += 1
      # 몬스터 검색 세분화 적용
      for event in $game_map.event_enemies.select{|event| event.enemy_ready? and event.on_battle_screen?}
        if self.obj_size?(event, di)
          if event.on_battle_screen? && event.enemy_ready?
            if self.obj_size?(event, PearlKernel::PlayerRange)
              !event.being_targeted
              @targeted_character = event
              event.being_targeted = true
              di += 10
              break
            end
          end
        end
      end
      if di >= 7
        # 주변에 몬스터가 없으면 자동 전투를 종료
        break
      end
    end
  end
  
  def move_straight(d, turn_ok = true)
    return if force_stopped?
    super
  end
  
  def move_diagonal(horz, vert)
    return if force_stopped?
    super
  end
  
  alias falcaoabs_gather gather?
  def gather?
    return true if !battler.deadposing.nil? and !battler.dead?
    falcaoabs_gather
  end
end