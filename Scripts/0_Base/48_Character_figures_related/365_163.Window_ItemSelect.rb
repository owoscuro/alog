# encoding: utf-8
# Name: 163.Window_ItemSelect
# Size: 662
# encoding: utf-8
# Name: 163.Window_ItemSelect
# Size: 605
class Window_ItemSelect < Window_HorzCommand
  def initialize(x=0, y=0)
    super(x, y)
  end

  def window_width()  return Graphics.width * 0.9 + 6  end
  def window_height() return 50   end  

  def make_command_list
    add_command("Arma Principal", :weapon)
    add_command("Arma Secundaria", :armor)
    add_command("Objeto", :item)
    add_command("Habilidad/Magia", :skill_1)
    add_command("Soporte/Otros", :skill_2)
  end
  
  def col_max
    return 5
  end
  
  def draw_item(index)
    contents.font.name = "Arial"
    contents.font.size = 20
    super
  end
end