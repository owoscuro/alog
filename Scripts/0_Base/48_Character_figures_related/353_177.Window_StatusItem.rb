# encoding: utf-8
# Name: 177.Window_StatusItem
# Size: 22090
# encoding: utf-8
# Name: 177.Window_StatusItem
# Size: 21004
class Window_StatusItem < Window_Base
  #include BMCHART 
  alias :bm_status_init :initialize
  def initialize(*args)
    @page = {}
    bm_status_init(*args)
  end   
  
  def current_page  
    if @page[@command_window.current_symbol] == nil
      @page[@command_window.current_symbol] = 0
    end
    return @page[@command_window.current_symbol]
  end
  
  def new_page(symbol)
    if current_page >= 0 && current_page < BM::STATUS::TOGGLE_WINDOWS[symbol].size-1
      @page[symbol] += 1
    elsif current_page == BM::STATUS::TOGGLE_WINDOWS[symbol].size-1
      @page[symbol] = 0
    end
    refresh
  end
  
  alias :bm_status_dwc :draw_window_contents
  def draw_window_contents
    #chart_starter_visibility
    if BM::STATUS::TOGGLE_WINDOWS.include?(@command_window.current_symbol)
      page_name = BM::STATUS::TOGGLE_WINDOWS[@command_window.current_symbol][current_page]
      if BM::STATUS::PORTRAIT_BACKGROUND.include?(page_name)
        # 수정 추가 정보 보기 전용 이미지
        draw_actor_portrait2(@actor, -30, 10, false)
      end
      case page_name
      when :general       # 일반적인
        draw_actor_general
      when :parameters    # 매개변수
        draw_parameter_graph
      #when :properties
      #  draw_properties_list
      #when :biography, :rename, :retitle
      #  draw_actor_biography
      else
        draw_toggle_custom
      end
      dx = contents.width - 24; dy = contents.height - 24
      draw_icon(BM::STATUS::TOGGLE_ICON, dx, dy)
    else
      bm_status_dwc    
    end
  end
  
  def draw_toggle_custom
    current_symbol = BM::STATUS::TOGGLE_WINDOWS[@command_window.current_symbol][current_page]
    return unless YEA::STATUS::CUSTOM_STATUS_COMMANDS.include?(current_symbol)
    method(YEA::STATUS::CUSTOM_STATUS_COMMANDS[current_symbol][3]).call
  end
  
  def draw_actor_general
    reset_font_settings
    # 일반 정보 이미지 추가
    draw_portrait2(@actor, x-30, y-38, true)
    draw_actor_bmbiography2
    draw_general_parameters(0)
  end
  
  def draw_horz_line(y)
    line_y = y + line_height / 2 - 1
    contents.fill_rect(243, line_y, contents.width - 243, 2, line_color)
  end
  
  def line_color
    color = normal_color
    color.alpha = 48
    color
  end
  
  def draw_general_parameters(dx)
    # 일반 정보 탭의 능력치 정보창
    dy = 0
    dy2 = 0
    
    dx += 250
    dw = (Graphics.width - dx) / 3 - 17
    
    dx1 = dx + dw * 0
    dx2 = dx1 + dw + 6
    dx3 = dx2 + dw + 6
    
    draw_actor_level(dx + dw * 0, line_height * 0 + dy, dw)
    draw_actor_exp(dx + dw * 1 + 6, line_height * 0 + dy, (dw + 3)*2)
    draw_exp_gauge(dx + dw * 0, line_height * 0.7 + dy, (dw + 3)*3) if BM::STATUS::GAUGE[:exp]
    
    draw_actor_param(0, dx1, line_height * 2 + dy, dw)
    draw_gauge(dx1, line_height * 2.7 + dy, dw, @actor.hp_rate, hp_gauge_color1, hp_gauge_color2) if BM::STATUS::GAUGE[:hp]
    draw_actor_param(2, dx1, line_height * 4 + dy, dw)
    draw_gauge(dx1, line_height * 4.7 + dy, dw, param_ratio(@actor,2), param_gauge1(6), param_gauge2(6))
    draw_actor_param(3, dx1, line_height * 6 + dy, dw)
    draw_gauge(dx1, line_height * 6.7 + dy, dw, param_ratio(@actor,3), param_gauge1(6), param_gauge2(6))
    
    draw_actor_param(1, dx2, line_height * 2 + dy, dw)
    draw_gauge(dx2, line_height * 2.7 + dy, dw, @actor.mp_rate, mp_gauge_color1, mp_gauge_color2) if BM::STATUS::GAUGE[:mp]
    draw_actor_param(4, dx2, line_height * 4 + dy, dw)
    draw_gauge(dx2, line_height * 4.7 + dy, dw, param_ratio(@actor,4), param_gauge1(6), param_gauge2(6))
    draw_actor_param(5, dx2, line_height * 6 + dy, dw)
    draw_gauge(dx2, line_height * 6.7 + dy, dw, param_ratio(@actor,5), param_gauge1(6), param_gauge2(6))
    
    draw_actor_tp(@actor, dx3, line_height * 2 + dy, dw)
    draw_gauge(dx3, line_height * 2.7 + dy, dw, @actor.tp_rate, tp_gauge_color1, tp_gauge_color2) if BM::STATUS::GAUGE[:tp]
    draw_actor_param(6, dx3, line_height * 4 + dy, dw)
    draw_gauge(dx3, line_height * 4.7 + dy, dw, param_ratio(@actor,6), param_gauge1(6), param_gauge2(6))
    draw_actor_param(7, dx3, line_height * 6 + dy, dw)
    draw_gauge(dx3, line_height * 6.7 + dy, dw, param_ratio(@actor,7), param_gauge1(6), param_gauge2(6))
    
    # 가로선 추가 실험
    draw_horz_line(line_height * 8 + dy - 8)
    dy += 15
    
    # 가로선 추가 실험
    draw_horz_line(line_height * 16 + dy - 8)
    dy2 += dy + 15
    
    change_color(system_color)
    
    # draw_text(dx1, line_height * 8 + dy, dw, line_height, " 허기")
    # draw_text(dx2, line_height * 8 + dy, dw, line_height, " 갈증")
    # draw_text(dx3, line_height * 8 + dy, dw, line_height, " 피로")
    
    # draw_text(dx1, line_height * 10 + dy, dw, line_height, " 성욕")
    # draw_text(dx2, line_height * 10 + dy, dw, line_height, " 취기")
    # draw_text(dx3, line_height * 10 + dy, dw, line_height, " 위생")
    
    # draw_text(dx1, line_height * 12 + dy, dw, line_height, " 심신")
    # draw_text(dx2, line_height * 12 + dy, dw, line_height, " 감기 기운")
    
    # draw_text(dx1, line_height * 14 + dy, dw, line_height, " 더위")
    # draw_text(dx2, line_height * 14 + dy, dw, line_height, " 추위")
    
    # draw_text(dx1, line_height * 16 + dy2, dw, line_height, " 경건")
    # draw_text(dx2, line_height * 16 + dy2, dw, line_height, " 이동 속도")
    # draw_text(dx3, line_height * 16 + dy2, dw, line_height, " 평판")

    draw_text(dx1, line_height * 8 + dy, dw, line_height, "Hambre")
    draw_text(dx2, line_height * 8 + dy, dw, line_height, "Sed")
    draw_text(dx3, line_height * 8 + dy, dw, line_height, "Fatiga")

    draw_text(dx1, line_height * 10 + dy, dw, line_height, "Libido")
    draw_text(dx2, line_height * 10 + dy, dw, line_height, "Embriaguez")
    draw_text(dx3, line_height * 10 + dy, dw, line_height, "Higiene")

    draw_text(dx1, line_height * 12 + dy, dw, line_height, "Ment/Cuer")
    draw_text(dx2, line_height * 12 + dy, dw, line_height, "Resfrío")

    draw_text(dx1, line_height * 14 + dy, dw, line_height, "Calor")
    draw_text(dx2, line_height * 14 + dy, dw, line_height, "Frío")

    draw_text(dx1, line_height * 16 + dy2, dw, line_height, "Devoción")
    draw_text(dx2, line_height * 16 + dy2, dw, line_height, "Vel. Mov.")
    draw_text(dx3, line_height * 16 + dy2, dw, line_height, "Reputación")

    change_color(normal_color)
    
    draw_text(dx1, line_height * 8 + dy, dw, line_height, "#{@actor.hunger_rate}"+'%', 2)
    draw_gauge(dx1, line_height * 8.7 + dy, dw, @actor.hunger_rate * 0.01, param_gauge1(3), param_gauge2(3))
    draw_text(dx2, line_height * 8 + dy, dw, line_height, "#{@actor.thirst_rate}"+'%', 2)
    draw_gauge(dx2, line_height * 8.7 + dy, dw, @actor.thirst_rate * 0.01, param_gauge1(3), param_gauge2(3))
    draw_text(dx3, line_height * 8 + dy, dw, line_height, "#{@actor.sleep_rate}"+'%', 2)
    draw_gauge(dx3, line_height * 8.7 + dy, dw, @actor.sleep_rate * 0.01, param_gauge1(3), param_gauge2(3))
    
    draw_text(dx1, line_height * 10 + dy, dw, line_height, "#{@actor.sexual_rate}"+'%', 2)
    draw_gauge(dx1, line_height * 10.7 + dy, dw, @actor.sexual_rate * 0.01, param_gauge1(3), param_gauge2(3))
    draw_text(dx2, line_height * 10 + dy, dw, line_height, "#{@actor.drunk_rate}"+'%', 2)
    draw_gauge(dx2, line_height * 10.7 + dy, dw, @actor.drunk_rate * 0.01, param_gauge1(3), param_gauge2(3))
    draw_text(dx3, line_height * 10 + dy, dw, line_height, "#{@actor.hygiene_rate}"+'%', 2)
    draw_gauge(dx3, line_height * 10.7 + dy, dw, @actor.hygiene_rate * 0.01, param_gauge1(3), param_gauge2(3))
    
    draw_text(dx1, line_height * 12 + dy, dw, line_height, "#{@actor.stress_rate}"+'%', 2)
    draw_gauge(dx1, line_height * 12.7 + dy, dw, @actor.stress_rate * 0.01, param_gauge1(3), param_gauge2(3))
    draw_text(dx2, line_height * 12 + dy, dw, line_height, "#{@actor.cold_rate}"+'%', 2)
    draw_gauge(dx2, line_height * 12.7 + dy, dw, @actor.cold_rate * 0.01, param_gauge1(3), param_gauge2(3))
    
    draw_text(dx1, line_height * 14 + dy, dw, line_height, "#{[0, @actor.temper.round-50].max}"+'%', 2)
    draw_gauge(dx1, line_height * 14.7 + dy, dw, (@actor.temper-50) * 0.01, param_gauge1(3), param_gauge2(3))
    draw_text(dx2, line_height * 14 + dy, dw, line_height, "#{[0, 50-@actor.temper.round].max}"+'%', 2)
    draw_gauge(dx2, line_height * 14.7 + dy, dw, (50-@actor.temper) * 0.01, param_gauge1(3), param_gauge2(3))
    
    draw_text(dx1, line_height * 16 + dy2, dw, line_height, "#{@actor.piety_rate}"+'%', 2)
    draw_gauge(dx1, line_height * 16.7 + dy2, dw, @actor.piety_rate * 0.01, param_gauge1(6), param_gauge2(6))
    draw_text(dx2, line_height * 16 + dy2, dw, line_height, "#{(((@actor.atk_times_add + 1) * 100).to_i)}"+'%', 2)
    draw_gauge(dx2, line_height * 16.7 + dy2, dw, (((@actor.atk_times_add + 1) * 100)/100).to_f, param_gauge1(6), param_gauge2(6))
    draw_text(dx3, line_height * 16 + dy2, dw, line_height, "#{@actor.repute_rate.to_i}"+'%', 2)
    draw_gauge(dx3, line_height * 16.7 + dy2, dw, @actor.repute_rate * 0.01, param_gauge1(6), param_gauge2(6))
  end
  
  def draw_exp_gauge(x, y, width = 124)
    draw_gauge(x, y, width, exp_rate(@actor), exp_gauge1, exp_gauge2)
  end
  
  def draw_actor_tp(actor, x, y, width = 124)
    change_color(system_color)
    draw_text(x+4, y, width-8, line_height, Vocab::tp)
    change_color(normal_color)
    draw_text(x+4, y, width-8, line_height, actor.tp.to_i, 2)
  end
  
  def draw_actor_exp(dx, dy, dw, width = 124)
    change_color(system_color)
    # draw_text(dx + 4, dy, dw - 8, line_height, "#{Vocab.exp} 필요")
    draw_text(dx + 4, dy, dw - 8, line_height, "#{Vocab.exp} necesario")

    s2 = @actor.max_level? ? "　" : @actor.next_level_exp - @actor.exp
    change_color(normal_color)
    draw_text(dx + 4, dy, dw - 8, line_height, s2, 2)
  end
  
  def draw_parameter_graph
    draw_parameter_title
    type = BM::STATUS::INFO_STYLE[:param]
    draw_actor_chart_and_numbers(0, line_height * 3 / 2, :param, :both, type)
  end
  
  def draw_parameter_title
    contents.font.bold = true
    change_color(system_color)
    text = YEA::STATUS::PARAMETERS_VOCAB
    draw_text(0, 0, contents.width, line_height, text, 1)
    reset_font_settings
  end
  
  def draw_properties_column1
    dx = 7
    dw = (contents.width - 7) / 4 - 7
    dy = 0
    for property in YEA::STATUS::PROPERTIES_COLUMN1
      dy = draw_property(property[0], dx, dy, dw)
    end
  end
  
  def draw_properties_column2
    dw = (Graphics.width - 250) / 3 - 10
    dx = 250
    dy = 0
    for property in YEA::STATUS::PROPERTIES_COLUMN2
      dy = draw_property(property[0], dx, dy, dw)
    end
  end
  
  def draw_properties_column3
    dw = (Graphics.width - 250) / 3 - 10
    dx = 250
    dx += dw
    dy = 0
    for property in YEA::STATUS::PROPERTIES_COLUMN3
      dy = draw_property(property[0], dx, dy, dw)
    end
  end
  
  def draw_properties_column4
    dw = (Graphics.width - 250) / 3 - 10
    dx = 250
    dx += dw * 2
    dy = 0
    for property in YEA::STATUS::PROPERTIES_COLUMN4
      dy = draw_property(property[0], dx, dy, dw)
    end
  end
  
  def graph_values(chart,id)
    n = 0
    case chart
    when :element
      n    = eval("(@actor.#{chart}_rate(#{id})*100).to_i")
      if $imported["YEA-ElementReflect"] && @actor.element_reflect_rate(id) != 0
        n = -(@actor.element_reflect_rate(id) * 100).to_i
      elsif $imported["Elemental_Modifiers"]
        n  = (@actor.element_resist_rate(id) * 100).to_i 
      end
    end
    return n
  end
  
  def draw_property(property, dx, dy, dw)
    case property
    when :el_3;  text2 = Vocab.sparam_f(property); value = 1 - (graph_values(:element,3) * 0.01);
    when :el_4;  text2 = Vocab.sparam_f(property); value = 1 - (graph_values(:element,4) * 0.01);
    when :el_5;  text2 = Vocab.sparam_f(property); value = 1 - (graph_values(:element,5) * 0.01);
    when :el_6;  text2 = Vocab.sparam_f(property); value = 1 - (graph_values(:element,6) * 0.01);
    when :el_7;  text2 = Vocab.sparam_f(property); value = 1 - (graph_values(:element,7) * 0.01);
    when :el_8;  text2 = Vocab.sparam_f(property); value = 1 - (graph_values(:element,8) * 0.01);
    when :el_9;  text2 = Vocab.sparam_f(property); value = 1 - (graph_values(:element,9) * 0.01);
    when :el_10; text2 = Vocab.sparam_f(property); value = 1 - (graph_values(:element,10) * 0.01);
    when :el_12; text2 = Vocab.sparam_f(property); value = 1 - (graph_values(:element,12) * 0.01);
    when :hit, :eva, :cri, :cev, :mev, :mrf, :cnt, :hrg, :mrg, :trg, :repute
      text1 = Vocab.xparam_a(property)
      text2 = Vocab.xparam_f(property)
      if property == :repute
        value = @actor.repute.to_f
      else
        value = eval("@actor.#{property}")
      end
    when :sexual
      text1 = Vocab.xparam_a(property)
      text2 = Vocab.xparam_f(property)
      value = @actor.sexual.to_f / @actor.sexual_max * 100
    when :piety
      text1 = Vocab.xparam_a(property)
      text2 = Vocab.xparam_f(property)
      value = @actor.piety.to_f / @actor.piety_max * 100
    when :atk_lk, :aps, :grd, :rec, :mcr, :tcr, :pdr, :mdr, :fdr, :exr, :rose_gold1, :rose_gold2, :rose_life, :rose_costume, :rose_costume2
      text1 = Vocab.sparam_a(property)
      text2 = Vocab.sparam_f(property)
      if property == :atk_lk
        value = (@actor.atk_lk + (@actor.luk * 0.001)).to_f
      elsif property == :rose_life
        value = $game_party.checkpoint_life
      elsif property == :rose_costume
        value = $game_variables[118].to_f / 100
      elsif property == :rose_costume2
        value = $game_player.move_speed.to_f / 4
      elsif property == :rose_gold1
        value = $game_variables[284].to_f / 100
      elsif property == :rose_gold2
        value = $game_variables[285].to_f / 100
      elsif property == :aps
        value = @actor.action_plus_set2.to_f * 10
      else
        value = eval("@actor.#{property}")
      end
    # 쿨타임 감소 실험
    when :pha
      text1 = Vocab.sparam_a(property)
      text2 = Vocab.sparam_f(property)
      value = (@actor.atk_speed - @actor.pha) * -1
    when :tgr
      text1 = Vocab.sparam_a(property)
      text2 = Vocab.sparam_f(property)
      value = @actor.tgr * 100
    when :hunger_max
      text1 = Vocab.sparam_a(property)
      text2 = Vocab.sparam_f(property)
      value = @actor.hunger.to_f / @actor.hunger_max * 100
    when :thirst_max
      text1 = Vocab.sparam_a(property)
      text2 = Vocab.sparam_f(property)
      value = @actor.thirst.to_f / @actor.thirst_max * 100
    when :sleep_max
      text1 = Vocab.sparam_a(property)
      text2 = Vocab.sparam_f(property)
      value = @actor.sleep.to_f / @actor.sleep_max * 100
    when :hygiene_max
      text1 = Vocab.sparam_a(property)
      text2 = Vocab.sparam_f(property)
      value = @actor.hygiene.to_f / @actor.hygiene_max * 100
    when :stress_max
      text1 = Vocab.sparam_a(property)
      text2 = Vocab.sparam_f(property)
      value = @actor.stress.to_f / @actor.stress_max * 100
    when :gut
      return dy unless $imported["BubsGuts"]
      text1 = Vocab.cparam_a(property)
      text2 = Vocab.cparam_f(property)
      value = eval("@actor.#{property}/@actor.#{property}_max")
    when :hcr, :tcr_y, :gcr
      return dy unless $imported["YEA-SkillCostManager"]
      text1 = Vocab.cparam_a(property)
      text2 = Vocab.cparam_f(property)
      value = eval("@actor.#{property}")
    when :cdr, :wur
      return dy unless $imported["YEA-SkillRestrictions"]
      text1 = Vocab.cparam_a(property)
      text2 = Vocab.cparam_f(property)
      value = eval("@actor.#{property}")
    when :hp_physical, :mp_physical, :hp_magical, :mp_magical
      return dy unless $imported["YEA-ConvertDamage"]
      text1 = Vocab.cparam_a(property)
      text2 = Vocab.cparam_f(property)
      value = @actor.convert_dmg_rate(property)
    when :blank; return dy + line_height
    when :hblank; return dy + line_height/2
    else; return dy
    end
    
    if value != nil
      if property != :aps and property != :tgr and property != :pha and property != :piety and property != :sexual and property != :hunger_max and property != :thirst_max and property != :sleep_max and property != :hygiene_max and property != :stress_max
        if property != :rose_life and property != :repute
          value = sprintf("%1.1f%%", value * 100)
        else
          value = sprintf("%d개", value) if property == :rose_life
          value = sprintf("%d점", value) if property == :repute
        end
      else
        value = sprintf("%1.1f%%", value)
      end
    end

    change_color(system_color)
    cw = text_size("100.0%").width
    
    if Graphics.height == 544
      contents.font.size = BM::STATUS::BIO_FONT_SIZE - 1
    elsif Graphics.height == 640
      contents.font.size = BM::STATUS::BIO_FONT_SIZE
    elsif Graphics.height == 704
      contents.font.size = BM::STATUS::BIO_FONT_SIZE + 1
    else
      contents.font.size = BM::STATUS::BIO_FONT_SIZE - 1
    end
        
    if BM::STATUS::PROPERTIES_FULL_NAME
      draw_text(dx+4, dy, dw-cw, line_height, text2, 0)
    else
      draw_text(dx+4, dy-2, dw-cw, line_height, text1, 0)
    end
    change_color(normal_color)
    # 상세 정보 능력치 수치
    draw_text(dx + 4-4, dy+1, dw - 8, line_height, value, 2)
    return dy + line_height
  end
  
  def draw_actor_nickname
    contents.font.bold = true
    fmt = YEA::STATUS::BIOGRAPHY_NICKNAME_TEXT
    text = sprintf(fmt, @actor.name, @actor.nickname)
    contents.font.size = YEA::STATUS::BIOGRAPHY_NICKNAME_SIZE
    draw_text(0, 0, contents.width, line_height*2, text, 1)
  end
  
  def draw_actor_yeabiography    
    draw_actor_nickname
    reset_font_settings
    x = 24; y = line_height * 2
    draw_text_ex(x, y, @actor.description)
  end
  
  def draw_actor_bmbiography2
    # 인물 이름 표기
    reset_font_settings
    y = Graphics.height - 259
    contents.font.size = BM::STATUS::BIO_FONT_SIZE
    bio_info_list = BM::STATUS::BIO_INFO
    bio_info_list = BM::STATUS::ACTOR_BIO_INFO[@actor.id] if BM::STATUS::ACTOR_BIO_INFO.include?(@actor.id)
    # 인물 상세 정보
    for id in bio_info_list
      if y + line_height > contents.height
      else
        contents.font.bold = true
        contents.font.size = 24
        y = draw_actor_bio_info(id, 20, y, 200)
      end
    end
    reset_font_settings
  end
  
  def draw_actor_bmbiography
    # 인물 이름 표기
    reset_font_settings
    y = Graphics.height - 259
    y2 = 2
    contents.font.size = BM::STATUS::BIO_FONT_SIZE
    bio_info_list = BM::STATUS::BIO_INFO
    bio_info_list = BM::STATUS::ACTOR_BIO_INFO[@actor.id] if BM::STATUS::ACTOR_BIO_INFO.include?(@actor.id)
    # 인물 상세 정보
    for id in bio_info_list
      if y + line_height > contents.height
        contents.font.bold = false
        if Graphics.height == 544
          contents.font.size = BM::STATUS::BIO_FONT_SIZE - 1
          y2 = draw_actor_bio_info(id, 247, y2, 200)
        elsif Graphics.height == 640
          contents.font.size = BM::STATUS::BIO_FONT_SIZE + 1
          y2 = draw_actor_bio_info(id, 247, y2, 230)
        elsif Graphics.height == 704
          contents.font.size = BM::STATUS::BIO_FONT_SIZE + 1
          y2 = draw_actor_bio_info(id, 247, y2, 230)
        else
          contents.font.size = BM::STATUS::BIO_FONT_SIZE - 1
          y2 = draw_actor_bio_info(id, 247, y2, 200)
        end
      else
        contents.font.bold = true
        contents.font.size = 24
        y = draw_actor_bio_info(id, 20, y, 200)
      end
    end
    reset_font_settings
  end 
  
  def draw_actor_bio_info(id, x, y, width = 100)
    case id
    when :blank; return y + (line_height/2)
    when :hblank; return dy + line_height/2
    when :align
      text1 = BM::STATUS::BIO_INFO_TEXT[id]
      text2 = @actor.name
      text_co = text_color(0)
    when :age, :birthplace, :height, :nickname
    text1 = BM::STATUS::BIO_INFO_TEXT[id]
    text2 = eval("@actor.#{id}")
    text_co = text_color(0)
    if text1 == "Edad" and text2 == "0 años"
      text2 = "??? años"
    end
    else
      return y unless BM::STATUS::CBIO_INFO_TEXT.include?(id)
      text1 = BM::STATUS::CBIO_INFO_TEXT[id]
      text2 = eval("@actor.#{id}")
      if text1 == "Tiempo de Contrato Restante"
        text2 = sprintf("%s horas", text2)
      elsif text1 == "Peso"
        text2 = sprintf("%s kg", text2)
      elsif text1 == "Afinidad"
        text2 = sprintf("%s puntos", text2)
      elsif text1 == "Padre"
        text2 = "Desconocido" if text2 == 0
      elsif text1 == "Madre"
        text2 = $game_actors[7].name.to_s if text2 == 0
      elsif text1 != "Raza" and text1 != "Virginidad" and text1 != "Precio por Día"
        text2 = sprintf("%s veces", text2)
      end
      if text1 != "Raza" and text1 != "Peso" and text1 != "Virginidad"
        text_co = system_color
      else
        text_co = text_color(0)
      end
      text2 = 0 if text2 == nil
    end
    cw = text_size(text1).width
    change_color(text_co)
    draw_text(x+3, y-2, width, line_height, text1, 0)
    change_color(normal_color)
    if text1 != "Precio por Día"
      draw_text(x + cw-3, y-2, width-cw, line_height, text2, 2)
    else
      if text2.to_i >= 1
        y += line_height
        draw_currency_value(text2, "", x + cw-3, y-2, width-cw, 4)
      else
        draw_text(x + cw-3, y-2, width-cw, line_height, "??", 2)
      end
    end
    return y + line_height
  end
end