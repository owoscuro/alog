# encoding: utf-8
# Name: 297.Russian Poker
# Size: 52767
#******************************************************************************
#
#    * Poker
#
#  --------------------------------------------------------------------------
#    Версия : 1.0.0
#    Платформа:  RPG Maker VX Ace : RGSS3
#    Автор : CACAO English Translation: Carrigon
#    Перевод на русский: SunCrash
#    Сайт автора : http://cacaosoft.web.fc2.com/
#    Переведено специально для: http://rpgvxa.3nx.ru/
#  --------------------------------------------------------------------------
#   == РЕЗЮМЕ ==
#
#    : Добавляет возможность поиграть в покер
#
#  --------------------------------------------------------------------------
#   == Меры предосторожности ==
#
#    ? Игра требует наличие изображения PokerTrump.png в Graphics\System
#
#  --------------------------------------------------------------------------
#   == Использование ==
#
#    ? Начать играть
#     Добавить на карту событие, в котором прописать скрипт: start_poker
#
#
#******************************************************************************


#==============================================================================
# Настройки
#==============================================================================
module CAO
module Poker
  #--------------------------------------------------------------------------
  # 코인의 개수가 저장되는 변수
  #--------------------------------------------------------------------------
  IDV_COIN = 7
  #--------------------------------------------------------------------------
  # 기본 요금
  #--------------------------------------------------------------------------
  DEFAULT_COIN = 100
  #--------------------------------------------------------------------------
  # 베팅이 증가하거나 감소하는 값
  #--------------------------------------------------------------------------
  BET_RATE = 100
  #--------------------------------------------------------------------------
  # 최대 베팅
  #--------------------------------------------------------------------------
  MAX_BET = 1000000
  #--------------------------------------------------------------------------
  # VOCAB_HANDS의 승수
  #--------------------------------------------------------------------------
  DIVIDEND_COVER = [0, 1, 2, 3, 5, 7, 10, 50, 100, 500]
  #--------------------------------------------------------------------------
  # Преобразовывать 000 в К? (15000 --> 15K)
  #--------------------------------------------------------------------------
  ADDR_DIVIDEND = true
  #--------------------------------------------------------------------------
  # Названия комбинаций карт
  #--------------------------------------------------------------------------
  VOCAB_HANDS = [ "Carta alta", "Un par", "Dos pares", "Trío",
                  "Escalera", "Color", "Full house", "Póker",
                  "Escalera de color", "Escalera real" ]
  VOCAB_COIN = ""
  VOCAB_COIN_U = ""
  VOCAB_BET  = "Seleccione la cantidad de la apuesta."
  VOCAB_WIN  = "Has ganado."
  VOCAB_LOSE = "Has perdido."
  VOCAB_HELP = "Presiona el botón SHIFT para ver la explicación del juego."

  #--------------------------------------------------------------------------
  # 게임 설명
  #--------------------------------------------------------------------------
  MANUAL_LINE = 17

  # <<-'[EOS]' 그 사이의 모든 것은 설명 [EOS]에 있습니다.
  TEXT_MANUAL = <<-'[EOS]'
  \C[8]＜Apuesta de Dinero＞\C[0]
   ・\C[2] Usa las teclas de flecha arriba y abajo para ajustar de 1 en 1 oro.\C[0]
   ・\C[2] Usa las teclas de flecha izquierda y derecha para ajustar de 10 en 10 plata.\C[0]
  \C[8]＜Controles del Juego＞\C[0]
   ・\C[2] Presiona la tecla Z para cambiar cartas.\C[0]
   ・\C[2] Presiona la tecla X para continuar.\C[0]
  \C[8]＜Explicación de Términos＞\C[0]
   ・\C[2] Carta alta: Sin pares, multiplicador 0\C[0]
   ・\C[2] Un par: 2 cartas del mismo número, multiplicador 1\C[0]
   ・\C[2] Dos pares: 2 pares, multiplicador 2\C[0]
   ・\C[2] Trío: 3 cartas del mismo número, multiplicador 3\C[0]
   ・\C[2] Escalera: 5 cartas en secuencia, multiplicador 5\C[0]
   ・\C[2] Color: 5 cartas del mismo palo, multiplicador 7\C[0]
   ・\C[2] Full house: 3 cartas del mismo número, 2 cartas del mismo número, multiplicador 10\C[0]
   ・\C[2] Póker: 4 cartas del mismo número, multiplicador 50\C[0]
   ・\C[2] Escalera de color: 5 cartas en secuencia y del mismo palo, multiplicador 100\C[0]
   ・\C[2] Escalera real: 10, J, Q, K, A del mismo palo, multiplicador 500\C[0]
    [EOS]

  #--------------------------------------------------------------------------
  # 음향 효과
  #--------------------------------------------------------------------------
  SOUND_START   = "Flash2"      # При раскладке карт
  SOUND_WIN     = "Applause1"   # При выйгрыше
  SOUND_LOSE    = "Scream"      # При проигрыше
  SOUND_BET     = "Shop"        # При подтверждении ставки
  SOUND_COIN    = "Coin"        # При выборе ставки
  SOUND_DEAL    = "Book2"       # При запуске
  SOUND_SLOUGH  = "Book2"       # При переходе от окончания игры на выбор ставки
  SOUND_REVERSE = "Book1"       # При повороте карт
  SOUND_CHANGE  = "Book2"       # При смене карт 
