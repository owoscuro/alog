# encoding: utf-8
# Name: 236.Scene_Equip
# Size: 4041
class Scene_Equip < Scene_MenuBase
  alias :bm_equip_start :start
  def start
    bm_equip_start
    unless $imported["YEA-AceEquipEngine"]
      create_actor_window
    end
    @status_window.slot_window = @slot_window
    @actor_window.slot_window = @slot_window
    @command_window.help_window = @help_window
    relocate_windows
  end
  
  def create_actor_window
    if $imported["YEA-AceEquipEngine"]
      x = @command_window.width
    else
      x = 0
    end
    @help_window.width = BM::EQUIP::COMMAND_SIDE_OPTIONS[:width]
    @help_window.height = 0
    wy = 0
    @actor_window = Window_EquipActor.new(x, wy)
    @actor_window.viewport = @viewport
    @actor_window.actor = @actor
  end
  
  alias :bm_equip_ciw :create_item_window
  def create_item_window
    if $imported["YEA-AceEquipEngine"]
      bm_equip_ciw
    else
      wx = @command_window.width
      wy = @slot_window.y + @slot_window.height
      ww = Graphics.width - wx
      wh = Graphics.height - wy
      @item_window = Window_EquipItem.new(wx, wy, ww, wh)
      @item_window.viewport = @viewport
      @item_window.help_window = @help_window
      @item_window.status_window = @status_window
      @item_window.actor = @actor
      @item_window.set_handler(:ok,     method(:on_item_ok))
      @item_window.set_handler(:cancel, method(:on_item_cancel))
      @slot_window.item_window = @item_window
    end
  end

  def create_status_window
    if $imported["YEA-AceEquipEngine"]
      wx = BM::EQUIP::COMMAND_SIDE_OPTIONS[:width]
    else
      wx = 0
    end
    wy = 0
    @status_window = Window_EquipStatus.new(wx, wy)
    @status_window.viewport = @viewport
    @status_window.actor = @actor
    @status_window.hide
  end

  alias :bm_equip_oso :on_slot_ok
  def on_slot_ok
    bm_equip_oso
    @slot_window.hide if $imported["YEA-AceEquipEngine"]
    @item_window.refresh
    @item_window.show
    @status_window.show
    @actor_window.hide
  end
  
  alias :bm_equip_oio :on_item_ok
  def on_item_ok
    bm_equip_oio
    @actor_window.refresh unless $imported["YEA-AceEquipEngine"]
    @actor_window.show
    @status_window.hide
  end
  
  alias :bm_equip_oic :on_item_cancel
  def on_item_cancel
    bm_equip_oic
    @actor_window.show
    @status_window.hide
  end

  alias :bm_equip_cc :command_clear
  def command_clear
    bm_equip_cc
    @actor_window.refresh unless $imported["YEA-AceEquipEngine"]
  end

  def command_clear2
    Sound.play_equip
    @actor.clear_equipments
    @status_window.refresh
    @slot_window.refresh
    @actor_window.refresh
  end
  
  alias :bm_equip_oac :on_actor_change
  def on_actor_change
    bm_equip_oac
    @actor_window.actor = @actor unless $imported["YEA-AceEquipEngine"]
  end
  
  def relocate_windows
    if BM::EQUIP::COMMAND_SIDE_OPTIONS[:left]
      @command_window.x = 0
      @item_window.x = 0
      @status_window.x = @command_window.width
      @actor_window.x = @command_window.width
      @slot_window.x = 0
    else
      @command_window.x = @status_window.width
      @item_window.x = @status_window.width
      @status_window.x = 0
      @actor_window.x = 0
      @slot_window.x = @status_window.width
    end
    return unless $imported["YEA-AceMenuEngine"]
    case Menu.help_window_location
    when 0
      @help_window.width = BM::EQUIP::COMMAND_SIDE_OPTIONS[:width]
      @help_window.height = 0
      @status_window.y = 0
      @command_window.y = 0
      @slot_window.y = @command_window.y + @command_window.height
      if $imported["YEA-AceEquipEngine"]
        @item_window.y = @slot_window.y
      else
        @item_window.y = @slot_window.y + @slot_window.height
      end
    when 2
      @status_window.y = 0
      @command_window.y = 0
      @slot_window.y = @command_window.y + @command_window.height
      if $imported["YEA-AceEquipEngine"]
        @item_window.y = @slot_window.y
      else
        @item_window.y = @slot_window.y + @slot_window.height
      end
    end
    @actor_window.y = @status_window.y
  end  
  
  def relocate_aee_windows
    return
  end
end