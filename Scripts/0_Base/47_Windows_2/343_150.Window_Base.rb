# encoding: utf-8
# Name: 150.Window_Base
# Size: 11728
class Window_Base < Window
  include H87_GoldSetup
  
  def draw_currency_value(value, unit, x, y, width, tepy)
    @negative = false
    if 1 > value
      @negative = true
      value *= -1
    end
    icon_width = IconOverlay ? 12 : 24
    bronzes = get_bronzes(value)
    silvers = get_silvers(value)
    golds = get_golds(value)
    w2 = width
    
    change_color(system_color)
    draw_text(x,y,w2,line_height,"소지금")     if tepy == 1
    draw_text(x,y,w2,line_height,"총 금액")    if tepy == 2
    draw_text(x,y,w2,line_height,"기부금")     if tepy == 3
    draw_text(x,y,w2,line_height,"")          if tepy == 4
    draw_text(x,y,w2,line_height,"배팅 금액")  if tepy == 5
    
    draw_text(x,y,w2,line_height,"#{$game_variables[27]}" + '일') if tepy == 6
    
    draw_text(x,y,w2,line_height,"")          if tepy == 7 # 골드 획득

    change_color(normal_color)
    if tepy == 3 or tepy == 5 or tepy == 6
      # 소지금 초과시 빨간색으로 표시 적용
      $game_switches[141] = false if $game_switches[141] == true
    end
    # 소지금 보다 값이 크면 빨간색
    if !SceneManager.scene_is?(Scene_Load) and !SceneManager.scene_is?(Scene_Save)
      if $game_switches[141] == false
        #print("061.통화 세분화 - 빨간색으로 표기(%s)\n" % [$game_switches[141]]);
        if value > $game_party.gold and value > 0 and value != nil
          change_color(text_color(10))
        end
      else
        #print("061.통화 세분화 - 초록색으로 표기(%s)\n" % [$game_switches[141]]);
        if value > $game_party.gold and value > 0 and value != nil
          change_color(text_color(3))
        end
      end
    end
    if tepy != 7
      if bronzes > 0
        draw_icon(ICONBRONZE, x + w2 - 17, y)
        w2 -= icon_width + 4
        w1 = text_size(bronzes).width + 10
        draw_text(x, y, w2, line_height, bronzes.to_s, 2)
        w2 -= w1
      end
      if silvers > 0
        draw_icon(ICONSILVER, x + w2 - 17, y)
        w2 -= icon_width + 4
        w1 = text_size(silvers).width + 10
        draw_text(x, y, w2, line_height, silvers.to_s, 2)
        w2 -= w1
      end
      if golds > 0
        draw_icon(ICONGOLD, x + w2 - 17, y)
        w2 -= icon_width + 4
        w1 = text_size(golds).width + 10
        draw_text(x, y, w2, line_height, golds.to_s, 2)
        w2 -= w1
      end
      if @negative # 음수로 마이너스를 그립니다.
        draw_text(x, y, w2, line_height, "-", 2)
      end
    else
      x = 10
      w2 = 0
      if golds > 0
        w1 = text_size(golds).width + 10
        draw_icon(ICONGOLD, x + w1 + w2 - 10, y)
        draw_text(x + w2 - 1, y, w1 + 10, line_height, golds.to_s, 0)
        w2 += icon_width + 4
        w2 += w1
      end
      if silvers > 0
        w1 = text_size(silvers).width + 10
        draw_icon(ICONSILVER, x + w1 + w2 - 10, y)
        draw_text(x + w2 - 1, y, w1 + 10, line_height, silvers.to_s, 0)
        w2 += icon_width + 4
        w2 += w1
      end
      if bronzes > 0
        w1 = text_size(bronzes).width + 10
        draw_icon(ICONBRONZE, x + w1 + w2 - 10, y)
        draw_text(x + w2 - 1, y, w1 + 10, line_height, bronzes.to_s, 0)
        w2 += icon_width + 4
        w2 += w1
      end
      if @negative # 음수로 마이너스를 그립니다.
        draw_text(x, y, w2, line_height, "-", 0)
      end
    end
    change_color(normal_color)
  end
  
  def draw_background_colour(dx, dy)
    colour = Color.new(0, 0, 0, translucent_alpha/2)
    rect = Rect.new(dx+1, dy+1, contents.width - dx - 2, line_height - 2)
    contents.fill_rect(rect, colour)
  end

  def get_bronzes(value)
    value % VALUESILVER
  end

  def get_silvers(value)
    value / VALUESILVER % VALUEGOLD
  end

  def get_golds(value)
    value / VALUESILVER / VALUEGOLD
  end

  alias goldp_e_c process_escape_character unless $@

  def process_escape_character(code, text, pos)
    return process_draw_coins(obtain_escape_param(text), pos) if code.upcase == 'M'
    goldp_e_c(code, text, pos)
  end

  def process_draw_coins(value, pos)
    width = calc_currency_width(value)
    draw_currency_value(value, "", pos[:x]-5, pos[:y], width, 4)
    pos[:x] += width
  end

  def calc_currency_width(value)
    icon_width = IconOverlay ? 12 : 24
    bronzes = get_bronzes(value)
    silvers = get_silvers(value)
    golds = get_golds(value)
    text = ""
    width = 0
    if bronzes > 0
      text += bronzes.to_s
      width += icon_width + 14
    end
    if silvers > 0
      text += silvers.to_s
      width += icon_width + 14
    end
    if golds > 0
      text += golds.to_s
      width += icon_width + 14
    end
    width + text_size(text).width
  end
  
  def draw_actor_hunger(actor, x, y, width = 66)
    # 폰트, 사이즈 게이지
    reset_font_settings
    contents.font.bold = false
    contents.font.size = 16
    self.z = 1210
    change_color(normal_color)
    draw_current_and_max_values2(x, y, width, actor.hunger.to_i, actor.hunger_max.to_i, normal_color, normal_color)
  end
  
  def draw_actor_thirst(actor, x, y, width = 66)
    # 폰트, 사이즈 게이지
    reset_font_settings
    contents.font.bold = false
    contents.font.size = 16
    self.z = 1210
    change_color(normal_color)
    draw_current_and_max_values2(x, y, width, actor.thirst.to_i, actor.thirst_max.to_i, normal_color, normal_color)
  end
  
  def draw_actor_sleep(actor, x, y, width = 66)
    # 폰트, 사이즈 게이지
    reset_font_settings
    contents.font.bold = false
    contents.font.size = 16
    self.z = 1210
    change_color(normal_color)
    draw_current_and_max_values2(x, y, width, actor.sleep.to_i, actor.sleep_max.to_i, normal_color, normal_color)
  end
  
  def draw_current_and_max_values2(x, y, width = col_width, current, max, color1, color2)
    change_color(color1)
    @rate = (current.to_f / max.to_f) * 100
    @rate = 0 if 0 > @rate
    @rate = 100 if @rate > 100
    @value = sprintf("%1.0f%%", @rate)
    case @rate
      when 80..110 then change_color(knockout_color)
      when 70..79 then change_color(crisis_color)
    end
    draw_text(x, y, width, line_height, @value, 2)
  end
  
  #--------------------------------------------------------------------------
  # 상태이상 남은 시간 표기 실험
  #--------------------------------------------------------------------------
  def draw_actor_state(x, y, width = 66)
    #print("생존 관련 + Window_Base - draw_actor_state \n");
    text_y = 0
    change_color(normal_color)
    if $game_actors[7].states != nil
      for state in $game_actors[7].states
        text_y += 24
        if state.remove_by_walking
          if !$game_actors[7].state_steps[state.id].nil? and $game_actors[7].state_steps[state.id] > 0
            # 상태이상 유지 시간 표기 실험
            if $game_actors[7].state_steps[state.id] >= 60
              draw_text(x, text_y-12, width, 32, $game_actors[7].state_steps[state.id]/60, 2)
            end
          end
        end
      end
    end
  end
  
  # 기본 폰트 설정
  def reset_font_settings
    change_color(normal_color)
    contents.font.size = Font.default_size
    contents.font.bold = Font.default_bold
    contents.font.italic = Font.default_italic
    contents.font.out_color = Font.default_out_color
  end
  
  def self.normal_color;      text_color(YEA::CORE::COLOURS[:normal]);      end;
  def self.system_color;      text_color(YEA::CORE::COLOURS[:system]);      end;
  def self.crisis_color;      text_color(YEA::CORE::COLOURS[:crisis]);      end;
  def self.knockout_color;    text_color(YEA::CORE::COLOURS[:knockout]);    end;
  def self.gauge_back_color;  text_color(YEA::CORE::COLOURS[:gauge_back]);  end;
  def self.hp_gauge_color1;   text_color(YEA::CORE::COLOURS[:hp_gauge1]);   end;
  def self.hp_gauge_color2;   text_color(YEA::CORE::COLOURS[:hp_gauge2]);   end;
  def self.mp_gauge_color1;   text_color(YEA::CORE::COLOURS[:mp_gauge1]);   end;
  def self.mp_gauge_color2;   text_color(YEA::CORE::COLOURS[:mp_gauge2]);   end;
  def self.mp_cost_color;     text_color(YEA::CORE::COLOURS[:mp_cost]);     end;
  def self.power_up_color;    text_color(YEA::CORE::COLOURS[:power_up]);    end;
  def self.power_down_color;  text_color(YEA::CORE::COLOURS[:power_down]);  end;
  def self.tp_gauge_color1;   text_color(YEA::CORE::COLOURS[:tp_gauge1]);   end;
  def self.tp_gauge_color2;   text_color(YEA::CORE::COLOURS[:tp_gauge2]);   end;
  def self.tp_cost_color;     text_color(YEA::CORE::COLOURS[:tp_cost]);     end;
  def translucent_alpha
    return YEA::CORE::TRANSPARENCY
  end
  
  def hp_color(actor)
    return knockout_color if actor.hp == 0
    return crisis_color if actor.hp < actor.mhp * YEA::CORE::HP_CRISIS
    return normal_color
  end
  
  def mp_color(actor)
    return crisis_color if actor.mp < actor.mmp * YEA::CORE::MP_CRISIS
    return normal_color
  end
  
  def draw_gauge(dx, dy, dw, rate, color1, color2)
    dw -= 2 if YEA::CORE::GAUGE_OUTLINE
    fill_w = [(dw * rate).to_i, dw].min
    gauge_h = YEA::CORE::GAUGE_HEIGHT
    gauge_y = dy + line_height - 2 - gauge_h
    if YEA::CORE::GAUGE_OUTLINE
      outline_colour = gauge_back_color
      outline_colour.alpha = translucent_alpha
      contents.fill_rect(dx, gauge_y-1, dw+2, gauge_h+2, outline_colour)
      dx += 1
    end
    contents.fill_rect(dx, gauge_y, dw, gauge_h, gauge_back_color)
    contents.gradient_fill_rect(dx, gauge_y, fill_w, gauge_h, color1, color2)
  end
  
  def draw_actor_level(actor, dx, dy)
    change_color(system_color)
    draw_text(dx, dy, 32, line_height, Vocab::level_a)
    change_color(normal_color)
    draw_text(dx + 32, dy, 24, line_height, actor.level.group, 2)
  end
  
  def draw_current_and_max_values(dx, dy, dw, current, max, color1, color2)
    total = current.group + "/" + max.group
    if dw < text_size(total).width + text_size(Vocab.hp).width
      change_color(color1)
      draw_text(dx, dy, dw, line_height, current.group, 2)
    else
      xr = dx + text_size(Vocab.hp).width
      dw -= text_size(Vocab.hp).width
      change_color(color2)
      text = "/" + max.group
      draw_text(xr, dy, dw, line_height, text, 2)
      dw -= text_size(text).width
      change_color(color1)
      draw_text(xr, dy, dw, line_height, current.group, 2)
    end
  end
  
  # 지역 공헌도 하단 표기 % 입력
  def draw_current_and_max_values3(dx, dy, dw, current, max, color1, color2)
    change_color(color1)
    draw_text(dx, dy, dw, line_height, "#{((current/max)*100).to_i}" + '%', 2)
  end
  
  def draw_actor_tp(actor, x, y, width = 124)
    draw_gauge(x, y, width, actor.tp_rate, tp_gauge_color1, tp_gauge_color2)
    change_color(system_color)
    draw_text(x, y, 30, line_height, Vocab::tp_a)
    change_color(tp_color(actor))
    draw_text(x + width - 42, y, 42, line_height, actor.tp.to_i.group, 2)
  end
  
  def draw_actor_param(actor, x, y, param_id)
    change_color(system_color)
    draw_text(x, y, 120, line_height, Vocab::param(param_id))
    change_color(normal_color)
    draw_text(x + 120, y, 36, line_height, actor.param(param_id).group, 2)
  end
  
  def draw_actor_simple_status(actor, dx, dy)
    draw_actor_name(actor, dx, dy)
    draw_actor_level(actor, dx, dy + line_height * 1)
    draw_actor_icons(actor, dx, dy + line_height * 2)
    dw = contents.width - dx - 124
    draw_actor_class(actor, dx + 120, dy, dw)
    draw_actor_hp(actor, dx + 120, dy + line_height * 1, dw)
    draw_actor_mp(actor, dx + 120, dy + line_height * 2, dw)
  end
end