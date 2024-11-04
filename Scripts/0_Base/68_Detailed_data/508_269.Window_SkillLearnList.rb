# encoding: utf-8
# Name: 269.Window_SkillLearnList
# Size: 3241
class Window_SkillLearnList
  alias tmitwin_Window_SkillLearnList_process_handling process_handling
  def process_handling
    tmitwin_Window_SkillLearnList_process_handling
    return unless open? && active
    if $game_switches[TMITWIN::SW_NOUSE_ITEM_INFO] == false and !SceneManager.scene_is?(Scene_Map)
      return process_description if Input.trigger?(TMITWIN::KEY_SYMBOL) or Keyboard.trigger?(:kN)
    end
  end
  
  def process_description
    if @data[index]
      Sound.play_ok
      Input.update
      deactivate
      call_handler(:description)
    else
      Sound.play_buzzer
    end
  end
end

class Window_SkillList
  alias tmitwin_window_skilllist_process_handling process_handling
  def process_handling
    tmitwin_window_skilllist_process_handling
    return unless open? && active
    if $game_switches[TMITWIN::SW_NOUSE_ITEM_INFO] == false and !SceneManager.scene_is?(Scene_Map)
      return process_description if Input.trigger?(TMITWIN::KEY_SYMBOL) or Keyboard.trigger?(:kN)
    end
  end
  
  def process_description
    if @data[index]
      Sound.play_ok
      Input.update
      deactivate
      call_handler(:description)
    else
      Sound.play_buzzer
    end
  end
end

class Window_EquipSlot
  alias tmitwin_window_equipslot_process_handling process_handling
  def process_handling
    tmitwin_window_equipslot_process_handling
    return unless open? && active
    if $game_switches[TMITWIN::SW_NOUSE_ITEM_INFO] == false and !SceneManager.scene_is?(Scene_Map)
      return process_description if Input.trigger?(TMITWIN::KEY_SYMBOL) or Keyboard.trigger?(:kN)
    end
  end
  
  def process_description
    unless $game_switches[TMITWIN::SW_NOUSE_ITEM_INFO]
      if item
        Sound.play_ok
        Input.update
        deactivate
        call_handler(:description)
      else
        Sound.play_buzzer
      end
    end
  end
end

class Window_ShopBuy
  alias tmitwin_window_shopbuy_process_handling process_handling
  def process_handling
    tmitwin_window_shopbuy_process_handling
    return unless open? && active
    if $game_switches[TMITWIN::SW_NOUSE_ITEM_INFO] == false and !SceneManager.scene_is?(Scene_Map)
      return process_description if Input.trigger?(TMITWIN::KEY_SYMBOL) or Keyboard.trigger?(:kN)
    end
  end
  
  def process_description
    unless $game_switches[TMITWIN::SW_NOUSE_ITEM_INFO]
      if @data[index]
        Sound.play_ok
        Input.update
        deactivate
        call_handler(:description)
      else
        Sound.play_buzzer
      end
    end
  end
end

class Window_ItemList
  alias tmitwin_window_itemlist_process_handling process_handling
  def process_handling
    tmitwin_window_itemlist_process_handling
    return unless open? && active
    if $game_switches[TMITWIN::SW_NOUSE_ITEM_INFO] == false and !SceneManager.scene_is?(Scene_Map)
      if @heading == nil
        return process_description if Input.trigger?(TMITWIN::KEY_SYMBOL) or Keyboard.trigger?(:kN)
      end
    end
  end
  
  def process_description
    unless $game_switches[TMITWIN::SW_NOUSE_ITEM_INFO]
      if @data[index]
        Sound.play_ok
        Input.update
        deactivate
        call_handler(:description)
      else
        Sound.play_buzzer
      end
    end
  end
end