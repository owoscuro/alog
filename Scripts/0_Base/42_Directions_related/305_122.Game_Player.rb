# encoding: utf-8
# Name: 122.Game_Player
# Size: 15790
class Game_Player < Game_Character
  attr_accessor :projectiles, :damage_pop, :anime_action
  attr_accessor :refresh_status_icons, :refresh_buff_icons, :mouse_over
  attr_accessor :refresh_skillbar, :pearl_menu_call
  attr_accessor :new_map_id
  attr_accessor :region_effects
  
  alias falcaopearl_initialize initialize
  def initialize
    @projectiles = []
    @damage_pop = []
    @anime_action = []
    @press_timer = 0
    @refresh_skillbar = 0
    @pearl_menu_call = [sym = nil, 0]
    @camera_slide_focus = 0
    @shadow = true
    falcaopearl_initialize
  end
  
  alias falcaopearl_poses_refresh refresh
  def refresh
    return if @knockdown_data[0] > 0
    if SceneManager.scene_is?(Scene_Map)
      print("122.Game_Player - refresh \n");
      SceneManager.scene.spriteset.refresh_effects
    end
    falcaopearl_poses_refresh
  end

  # 팔로어 전투 여부
  def follower_fighting?
    @followers.each do |f|
      next unless f.visible?
      return true if f.targeted_character != nil
    end
    return false
  end
  
  # 팔로어와 겹치는지 확인
  def follower_passable?(x, y)
    @followers.follower_passable?(x, y)
  end
  
  # 전투 모드에서 게임 파티가 있는지 확인
  def in_combat_mode?
    return true if follower_fighting? || battler_acting?
    return false
  end
  
  def battler
    return actor
  end
  
  def update_state_effects
    battler.dead? ? return : super
  end
  
  def trigger_tool?(key, type)
    return true if type == :keys && Keyboard.trigger?(key)
    return false
  end
  
  def all_jump(x, y)
    jumpto_tile(x, y)
    @followers.each {|f| f.jumpto_tile(x, y)}
  end
  
=begin
  alias galv_region_effects_update_update_nonmoving update_nonmoving
  # 플레이어가 움직이지 않고 가만히 있을때 진행한다.
  def update_nonmoving(last_moving)
    if last_moving
      galv_region_check
    end
    galv_region_effects_update_update_nonmoving(last_moving)
  end
  
  def galv_region_check
    return if Input.trigger?(:C)
    ##print("이동 관련 + Game_Player - galv_region_check \n");
    # 타일셋 수치로 적용 실험
    r_id = $game_map.region_id($game_player.x, $game_player.y)
    if 8 > r_id
      r_id = $game_map.terrain_tag($game_player.x, $game_player.y)
    end
    return if Region_Effects::EFFECT[r_id] == nil
    com_eve = Region_Effects::EFFECT[r_id][4]
    $game_temp.reserve_common_event(com_eve) unless com_eve == nil
  end
