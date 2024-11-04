# encoding: utf-8
# Name: 284. Apply Item Enchantments
# Size: 33844
# encoding: utf-8
# Name: 284.아이템 인챈트 적용
# Size: 33175
# <분해 [1,3]>
# 아이템을 분해하면 랜덤으로 1~3개의 1호 소품을 획득할 수 있습니다.
$m5script ||= {}; raise("Meow Meow 5 필요") unless $m5script[:M5Base]
$m5script[:M5DI20160122] = 20160122; M5script.version(20151221)
module M5DI20160122_2
#==============================================================================
# 설정 섹션
#==============================================================================

  ICONBRONZE = 3872
  ICONSILVER = 3873
  ICONGOLD = 3874
  
  GOLD = 500
  RATE = 0.1
  SE = 'Bell2'
  
  # VOCAB = {
    
  #   WEAPON: "무기 인챈트",
  #   ARMOR:  "방어구 인챈트",
    
  #   HINT_HEAD:  "장비에 인챈트를 부여하실 수 있습니다.",
  #   HINT_FOOT:  "어느 마결정으로 인챈트를 부여하시겠습니까?",
  #   HINT_FOOT2: "마결정은 10개씩 소모되며 아래의 인챈트 중 랜덤으로 부여합니다.",
  #   #HINT_FOOT3: sprintf("추가로 인챈트 비용은 \\M[%d]입니다.", $game_variables[28] * ((($game_variables[33] * $game_variables[33]) + 1) * ($game_variables[163] * 0.01).to_f).to_i),
  #   #"추가로 인챈트 비용은 \\M[\\V[28]*(\\V[33]+1)]입니다.",
  #   #HINT_ERROR: "인챈트 비용이 부족합니다, 인챈트 비용으로 \\M[\\V[28]*(\\V[33]+1)]이 필요합니다.",
  #   HINT_SEP:   "~",
  #   HINT_UNIT:  "개",
  #   HINT_SUCCESS: "인챈트를 부여하여 다음과 같은 장비로 변경되었습니다.",
    
  #   OK1:    "흑마(",
  #   OK2:    "적마(",
  #   OK3:    "자마(",
  #   OK4:    "청마(",
  #   OK5:    "녹마(",
  #   OK6:    "황마(",
  #   OK7:    "백마(",
  #   CNACEL: "취소한다."

  # }
    VOCAB = {

    WEAPON: "Encantamiento de arma",
    ARMOR:  "Encantamiento de armadura",

    HINT_HEAD:  "Puedes encantar tu equipo.",
    HINT_FOOT:  "¿Con qué cristal mágico deseas aplicar el encantamiento?",
    HINT_FOOT2: "Se consumirán 10 cristales mágicos y uno de los encantamientos de abajo se aplicará al azar.",
    # HINT_FOOT3: sprintf("El costo adicional del encantamiento es \\M[%d].", $game_variables[28] * ((($game_variables[33] * $game_variables[33]) + 1) * ($game_variables[163] * 0.01).to_f).to_i),
    # "El costo adicional del encantamiento es \\M[\\V[28]*(\\V[33]+1)].",
    # HINT_ERROR: "Faltan fondos para el encantamiento. Se necesita \\M[\\V[28]*(\\V[33]+1)] para el costo del encantamiento.",
    HINT_SEP:   "~",
    HINT_UNIT:  "unidades",
    HINT_SUCCESS: "El encantamiento ha sido aplicado, y tu equipo ha sido transformado de la siguiente manera.",

    OK1:    "Brujo negro (",
    OK2:    "Brujo rojo (",
    OK3:    "Brujo púrpura (",
    OK4:    "Brujo azul (",
    OK5:    "Brujo verde (",
    OK6:    "Brujo amarillo (",
    OK7:    "Brujo blanco (",
    CNACEL: "Cancelar."
  }

#==============================================================================
# 설정 끝
#==============================================================================

