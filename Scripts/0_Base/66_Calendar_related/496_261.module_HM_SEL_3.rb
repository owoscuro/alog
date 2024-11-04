# encoding: utf-8
# Name: 261.module HM_SEL 3
# Size: 16178
module HM_SEL
  
  # 창이 표시되는 위치(이 경우 시계)를 결정하는 데 사용됩니다.
  # 1 = Top Left,    2 = Top Right
  # 3 = Bottom Left, 4 = Bottom Right
  # 5 = Top Middle,  6 = Bottom Middle
  CLOCK_POSITION = 4

  # 시계 HUD의 크기를 결정합니다, True는 작은 버전을 사용합니다.
  USE_SMALL_CLOCK = true

  # 0 = 보이지 않는 배경, 255 = 정상
  CLOCK_OPACITY = 0

  # 이것을 당신이 가지고 있는 다른 윈도우 스킨의 이름으로 변경하십시오.
  Window_Skin = "Window"

  # HUD 가시성을 수동으로 토글하는 데 사용되는 버튼입니다.
  CLOCK_TOGGLE = nil

	Day_Names = ['','Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo']
	Month_Names = ['', 'Invierno', 'Invierno', 'Invierno', 'Primavera', 'Primavera', 'Verano', 
				   'Verano', 'Verano', 'Verano', 'Otoño', 'Otoño', 'Invierno']

  def self.current_time?
    minute = $game_variables[MIN]
    hour = $game_variables[HOUR]
    hour = 12 if hour == 0
    hour -= 12 if hour > 12

    if hour < 10
      hour = ' ' + hour.to_s
    else
      hour.to_s
    end
    
    if minute < 10
      minute = '0' + minute.to_s
    else
      minute.to_s
    end

    # 메서드에 대한 결과 텍스트입니다.
    return hour.to_s + ':' + minute.to_s
  end
  
  def self.am_pm?
    $game_variables[HOUR] >= 12 ? 'PM' : 'AM'
  end
  
  def self.day_of_week?
    if $game_variables[DAYA] > 0 && $game_variables[DAYA] < Day_Names.size
      return Day_Names[$game_variables[DAYA]]
    else
      return 'ERR'
    end
  end
  
  def self.day_of_month?
    day = $game_variables[DAYB]
    if day < 10
      return ' ' + day.to_s
    else
      return day.to_s
    end
  end
  
  def self.month?
    if $game_variables[MONTH] > 0 && $game_variables[MONTH] < Month_Names.size
      return Month_Names[$game_variables[MONTH]]
    else
      return 'ERROR'
    end
  end
  
  def self.month2?
    month2 = $game_variables[MONTH]
    return month2.to_s
  end

  # 년도 추가
  def self.ro_year?
    ro_year = $game_variables[YEAR]
    return ro_year.to_s
  end
  
	# Variable de visualización en la pantalla de guardar
	def self.top_calendar_line?
	  HM_SEL::init_var if $game_variables[DAYA] == 0
	  $game_variables[168] = self.top_calendar_line2?
	  return day_of_month? + '/' + month2? + '/' + ro_year? + ' (' + day_of_week? + ') (' + month? + ')'
	end

	def self.top_calendar_line2?
	  HM_SEL::init_var if $game_variables[DAYA] == 0
	  return day_of_month? + '/' + month2? + '/' + ro_year? + ' (' + day_of_week? + ') (' + month? + ')'
	end
  
  def self.bottom_calendar_line?
    return current_time? + ' ' + am_pm?
  end
  
  class Window_Clock < Window_Base
    def initialize
      #print("261.module HM_SEL 3 - 시계 UI 생성 및 설정 \n");
      @minute = $game_variables[HM_SEL::MIN]
      @hour = $game_variables[HM_SEL::HOUR]
      @day = $game_variables[HM_SEL::DAYA]
      @time_stopped = HM_SEL::time_stop?
      #--------------------------------------------------------------------------
      # 날씨 아이콘, 햇빛 투명도 변경
      #--------------------------------------------------------------------------
      case $game_variables[HM_SEL::HOUR]
        when 0;  $game_variables[20] = 3;   $picture_12_op = 0
        when 1;  $game_variables[20] = 7;   $picture_12_op = 0
        when 2;  $game_variables[20] = 7;   $picture_12_op = 0
        when 3;  $game_variables[20] = 15;  $picture_12_op = 0
        when 4;  $game_variables[20] = 15;  $picture_12_op = 0
        when 5;  $game_variables[20] = 12;  $picture_12_op = 10
        when 6;  $game_variables[20] = 8;   $picture_12_op = 10
        when 7;  $game_variables[20] = 4;   $picture_12_op = 30
        when 8;  $game_variables[20] = 0;   $picture_12_op = 30
        when 9;  $game_variables[20] = 5;   $picture_12_op = 80
        when 10; $game_variables[20] = 1;   $picture_12_op = 80
        when 11; $game_variables[20] = 1;   $picture_12_op = 140
        when 12; $game_variables[20] = 1;   $picture_12_op = 140
        when 13; $game_variables[20] = 5;   $picture_12_op = 230
        when 14; $game_variables[20] = 5;   $picture_12_op = 230
        when 15; $game_variables[20] = 9;   $picture_12_op = 170
        when 16; $game_variables[20] = 9;   $picture_12_op = 170
        when 17; $game_variables[20] = 2;   $picture_12_op = 140
        when 18; $game_variables[20] = 2;   $picture_12_op = 140
        when 19; $game_variables[20] = 2;   $picture_12_op = 120
        when 20; $game_variables[20] = 6;   $picture_12_op = 120
        when 21; $game_variables[20] = 10;  $picture_12_op = 10
        when 22; $game_variables[20] = 14;  $picture_12_op = 10
        when 23; $game_variables[20] = 11;  $picture_12_op = 5
        when 24; $game_variables[20] = 3;   $picture_12_op = 5
      end
      # 비오는 날씨
      if $game_variables[12] != 0
        $picture_12_op = 0
      end
      #--------------------------------------------------------------------------
      # 계절 변수 적용
      #--------------------------------------------------------------------------
      case $game_variables[HM_SEL::MONTH]
        when 1..3
          $game_variables[23] = 2
        when 4..5
          $game_variables[23] = 3
        when 6..9
          $game_variables[23] = 0
        when 10..11
          $game_variables[23] = 1
        when 12
          $game_variables[23] = 2
        else
          $game_variables[23] = 3
      end
      # 시계 UI 제거 스위치
      if $game_switches[284] == false and $game_switches[189] == false
        if @icons2 == nil or @icons_hour != $game_variables[20]
          @icons_hour = $game_variables[20]
          draw_icon2(@icons_hour, 0, 0, 255)
          @icons2.opacity = 255
          @icons2.visible = !HM_SEL::time_stop?
          @icons2.z = 1101
          draw_icon3(0, 0, 0, 255)
          @icons3.opacity = 255
          @icons3.visible = !HM_SEL::time_stop?
          @icons3.z = 1102
        end
        super(hud_x-10, hud_y, hud_w+20, hud_h)
        self.windowskin = Cache.system(HM_SEL::Window_Skin)
        self.z = 1100
        self.opacity = 0
        self.contents.font.name = "한컴 윤체 L"
        self.contents.font.size = 16
        # 진행 여부 -------------------------------------------------------------
        if !HM_SEL::time_stop?
        # ----------------------------------------------------------------------
          if $game_switches[35] != true
            if @minute != $game_variables[HM_SEL::MIN] or @dicon3_icon != 1
              self.contents.clear
              self.contents.draw_text(15,0,125,24,HM_SEL::bottom_calendar_line?)
              self.contents.draw_text(0,20,125,24,HM_SEL::top_calendar_line?)
              @dicon3_va_old = $game_variables[125]
              @dicon3_icon = 1
              self.visible = !HM_SEL::time_stop?
            end
          elsif @minute != $game_variables[HM_SEL::MIN] or @dicon3_va_old != $game_variables[125] or @dicon3_icon != 2
            self.contents.clear
            self.contents.draw_text(15,0,125,24,HM_SEL::bottom_calendar_line?)
            if $game_variables[18] == 0
              self.contents.draw_text(0,20,95,24,"X"+"#{$game_player.x}"+" Y"+"#{$game_player.y}"+" L"+"#{$game_variables[99]}"+"(E)", 2)
            elsif $game_variables[18] == 1
              self.contents.draw_text(0,20,95,24,"X"+"#{$game_player.x}"+" Y"+"#{$game_player.y}"+" L"+"#{$game_variables[99]}"+"(N)", 2)
            elsif $game_variables[18] == 2
              self.contents.draw_text(0,20,95,24,"X"+"#{$game_player.x}"+" Y"+"#{$game_player.y}"+" L"+"#{$game_variables[99]}"+"(H)", 2)
            elsif $game_variables[18] == 3
              self.contents.draw_text(0,20,95,24,"X"+"#{$game_player.x}"+" Y"+"#{$game_player.y}"+" L"+"#{$game_variables[99]}"+"(VE)", 2)
            elsif $game_variables[18] == 4
              self.contents.draw_text(0,20,95,24,"X"+"#{$game_player.x}"+" Y"+"#{$game_player.y}"+" L"+"#{$game_variables[99]}"+"(H)", 2)
            elsif $game_variables[18] == 5
              self.contents.draw_text(0,20,95,24,"X"+"#{$game_player.x}"+" Y"+"#{$game_player.y}"+" L"+"#{$game_variables[99]}"+"(L)", 2)
            end
            @dicon3_va_old = $game_variables[125]
            @dicon3_icon = 2
            self.visible = !HM_SEL::time_stop?
          end
        end
      end
    end

    # 날씨 아이콘 실험 -----------------------------------------------------------
    def dispose
      if @icons2 != nil
        #print("261.module HM_SEL 3 - dispose, @icons2 \n");
        self.contents.clear if self.contents != nil
        @icons2.bitmap.dispose
        @icons2.dispose
        @icons2 = nil
      end
      if @icons3 != nil
        #print("261.module HM_SEL 3 - dispose, @icons3 \n");
        self.contents.clear if self.contents != nil
        @icons3.bitmap.dispose
        @icons3.dispose
        @icons3 = nil
        @hts_window.dispose
        @hts_window = nil
      end
      @dicon3_icon = nil if @dicon3_icon != nil
      @dicon3_va_old = nil if @dicon3_va_old != nil
    end
    # --------------------------------------------------------------------------

    def hud_w
      USE_SMALL_CLOCK ? 113 : 131
    end
    
    def hud_h
      USE_SMALL_CLOCK ? 52 : 68
    end
    
    def hud_x
      return 0 if [1, 3].include?(CLOCK_POSITION)
      return (Graphics.width/2)-(hud_w/2) if [5, 6].include?(CLOCK_POSITION)
      return Graphics.width - hud_w if [2, 4].include?(CLOCK_POSITION)
    end
    
    def hud_y
      return 0 if [1, 2, 5].include?(CLOCK_POSITION)
      return Graphics.height - hud_h if [3, 4, 6].include?(CLOCK_POSITION)
    end
    
    def standard_padding
      USE_SMALL_CLOCK ? 5 : 12
    end 
    
    def update
      # 시계 UI 제거 스위치
      if $game_switches[281] == true and $game_switches[284] == false and !HM_SEL::time_stop? and $game_switches[189] == false
        # 아이콘 이미지, 텍스트 실시간 표시 여부를 적용
        if @icons2 != nil and @icons2.visible != !HM_SEL::time_stop?
          #print("261.module HM_SEL 3 - update[1] \n");
          @icons2.visible = !HM_SEL::time_stop?
          @icons3.visible = !HM_SEL::time_stop?
          @hts_window.refresh
        end
        # 날씨 아이콘 실험 -------------------------------------------------------
        if @icons3 == nil or @icons2 == nil
          #print("261.module HM_SEL 3 - update[2] \n");
          @icons_hour = $game_variables[20]
          draw_icon2(@icons_hour, 0, 0, 255)
          @icons2.opacity = 255
          @icons2.z = 1101
          draw_icon3(0, 0, 0, 255)
          @icons3.opacity = 255
          @icons3.z = 1102
          @hour = $game_variables[HM_SEL::HOUR]
          @minute = $game_variables[HM_SEL::MIN]
          @day = $game_variables[HM_SEL::DAYA]
          @time_stopped = HM_SEL::time_stop?
        end
        # 욕구 갱신 확인 스위치
        if $game_switches[226] == true
          #print("261.module HM_SEL 3 - update[3] \n");
          @hts_window.refresh
        end
        # ----------------------------------------------------------------------
        if $game_switches[35] != true
          if @minute != $game_variables[HM_SEL::MIN] or @dicon3_icon != 1
            #print("261.module HM_SEL 3 - update[4] \n");
            self.contents.clear
            self.contents.draw_text(15,0,125,24,HM_SEL::bottom_calendar_line?)
            self.contents.draw_text(0,20,125,24,HM_SEL::top_calendar_line?)
            @dicon3_va_old = $game_variables[125]
            @dicon3_icon = 1
            self.visible = !HM_SEL::time_stop?
            @minute = $game_variables[HM_SEL::MIN]
          end
        elsif @minute != $game_variables[HM_SEL::MIN] or @dicon3_va_old != $game_variables[125] or @dicon3_icon != 2
          #print("261.module HM_SEL 3 - update[5] \n");
          self.contents.clear
          self.contents.draw_text(15,0,125,24,HM_SEL::bottom_calendar_line?)
          if $game_variables[18] == 0
            self.contents.draw_text(0,20,95,24,"X"+"#{$game_player.x}"+" Y"+"#{$game_player.y}"+" L"+"#{$game_variables[99]}"+"(E)", 2)
          elsif $game_variables[18] == 1
            self.contents.draw_text(0,20,95,24,"X"+"#{$game_player.x}"+" Y"+"#{$game_player.y}"+" L"+"#{$game_variables[99]}"+"(N)", 2)
          elsif $game_variables[18] == 2
            self.contents.draw_text(0,20,95,24,"X"+"#{$game_player.x}"+" Y"+"#{$game_player.y}"+" L"+"#{$game_variables[99]}"+"(H)", 2)
          elsif $game_variables[18] == 3
            self.contents.draw_text(0,20,95,24,"X"+"#{$game_player.x}"+" Y"+"#{$game_player.y}"+" L"+"#{$game_variables[99]}"+"(VE)", 2)
          elsif $game_variables[18] == 4
            self.contents.draw_text(0,20,95,24,"X"+"#{$game_player.x}"+" Y"+"#{$game_player.y}"+" L"+"#{$game_variables[99]}"+"(H)", 2)
          elsif $game_variables[18] == 5
            self.contents.draw_text(0,20,95,24,"X"+"#{$game_player.x}"+" Y"+"#{$game_player.y}"+" L"+"#{$game_variables[99]}"+"(L)", 2)
          end
          @dicon3_va_old = $game_variables[125]
          @dicon3_icon = 2
          self.visible = !HM_SEL::time_stop?
          @minute = $game_variables[HM_SEL::MIN]
        end
      else
        dispose
      end
    end

    # 날씨 아이콘 실험
    def draw_icon2(icon_index, x, y, enabled = true)
      #print("261.module HM_SEL 3 - draw_icon2 \n");
      bit = Cache.system("weather_icon")
      rect = Rect.new(icon_index % 4 * 30, icon_index / 4 * 30, 30, 30)
      @icons2 = Sprite.new
      @icons2.bitmap = Bitmap.new(30, 30)
      @icons2.x = Graphics.width - 40
      @icons2.y = Graphics.height - 60
      @icons2.z = 1101
      @icons2.bitmap.blt(x, y, bit, rect, enabled ? 255 : 150)
    end

    # 욕구 아이콘 설정 실험
    def draw_icon3(icon_index, x, y, enabled = true)
      #print("261.module HM_SEL 3 - draw_icon3 \n");
      @hts_window = Window_HTS.new(BRAVO_HTS::HTS_HUD_X, BRAVO_HTS::HTS_HUD_Y)
      bit = Cache.system("hunger_icon")
      rect = Rect.new(0,0, 200, 29)
      @icons3 = Sprite.new
      @icons3.bitmap = Bitmap.new(200, 29)
      @icons3.x = 10
      @icons3.y = Graphics.height - 30
      @icons3.z = 1102
      @icons3.bitmap.blt(x, y, bit, rect, enabled ? 255 : 150)
    end
  end
  
  class Window_Sex_Clock < Window_Base
    def initialize
      super(0, -5, Graphics.width, 60)
      self.windowskin = Cache.system(HM_SEL::Window_Skin)
      self.z = 1100
      self.opacity = 0
    end
    
    def dispose
      self.contents.clear if self.contents != nil
    end
    
    def update
      if $game_switches[189] == true
        draw_actor_h_gauge(7,3)
      else
        dispose
      end
    end
    
    # 성행위시 에르니 체력 게이지
    def draw_actor_h_gauge(x,y)
      contents.clear
      width = Graphics.width-36
      ol_rate = 600 - $game_variables[68]
      # 체력 게이지 백분율
      $game_variables[67] = ($game_variables[68].to_f/600)*100
      rate = ol_rate.to_f/600
      rate = 1 if rate > 1
      fill_w = (width * rate).to_i
      fill_w = 3 if 3 > fill_w
      self.contents.fill_rect(x, y-1, width-1, 8, Color.new(0, 0, 0, 200))
      self.contents.fill_rect(x+1, y, width-3, 6, Color.new(255, 255, 255, 200))
      self.contents.gradient_fill_rect(x+1, y, fill_w-3, 6, Color.new(196, 180, 74, 255), Color.new(115, 20, 20, 200))
      # 폰트, 사이즈 실험 게이지
      reset_font_settings
      contents.font.bold = false
      contents.font.size = 16
      change_color(normal_color)
      draw_text(x, y+6, 64, line_height, "Excitación")
      draw_current_and_max_values2(x, y+6, 90, ol_rate, 600,
      normal_color, normal_color)
    end
  end
end