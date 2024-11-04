# encoding: utf-8
# Name: 193.Window_ItemCategory
# Size: 1803
class Window_ItemCategory
  def col_max
    return CAO::CategorizeItem::COMMANDS.size
  end
  
  def make_command_list
    CAO::CategorizeItem::COMMANDS.each do |symbol|
      add_command(CAO::CategorizeItem::VOCAB_COMMANDS[symbol], symbol)
    end
  end
  
  def draw_item(index)
    rect = item_rect_for_text(index)
    param = command_name(index)
    if param.is_a?(Array) && param[1].is_a?(String)
      ww = (rect.width - self.contents.text_size(param[1]).width - 24)
      ww =  [0, ww - (self.contents.font.outline ? 3 : 1)].max
      rect.x += ww / 2
      draw_icon(param[0], rect.x, rect.y)
      rect.x += 24
      rect.width -= ww + 24
      change_color(normal_color)
      draw_text(rect, param[1])
    elsif param.is_a?(String)
      change_color(normal_color)
      draw_text(rect, param, alignment)
    else
      rect.x += (rect.width - 24) / 2
      if param.is_a?(Array)
        icon_index = param[(param[1] && @index == index) ? 1 : 0]
      else
        icon_index = param
      end
      draw_icon(icon_index, rect.x, rect.y)
    end
  end
  
  def index=(index)
    last_index = @index
    #print("193.Window_ItemCategory - 카테고리, %s \n" % [last_index]);
    super
    refresh if @index != last_index
    if @help_window and SceneManager.scene_is?(Scene_Item)
      @help_window.set_text(BRAVO_STORAGE_2::HELP_TEXT_02, nil)
      # Z 버튼으로 아이템을 사용할 수 있으며...
    elsif @help_window and SceneManager.scene_is?(Scene_Storage_2)
      @help_window.set_text(BRAVO_STORAGE_2::HELP_TEXT_01, nil)
      # 상인마다 구매 및 판매하는 아이템이 다르며...
    end
  end
  
  def update_cursor
    super
    self.cursor_rect.empty unless CAO::CategorizeItem::VISIBLE_CURSOR
  end
end