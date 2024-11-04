# encoding: utf-8
# Name: 225.Window_SkillCommand2
# Size: 956
class Window_SkillCommand2 < Window_Command
  attr_reader   :command_window
  def initialize(x, y)
    super(x, y)
    @actor = nil
  end
  
  def col_max
    return 6
  end
  
  def window_width
    Graphics.width
  end
  
  def alignment
    return 1
  end
  
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
  end
  
  def visible_line_number
    return 1
  end
  
  def make_command_list
    return unless @actor
    @actor.added_skill_types.sort.each do |stype_id|
      name = $data_system.skill_types[stype_id]
      add_command(name, :skill, true, stype_id)
    end
  end
  
  def update
    super
    if $game_variables[381] != current_ext
      $game_variables[381] = current_ext
      if @help_window
        #print("076_2.스킬 카테고리 - 카테고리 변경 \n");
        @help_window.set_text(BRAVO_STORAGE_2::HELP_TEXT_03, nil)
      end
    end
  end
end