class << self
  def enough_money?;   $game_party.gold >= ($game_variables[28] * ((($game_variables[33] * $game_variables[33]) + 1) * ($game_variables[163] * 0.01).to_f).to_i); end
  def enough_money1?;  $game_party.item_number($data_items[448]) >= 10 and $game_party.gold >= ($game_variables[28] * ((($game_variables[33] * $game_variables[33]) + 1) * ($game_variables[163] * 0.01).to_f).to_i); end
  def enough_money2?;  $game_party.item_number($data_items[449]) >= 10 and $game_party.gold >= ($game_variables[28] * ((($game_variables[33] * $game_variables[33]) + 1) * ($game_variables[163] * 0.01).to_f).to_i); end
  def enough_money3?;  $game_party.item_number($data_items[450]) >= 10 and $game_party.gold >= ($game_variables[28] * ((($game_variables[33] * $game_variables[33]) + 1) * ($game_variables[163] * 0.01).to_f).to_i); end
  def enough_money4?;  $game_party.item_number($data_items[451]) >= 10 and $game_party.gold >= ($game_variables[28] * ((($game_variables[33] * $game_variables[33]) + 1) * ($game_variables[163] * 0.01).to_f).to_i); end
  def enough_money5?;  $game_party.item_number($data_items[452]) >= 10 and $game_party.gold >= ($game_variables[28] * ((($game_variables[33] * $game_variables[33]) + 1) * ($game_variables[163] * 0.01).to_f).to_i); end
  def enough_money6?;  $game_party.item_number($data_items[453]) >= 10 and $game_party.gold >= ($game_variables[28] * ((($game_variables[33] * $game_variables[33]) + 1) * ($game_variables[163] * 0.01).to_f).to_i); end
  def enough_money7?;  $game_party.item_number($data_items[454]) >= 10 and $game_party.gold >= ($game_variables[28] * ((($game_variables[33] * $game_variables[33]) + 1) * ($game_variables[163] * 0.01).to_f).to_i); end
  def call; SceneManager.call(Scene_2); end
end

Gold = Class.new(Window_Gold)

class Category < Window_ItemCategory
  def initialize(width)
    # 소지금 초과시 빨간색으로 표시 적용
    $game_switches[141] = false if $game_switches[141] == true
    super()
  end
  def window_width; Graphics.width; end
  def col_max; return 2; end
  def make_command_list
    add_command(VOCAB[:WEAPON], :weapon)
    add_command(VOCAB[:ARMOR], :armor)
  end
end

class Confirm < Window_HorzCommand
  def initialize(x,y)
    super
    self.openness = 0
    self.z = 300
    self.back_opacity = 230
  end
  def window_width; Graphics.width; end
  def col_max; 8; end
  def make_command_list
    add_command(VOCAB[:OK1] + "#{$game_party.item_number($data_items[448])}" + '/10)', :ok1, M5DI20160122_2.enough_money1?)
    add_command(VOCAB[:OK2] + "#{$game_party.item_number($data_items[449])}" + '/10)', :ok2, M5DI20160122_2.enough_money2?)
    add_command(VOCAB[:OK3] + "#{$game_party.item_number($data_items[450])}" + '/10)', :ok3, M5DI20160122_2.enough_money3?)
    add_command(VOCAB[:OK4] + "#{$game_party.item_number($data_items[451])}" + '/10)', :ok4, M5DI20160122_2.enough_money4?)
    add_command(VOCAB[:OK5] + "#{$game_party.item_number($data_items[452])}" + '/10)', :ok5, M5DI20160122_2.enough_money5?)
    add_command(VOCAB[:OK6] + "#{$game_party.item_number($data_items[453])}" + '/10)', :ok6, M5DI20160122_2.enough_money6?)
    add_command(VOCAB[:OK7] + "#{$game_party.item_number($data_items[454])}" + '/10)', :ok7, M5DI20160122_2.enough_money7?)
    add_command(VOCAB[:CNACEL], :cancel)
  end
end

