# encoding: utf-8
# Name: 073.YEA, STATUS
# Size: 18024
# encoding: utf-8
# Name: 073.YEA, STATUS
# Size: 16190
$imported = {} if $imported.nil?
$imported["YEA-StatusMenu"] = true

module YEA
  module STATUS
    COMMANDS =[
      [    :general, "Información general"],
      [ :properties, "Información detallada"],
      [  :biography, "Información personal"],
    ]

    
    CUSTOM_STATUS_COMMANDS ={
    # :command => [EnableSwitch, ShowSwitch, Handler Method, Window Draw],
      :custom1 => [           0,          0, :command_name1, :draw_custom1],
      :custom2 => [           0,          0, :command_name2, :draw_custom2],
      :custom3 => [           0,          0, :command_name3, :draw_custom3],
    }
    
    # PARAMETERS_VOCAB = "일반 정보"
    # EXPERIENCE_VOCAB = "경험"
    # NEXT_TOTAL_VOCAB = "다음 %s, 필요 총 경험치"
    PARAMETERS_VOCAB = "Información general"
    EXPERIENCE_VOCAB = "Experiencia"
    NEXT_TOTAL_VOCAB = "Total de experiencia necesario para el próximo %s"

    
    # 일반 정보 탭의 능력치 정보창
    PARAM_COLOUR ={
    # ParamID => [:stat,       Colour1,                   Colour2          ],
            2 => [ :atk, Color.new(225, 100, 100), Color.new(240, 150, 150)],
            3 => [ :def, Color.new(250, 150,  30), Color.new(250, 180, 100)],
            4 => [ :mat, Color.new( 70, 140, 200), Color.new(135, 180, 230)],
            5 => [ :mdf, Color.new(135, 130, 190), Color.new(170, 160, 220)],
            6 => [ :agi, Color.new( 60, 180,  80), Color.new(120, 200, 120)],
            7 => [ :luk, Color.new(255, 240, 100), Color.new(255, 250, 200)],
    }
    
    PROPERTIES_FONT_SIZE = 18
    
    # # 이들은 0 열에 나타나는 속성입니다.
    # PROPERTIES_COLUMN1 =[
    #   [:hrg, "HP 회복력"], [:mrg, "MP 회복력"],
    #   [:mcr, "MP 소모 비율"], [:trg, "TP 회복력"],
    #   [:tcr, "TP 충전 비율"], [:rec, "회복 비율"],
    #   [:tgr, "Poción 효율"],
    # ]
    
    # # 이들은 1 열에 나타나는 속성입니다.
    # PROPERTIES_COLUMN2 =[
    #   [:hrg, "HP 회복력"], [:mrg, "MP 회복력"],
    #   [:mcr, "MP 소모 비율"], [:trg, "TP 회복력"],
    #   [:tcr, "TP 충전 비율"], [:rec, "회복 비율"],
    #   [:tgr, "Poción 효율"], [:pdr, "물리 공격력"],
    #   [:cnt, "반격 확률"], [:mdr, "마법 공격력"],
    #   [:mrf, "마법 효율"], [:hit, "적중률"],
    #   [:atk_lk, "치명타 공격 비율"], [:cri, "치명타 확률"],
    #   [:eva, "회피율"], [:cev, "치명타 회피율"],
    #   [:mev, "마법 회피율"], [:grd, "방어 비율"],
    #   [:pha, "쿨타임 감소"],
    # ]
    
    # # 이들은 2 열에 나타나는 속성입니다.
    # PROPERTIES_COLUMN3 =[
    #   [:exr, "경험치 획득 비율"], [:rose_gold1, "구매 가격 비율"],
    #   [:rose_gold2, "판매 가격 비율"], [:aps, "넉백 무시 확률"],
    #   [:fdr, "지형 저항력"],
    # ]
    
    # # 이들은 3 열에 나타나는 속성입니다.
    # PROPERTIES_COLUMN4 =[
    #   [:el_3, "화속성"], [:el_4, "빙속성"],
    #   [:el_5, "뇌속성"], [:el_6, "수속성"],
    #   [:el_7, "지속성"], [:el_8, "풍속성"],
    #   [:el_9, "성속성"], [:el_10, "암속성"],
    #   [:el_12, "독속성"],
    # ]

    # Estas son las propiedades que aparecen en la columna 0.
    PROPERTIES_COLUMN1 =[
      [:hrg, "Rec HP"], [:mrg, "Rec MP"],
      [:mcr, "Cons MP"], [:trg, "Rec TP"],
      [:tcr, "Carga TP"], [:rec, "Recuperación"],
      [:tgr, "Eficiencia Poción"],
    ]

    # Estas son las propiedades que aparecen en la columna 1.
    PROPERTIES_COLUMN2 =[
      [:hrg, "Rec HP"], [:mrg, "Rec MP"],
      [:mcr, "Cons MP"], [:trg, "Rec TP"],
      [:tcr, "Carga TP"], [:rec, "Recuperación"],
      [:tgr, "Eficiencia Poción"], [:pdr, "Poder Atq Fís"],
      [:cnt, "Contraataque"], [:mdr, "Poder Atq Mág"],
      [:mrf, "Eficiencia Mág"], [:hit, "Precisión"],
      [:atk_lk, "Atq Crítico"], [:cri, "Prob Crítico"],
      [:eva, "Evadir"], [:cev, "Evitar Crítico"],
      [:mev, "Evitar Magia"], [:grd, "Defensa"],
      [:pha, "Reducir Cooldown"],
    ]

    # Estas son las propiedades que aparecen en la columna 2.
    PROPERTIES_COLUMN3 =[
      [:exr, "Obt Exp"], [:rose_gold1, "Tasa Compra"],
      [:rose_gold2, "Tasa Venta"], [:aps, "Evitar Empujones"],
      [:fdr, "Resistencia Terreno"],
    ]

    # Estas son las propiedades que aparecen en la columna 3.
    PROPERTIES_COLUMN4 =[
      [:el_3, "Elemento Fuego"], [:el_4, "Elemento Hielo"],
      [:el_5, "Elemento Rayo"], [:el_6, "Elemento Agua"],
      [:el_7, "Elemento Tierra"], [:el_8, "Elemento Viento"],
      [:el_9, "Elemento Luz"], [:el_10, "Elemento Oscuridad"],
      [:el_12, "Elemento Veneno"],
    ]

    BIOGRAPHY_NICKNAME_TEXT = "%s"
    BIOGRAPHY_NICKNAME_SIZE = 24
  end
