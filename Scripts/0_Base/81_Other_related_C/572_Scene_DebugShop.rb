# encoding: utf-8
# Name: Scene_DebugShop
# Size: 3604
class Scene_DebugShop < Scene_MenuBase
  def start
    super
    create_category_window
    create_item_window
    create_number_window
  end
  
  def create_category_window
    @category_window = Window_DebugShopCategory.new
    @category_window.set_handler(:ok, method(:on_category_ok))
    @category_window.set_handler(:cancel, method(:return_scene))
  end
  
  def create_item_window
    wy = @category_window.y + @category_window.height
    wh = Graphics.height - wy
    @item_window = Window_DebugShopBuy.new(0, wy, Graphics.width, wh)
    @item_window.set_handler(:ok, method(:on_item_ok))
    @item_window.set_handler(:cancel, method(:on_item_cancel))
    @item_window.hide
  end
  
  def create_number_window
    @number_window = Window_ShopNumber.new(@item_window.x, @item_window.y, @item_window.height)
    @number_window.x = (Graphics.width - @number_window.width) / 2
    @number_window.y = (Graphics.height - @number_window.height) / 2
    @number_window.set_handler(:ok, method(:on_number_ok))
    @number_window.set_handler(:cancel, method(:on_number_cancel))
    @number_window.hide
  end
  
  def on_category_ok
    @item_window.category = @category_window.current_symbol
    @item_window.refresh
    @item_window.show.activate
    @item_window.select(0)
  end
  
  def on_item_ok
    item = @item_window.item
    max = 999
    price = 0
    @number_window.set(item, max, price)
    @number_window.show.activate
    @item_window.hide
  end
  
  def on_item_cancel
    @item_window.unselect
    @category_window.activate
    @item_window.hide
  end
  
  def on_number_ok
    Sound.play_shop
    $game_party.gain_item(@item_window.item, @number_window.number)
    @number_window.hide
    @item_window.refresh
    @item_window.show.activate
  end

  def on_number_cancel
    @number_window.hide
    @item_window.show.activate
  end
end

class Window_DebugShopCategory < Window_HorzCommand
  def initialize
    super(0, 0)
  end
  
  def window_width
    Graphics.width
  end
  
  def col_max
    return 3
  end

  def make_command_list
    add_command("Items",  :item)
    add_command("Weapons", :weapon)
    add_command("Armors",  :armor)
  end
end

class Window_DebugShopBuy < Window_Selectable
  def initialize(x, y, width, height)
    super(x, y, width, height)
    @shop_goods = []
    make_item_list
    refresh
    select(0)
  end
  
  def category=(category)
    @category = category
    make_item_list
    refresh
  end
  
  def make_item_list
    items = case @category
            when :item
              $data_items
            when :weapon
              $data_weapons
            when :armor
              $data_armors
            else
              []
            end
    item_hash = {}
    items.each do |item|
      next if item.nil? || item.name.strip.empty?
      normalized_name = item.name.strip.downcase
      item_hash[normalized_name] ||= item
    end
    @data = item_hash.values
  end
  
  def item_max
    @data ? @data.size : 1
  end
  
  def col_max
    return 2
  end
  
  def item
    @data[index]
  end
  
  def draw_item(index)
    item = @data[index]
    return unless item
    rect = item_rect(index)
    draw_item_name(item, rect.x, rect.y, enable?(item))
    draw_text(rect, "free!!1", 2) 
  end
  
  def enable?(item)
    true
  end

  def refresh
    make_item_list
    create_contents
    draw_all_items
  end
end

module DebugShop
  def self.open
    SceneManager.call(Scene_DebugShop)
  end
end

class Scene_Map < Scene_Base
  alias debug_shop_update update
  def update
    debug_shop_update
    DebugShop.open if Input.press?(:kF8)
  end
end