end
end

#/////////////////////////////////////////////////////////////////////////////#
#                                                                             #
#                Вам не нужно менять скрипт ниже.                             #
#                                                                             #
#/////////////////////////////////////////////////////////////////////////////#

class << CAO::Poker
  #--------------------------------------------------------------------------
  # ???????????
  #--------------------------------------------------------------------------
  def coin
    return $game_party.gold
  end
  #--------------------------------------------------------------------------
  #
  #--------------------------------------------------------------------------
  def gain_coin(amount)
    $game_party::gain_gold(amount)
    $game_party.gold = 0 if self.coin < 0
  end
end

module Sound
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def self.define_poker_sound(method_name, file_name)
    if file_name.empty?
      instance_eval %Q{
        def #{method_name}
        end
      }
    else
      instance_eval %Q{
        @#{method_name} = RPG::SE.new(file_name, 80)
        def #{method_name}
          @#{method_name}.play
        end
      }
    end
  end
  #--------------------------------------------------------------------------
  # ????????
  #--------------------------------------------------------------------------
  define_poker_sound :play_poker_start,   CAO::Poker::SOUND_START
  define_poker_sound :play_poker_win,     CAO::Poker::SOUND_WIN
  define_poker_sound :play_poker_lose,    CAO::Poker::SOUND_LOSE
  define_poker_sound :play_poker_bet,     CAO::Poker::SOUND_BET
  define_poker_sound :play_poker_coin,    CAO::Poker::SOUND_COIN
  define_poker_sound :play_poker_deal,    CAO::Poker::SOUND_DEAL
  define_poker_sound :play_poker_slough,  CAO::Poker::SOUND_SLOUGH
  define_poker_sound :play_poker_reverse, CAO::Poker::SOUND_REVERSE
  define_poker_sound :play_poker_change,  CAO::Poker::SOUND_CHANGE
end

class CAO::Poker::Trump
  #--------------------------------------------------------------------------
  # ????????
  #--------------------------------------------------------------------------
  SUIT_SPADES   = 0
  SUIT_HEARTS   = 1
  SUIT_DIAMONDS = 2
  SUIT_CLUBS    = 3
  #--------------------------------------------------------------------------
  # ??????????
  #--------------------------------------------------------------------------
  attr_reader   :suit                     # ??? (0..3)
  attr_reader   :number                   # ??   (1..13)
  #--------------------------------------------------------------------------
  # ??????????
  #--------------------------------------------------------------------------
  def initialize(suit, number)
    @suit = suit
    @number = number
  end
  #--------------------------------------------------------------------------
  # ?????ID
  #--------------------------------------------------------------------------
  def id
    return 100 * @suit + @number
  end
  #--------------------------------------------------------------------------
  # ?????
  #--------------------------------------------------------------------------
  def inspect
    return sprintf('%s%02d', '????'[@suit], @number)  # ????
  end
end

class CAO::Poker::Hand
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  @@deck = Array.new(13*4) {|i| CAO::Poker::Trump.new(i/13, i%13+1) }.freeze
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  attr_reader :hand
  attr_reader :stock
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def initialize
    @stock = @@deck.shuffle
    @hand = @stock.pop(5)
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def change(index)
    @hand[index] = @stock.pop
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def [](index)
    return @hand[index]
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def each
    @hand.each {|card| yield card }
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def sort!
    @hand.sort! {|a,b| a.number <=> b.number }
  end
  #--------------------------------------------------------------------------
  # ????
  #--------------------------------------------------------------------------
  def final
    sort!       # ?????????????????
    royal    = _royal?
    straight = _straight?
    flush    = _flush?
    pairs    = _pairs
    pair_max = pairs.max
    pair_min = pairs.min
    pair_cnt = pairs.count(pair_max)
    
    return 9 if royal && flush                    # ?????????
    return 8 if straight && flush                 # ??????????
    return 7 if pair_max == 4                     # ??????
    return 6 if pair_max == 3 && pair_min == 2    # ?????
    return 5 if flush                             # ?????
    return 4 if straight                          # ?????
    return 3 if pair_max == 3 && pair_min == 1    # ??????
    return 2 if pair_max == 2 && pair_cnt == 4    # ????
    return 1 if pair_max == 2                     # ????
    return 0                                      # ?????
  end
  #--------------------------------------------------------------------------
  # ????????????
  #--------------------------------------------------------------------------
  def _royal?
    return @hand.map {|card| card.number } == [1, 10, 11, 12, 13]
  end
  #--------------------------------------------------------------------------
  # ????????
  #--------------------------------------------------------------------------
  def _straight?
    return true if _royal?
    @hand.each_with_index do |card,i|
      return false if card.number - @hand[0].number != i
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ????????
  #--------------------------------------------------------------------------
  def _flush?
    return @hand.all? {|card| card.suit == @hand[0].suit }
  end
  #--------------------------------------------------------------------------
  # ????????? (????)
  #--------------------------------------------------------------------------
  def _pairs
    return @hand.map {|c1| @hand.count{|c2| c1.number == c2.number } }
  end
  protected :_royal?, :_straight?, :_flush?, :_pairs
