# encoding: utf-8
# Name: 160.Window_FileAction
# Size: 2543
class Window_FileAction < Window_HorzCommand
  def initialize(dx, dy, file_window)
    @file_window = file_window
    super(dx, dy)
    deactivate
    unselect
  end
  
  def window_width; Graphics.width - 128; end
  
  def col_max; return 3; end
  
  def update
    super
    return if @file_window == nil
    return if @file_window.index < 0
    return if @current_index == @file_window.index
    @current_index = @file_window.index
    refresh
  end
  
  def make_command_list
    @header = DataManager.load_header(@file_window.index)
    add_load_command
    add_save_command
    add_delete_command
  end
  
  def add_load_command
    add_command(YEA::SAVE::ACTION_LOAD, :load, load_enabled?)
  end
  
  def load_enabled?
    return false if @header.nil?
    return true
  end
  
  def add_save_command
    add_command(YEA::SAVE::ACTION_SAVE, :save, save_enabled?)
  end
  
  def save_enabled?
    # 저장 금지, 불가능한 지역 확인
    return false if $game_switches[39] == true
    return false if $game_variables[18] == 2 and $game_switches[40] == false
    return false if $game_variables[18] == 4 and $game_switches[40] == false
    return false if $game_variables[18] == 5 and $game_switches[40] == false
    return false if @header.nil? && SceneManager.scene_is?(Scene_Load)
    return false if SceneManager.scene_is?(Scene_Load)
    return false if $game_system.save_disabled
    return true
  end
  
  def add_delete_command
    add_command(YEA::SAVE::ACTION_DELETE, :delete, delete_enabled?)
  end
  
  def delete_enabled?
    return false if @header.nil?
    return true
  end
  
  def update_help
    if current_symbol != nil
      case current_symbol
      when :load
        @help_window.set_text(YEA::SAVE::LOAD_HELP, nil)
      when :save
        if $game_switches[39] == true
          @help_window.set_text(YEA::SAVE::SAVE_HELP_NO2, nil)
        elsif $game_variables[18] == 2 and $game_switches[40] == false
          @help_window.set_text(YEA::SAVE::SAVE_HELP_NO, nil)
        elsif $game_variables[18] == 4 and $game_switches[40] == false
          @help_window.set_text(YEA::SAVE::SAVE_HELP_NO, nil)
        elsif $game_variables[18] == 5 and $game_switches[40] == false
          @help_window.set_text(YEA::SAVE::SAVE_HELP_NO, nil)
        else
          @help_window.set_text(YEA::SAVE::SAVE_HELP, nil)
        end
      when :delete
        @help_window.set_text(YEA::SAVE::DELETE_HELP, nil)
      end
    end
  end
end