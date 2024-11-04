# encoding: utf-8
# Name: 175.Window_StatusCommand
# Size: 2705
class Window_StatusCommand < Window_Command
  attr_accessor :item_window
  
  def initialize(dx, dy)
    super(dx, dy)
    @actor = nil
  end
  
  #--------------------------------------------------------------------------
  # 가온데 정렬 추가 수정
  #--------------------------------------------------------------------------
  def alignment
    return 1
  end
  
  def window_width
    return Graphics.width
  end
  
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
  end
  
  def visible_line_number
    return 1
  end
  
  # 지역 정보를 제외하고 인물 정보를 포함하여 3 대입
  def col_max
    return 3
  end
  
  def ok_enabled?
    return handle?(current_symbol)
  end
  
  def make_command_list
    return unless @actor
    for command in YEA::STATUS::COMMANDS
      # 능력치 정보 하위 메뉴
      #print(" + Window_StatusCommand - %s \n" % [command[0]]);
      case command[0]
      when :general, :parameters, :properties, :biography
        add_command(command[1], command[0])
      when :rename
        next unless $imported["YEA-RenameActor"]
        add_command(command[1], command[0], @actor.rename_allow?)
      when :retitle
        next unless $imported["YEA-RenameActor"]
        add_command(command[1], command[0], @actor.retitle_allow?)
      else
        process_custom_command(command)
      end
    end
    if !$game_temp.scene_status_index.nil?
      select($game_temp.scene_status_index)
      self.oy = $game_temp.scene_status_oy
    end
    $game_temp.scene_status_index = nil
    $game_temp.scene_status_oy = nil
  end
  
  def process_ok
    $game_temp.scene_status_index = index
    $game_temp.scene_status_oy = self.oy
    super
  end
  
  def process_custom_command(command)
    return unless YEA::STATUS::CUSTOM_STATUS_COMMANDS.include?(command[0])
    show = YEA::STATUS::CUSTOM_STATUS_COMMANDS[command[0]][1]
    continue = show <= 0 ? true : $game_switches[show]
    return unless continue
    text = command[1]
    switch = YEA::STATUS::CUSTOM_STATUS_COMMANDS[command[0]][0]
    enabled = switch <= 0 ? true : $game_switches[switch]
    add_command(text, command[0], enabled)
  end
  
  def update
    super
    update_item_window
  end
  
  def update_item_window
    return if @item_window.nil?
    return if @current_index == current_symbol
    @current_index = current_symbol
    @item_window.refresh
  end
  
  def item_window=(window)
    @item_window = window
    update
  end
  
  def update_help
    return if @actor.nil?
    @help_window.set_text(@actor.actor.description, nil)
  end
end