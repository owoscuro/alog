# encoding: utf-8
# Name: 285. Remove Window Movement
# Size: 677
class Window_Base < Window
  def update_open
    self.openness += 255
    @opening = false if open?
  end
  
  def update_close
    self.openness -= 255
    @closing = false if close?
  end
end

class Scene_Menu < Scene_MenuBase
  def transition_speed
    return 0
  end
  def terminate
    super
    Graphics.transition(0)
  end
end

class Scene_ItemBase < Scene_MenuBase
  def transition_speed
    return 0
  end
  def terminate
    super
    Graphics.transition(0)
  end
end

class Scene_Map < Scene_Base
  def transition_speed
    return 0
  end
  def terminate
    super
    SceneManager.snapshot_for_background
    @spriteset.dispose
    Graphics.transition(0)
  end
end