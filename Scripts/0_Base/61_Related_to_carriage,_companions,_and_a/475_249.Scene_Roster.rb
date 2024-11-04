# encoding: utf-8
# Name: 249.Scene_Roster
# Size: 1477
class Scene_Roster < Scene_Base
  def start
    #super # 장면 커먼 이벤트에 오류 발생하여 추가 실험
    create_background
    #create_actorList_window  # 장면 커먼 이벤트에 오류 발생하여 추가 실험
    @list_window = Window_ActorList.new
    @list_window.set_handler(:cancel, method(:close_scene))
    @status_window = Window_RosterStatus.new(@list_window.current_actor)
    @status_window.x = @list_window.width
  end
  
  def initialize
    super
  end
  
  def terminate
    super
    dispose_background
  end
  
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
  
  def dispose_background
    @background_sprite.dispose
  end
  
  def dispose_main_viewport
    @background_sprite.dispose
  end
  
  def update
    super
    @status_window.actor = @list_window.current_actor
  end
  
  def close_scene
    SceneManager.return
  end
end

class Scene_Medal < Scene_MenuBase
  def start
    super
    create_help_window
    create_item_window
  end
  
  def create_item_window
    wy = @help_window.height
    wh = Graphics.height - wy
    @item_window = Window_Medal.new(0, wy, Graphics.width, wh)
    @item_window.viewport = @viewport
    @item_window.help_window = @help_window
    @item_window.set_handler(:cancel, method(:return_scene))
  end
end