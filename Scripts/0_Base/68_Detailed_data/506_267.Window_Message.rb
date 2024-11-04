# encoding: utf-8
# Name: 267.Window_Message
# Size: 1587
class Window_Message
  alias tmitwin_window_message_create_all_windows create_all_windows
  def create_all_windows
    tmitwin_window_message_create_all_windows
    @item_window.set_handler(:description, method(:on_item_description))
    create_description_window
  end
  
  alias tmitwin_window_message_dispose_all_windows dispose_all_windows
  def dispose_all_windows
    tmitwin_window_message_dispose_all_windows
    @description_window.dispose
  end
  
  def input_item
    @item_window.start
    Fiber.yield while (@item_window.active || @description_window.active)
  end
  
  #--------------------------------------------------------------------------
  # ○ 항목 자세한 창 만들기
  #--------------------------------------------------------------------------
  def create_description_window
    @description_window = Window_ItemDescription.new
    @description_window.set_handler(:ok,     method(:on_description_ok))
    @description_window.set_handler(:cancel, method(:on_description_cancel))
  end
  
  def on_description_ok
    Sound.play_ok
    hide_sub_window(@description_window)
  end
  
  def on_description_cancel
    Sound.play_cancel
    hide_sub_window(@description_window)
  end
  
  def on_item_description
    @description_window.refresh(@item_window.item)
    show_sub_window(@description_window)
  end
  
  def show_sub_window(window)
    @item_window.hide.deactivate
    window.show.activate
  end
  
  def hide_sub_window(window)
    window.hide.deactivate
    @item_window.show.activate
  end
end