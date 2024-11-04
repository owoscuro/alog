# encoding: utf-8
# Name: 196.Window_ShopBuy
# Size: 2051
class Window_ShopBuy
  include ShopItemList
  def initialize(x, y, height, shop_goods)
    super(x, y, window_width, height)
    @shop_goods = shop_goods
    @money = 0
  end

  def make_item_list
    @data = []
    @price = {}
    @shop_goods.each do |goods|
      case goods[0]
      when 0;  item = $data_items[goods[1]]
      when 1;  item = $data_weapons[goods[1]]
      when 2;  item = $data_armors[goods[1]]
      end
      if item && include?(item)
        @data.push(item)
        @price[item] = goods[2] == 0 ? item.price : goods[3]
      end
    end
  end
end

class Window_ShopBuy < Window_Selectable
  alias tmprice_window_shopbuy_price price
  def price(item)
    return item.price unless @price[item]
    if $game_switches[TMPRICE::SW_USE]
      # 구매
      #@price[item] * ($game_variables[163] * 0.01).to_i
      @price[item] + (@price[item] * ($game_variables[163] * 0.01)).to_i
    else
      tmprice_window_shopbuy_price(item)
    end
  end
  
  #-----------------------------------------------------------------------------
  # * 통화 세분화 시작
  #-----------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    rect = item_rect(index)
    draw_item_name(item, rect.x, rect.y, enable?(item))
    rect.width -= 4
    draw_currency_value(price(item), "", rect.x, rect.y, rect.width, 0)
  end
end

class Window_ShopSell
  include ShopItemList
  def col_max
    return 1
  end
  
  def draw_item(index)
    item = @data[index]
    rect = item_rect(index)
    draw_item_name(item, rect.x, rect.y, enable?(item))
    rect.width -= 4
    draw_text(rect, price(item), 2)
  end
  
  #--------------------------------------------------------------------------
  # ● 아이템 가격 설정
  #--------------------------------------------------------------------------
  def price(item)
    # 판매
    #return Integer(item.price * ($game_variables[161] * 0.01).to_i)
    return Integer(item.price + (item.price * ($game_variables[161] * 0.01)).to_i)
  end
end