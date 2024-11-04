# encoding: utf-8
# Name: 194.Window_ShopNumber
# Size: 3300
# encoding: utf-8
# Name: 194.Window_ShopNumber
# Size: 3328
class Window_ShopNumber < Window_Selectable
  attr_accessor :mode
  
  alias theo_liminv_init initialize
  def initialize(x, y, height)
    theo_liminv_init(x, y, height)
    @mode = :buy
  end
  
  alias theo_liminv_refresh refresh
  def refresh
    theo_liminv_refresh
    draw_itemsize
  end

  def draw_itemsize
    item_size = @number * @item.inv_size
    # 구매인지 판매인지 확인 스위치
    if $game_switches[141] != true
      total_size = $game_party.total_inv_size + item_size 
    else
      total_size = $game_party.total_inv_size - item_size 
    end
    txt = sprintf("%d / %d",total_size,$game_party.inv_max)

    ypos = 0
    
    # 상점 물건 구매시 무게 제한 텍스트 표기 실험
    rect = Rect.new(4,ypos,contents.width-8,line_height)
    change_color(system_color)
    draw_text(rect,Theo::LimInv::InvSlotVocab)
    change_color(normal_color)
    change_color(text_color(10)) if total_size >= $game_party.inv_max
    draw_text(rect,txt,2)

    # 해당 아이템 무게도 보이게 실험
    rect2 = Rect.new(4,line_height,contents.width-8,line_height)
    change_color(system_color)
    draw_text(rect2, "Peso", 0)
    change_color(normal_color)
    draw_text(rect2,item_size,2)

    # 해당 아이템 무게도 보이게 실험
    rect2 = Rect.new(4,line_height * 2,contents.width-8,line_height)
    change_color(system_color)
    draw_text(rect2, "Proporción Precio", 0)

    # 구매인지 판매인지 확인 스위치
    @item_rat_pc = 0
    if $game_switches[141] != true
      # 구매
      #@item_rat_pc = ($game_variables[163] * 0.01).to_i
      @item_rat_pc = $game_variables[163]
    else
      # 판매
      #@item_rat_pc = ($game_variables[161] * 0.01).to_i
      @item_rat_pc = $game_variables[161]
    end

    change_color(normal_color)
    text_it_rat = sprintf("%1.0f%%", @item_rat_pc)
    draw_text(rect2, text_it_rat, 2)

    if $game_variables[157]-1 >= 1
      if $game_switches[141] != true
        # 구매
        #@fac_gold_min = ($game_variables[163] * 0.01).to_i
        @fac_gold_min = $game_variables[163]
      else
        # 판매
        #@fac_gold_min = ($game_variables[161] * 0.01).to_i
        @fac_gold_min = $game_variables[161]
      end
      @fac_gold = ((@number * @fac_gold_min.to_i).to_f / 10000).to_i
      @fac_gold = 0 if @fac_gold == nil or 1 > @fac_gold
      # 획득할 지역 공헌도 수치
      rect2 = Rect.new(4,line_height * 3,contents.width-8,line_height)
      change_color(system_color)
      draw_text(rect2, "Valor Adquirido de Contribución", 0)
      change_color(normal_color)
      draw_text(rect2, @fac_gold,2)
      # 아이템 수량 표기 실험
      draw_item_max_size(@item,-2,line_height * 4, false, contents.width)
    else
      # 아이템 수량 표기 실험
      draw_item_max_size(@item,-2,line_height * 3, false, contents.width)
    end
  end

  def update_number
    change_number(1)   if Input.repeat?(:RIGHT)
    change_number(-1)  if Input.repeat?(:LEFT)
    change_number(10)  if Input.repeat?(:UP)
    change_number(-10) if Input.repeat?(:DOWN)
  end

  def change_number(amount)
    # 소지량 제한 최소값 0 으로 수정
    @number = [[@number + amount, @max].min, 0].max
  end
end