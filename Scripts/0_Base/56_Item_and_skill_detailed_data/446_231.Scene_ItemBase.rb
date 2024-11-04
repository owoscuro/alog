# encoding: utf-8
# Name: 231.Scene_ItemBase
# Size: 641
class Scene_ItemBase
  alias tmitwin_scene_itembase_start start
  def start
    tmitwin_scene_itembase_start
    create_description_window
  end
end

class Scene_Item
  alias tmitwin_scene_item_create_item_window create_item_window
  def create_item_window
    tmitwin_scene_item_create_item_window
    @item_window.set_handler(:description, method(:on_item_description))
  end
end

class Scene_Skill
  alias tmitwin_scene_skill_create_item_window create_item_window
  def create_item_window
    tmitwin_scene_skill_create_item_window
    @item_window.set_handler(:description, method(:on_item_description))
  end
end