end

class Game_Interpreter
  #--------------------------------------------------------------------------
  # ??????
  #--------------------------------------------------------------------------
  def start_poker
    SceneManager.call(Scene_Poker)
    Fiber.yield
  end
end

class Window_PokerHands < Window_Base
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  attr_reader :index
  #--------------------------------------------------------------------------
  # ?????????
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, Graphics.width, fitting_height(5))
    clear
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def clear
    @index = -1
    @coin = 0
    refresh
  end
  #--------------------------------------------------------------------------
  # ??????
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    draw_all_items
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def draw_all_items
    10.times {|i| draw_item(i) }
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def draw_item(index)
    change_color(@index == index ? text_color(18) : normal_color)
    rect = Rect.new(0, 0, self.item_width, self.line_height)
    rect.x = (index / 5) * (rect.width + self.space)
    rect.y = (index % 5) * rect.height
    draw_text(rect, CAO::Poker::VOCAB_HANDS[index])
    # 금액 표시 수정 실험
    draw_currency_value(prize_s(index).to_i, "", rect.x, rect.y, rect.width - 10, 4)
    #draw_text(rect, prize_s(index), 2)
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def item_width
    return (contents_width - self.space) / 2
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def space
    return 16
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def prize(index = nil)
    return Integer(@coin * CAO::Poker::DIVIDEND_COVER[index || @index])
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def prize_s(index)
    if @coin == 0
      return "x#{CAO::Poker::DIVIDEND_COVER[index]}"
    else
      # 금액 표시 수정 실험
      #draw_currency_value(value.to_i, "", x, y, width - cx - 2)
      value = String(prize(index))
      #value.sub!(/000$/, 'K') if CAO::Poker::ADDR_DIVIDEND && value.size > 4
      return value
    end
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def coin=(value)
    @coin = value
    refresh
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def index=(index)
    @index = index
    refresh
  end
end

class Window_Base
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def draw_poker_coin(x, y, width, value, text = "", enabled = true)
    change_color(system_color)
    draw_text(x, y, width, line_height, text) unless text.empty?
    draw_text(x, y, width, line_height, CAO::Poker::VOCAB_COIN_U, 2)
    change_color(normal_color, enabled)
    cx = text_size(CAO::Poker::VOCAB_COIN_U).width
    # 금액 표시 수정 실험
    draw_currency_value(value.to_i, "", x, y, width - 2, 1)
    #draw_text(x, y, width - cx - 2, line_height, value, 2)
  end
  def draw_poker_bat(x, y, width, value, text = "", enabled = true)
    change_color(system_color)
    draw_text(x, y, width, line_height, text) unless text.empty?
    draw_text(x, y, width, line_height, CAO::Poker::VOCAB_COIN_U, 2)
    change_color(normal_color, enabled)
    cx = text_size(CAO::Poker::VOCAB_COIN_U).width
    # 금액 표시 수정 실험
    draw_currency_value(value.to_i, "", x, y, width - 2, 5)
    #draw_text(x, y, width - cx - 2, line_height, value, 2)
  end
  def draw_poker_gc(x, y, width, value, text = "", enabled = true)
    change_color(system_color)
    draw_text(x, y, width, line_height, text) unless text.empty?
    draw_text(x, y, width, line_height, CAO::Poker::VOCAB_COIN_U, 2)
    change_color(normal_color, enabled)
    cx = text_size(CAO::Poker::VOCAB_COIN_U).width
    # 금액 표시 수정 실험
    draw_currency_value(value.to_i, "", x, y, width - 2, 3)
    #draw_text(x, y, width - cx - 2, line_height, value, 2)
  end
  def draw_poker_fr(x, y, width, value, text = "", enabled = true)
    change_color(system_color)
    draw_text(x, y, width, line_height, text) unless text.empty?
    draw_text(x, y, width, line_height, CAO::Poker::VOCAB_COIN_U, 2)
    change_color(normal_color, enabled)
    cx = text_size(CAO::Poker::VOCAB_COIN_U).width
    # 금액 표시 수정 실험
    draw_currency_value(value.to_i, "", x, y, width - 2, 6)
  end
end

