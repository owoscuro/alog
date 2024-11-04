# encoding: utf-8
# Name: 164.Window_SlotConfirm
# Size: 1300
# encoding: utf-8
# Name: 164.Window_SlotConfirm
# Size: 1281
class Window_SlotConfirm < Window_Command
  # Experimento de alineación centrada
  def alignment
    return 1
  end
  
  def initialize(x, y, kind)
    @kind = kind
    super(x, y)
    activate
  end

  def col_max
    return 2
  end
  
  def window_width()  return 340  end
  def window_height() return @kind == :item ? 75 : 120   end  

  def make_command_list
    case @kind
    when :item
      add_command('Atajo ' + Key::Item[1],    :slot1)
      add_command('Atajo ' + Key::Item2[1],   :slot2)
      add_command('Atajo ' + Key::Item3[1],   :slot3)
      add_command('Atajo ' + Key::Item4[1],   :slot4)
    when :skill_1, :skill_2
      add_command('Atajo ' + Key::Skill[1],   :slot1)
      add_command('Atajo ' + Key::Skill2[1],  :slot2)
      add_command('Atajo ' + Key::Skill3[1],  :slot3)
      add_command('Atajo ' + Key::Skill4[1],  :slot4)
      add_command('Atajo ' + Key::Skill5[1],  :slot5)
      add_command('Atajo ' + Key::Skill6[1],  :slot6)
      add_command('Atajo ' + Key::Skill7[1],  :slot7)
      add_command('Atajo ' + Key::Skill8[1],  :slot8)
    end
  end
  
  def draw_item(index)
    contents.font.name = "Arial"
    contents.font.size = 20
    super
  end
end