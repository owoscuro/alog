# encoding: utf-8
# Name: 187.Window_StorageName
# Size: 622
class Window_StorageName < Window_Base
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
    return BRAVO_STORAGE::NAME_WIDTH
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