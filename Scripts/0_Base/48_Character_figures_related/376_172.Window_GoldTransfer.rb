# encoding: utf-8
# Name: 172.Window_GoldTransfer
# Size: 2457
class Window_GoldTransfer < Window_Selectable
  attr_reader   :number
  def initialize
    super(0, 0, window_width, window_height) 
    @item = nil
    @max = 1
    @number = 1
    @cursor_y = 0
  end
  
  #--------------------------------------------------------------------------
  # 가온데 정렬 추가 수정
  #--------------------------------------------------------------------------
  def alignment
    return 1
  end
  
  def window_width
    return 330
  end
  
  def window_height
    return 72
  end
  
  def set(max, position)
    @max = max
    @number = 1
    @cursor_y = position
    refresh
  end
  
  def refresh
    contents.clear
    draw_gold_info
    draw_number
  end
  
  def enabled?
    if @cursor_y == 0
      return true if $game_party.gold > 0
    else
      return true if $game_party.storage_gold > 0
    end
    return false
  end
  
  def process_ok
    if enabled?
      Sound.play_ok
      Input.update
      deactivate
      call_ok_handler
    else
      Sound.play_buzzer
    end
  end
  
  def draw_gold_info
    party = "Party " + Vocab::currency_unit + " :"
    storage = "Storage " + Vocab::currency_unit + " :"
    draw_text(0, 0, 280, line_height, party)
    draw_text(0, 24, 280, line_height, storage)
    draw_text(0, 0, 225, line_height, $game_party.gold, 2)
    draw_text(0, 24, 225, line_height, $game_party.storage_gold, 2)
  end
  
  def draw_number
    change_color(normal_color)
    draw_text(cursor_x - 28, @cursor_y, 22, line_height, "×")
    draw_text(cursor_x, @cursor_y, cursor_width - 4, line_height, @number, 2)
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
    @cursor_y ||= 0
    cursor_rect.set(cursor_x, @cursor_y, cursor_width, line_height)
  end
end