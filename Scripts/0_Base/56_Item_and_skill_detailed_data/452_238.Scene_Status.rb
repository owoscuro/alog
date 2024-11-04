# encoding: utf-8
# Name: 238.Scene_Status
# Size: 1746
# encoding: utf-8
# Name: 238.Scene_Status
# Size: 1694
class Scene_Status < Scene_MenuBase
  def start
    super
    create_command_window
    create_item_window
    relocate_windows
  end
  
  def create_command_window
    @command_window = Window_StatusCommand.new(0, 0)
    @command_window.viewport = @viewport
    @command_window.actor = @actor
    @command_window.set_handler(:cancel,   method(:return_scene))
    @command_window.set_handler(:pagedown, method(:next_actor))
    @command_window.set_handler(:pageup,   method(:prev_actor))
    process_custom_status_commands
  end
  
  def process_custom_status_commands
    for command in YEA::STATUS::COMMANDS
      next unless YEA::STATUS::CUSTOM_STATUS_COMMANDS.include?(command[0])
      called_method = YEA::STATUS::CUSTOM_STATUS_COMMANDS[command[0]][2]
      @command_window.set_handler(command[0], method(called_method))
    end
  end
  
  def create_item_window
    dy = @command_window.y + @command_window.height
    @item_window = Window_StatusItem.new(0, dy, @command_window)
    @item_window.viewport = @viewport
    @item_window.actor = @actor
    @command_window.item_window = @item_window
  end
  
  def relocate_windows
    return unless $imported["YEA-AceMenuEngine"]
    @help_window.y = 0
    @command_window.y = @help_window.height
    @item_window.y = @command_window.y + @command_window.height
    @status_window.y = @command_window.y
  end
  
  def on_actor_change
    if @actor != nil
      @command_window.actor = @actor
      @item_window.actor = @actor
    else
      Sound.play_buzzer
      $game_temp.pop_w(180, 'SYSTEM', "  No hay personajes para cambiar.  ")
    end
    @command_window.activate
  end
end