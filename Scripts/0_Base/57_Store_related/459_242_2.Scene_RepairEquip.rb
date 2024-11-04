# encoding: utf-8
# Name: 242_2.Scene_RepairEquip
# Size: 3113
class Scene_RepairEquip < Scene_ItemBase
  def start
    super
    create_help_window
    create_item_window
    create_itemsize_window
    create_command_window5
    # 상세 데이터 설명창 추가
    create_description_window
  end
  
  def create_itemsize_window
    return unless Theo::LimInv::Display_ItemSize
    wy = Graphics.height - @help_window.line_height * 2
    wh = Graphics.width
    @itemsize = Window_ItemSize2.new(0,wy,wh)
    @itemsize.viewport = @viewport
    @item_window.item_size_window = @itemsize
  end

  def create_item_window
    wy = @help_window.y + @help_window.height
    wh = Graphics.height - wy - @help_window.line_height * 2
    @item_window = Window_EquipRepair.new(0, wy, Graphics.width, wh)
    @item_window.viewport = @viewport
    @item_window.help_window = @help_window
    @item_window.set_handler(:ok,     method(:on_item_ok))
    @item_window.set_handler(:cancel, method(:on_item_cancel))
    @item_window.category = :item
    #--------------------------------------------------------------------------
    # 상세 데이터 설명창 추가
    #--------------------------------------------------------------------------
    @item_window.set_handler(:description, method(:on_item_description))
    #--------------------------------------------------------------------------
  end
  
  #--------------------------------------------------------------------------
  # 상세 데이터 설명창 추가
  #--------------------------------------------------------------------------
  def create_description_window
    @description_window = Window_ItemDescription.new
    @description_window.hide
    @description_window.set_handler(:ok, method(:no_item_description))
    @description_window.set_handler(:cancel, method(:no_item_description))
  end
  
  def no_item_description
    Sound.play_cancel
    @item_window.show.activate
    @help_window.show
    @itemsize.show
    @description_window.hide.deactivate
  end
  
  def on_item_description
    @description_window.show.activate
    @description_window.refresh(@item_window.item)
    @help_window.hide
    @itemsize.hide
    @item_window.hide
  end
  
  def create_command_window5
    @item_window.activate
    @item_window.select(0)
  end

  def on_item_ok
    ro_item_pr = 1 - (item.durability.to_f/item.max_durability).to_f
    ro_item_pr = (item.price * ro_item_pr).to_i
    #ro_item_pr = ((ro_item_pr * TH_Instance::Scene_Repair::Price_Mod) / (500 - $game_variables[163])).to_i * 3 + 1
    # 수리 가격 수정
    ro_item_pr = (ro_item_pr * ($game_variables[163] * 0.01).to_f).to_i
    $game_party.lose_gold(ro_item_pr)
    item.repair
    @itemsize.refresh
    on_item_sound
    activate_item_window
  end
  
  def on_item_cancel
    return_scene
  end
  
  def command_repair
    @item_window.activate
    @item_window.select(0)
  end
  
  def on_item_sound
    RPG::SE.stop
    sound_effect = TH_Instance::Scene_Repair::SE
    RPG::SE.new(sound_effect[0], sound_effect[1], sound_effect[2]).play
  end
end