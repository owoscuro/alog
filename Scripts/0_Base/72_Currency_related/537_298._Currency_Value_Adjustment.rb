# encoding: utf-8
# Name: 298. Currency Value Adjustment
# Size: 3033
class Scene_Gold_Control < Scene_MenuBase
  def start
    super
    create_gold_control_window
  end
  def create_gold_control_window
    @gold_control_window = Window_Gold_Control.new
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

class Window_Gold_Control < Window_Base
  attr_reader   :number
  def initialize
    super(0, 0, 272, fitting_height(2))
    self.viewport = viewport
    @digits_max = CAO::Poker::MAX_BET % 10 + 1
    self.openness = 0
    deactivate
    reset
  end
  def reset
    @number = CAO::Poker::DEFAULT_COIN
    refresh
  end
  def refresh
    self.contents.clear
    change_color(normal_color)
    draw_text(0, 0, contents_width, line_height, "기부할 금액을 선택하세요.", 1)
    draw_poker_gc(0, line_height, contents_width, sprintf("%0*d", @digits_max, @number), "", true)
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
      @number += CAO::Poker::BET_RATE if Input.repeat?(:RIGHT)
      @number -= CAO::Poker::BET_RATE if Input.repeat?(:LEFT)
      @number += CAO::Poker::BET_RATE * 100 if Input.repeat?(:UP)
      @number -= CAO::Poker::BET_RATE * 100 if Input.repeat?(:DOWN)
      @number = CAO::Poker::BET_RATE if @number < CAO::Poker::BET_RATE
      @number = CAO::Poker::MAX_BET if CAO::Poker::MAX_BET < @number
      $game_variables[272] = @number.to_i
      # 오류 메세지 표시 실험 -----------------------
      #$game_temp.pop_w(180, 'SYSTEM', 
      #"  %s  " % [$game_variables[272]])
      # -------------------------------------------
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
    Sound.play_poker_bet
    deactivate
    close
    @ok_handler.call
  end
  #--------------------------------------------------------------------------
  def process_cancel
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