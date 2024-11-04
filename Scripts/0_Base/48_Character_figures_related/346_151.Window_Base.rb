# encoding: utf-8
# Name: 151.Window_Base
# Size: 34452
# encoding: utf-8
# Name: 151.Window_Base
# Size: 34070
class Window_Base < Window
  alias :convert_escape_ve_basic_module :convert_escape_characters
  def convert_escape_characters(text)
    result = text.to_s.clone
    result = text_replace(result)
    result = convert_escape_ve_basic_module(text)
    result
  end
  
  def text_replace(result)
    result.gsub!(/\r/) { "" }
    result.gsub!(/\\/) { "\e" }
    result
  end
  
  def draw_inv_slot(x,y,width = contents.width,align = 2)
    txt = sprintf("%d / %d",$game_party.total_inv_size, $game_party.inv_max)
    change_color(normal_color)
    change_color(text_color(10)) if $game_party.total_inv_size >= $game_party.inv_max
    draw_text(x,y,width,line_height,txt,align)
    change_color(normal_color)
  end
  
  # 무게 제한 표기
  def draw_inv_info(x,y,width)
    change_color(system_color)
    draw_text(x,y,width,line_height,Theo::LimInv::InvSlotVocab)
    change_color(normal_color)
    draw_inv_slot(x,y,width)
  end

  # 무게 표기
  def draw_item_size(item,x,y,total,width)
    rect = Rect.new(x,y,width,line_height)
    change_color(system_color)
    draw_text(rect,Theo::LimInv::InvSizeVocab)
    change_color(normal_color)
    number = (Theo::LimInv::DrawTotal_Size && total) ? 
      $game_party.item_size(item) : item.nil? ? 0 : item.inv_size
    draw_text(rect,number,2)
  end

  # 아이템 수량 표기 실험
  def draw_item_max_size(item,x,y,total = true,width = contents.width)
    if item.inv_item_max2 != nil
      rect = Rect.new(x+6,y,width-8,line_height)
      change_color(system_color)
      draw_text(rect,Theo::LimInv::InvSizeMax)

      change_color(normal_color)
      if $game_switches[141] != true
        change_color(text_color(10)) if $game_party.item_number(item)+@number >= item.inv_item_max2
        number = sprintf("%d / %d",$game_party.item_number(item)+@number, item.inv_item_max2)
      else
        change_color(text_color(10)) if $game_party.item_number(item)-@number >= item.inv_item_max2
        number = sprintf("%d / %d",$game_party.item_number(item)-@number, item.inv_item_max2)
      end
      draw_text(rect,number,2)
    end
  end
  
  alias :bm_status_cec :convert_escape_characters
  def convert_escape_characters(text)
    result = bm_status_cec(text)
    result = convert_bm_status_characters(result)    
    return result
  end
  
  def convert_bm_status_characters(result)
    result.gsub!(/\eAAGE\[([-+]?\w+)\]/i)  { escape_actor_bio(:age, $1.to_i) }
    result.gsub!(/\eABIRTH\[([-+]?\w+)\]/i)  { escape_actor_bio(:birthplace, $1.to_i) }
    result.gsub!(/\eAHEIGHT\[([-+]?\w+)\]/i)  { escape_actor_bio(:height, $1.to_i) }
    result.gsub!(/\eABIO\[(\d+),([-+]?\w+)\]/i)  { escape_actor_cbio($1.to_i, $2.to_i) }
    return result
  end
  
  def escape_actor_bio(type, actor_id)
    actor_id = $game_party.members[actor_id.abs].id if actor_id <= 0
    actor = $game_actors[actor_id]
    return "" if actor.nil?
    text = eval("actor.#{type}")
    return text
  end
  
  def escape_actor_cbio(type, actor_id)
    actor_id = $game_party.members[actor_id.abs].id if actor_id <= 0
    actor = $game_actors[actor_id]
    return "" if actor.nil?
    text = eval("actor.custom_bio#{type}")
    return text
  end
  
  alias :bm_base_pnc :process_normal_character
  def process_normal_character(c, pos)
    return unless c >= ' '
    bm_base_pnc(c, pos)
  end
  
  def exp_gauge1; return text_color(BM::EXP_GAUGE1); end
  def exp_gauge2; return text_color(BM::EXP_GAUGE2); end
  def param_gauge1(param_id); return BM::PARAM_COLOUR[param_id][1]; end
  def param_gauge2(param_id); return BM::PARAM_COLOUR[param_id][2]; end
  
  def standby_color(actor)
    return BM::STANDBY_COLOR unless battle_party?(actor)
    return Color.new(0, 0, 0, 0)
  end
  
  def hp_gauge_color1;   BM::PARAM_COLOUR[0][1];   end
  def hp_gauge_color2;   BM::PARAM_COLOUR[0][2];   end
  def mp_gauge_color1;   BM::PARAM_COLOUR[1][1];   end
  def mp_gauge_color2;   BM::PARAM_COLOUR[1][2];   end
  def item_name_color; BM::ITEM_NAME_COLOR; end
  
  def percent_color(value)
    if value < 0; power_down_color
    elsif value > 0; power_up_color
    else;  normal_color
    end
  end
  
  def exp_rate(actor)
    now_exp = actor.exp - actor.current_level_exp
    next_exp = actor.next_level_exp - actor.current_level_exp
    rate = now_exp * 1.0 / next_exp
    rate = [[rate, 1.0].min, 0.0].max
  end
  
  def param_ratio(actor, param_id)
    minimum = 0
    case BM::PARAM_RATIO_MAX
    when :set
      maximum = BM::PARAM_MAX
    when :max
      maximum = actor.param_max(param_id)
    when :current
      maximum = 1
    end
    for i in 2..7
      maximum = [actor.param(i), maximum].max
      minimum = [actor.param(i), minimum].min
    end
    return 1.0 if maximum == minimum
    rate = actor.param(param_id).to_f / maximum.to_f
    return rate
  end
  
  def draw_portrait(portrait_name, x, y, enabled = true)    
    return unless portrait_exist?(portrait_name)
    bitmap = Cache.portrait(portrait_name)
    rect = Rect.new(0, 0, bitmap.width, bitmap.height)
    contents.blt(x-10, y-40, bitmap, rect, 255)
    bitmap.dispose
  end
  
  def draw_portrait2(portrait_name, x, y, enabled = true)    
    @ro_x = 437
    if Graphics.height == 640
      @ro_x -= 10
      @ro_y = Graphics.height * -0.04 + 80
    elsif Graphics.height == 704
      @ro_x -= 10
      @ro_y = Graphics.height * -0.04 + 20
    else
      @ro_y = Graphics.height * -0.04 + 100
    end
    x = x + 35
    y = y - 6
    
    # 빙결, 석화 상태인지 확인, 행동불가인지 확인
    @ro_x -= 62 if portrait_name.id == 7 and ($game_actors[7].state?(133) or $game_actors[7].state?(11))
    
    @self_face_x = -326
    @self_face_y = $game_actors[portrait_name.id].height.split("cm")
    @self_face_y = @self_face_y[0].to_i - Graphics.height * 0.4 + (@self_face_y[0].to_i - 140)
    #print("151.Window_Base - %s \n" % [@self_face_y])
    
    if portrait_name.id == 7
      bitmap = Cache.picture($game_variables[443]) # 몸통
      rect = Rect.new(@ro_x, @ro_y + @self_face_y + 70, 227, Graphics.height * 0.9)
      contents.blt(x, y, bitmap, rect, 255)
      bitmap = Cache.picture($game_variables[444]) # 표정
      contents.blt(x, y, bitmap, rect, 255)
      bitmap = Cache.picture($game_variables[445]) # 성인용품
      contents.blt(x, y, bitmap, rect, 255)
      bitmap = Cache.picture($game_variables[446]) # 발그레
      contents.blt(x, y, bitmap, rect, 255)
      bitmap = Cache.picture($game_variables[447]) # 방어구
      contents.blt(x, y, bitmap, rect, 255)
    else
      filename = "Actor#{portrait_name.id}"
      bitmap = Cache.face(filename)
      rect = Rect.new(@ro_x + @self_face_x, @ro_y + @self_face_y, 227, Graphics.height * 0.9)
      contents.blt(x, y, bitmap, rect, 255)
    end
    
    if Graphics.height == 640
      bitmap = Cache.picture("Actor_Portrait_2")
    elsif Graphics.height == 704
      bitmap = Cache.picture("Actor_Portrait_1")
    else
      bitmap = Cache.picture("Actor_Portrait")
    end
    
    rect = Rect.new(0, 0, bitmap.width, bitmap.height)
    contents.blt(x, y, bitmap, rect, 255)
    bitmap.dispose
  end
  
  #--------------------------------------------------------------------------
  # 가슴, 보지, 엉덩이 이미지
  #--------------------------------------------------------------------------
  def draw_portrait3(portrait_name, x, y, enabled = true)
    y += 4
    if Graphics.height == 640 or Graphics.height == 704
      x += 30
    else
      x += 0
    end
    x1 = x;    y1 = 15
    x2 = x;    y2 = contents.height / 3 + y1
    x3 = x;    y3 = contents.height / 3 + y2
    if portrait_name.id == 7
      # 임신 여부
      if $game_party.item_number($data_items[68]) == 0
        bitmap = Cache.picture("body_st/gs") # 가슴
        rect = Rect.new($game_variables[322] % 5 * 127, $game_variables[323] / 5 * 86, 127, 86)
        contents.blt(x1+2, y1+2, bitmap, rect, 255)
        bitmap = Cache.picture("body_st/bg") # 보지
        rect = Rect.new($game_variables[322] % 5 * 127, $game_variables[324] / 5 * 86, 127, 86)
        contents.blt(x2+2, y2+2, bitmap, rect, 255)
        bitmap = Cache.picture("body_st/dg") # 엉덩이
        rect = Rect.new($game_variables[322] % 5 * 127, $game_variables[325] / 5 * 86, 127, 86)
        contents.blt(x3+2, y3+2, bitmap, rect, 255)
      else
        bitmap = Cache.picture("body_st/gs") # 가슴
        rect = Rect.new(20 % 5 * 127, 20 / 5 * 86, 127, 86)
        contents.blt(x1+2, y1+2, bitmap, rect, 255)
        bitmap = Cache.picture("body_st/bg") # 보지
        rect = Rect.new(20 % 5 * 127, 20 / 5 * 86, 127, 86)
        contents.blt(x2+2, y2+2, bitmap, rect, 255)
        bitmap = Cache.picture("body_st/dg") # 엉덩이
        rect = Rect.new(20 % 5 * 127, 20 / 5 * 86, 127, 86)
        contents.blt(x3+2, y3+2, bitmap, rect, 255)
      end
    end
    # 일레이나, 프리아나, 아우펠, 브라인 페리
    if portrait_name.id == 3 or portrait_name.id == 6 or portrait_name.id == 8
      bitmap = Cache.picture("body_st/gs_zr") # 가슴
      rect = Rect.new(0, 0, 127, 86);    contents.blt(x1+2, y1+2, bitmap, rect, 255)
      bitmap = Cache.picture("body_st/bg_zr") # 보지
      rect = Rect.new(0, 0, 127, 86);    contents.blt(x2+2, y2+2, bitmap, rect, 255)
      bitmap = Cache.picture("body_st/dg_zr") # 엉덩이
      rect = Rect.new(0, 0, 127, 86);    contents.blt(x3+2, y3+2, bitmap, rect, 255)
    elsif portrait_name.id == 10  # 브라인 페리
      bitmap = Cache.picture("body_st/gs_Y") # 가슴
      rect = Rect.new(0, 0, 127, 86);    contents.blt(x1+2, y1+2, bitmap, rect, 255)
      bitmap = Cache.picture("body_st/bg_Y") # 보지
      rect = Rect.new(0, 0, 127, 86);    contents.blt(x2+2, y2+2, bitmap, rect, 255)
      bitmap = Cache.picture("body_st/dg_Y") # 엉덩이
      rect = Rect.new(0, 0, 127, 86);    contents.blt(x3+2, y3+2, bitmap, rect, 255)
    elsif portrait_name.id == 12  # 산시아
      bitmap = Cache.picture("body_st/gs_Y2") # 가슴
      rect = Rect.new(0, 0, 127, 86);    contents.blt(x1+2, y1+2, bitmap, rect, 255)
      bitmap = Cache.picture("body_st/bg_Y2") # 보지
      rect = Rect.new(0, 0, 127, 86);    contents.blt(x2+2, y2+2, bitmap, rect, 255)
      bitmap = Cache.picture("body_st/dg_Y2") # 엉덩이
      rect = Rect.new(0, 0, 127, 86);    contents.blt(x3+2, y3+2, bitmap, rect, 255)
    elsif portrait_name.id == 5  # 세레니아
      bitmap = Cache.picture("body_st/gs_Sr") # 가슴
      rect = Rect.new(0, 0, 127, 86);    contents.blt(x1+2, y1+2, bitmap, rect, 255)
      bitmap = Cache.picture("body_st/bg_Sr") # 보지
      rect = Rect.new(0, 0, 127, 86);    contents.blt(x2+2, y2+2, bitmap, rect, 255)
      bitmap = Cache.picture("body_st/dg_Sr") # 엉덩이
      rect = Rect.new(0, 0, 127, 86);    contents.blt(x3+2, y3+2, bitmap, rect, 255)
    elsif portrait_name.id == 21 or portrait_name.id == 22 # 딸
      bitmap = Cache.picture("body_st/gs_zr") # 가슴
      rect = Rect.new(0, 0, 127, 86);    contents.blt(x1+2, y1+2, bitmap, rect, 255)
      bitmap = Cache.picture("body_st/bg_zr") # 보지
      rect = Rect.new(0, 0, 127, 86);    contents.blt(x2+2, y2+2, bitmap, rect, 255)
      bitmap = Cache.picture("body_st/dg_zr") # 엉덩이
      rect = Rect.new(0, 0, 127, 86);    contents.blt(x3+2, y3+2, bitmap, rect, 255)
    elsif portrait_name.id == 2   # 주스트
      bitmap = Cache.picture("body_st/gs_M") # 가슴
      rect = Rect.new(0, 0, 127, 86);    contents.blt(x1+2, y1+2, bitmap, rect, 255)
      bitmap = Cache.picture("body_st/bg_M") # 고추
      rect = Rect.new(0, 0, 127, 86);    contents.blt(x2+2, y2+2, bitmap, rect, 255)
      bitmap = Cache.picture("body_st/dg_M") # 엉덩이
      rect = Rect.new(0, 0, 127, 86);    contents.blt(x3+2, y3+2, bitmap, rect, 255)
    elsif portrait_name.id == 20  # 아들
      bitmap = Cache.picture("body_st/gs_My") # 가슴
      rect = Rect.new(0, 0, 127, 86);    contents.blt(x1+2, y1+2, bitmap, rect, 255)
      bitmap = Cache.picture("body_st/bg_My") # 고추
      rect = Rect.new(0, 0, 127, 86);    contents.blt(x2+2, y2+2, bitmap, rect, 255)
      bitmap = Cache.picture("body_st/dg_My") # 엉덩이
      rect = Rect.new(0, 0, 127, 86);    contents.blt(x3+2, y3+2, bitmap, rect, 255)
    # 알렉 터너, 시르웬, 잉골프, 브리시오
    elsif portrait_name.id == 1 or portrait_name.id == 4 or portrait_name.id == 11 or portrait_name.id == 13 or portrait_name.id == 14
      bitmap = Cache.picture("body_st/gs_M") # 가슴
      rect = Rect.new(0, 0, 127, 86);    contents.blt(x1+2, y1+2, bitmap, rect, 255)
      bitmap = Cache.picture("body_st/bg_M") # 고추
      rect = Rect.new(0, 0, 127, 86);    contents.blt(x2+2, y2+2, bitmap, rect, 255)
      bitmap = Cache.picture("body_st/dg_M") # 엉덩이
      rect = Rect.new(0, 0, 127, 86);    contents.blt(x3+2, y3+2, bitmap, rect, 255)
    elsif portrait_name.id == 9   # 케튼
      bitmap = Cache.picture("body_st/gs_M") # 가슴
      rect = Rect.new(0, 0, 127, 86);    contents.blt(x1+2, y1+2, bitmap, rect, 255)
      bitmap = Cache.picture("body_st/bg_M") # 고추
      rect = Rect.new(0, 0, 127, 86);    contents.blt(x2+2, y2+2, bitmap, rect, 255)
      bitmap = Cache.picture("body_st/dg_M") # 엉덩이
      rect = Rect.new(0, 0, 127, 86);    contents.blt(x3+2, y3+2, bitmap, rect, 255)
    end
    bitmap = Cache.picture("Actor_Portrait_Meni")
    rect = Rect.new(0, 0, bitmap.width, bitmap.height)
    contents.blt(x1, y1, bitmap, rect, 255)
    contents.blt(x2, y2, bitmap, rect, 255)
    contents.blt(x3, y3, bitmap, rect, 255)
    
    dw = Graphics.width - x
    x1 = Graphics.width - dw - 35;    x2 = x1;        x3 = x1
    y1 = y1 - 14;                     y2 = y2 - 14;   y3 = y3 - 14
    
    contents.font.bold = false
    if Graphics.height == 640
      contents.font.size = 23
    elsif Graphics.height == 704
      contents.font.size = 22
    else
      contents.font.size = 20
    end
    
    if portrait_name.id == 1 or portrait_name.id == 2 or portrait_name.id == 4 or portrait_name.id == 9 or portrait_name.id == 11 or portrait_name.id == 13 or portrait_name.id == 14 or portrait_name.id == 20
      change_color(system_color)
      draw_text(x1, y1, dw, line_height, "Pecho", 1)
      draw_text(x2, y2, dw, line_height, "Pene", 1)
      draw_text(x3, y3, dw, line_height, "Culo", 1)
      
      y1 += 7;    y2 += 7;    y3 += 7
      
      dy = 1
      change_color(normal_color)
      draw_text(x1, y1+line_height, dw, line_height, 
      "Un pecho firme construido con músculos reales,", 2); dy += 1
      draw_text(x1, y1+(line_height*dy), dw, line_height, 
      "además, los abdominales definidos son impresionantes.", 2); dy += 1
      
      dy = 1
      change_color(normal_color)
      draw_text(x2, y2+line_height, dw, line_height, 
      "Un hueso pélvico liso y un pene pesado,", 2); dy += 1
      draw_text(x2, y2+(line_height*dy), dw, line_height, 
      "parece que también se ha preocupado mucho por la limpieza, está limpio.", 2); dy += 1
      
      dy = 1
      change_color(normal_color)
      draw_text(x3, y3+line_height, dw, line_height, 
      "Un trasero de forma bonita pero firme,", 2); dy += 1
      draw_text(x3, y3+(line_height*dy), dw, line_height, 
      "es un orificio que se usa solo para la excreción.", 2); dy += 1
    end
    
    if portrait_name.id == 3 or portrait_name.id == 5 or portrait_name.id == 6 or portrait_name.id == 7 or portrait_name.id == 8 or portrait_name.id == 10 or portrait_name.id == 12 or portrait_name.id == 21 or portrait_name.id == 22
      change_color(system_color)
      draw_text(x1, y1, dw, line_height, "Pecho", 1)
      draw_text(x2, y2, dw, line_height, "Vagina", 1)
      draw_text(x3, y3, dw, line_height, "Trasero", 1)
      
      y1 += 7;    y2 += 7;    y3 += 7
      
      dy = 1
      change_color(normal_color)
      ro_best = 0
      ro_best = $game_actors[portrait_name.id].set_custom_bio[4].to_i      # 질 성교
      #ro_best += $game_actors[portrait_name.id].set_custom_bio[5].to_i     # 항문 성교
      ro_best += $game_actors[portrait_name.id].set_custom_bio[16].to_i    # 매춘
      ro_best += $game_actors[portrait_name.id].set_custom_bio[17].to_i    # 강간
      if ro_best != 0
        ro_best += $game_actors[portrait_name.id].set_custom_bio[13].to_i  # 절정
        ro_best += $game_actors[portrait_name.id].set_custom_bio[14].to_i  # 초절정
      end
      ro_best = (ro_best * 0.5).to_i
      
      if ro_best == -1
        draw_text(x1, y1 + line_height, dw, line_height, 
        "Pecho con un poco de peso y elasticidad,", 2); dy += 1
        draw_text(x1, y1 + (line_height * dy), dw, line_height, 
        "y pezones rosados y suaves.", 2); dy += 1
      elsif ro_best == 0
        $game_variables[323] = 1
        draw_text(x1, y1 + line_height, dw, line_height, 
        "Pecho suave que nunca ha sido tocado por un hombre,", 2); dy += 1
        draw_text(x1, y1 + (line_height * dy), dw, line_height, 
        "y pezones rosados que aún no han experimentado placer.", 2); dy += 1
      elsif 50 >= ro_best and ro_best >= 1
        $game_variables[323] = 2
        draw_text(x1, y1 + line_height, dw, line_height, 
        "Pecho que parece haber crecido un poco por el manoseo de los hombres,", 2); dy += 1
        draw_text(x1, y1 + (line_height * dy), dw, line_height, 
        "pezones rosados que se convierten en un interruptor de placer, y al tocarlos,", 2); dy += 1
        draw_text(x1, y1 + (line_height * dy), dw, line_height, 
        "hacen que reaccione automáticamente de manera adorable.", 2); dy += 1
      elsif ro_best >= 51
        $game_variables[323] = 3
        draw_text(x1, y1 + line_height, dw, line_height, 
        "Pecho donde los pezones se erectan solo con el roce del viento,", 2); dy += 1
        draw_text(x1, y1 + (line_height * dy), dw, line_height, 
        "y con un poco de caricias, se excita rápidamente haciendo temblar las caderas.", 2); dy += 1
      end
      
      # 모유 생산 여부
      if portrait_name.id == 7 and $game_variables[327] != 0
        change_color(text_color(10))
        draw_text(x1, y1 + (line_height * dy), dw, line_height,
        "* Cantidad de leche materna %sml" % [$game_variables[327]], 2); dy += 1
      end
      
      dy = 1
      change_color(normal_color)
      ro_best = 0
      ro_best = $game_actors[portrait_name.id].set_custom_bio[4].to_i      # 질 성교
      #ro_best += $game_actors[portrait_name.id].set_custom_bio[16].to_i    # 매춘
      ro_best += $game_actors[portrait_name.id].set_custom_bio[17].to_i    # 강간
      if ro_best != 0
        ro_best += $game_actors[portrait_name.id].set_custom_bio[13].to_i  # 절정
        ro_best += $game_actors[portrait_name.id].set_custom_bio[14].to_i  # 초절정
      end
      ro_best = (ro_best * 0.7).to_i
      
      if ro_best == -1
        draw_text(x2, y2 + line_height, dw, line_height, 
        "De color rosado, regordeta y sin pelo,", 2); dy += 1
        draw_text(x2, y2 + (line_height * dy), dw, line_height, 
        "es una vagina virgen completamente cerrada.", 2); dy += 1
      elsif ro_best == 0
        $game_variables[324] = 1
        draw_text(x2, y2 + line_height, dw, line_height, 
        "Una vagina que nunca ha sido abierta ni penetrada,", 2); dy += 1
        draw_text(x2, y2 + (line_height * dy), dw, line_height, 
        "el himen intacto es un símbolo de pureza.", 2); dy += 1
      elsif 50 >= ro_best and ro_best >= 1
        $game_variables[324] = 2
        draw_text(x2, y2 + line_height, dw, line_height, 
        "Aunque ha sido penetrada varias veces,", 2); dy += 1
        draw_text(x2, y2 + (line_height * dy), dw, line_height, 
        "su ajuste sigue siendo elogiado por su parecido al de una virgen.", 2); dy += 1
      elsif ro_best >= 51
        $game_variables[324] = 3
        draw_text(x2, y2 + line_height, dw, line_height, 
        "Como una vagina naturalmente excelente, sin importar cuántos penes la", 2); dy += 1
        draw_text(x2, y2 + (line_height * dy), dw, line_height, 
        "penetren, sigue ajustándose como una virgen, sirviendo al pene.", 2); dy += 1
        draw_text(x2, y2 + (line_height * dy), dw, line_height, 
        "Ahora, casi no hay tiempo en que no haya semen dentro.", 2); dy += 1
      end
      
      # 임신 여부
      if portrait_name.id == 7
        if $game_party.item_number($data_items[68]) != 0
          change_color(text_color(10))
          draw_text(x2, y2 + (line_height * dy), dw, line_height,
          "* Embarazo %s días" % [$game_variables[167]], 2); dy += 1
        else
          # Mostrar ciclo menstrual
          if $game_variables[8] >= $game_variables[173]
            change_color(text_color(10))
            # Si está tomando píldoras anticonceptivas
            if $game_actors[7].state?(160) == true
              draw_text(x2, y2 + (line_height * dy), dw, line_height,
              "* No hay menstruación debido a las píldoras anticonceptivas.", 2); dy += 1
            else
              draw_text(x2, y2 + (line_height * dy), dw, line_height,
              "* Días restantes para la menstruación %s días" % [$game_variables[174] - $game_variables[173]], 2); dy += 1
            end
          # Mostrar ciclo ovulatorio
          elsif $game_party.item_number($data_items[68]) == 0 and $game_variables[8] >= $game_variables[173] - 3 and $game_variables[173] - 1 > $game_variables[8]
            # Ajuste de probabilidad de embarazo
            @ro_157state = 0
            @ro_157state += 60
            @ro_157state -= 30 if $game_actors[7].state?(137) == false
            @ro_157state += $game_party.item_number($data_items[67])
            @ro_157state += 40 if $game_actors[7].state?(157) == true   # Inductor de ovulación
            @ro_157state += 20 if $game_actors[7].state?(166) == true   # Fértil
            # Temperatura mágica, activación mágica
            @ro_157state += 10 if $game_actors[7].state?(168) == true
            @ro_157state += 10 if $game_actors[7].state?(174) == true
            # Resistencia mágica a estados anormales de frío mortal
            @ro_157state -= 20 if $game_actors[7].state?(170) == true   # Venas de hielo
            @ro_157state -= 20 if $game_actors[7].state?(171) == true   # Corazón de fuego
            @ro_157state -= 20 if $game_actors[7].state?(172) == true   # Nervios de electricidad
            @ro_157state -= 20 if $game_actors[7].state?(173) == true   # Frío mortal
            # Píldoras anticonceptivas
            @ro_157state -= 90 if $game_actors[7].state?(160) == true   # Píldoras anticonceptivas
            @ro_157state = 0   if $game_variables[114] == "I"
            
            @ro_157state = 100 if @ro_157state > 100
            @ro_157state = 0 if 0 > @ro_157state
            
            # Notificación de ovulación
            change_color(text_color(10))
            draw_text(x2, y2 + (line_height * dy), dw, line_height,
            "* Días restantes para la ovulación %s días (Probabilidad de embarazo %1.0f%%)" % [($game_variables[173] - 1) - $game_variables[8], @ro_157state], 2); dy += 1
          else
            change_color(text_color(10))
            # Si está tomando píldoras anticonceptivas
            if $game_actors[7].state?(160) == true
              draw_text(x2, y2 + (line_height * dy), dw, line_height,
              "* No hay menstruación debido a las píldoras anticonceptivas.", 2); dy += 1
            else
              draw_text(x2, y2 + (line_height * dy), dw, line_height,
              "* Período menstrual desde el %s de mes %s durante %s días" % [$game_variables[10], $game_variables[173], $game_variables[174] - $game_variables[173]], 2); dy += 1
            end
          end
        end
      end

      dy = 1
      change_color(normal_color)
      ro_best = 0
      ro_best = $game_actors[portrait_name.id].set_custom_bio[5].to_i      # 항문 성교
      #ro_best += $game_actors[portrait_name.id].set_custom_bio[17].to_i    # 강간
      #ro_best += $game_actors[portrait_name.id].set_custom_bio[16].to_i    # 매춘
      if ro_best != 0
        ro_best += $game_actors[portrait_name.id].set_custom_bio[13].to_i  # 절정
        ro_best += $game_actors[portrait_name.id].set_custom_bio[14].to_i  # 초절정
      end
      ro_best = (ro_best * 0.7).to_i
      
      if ro_best == -1
        draw_text(x3, y3 + line_height, dw, line_height, 
        "Un trasero de forma bonita con una cantidad adecuada de grasa,", 2); dy += 1
        draw_text(x3, y3 + (line_height * dy), dw, line_height, 
        "parece limpio, como si se hubiera cuidado mucho la higiene.", 2); dy += 1
      elsif ro_best == 0
        $game_variables[325] = 1
        draw_text(x3, y3 + line_height, dw, line_height, 
        "Un agujero utilizado solo para la excreción,", 2); dy += 1
        draw_text(x3, y3 + (line_height * dy), dw, line_height, 
        "nunca ha sido usado con fines de placer.", 2); dy += 1
        draw_text(x3, y3 + (line_height * dy), dw, line_height, 
        "Un trasero adecuado para un parto fácil, se ha convertido en la fantasía de muchos hombres.", 2); dy += 1
      elsif 50 >= ro_best and ro_best >= 1
        $game_variables[325] = 2
        draw_text(x3, y3 + line_height, dw, line_height, 
        "Un agujero que ha conocido el placer por un uso no convencional,", 2); dy += 1
        draw_text(x3, y3 + (line_height * dy), dw, line_height, 
        "hombres que antes solo lo miraban ahora lo disfrutan plenamente,", 2); dy += 1
        draw_text(x3, y3 + (line_height * dy), dw, line_height, 
        "la sensación es como la de un pecho, haciendo que sus penes se erecten de nuevo.", 2); dy += 1
      elsif ro_best >= 51
        $game_variables[325] = 3
        draw_text(x3, y3 + line_height, dw, line_height, 
        "Ahora es un agujero utilizado más como un órgano de placer,", 2); dy += 1
        draw_text(x3, y3 + (line_height * dy), dw, line_height, 
        "el cuerpo se ha adaptado tanto que llega al orgasmo varias veces al defecar.", 2); dy += 1
      end
    end
    bitmap.dispose
  end
  
  def draw_portrait4(portrait_name, x, y, actor, enabled = true)
    x += 44
    y -= 10
    if portrait_name == "Actor-not-Portrait"
      bitmap = Cache.portrait(portrait_name)
      rect = Rect.new(0, 0, bitmap.width, bitmap.height)
    else
      bitmap = Cache.face(portrait_name)
      #@self_face_x = 0
      #@self_face_y = 0
      # 값이 없으면 캐릭터 정보 갱신
      #if $game_actors[actor.id].set_custom_bio[25] == nil or
      #  $game_actors[actor.id].set_custom_bio[25] == "?"
      #  $game_actors[actor.id].setup(actor.id)
      #end
      @self_face_x = 121
      @self_face_y = 40
      rect = Rect.new(@self_face_x, @self_face_y, 224, 253)
    end
    contents.blt(x, y, bitmap, rect, 255)
    bitmap = Cache.portrait("Actor-Portrait")
    rect = Rect.new(0, 0, bitmap.width, bitmap.height)
    contents.blt(x, y, bitmap, rect, 255)
    bitmap.dispose
  end
  
  def draw_actor_portrait3(actor, x, y, enabled = true)
    @ro_x = 481
    @ro_y = 75
    x = x - 8
    y = y + 20
    
    # 빙결, 석화 상태인지 확인, 행동불가인지 확인
    @ro_x -= 62 if actor.id == 7 and ($game_actors[7].state?(133) or $game_actors[7].state?(11))
    
    if actor.id == 7
      bitmap = Cache.picture($game_variables[443]) # 몸통
      rect = Rect.new(@ro_x, @ro_y, 125, Graphics.height * 0.55)
      contents.blt(x, y, bitmap, rect, 255)
      bitmap = Cache.picture($game_variables[444]) # 표정
      contents.blt(x, y, bitmap, rect, 255)
      bitmap = Cache.picture($game_variables[445]) # 성인용품
      contents.blt(x, y, bitmap, rect, 255)
      bitmap = Cache.picture($game_variables[446]) # 발그레
      contents.blt(x, y, bitmap, rect, 255)
      bitmap = Cache.picture($game_variables[447]) # 방어구
      contents.blt(x, y, bitmap, rect, 255)
    else
      filename = "Actor#{actor.id}"
      bitmap = Cache.face(filename)
      @self_face_x = 165
      @self_face_y = 30
      rect = Rect.new(@self_face_x, @self_face_y, 125, Graphics.height * 0.55)
      contents.blt(x, y, bitmap, rect, 255)
    end

    if Graphics.height == 640
      bitmap = Cache.picture("Actor_Skill_2")
    elsif Graphics.height == 704
      bitmap = Cache.picture("Actor_Skill_1")
    else
      bitmap = Cache.picture("Actor_Skill")
    end
    rect = Rect.new(0, 0, bitmap.width, bitmap.height)
    contents.blt(x-1, y-1, bitmap, rect, 255)
    bitmap.dispose
  end
  
  def draw_actor_portrait2(actor, x, y, enabled = true)
    draw_portrait2(actor, x, y, enabled)
    draw_portrait3(actor, 455, 0, enabled)
  end
  
  # 동료 목록에서 사용하는 부분
  def draw_actor_portrait4(actor, x, y, enabled = true)
    if actor != 99
      filename = "Actor#{actor.id}"
    else
      filename = "Actor-not-Portrait"
    end
    draw_portrait4(filename, x, y, actor, enabled)
  end
  
  alias :bm_base_dal :draw_actor_level
  def draw_actor_level(actor, x, y, width = 100)
    y = y - 15
    draw_gauge(x + 10, y, width - 10, exp_rate(actor), exp_gauge1, exp_gauge2) if BM::SHOW_EXP_GAUGE
    change_color(system_color)
    draw_text(x, y, 32, line_height, Vocab::level_a)
    change_color(normal_color)
    draw_text(x, y, width, line_height, actor.level.group, 2)
  end
  
  alias :bm_base_dap :draw_actor_param
  def draw_actor_param(actor, x, y, param_id, width = 156)
    if BM::SHOW_PARAM_GAUGE
      draw_gauge(x, y, width, param_ratio(actor, param_id), param_gauge1(param_id), param_gauge2(param_id))
    end
    change_color(system_color)
    draw_text(x, y, 120, line_height, Vocab::param(param_id))
    change_color(normal_color)
    draw_text(x, y, width, line_height, actor.param(param_id).group, 2)
  end
  
  def battle_party?(actor)
    if BM::NON_PARTY_MEMBER_TRANSPARENCY
      return $game_party.battle_members.include?(actor)
    else; true
    end
  end
  
  alias :bm_base_dan :draw_actor_name
  def draw_actor_name(*args)
    contents.font.bold = BM::TEXT[:bold][:actor_name]
    contents.font.italic = false
    bm_base_dan(*args)
    contents.font.bold = Font.default_bold
    contents.font.italic = false
  end
  
  alias :bm_base_dac :draw_actor_class
  def draw_actor_class(*args)
    contents.font.bold = BM::TEXT[:bold][:actor_class]
    contents.font.italic = false
    bm_base_dac(*args)
    contents.font.bold = Font.default_bold
    contents.font.italic = false
  end
  
  def game_time
    gametime = Graphics.frame_count / Graphics.frame_rate
    hours = gametime / 3600
    minutes = gametime / 60 % 60
    seconds = gametime % 60
    result = sprintf("%d : %02d : %02d", hours, minutes, seconds)
    return result
  end
  
  def draw_text_ex2(x, y, text)
    text = convert_escape_characters(text)
    pos = {:x => x, :y => y, :new_x => x, :height => calc_line_height(text)}
    process_character(text.slice!(0, 1), text, pos) until text.empty?
  end
  
  #--------------------------------------------------------------------------
  # ○ RP 문자색
  #--------------------------------------------------------------------------
  def rp_color(actor)
    return (actor.rp == 0 ? knockout_color : normal_color)
  end
  
  def rp_color2(actor)
    return (actor.skill_point == 0 ? knockout_color : normal_color)
  end
  
  #--------------------------------------------------------------------------
  # ○ 분배 게이지 색상 1 얻기
  #--------------------------------------------------------------------------
  def distribute_gauge_color1
    color = KMS_DistributeParameter::GAUGE_START_COLOR
    return (color.is_a?(Integer) ? text_color(color) : color)
  end
  
  #--------------------------------------------------------------------------
  # ○ 분배 게이지 색상 2 획득
  #--------------------------------------------------------------------------
  def distribute_gauge_color2
    color = KMS_DistributeParameter::GAUGE_END_COLOR
    return (color.is_a?(Integer) ? text_color(color) : color)
  end
  
  def draw_actor_rp(actor, x, y, width = 124)
    change_color(system_color)
    # 포인트 명칭 표시 실험
    #draw_text(x, y, 30, line_height, Vocab::rp_a)
    draw_text(x, y, width, line_height, Vocab::rp_a, 0)
    draw_current_and_max_values(x, y, width, actor.rp, actor.mrp, rp_color(actor), normal_color)
    change_color(normal_color)
  end
  
  def draw_actor_rp2(actor, x, y, width = 124)
    change_color(system_color)
    draw_text(x, y, width, line_height, Lang::TEXTS[:interface][:text_sp], 0)
    draw_current_and_max_values(x, y, width, actor.skill_point, actor.skill_point2, rp_color2(actor), normal_color)
    change_color(normal_color)
  end
  
  #--------------------------------------------------------------------------
  # ○ 분배 게이지 그리기
  #--------------------------------------------------------------------------
  def draw_actor_distribute_gauge(actor, param, x, y, width = 124)
    gain = actor.gain_parameter(param)
    return if gain == nil || gain.limit <= 0

    rate = actor.distributed_count(param) * 1.0 / gain.limit
    if $kms_imported["GenericGauge"] &&
        KMS_DistributeParameter::ENABLE_GENERIC_GAUGE
      # 범용 게이지
      draw_generic_gauge(KMS_DistributeParameter::GAUGE_IMAGE,
        x, y, width, rate,
        KMS_DistributeParameter::GAUGE_OFFSET,
        KMS_DistributeParameter::GAUGE_LENGTH,
        KMS_DistributeParameter::GAUGE_SLOPE)
    else
      # 기본 게이지
      gc1  = distribute_gauge_color1
      gc2  = distribute_gauge_color2
      draw_gauge(x, y, width, rate, gc1, gc2)
    end
  end
end