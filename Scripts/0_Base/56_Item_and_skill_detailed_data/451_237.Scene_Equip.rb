# encoding: utf-8
# Name: 237.Scene_Equip
# Size: 963
class Scene_Equip
  alias tmitwin_scene_equip_start start
  def start
    tmitwin_scene_equip_start
    create_description_window
  end
  
  alias tmitwin_scene_equip_create_slot_window create_slot_window
  def create_slot_window
    tmitwin_scene_equip_create_slot_window
    @slot_window.set_handler(:description, method(:on_item_description))
  end
  
  alias tmitwin_scene_equip_create_item_window create_item_window
  def create_item_window
    tmitwin_scene_equip_create_item_window
    @item_window.set_handler(:description, method(:on_item_description))
  end
  
  def item
    (@item_window.index == -1 ? @slot_window : @item_window).item
  end
  
  def show_sub_window(window)
    @viewport.rect.width = 0
    window.show.activate
  end
  
  def hide_sub_window(window)
    @viewport.rect.width = Graphics.width
    window.hide.deactivate
    (@item_window.index == -1 ? @slot_window : @item_window).activate
  end
end