# encoding: utf-8
# Name: 287.Window_SystemOptions
# Size: 8306
class Window_SystemOptions < Window_Command
  def initialize(help_window)
    @help_window = help_window
    super(0, @help_window.height)
    refresh
  end
  
  def window_width; return Graphics.width; end
  
  def window_height; return Graphics.height - @help_window.height; end
  
  def update_help
    if current_symbol == :custom_switch || current_symbol == :custom_variable
      text = @help_descriptions[current_ext]
    else
      text = @help_descriptions[current_symbol]
    end
    text = "" if text.nil?
    @help_window.set_text(text, nil)
  end
  
  def ok_enabled?
    return true if [:to_title3, :to_title2, :to_title, :shutdown].include?(current_symbol)
    return false
  end
  
  def make_command_list
    # 이미지 갱신 스위치 ON 실험
    $game_switches[195] = true
    @help_descriptions = {}
    for command in YEA::SYSTEM::COMMANDS
      case command
      when :blank
        add_command(YEA::SYSTEM::COMMAND_VOCAB[command][0], command)
        @help_descriptions[command] = YEA::SYSTEM::COMMAND_VOCAB[command][3]
      when :volume_bgm, :volume_bgs, :volume_sfx
        add_command(YEA::SYSTEM::COMMAND_VOCAB[command][0], command)
        @help_descriptions[command] = YEA::SYSTEM::COMMAND_VOCAB[command][3]
      when :autodash, :instantmsg
        add_command(YEA::SYSTEM::COMMAND_VOCAB[command][0], command)
        @help_descriptions[command] = YEA::SYSTEM::COMMAND_VOCAB[command][3]
      when :to_title3, :to_title2, :to_title, :shutdown
        add_command(YEA::SYSTEM::COMMAND_VOCAB[command][0], command)
        @help_descriptions[command] = YEA::SYSTEM::COMMAND_VOCAB[command][3]
      else
        process_custom_switch(command)
        process_custom_variable(command)
      end
    end
  end
  
  def process_custom_switch(command)
    return unless YEA::SYSTEM::CUSTOM_SWITCHES.include?(command)
    name = YEA::SYSTEM::CUSTOM_SWITCHES[command][1]
    add_command(name, :custom_switch, true, command)
    @help_descriptions[command] = YEA::SYSTEM::CUSTOM_SWITCHES[command][4]
  end
  
  def process_custom_variable(command)
    return unless YEA::SYSTEM::CUSTOM_VARIABLES.include?(command)
    name = YEA::SYSTEM::CUSTOM_VARIABLES[command][1]
    add_command(name, :custom_variable, true, command)
    @help_descriptions[command] = YEA::SYSTEM::CUSTOM_VARIABLES[command][6]
  end
  
  def draw_item(index)
    reset_font_settings
    rect = item_rect(index)
    contents.clear_rect(rect)
    case @list[index][:symbol]
    when :volume_bgm, :volume_bgs, :volume_sfx
      draw_volume(rect, index, @list[index][:symbol])
    when :autodash, :instantmsg
      draw_toggle(rect, index, @list[index][:symbol])
    when :to_title3, :to_title2, :to_title, :shutdown
      draw_text(item_rect_for_text(index), command_name(index), 1)
    when :custom_switch
      draw_custom_switch(rect, index, @list[index][:ext])
    when :custom_variable
      draw_custom_variable(rect, index, @list[index][:ext])
    end
  end
  
  def draw_volume(rect, index, symbol)
    name = @list[index][:name]
    draw_text(0, rect.y, contents.width/2, line_height, name, 1)
    dx = contents.width / 2
    case symbol
    when :volume_bgm
      rate = $game_system.volume(:bgm)
    when :volume_bgs
      rate = $game_system.volume(:bgs)
    when :volume_sfx
      rate = $game_system.volume(:sfx)
    end
    colour1 = text_color(YEA::SYSTEM::COMMAND_VOCAB[symbol][1])
    colour2 = text_color(YEA::SYSTEM::COMMAND_VOCAB[symbol][2])
    value = sprintf("%d%%", rate)
    rate *= 0.01
    draw_gauge(dx, rect.y, contents.width - dx - 48, rate, colour1, colour2)
    contents.font.bold = true
    draw_text(dx, rect.y, contents.width - dx - 48, line_height, value, 2)
  end
  
  def draw_toggle(rect, index, symbol)
    name = @list[index][:name]
    draw_text(0, rect.y, contents.width/2, line_height, name, 1)
    dx = contents.width / 2
    case symbol
    when :autodash
      enabled = $game_system.autodash?
    when :instantmsg
      enabled = $game_system.instantmsg?
    end
    dx = contents.width/2
    contents.font.bold = true
    change_color(normal_color, !enabled)
    change_color(text_color(3)) if !enabled
    option1 = YEA::SYSTEM::COMMAND_VOCAB[symbol][1]
    draw_text(dx, rect.y, contents.width/4, line_height, option1, 1)
    dx += contents.width/4
    change_color(normal_color, enabled)
    change_color(text_color(3)) if enabled
    option2 = YEA::SYSTEM::COMMAND_VOCAB[symbol][2]
    draw_text(dx, rect.y, contents.width/4, line_height, option2, 1)
  end
  
  def draw_custom_switch(rect, index, ext)
    name = @list[index][:name]
    draw_text(0, rect.y, contents.width/2, line_height, name, 1)
    dx = contents.width / 2
    enabled = $game_switches[YEA::SYSTEM::CUSTOM_SWITCHES[ext][0]]
    dx = contents.width/2
    contents.font.bold = true
    change_color(normal_color, !enabled)
    change_color(text_color(3)) if !enabled
    option1 = YEA::SYSTEM::CUSTOM_SWITCHES[ext][2]
    draw_text(dx, rect.y, contents.width/4, line_height, option1, 1)
    dx += contents.width/4
    change_color(normal_color, enabled)
    change_color(text_color(3)) if enabled
    option2 = YEA::SYSTEM::CUSTOM_SWITCHES[ext][3]
    draw_text(dx, rect.y, contents.width/4, line_height, option2, 1)
  end
  
  def draw_custom_variable(rect, index, ext)
    name = @list[index][:name]
    draw_text(0, rect.y, contents.width/2, line_height, name, 1)
    dx = contents.width / 2
    value = $game_variables[YEA::SYSTEM::CUSTOM_VARIABLES[ext][0]]
    colour1 = text_color(YEA::SYSTEM::CUSTOM_VARIABLES[ext][2])
    colour2 = text_color(YEA::SYSTEM::CUSTOM_VARIABLES[ext][3])
    minimum = YEA::SYSTEM::CUSTOM_VARIABLES[ext][4]
    maximum = YEA::SYSTEM::CUSTOM_VARIABLES[ext][5]
    rate = (value - minimum).to_f / [(maximum - minimum).to_f, 0.01].max
    dx = contents.width/2
    draw_gauge(dx, rect.y, contents.width - dx - 48, rate, colour1, colour2)
    contents.font.bold = true
    draw_text(dx, rect.y, contents.width - dx - 48, line_height, value, 2)
  end
  
  def cursor_right(wrap = false)
    cursor_change(:right)
    super(wrap)
  end
  
  def cursor_left(wrap = false)
    cursor_change(:left)
    super(wrap)
  end
  
  def cursor_change(direction)
    case current_symbol
    when :volume_bgm, :volume_bgs, :volume_sfx
      change_volume(direction)
    when :autodash, :instantmsg
      change_toggle(direction)
    when :custom_switch
      change_custom_switch(direction)
    when :custom_variable
      change_custom_variables(direction)
    end
  end
  
  def change_volume(direction)
    Sound.play_cursor
    value = direction == :left ? -1 : 1
    value *= 10 if Input.press?(:A)
    case current_symbol
    when :volume_bgm
      $game_system.volume_change(:bgm, value)
    when :volume_bgs
      $game_system.volume_change(:bgs, value)
    when :volume_sfx
      $game_system.volume_change(:sfx, value)
    end
    draw_item(index)
  end
  
  def change_toggle(direction)
    value = direction == :left ? false : true
    case current_symbol
    when :autodash
      current_case = $game_system.autodash?
      $game_system.set_autodash(value)
    when :instantmsg
      current_case = $game_system.instantmsg?
      $game_system.set_instantmsg(value)
    end
    Sound.play_cursor if value != current_case
    draw_item(index)
  end
  
  def change_custom_switch(direction)
    value = direction == :left ? false : true
    ext = current_ext
    current_case = $game_switches[YEA::SYSTEM::CUSTOM_SWITCHES[ext][0]]
    $game_switches[YEA::SYSTEM::CUSTOM_SWITCHES[ext][0]] = value
    Sound.play_cursor if value != current_case
    draw_item(index)
  end
  
  def change_custom_variables(direction)
    Sound.play_cursor
    value = direction == :left ? -1 : 1
    value *= 10 if Input.press?(:A)
    ext = current_ext
    var = YEA::SYSTEM::CUSTOM_VARIABLES[ext][0]
    minimum = YEA::SYSTEM::CUSTOM_VARIABLES[ext][4]
    maximum = YEA::SYSTEM::CUSTOM_VARIABLES[ext][5]
    $game_variables[var] += value
    $game_variables[var] = [[$game_variables[var], minimum].max, maximum].min
    draw_item(index)
  end
end