class Window_PokerBet < Window_Base
  #--------------------------------------------------------------------------
  # ??????????
  #--------------------------------------------------------------------------
  attr_reader   :number                   # ??????
  #--------------------------------------------------------------------------
  # ?????????
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, 272, fitting_height(2))
    self.viewport = viewport
    @digits_max = CAO::Poker::MAX_BET % 10 + 1
    self.openness = 0
    deactivate
    reset
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def reset
    @count = 0
    @number = CAO::Poker::DEFAULT_COIN
    refresh
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def enable?
    @number <= CAO::Poker.coin
  end
  #--------------------------------------------------------------------------
  # ??????
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    change_color(normal_color)
    draw_text(0, 0, contents_width, line_height, CAO::Poker::VOCAB_BET, 1)
    draw_poker_bat(0, line_height, contents_width,
      sprintf("%0*d", @digits_max, @number), "", self.enable?)
    #draw_poker_coin(0, line_height, contents_width,
    #  sprintf("%0*d", @digits_max, @number), "", self.enable?)
  end
  #--------------------------------------------------------------------------
  # ??????
  #--------------------------------------------------------------------------
  def update
    super
    process_digit_change
    process_handling
  end
  #--------------------------------------------------------------------------
  # ???????
  #--------------------------------------------------------------------------
  def process_digit_change
    return unless open? && active
    if Input.repeat?(:UP) || Input.repeat?(:DOWN) || Input.repeat?(:RIGHT) || Input.repeat?(:LEFT)
      last_number = @number
      if @count < 3
        @count += 1
        @number += CAO::Poker::BET_RATE if Input.repeat?(:RIGHT)
        @number -= CAO::Poker::BET_RATE if Input.repeat?(:LEFT)
        @number += CAO::Poker::BET_RATE * 100 if Input.repeat?(:UP)
        @number -= CAO::Poker::BET_RATE * 100 if Input.repeat?(:DOWN)
      else
        @number += CAO::Poker::BET_RATE if Input.repeat?(:RIGHT)
        @number -= CAO::Poker::BET_RATE if Input.repeat?(:LEFT)
        @number += CAO::Poker::BET_RATE * 100 if Input.repeat?(:UP)
        @number -= CAO::Poker::BET_RATE * 100 if Input.repeat?(:DOWN)
      end
      @number = CAO::Poker::BET_RATE if @number < CAO::Poker::BET_RATE
      @number = CAO::Poker::MAX_BET if CAO::Poker::MAX_BET < @number
      if @number != last_number
        Sound.play_poker_coin
        refresh
      end
    else
      @count = 0
    end
  end
  #--------------------------------------------------------------------------
  # ?????????????????
  #--------------------------------------------------------------------------
  def process_handling
    return unless open? && active
    return process_ok     if Input.trigger?(:C)
    return process_cancel if Input.trigger?(:B)
  end
  #--------------------------------------------------------------------------
  # ???????????????
  #--------------------------------------------------------------------------
  def process_ok
    if self.enable?
      Sound.play_poker_bet
      deactivate
      close
      @ok_handler.call
    else
      Sound.play_buzzer
    end
  end
  #--------------------------------------------------------------------------
  # ??????????????????
  #--------------------------------------------------------------------------
  def process_cancel
    Sound.play_cancel
    @cancel_handler.call
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def set_ok_handler(method)
    @ok_handler = method
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def set_cancel_handler(method)
    @cancel_handler = method
  end
end

class Window_PokerMessage < Window_Base
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, 272, fitting_height(1))
    self.openness = 0
    deactivate
  end
  #--------------------------------------------------------------------------
  def alignment
		return 1
	end
  #--------------------------------------------------------------------------
  def update
    super
    process_handling
  end
  #--------------------------------------------------------------------------
  def process_handling
    return unless active
    return process_ok     if Input.trigger?(:C)
    return process_cancel if Input.trigger?(:B)
  end
  #--------------------------------------------------------------------------
  def process_ok
    Sound.play_poker_slough
    deactivate
    close
    @handler.call
    Input.update
  end
  #--------------------------------------------------------------------------
  def process_cancel
    process_ok
  end
  #--------------------------------------------------------------------------
  def set_ok_handler(method)
    @handler = method
  end
  #--------------------------------------------------------------------------
  def set_cancel_handler(method)
    @handler = method
  end
  #--------------------------------------------------------------------------
  def set_text(text)
    if text != @text
      @text = text
      refresh
    end
  end
  #--------------------------------------------------------------------------
  def clear
    set_text("")
  end
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    # 메시지 중앙 수정
    draw_text(0, 0, contents.width, line_height, @text, 1)
    #draw_text_ex(4, 0, @text)
  end
end

class Window_PokerCoin < Window_Base
  #--------------------------------------------------------------------------
  WIDTH = Graphics.width / 8 * 3
  #--------------------------------------------------------------------------
  def initialize()
    super(0, 0, WIDTH, fitting_height(1))
    refresh
  end
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    draw_poker_coin(0,0,contents_width,CAO::Poker.coin,CAO::Poker::VOCAB_COIN)
  end
end

class Window_PokerHelp < Window_Base
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, Graphics.width - Window_PokerCoin::WIDTH, fitting_height(1))
    refresh
  end
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    draw_text(0, 0, contents_width, contents_height, CAO::Poker::VOCAB_HELP)
  end
