# encoding: utf-8
# Name: 186.Window_StorageCommand
# Size: 696
class Window_StorageCommand < Window_HorzCommand
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
      Graphics.width - BRAVO_STORAGE::NAME_WIDTH
    end
  end
  
  def col_max
    return 2
  end
  
  def make_command_list
    add_command(BRAVO_STORAGE::WITHDRAW_TEXT, :withdraw)
    add_command(BRAVO_STORAGE::STORE_TEXT, :store)
  end
end