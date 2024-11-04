# encoding: utf-8
# Name: 256.Scene_BattlerSelection
# Size: 6089
class Scene_BattlerSelection < Scene_MenuBase
  def start
    super
    item = $game_player.targeting[1]

    # 사거리 대입하기 위해서 추가
    @tool_distance = $game_player.targeting[1].tool_data("Tool Distance = ")

    if item.is_a?(RPG::Skill) || item.is_a?(RPG::Item)
      load_target(item)
    else
      invoke = item.tool_data("Tool Invoke Skill = ")
      if invoke != 0
        load_target($data_skills[invoke])
      else
        @event_window = Window_EventSelect.new($game_map.events.values)
      end
    end

    @info_window = Sprite.new
    @event_window.item.nil? ? t = 'No hay objetivo.' : t = 'Por favor seleccione un objetivo.'
    @info_window.bitmap = Bitmap.new(300, 60)
    @info_window.z = 900 
    x, y = Graphics.width / 2 - 300 / 2,  Graphics.height / 2 - 60 / 2
    @info_window.x = x; @info_window.y = y
    @info_window.bitmap.font.name = "한컴 윤체 L"
    @info_window.bitmap.font.size = 30
    @info_window.bitmap.font.shadow = true
    @info_window.bitmap.draw_text(0, 0, @info_window.width, 32, t, 1)
    @info_time = 10
    create_cursor unless @event_window.item.nil?
    @background_sprite.color.set(16, 16, 16, 70)
  end

  def create_name_sprites
    return if !@name_text.nil?
    @name_text = Sprite.new
    @name_text.bitmap = Bitmap.new(200, 60)
    $game_player.targeting[2] = @event_window.item
    
    if !obj_size_xy?($game_player.targeting[2].x, $game_player.targeting[2].y, @tool_distance) and @tool_distance != nil and @tool_distance != 0
      $game_temp.pop_w(180, 'SYSTEM', "  El objetivo está fuera de alcance.  ")
      @name_text.bitmap.font.color = Color.new(255,0,0,255)
    else
      if $game_temp.pop_windowdata != nil
        $game_temp.pop_windowdata[0] = 0 if $game_temp.pop_windowdata[0] > 0
      end
      @name_text.bitmap.font.color = Color.new(255,255,255,255)
    end

    @name_text.bitmap.font.name = "한컴 윤체 L"
    @name_text.bitmap.font.size = 20
    @name_text.bitmap.font.shadow = true
    @name_text.x = @event_window.item.screen_x2 - 100
    @name_text.y = @event_window.item.screen_y2 - 58
    text = @event_window.item.battler.name
    @name_text.bitmap.draw_text(0, 0, @name_text.width, 32, text, 1)
  end
  
  def dispose_name_sprites
    return if @name_text.nil?
    @name_text.bitmap.dispose
    @name_text.dispose
    @name_text = nil
  end

  # 로드 항목 대상
  def load_target(item)
    if item.scope.between?(1, 6)
      @event_window = Window_EventSelect.new($game_map.events.values)
    else
      targets = []
      $game_player.followers.each {|i| targets << i if i.visible?}
      targets << $game_player
      @event_window = Window_EventSelect.new(targets)
    end
  end
  
  def refresh_info(type)
    @info_window.bitmap.clear
    t = '¡Objetivo incorrecto!' if type == 2
    @info_window.bitmap.draw_text(-30, 0, @info_window.width, 32, t, 1)
  end
  
  def create_cursor
    @cursor = Sprite.new
    icon = PearlScenes::CursorIcon
    @cursor.bitmap = Bitmap.new(24, 24)
    bitmap = Cache.system("Iconset")
    rect = Rect.new(icon % 16 * 24, icon / 16 * 24, 24, 24)
    @cursor.bitmap.blt(0, 0, bitmap, rect)
    @cursor_zooming = 0
    update_cursor_position
  end

  def update
    super
    if @info_window != nil and Input.trigger?(:B)
      print("256.Scene_BattlerSelection - 타겟 선택 취소 \n");
      $game_player.targeting = [false, item=nil, char=nil]
      SceneManager.return
      Sound.play_cancel
    end
    @info_time -= 1 if @info_time > 0
    if @info_time == 0
      @info_window.opacity -= 8 if @info_window.opacity > 0
      if @info_window.opacity == 0 and @event_window.item.nil?
        Sound.play_cancel
        $game_player.targeting = [false, item=nil, char=nil]
        SceneManager.return
      end
    end
    return if @event_window.item.nil?
    if @current_index != @event_window.index
      @current_index = @event_window.index
      dispose_name_sprites
      create_name_sprites
    end
    update_cursor_position
    update_target_selection
  end

  # 범위 확인
  def obj_size?(target, size)
    return false if size.nil?
    sx = $game_map.events[target].x
    sy = $game_map.events[target].y
    distance = ($game_player.x - sx).abs + ($game_player.y - sy).abs
    enable   = (distance <= size-1)
    return true if enable
    return false
  end

  # 좌표 범위 확인
  def obj_size_xy?(target_x, target_y, size)
    return false if size.nil?
    distance = ($game_player.x - target_x).abs + ($game_player.y - target_y).abs
    enable   = (distance <= size-1)
    return true if enable
    return false
  end
  
  # 타겟 선택
  def update_target_selection
    if Input.trigger?(:C)
      # 타겟 선택 완료
      Sound.play_ok
      #$game_player.targeting[2] = @event_window.item
      SceneManager.return
      if $game_player.targeting[2].battler.is_a?(Game_Actor)
        # 마지막에 사용한 스킬 아이디 대입
        print("256.Scene_BattlerSelection - %s \n" % [$game_player.targeting[2].battler.id]);
        if $game_player.targeting[1].is_a?(RPG::Skill)
          $game_variables[126] = $game_player.targeting[2].battler.id
          $game_temp.reserve_common_event(261) if $game_player.targeting[1].id == 326
        end
      end
    end
  end

  def update_cursor_position
    @cursor.x = @event_window.item.screen_x2
    @cursor.y = @event_window.item.screen_y2 - 16
    @cursor_zooming += 1
    case @cursor_zooming
    when 1..10 ; @cursor.zoom_x -= 0.01 ; @cursor.zoom_y -= 0.01
    when 11..20; @cursor.zoom_x += 0.01 ; @cursor.zoom_y += 0.01
    when 21..30; @cursor.zoom_x = 1.0   ; @cursor.zoom_y = 1.0
      @cursor_zooming = 0 
    end
  end

  def terminate
    super
    @event_window.dispose
    @info_window.dispose
    @info_window.bitmap.dispose
    dispose_name_sprites
    @cursor.dispose unless @cursor.nil?
    @cursor.bitmap.dispose unless @cursor.nil?
  end
end