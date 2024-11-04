# encoding: utf-8
# Name: 152.Window_Selectable
# Size: 1056
class Window_Selectable < Window_Base
  def process_cursor_move
    return unless cursor_movable?
    last_index = @index
    cursor_down (Input.trigger?(:DOWN))  if Input.repeat?(:DOWN)
    cursor_up   (Input.trigger?(:UP))    if Input.repeat?(:UP)
    cursor_right(Input.trigger?(:RIGHT)) if Input.repeat?(:RIGHT)
    cursor_left (Input.trigger?(:LEFT))  if Input.repeat?(:LEFT)
    cursor_pagedown   if !handle?(:pagedown) && Input.repeat?(:R)
    cursor_pageup     if !handle?(:pageup)   && Input.repeat?(:L)
    Sound.play_cursor if @index != last_index
  end
end

class Window_MenuStatus
  def item_height
    (height - standard_padding * 2) / 3
  end
end

class Window_MenuStatus < Window_Selectable
  alias sp_ini initialize 
  def initialize(x, y)
    sp_ini(x,y)
    select(0)
  end
  #--------------------------------------------------------------------------
  # 가온데 정렬 추가 수정
  #--------------------------------------------------------------------------
  def alignment
    return 1
  end
end