end

class Window_PokerManual < Window_Base
  #--------------------------------------------------------------------------
  def initialize
    bitmap = Bitmap.new(Graphics.width, Graphics.height)
    bitmap.fill_rect(bitmap.rect, Color.new(0, 0, 0, 160))
    @background = Sprite.new
    @background.bitmap = bitmap
    @background.visible = false
    super(0, 0, 524, fitting_height(CAO::Poker::MANUAL_LINE))
    self.openness = 0
    @background.z = self.z
    deactivate
    refresh
  end
  #--------------------------------------------------------------------------
  def dispose
    @background.bitmap.dispose
    @background.dispose
    super
  end
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    draw_text_ex(0, 0, CAO::Poker::TEXT_MANUAL)
  end
  #--------------------------------------------------------------------------
  def update
    super
    @background.visible = !close?
    if open? && (Input.trigger?(:A) || Input.trigger?(:B))
      Sound.play_cancel
      @close_handler.call
    elsif close? && Input.trigger?(:A)
      Sound.play_ok
      @open_handler.call
    end
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def open_handler=(method)
    @open_handler = method
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def close_handler=(method)
    @close_handler = method
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def viewport=(value)
    @background.viewport = value
    super
  end
end

class Sprite_PokerTrump < Sprite
  #--------------------------------------------------------------------------
  # ??
  #--------------------------------------------------------------------------
  CARD_WIDTH  = Cache.system("PokerTrump").width  / 14
  CARD_HEIGHT = Cache.system("PokerTrump").height / 4
  #--------------------------------------------------------------------------
  # ??????
  #--------------------------------------------------------------------------
  BMP_BACK_FACE.dispose if defined? BMP_BACK_FACE
  BMP_BACK_FACE = Bitmap.new(CARD_WIDTH, CARD_HEIGHT)
  BMP_BACK_FACE.blt(0, 0, Cache.system("PokerTrump"),
    Rect.new(CARD_WIDTH * 13, CARD_HEIGHT * 0, CARD_WIDTH, CARD_HEIGHT))
  #--------------------------------------------------------------------------
  # ??????????
  #--------------------------------------------------------------------------
  attr_reader :wait_count
  #--------------------------------------------------------------------------
  # ?????????
  #--------------------------------------------------------------------------
  def initialize(x, y, viewport)
    @pos_x = x
    @pos_y = y
    super(viewport)
    self.bitmap = BMP_BACK_FACE
    self.x = x
    self.y = y
    self.opacity = 0
    centering_origin
    init_instance_variables
    hide
  end
  #--------------------------------------------------------------------------
  # ????????
  #--------------------------------------------------------------------------
  def dispose
    @trump_bitmap.dispose if @trump_bitmap
    super
  end
  #--------------------------------------------------------------------------
  # ????????????
  #--------------------------------------------------------------------------
  def init_instance_variables
    @trump = nil
    @opening = @closing = false
    @openness = 100
    @wait_count = 0
    @target_bitmap = nil
    @target_x = self.x
    @target_y = self.y
    @target_opacity = self.opacity
    @speed_x = 0.0
    @speed_y = 0.0
    @speed_opacity = 0.0
  end
  #--------------------------------------------------------------------------
  # ???????????
  #--------------------------------------------------------------------------
  def centering_origin
    self.ox = CARD_WIDTH / 2
    self.oy = CARD_HEIGHT / 2
  end
  #--------------------------------------------------------------------------
  # ??????
  #--------------------------------------------------------------------------
  def update
    super
    if @wait_count > 0
      @wait_count -= 1
    else
      # update_deal_sound
      update_reverse
      update_position
    end
  end
  #--------------------------------------------------------------------------
  # ?????????????? (???)
  #--------------------------------------------------------------------------
  def update_deal_sound
    if @start_deal
      Sound.play_poker_deal
      @start_deal = false
    end
  end
  #--------------------------------------------------------------------------
  # ?????????
  #--------------------------------------------------------------------------
  def update_reverse
    return if self.x != @target_x
    return if self.y != @target_y
    return if self.opacity != @target_opacity
    if @closing
      @openness -= 20
      if @openness <= 0
        self.bitmap = @target_bitmap
        @openness = 0
        @closing = false
      end
      self.zoom_x = @openness / 100.0
    elsif @openning
      @openness += 20
      if @openness >= 100
        @openness = 100
        @openning = false
      end
      self.zoom_x = @openness / 100.0
    end
  end
  #--------------------------------------------------------------------------
  # ?????????
  #--------------------------------------------------------------------------
  def update_position
    return if @openness != 0 && @openness != 100
    if self.x != @target_x
      @x += @speed_x
      self.x = @x
      if @speed_x < 0
        self.x = @target_x if self.x < @target_x
      else
        self.x = @target_x if self.x > @target_x
      end
    end
    if self.y != @target_y
      @y += @speed_y
      self.y = @y
      if @speed_y < 0
        self.y = @target_y if self.y < @target_y
      else
        self.y = @target_y if self.y > @target_y
      end
    end
    if self.opacity != @target_opacity
      @opacity += @speed_opacity
      self.opacity = @opacity
    end
  end
  #--------------------------------------------------------------------------
  # ??????????
  #--------------------------------------------------------------------------
  def open(wait = -1)
    self.wait = wait unless wait < 0
    @target_bitmap = @trump_bitmap
    reverse_motion
  end
  #--------------------------------------------------------------------------
  # ??????????
  #--------------------------------------------------------------------------
  def close
    @target_bitmap = BMP_BACK_FACE
    reverse_motion
  end
  #--------------------------------------------------------------------------
  # ????????
  #--------------------------------------------------------------------------
  def reverse
    front? ? close : open
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def reverse_motion
    @openness = 100
    @closing = true
    @openning = true
  end
  #--------------------------------------------------------------------------
  # ????????
  #--------------------------------------------------------------------------
  def deal
    @start_deal = true    # ??? (update_deal_sound)
    self.bitmap = BMP_BACK_FACE
    self.x = @pos_x - 4
    self.y = @pos_y - 4
    @target_x = @pos_x
    @target_y = @pos_y
    @target_opacity = 255
    calc_speed(10)
  end
  #--------------------------------------------------------------------------
  # ????????
  #--------------------------------------------------------------------------
  def slough
    @target_x = self.x
    @target_y = self.y - 20
    @target_opacity = 0
    calc_speed(10)
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def calc_speed(frame)
    @x = self.x
    @y = self.y
    @opacity = self.opacity
    @speed_x = (@target_x - self.x) / frame.to_f
    @speed_y = (@target_y - self.y) / frame.to_f
    @speed_opacity = (@target_opacity - self.opacity) / frame.to_f
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def show
    self.opacity = 255
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def hide
    self.opacity = 0
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def in_motion?
    return true if reversing?
    return true if moving?
    return false
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def reversing?
    return @closing || @openning
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def moving?
    return true if self.x != @target_x
    return true if self.y != @target_y
    return true if self.opacity != @target_opacity
    return false
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def wait?
    return @wait_count != 0
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def front?
    return self.bitmap != BMP_BACK_FACE
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def trump=(trump)
    return if @trump == trump
    @trump = trump
    @trump_bitmap.dispose if @trump_bitmap
    @trump_bitmap = Bitmap.new(CARD_WIDTH, CARD_HEIGHT)
    bitmap = Cache.system("PokerTrump")
    rect = Rect.new(0, 0, CARD_WIDTH, CARD_HEIGHT)
    rect.x = CARD_WIDTH * (trump.number - 1)
    rect.y = CARD_HEIGHT * trump.suit
    @trump_bitmap.blt(0, 0, bitmap, rect)
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def wait=(value)
    @wait_count = value
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def select
    self.oy = CARD_HEIGHT / 2 + 8
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def unselect
    self.oy = CARD_HEIGHT / 2
  end
  #--------------------------------------------------------------------------
  # ??????????????????????
  #--------------------------------------------------------------------------
  protected :ox=, :oy=, :zoom_x=, :zoom_y=