=end

  def cam_follow(event = 0)
    @camera_slide_focus = event
  end

  def cam_ev_name(ev_name = "")
    $game_variables[34] = ev_name
    $game_variables[141] = 0
    $game_map.events.values.each do |event|
      if event != nil and event.name =~ /<enemy: /i and event.battler.name =~ /#{ev_name}/i and event.character_name != ""
        @camera_slide_focus = event.id
        $game_variables[141] = 1
        return
      end
    end
  end
  
  def cam_center(event = 0)
    @camera_slide_focus = 0
  end
  
  alias game_player_dash_so dash?
  def dash?
    # 욕구 수치와 상태이상으로 불가 판정 적용
    if $game_party.inv_maxed? or $game_party.leader.stress >= BRAVO_HTS::DISABLE_DASH[8] or $game_party.leader.temper >= BRAVO_HTS::DISABLE_DASH[7] or $game_party.leader.sleep >= BRAVO_HTS::DISABLE_DASH[2] or $game_party.leader.thirst >= BRAVO_HTS::DISABLE_DASH[1] or $game_party.leader.hunger >= BRAVO_HTS::DISABLE_DASH[0]
      $game_actors[7].add_state(29) if !$game_actors[7].state?(29)
    elsif $game_actors[7].state?(29)
      $game_actors[7].remove_state(29)
    end
    return false if $game_actors[7].state?(29) or $game_actors[7].state?(118)
    return false if $game_switches[MOVE_CONTROL::DASH_SEAL]
    return false if Theo::LimInv::Full_DisableDash && $game_party.inv_maxed?
    
    if $game_system.autodash? or $game_switches[MOVE_CONTROL::DASH_REV]
      return false if @move_route_forcing
      return false if $game_map.disable_dash?
      return false if vehicle
      return false if Input.press?(:A)
      return true
    else
      return game_player_dash_so
    end
  end
  
  alias move_by_input_8direction move_by_input
  def move_by_input
    return if !movable? || $game_map.interpreter.running?
    # 캐릭터 조작 금지 스위치 52
    return if $game_switches[MOVE_CONTROL::MOVE_SEAL_SWITCH] == true
    # 월드 맵인 경우 취소
    if !$game_actors[7].equips[1].is_a?(RPG::Armor) and Keyboard.press?(:kS) and $game_map.map_id != 21
      set_direction(Input.dir4)
      return
    end
    if Input.press?(:LEFT) && Input.press?(:DOWN)
      if passable?(@x, @y, 4) && passable?(@x, @y, 2) &&
        passable?(@x - 1, @y, 2) && passable?(@x, @y + 1, 4) &&
        passable?(@x - 1, @y + 1, 6) && passable?(@x - 1, @y + 1, 8)
        move_diagonal(4, 2)
      elsif @direction == 4
        if passable?(@x, @y, 2) && passable?(@x, @y + 1, 8)
          move_straight(2)
        elsif passable?(@x, @y, 4) && passable?(@x - 1, @y, 6)
          move_straight(4)
        else
          move_straight(Input.dir4) if Input.dir4 > 0
        end
      elsif @direction == 2
        if passable?(@x, @y, 4) && passable?(@x - 1, @y, 6)
          move_straight(4)
        elsif passable?(@x, @y, 2) && passable?(@x, @y + 1, 8)
          move_straight(2)
        else
          move_straight(Input.dir4) if Input.dir4 > 0
        end
      else
        move_straight(Input.dir4) if Input.dir4 > 0
      end
    elsif Input.press?(:RIGHT) && Input.press?(:DOWN)
      if passable?(@x, @y, 6) && passable?(@x, @y, 2) &&
        passable?(@x + 1, @y, 2) && passable?(@x, @y + 1, 6) &&
        passable?(@x + 1, @y + 1, 4) && passable?(@x + 1, @y + 1, 8)
        move_diagonal(6, 2)
      elsif @direction == 6
        if passable?(@x, @y, 2) && passable?(@x, @y + 1, 8)
          move_straight(2)
        elsif passable?(@x, @y, 6) && passable?(@x + 1, @y, 4)
          move_straight(6)
        else
          move_straight(Input.dir4) if Input.dir4 > 0
        end
      elsif @direction == 2
        if passable?(@x, @y, 6) && passable?(@x + 1, @y, 4)
          move_straight(6)
        elsif passable?(@x, @y, 2) && passable?(@x, @y + 1, 8)
          move_straight(2)
        else
          move_straight(Input.dir4) if Input.dir4 > 0
        end
      else
        move_straight(Input.dir4) if Input.dir4 > 0
      end
    elsif Input.press?(:LEFT) && Input.press?(:UP)
      if passable?(@x, @y, 4) && passable?(@x, @y, 8) &&
        passable?(@x - 1, @y, 8) && passable?(@x, @y - 1, 4) &&
        passable?(@x - 1, @y - 1, 2) && passable?(@x - 1, @y - 1, 6)
        move_diagonal(4, 8)
      elsif @direction == 4
        if passable?(@x, @y, 8) && passable?(@x, @y - 1, 2)
          move_straight(8)
        elsif passable?(@x, @y, 4) && passable?(@x - 1, @y, 6)
          move_straight(4)
        else
          move_straight(Input.dir4) if Input.dir4 > 0
        end
      elsif @direction == 8
        if passable?(@x, @y, 4) && passable?(@x - 1, @y, 6)
          move_straight(4)
        elsif passable?(@x, @y, 8) && passable?(@x, @y - 1, 2)
          move_straight(8)
        else
          move_straight(Input.dir4) if Input.dir4 > 0
        end
      else
        move_straight(Input.dir4) if Input.dir4 > 0
      end
    elsif Input.press?(:RIGHT) && Input.press?(:UP)
      if passable?(@x, @y, 6) && passable?(@x, @y, 8) &&
        passable?(@x + 1, @y, 8) && passable?(@x, @y - 1, 6) &&
        passable?(@x + 1, @y - 1, 2) && passable?(@x + 1, @y - 1, 4)
        move_diagonal(6, 8)
      elsif @direction == 6
        if passable?(@x, @y, 8) && passable?(@x, @y - 1, 2)
          move_straight(8)
        elsif passable?(@x, @y, 6) && passable?(@x + 1, @y, 4)
          move_straight(6)
        else
          move_straight(Input.dir4) if Input.dir4 > 0
        end
      elsif @direction == 8
        if passable?(@x, @y, 6) && passable?(@x + 1, @y, 4)
          move_straight(6)
        elsif passable?(@x, @y, 8) && passable?(@x, @y - 1, 2)
          move_straight(8)
        else
          move_straight(Input.dir4) if Input.dir4 > 0
        end
      else
        move_straight(Input.dir4) if Input.dir4 > 0
      end
    else
      move_straight(Input.dir4) if Input.dir4 > 0
    end
    unless moving?
      @direction = Input.dir4 unless Input.dir4 == 0
    end
  end
  
  #--------------------------------------------------------------------------
  # * 역할 업데이트
  # last_real_x : 마지막 실제 X 좌표
  # last_real_y : 마지막 실제 Y 좌표
  #--------------------------------------------------------------------------
  def update_scroll(last_real_x, last_real_y)
    @camera_slide_focus = 0 if @camera_slide_focus == nil
    return if $game_map.scrolling?
    if @camera_slide_focus == 0
      screen_focus_x = screen_x
      screen_focus_y = screen_y
    else
      screen_focus_x = $game_map.events[@camera_slide_focus].screen_x
      screen_focus_y = $game_map.events[@camera_slide_focus].screen_y
    end
    sc_x = (screen_focus_x - Graphics.width/2).abs
    sc_y = (screen_focus_y - 16 - Graphics.height/2).abs
    if @camera_slide_focus == 0
      $game_map.scroll_right(Lune_cam_slide::Slide*sc_x) if screen_focus_x > Graphics.width / 2
      $game_map.scroll_left(Lune_cam_slide::Slide*sc_x) if screen_focus_x < Graphics.width / 2
      $game_map.scroll_up(Lune_cam_slide::Slide*sc_y) if screen_focus_y - 16 < Graphics.height / 2
      $game_map.scroll_down(Lune_cam_slide::Slide*sc_y) if screen_focus_y - 16 > Graphics.height / 2
    else
      $game_map.scroll_right(Lune_cam_slide::Slide*sc_x) if screen_focus_x - screen_x > 0
      $game_map.scroll_left(Lune_cam_slide::Slide*sc_x) if screen_focus_x - screen_x < 0
      $game_map.scroll_up(Lune_cam_slide::Slide*sc_y) if screen_focus_y - screen_y < 0
      $game_map.scroll_down(Lune_cam_slide::Slide*sc_y) if screen_focus_y - screen_y > 0
    end
  end
  
  alias falcaopearl_it_update update
  def update
    # --------------------------------------------------------------------------
    # 아래는 시간 가속중이 아닌 경우에만 적용
    # --------------------------------------------------------------------------
    update_pearl_battle_set if $game_switches[283] == false and !$game_actors[7].dead?
    falcaopearl_it_update
  end
  
  # 전투 업데이트
  def update_pearl_battle_set
    # 월드 맵, 의뢰 게시판 취소
    return if $game_map.map_id == 21 or $game_map.map_id == 35
    @projectiles.each {|projectile| projectile.update}
    @pearl_menu_call[1] -= 1 if @pearl_menu_call[1] > 0
    update_tool_usage
    update_menu_buttons
  end
  
  if $imported["Falcao Interactive System Lite"]
    alias falcaopearl_int player_start_falling
    def player_start_falling
      return if @hookshoting[1]
      falcaopearl_int
    end
  end
  
  def update_tool_usage
    return if PearlSkillBar.hidden?
    return unless normal_walk?
    # 캐릭터 조작 금지 스위치
    return if $game_switches[52] == true

    if trigger_tool?(Key::Weapon[0], :keys) and actor.equips[0].nil?
      # 무기가 없는 경우 그냥 맨주먹 무기 데이터를 읽는다.
      use_weapon(130)
    end
    unless actor.equips[0].nil?
      use_weapon(actor.equips[0].id) if trigger_tool?(Key::Weapon[0], :keys)
    end
    
    # 무기 종류, 도를 착용한 상태
    if !actor.equips[0].nil? and actor.equips[0].wtype_id == 5
      #use_armor(331) if trigger_tool?(Key::Armor[0], :keys)
    else
      unless actor.equips[1].nil?
        use_armor(actor.equips[1].id) if trigger_tool?(Key::Armor[0], :keys)
      end
    end
    unless actor.assigned_item.nil?
      use_item(actor.assigned_item.id) if trigger_tool?(Key::Item[0], :keys)
    end
    unless actor.assigned_item2.nil?
      use_item(actor.assigned_item2.id) if trigger_tool?(Key::Item2[0], :keys)
    end
    unless actor.assigned_skill.nil?
      use_skill(actor.assigned_skill.id) if trigger_tool?(Key::Skill[0], :keys)
    end
    unless actor.assigned_skill2.nil?
      use_skill(actor.assigned_skill2.id) if trigger_tool?(Key::Skill2[0],:keys)
    end
    unless actor.assigned_skill3.nil?
      use_skill(actor.assigned_skill3.id) if trigger_tool?(Key::Skill3[0],:keys)
    end
    unless actor.assigned_skill4.nil?
      use_skill(actor.assigned_skill4.id) if trigger_tool?(Key::Skill4[0],:keys)
    end
    unless actor.assigned_skill5.nil?
      use_skill(actor.assigned_skill5.id) if trigger_tool?(Key::Skill5[0],:keys)
    end
    unless actor.assigned_skill6.nil?
      use_skill(actor.assigned_skill6.id) if trigger_tool?(Key::Skill6[0],:keys)
    end
    unless actor.assigned_skill7.nil?
      use_skill(actor.assigned_skill7.id) if trigger_tool?(Key::Skill7[0],:keys)
    end
    unless actor.assigned_skill8.nil?
      use_skill(actor.assigned_skill8.id) if trigger_tool?(Key::Skill8[0],:keys)
    end
    unless actor.assigned_item3.nil?
      use_item(actor.assigned_item3.id) if trigger_tool?(Key::Item3[0], :keys)
    end
    unless actor.assigned_item4.nil?
      use_item(actor.assigned_item4.id) if trigger_tool?(Key::Item4[0], :keys)
    end
    update_followers_trigger unless $game_map.interpreter.running?
  end
  
  def update_followers_trigger
    # 프레임 조작 실험
    if $sel_time_frame_10 == 1
      make_battle_followers if $game_switches[196] == true and $game_switches[80] == false and $game_switches[182] == false
    end
    make_battle_followers_test if trigger_tool?(Key::Follower[0], :keys)
  end

  # 자동 사냥 아이콘 변경
  def make_battle_followers_test
    $game_switches[197] = true
    if $game_switches[196] == true
      $game_switches[196] = false
    else
      $game_switches[196] = true
    end
  end
  
  def make_battle_followers
    @followers.each do |f|
      next unless f.visible?
      next if f.fo_tool.nil? || f.battler.dead?
      if f.targeted_character.nil?
        if f.fo_tool.tool_data("User Graphic = ", false).nil?
          # 오류로 인하여 실험
          if f.fo_tool.is_a?(RPG::Skill) || fo_tool.is_a?(RPG::Item)
            # 데이터는 없지만 유익한 기술입니다.
            if f.fo_tool.scope == 0 || f.fo_tool.scope.between?(7, 11)
              f.setup_followertool_usage
            else
              f.balloon_id = PearlKernel::FailBalloon
            end
          else
            f.balloon_id = PearlKernel::FailBalloon
            next
          end
        else
          # 데이터가 있다
          f.setup_followertool_usage
        end
      end
    end
  end
  
  def update_menu_buttons
    # 게임 시간 가속중 버튼 금지
    return if $game_switches[283] == true
    return if $game_map.interpreter.running?
    return if @pearl_menu_call[1] > 0
    if Keyboard.trigger?(Key::QuickTool)
      return if @knockdown_data[0] > 0
      force_cancel_actions
      if $game_variables[283] == 1
        @pearl_menu_call = [:tools, 2]
      end
    end
  end
  
  def set_skill(id)
    actor.assigned_skill = $data_skills[id]
  end
  
  alias falcao_pearl_movable movable?
  def movable?
    return if force_stopped? || @blowpower[0] > 0
    falcao_pearl_movable
  end
  
  alias falcaopearl_start_map start_map_event
  def start_map_event(x, y, triggers, normal)
    # 게임 시간 가속중 Z 버튼 생략
    return if $game_switches[283] == true
    falcaopearl_start_map(x, y, triggers, normal)
  end
end