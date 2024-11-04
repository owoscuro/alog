# encoding: utf-8
# Name: 191.Window_StorageCommand_2
# Size: 1332
class Window_StorageCommand_2 < Window_HorzCommand
  def initialize
    super(0, 0)
  end
  
  #--------------------------------------------------------------------------
  # 가온데 정렬 추가 수정
  #--------------------------------------------------------------------------
  def alignment
    return 1
  end
  
  def window_width
    if $game_temp.storage_name_window == false
      return Graphics.width
    else
      Graphics.width - BRAVO_STORAGE_2::NAME_WIDTH
    end
  end
  
  def col_max
    return 2
  end
  
  def make_command_list
    add_command(BRAVO_STORAGE_2::WITHDRAW_TEXT, :withdraw)
    add_command(BRAVO_STORAGE_2::STORE_TEXT, :store)
  end
end

class Window_StorageName_2 < Window_Base
  def initialize
    super(0, 0, window_width, fitting_height(1))
    refresh
  end
  
  #--------------------------------------------------------------------------
  # 가온데 정렬 추가 수정
  #--------------------------------------------------------------------------
  def alignment
    return 1
  end
  
  def window_width
    return BRAVO_STORAGE_2::NAME_WIDTH
  end
  
  def refresh
    contents.clear
    name = $game_party.storage_name
    draw_text(0, 0, window_width, line_height, name)
  end
  
  def open
    refresh
    super
  end
end