end

class Spriteset_PokerTrump
  #--------------------------------------------------------------------------
  # ??
  #--------------------------------------------------------------------------
  CARD_MAX = 5
  WAIT_TIME = 8
  #--------------------------------------------------------------------------
  # ??????????
  #--------------------------------------------------------------------------
  attr_reader   :index                    # ??????
  attr_reader   :active                   # 
  #--------------------------------------------------------------------------
  # ?????????
  #--------------------------------------------------------------------------
  def initialize(viewport)
    @wait_count = -1
    @viewport = viewport
    @viewport.z = 50
    cw = @viewport.rect.width / CARD_MAX
    sx = @viewport.rect.width / 2 - cw * 2
    sy = @viewport.rect.height / 2
    @card_sprites = Array.new(CARD_MAX) do |i|
      Sprite_PokerTrump.new(sx + cw * i, sy, @viewport)
    end
    clear_handler
    unselect
    deactivate
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def dispose
    @viewport.dispose
    @card_sprites.each {|sp| sp.dispose }
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def update
    @viewport.update
    @card_sprites.each {|sp| sp.update }
    update_timer
    update_cursor
    if self.active
      process_ok                           if Input.trigger?(:C)
      process_cancel                       if Input.trigger?(:B)
      cursor_right(Input.trigger?(:RIGHT)) if Input.repeat?(:RIGHT)
      cursor_left (Input.trigger?(:LEFT))  if Input.repeat?(:LEFT)
    end
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def deal(hand)
    Sound.play_poker_deal
    CARD_MAX.times do |i|
      @card_sprites[i].trump = hand[i]
      @card_sprites[i].wait = WAIT_TIME * i
      @card_sprites[i].deal
    end
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def slough
    @card_sprites.each {|sp| sp.slough }
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def open(hand = nil)
    if hand
      CARD_MAX.times {|i| @card_sprites[i].trump = hand[i] }
      list = @card_sprites.select {|sp| !sp.front? }
    else
      list = @card_sprites
    end
    list.each_with_index {|sp,i| sp.open(WAIT_TIME * i) }
    return self
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def reversed_indexes
    result = []
    @card_sprites.each_with_index do |sp,i|
      result << i unless sp.front?
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ????????????
  #--------------------------------------------------------------------------
  def activate
    @active = true
    self
  end
  #--------------------------------------------------------------------------
  # ?????????????
  #--------------------------------------------------------------------------
  def deactivate
    @active = false
    self
  end
  #--------------------------------------------------------------------------
  # ?????
  #--------------------------------------------------------------------------
  def select(index)
    @index = index
    update_cursor
  end
  #--------------------------------------------------------------------------
  # ???????
  #--------------------------------------------------------------------------
  def unselect
    @index = -1
    update_cursor
  end
  #--------------------------------------------------------------------------
  # ???????????
  #--------------------------------------------------------------------------
  def clear_handler
    @handler = {}
  end
  #--------------------------------------------------------------------------
  # ??????????????
  #     method : ??????????????? (Method ??????)
  #--------------------------------------------------------------------------
  def set_handler(symbol, method)
    @handler[symbol] = method
  end
  #--------------------------------------------------------------------------
  # ?????????
  #--------------------------------------------------------------------------
  def handle?(symbol)
    @handler.include?(symbol)
  end
  #--------------------------------------------------------------------------
  # ?????????
  #--------------------------------------------------------------------------
  def call_handler(symbol)
    @handler[symbol].call if handle?(symbol)
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def update_cursor
    @card_sprites.each {|sp| sp.unselect }
    @card_sprites[@index].select unless @index < 0
  end
  #--------------------------------------------------------------------------
  # ???????????
  #--------------------------------------------------------------------------
  def cursor_movable?
    return self.active
  end
  #--------------------------------------------------------------------------
  # ?????????
  #--------------------------------------------------------------------------
  def cursor_right(wrap = false)
    if index < CARD_MAX - 1 || wrap
      Sound.play_cursor
      select((index + 1) % CARD_MAX)
    end
  end
  #--------------------------------------------------------------------------
  # ?????????
  #--------------------------------------------------------------------------
  def cursor_left(wrap = false)
    if index > 0 || wrap
      Sound.play_cursor
      select((index - 1 + CARD_MAX) % CARD_MAX)
    end
  end
  #--------------------------------------------------------------------------
  # ???????????
  #--------------------------------------------------------------------------
  def current_card
    return @index < 0 ? nil : @card_sprites[@index]
  end
  #--------------------------------------------------------------------------
  # ???????????????
  #--------------------------------------------------------------------------
  def process_ok
    Sound.play_poker_reverse
    Input.update
    unless @index < 0
      @card_sprites[@index].reverse
    end
  end
  #--------------------------------------------------------------------------
  # ??????????????????
  #--------------------------------------------------------------------------
  def process_cancel
    Sound.play_poker_change
    Input.update
    deactivate
    call_handler(:cancel)
  end
  #--------------------------------------------------------------------------
  # ????????????????????
  #--------------------------------------------------------------------------
  def wait_count
    return @card_sprites.max_by {|sp| sp.wait_count }.wait_count
  end
  #--------------------------------------------------------------------------
  # ??????????
  #--------------------------------------------------------------------------
  def viewport
    return @viewport.rect
  end
  #--------------------------------------------------------------------------
  # ?????
  #--------------------------------------------------------------------------
  def update_timer
    return if @wait_count < 0
    return if @card_sprites.any? {|card| card.in_motion? }
    @wait_count -= 1
    @deferred.call if @wait_count < 0 && @deferred
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def wait(duration, method = nil)
    @wait_count = duration
    @deferred = method
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def waiting?
    return @wait_count >= 0
  end