class Result < Window_Base
  def initialize(height)
    # 분해 정보창 높이
    super *position(height)
    self.openness = 0
    self.z = 300
    self.back_opacity = 230
  end
  def update
    super
    # 인챈트 목록 갱신
    refresh(0) if @armor_reset != $game_variables[33] and $game_variables[33] != 7
  end
  def position(height)
    return [0, 0, Graphics.width, height]
  end
  def line_height; super; end
  #----------------------------------------------------------------------------
  def draw_line2(y)
    color = get_color(Venka::Bestiary::Line_Color)
    contents.fill_rect(4, y, contents_width - 8, 2, color)
    contents.fill_rect(4, y + 2, contents_width - 8, 1, Color.new(16,16,16,100))
    
    #color = get_color(Venka::Crafting::Line_Color)
    #contents.fill_rect(4, y + 12, contents_width - 8, 1, color)
    #contents.fill_rect(4, y + 13, contents_width - 8, 1, Color.new(16,16,16,100))
  end
  #----------------------------------------------------------------------------
  def draw_line(line, type, data)
    y = line * line_height
    case type
    when 0
      draw_text_ex(5, y, data)
      line += 1
    when 1
      armor_inh = []
      armor_inh_padding = -24
      width_inh = 0
      case $game_variables[33]
      when 0
        armor_inh = [230,231,302,303,304,305,293,307,308,
                    238,239,240,287,289,292,306,294,295,297,298,299,232,310,233,234,235,
                    ]
      when 1
        armor_inh = [230,231,302,303,304,305,293,307,308,
                    238,239,240,287,289,292,306,294,295,297,298,299,232,310,233,234,235,
                    236,237,241,242,243,244,245,246,247,248,249,284,286,290,296,300
                    ]
      when 2
        armor_inh = [230,231,302,303,304,305,293,307,308,
                    238,239,240,287,289,292,306,294,295,297,298,299,232,310,233,234,235,
                    236,237,241,242,243,244,245,246,247,248,249,284,286,290,296,300,
                    285,288,291,301
                    ]
      when 3
        armor_inh = [230,231,302,303,304,305,293,307,308,
                    238,239,240,287,289,292,306,294,295,297,298,299,232,310,233,234,235,
                    236,237,241,242,243,244,245,246,247,248,249,284,286,290,296,300,
                    285,288,291,301
                    ]
      when 4
        armor_inh = [230,231,302,303,304,305,293,307,308,
                    238,239,240,287,289,292,306,294,295,297,298,299,232,310,233,234,235,
                    236,237,241,242,243,244,245,246,247,248,249,284,286,290,296,300,
                    285,288,291,301
                    ]
      when 5
        armor_inh = [230,231,302,303,304,305,293,307,308,
                    238,239,240,287,289,292,306,294,295,297,298,299,232,310,233,234,235,
                    236,237,241,242,243,244,245,246,247,248,249,284,286,290,296,300,
                    285,288,291,301
                    ]
      when 6
        armor_inh = [230,231,302,303,304,305,293,307,308,
                    238,239,240,287,289,292,306,294,295,297,298,299,232,310,233,234,235,
                    236,237,241,242,243,244,245,246,247,248,249,284,286,290,296,300,
                    285,288,291,301,309,311,312
                    ]
      else
        armor_inh = [230]
      end
      for i in 0...armor_inh.size
        # 아이템 인챈트 적용
        width_inh = text_size($data_armors[armor_inh[i]].name).width + 10
        if armor_inh_padding + width_inh + 24 > contents.width
          armor_inh_padding = -24
          line += 1
          y = line * line_height
        end
        draw_item_name($data_armors[armor_inh[i]], armor_inh_padding, y, true, width_inh)
        armor_inh_padding += width_inh
        if armor_inh.count > i + 1
          draw_text(armor_inh_padding + 15, y, 10, 24, ",")
        end
        #$game_variables[28] = ((@item_window.item.price / 2) * ($game_variables[163] * 0.01).to_f).to_i * ((($game_variables[33] * $game_variables[33]) + 1) * ($game_variables[163] * 0.01).to_f).to_i.to_i
        #$game_variables[28] = 3 if 3 > $game_variables[28]
        @armor_reset = $game_variables[33]
      end
      line += 1
    when 2
      width = contents.width
      y += 5
      draw_line2(y)
      y += 5
      line += 0.4
    when 3
      padding = draw_item_padding
      width = contents.width - padding * 2
      self.contents.font.size = 22
      self.contents.font.color = (text_color(10))
      y += 5
      draw_text(padding - 5, y - 5, width, line_height, "Precauciones")
      line += 1
    when 4
      padding = draw_item_padding
      width = contents.width - padding * 2
      self.contents.font.size = 22
      self.contents.font.color = (text_color(1))
      y += 5
      draw_text(padding - 5, y - 5, width, line_height, "Equipo cambiado")
      line += 1
    when 5
      padding = draw_item_padding
      width = contents.width - padding * 2
      self.contents.font.size = 22
      self.contents.font.color = (Color.new(0, 255, 0, 200))
      draw_text(padding - 5, y - 5, width, line_height, "Encantamiento", 1)
      line += 1
    when 6
      padding = draw_item_padding
      width = contents.width - padding * 2
      self.contents.font.size = 22
      self.contents.font.color = (text_color(14))
      draw_text(padding - 5, y - 5, width, line_height, "Resultado", 1)
      line += 1
    when 7
      padding = draw_item_padding
      width = contents.width - padding * 2
      draw_item_name($game_variables[77], padding + 5, y, true, width)
      line += 1
    end
  end
  def draw_item_padding
    5
  end
  def draw_item_number(value)
    value == 1 ? "1 " : "1 #{VOCAB[:HINT_SEP]} #{value} "
  end
  def refresh(data)
    contents.clear
    line = 0
    line = draw_line(line, 5, "")
    line = draw_line(line, 0, VOCAB[:HINT_HEAD])
    #if M5DI20160122_2.enough_money?
      line = draw_line(line, 0, VOCAB[:HINT_FOOT])
      line = draw_line(line, 2, "")
      line = draw_line(line, 3, "")
      line = draw_line(line, 0, VOCAB[:HINT_FOOT2])
      line = draw_line(line, 1, "")
      line = draw_line(line, 2, "")
      #line = draw_line(line, 0, VOCAB[:HINT_FOOT3])
      # text = sprintf("추가로 인챈트 비용은 \\M[%d]입니다.", $game_variables[28] * ((($game_variables[33] * $game_variables[33]) + 1) * ($game_variables[163] * 0.01).to_f).to_i)
      text = sprintf("El costo adicional del encantamiento es \\M[%d].", $game_variables[28] * ((($game_variables[33] * $game_variables[33]) + 1) * ($game_variables[163] * 0.01).to_f).to_i)
      line = draw_line(line, 0, text)
      #line = draw_line(line, 2, "")
    #else
      #line = draw_line(line, 0, VOCAB[:HINT_ERROR])
    #  text = sprintf("인챈트 비용이 부족합니다, 인챈트 비용으로 \\M[%d]이 필요합니다.", $game_variables[28] * ((($game_variables[33] * $game_variables[33]) + 1) * ($game_variables[163] * 0.01).to_f).to_i)
    #  line = draw_line(line, 0, text)
    #end
  end
