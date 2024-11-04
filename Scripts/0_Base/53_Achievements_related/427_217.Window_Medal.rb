# encoding: utf-8
# Name: 217.Window_Medal
# Size: 1591
# encoding: utf-8
# Name: 217.Window_Medal
# Size: 1561
class Window_Medal < Window_Selectable
  def initialize(x, y, width, height)
    super
    refresh
    select(0)
    activate
  end
  
  def col_max
    return 1
  end
  
  def item_max
    @data ? @data.size : 1
  end
  
  def item
    @data && index >= 0 ? @data[index] : nil
  end
  
  def make_item_list
    @data = []
    @data = $game_party.medals
    TMMEDAL::MEDAL_DATA.size.times.each {|i|
      if @data.any? {|row| row[0] == i}
        #print("중복 값 %s, %s \n" % [row[0], row[1]]);
      else
        @data.push([i, ""])
      end
    }
  end
  
  def draw_item(index)
    item = @data[index]
    medal = TMMEDAL::MEDAL_DATA[item[0]]
    rect = item_rect(index)
    draw_icon(medal[1], rect.x, rect.y)
    rect.x += 24
    rect.y -= 1
    rect.width -= 216
    if item[1] != ""
      change_color(normal_color)
      draw_text(rect, medal[0])
      rect.x = contents.width - 192
      rect.width = 192
      draw_text(rect, item[1], 2)
    else
      change_color(normal_color, false)
      draw_text(rect, medal[0])
      rect.x = contents.width - 192
      rect.width = 192
      draw_text(rect, "", 2)
    end
  end
  
	def update_help
	  if item
		if item[1] != ""
		  medal = TMMEDAL::MEDAL_DATA[item[0]]
		  text = medal[2]
		else
		  text = "Solo puedes ver la información de los logros obtenidos."
		end
		@help_window.set_text(text, nil)
	  end
	end
  
  def refresh
    make_item_list
    create_contents
    draw_all_items
  end
end