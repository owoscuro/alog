# encoding: utf-8
# Name: 288.Scene_System
# Size: 1847
class Scene_System < Scene_MenuBase
  def start
    super
    create_help_window
    create_command_window
  end
  
  def create_command_window
    @command_window = Window_SystemOptions.new(@help_window)
    @command_window.set_handler(:cancel, method(:return_scene))
    @command_window.set_handler(:to_title3, method(:command_to_title3))
    @command_window.set_handler(:to_title2, method(:command_to_title2))
    @command_window.set_handler(:to_title, method(:command_to_title))
    @command_window.set_handler(:shutdown, method(:command_shutdown))
  end
  
  #--------------------------------------------------------------------------
  # 후원 포인트 사용하기
  #--------------------------------------------------------------------------
  def command_to_title3
    SceneManager.exit
    $game_map.autoplay
    SceneManager.goto(Scene_Map)
    $game_temp.call_menu = true
    $game_temp.reserve_common_event(188)
  end
  
  #--------------------------------------------------------------------------
  # 끼임 탈출하기
  #--------------------------------------------------------------------------
  def command_to_title2
    SceneManager.exit
    $game_map.autoplay
    SceneManager.goto(Scene_Map)
    if !$game_map.passable?($game_player.x,$game_player.y,$game_player.direction)
      $game_temp.call_menu = true
      $game_temp.reserve_common_event(26)
    else
      $game_temp.call_menu = true
      # 오류 메세지 표시 실험 -----------------------
      $game_temp.pop_w(180, 'SYSTEM', "  No estás en un estado de atasco (error).  ")
      # -------------------------------------------
    end
  end
  
  def command_to_title
    fadeout_all
    SceneManager.goto(Scene_Title)
  end
  
  def command_shutdown
    fadeout_all
    SceneManager.exit
  end
end