# encoding: utf-8
# Name: 210.Window_FactionList
# Size: 1409
class Window_FactionList < Window_Selectable
  attr_reader :description_window
  def initialize(x, y, width, height)
    super
    @category = :none
    @data = []
  end
  
  def category=(category)
    return if @category == category
    @category = category
    refresh
    self.oy = 0
  end
  
  def description_window=(dw)
    @description_window = dw
    refresh
  end
  
  def col_max
    return SZS_Factions::UseDescriptions ? 1 : 2
  end
  
  def item_max
    @data ? @data.size : 1
  end
  
  def item
    @data && index >= 0 ? @data[index] : nil
  end
  
  def current_item_enabled?
    return true
  end
  
  def make_item_list
    # 오류 수정 기존 세이브
    $game_factions = Game_Factions.new if $game_factions == nil
    @data = $game_factions.factions_of(@category)
  end
  
  def select_last
    select(@data.index($game_party.last_item.object) || 0)
  end
  
  def draw_item(index)
    item = @data[index]
    if item
      rect = item_rect(index)
      rect.width -= 4
      # 이름 가온데로 수정
      draw_text(rect.x, rect.y, contents.width, line_height, item.name, 1)
    end
  end
  
  def update_help
    @help_window.faction = item if @help_window
    @description_window.faction = item if @description_window
  end
  
  def refresh
    make_item_list
    create_contents
    draw_all_items
  end
end