end

class Success < Result
  def position(height)
    return [0, 0, Graphics.width, height]
  end
  def draw_item_padding
    5
  end
  def draw_item_number(value)
    return "#{value} "
  end
  def refresh(data)
    contents.clear
    line = 0
    line = draw_line(line, 6, "")
    line = draw_line(line, 0, VOCAB[:HINT_SUCCESS])
    line = draw_line(line, 2, "")
    line = draw_line(line, 4, "")
    line = draw_line(line, 7, $game_variables[77]) if $game_variables[77] != 0
    #line = draw_line(line, 2, "")
  end
end

class SuccessCommand < Window_Command
  def window_width; 0; end
  def make_command_list
    add_command('close success window', :ok)
  end
end

class List_inch < Window_ItemList
  def include?(item)
    return item.is_a?(RPG::Item) if @category == :item
    super(item)
  end
  def enable?(item); item; end
  def category=(category)
    return if @category == category
    @m5_data = nil
    super(category)
  end
  def make_item_list
    super
    @m5_data = {} unless @m5_data
    @data.reject! do |item|
      next false if @m5_data[item.id]
      result = item.m50160122_decompose_result
      next true unless result
      @m5_data[item.id] = result
      false
    end
    @index = [@index, @data.size - 1].min
  end
  def item_decompose_data
    return [] unless item
    @m5_data[item.id].collect{|id, num| [$data_items[id], num] }
  end
end

