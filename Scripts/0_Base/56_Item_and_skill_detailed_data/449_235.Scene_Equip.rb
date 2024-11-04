# encoding: utf-8
# Name: 235.Scene_Equip
# Size: 3208
class Scene_Equip < Scene_MenuBase

  def alignment
    return 1
  end
  
  def create_command_window
    wx = 0
    wy = 0
    ww = 160
    @command_window = Window_EquipCommand.new(wx, wy, ww)
    @command_window.actor = @actor
    @command_window.viewport = @viewport
    @command_window.help_window = @help_window
    if !$game_temp.scene_equip_index.nil?
      @command_window.select($game_temp.scene_equip_index)
      @command_window.oy = $game_temp.scene_equip_oy
    end
    $game_temp.scene_equip_index = nil
    $game_temp.scene_equip_oy = nil
    @command_window.set_handler(:equip,    method(:command_equip))
    @command_window.set_handler(:optimize, method(:command_optimize))
    @command_window.set_handler(:clear,    method(:command_clear))
    @command_window.set_handler(:cancel,   method(:return_scene))
    @command_window.set_handler(:pagedown, method(:next_actor))
    @command_window.set_handler(:pageup,   method(:prev_actor))
    process_custom_equip_commands
    create_actor_window
  end

  def process_custom_equip_commands
    for command in YEA::EQUIP::COMMAND_LIST
      next unless YEA::EQUIP::CUSTOM_EQUIP_COMMANDS.include?(command)
      called_method = YEA::EQUIP::CUSTOM_EQUIP_COMMANDS[command][3]
      @command_window.set_handler(command, method(called_method))
    end
  end
  
  def create_slot_window
    wx = 0
    wy = @command_window.y + @command_window.height
    ww = Graphics.width - @status_window.width
    @slot_window = Window_EquipSlot.new(wx, wy, ww)
    @slot_window.viewport = @viewport
    @slot_window.help_window = @help_window
    @slot_window.status_window = @status_window
    @slot_window.actor = @actor
    @slot_window.set_handler(:ok,       method(:on_slot_ok))
    @slot_window.set_handler(:cancel,   method(:on_slot_cancel))
  end
  
  def create_item_window
    wx = @slot_window.x
    wy = @slot_window.y
    ww = @slot_window.width
    wh = @slot_window.height
    @item_window = Window_EquipItem.new(wx, wy, ww, wh)
    @item_window.viewport = @viewport
    @item_window.help_window = @help_window
    @item_window.status_window = @status_window
    @item_window.actor = @actor
    @item_window.set_handler(:ok,     method(:on_item_ok))
    @item_window.set_handler(:cancel, method(:on_item_cancel))
    @slot_window.item_window = @item_window
    @item_window.hide
  end

  alias scene_equip_command_clear_aee command_clear
  def command_clear
    scene_equip_command_clear_aee
    @actor_window.refresh
  end
  
  alias scene_equip_on_slot_ok_aee on_slot_ok
  def on_slot_ok
    scene_equip_on_slot_ok_aee
    @slot_window.hide
    @item_window.refresh
    @item_window.show
  end
  
  alias scene_equip_on_item_cancel_aee on_item_cancel
  def on_item_cancel
    scene_equip_on_item_cancel_aee
    @slot_window.show
    @item_window.hide
  end

  alias scene_equip_on_item_ok_aee on_item_ok
  def on_item_ok
    scene_equip_on_item_ok_aee
    @actor_window.refresh
    @slot_window.show
    @item_window.hide
  end
  
  alias scene_equip_on_actor_change_aee on_actor_change
  def on_actor_change
    scene_equip_on_actor_change_aee
    @actor_window.actor = @actor
  end
  
  def command_name1
  end
  
  def command_name2
  end
end