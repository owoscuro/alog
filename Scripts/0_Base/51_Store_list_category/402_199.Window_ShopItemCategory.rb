# encoding: utf-8
# Name: 199.Window_ShopItemCategory
# Size: 3083
class Window_ShopItemCategory < Window_ItemCategory
  include CAO::CategorizeShop
  def initialize
    clear_command_list
    _init_window(0, 0, window_width, window_height)
    self.windowskin = Cache.system("Window")
    update_padding
    @opening = @closing = false
    @handler = {}
    @index = -1
    deactivate
  end
  
  def _init_window(x, y, width, height)
    Window.instance_method(:initialize).bind(self).call(x, y, width, height)
  end
  private :_init_window
  
  #--------------------------------------------------------------------------
  # ○ 옆에 항목이 늘어놓을 때의 공백의 폭을 취득
  #--------------------------------------------------------------------------
  def spacing
    return 4
  end
  
  def commands
    if $game_switches[141] == true
      result = $game_system.shop_sell_category
    else
      result = $game_system.shop_buy_category
    end

    # 설정 없는 경우 기본 설정 적용
    return [:weapon, :armor, "포션", "음식", "기타"]
  end
  
  def col_max
    return commands.size
  end
  
  #--------------------------------------------------------------------------
  # ○ 프레임 업데이트
  #--------------------------------------------------------------------------
  def update
    last_index = @index
    super
    @item_window.category = current_symbol if @item_window
    refresh if @index != last_index
  end
  
  def make_command_list
    self.commands.each {|item| add_command(VOCAB_COMMANDS[item], item) }
  end
  
  def update_cursor
    if @index < 0 || !VISIBLE_CURSOR
      self.cursor_rect.empty
    else
      ensure_cursor_visible
      cursor_rect.set(item_rect(@index))
    end
  end
  
  def draw_icon(params, x, y, enabled = true)
    if params.kind_of?(Array)
      bitmap = Cache.system(params[0])
      icon_index = params[1]
    else
      bitmap = Cache.system("Iconset")
      icon_index = params
    end
    rect = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
    self.contents.blt(x, y, bitmap, rect, enabled ? 255 : translucent_alpha)
  end
  
  def draw_item(index)
    rect = item_rect_for_text(index)
    icon_info = IMAGE_ICONS[@list[index][:symbol]]
    if icon_info
      rect.x += (rect.width - 24) / 2
      rect.y += (rect.height - 24) / 2
      if icon_info.kind_of?(String)
        icon_index = icon_info[(self.index == index) ? 2 : 1] || icon_info[1]
        draw_icon([icon_info[0], icon_index], rect.x, rect.y)
      else
        icon_index = icon_info[(self.index == index) ? 1 : 0] || icon_info[0]
        draw_icon(icon_index, rect.x, rect.y)
      end
    else
      change_color(normal_color, command_enabled?(index))
      draw_text(rect, command_name(index), alignment)
    end
  end

  #--------------------------------------------------------------------------
  # ○ 결정 처리의 유효 상태 취득
  #--------------------------------------------------------------------------
  def ok_enabled?
    return false
  end
end