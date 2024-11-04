# encoding: utf-8
# Name: 227.Scene_Base
# Size: 5581
class Scene_Base
  #--------------------------------------------------------------------------
  # ○ 항목 자세한 창 만들기
  #--------------------------------------------------------------------------
  def create_description_window
    @description_window = Window_ItemDescription.new
    @description_window.set_handler(:ok,     method(:on_description_ok))
    @description_window.set_handler(:cancel, method(:on_description_cancel))
    @description_window.set_handler(:description, method(:on_description_cancel))
  end
  
  #--------------------------------------------------------------------------
  # ○ 항목 자세한 [결정]
  #--------------------------------------------------------------------------
  def on_description_ok
    hide_sub_window(@description_window)
  end
  
  #--------------------------------------------------------------------------
  # ○ 항목 자세한 취소
  #--------------------------------------------------------------------------
  def on_description_cancel
    Sound.play_cancel
    hide_sub_window(@description_window)
  end
  
  def on_item_description
    @description_window.refresh(item)
    show_sub_window(@description_window)
  end
  
  def quicksave
    if $game_switches[283] == true
      Sound.play_buzzer
      # 오류 메세지 표시 실험 -----------------------
      $game_temp.pop_w(180, 'SYSTEM', 
      "  %s  " % [YEA::SAVE::SAVE_HELP_NO3])
      # -------------------------------------------
    elsif $game_switches[39] == true
      Sound.play_buzzer
      # 오류 메세지 표시 실험 -----------------------
      $game_temp.pop_w(180, 'SYSTEM', 
      "  %s  " % [YEA::SAVE::SAVE_HELP_NO2])
      # -------------------------------------------
    elsif ($game_variables[18] == 2 and $game_switches[40] == false) or 
      ($game_variables[18] == 4 and $game_switches[40] == false) or 
      ($game_variables[18] == 5 and $game_switches[40] == false)
      Sound.play_buzzer
      # 오류 메세지 표시 실험 -----------------------
      $game_temp.pop_w(180, 'SYSTEM', 
      "  %s  " % [YEA::SAVE::SAVE_HELP_NO])
      # -------------------------------------------
    else
      if DataManager.save_game(ADIK::QUICK::INDEX)
        Sound.play_save
        # 오류 메세지 표시 실험 -----------------------
        $game_temp.pop_w(180, 'SYSTEM', 
        "  %s  " % [YEA::SAVE::SAVE_HELP_OK])
        # -------------------------------------------
      else
        Sound.play_buzzer
      end
    end
  end
    
  def quickload
    if DataManager.load_game(ADIK::QUICK::INDEX)
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
    else
      Sound.play_buzzer
    end
  end
    
  def is_quicksave
    return Keyboard.trigger?(ADIK::QUICK::SAVE_KEY)
  end
    
  def is_quickload
    return Keyboard.trigger?(ADIK::QUICK::LOAD_KEY)
  end
    
  def quicksystem
    if !$game_system.menu_disabled and $game_switches[283] == false and HM_SEL::time_stop? == false
      if is_quicksave and not SceneManager.scene_is?(Scene_Save)
        quicksave
        return
      end
      if is_quickload and not SceneManager.scene_is?(Scene_Load)
        @header = DataManager.load_header(ADIK::QUICK::INDEX)
        # 세이브 에디터 방지용 데이터 획득
        $ro_rodel_rosepa = @header if @header != nil
        quickload
        return
      end
    end
  end

  alias update_quicksystem update
  def update
    update_quicksystem
    quicksystem
  end
end