class Scene_2 < Scene_MenuBase
  def start
    super
    create_help_window
    create_2_category_window
    create_2_list_window
    create_2_confirm_window
    create_2_result_window
    create_2_success_window
    create_2_itemsize_window
    
    # 상세 데이터 설명창 추가
    create_description_window
  end
  #--------------------------------------------------------------------------
  # 상세 데이터 설명창 추가
  #--------------------------------------------------------------------------
  def item
    @item_window.item
  end
  def show_sub_window(window)
    @category_window.hide
    @help_window.hide
    @item_window.hide
    @viewport.rect.width = 0
    window.show.activate
  end
  def hide_sub_window(window)
    @category_window.show
    @help_window.show
    @item_window.show
    @viewport.rect.width = Graphics.width
    window.hide.deactivate
    (@item_window.index == -1 ? @slot_window : @item_window).activate
  end
  #--------------------------------------------------------------------------
  def create_2_itemsize_window
    return unless Theo::LimInv::Display_ItemSize
    wy = Graphics.height - @help_window.line_height * 2
    wh = Graphics.width
    @itemsize = Window_ItemSize2.new(0,wy,wh)
    @itemsize.viewport = @viewport
    @item_window.item_size_window = @itemsize
  end
  def create_2_category_window
    @category_window = Category.new(Graphics.width)
    @category_window.help_window = @help_window
    @category_window.y = @help_window.height
    @category_window.set_handler(:ok, method(:on_category_ok))
    @category_window.set_handler(:cancel, method(:return_scene))
  end
  def create_2_gold_window
    @gold_window = Gold.new
    @gold_window.x = Graphics.width - @gold_window.width
    @gold_window.y = @help_window.height
  end
  def create_2_list_window
    wy = @category_window.y + @category_window.height
    wh = Graphics.height - wy - @help_window.line_height * 2
    @item_window = List_inch.new(0, wy, Graphics.width, wh)
    @item_window.help_window = @help_window
    @item_window.set_handler(:ok,     method(:on_item_ok))
    @item_window.set_handler(:cancel, method(:on_item_cancel))
    #--------------------------------------------------------------------------
    # 상세 데이터 설명창 추가
    #--------------------------------------------------------------------------
    @description_window = Window_ItemDescription.new
    @item_window.set_handler(:description, method(:on_item_description))
    #--------------------------------------------------------------------------
    @category_window.item_window = @item_window
  end
  def create_2_confirm_window
    @confirm_window = Confirm.new(0, 0)
    @confirm_window.y = Graphics.height - @confirm_window.height - @help_window.line_height * 2
    @confirm_window.set_handler(:ok1,     method(:on_confirm_ok1))
    @confirm_window.set_handler(:ok2,     method(:on_confirm_ok2))
    @confirm_window.set_handler(:ok3,     method(:on_confirm_ok3))
    @confirm_window.set_handler(:ok4,     method(:on_confirm_ok4))
    @confirm_window.set_handler(:ok5,     method(:on_confirm_ok5))
    @confirm_window.set_handler(:ok6,     method(:on_confirm_ok6))
    @confirm_window.set_handler(:ok7,     method(:on_confirm_ok7))
    @confirm_window.set_handler(:cancel, method(:on_confirm_cancel))
  end
  def create_2_result_window
    @result_window = Result.new(Graphics.height - @confirm_window.height - @category_window.height - @help_window.line_height * 5)
    @result_window.y = @category_window.height + @help_window.line_height * 3
    @result_window.back_opacity = 192
  end
  def create_2_success_window
    @success_window = Success.new(Graphics.height - @category_window.height - @help_window.line_height * 5)
    @success_window.y = @category_window.height + @help_window.line_height * 3
    @success_window.back_opacity = 192
    @success_window_command = SuccessCommand.new(0,0)
    @success_window_command.deactivate
    @success_window_command.set_handler(:ok, method(:on_confirm_cancel))
    @success_window_command.set_handler(:cancel, method(:on_confirm_cancel))
  end
  def on_category_ok
    @item_window.activate.select(0)
  end
  def on_item_ok
    # 인챈트 비용 입력
    #$game_variables[28] = ((500 - $game_variables[163] + @item_window.item.price) / 4).to_i
    $game_variables[28] = ((@item_window.item.price / 2) * ($game_variables[163] * 0.01).to_f).to_i
    $game_variables[28] = 3 if 3 > $game_variables[28]
    
    @item_window.hide
    @result_window.refresh(@item_window.item_decompose_data)
    @result_window.show
    @result_window.open
    @confirm_window.refresh
    @confirm_window.open.activate
  end
  def on_item_cancel
    @item_window.unselect
    @category_window.activate
  end
  def on_confirm_ok1
    case rand(100)
      # 3% 레어도 2 -------------------------------------------------------------
      when 0..3;        inh_rand = rand(2) + 238
      when 4..5;        inh_rand = 287
      when 6..7;        inh_rand = 289
      when 8..14;       inh_rand = rand(3) + 292
      when 14..20;      inh_rand = rand(2) + 297
      when 21..40;      inh_rand = rand(3) + 232
      else # 꽝 ----------------------------------------------------------------
        inh_rand = rand(1) + 230
    end
    result = []
    @item_window.item.suffix_id = inh_rand  # 접두 추가
    inh_item = @item_window.item
    $game_variables[77] = inh_item; result << [inh_item, 1]
    $game_party.lose_item($data_items[448], 10)
    $game_party.lose_gold($game_variables[28] * ((($game_variables[33] * $game_variables[33]) + 1) * ($game_variables[163] * 0.01).to_f).to_i)
    
    RPG::SE.new("Flash2", 80).play
    
    @result_window.close;    @confirm_window.close
    @itemsize.refresh;       @item_window.refresh
    @success_window.refresh(result)
    @success_window.open;    @success_window_command.activate
  end
  def on_confirm_ok2
    case rand(100)
      # 3% 레어도 2 -------------------------------------------------------------
      when 0..3;        inh_rand = rand(2) + 238
      when 4..5;        inh_rand = 287
      when 6..7;        inh_rand = 289
      when 8..14;       inh_rand = rand(3) + 292
      when 14..20;      inh_rand = rand(2) + 297
      when 21..40;      inh_rand = rand(3) + 232
      # 5% 레어도 3 -------------------------------------------------------------
      when 41..46;      inh_rand = rand(1) + 236
      when 47..50;      inh_rand = rand(8) + 241
      when 51..52;      inh_rand = 284
      when 51..52;      inh_rand = 286
      when 53..55;      inh_rand = 290
      when 56..58;      inh_rand = 296
      when 59..61;      inh_rand = 300
      else # 꽝 ----------------------------------------------------------------
        inh_rand = rand(1) + 230
    end
    result = []
    @item_window.item.suffix_id = inh_rand  # 접두 추가
    inh_item = @item_window.item
    $game_variables[77] = inh_item; result << [inh_item, 1]
    $game_party.lose_item($data_items[449], 10)
    $game_party.lose_gold($game_variables[28] * ((($game_variables[33] * $game_variables[33]) + 1) * ($game_variables[163] * 0.01).to_f).to_i)
    
    RPG::SE.new("Flash2", 80).play
    
    @result_window.close;    @confirm_window.close
    @itemsize.refresh;       @item_window.refresh
    @success_window.refresh(result)
    @success_window.open;    @success_window_command.activate
  end
  def on_confirm_ok3
    case rand(100)
      # 3% 레어도 2 -------------------------------------------------------------
      when 0..3;        inh_rand = rand(2) + 238
      when 4..5;        inh_rand = 287
      when 6..7;        inh_rand = 289
      when 8..14;       inh_rand = rand(3) + 292
      when 14..20;      inh_rand = rand(2) + 297
      when 21..40;      inh_rand = rand(3) + 232
      when 70;          inh_rand = 310
      # 5% 레어도 3 -------------------------------------------------------------
      when 41..46;      inh_rand = rand(1) + 236
      when 47..50;      inh_rand = rand(8) + 241
      when 51..52;      inh_rand = 284
      when 51..52;      inh_rand = 286
      when 53..55;      inh_rand = 290
      when 56..58;      inh_rand = 296
      when 59..61;      inh_rand = 300
      # 2% 레어도 4 -------------------------------------------------------------
      when 62..63;      inh_rand = 285
      when 64..65;      inh_rand = 288
      when 66..67;      inh_rand = 291
      when 68..69;      inh_rand = 301
      else # 꽝 ----------------------------------------------------------------
        inh_rand = rand(1) + 230
    end
    result = []
    @item_window.item.suffix_id = inh_rand  # 접두 추가
    inh_item = @item_window.item
    $game_variables[77] = inh_item; result << [inh_item, 1]
    $game_party.lose_item($data_items[450], 10)
    $game_party.lose_gold($game_variables[28] * ((($game_variables[33] * $game_variables[33]) + 1) * ($game_variables[163] * 0.01).to_f).to_i)
    
    RPG::SE.new("Flash2", 80).play
    
    @result_window.close;    @confirm_window.close
    @itemsize.refresh;       @item_window.refresh
    @success_window.refresh(result)
    @success_window.open;    @success_window_command.activate
  end
  def on_confirm_ok4
    case rand(100)
      # 3% 레어도 2 -------------------------------------------------------------
      when 0..3;        inh_rand = rand(2) + 238
      when 4..5;        inh_rand = 287
      when 6..7;        inh_rand = 289
      when 8..14;       inh_rand = rand(3) + 292
      when 14..20;      inh_rand = rand(2) + 297
      when 21..40;      inh_rand = rand(3) + 232
      when 70;          inh_rand = 310
      # 5% 레어도 3 -------------------------------------------------------------
      when 41..46;      inh_rand = rand(1) + 236
      when 47..50;      inh_rand = rand(8) + 241
      when 51..52;      inh_rand = 284
      when 51..52;      inh_rand = 286
      when 53..55;      inh_rand = 290
      when 56..58;      inh_rand = 296
      when 59..61;      inh_rand = 300
      # 4% 레어도 4 -------------------------------------------------------------
      when 62..65;      inh_rand = 285
      when 66..70;      inh_rand = 288
      when 71..75;      inh_rand = 291
      when 76..80;      inh_rand = 301
      else # 꽝 ----------------------------------------------------------------
        inh_rand = rand(1) + 230
    end
    result = []
    @item_window.item.suffix_id = inh_rand  # 접두 추가
    inh_item = @item_window.item
    $game_variables[77] = inh_item; result << [inh_item, 1]
    $game_party.lose_item($data_items[451], 10)
    $game_party.lose_gold($game_variables[28] * ((($game_variables[33] * $game_variables[33]) + 1) * ($game_variables[163] * 0.01).to_f).to_i)
    
    RPG::SE.new("Flash2", 80).play
    
    @result_window.close;    @confirm_window.close
    @itemsize.refresh;       @item_window.refresh
    @success_window.refresh(result)
    @success_window.open;    @success_window_command.activate
  end
  def on_confirm_ok5
    case rand(100)
      # 3% 레어도 2 -------------------------------------------------------------
      when 0..3;        inh_rand = rand(2) + 238
      when 4..5;        inh_rand = 287
      when 6..7;        inh_rand = 289
      when 8..14;       inh_rand = rand(3) + 292
      when 14..20;      inh_rand = rand(2) + 297
      when 21..40;      inh_rand = rand(3) + 232
      when 90;          inh_rand = 310
      # 5% 레어도 3 -------------------------------------------------------------
      when 41..46;      inh_rand = rand(1) + 236
      when 47..50;      inh_rand = rand(8) + 241
      when 51..52;      inh_rand = 284
      when 51..52;      inh_rand = 286
      when 53..55;      inh_rand = 290
      when 56..58;      inh_rand = 296
      when 59..61;      inh_rand = 300
      # 6% 레어도 4 -------------------------------------------------------------
      when 62..68;      inh_rand = 285
      when 69..75;      inh_rand = 288
      when 76..82;      inh_rand = 291
      when 83..89;      inh_rand = 301
      else # 꽝 ----------------------------------------------------------------
        inh_rand = rand(1) + 230
    end
    result = []
    @item_window.item.suffix_id = inh_rand  # 접두 추가
    inh_item = @item_window.item
    $game_variables[77] = inh_item; result << [inh_item, 1]
    $game_party.lose_item($data_items[452], 10)
    $game_party.lose_gold($game_variables[28] * ((($game_variables[33] * $game_variables[33]) + 1) * ($game_variables[163] * 0.01).to_f).to_i)
    
    RPG::SE.new("Flash2", 80).play
    
    @result_window.close;    @confirm_window.close
    @itemsize.refresh;       @item_window.refresh
    @success_window.refresh(result)
    @success_window.open;    @success_window_command.activate
  end
  def on_confirm_ok6
    case rand(100)
      # 3% 레어도 2 -------------------------------------------------------------
      when 0..3;        inh_rand = rand(2) + 238
      when 4..5;        inh_rand = 287
      when 6..7;        inh_rand = 289
      when 8..14;       inh_rand = rand(3) + 292
      when 14..20;      inh_rand = rand(2) + 297
      when 21..40;      inh_rand = rand(3) + 232
      when 90;          inh_rand = 310
      # 5% 레어도 3 -------------------------------------------------------------
      when 41..46;      inh_rand = rand(1) + 236
      when 47..50;      inh_rand = rand(8) + 241
      when 51..52;      inh_rand = 284
      when 51..52;      inh_rand = 286
      when 53..55;      inh_rand = 290
      when 56..58;      inh_rand = 296
      when 59..61;      inh_rand = 300
      # 6% 레어도 4 -------------------------------------------------------------
      when 62..68;      inh_rand = 285
      when 69..75;      inh_rand = 288
      when 76..82;      inh_rand = 291
      when 83..89;      inh_rand = 301
      else # 꽝 ----------------------------------------------------------------
        inh_rand = rand(1) + 230
    end
    case rand(100)
      # 5% ---------------------------------------------------------------------
      when 0..5;        inh_rand_2 = rand(4) + 201
      when 6..10;       inh_rand_2 = rand(4) + 207
      when 11..15;      inh_rand_2 = rand(2) + 213
      when 16..17;      inh_rand_2 = rand(2) + 217
      when 18..20;      inh_rand_2 = rand(2) + 221
      when 21..25;      inh_rand_2 = rand(3) + 225
      # 5% ---------------------------------------------------------------------
      when 26..28;      inh_rand_2 = rand(14) + 251
      when 6..10;       inh_rand_2 = rand(2) + 267
      when 11..15;      inh_rand_2 = rand(3) + 271
      when 16..17;      inh_rand_2 = rand(2) + 276
      when 18..20;      inh_rand_2 = rand(2) + 280
      else # 꽝 ----------------------------------------------------------------
        inh_rand_2 = 0
    end
    result = []
    @item_window.item.suffix_id = inh_rand                        # 접두 추가
    @item_window.item.prefix_id = inh_rand_2 if inh_rand_2 != 0   # 접미 추가
    inh_item = @item_window.item
    $game_variables[77] = inh_item; result << [inh_item, 1]
    $game_party.lose_item($data_items[453], 10)
    $game_party.lose_gold($game_variables[28] * ((($game_variables[33] * $game_variables[33]) + 1) * ($game_variables[163] * 0.01).to_f).to_i)
    
    RPG::SE.new("Flash2", 80).play
    
    @result_window.close;    @confirm_window.close
    @itemsize.refresh;       @item_window.refresh
    @success_window.refresh(result)
    @success_window.open;    @success_window_command.activate
  end
  def on_confirm_ok7
    case rand(100)
      # 3% 레어도 2 -------------------------------------------------------------
      when 0..3;        inh_rand = rand(2) + 238
      when 4..5;        inh_rand = 287
      when 6..7;        inh_rand = 289
      when 8..14;       inh_rand = rand(3) + 292
      when 14..20;      inh_rand = rand(2) + 297
      when 21..40;      inh_rand = rand(3) + 232
      when 90;          inh_rand = 310
      # 5% 레어도 3 -------------------------------------------------------------
      when 41..46;      inh_rand = rand(1) + 236
      when 47..50;      inh_rand = rand(8) + 241
      when 51..52;      inh_rand = 284
      when 51..52;      inh_rand = 286
      when 53..55;      inh_rand = 290
      when 56..58;      inh_rand = 296
      when 59..61;      inh_rand = 300
      # 6% 레어도 4 -------------------------------------------------------------
      when 62..68;      inh_rand = 285
      when 69..75;      inh_rand = 288
      when 76..82;      inh_rand = 291
      when 83..89;      inh_rand = 301
      when 91;          inh_rand = 309
      when 92;          inh_rand = 311
      when 93;          inh_rand = 312
      else # 꽝 ----------------------------------------------------------------
        inh_rand = rand(1) + 230
    end
    case rand(70)
      # 5% ---------------------------------------------------------------------
      when 0..5;        inh_rand_2 = rand(4) + 201
      when 6..10;       inh_rand_2 = rand(4) + 207
      when 11..15;      inh_rand_2 = rand(2) + 213
      when 16..17;      inh_rand_2 = rand(2) + 217
      when 18..20;      inh_rand_2 = rand(2) + 221
      when 21..25;      inh_rand_2 = rand(3) + 225
      # 5% ---------------------------------------------------------------------
      when 26..28;      inh_rand_2 = rand(14) + 251
      when 6..10;       inh_rand_2 = rand(2) + 267
      when 11..15;      inh_rand_2 = rand(3) + 271
      when 16..17;      inh_rand_2 = rand(2) + 276
      when 18..20;      inh_rand_2 = rand(2) + 280
      else # 꽝 ----------------------------------------------------------------
        inh_rand_2 = 0
    end
    result = []
    @item_window.item.suffix_id = inh_rand                        # 접두 추가
    @item_window.item.prefix_id = inh_rand_2 if inh_rand_2 != 0   # 접미 추가
    inh_item = @item_window.item
    $game_variables[77] = inh_item; result << [inh_item, 1]
    $game_party.lose_item($data_items[454], 10)
    $game_party.lose_gold($game_variables[28] * ((($game_variables[33] * $game_variables[33]) + 1) * ($game_variables[163] * 0.01).to_f).to_i)
    
    RPG::SE.new("Flash2", 80).play
    
    @result_window.close;    @confirm_window.close
    @itemsize.refresh;       @item_window.refresh
    @success_window.refresh(result)
    @success_window.open;    @success_window_command.activate
  end
  def on_confirm_cancel
    # 인챈트 취소
    @category_window.show
    @help_window.show
    @item_window.show
    @result_window.close
    @confirm_window.close
    @success_window.close
    @item_window.refresh
    if @confirm_window.index == 7
      @confirm_window.index = 0
    end
    #print("284.아이템 인챈트 적용 - index(%s) \n" % [@confirm_window.index]);
    (@item_window.index == -1 ? @item_window.activate.select(0) : @item_window.activate)
  end
end

end

class RPG::BaseItem
  def m50160122_decompose_result
    # 기본적으로 인챈트 가능하게 한다.
    value = [[265, 1]]
    m5note("분해",nil,true,true) do |result|
      value << eval(result.gsub(/，/){','})
    end
    value.empty? ? [[265, 1]] : value
  end
end