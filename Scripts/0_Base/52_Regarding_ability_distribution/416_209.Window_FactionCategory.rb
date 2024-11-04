# encoding: utf-8
# Name: 209.Window_FactionCategory
# Size: 589
class Window_FactionCategory < Window_HorzCommand
  attr_reader   :reputation_window
  def initialize
    super(0, 0)
  end
  
  def window_width
    Graphics.width
  end
  
  def col_max
    return SZS_Factions::FactionType.size
  end
  
  def update
    super
    @reputation_window.category = current_symbol if @reputation_window
  end
  
  def make_command_list
    SZS_Factions::FactionType.each do |k, v|
      add_command(v,k)
    end
  end
  
  def reputation_window=(reputation_window)
    @reputation_window = reputation_window
    update
  end
end