# encoding: utf-8
# Name: Scene_Base
# Size: 5807
#==============================================================================
# ** Scene_Base
#------------------------------------------------------------------------------
#  This is a super class of all scenes within the game.
#==============================================================================

class Scene_Base
  #--------------------------------------------------------------------------
  # * Main
  #--------------------------------------------------------------------------
  def main
    start
    post_start
    update until scene_changing?
    pre_terminate
    terminate
  end
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    create_main_viewport
  end
  #--------------------------------------------------------------------------
  # * Post-Start Processing
  #--------------------------------------------------------------------------
  def post_start
    perform_transition
    Input.update
  end
  #--------------------------------------------------------------------------
  # * Determine if Scene Is Changing
  #--------------------------------------------------------------------------
  def scene_changing?
    SceneManager.scene != self
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    update_basic
  end
  #--------------------------------------------------------------------------
  # * Update Frame (Basic)
  #--------------------------------------------------------------------------
  def update_basic
    Graphics.update
    Input.update
    update_all_windows
  end
  #--------------------------------------------------------------------------
  # * 사전 종료 처리
  #--------------------------------------------------------------------------
  def pre_terminate
  end
  #--------------------------------------------------------------------------
  # * 해지 처리
  #--------------------------------------------------------------------------
  def terminate
    Graphics.freeze
    dispose_all_windows
    dispose_main_viewport
  end
  #--------------------------------------------------------------------------
  # * Execute Transition
  #--------------------------------------------------------------------------
  def perform_transition
    Graphics.transition(transition_speed)
  end
  #--------------------------------------------------------------------------
  # * Get Transition Speed
  #--------------------------------------------------------------------------
  def transition_speed
    return 10
  end
  #--------------------------------------------------------------------------
  # * Create Viewport
  #--------------------------------------------------------------------------
  def create_main_viewport
    @viewport = Viewport.new
    @viewport.z = 200
  end
  #--------------------------------------------------------------------------
  # * Free Viewport
  #--------------------------------------------------------------------------
  def dispose_main_viewport
    @viewport.dispose if @viewport != nil # 오류 방지용 추가
  end
  #--------------------------------------------------------------------------
  # * Update All Windows
  #--------------------------------------------------------------------------
  def update_all_windows
    #print("Scene_Base - update_all_windows 시작 \n");
    instance_variables.each do |varname|
      ivar = instance_variable_get(varname)
      ivar.update if ivar.is_a?(Window)
    end
    #print("Scene_Base - update_all_windows 종료 \n");
  end
  #--------------------------------------------------------------------------
  # * Free All Windows
  #--------------------------------------------------------------------------
  def dispose_all_windows
    #print("Scene_Base - dispose_all_windows 시작 \n");
    instance_variables.each do |varname|
      ivar = instance_variable_get(varname)
      ivar.dispose if ivar.is_a?(Window)
    end
    #print("Scene_Base - dispose_all_windows 종료 \n");
  end
  #--------------------------------------------------------------------------
  # * Return to Calling Scene
  #--------------------------------------------------------------------------
  def return_scene
    $game_temp.call_menu = true
    SceneManager.return
=begin
    if SceneManager.scene_is?(Scene_Menu)
      print("Scene_Base : 맵으로 이동 \n");
      $game_temp.call_menu = true
      SceneManager.clear
      SceneManager.call(Scene_Map)
      #Window_MenuCommand::init_command_position
      #SceneManager.return
    else
      print("Scene_Base : 메인 메뉴가 아닌 메뉴에서 메인 메뉴로 이동 \n");
      $game_temp.call_menu = false
      SceneManager.clear
      SceneManager.call(Scene_Menu)
      #Window_MenuCommand::init_command_position
      #SceneManager.return
    end
=end
  end
  #--------------------------------------------------------------------------
  # * Fade Out All Sounds and Graphics
  #--------------------------------------------------------------------------
  def fadeout_all(time = 1000)
    RPG::BGM.fade(time)
    RPG::BGS.fade(time)
    RPG::ME.fade(time)
    Graphics.fadeout(time * Graphics.frame_rate / 1000)
    RPG::BGM.stop
    RPG::BGS.stop
    RPG::ME.stop
  end
  #--------------------------------------------------------------------------
  # * Determine if Game Is Over
  #   Transition to the game over screen if the entire party is dead.
  #--------------------------------------------------------------------------
  def check_gameover
    SceneManager.goto(Scene_Gameover) if $game_party.all_dead?
  end
end