end

class Window_StatusItem < Window_Base
  def initialize(dx, dy, command_window)
    super(dx, dy, Graphics.width, Graphics.height - dy)
    @command_window = command_window
    @actor = nil
    refresh
  end
  
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
  end
  
  def refresh
    contents.clear
    reset_font_settings
    return unless @actor
    draw_window_contents
  end
  
  def draw_window_contents
    case @command_window.current_symbol
    when :general
      draw_actor_general
    when :parameters
      draw_parameter_graph
    when :properties
      draw_properties_list
    else
      draw_custom
    end
  end
  
  def draw_actor_general
    draw_general_parameters
    draw_general_experience
  end

  def draw_general_parameters
    dx = 24
    dy = line_height / 2
    draw_actor_level(dx, line_height*1+dy, contents.width/2 - 24)
    draw_actor_param(0, dx, line_height*2+dy, contents.width/2 - 24)
    draw_actor_param(1, dx, line_height*3+dy, contents.width/2 - 24)
    draw_actor_param(2, dx, line_height*4+dy, contents.width/4 - 12)
    draw_actor_param(4, dx, line_height*5+dy, contents.width/4 - 12)
    draw_actor_param(6, dx, line_height*6+dy, contents.width/4 - 12)
    dx += contents.width/4 - 12
    draw_actor_param(3, dx, line_height*4+dy, contents.width/4 - 12)
    draw_actor_param(5, dx, line_height*5+dy, contents.width/4 - 12)
    draw_actor_param(7, dx, line_height*6+dy, contents.width/4 - 12)
  end
  
  def draw_actor_level(dx, dy, dw)
    change_color(system_color)
    draw_text(dx+4, dy, dw-8, line_height, Vocab::level)
    change_color(normal_color)
    draw_text(dx+4, dy, dw-8, line_height, @actor.level.group, 2)
  end
  
  def draw_actor_param(param_id, dx, dy, dw)
    change_color(system_color)
    draw_text(dx+4, dy, dw-8, line_height, Vocab::param(param_id))
    change_color(normal_color)
    draw_text(dx+4, dy, dw-8, line_height, @actor.param(param_id).group, 2)
  end
  
  def draw_general_experience
    if @actor.max_level?
      s1 = @actor.exp.group
      s2 = "?"
      s3 = "?"
    else
      s1 = @actor.exp.group
      s2 = (@actor.next_level_exp - @actor.exp).group
      s3 = @actor.next_level_exp.group
    end
    s_next = sprintf(Vocab::ExpNext, Vocab::level)
    total_next_text = sprintf(YEA::STATUS::NEXT_TOTAL_VOCAB, Vocab::level)
    change_color(system_color)
    dx = contents.width/2 + 12
    dy = line_height * 3 / 2
    dw = contents.width/2 - 36
    draw_text(dx, dy + line_height * 0, dw, line_height, Vocab::ExpTotal)
    draw_text(dx, dy + line_height * 2, dw, line_height, s_next)
    draw_text(dx, dy + line_height * 4, dw, line_height, total_next_text)
    change_color(normal_color)
    draw_text(dx, dy + line_height * 1, dw, line_height, s1, 2)
    draw_text(dx, dy + line_height * 3, dw, line_height, s2, 2)
    draw_text(dx, dy + line_height * 5, dw, line_height, s3, 2)
  end
  
  def draw_parameter_graph
    draw_parameter_title
    dy = line_height * 3/2
    maximum = 1
    minimum = @actor.param_max(2)
    for i in 2..7
      maximum = [@actor.param(i), maximum].max
      minimum = [@actor.param(i), minimum].min
    end
    maximum += minimum * 0.33 unless maximum == minimum
    for i in 2..7
      rate = calculate_rate(maximum, minimum, i)
      dy = line_height * i - line_height/2
      draw_param_gauge(i, dy, rate)
      change_color(system_color)
      draw_text(28, dy, contents.width - 56, line_height, Vocab::param(i))
      dw = (contents.width - 48) * rate - 8
      change_color(normal_color)
      draw_text(28, dy, dw, line_height, @actor.param(i).group, 2)
    end
  end
  
  #-----------------------------------------------------------------------------
  # 속도 계산
  #-----------------------------------------------------------------------------
  def calculate_rate(maximum, minimum, param_id)
    return 1.0 if maximum == minimum
    rate = (@actor.param(param_id).to_f - minimum) / (maximum - minimum).to_f
    rate *= 0.67
    rate += 0.33
    return rate
  end
  
  def draw_param_gauge(param_id, dy, rate)
    dw = contents.width - 48
    colour1 = param_gauge1(param_id)
    colour2 = param_gauge2(param_id)
    draw_gauge(24, dy, dw, rate, colour1, colour2)
  end
  
  def param_gauge1(param_id)
    return YEA::STATUS::PARAM_COLOUR[param_id][1]
  end
  
  def param_gauge2(param_id)
    return YEA::STATUS::PARAM_COLOUR[param_id][2]
  end
  
  def draw_parameter_title
    change_color(system_color)
    text = YEA::STATUS::PARAMETERS_VOCAB
    draw_text(0, line_height/3, contents.width, line_height, text, 1)
  end
  
  def draw_properties_list
    contents.font.size = YEA::STATUS::PROPERTIES_FONT_SIZE
    draw_properties_column2
    draw_properties_column3
    draw_properties_column4
    draw_portrait2(@actor, x-30, y-38, true)
    draw_actor_bmbiography2
    reset_font_settings
  end
  
  def draw_properties_column1
    dw = (Graphics.width - 227) / 3 - 25
    dx = 227
    dy = 0
    for property in YEA::STATUS::PROPERTIES_COLUMN1
      dy = draw_property(property, dx, dy, dw)
    end
  end
  
  def draw_properties_column2
    dw = (Graphics.width - 227) / 3 - 25
    dx = 227
    dy = 0
    for property in YEA::STATUS::PROPERTIES_COLUMN2
      dy = draw_property(property, dx, dy, dw)
    end
  end
  
  def draw_properties_column3
    dw = (Graphics.width - 227) / 3 - 25
    dx = 227 + dw
    dy = 0
    for property in YEA::STATUS::PROPERTIES_COLUMN3
      dy = draw_property(property, dx, dy, dw)
    end
  end
  
  def draw_properties_column4
    dw = (Graphics.width - 227) / 3 - 25
    dx = 227 + (dw * 2)
    dy = 0
    for property in YEA::STATUS::PROPERTIES_COLUMN4
      dy = draw_property(property, dx, dy, dw)
    end
  end
  
  def draw_property(property, dx, dy, dw)
    fmt = "%1.2f%%"
    case property[0]
    when :hit
      value = sprintf(fmt, @actor.hit * 100)
    when :eva
      value = sprintf(fmt, @actor.eva * 100)
    when :cri
      value = sprintf(fmt, @actor.cri * 100)
    when :cev
      value = sprintf(fmt, @actor.cev * 100)
    when :mev
      value = sprintf(fmt, @actor.mev * 100)
    when :mrf
      value = sprintf(fmt, @actor.mrf * 100)
    when :cnt
      value = sprintf(fmt, @actor.cnt * 100)
    when :hrg
      value = sprintf(fmt, @actor.hrg * 100)
    when :mrg
      value = sprintf(fmt, @actor.mrg * 100)
    when :trg
      value = sprintf(fmt, @actor.trg * 100)
    when :tgr # 약물 효과
      value = sprintf(fmt, @actor.pha * 100)
    when :grd
      value = sprintf(fmt, @actor.grd * 100)
    when :rec
      value = sprintf(fmt, @actor.rec * 100)
    when :pha # 도구 속도를 공격 속도(쿨타임 감소)로 변경
      value = 0
    when :mcr
      value = sprintf(fmt, @actor.mcr * 100)
    when :tcr
      value = sprintf(fmt, @actor.tcr * 100)
    when :pdr
      value = sprintf(fmt, @actor.pdr * 100)
    when :mdr
      value = sprintf(fmt, @actor.mdr * 100)
    when :fdr
      value = sprintf(fmt, @actor.fdr * 100)
    when :exr
      value = sprintf(fmt, @actor.exr * 100)
    when :rose_costume      # 에르니 의상 내구도
      value = $game_variables[118]
    when :rose_costume2     # 이동 속도
      value = $game_player.move_speed
    when :rose_life         # 에르니 목숨 표시
      value = $game_party.checkpoint_life
    when :rose_gold1        # 평판에 따른 세율
      value = $game_variables[284]
    when :rose_gold2
      value = $game_variables[285]
    when :aps
      value = sprintf(fmt, @actor.action_plus_set2 * 100)
    when :atk_lk            # 치명타 공격 비율
      value = sprintf(fmt, (@actor.atk_lk + (@actor.luk * 0.01)) * 100)
    when :repute
      value = @actor.repute # 평판 실험
    when :sexual
      value = @actor.sexual # 성욕 실험
    when :piety
      value = @actor.piety  # 경건 실험
    when :hunger_max
      value = sprintf(fmt, @actor.hunger_max)
    when :thirst_max
      value = sprintf(fmt, @actor.thirst_max)
    when :sleep_max
      value = sprintf(fmt, @actor.sleep_max)
    when :hygiene_max
      value = sprintf(fmt, @actor.hygiene_max)
    when :stress_max
      value = sprintf(fmt, @actor.stress_max)
    when :hcr
      return dy unless $imported["YEA-SkillCostManager"]
      value = sprintf(fmt, @actor.hcr * 100)
    when :tcr_y
      return dy unless $imported["YEA-SkillCostManager"]
      value = sprintf(fmt, @actor.tcr_y * 100)
    when :gcr
      return dy unless $imported["YEA-SkillCostManager"]
      value = sprintf(fmt, @actor.gcr * 100)
    when :cdr
      return dy unless $imported["YEA-SkillRestrictions"]
      value = sprintf(fmt, @actor.cdr * 100)
    when :wur
      return dy unless $imported["YEA-SkillRestrictions"]
      value = sprintf(fmt, @actor.wur * 100)
    else; return dy
    end
    change_color(system_color)
    draw_text(dx+4, dy, dw-8, line_height, property[1], 0)
    change_color(normal_color)
    draw_text(dx+4, dy, dw-8, line_height, value, 2)
    return dy + line_height
  end
  
  def draw_custom
    current_symbol = @command_window.current_symbol
    return unless YEA::STATUS::CUSTOM_STATUS_COMMANDS.include?(current_symbol)
    method(YEA::STATUS::CUSTOM_STATUS_COMMANDS[current_symbol][3]).call
  end
  
  def draw_custom1
    dx = 0; dy = 0
    for skill in @actor.skills
      next if skill.nil?
      next unless @actor.added_skill_types.include?(skill.stype_id)
      draw_item_name(skill, dx, dy)
      dx = dx == contents.width / 2 + 16 ? 0 : contents.width / 2 + 16
      dy += line_height if dx == 0
      return if dy + line_height > contents.height
    end
  end
  
  def draw_custom2
    dx = 4; dy = 0; slot_id = 0
    for equip in @actor.equips
      change_color(system_color)
      text = Vocab.etype(@actor.equip_slots[slot_id])
      draw_text(dx, dy, contents.width - dx, line_height, text)
      reset_font_settings
      draw_item_name(equip, dx+92, dy) unless equip.nil?
      slot_id += 1
      dy += line_height
      break if dy + line_height > contents.height
    end
    dw = Graphics.width * 2 / 5 - 24
    dx = contents.width - dw; dy = 0
    param_id = 0
    8.times do
      size = $imported["YEA-AceEquipEngine"] ? YEA::EQUIP::STATUS_FONT_SIZE : 20
      contents.font.size = size
      change_color(system_color)
      draw_text(dx+4, dy, dw, line_height, Vocab::param(param_id))
      change_color(normal_color)
      dwa = (Graphics.width * 2 / 5 - 2) / 2
      draw_text(dx, dy, dwa, line_height, @actor.param(param_id).group, 2)
      reset_font_settings
      change_color(system_color)
      draw_text(dx + dwa, dy, 22, line_height, "▷", 1)
      param_id += 1
      dy += line_height
      break if dy + line_height > contents.height
    end
  end
  
  def draw_custom3
    return unless $imported["YEA-ClassSystem"]
    data = []
    for class_id in YEA::CLASS_SYSTEM::CLASS_ORDER
      next if $data_classes[class_id].nil?
      item = $data_classes[class_id]
      next unless @actor.unlocked_classes.include?(item.id) or 
        YEA::CLASS_SYSTEM::DEFAULT_UNLOCKS.include?(item.id)
      data.push(item)
    end
    dx = 0; dy = 0; class_index = 0
    for class_id in data
      item = data[class_index]
      reset_font_settings
      if item == @actor.class
        change_color(text_color(YEA::CLASS_SYSTEM::CURRENT_CLASS_COLOUR))
      elsif item == @actor.subclass
        change_color(text_color(YEA::CLASS_SYSTEM::SUBCLASS_COLOUR))
      else
        change_color(normal_color)
      end
      icon = item.icon_index
      draw_icon(icon, dx, dy)
      text = item.name
      draw_text(24, dy, contents.width-24, line_height, text)
      next if YEA::CLASS_SYSTEM::MAINTAIN_LEVELS
      level = @actor.class_level(item.id)
      contents.font.size = YEA::CLASS_SYSTEM::LEVEL_FONT_SIZE
      text = sprintf(YEA::CLASS_SYSTEM::CLASS_LEVEL, level.group)
      dwa = contents.width - (Graphics.width * 2 / 5 - 24) - 28
      draw_text(dx, dy, dwa, line_height, text, 2)
      class_index += 1
      dy += line_height
      break if dy + line_height > contents.height
    end
    dw = Graphics.width * 2 / 5 - 24
    dx = contents.width - dw; dy = 0
    param_id = 0
    8.times do
      contents.font.size = YEA::CLASS_SYSTEM::PARAM_FONT_SIZE
      change_color(system_color)
      draw_text(dx+4, dy, dw, line_height, Vocab::param(param_id))
      change_color(normal_color)
      dwa = (Graphics.width * 2 / 5 - 2) / 2
      draw_text(dx, dy, dwa, line_height, @actor.param(param_id).group, 2)
      reset_font_settings
      change_color(system_color)
      draw_text(dx + dwa, dy, 22, line_height, "▷", 1)
      param_id += 1
      dy += line_height
      break if dy + line_height > contents.height
    end
  end
end