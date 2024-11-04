# encoding: utf-8
# Name: 205.Window_EquipCommand
# Size: 4744
# encoding: utf-8
# Name: 205.Window_EquipCommand
# Size: 4718
class Window_EquipCommand < Window_HorzCommand
  attr_accessor :actor
  
  def initialize(x, y, width)
    @window_width = window_width
    super(x, y)
  end
  
  def make_command_list
    for command in YEA::EQUIP::COMMAND_LIST
      case command
      when :equip
        add_command(Vocab::equip2, :equip)
      #when :optimize
      #  add_command(Vocab::optimize, :optimize)
      when :clear
        add_command(Vocab::clear, :clear)
      else
        process_custom_command(command)
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # 가온데 정렬 추가 수정
  #--------------------------------------------------------------------------
  def alignment
    return 1
  end
  
  def process_ok
    $game_temp.scene_equip_index = index
    $game_temp.scene_equip_oy = self.oy
    super
  end
  
  def process_custom_command(command)
    return unless YEA::EQUIP::CUSTOM_EQUIP_COMMANDS.include?(command)
    show = YEA::EQUIP::CUSTOM_EQUIP_COMMANDS[command][2]
    continue = show <= 0 ? true : $game_switches[show]
    return unless continue
    text = YEA::EQUIP::CUSTOM_EQUIP_COMMANDS[command][0]
    switch = YEA::EQUIP::CUSTOM_EQUIP_COMMANDS[command][1]
    enabled = switch <= 0 ? true : $game_switches[switch]
    add_command(text, command, enabled)
  end
  
  def window_width
    return 160
  end
  
  def contents_width
    return width - standard_padding * 2
  end
  
  def contents_height
    ch = height - standard_padding * 2
    return [ch - ch % item_height, row_max * item_height].max
  end
  
  def visible_line_number
    return 4
  end
  
  def col_max
    return 2
  end
  
  def item_rect(index)
    rect = Rect.new
    rect.width = item_width
    rect.height = item_height
    rect.x = index % col_max * (item_width + spacing)
    rect.y = index / col_max * item_height
    rect
  end

  def ensure_cursor_visible
    self.top_row = row if row < top_row
    self.bottom_row = row if row > bottom_row
  end
  
  def cursor_down(wrap = false)
    if index < item_max - col_max || (wrap && col_max == 1)
      select((index + col_max) % item_max)
    end
  end
  
  def cursor_up(wrap = false)
    if index >= col_max || (wrap && col_max == 1)
      select((index - col_max + item_max) % item_max)
    end
  end
  
  def process_pageup
    Sound.play_cursor
    Input.update
    deactivate
    call_handler(:pageup)
  end
  
  def process_pagedown
    Sound.play_cursor
    Input.update
    deactivate
    call_handler(:pagedown)
  end
  
  def visible_line_number
    return BM::EQUIP::COMMAND_SIDE_OPTIONS[:lines_shown]
  end
  
  def window_width
    return BM::EQUIP::COMMAND_SIDE_OPTIONS[:width]
  end
  
  def update_help
    @help_window.set_text(BM::EQUIP::COMMAND_HELP[self.index], nil)
  end
  
  alias :bm_equip_align :alignment
  def alignment
    return 1
  end
  
  def can_cancel?
    return false if @actor && @actor.available_weight < 0
    # 창피함 추가
    if @actor and @actor.available_sexy == false and !@actor.skill_learn?($data_skills[420])
      @actor.remove_state(150); @actor.remove_state(151); @actor.remove_state(152);
      @actor.remove_state(153); @actor.remove_state(154);
      # 216 변수 - 변태력
      case $game_variables[216]
      when 0..30;       @actor.add_state(150)
      when 31..50;      @actor.add_state(151)
      when 51..80;      @actor.add_state(152)
      when 81..140;     @actor.add_state(153)
      else;             @actor.add_state(154)
      end
    else
      @actor.remove_state(150); @actor.remove_state(151); @actor.remove_state(152);
      @actor.remove_state(153); @actor.remove_state(154);
    end
    return true
  end
  
  alias process_cancel_ce_equipment_weight process_cancel
  def process_cancel
    if can_cancel?
      process_cancel_ce_equipment_weight
    else
      Sound.play_buzzer
      $game_temp.pop_w(180, 'SYSTEM', "  Es demasiado pesado para usarlo.  ")
    end
  end
  
  alias process_pageup_ce_equipment_weight process_pageup
  def process_pageup
    if can_cancel?
      process_pageup_ce_equipment_weight
    else
      Sound.play_buzzer
      $game_temp.pop_w(180, 'SYSTEM', "  Es demasiado pesado para equiparlo.  ")
    end
  end
  
  alias process_pagedown_ce_equipment_weight process_pagedown
  def process_pagedown
    if can_cancel?
      process_pagedown_ce_equipment_weight
    else
      Sound.play_buzzer
      $game_temp.pop_w(180, 'SYSTEM', "  Es demasiado pesado para ponértelo.  ")
    end
  end
end