# encoding: utf-8
# Name: SceneManager
# Size: 4591
#==============================================================================
# ** SceneManager
#------------------------------------------------------------------------------
#  This module manages scene transitions. For example, it can handle
# hierarchical structures such as calling the item screen from the main menu
# or returning from the item screen to the main menu.
#==============================================================================

module SceneManager
  #--------------------------------------------------------------------------
  # * Module Instance Variables
  #--------------------------------------------------------------------------
  @scene = nil                            # current scene object
  @stack = []                             # stack for hierarchical transitions
  @background_bitmap = nil                # background bitmap
  #--------------------------------------------------------------------------
  # * Execute
  #--------------------------------------------------------------------------
  def self.run
    DataManager.init
    Audio.setup_midi if use_midi?
    @scene = first_scene_class.new
    @scene.main while @scene
  end
  #--------------------------------------------------------------------------
  # * Get First Scene Class
  #--------------------------------------------------------------------------
  def self.first_scene_class
    $BTEST ? Scene_Battle : Scene_Title
  end
  #--------------------------------------------------------------------------
  # * Use MIDI?
  #--------------------------------------------------------------------------
  def self.use_midi?
    $data_system.opt_use_midi
  end
  #--------------------------------------------------------------------------
  # * 현재 장면 가져오기
  #--------------------------------------------------------------------------
  def self.scene
    #print("SceneManager - self.scene, %s \n" % [@scene]);
    @scene
  end
  #--------------------------------------------------------------------------
  # * 현재 장면 클래스 결정
  #--------------------------------------------------------------------------
  def self.scene_is?(scene_class)
    # 지금 화면 상태를 확인한다.
    @scene.instance_of?(scene_class)
    #print("scene_is?, %s \n" % [scene_class]);
  end
  #--------------------------------------------------------------------------
  # * Direct Transition
  #--------------------------------------------------------------------------
  def self.goto(scene_class)
    @scene = scene_class.new
    #print("SceneManager - self.goto, %s \n" % [scene_class.new]);
  end
  #--------------------------------------------------------------------------
  # * Call
  #--------------------------------------------------------------------------
  def self.call(scene_class)
    @stack.push(@scene)
    @scene = scene_class.new
    #print("SceneManager - self.call, %s \n" % [@stack]);
  end
  #--------------------------------------------------------------------------
  # * Return to Caller
  #--------------------------------------------------------------------------
  def self.return
    if SceneManager.scene_is?(Scene_Menu)
      #print("SceneManager : 맵으로 이동, %s \n" % [@stack]);
      @stack.clear
      @scene = Scene_Map.new
      #SceneManager.goto(Scene_Map)
    else
      @scene = @stack.pop
    end
    #print("SceneManager - self.return, %s \n" % [@scene]);
  end
  #--------------------------------------------------------------------------
  # * Clear Call Stack
  #--------------------------------------------------------------------------
  def self.clear
    @stack.clear
  end
  #--------------------------------------------------------------------------
  # * Exit Game
  #--------------------------------------------------------------------------
  def self.exit
    @scene = nil
  end
  #--------------------------------------------------------------------------
  # * Create Snapshot to Use as Background
  #--------------------------------------------------------------------------
  def self.snapshot_for_background
    @background_bitmap.dispose if @background_bitmap
    @background_bitmap = Graphics.snap_to_bitmap
    @background_bitmap.blur
  end
  #--------------------------------------------------------------------------
  # * Get Background Bitmap
  #--------------------------------------------------------------------------
  def self.background_bitmap
    @background_bitmap
  end
end