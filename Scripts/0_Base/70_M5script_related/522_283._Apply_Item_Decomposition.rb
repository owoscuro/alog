# encoding: utf-8
# Name: 283. Apply Item Decomposition
# Size: 14924
# encoding: utf-8
# Name: 283.아이템 분해 적용
# Size: 15265
# <분해 [1,3]>
# 아이템을 분해하면 랜덤으로 1~3개의 1호 소품을 획득할 수 있습니다.
$m5script ||= {}; raise("Meow Meow 5 필요") unless $m5script[:M5Base]
$m5script[:M5DI20160122] = 20160122; M5script.version(20151221)
module M5DI20160122
#==============================================================================
# 설정 섹션
#==============================================================================

  ICONBRONZE = 3872
  ICONSILVER = 3873
  ICONGOLD = 3874
  
  GOLD = 500
  RATE = 0.1
  SE = 'Bell2'
  
  VOCAB = {

    ITEM:   "Descomponer otros",
    WEAPON: "Descomponer armas",
    ARMOR:  "Descomponer armaduras",

    HINT_HEAD:  "Si la descomposición tiene éxito, obtendrás lo siguiente.",
    HINT_FOOT:  "¿Realmente deseas descomponerlo? Necesitarás \\M[\\V[28]] como costo de descomposición.",
    HINT_ERROR: "No tienes suficiente dinero, necesitas \\M[\\V[28]] para el costo de descomposición.",
    HINT_SEP:   "~",
    HINT_UNIT:  "unidades",
    HINT_SUCCESS: "La descomposición fue exitosa y obtuviste los siguientes materiales.",

    OK:     "Descomponer.",
    CANCEL: "Cancelar."

  }
  
#==============================================================================
# 설정 끝
#==============================================================================

class << self
  def enough_money?; $game_party.gold >= $game_variables[28] * $game_variables[27]; end
  def call; SceneManager.call(Scene); end
end

Gold = Class.new(Window_Gold)

class Category < Window_ItemCategory
  def initialize(width)
    # 소지금 초과시 빨간색으로 표시 적용
    $game_switches[141] = false if $game_switches[141] == true
    super()
  end
  def window_width; Graphics.width; end
  def col_max; return 3; end
  def make_command_list
    add_command(VOCAB[:ITEM], :item)
    add_command(VOCAB[:WEAPON], :weapon)
    add_command(VOCAB[:ARMOR], :armor)
  end
end

class Confirm < Window_HorzCommand
  def initialize(x,y)
    super
    #self.openness = 0
    self.z = 300
    self.back_opacity = 230
  end
  def window_width; Graphics.width; end
  def col_max; 2; end
  def make_command_list
    add_command(VOCAB[:OK], :ok, M5DI20160122.enough_money?)
    add_command(VOCAB[:CNACEL], :cancel)
  end
end

class Result < Window_Base
  def initialize(height)
    # 분해 정보창 높이
    super *position(height)
    #self.openness = 0
    self.z = 300
    self.back_opacity = 230
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
      padding = draw_item_padding
      width = contents.width - padding * 2
      draw_item_name(data[0], padding + 5, y, true, width)
      num = draw_item_number(data[1])
      #draw_text(padding, y, width, line_height, "×" + "#{num.to_i}", 2)
      draw_text(padding, y, width, line_height, "×" + "#{num.to_i * $game_variables[27]}", 2)
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
      self.contents.font.color = (text_color(1))
      y += 5
      draw_text(padding - 5, y - 5, width, line_height, "Materiales obtenibles")
      line += 1
    when 4
      padding = draw_item_padding
      width = contents.width - padding * 2
      self.contents.font.size = 22
      self.contents.font.color = (text_color(1))
      y += 5
      draw_text(padding - 5, y - 5, width, line_height, "Materiales obtenidos")
      line += 1
    when 5
      padding = draw_item_padding
      width = contents.width - padding * 2
      self.contents.font.size = 22
      self.contents.font.color = (Color.new(0, 255, 0, 200))
      draw_text(padding - 5, y - 5, width, line_height, "Descomponer", 1)
      line += 1
    when 6
      padding = draw_item_padding
      width = contents.width - padding * 2
      self.contents.font.size = 22
      self.contents.font.color = (text_color(14))
      draw_text(padding - 5, y - 5, width, line_height, "Resultado", 1)
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
    line = draw_line(line, 2, "")
    line = draw_line(line, 3, "")
    data.each {|item| line = draw_line(line, 1, item)}
    line = draw_line(line, 2, "")
    line = draw_line(line, 0,
      M5DI20160122.enough_money? ? VOCAB[:HINT_FOOT] : VOCAB[:HINT_ERROR])
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
    data.each {|item| line = draw_line(line, 1, item) }
    #line = draw_line(line, 2, "")
  end
