# encoding: utf-8
# Name: 136.Game_Interpreter
# Size: 12413
Spike = RPG::SE.new("Sword3",40,150)  # Sound for spike
Escape_SpanTime = 10 * 6              # Escape time
Respawn_Time    = 10 * 60             # Respawn time
Surprise_Delay  = 3 * 6

class Game_Interpreter
  include CHARACTER_EX_EFFECTS_COMMAND
  include KMS_Commands
  include IMIR_Commands
  
  def setup(list, event_id = 0)
    clear
    @map_id = $game_map.map_id
    @event_id = event_id
    @list = list.clone
    create_fiber
  end
  
  def set_checkpoint
    $game_party.set_checkpoint
  end
  
  def add_life(amount)
    $game_party.checkpoint_life += amount
  end
  
  def find_path(x, y, ev = 0, wait = true, dist = 0)
    char = get_character(ev)
    if char != nil
      # 플레이어 혹은 팔로워 좌표 추적 추가
      if x == 0 and y == 0
        @agroto_f.nil? ? target = $game_player : target = @agroto_f
        # 플레이어 좌표도 추가
        if target != nil
          tx = target.x
          ty = target.y
          path = $game_map.find_path(tx, ty, char.x, char.y, dist)
        end
      elsif x == -1 and y != 0
        event = $game_map.events[y]
        return unless event.is_a?(Game_Event)
        tx = event.x
        ty = event.y
        path = $game_map.find_path(tx, ty, char.x, char.y, dist)
      elsif x >= 1 and y >= 1
        path = $game_map.find_path(x, y, char.x, char.y, dist)
      end
    end
    path.reverse!
    path.push(RPG::MoveCommand.new(0))
    route = RPG::MoveRoute.new
    route.list = path
    route.wait = wait
    route.skippable = true
    route.repeat = false
    char.force_move_route(route)
  end
  
  def call_stateview
    SceneManager.call(Scene_StateView)
  end
  [:reveal_state_description, :reveal_buff_description].each { |sys_meth|
    define_method(sys_meth) do |*args| $game_system.send(sys_meth, *args) end
  }
  
  alias game_interpreter_command_125_ew command_125
  def command_125
    game_interpreter_command_125_ew
    value = operate_value(@params[0], @params[1], @params[2])
    event_window_make_gold_text(value)
  end

  alias game_interpreter_command_126_ew command_126
  def command_126
    game_interpreter_command_126_ew
    value = operate_value(@params[1], @params[2], @params[3])
    if $game_switches[142] != true
      event_window_make_item_text($data_items[@params[0]], value)
    else
      add_map_drop("i#{@params[0]}", value)
    end
  end
  
  alias game_interpreter_command_127_ew command_127
  def command_127
    game_interpreter_command_127_ew
    value = operate_value(@params[1], @params[2], @params[3])
    if $game_switches[142] != true
      event_window_make_item_text($data_weapons[@params[0]], value)
    else
      add_map_drop("w#{@params[0]}", value)
    end
  end
  
  alias game_interpreter_command_128_ew command_128
  def command_128
    game_interpreter_command_128_ew
    value = operate_value(@params[1], @params[2], @params[3])
    if $game_switches[142] != true
      event_window_make_item_text($data_armors[@params[0]], value)
    else
      add_map_drop("a#{@params[0]}", value)
    end
  end

  def event_window_make_gold_text(value)
    return unless SceneManager.scene_is?(Scene_Map)
    return if Switch.hide_event_window
    if value > 0
      text = YEA::EVENT_WINDOW::FOUND_TEXT
      item = 0
    else; return
    end
    if 100 > value
      text += sprintf("\ei[3872]%s 동화", value)
      event_window_add_text(text)
    elsif value >= 10000
      text += sprintf("\ei[3874]%s 금화", value / 10000)
      value -= value / 10000 * 10000
      text += sprintf("\ei[3873]%s 은화", value / 100) if value >= 100
      value -= value / 100 * 100
      text += sprintf("\ei[3872]%s 동화", value) if value >= 1
      event_window_add_text(text)
    elsif value >= 100
      text += sprintf("\ei[3873]%s 은화", value / 100)
      value -= value / 100 * 100
      text += sprintf("\ei[3872]%s 동화", value) if value >= 1
      event_window_add_text(text)
    end
  end
  
  def event_window_make_item_text(item, value)
    return unless SceneManager.scene_is?(Scene_Map)
    return if Switch.hide_event_window
    if value > 0
      text = YEA::EVENT_WINDOW::FOUND_TEXT
    else; return
    end
    text += sprintf("\ei[%d] %s", item.icon_index, item.name)
    if value.abs > 1
      fmt = YEA::EVENT_WINDOW::AMOUNT_TEXT
      text += sprintf(fmt, value.abs.group)
    end
    event_window_add_text(text)
  end
  
  def event_window_add_text(text)
    return unless SceneManager.scene_is?(Scene_Map)
    return if Switch.hide_event_window
    text = YEA::EVENT_WINDOW::HEADER_TEXT + text
    text += YEA::EVENT_WINDOW::CLOSER_TEXT
    SceneManager.scene.event_window_add_text(text)
  end
  
  def event_window_clear_text
    $game_temp.clear_event_window_data
  end
  
  # 이동 가능 확인
  def spawn_move_event(dx, dy, teyp, di = 0, tid = 0)
    # 밀기
    if teyp == 1
      di = $game_player.direction if di == 0
      case di
        when 2; dy += 2
        when 8; dy -= 2
        when 4; dx -= 2
        when 6; dx += 2
      end
    # 밀기 2단계, 소유권 집 밖 이동, 당기기
    else
      di = $game_player.direction if di == 0
      di = 10 - di if teyp == 2
      case di
        when 2; dy += 1
        when 8; dy -= 1
        when 4; dx -= 1
        when 6; dx += 1
      end
    end
    if di != 0 and teyp != 4 and teyp != 3
      if $game_map.passable?(dx, dy, di) and $game_player.map_passable?(dx, dy, di) and !$game_player.collide_with_characters?(dx, dy)
        return true
      else
        return false
      end
    elsif teyp == 3
      if tid == 0 or tid == 2
        if $game_map.passable?(dx, dy, di) and $game_player.map_passable?(dx, dy, di) and !$game_player.collide_with_characters?(dx, dy)
          return true
        else
          return false
        end
      else
        if $game_map.terrain_tag(dx, dy) == tid and !$game_map.passable?(dx, dy, di) and !$game_player.map_passable?(dx, dy, di)
          return false
        else
          return true
        end
      end
    elsif teyp == 4
      if $game_map.terrain_tag(dx, dy) == 1 and !$game_map.passable?(dx, dy, di) and !$game_player.map_passable?(dx, dy, di)
        return true
      else
        return false
      end
    end
  end
  
  def spawn_event_location(dx, dy, event_id, map_id = 0)
    # 커먼 이벤트로 진행하기 때문에, 아래 주석 처리
    return unless SceneManager.scene_is?(Scene_Map)
    $game_map.spawn_event(dx, dy, event_id, map_id)
  end
  
  def spawn_event_location2(dx, dy, event_id, map_id = 0, id)
    # 커먼 이벤트로 진행하기 때문에, 아래 주석 처리
    return unless SceneManager.scene_is?(Scene_Map)
    $game_map.spawn_event2(dx, dy, event_id, map_id, id)
  end
  
  def spawn_event_region(region_id, event_id, map_id = 0)
    return unless SceneManager.scene_is?(Scene_Map)
    $game_map.spawn_event_region(region_id, event_id, map_id)
  end
  
  # 화면이 특정 이벤트에게 이동한다.
  def cam_follow(event = 0)
    $game_player.cam_follow(event)
  end
  
  # 몬스터 추적
  def cam_ev_name(ev_name = "")
    $game_player.cam_ev_name(ev_name)
  end
  
  # 화면을 중앙으로 이동한다.
  def cam_center(event = 0)
    $game_player.cam_follow(0)
  end
  
  # Add/Remove Shadows from selected characters
  def shadow(*args,status)
    char_ids = [*args]
    if !$game_map.shad_id_ro.include?(char_ids)
      if char_ids == [:all]
        $game_map.events.values.each { |e|
          e.shadow = status if e.character_name != "" #and e.on_battle_screen?
        }
      else
        char_ids.each {|c| $game_map.events[c].shadow = status }
      end
      #print("097_4.캐릭터 이팩트[7] - refresh_effects \n");
      SceneManager.scene.spriteset.refresh_effects
    end
  end
  
  # Change player and follower shadows
  def actor_shadows(status)
    $game_player.shadow = status
    $game_player.followers.each { |f| f.shadow = status }
    #print("097_4.캐릭터 이팩트[6] - refresh_effects \n");
    SceneManager.scene.spriteset.refresh_effects
  end
  
  def char_effects2(*args,status)
    # 기타 설정에서 그림자 설정
    [*args].each { |e| 
    if e != 1
      $game_map.char_effects2[e] = status
    else
      $game_map.char_effects2[e] = !$game_switches[91]
    end
    }
    #print("097_4.캐릭터 이팩트[2] - refresh_effects \n");
    SceneManager.scene.spriteset.refresh_effects
  end
  
  def mrbt(id, text)
    event = $game_map.interpreter.get_character(id)
    event.mrbt = text if event and event.on_battle_screen?
  end
  
  def change_hunger(actor, amount)
    if actor == 0
      $game_party.members.each do |actor|
        actor.hunger += amount
        actor.check_death
      end
    else
      $game_actors[actor].hunger += amount
      $game_actors[actor].check_death
    end
  end
  
  def change_thirst(actor, amount)
    if actor == 0
      $game_party.members.each do |actor|
        actor.thirst += amount
        actor.check_death
      end
    else
      $game_actors[actor].thirst += amount
      $game_actors[actor].check_death
    end
  end
  
  def change_sleep(actor, amount)
    if actor == 0
      $game_party.members.each do |actor|
        actor.sleep += amount
        actor.check_death
      end
    else
      $game_actors[actor].sleep += amount
      $game_actors[actor].check_death
    end
  end
  
  def change_repute(actor, amount)
    if actor == 0
      $game_party.members.each do |actor|
        actor.repute += amount
        actor.check_death
      end
    else
      $game_actors[actor].repute += amount
      $game_actors[actor].check_death
    end
  end
  
  def change_sexual(actor, amount)
    if actor == 0
      $game_party.members.each do |actor|
        actor.sexual += amount
        actor.check_death
      end
    else
      $game_actors[actor].sexual += amount
      $game_actors[actor].check_death
    end
  end
  
  def change_piety(actor, amount)
    if actor == 0
      $game_party.members.each do |actor|
        actor.piety += amount
        actor.check_death
      end
    else
      $game_actors[actor].piety += amount
      $game_actors[actor].check_death
    end
  end
  
  def change_hygiene(actor, amount)
    if actor == 0
      $game_party.members.each do |actor|
        actor.hygiene += amount
        actor.check_death
      end
    else
      $game_actors[actor].hygiene += amount
      $game_actors[actor].check_death
    end
  end
  
  def change_temper(actor, amount)
    if actor == 0
      $game_party.members.each do |actor|
        actor.temper += amount
        actor.check_death
      end
    else
      $game_actors[actor].temper += amount
      $game_actors[actor].check_death
    end
  end
  
  def change_stress(actor, amount)
    if actor == 0
      $game_party.members.each do |actor|
        actor.stress += amount
        actor.check_death
      end
    else
      $game_actors[actor].stress += amount
      $game_actors[actor].check_death
    end
  end
  
  def change_cold(actor, amount)
    if actor == 0
      $game_party.members.each do |actor|
        actor.cold += amount
        actor.check_death
      end
    else
      $game_actors[actor].cold += amount
      $game_actors[actor].check_death
    end
  end
  
  def change_drunk(actor, amount)
    if actor == 0
      $game_party.members.each do |actor|
        actor.drunk += amount
        actor.check_death
      end
    else
      $game_actors[actor].drunk += amount
      $game_actors[actor].check_death
    end
  end
  
  def wait_fix(duration, divider = 5)
    new_command = RPG::EventCommand.new(230,@indent,[divider])
    (duration/5).times do |i|
      i += 1
      @list.insert(@index+i,new_command)
    end
  end
  
  def escape_wait
    wait_fix(Escape_SpanTime)
  end
  
  def respawn_wait
    wait_fix(Respawn_Time)
  end
  
  def collide?
    ev = $game_map.events[@event_id]
    pl = $game_player
    return ev.x == pl.x && ev.y == pl.y
  end
  
  def surprise_delay
    wait_fix(Surprise_Delay)
  end
end