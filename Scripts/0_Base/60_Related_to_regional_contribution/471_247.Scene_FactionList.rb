# encoding: utf-8
# Name: 247.Scene_FactionList
# Size: 1989
class Scene_FactionList < Scene_Base
  def start
    super
    create_category_window
    create_help_window
    create_fac_list_window
    # 메뉴 배경을 반투명하게 변경
    create_background
    create_desc_window if SZS_Factions::UseDescriptions
  end
  
  # 메뉴 배경을 반투명하게 변경
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
  
  def dispose_background
    @background_sprite.dispose
  end
  
  def create_category_window
    @category_win = Window_FactionCategory.new
    @category_win.set_handler(:ok,     method(:on_category_ok))
    @category_win.set_handler(:cancel, method(:return_scene))
  end
  
  def create_help_window
    @help_window = Window_FactionStatus.new
  end
  
  def create_fac_list_window
    y = @category_win.height
    w = Graphics.width
    h = Graphics.height-y-@help_window.height
    w /= 4 if SZS_Factions::UseDescriptions
    @fac_list_win = Window_FactionList.new(0,y,w,h)
    @fac_list_win.help_window = @help_window
    @fac_list_win.set_handler(:cancel, method(:on_faction_cancel))
    @category_win.reputation_window = @fac_list_win
  end
  
  def create_desc_window
    y = @category_win.height
    h = Graphics.height-y-@help_window.height
    x = @fac_list_win.width
    w = Graphics.width - x
    @desc_window = Window_FactionDescription.new(x,y,w,h)
    @fac_list_win.description_window = @desc_window
  end
  
  def terminate
    super
    @category_win.dispose
    @fac_list_win.dispose
    @help_window.dispose
    @desc_window.dispose if @desc_window
  end
  
  def on_category_ok
    @fac_list_win.activate.select(0)
  end
  
  def on_faction_cancel
    @fac_list_win.deactivate.select(-1)
    @help_window.faction = nil
    @desc_window.faction = nil if @desc_window
    @category_win.activate
  end
end