# encoding: utf-8
# Name: Scene_Skill
# Size: 6179
#==============================================================================
# ** Scene_Skill
#------------------------------------------------------------------------------
#  This class performs skill screen processing. Skills are handled as items for
# the sake of process sharing.
#==============================================================================

class Scene_Skill < Scene_ItemBase
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    create_location_window
    create_face_window
  end
  
  #--------------------------------------------------------------------------
  # ● 액터 결정 추가
  #--------------------------------------------------------------------------
  def create_location_window
    @location_window = Window_location.new(0, 0)
  end
  
  def create_face_window
    @face_window = Window_MenuStatus.new(0,72)
    @face_window.viewport = @viewport
    @face_window.set_handler(:ok,     method(:on_actor_ok_face))
    @face_window.set_handler(:cancel, method(:return_scene))
    @face_window.index = 0
    @face_window.activate
  end
  
  def on_actor_ok_face
    @actor = $game_party.members[@face_window.index]
    @face_window.hide.deactivate
    @location_window.hide.deactivate
    create_help_window
    create_status_window
    create_command_window
    create_item_window
    if @help_window
      @help_window.set_text(BRAVO_STORAGE_2::HELP_TEXT_04, nil)
    end
  end
  #--------------------------------------------------------------------------
  # ● 액터 결정 추가 종료
  #--------------------------------------------------------------------------
  
  #--------------------------------------------------------------------------
  # * Create Command Window
  #--------------------------------------------------------------------------
  def create_command_window
    wy = @help_window.height + @status_window.height
    #wy = @help_window.height
    @command_window = Window_SkillCommand.new(0, wy)
    @command_window.viewport = @viewport
    @command_window.help_window = @help_window
    @command_window.actor = @actor
    @command_window.set_handler(:skill,    method(:command_skill))
    @command_window.set_handler(:cancel,   method(:return_scene))
    @command_window.set_handler(:pagedown, method(:next_actor))
    @command_window.set_handler(:pageup,   method(:prev_actor))
  end
  #--------------------------------------------------------------------------
  # * Create Status Window
  #--------------------------------------------------------------------------
  def create_status_window
    @status_window = Window_DistributeParameterActor.new(0, 0, @actor)
    @status_window.viewport = @viewport
    @status_window.actor = @actor
    @help_window.y = @status_window.height
  end
=begin
  def create_status_window
    y = @help_window.height
    @status_window = Window_SkillStatus.new(@command_window.width, y)
    @status_window.viewport = @viewport
    @status_window.actor = @actor
  end
=end
  #--------------------------------------------------------------------------
  # * Create Item Window
  #--------------------------------------------------------------------------
  def create_item_window
    wx = 0
    wy = @command_window.y + @command_window.height
    #wy = @status_window.y + @status_window.height
    ww = Graphics.width
    wh = Graphics.height - wy
    @item_window = Window_SkillList.new(wx, wy, ww, wh)
    @item_window.actor = @actor
    @item_window.viewport = @viewport
    @item_window.help_window = @help_window
    @item_window.set_handler(:ok,     method(:on_item_ok))
    @item_window.set_handler(:cancel, method(:on_item_cancel))
    @command_window.skill_window = @item_window
  end
  #--------------------------------------------------------------------------
  # * Get Skill's User
  #--------------------------------------------------------------------------
  def user
    @actor
  end
  #--------------------------------------------------------------------------
  # * [Skill] Command
  #--------------------------------------------------------------------------
  def command_skill
    #@command_window.deactivate
    @item_window.activate
    @item_window.select_last
  end
  #--------------------------------------------------------------------------
  # * Item [OK]
  #--------------------------------------------------------------------------
  def on_item_ok
    @actor.last_skill.object = item
    determine_item
  end
  #--------------------------------------------------------------------------
  # * Item [Cancel]
  #--------------------------------------------------------------------------
  def on_item_cancel
    @item_window.unselect
    @command_window.activate
    if @help_window
      @help_window.set_text(BRAVO_STORAGE_2::HELP_TEXT_04, nil)
    end
  end
  #--------------------------------------------------------------------------
  # * Play SE When Using Item
  #--------------------------------------------------------------------------
  def play_se_for_item
    Sound.play_use_skill
  end
  #--------------------------------------------------------------------------
  # * Use Item
  #--------------------------------------------------------------------------
  def use_item
    super
    @status_window.refresh
    @item_window.refresh
  end
  #--------------------------------------------------------------------------
  # ○ 창 다시 그리기
  #--------------------------------------------------------------------------
  def refresh_window
    @status_window.refresh
    @item_window.refresh
    Graphics.frame_reset
  end
  #--------------------------------------------------------------------------
  # * Change Actors
  #--------------------------------------------------------------------------
  def on_actor_change
    @command_window.actor = @actor
    @status_window.actor = @actor
    @item_window.actor = @actor
    @command_window.activate
    refresh_window
    if @help_window
      @help_window.set_text(BRAVO_STORAGE_2::HELP_TEXT_04, nil)
    end
  end
end