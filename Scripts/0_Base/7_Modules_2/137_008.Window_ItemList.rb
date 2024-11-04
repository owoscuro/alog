# encoding: utf-8
# Name: 008.Window_ItemList
# Size: 221
class Window_ItemList < Window_Selectable
  alias :th_instance_items_draw_item_number :draw_item_number
  def draw_item_number(rect, item)
    th_instance_items_draw_item_number(rect, item) if item.is_template?
  end
end