# encoding: utf-8
# Name: 241.Scene_Shop
# Size: 4475
class Scene_Shop
  attr_reader :item_size_window
  include CAO::CategorizeShop
  
  alias tmitwin_scene_shop_start start
  def start
    tmitwin_scene_shop_start
    create_description_window
    super
    create_help_window
    create_dummy_window
    create_category_window
    create_number_window
    create_status_window
    create_buy_window
    create_sell_window
    create_command_window2
    hide_all_backwindows unless VISIBLE_BACKWINDOW
  end
  
  def create_command_window2
    create_buy_window
    @category_window.item_window = @buy_window
    @dummy_window.hide
    @category_window.select(0)
    @buy_window.select(0)
    activate_buy_window
  end
  
  def hide_all_backwindows
    instance_variables.each do |varname|
      ivar = instance_variable_get(varname)
      ivar.opacity = 0 if ivar.is_a?(Window)
    end
  end
  
  def create_category_window
    @category_window = Window_ShopItemCategory.new
    @category_window.viewport = @viewport
    @category_window.help_window = @help_window
    @category_window.y = @dummy_window.y
    @category_window.hide.deactivate
  end
  
  def create_number_window
    wy = @dummy_window.y + @category_window.height
    wh = @dummy_window.height - @category_window.height
    @number_window = Window_ShopNumber.new(0, wy, wh)
    @number_window.viewport = @viewport
    @number_window.hide
    @number_window.set_handler(:ok,     method(:on_number_ok))
    @number_window.set_handler(:cancel, method(:on_number_cancel))
  end
  
  def activate_buy_window
    @category_window.refresh
    @category_window.show.activate
    @buy_window.money = money
    @buy_window.show.activate
    @status_window.show
  end
  
  def activate_sell_window
    @category_window.refresh
    @category_window.show.activate
    @sell_window.show.refresh
    @sell_window.show.activate
    @status_window.show
  end
  
  def command_buy
    @category_window.item_window = @buy_window
    @dummy_window.hide
    @category_window.select(0)
    @buy_window.select(0)
    activate_buy_window
  end
  
  def command_sell
    @category_window.item_window = @sell_window
    @dummy_window.hide
    @category_window.select(0)
    @sell_window.select(0)
    activate_sell_window
  end
  
  def on_buy_ok
    @item = @buy_window.item
    @category_window.deactivate
    @buy_window.hide
    @number_window.set(@item, max_buy, buying_price, currency_unit)
    @number_window.show.activate
  end
  
  def on_buy_cancel
    return_scene
  end
  
  def on_sell_ok
    @item = @sell_window.item
    @category_window.deactivate
    @sell_window.hide
    @number_window.set(@item, max_sell, selling_price, currency_unit)
    @number_window.show.activate
  end
  
  def on_sell_cancel
    @command_window.activate
    @dummy_window.show
    @category_window.hide.deactivate
    @sell_window.hide
    @status_window.hide
    @status_window.item = nil
    @help_window.clear
  end
  
  def selling_price
    @sell_window.price(@item)
  end
  
  def create_buy_window
    wy = @number_window.y
    wh = @number_window.height
    @buy_window = Window_ShopBuy.new(0, wy, wh, @goods)
    @buy_window.viewport = @viewport
    @buy_window.help_window = @help_window
    @buy_window.status_window = @status_window
    @buy_window.hide
    @buy_window.set_handler(:ok,     method(:on_buy_ok))
    @buy_window.set_handler(:cancel, method(:on_buy_cancel))
    @buy_window.set_handler(:description, method(:on_item_description))
  end
  
  def create_sell_window
    wy = @number_window.y
    wh = @number_window.height
    @sell_window = Window_ShopSell.new(0, wy, @number_window.width, wh)
    @sell_window.viewport = @viewport
    @sell_window.help_window = @help_window
    @sell_window.status_window = @status_window
    @sell_window.hide
    @sell_window.set_handler(:ok,     method(:on_sell_ok))
    @sell_window.set_handler(:cancel, method(:on_sell_cancel))
    @sell_window.set_handler(:description, method(:on_item_description))
  end
  
  def item
    if @sell_window.visible
      @sell_window.item
    elsif @buy_window.visible
      @buy_window.item
    end
  end
  
  def show_sub_window(window)
    @category_window.deactivate
    @viewport.rect.width = 0
    window.show.activate
  end
  
  def hide_sub_window(window)
    @category_window.activate
    @viewport.rect.width = Graphics.width
    window.hide.deactivate
    if @sell_window.visible
      @sell_window.activate
    elsif @buy_window.visible
      @buy_window.activate
    end
  end
end