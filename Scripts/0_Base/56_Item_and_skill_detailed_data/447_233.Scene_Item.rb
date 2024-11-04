# encoding: utf-8
# Name: 233.Scene_Item
# Size: 2560
class Scene_Item < Scene_ItemBase
  
  alias theo_liminv_start start
  def start
    theo_liminv_start
    
    resize_item_window
    create_itemsize_window
  end
  
  def resize_item_window
    @item_window.height -= @item_window.line_height * 2
  end
  
  def create_itemsize_window
    return unless Theo::LimInv::Display_ItemSize
    wy = @item_window.y + @item_window.height
    wh = Graphics.width
    @itemsize = Window_ItemSize.new(0,wy,wh)
    @itemsize.viewport = @viewport
    @item_window.item_size_window = @itemsize
  end
  
  alias theo_liminv_use_item use_item
  def use_item
    theo_liminv_use_item
    @itemsize.refresh
  end
  
  alias :th_map_drops_item_window :create_item_window
  def create_item_window
    th_map_drops_item_window
    @item_window.set_handler(:drop, method(:on_item_drop))
  end
  
  def on_item_drop
    if item != nil
      if item.is_a?(RPG::Item) and item.key_item?
        Sound.play_buzzer
        @item_window.activate
      else
        Sound.play_cursor
        drop_item
      end
    else
      Sound.play_buzzer
      @item_window.activate
    end
  end
  
  # 상점에 사용되는 부분
  #def currency_unit
  #  @status_window.currency_unit
  #end
  
  def max_naver
    $game_party.item_number(@item_window.item)
  end
  
  def line_height
    return 24
  end
  
  def drop_item
    @number_window = Window_StorageNumber.new
    @number_window.viewport = @viewport
    @number_window.x = ((Graphics.width / 2) - (@number_window.width / 2)) 
    @number_window.y = ((Graphics.height / 2) - (@number_window.height / 2)) 
    @number_window.set(item, max_naver)
    @item_window.deactivate
    @number_window.show.activate
    # 구매 혹은 판매 수량 조절 활성화 상태
    @number_window.set_handler(:ok,     method(:on_number_ok))
    @number_window.set_handler(:cancel, method(:on_number_cancel))
  end
  
  def on_number_ok
    activate_sell_window
  end
  
  def activate_sell_window
    number = @number_window.number
    $game_party.lose_item(item, number)
    @help_window.clear
    @number_window.hide.deactivate
    @item_window.show
    @item_window.refresh
    @item_window.index -= 1 if @item_window.item == nil
    @item_window.index == -1 ? @item_window.activate.select(0) : @item_window.activate
    @category_window.item_window = @item_window
  end
  
  def on_number_cancel
    @number_window.hide.deactivate
    @item_window.show.activate
    @item_window.refresh
  end
end