# encoding: utf-8
# Name: 158.Window_ShopBuy
# Size: 253
class Window_ShopBuy < Window_Selectable
  def draw_item(index)
    item = @data[index]
    rect = item_rect(index)
    draw_item_name(item, rect.x, rect.y, enable?(item))
    rect.width -= 4
    draw_text(rect, price(item).group, 2)
  end
end