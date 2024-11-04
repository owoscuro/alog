# encoding: utf-8
# Name: 240.Scene_File
# Size: 4977
class Scene_File < Scene_MenuBase
  def start
    super
    create_all_windows
  end
  
  def terminate
    super
  end
  
  def update
    super
  end
  
  def create_all_windows
    create_help_window
    create_file_window
    create_action_window
    create_status_window
  end
  
  def create_help_window
    @help_window = Window_Help.new
    @help_window.set_text(YEA::SAVE::SELECT_HELP, nil)
  end
  
  def create_file_window
    wy = @help_window.height
    @file_window = Window_FileList.new(0, wy)
    @file_window.set_handler(:ok, method(:on_file_ok))
    @file_window.set_handler(:cancel, method(:return_scene))
  end
  
  def create_action_window
    wx = @file_window.width
    wy = @help_window.height
    @action_window = Window_FileAction.new(wx, wy, @file_window)
    @action_window.help_window = @help_window
    @action_window.set_handler(:cancel, method(:on_action_cancel))
    @action_window.set_handler(:load, method(:on_action_load))
    @action_window.set_handler(:save, method(:on_action_save))
    @action_window.set_handler(:delete, method(:on_action_delete))
  end
  
  def create_status_window
    wx = @action_window.x
    wy = @action_window.y + @action_window.height
    @status_window = Window_FileStatus.new(wx, wy, @file_window)
  end
  
  def on_file_ok
    @action_window.activate
    index = SceneManager.scene_is?(Scene_Load) ? 0 : 1
    @action_window.select(index)
  end
  
  def on_action_cancel
    @action_window.unselect
    @file_window.activate
    @help_window.set_text(YEA::SAVE::SELECT_HELP, nil)
  end
  
  def on_action_load
    if DataManager.load_game(@file_window.index)
      on_load_success
    else
      Sound.play_buzzer
    end
  end
  
  def on_load_success
    Sound.play_load
    fadeout_all
    $game_system.on_after_load

    # 세이브 조작 확인
    if ($game_party.gold).to_i != ($ro_rodel_rosepa[:party].gold.group).to_i
      print("소지금 조작 \n");
      @roro_edit = 1
    end
    for i in 1...$data_system.variables.size
      if i != 5 and i != 15 and i != 20 and i != 21 and i != 23 and i != 40 and 
        i != 327 and i != 32 and i != 177 and i != 192 and i != 86 and i != 71 and
        i != 72 and i >= 176 and 180 >= i and i >= 192 and 197 >= i
        if $game_variables[i] != $ro_rodel_rosepa[:variables][i]
          print("변수 조작 %s \n" % [i]);
          @roro_edit = 1
        end
      end
    end
    for i in 1...$data_system.switches.size
      if i != 196 and i != 191
        if $game_switches[i] != $ro_rodel_rosepa[:switches][i]
          print("스위치 조작 %s \n" % [i]);
          @roro_edit = 1
        end
      end
    end
    if $game_party.total_inv_size != $ro_rodel_rosepa[:party].total_inv_size
      print("아이템 무게 조작 \n");
      @roro_edit = 1
    end
    if $game_party.items.count != $ro_rodel_rosepa[:party].items.count
      print("아이템 조작 \n");
      @roro_edit = 1
    end
    if $game_party.weapons.count != $ro_rodel_rosepa[:party].weapons.count
      print("무기 조작 \n");
      @roro_edit = 1
    end
    if $game_party.armors.count != $ro_rodel_rosepa[:party].armors.count
      print("방어구 조작 \n");
      @roro_edit = 1
    end
    $game_party.members.each do |actor|
      for i in BM::STATUS::BMPROPERTIES_COLUMN_TEST
        if eval("$game_actors[actor.id].#{i}") != eval("$ro_rodel_rosepa[:actors][actor.id].#{i}")
          print("능력치 %s 조작 \n" % [i]);
          @roro_edit = 1
        end
      end
    end
    if @roro_edit == 1
      SceneManager.goto(Scene_Title)
    else
      SceneManager.goto(Scene_Map)
    end
  end

  def on_action_save
    @action_window.activate
    if $game_switches[283] == true
      Sound.play_buzzer
      # 오류 메세지 표시 실험 -----------------------
      $game_temp.pop_w(180, 'SYSTEM', 
      "  No es posible guardar en este momento.  ")
      # -------------------------------------------
    else
      if DataManager.save_game(@file_window.index)
        on_save_success
      else
        Sound.play_buzzer
      end
    end
    refresh_windows
  end

  def on_save_success; Sound.play_save; end
  
  def on_action_delete
    @action_window.activate
    if Keyboard.press?(:kC)
      DataManager.delete_save_file(@file_window.index)
      on_delete_success
    else
      Sound.play_buzzer
      # 오류 메세지 표시 실험 -----------------------
      $game_temp.pop_w(180, 'SYSTEM', 
      "  Presiona el 'botón Z' mientras mantienes presionado el 'botón C' para 'remover'.  ")
      # -------------------------------------------
    end
    refresh_windows
  end
  
  def on_delete_success
    YEA::SAVE::DELETE_SOUND.play
  end
  
  def refresh_windows
    @file_window.refresh
    @action_window.refresh
    @status_window.refresh
  end
end