end

class Scene_Poker < Scene_MenuBase
  #--------------------------------------------------------------------------
  # ????
  #--------------------------------------------------------------------------
  def start
    super
    create_hands_window
    create_help_window
    create_gold_window
    create_card_sprite
    create_info_windows
    start_game
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def create_hands_window
    @hands_window = Window_PokerHands.new
    @hands_window.x = (Graphics.width - @hands_window.width) / 2
    # 배수 설명 메세지 창 위치 조절
    @hands_window.y = 0 #32
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def create_help_window
    @help_window = Window_PokerHelp.new
    @help_window.y = Graphics.height - @help_window.height
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def create_gold_window
    @coin_window = Window_PokerCoin.new
    @coin_window.x = Graphics.width - @coin_window.width
    @coin_window.y = Graphics.height - @coin_window.height
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def create_card_sprite
    viewport = Viewport.new
    viewport.rect.y = @hands_window.y + @hands_window.height
    viewport.rect.height -= viewport.rect.y + @help_window.height
    @spriteset = Spriteset_PokerTrump.new(viewport)
    @spriteset.set_handler(:cancel, method(:change_card))
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def create_info_windows
    @info_viewport = Viewport.new
    @info_viewport.z = 100
    create_bet_window
    create_message_window
    create_manual_window
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def create_bet_window
    @bet_window = Window_PokerBet.new
    @bet_window.viewport = @info_viewport
    @bet_window.x = (@info_viewport.rect.width - @bet_window.width) / 2
    @bet_window.y = (@info_viewport.rect.height - @bet_window.height) / 2
    @bet_window.y = @spriteset.viewport.y + 16
    @bet_window.set_ok_handler(method(:on_bet_ok))
    @bet_window.set_cancel_handler(method(:return_scene))
  end
  #--------------------------------------------------------------------------
  def create_message_window
    @message_window = Window_PokerMessage.new
    @message_window.viewport = @info_viewport
    @message_window.x = (@info_viewport.rect.width - @message_window.width) / 2
    @message_window.y = (@info_viewport.rect.height - @message_window.height) / 2
    @message_window.y = @spriteset.viewport.y + 16
  end
  #--------------------------------------------------------------------------
  def create_manual_window
    @manual_window = Window_PokerManual.new
    @manual_window.viewport = @info_viewport
    @manual_window.x = (@info_viewport.rect.width - @manual_window.width) / 2
    @manual_window.y = (@info_viewport.rect.height - @manual_window.height) / 2
    @manual_window.open_handler = proc do
      @manual_window.open
    end
    @manual_window.close_handler = proc do
      @manual_window.close
    end
  end
  #--------------------------------------------------------------------------
  def terminate
    super
    @info_viewport.dispose
    @spriteset.dispose
  end
  #--------------------------------------------------------------------------
  def update
    super
    @spriteset.update if @manual_window.close?
  end
  #--------------------------------------------------------------------------
  def update_all_windows
    if @manual_window.close?
      super
    else
      @manual_window.update
    end
  end
  #--------------------------------------------------------------------------
  def start_game
    @hands_window.clear
    @hand = CAO::Poker::Hand.new
    @spriteset.deal(@hand)
    @spriteset.wait(0, method(:start_bet))
  end
  #--------------------------------------------------------------------------
  def end_game
    @spriteset.slough
    @spriteset.wait(10, method(:start_game))
  end
  #--------------------------------------------------------------------------
  def start_bet
    @bet_window.refresh
    @bet_window.open.activate
  end
  #--------------------------------------------------------------------------
  def start_select
    Sound.play_poker_start
    @spriteset.select(0)
    @spriteset.activate
  end
  #--------------------------------------------------------------------------
  def show_mes_win
    Sound.play_poker_win
    CAO::Poker.gain_coin(@hands_window.prize)
    @coin_window.refresh
    
    #draw_text(0, 0, Graphics.width, 32, "CAO::Poker::VOCAB_WIN", 1)
    
    @message_window.set_text(CAO::Poker::VOCAB_WIN)
    # 포커 승리 횟수 저장
    $game_variables[201] += 1
    #@message_window.set_text(CAO::Poker::VOCAB_WIN % @hands_window.prize)
    @message_window.open.activate
  end
  #--------------------------------------------------------------------------
  def show_mes_lose
    Sound.play_poker_lose
    
    #draw_text(0, 0, Graphics.width, 32, "CAO::Poker::VOCAB_LOSE", 1)
    
    @message_window.set_text(CAO::Poker::VOCAB_LOSE)
    # 포커 패배 횟수 저장
    $game_variables[202] += 1
    #@message_window.set_text(CAO::Poker::VOCAB_LOSE % @hands_window.prize)
    @message_window.open.activate
  end
  #--------------------------------------------------------------------------
  def on_bet_ok
    CAO::Poker.gain_coin(-@bet_window.number)
    @coin_window.refresh
    @hands_window.coin = @bet_window.number
    @bet_window.close
    @spriteset.open
    @spriteset.wait(0, method(:start_select))
  end
  #--------------------------------------------------------------------------
  def on_mes_change_ok
    start_select
  end
  #--------------------------------------------------------------------------
  def on_mes_win_ok
    end_game
  end
  #--------------------------------------------------------------------------
  def on_mes_lose_ok
    end_game
  end
	#--------------------------------------------------------------------------
  def alignment
		return 1
	end
  #--------------------------------------------------------------------------
  def change_card
    @spriteset.unselect
    @spriteset.reversed_indexes.each {|index| @hand.change(index) }
    @spriteset.open(@hand)
    @hands_window.index = @hand.final
    if @bet_window.number <= @hands_window.prize
      @message_window.set_ok_handler(method(:on_mes_win_ok))
      @message_window.set_cancel_handler(method(:on_mes_win_ok))
      @spriteset.wait(0, method(:show_mes_win))
    else
      @message_window.set_ok_handler(method(:on_mes_lose_ok))
      @message_window.set_cancel_handler(method(:on_mes_lose_ok))
      @spriteset.wait(0, method(:show_mes_lose))
    end
  end
end