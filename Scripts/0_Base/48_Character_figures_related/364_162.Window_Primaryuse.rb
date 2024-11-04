# encoding: utf-8
# Name: 162.Window_Primaryuse
# Size: 1825
# encoding: utf-8
# Name: 162.Window_Primaryuse
# Size: 1729
class Window_Primaryuse < Window_Command
  
  # 가온데 정렬 실험
  def alignment
    return 1
  end
  
  attr_accessor :actor
  def initialize(x, y, actor)
    @actor = actor
    super(x, y)
    deactivate ; unselect
  end
  
  def window_width()  return 544  end
  def window_height() return 80   end  

  def make_command_list
    add_command('Arma ' + Key::Weapon[1],   'Arma ' + Key::Weapon[1])
    add_command('Armadura ' + Key::Armor[1],'Armadura ' + Key::Armor[1])
    add_command('Objeto ' + Key::Item[1],   'Objeto '  + Key::Item[1])
    add_command('Objeto ' + Key::Item2[1],  'Objeto '  + Key::Item2[1])
    add_command('Habilidad ' + Key::Skill[1],  'Habilidad ' + Key::Skill[1])
    add_command('Habilidad ' + Key::Skill2[1], 'Habilidad ' + Key::Skill2[1])
    add_command('Habilidad ' + Key::Skill3[1], 'Habilidad ' + Key::Skill3[1])
    add_command('Habilidad ' + Key::Skill4[1], 'Habilidad ' + Key::Skill4[1])
    add_command('Habilidad ' + Key::Skill5[1], 'Habilidad ' + Key::Skill5[1])
    add_command('Habilidad ' + Key::Skill6[1], 'Habilidad ' + Key::Skill6[1])
    add_command('Habilidad ' + Key::Skill7[1], 'Habilidad ' + Key::Skill7[1])
    add_command('Habilidad ' + Key::Skill8[1], 'Habilidad ' + Key::Skill8[1])
  end
  
  def refresh_actor(actor)
    @actor = actor
    refresh
  end
  
  def col_max
    return 4
  end
  
  def draw_item(index)
    contents.font.name = "Arial"
    contents.font.size = 20
    if @actor.primary_use == index + 1
      contents.font.color = Color.new(255, 120, 0, 255)
      draw_text(item_rect_for_text(index), command_name(index), alignment)
      change_color(normal_color, command_enabled?(index))
      return
    end
    super
  end
end