end

class SuccessCommand < Window_Command
  def window_width; 0; end
  def make_command_list
    add_command('close success window', :ok)
  end
end

class List < Window_ItemList
  def include?(item)
    return item.is_a?(RPG::Item) if @category == :item
    super(item)
  end
  def enable?(item);
    if item.is_a?(RPG::Item)
      return false if item.key_item?
    end
    item
    end
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
      result = item.m5_20160122_decompose_result
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

class Scene < Scene_MenuBase
    def start
      super
      $game_variables[27] = 1
      create_help_window
      create_category_window
      create_list_window
      create_confirm_window
      create_result_window
      create_success_window
      create_itemsize_window
      
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
    def create_itemsize_window
      return unless Theo::LimInv::Display_ItemSize
      wy = Graphics.height - @help_window.line_height * 2
      wh = Graphics.width
      @itemsize = Window_ItemSize2.new(0,wy,wh)
      @itemsize.viewport = @viewport
      @item_window.item_size_window = @itemsize
    end
    def create_category_window
      @category_window = Category.new(Graphics.width)
      @category_window.help_window = @help_window
      @category_window.y = @help_window.height
      @category_window.set_handler(:ok, method(:on_category_ok))
      @category_window.set_handler(:cancel, method(:return_scene))
    end
    def create_gold_window
      @gold_window = Gold.new
      @gold_window.x = Graphics.width - @gold_window.width
      @gold_window.y = @help_window.height
    end
    def create_list_window
      wy = @category_window.y + @category_window.height
      wh = Graphics.height - wy - @help_window.line_height * 2
      @item_window = List.new(0, wy, Graphics.width, wh)
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
    def create_confirm_window
      @confirm_window = Confirm.new(0, 0)
      @confirm_window.y = Graphics.height - @confirm_window.height - @help_window.line_height * 2
      @confirm_window.back_opacity = 192
      @confirm_window.hide.deactivate
      @confirm_window.set_handler(:ok,     method(:on_confirm_ok))
      @confirm_window.set_handler(:cancel, method(:on_confirm_cancel))
    end
    def max_naver
      $game_party.item_number(@item_window.item)
    end
    def create_number_window
      @number_window = Window_StorageNumber.new
      @number_window.viewport = @viewport
      @number_window.x = ((Graphics.width / 2) - (@number_window.width / 2)) 
      @number_window.y = ((Graphics.height / 2) - (@number_window.height / 2)) 
      @number_window.set(item, max_naver)
      if max_naver == 1
        on_number_ok
      else
        @number_window.activate
      end
      @number_window.set_handler(:ok,     method(:on_number_ok))
      @number_window.set_handler(:cancel, method(:on_number_cancel))
    end
    def on_number_cancel
      print("283.아이템 분해 적용 - 수량 설정 취소 \n");
      @number_window.hide.deactivate
      #@result_window.close
      #@confirm_window.close
      @result_window.hide
      @confirm_window.hide
      #@success_window.close
      @success_window.hide
      @item_window.refresh
      @item_window.activate
      #@confirm_window.activate
      #@confirm_window.refresh
    end
    def on_number_ok
      # 분해 수량 확인
      $game_variables[27] = @number_window.number
      # 분해 비용 입력
      #$game_variables[28] = ((500 - $game_variables[163] + @item_window.item.price) / 4).to_i * $game_variables[27]
      $game_variables[28] = ((@item_window.item.price / 10) * ($game_variables[163] * 0.01).to_f).to_i * $game_variables[27]
      $game_variables[28] = 3 if 3 > $game_variables[28]
      print("283.아이템 분해 적용 - 수량 설정 완료 %s개 \n" % [$game_variables[27]]);
      @item_window.hide
      #@item_window.hide.deactivate
      @number_window.hide.deactivate
      @result_window.refresh(@item_window.item_decompose_data)
      @result_window.show
      #@result_window.open
      @confirm_window.refresh
      #@confirm_window.show
      @confirm_window.show.activate.select(0)
      #@confirm_window.open.activate.select(0)
    end
    def create_result_window
      @result_window = Result.new(Graphics.height - @confirm_window.height - @category_window.height - @help_window.line_height * 5)
      @result_window.y = @category_window.height + @help_window.line_height * 3
      @result_window.back_opacity = 192
      @result_window.hide
    end
    def create_success_window
      @success_window = Success.new(Graphics.height - @category_window.height - @help_window.line_height * 5)
      @success_window.y = @category_window.height + @help_window.line_height * 3
      @success_window.back_opacity = 192
      @success_window.hide
      @success_window_command = SuccessCommand.new(0,0)
      @success_window_command.set_handler(:ok, method(:on_confirm_cancel))
      @success_window_command.set_handler(:cancel, method(:on_confirm_cancel))
    end
    def on_category_ok
      print("283.아이템 분해 적용 - on_category_ok \n");
      @item_window.activate.select(0)
    end
    def on_item_ok
      print("283.아이템 분해 적용 - on_item_ok \n");
      @item_window.deactivate
      @category_window.deactivate
      @confirm_window.deactivate
      @success_window.deactivate
      @success_window_command.deactivate
      create_number_window
    end
    def on_item_cancel
      print("283.아이템 분해 적용 - on_item_cancel \n");
      @item_window.unselect
      @category_window.activate
    end
    def on_confirm_ok
      print("283.아이템 분해 적용 - on_confirm_ok \n");
      result = []
      $game_party.lose_item(@item_window.item, 1 * $game_variables[27])
      @item_window.item_decompose_data.each do |i, n|
        num = n * (rand + RATE)
        num = [[num.round, 1].max, n].min
        $game_party.gain_item(i, num * $game_variables[27])
        result << [i, num]
      end
      $game_party.lose_gold($game_variables[28])
      
      # 효과음 수정
      RPG::SE.new("Bell2", 80).play
      
      #@result_window.close
      #@confirm_window.close
      @result_window.hide
      @confirm_window.hide
      
      @itemsize.refresh
      @item_window.refresh
      @success_window.refresh(result)
      @success_window.show
      #@success_window.open
      @success_window_command.activate
    end
    def on_confirm_cancel
      print("283.아이템 분해 적용 - on_confirm_cancel \n");
      @category_window.show
      @help_window.show
      @item_window.show
      #@result_window.close
      #@confirm_window.close
      @result_window.hide
      @confirm_window.hide
      #@success_window.close
      @success_window.hide
      
      @item_window.refresh
      (@item_window.index == -1 ? @item_window.activate.select(0) : @item_window.activate)
    end
  end
end

class RPG::BaseItem
  def m5_20160122_decompose_result
    # 기본적으로 인챈트 가능하게 한다.
    value = [[265, 1]]
    m5note("분해",nil,true,true) do |result|
      value << eval(result.gsub(/，/){','})
    end
    value.empty? ? [[265, 1]] : value
  end
end