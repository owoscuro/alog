# encoding: utf-8
# Name: 248.Scene_Lune_Map
# Size: 1599
class Scene_Lune_Map < Scene_ItemBase
  def start
    super
    @get_index = 0
    $lune_map_info = Array.new
    Lune_Map::Map_Info.each {|map| $lune_map_info.push(map) if $game_switches[map['Switch']]}
    create_category_window
    # 시작하는 위치
    @category_window.index = $game_variables[185]
    create_map_window
  end
  
  def create_category_window
    @help_window = Window_Help_Map.new
    @help_window.viewport = @viewport
    @category_window = Window_MapList.new
    @category_window.viewport = @viewport
    @category_window.y = @help_window.height
    @help_window.z = @category_window.z = 400
    @category_window.set_handler(:cancel, method(:return_scene))
  end
  
  def create_map_window
    @item_window = Window_ShowMap.new
    @item_window.viewport = @viewport
    @category_window.item_window = @item_window
  end
  
  def update
    super
    @item_window.refresh(@category_window.index) unless $lune_map_info == []
    @help_window.refresh(@category_window.index) unless $lune_map_info == []
  end
  
  def on_category_ok
    @item_window.activate
    @item_window.select_last
  end
  
  def on_item_ok
    $game_party.last_item.object = item
    determine_item
  end
  
  def on_item_cancel
    @item_window.unselect
    @category_window.activate
  end
  
  def play_se_for_item
    Sound.play_use_item
  end
  
  def use_item
    super
    @item_window.redraw_current_item
  end
  
  def terminate
    super
    @help_window.dispose
    @item_window.dispose
    @category_window.dispose
  end
end