# encoding: utf-8
# Name: 299. Recruit Companions
# Size: 3173
class Scene_Gold_Control_2 < Scene_MenuBase
  def start
    super
    create_gold_control_window
  end
  def create_gold_control_window
    @gold_control_window = Window_Gold_Control_2.new
    @gold_control_window.viewport = Viewport.new
    @gold_control_window.z = 100
    @gold_control_window.x = (Graphics.width - @gold_control_window.width) / 2
    @gold_control_window.y = (Graphics.height - @gold_control_window.height) / 2
    @gold_control_window.set_ok_handler(method(:on_bet_ok))
    @gold_control_window.set_cancel_handler(method(:return_scene))
    @gold_control_window.open.activate
  end
  def on_bet_ok
    @gold_control_window.close
    return_scene
  end
end

class Window_Gold_Control_2 < Window_Base
  attr_reader   :number
  def initialize
    super(0, 0, 272, fitting_height(2))
    self.viewport = viewport
    @digits_max = CAO::Poker::MAX_BET % 10 + 1
    @number = $game_variables[239]
    self.openness = 0
    deactivate
    reset
  end
  def reset
    @number = $game_variables[239]
    $game_variables[27] = 1
    refresh
  end
  def refresh
    self.contents.clear
    change_color(normal_color)
    draw_text(0, 0, contents_width, line_height, "¿Cuántos días quieres contratar?", 1)
    draw_poker_fr(0, line_height, contents_width, sprintf("%0*d", @digits_max, @number), "", true)
  end
  def update
    super
    process_digit_change
    process_handling
  end
  def process_digit_change
    return unless open? && active
    if Input.repeat?(:UP) || Input.repeat?(:DOWN) || Input.repeat?(:RIGHT) || Input.repeat?(:LEFT)
      last_number = @number
      @number += $game_variables[239] if Input.repeat?(:RIGHT)
      @number -= $game_variables[239] if Input.repeat?(:LEFT)
      @number += $game_variables[239] * 10 if Input.repeat?(:UP)
      @number -= $game_variables[239] * 10 if Input.repeat?(:DOWN)
      @number = $game_variables[239] if @number < $game_variables[239]
      @number = $game_variables[239] * 30 if $game_variables[239] * 30 < @number
      $game_variables[272] = @number.to_i
      $game_variables[27] = @number / $game_variables[239]
      if @number != last_number
        Sound.play_poker_coin
        refresh
      end
    end
  end
  def process_handling
    return unless open? && active
    return process_ok     if Input.trigger?(:C)
    return process_cancel if Input.trigger?(:B)
  end
  #--------------------------------------------------------------------------
  def process_ok
    $game_variables[272] = @number.to_i
    $game_variables[27] = @number / $game_variables[239]
    
    Sound.play_poker_bet
    deactivate
    close
    @ok_handler.call
  end
  #--------------------------------------------------------------------------
  def process_cancel
    $game_variables[272] = @number.to_i
    $game_variables[27] = @number / $game_variables[239]
    
    Sound.play_cancel
    @cancel_handler.call
  end
  #--------------------------------------------------------------------------
  def set_ok_handler(method)
    @ok_handler = method
  end
  #--------------------------------------------------------------------------
  def set_cancel_handler(method)
    @cancel_handler = method
  end
end