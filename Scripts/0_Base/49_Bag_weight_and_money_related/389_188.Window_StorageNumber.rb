# encoding: utf-8
# Name: 188.Window_StorageNumber
# Size: 1692
class Window_StorageNumber < Window_Selectable
  attr_reader   :number
  def initialize
    super(0, 0, window_width, window_height) 
    @item = nil
    @max = 1
    @number = 1
  end
  
  #--------------------------------------------------------------------------
  # 가온데 정렬 추가 수정
  #--------------------------------------------------------------------------
  def alignment
    return 1
  end
  
  def window_width
    return Graphics.width / 2
  end
  
  def window_height
    return 48
  end
  
  def set(item, max)
    @item = item
    @max = max
    @number = 1
    refresh
  end
  
  def refresh
    contents.clear
    draw_item_name(@item, 0, 0)
    draw_number
  end
  
  def draw_number
    change_color(normal_color)
    draw_text(cursor_x - 28, 0, 22, line_height, "×")
    draw_text(cursor_x, 0, cursor_width - 4, line_height, @number, 2)
  end
  
  def cursor_width
    figures * 10 + 12
  end
  
  def cursor_x
    contents_width - cursor_width - 4
  end
  
  def figures
    return 4
  end
  
  def update
    super
    if active
      last_number = @number
      update_number
      if @number != last_number
        Sound.play_cursor
        refresh
      end
    end
  end
  
  def update_number
    change_number(1)   if Input.repeat?(:RIGHT)
    change_number(-1)  if Input.repeat?(:LEFT)
    change_number(10)  if Input.repeat?(:UP)
    change_number(-10) if Input.repeat?(:DOWN)
  end
  
  def change_number(amount)
    @number = [[@number + amount, @max].min, 1].max
  end
  
  def update_cursor
    cursor_rect.set(cursor_x, 0, cursor_width, line_height)
  end
end