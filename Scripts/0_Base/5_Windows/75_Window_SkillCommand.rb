# encoding: utf-8
# Name: Window_SkillCommand
# Size: 3694
#==============================================================================
# ** Window_SkillCommand
#------------------------------------------------------------------------------
#  This window is for selecting commands (special attacks, magic, etc.) on the
# skill screen.
#==============================================================================

class Window_SkillCommand < Window_Command
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :skill_window
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y)
    @actor = nil
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    return Graphics.width
    #return 160
  end
  #--------------------------------------------------------------------------
  # 가온데 정렬 추가 수정
  #--------------------------------------------------------------------------
  def alignment
    return 1
  end
  #--------------------------------------------------------------------------
  # * Set Actor
  #--------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    # 스킬 상세 데이터를 위해 추가
    $game_variables[126] = @actor.id
    refresh
    #select_last
  end
  #--------------------------------------------------------------------------
  def spacing
    return 2
  end
  def col_max
    return 6
    #return 2
  end
  #--------------------------------------------------------------------------
  # * Get Number of Lines to Show
  #--------------------------------------------------------------------------
  def visible_line_number
    return 1
    #return 4
  end
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    return unless @actor
    @actor.added_skill_types.sort.each do |stype_id|
      name = $data_system.skill_types[stype_id]
      add_command(name, :skill, true, stype_id)
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    if @help_window and @skill_window
      if $game_variables[381] != current_ext
        $game_variables[381] = current_ext
        @help_window.set_text(BRAVO_STORAGE_2::HELP_TEXT_04, nil)
      end
    end
    if @skill_window
      @skill_window.stype_id = current_ext
    end
  end
  #--------------------------------------------------------------------------
  # * Set Skill Window
  #--------------------------------------------------------------------------
  def skill_window=(skill_window)
    @skill_window = skill_window
    update
  end
  #--------------------------------------------------------------------------
  # * Restore Previous Selection Position
  #--------------------------------------------------------------------------
  def select_last
    skill = @actor.last_skill.object
    if skill
      select_ext(skill.stype_id)
    else
      select(0)
    end
  end
end