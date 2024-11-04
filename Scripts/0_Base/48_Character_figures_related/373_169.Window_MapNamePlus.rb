# encoding: utf-8
# Name: 169.Window_MapNamePlus
# Size: 10450
# encoding: utf-8
# Name: 169.Window_MapNamePlus
# Size: 11379
class Window_MapNamePlus < Window_Base
  
  FONT_NAME_CH = ["Arial"]          # 맵 이름 글꼴 이름
  FONT_SIZE_CH = 32                 # 맵 이름 글꼴 크기
  FONT_NAME_EN = ["Arial"]          # 맵 이름 글꼴 이름
  FONT_SIZE_EN = 22                 # 맵 이름 글꼴 크기
  FONT_BOLD = false                 # 글꼴이 굵게 표시된 경우 True
  
  FONT_COLOR = Color.new(255, 255, 255, 255)  # 글꼴 색상
  
  FONT_OUT = true                   # 글꼴에 윤곽선이 있는 경우 True
  OUT_COLOR = Color.new(0, 0, 0, 200)         # 외곽선 색상 글꼴 색상
  FONT_SHADOW = false               # 텍스트가 그림자를 드리우면 True
  MODIFIER = ""                     # 맵 이름 옆에 수정자가 추가됨
  PADDING = 8                       # 창의 프레임과 내용 사이의 패딩
  LINE_HEIGHT = 2                   # 분할선 높이
  
  attr_reader :map_name_ch          # Chinese Map Name
  attr_reader :map_name_en          # English Map Name
  attr_reader :line_x               # Split Line X Coordinate
  attr_reader :line_y               # Split Line Y Coordinate
  attr_reader :map_id_name          # 맵 이동 여부 확인
  
  def initialize
    super(0, ((Graphics.height - (FONT_SIZE_CH + FONT_SIZE_EN + PADDING * 4 + LINE_HEIGHT)) / 2), window_width, FONT_SIZE_CH + FONT_SIZE_EN + PADDING * 4 + LINE_HEIGHT)
    
    contents.font.bold = FONT_BOLD
    contents.font.color = FONT_COLOR
    contents.font.outline = FONT_OUT
    contents.font.out_color = OUT_COLOR
    contents.font.shadow = FONT_SHADOW
    
    self.opacity = 0
    self.contents_opacity = 0
    @show_count = 0
    @map_id_name = ""
    refresh
  end
  
  def window_width
    return Graphics.width
  end
  
  def update
    super
    # --------------------------------------------------------------------------
    # 아래는 시간 가속중이 아닌 경우에만 적용
    # --------------------------------------------------------------------------
    if $game_switches[283] == false
      if @show_count > 0 && $game_map.name_display
        update_fadein
        @show_count -= 1
      elsif self.contents_opacity >= 1
        update_fadeout
      end
    end
  end
  
  def update_fadein
    self.contents_opacity += 16
  end
  
  def update_fadeout
    self.contents_opacity -= 16
  end
  
  def open
    refresh
    @show_count = 150
    self.contents_opacity = 0
    self
  end
  
  def close
    @show_count = 0
    self
  end
  
  def refresh
    # 메뉴 불러오기 취소해도 갱신
    if contents != nil
      #print("맵 이름 관련 + Window_MapNamePlus - contents.clear \n");
      contents.clear
    end
    
    # 매춘으로 인한 맵 이동이 아닌 경우에만 맵 이름 표시한다.
    if $game_variables[69] == 0
      if @map_id_name != $game_map.display_name
        # 아예 다른 맵으로 이동시 광원 효과 갱신 처리
        # 아래 사용시 맵 이동 후 완전 밝아진다.
        #$game_map.screen.clear_lights
        set_map_name
        unless $game_map.display_name.empty?
          #print("맵 이름 관련 + Window_MapNamePlus - draw_map_name \n");
          draw_map_name
        end
      end
    end
  end
  
  def draw_line(rect)
    temp_rect = rect.clone
    temp_rect.height = LINE_HEIGHT
    temp_rect.width /= 4
    contents.gradient_fill_rect(temp_rect, color2, color1)
    temp_rect.x += temp_rect.width
    temp_rect.width *= 2
    contents.fill_rect(temp_rect, color1)
    temp_rect.x += temp_rect.width
    temp_rect.width /= 2
    contents.gradient_fill_rect(temp_rect, color1, color2)
  end
  
  def set_map_name
    #print("맵 이름 관련 + Window_MapNamePlus - set_map_name \n");
    @map_name_ch = nil
    @map_name_en = nil
    if $game_map.map_id == 141
      @map_name_ch = $game_actors[18].name
      @map_name_en = MODIFIER + "(#{$game_variables[370]}, #{$game_variables[371]})" + MODIFIER
    elsif $game_map.map_id == 144
      @map_name_ch = $game_actors[17].name
      @map_name_en = MODIFIER + "(#{$game_variables[370]}, #{$game_variables[371]})" + MODIFIER
    # 세라이튼 집
    elsif $game_map.map_id == 398 or $game_map.map_id == 399
      @map_name_ch = $game_map.display_name
      @map_name_ch = $game_actors[16].name if $game_variables[147] == $game_map.map_id
      @map_name_en = MODIFIER + "(#{$game_variables[370]}, #{$game_variables[371]})" + MODIFIER
    # 바일라스 집
    elsif $game_map.map_id == 403 or $game_map.map_id == 404
      @map_name_ch = $game_map.display_name
      @map_name_ch = $game_actors[16].name if $game_variables[147] == $game_map.map_id
      @map_name_ch = $game_actors[16].name if $game_variables[147] + 1 == $game_map.map_id
      @map_name_en = MODIFIER + "(#{$game_variables[370]}, #{$game_variables[371]})" + MODIFIER
    # 슬라인 집
    elsif $game_map.map_id == 400
      @map_name_ch = $game_map.display_name
      @map_name_ch = $game_actors[16].name if $game_variables[147] == $game_map.map_id
      @map_name_en = MODIFIER + "(#{$game_variables[370]}, #{$game_variables[371]})" + MODIFIER
    # 팔세린 집
    elsif $game_map.map_id == 316 or $game_map.map_id == 272
      @map_name_ch = $game_map.display_name
      @map_name_ch = $game_actors[16].name if $game_variables[147] == $game_map.map_id
      @map_name_en = MODIFIER + "(#{$game_variables[370]}, #{$game_variables[371]})" + MODIFIER
    end
    if @map_name_ch == nil or @map_name_ch == ""
      temp_map_name = $game_map.display_name.split(" (")
      @map_name_ch = temp_map_name[0].to_s
      # 마을인 경우 굳이 지역을 표시하지 않는다.
      if $game_map.map_id != 395 and $game_map.map_id != 312 and 
        $game_map.map_id != 264 and $game_map.map_id != 286 and 
        $game_map.map_id != 382 and $game_map.map_id != 62 and 
        $game_map.map_id != 68 and $game_map.map_id != 335 and 
        $game_map.map_id != 76 and $game_map.map_id != 117 and 
        $game_map.map_id != 155 and $game_map.map_id != 175 and 
        $game_map.map_id != 176 and $game_map.map_id != 35 and 
        $game_map.map_id != 47
        if temp_map_name[1] != nil
          # 공헌도 지역 확인
          $game_map.rose_Factions
          # 아일로
          if $game_variables[157] == 1
            @map_name_en = MODIFIER + "Región Ailo (#{$game_variables[370]}, #{$game_variables[371]})" + MODIFIER
          # Falserin
          elsif $game_variables[157] == 2
            @map_name_en = MODIFIER + "Región Falserin (#{$game_variables[370]}, #{$game_variables[371]})" + MODIFIER
          # Serat
          elsif $game_variables[157] == 3
            @map_name_en = MODIFIER + "Región Serat (#{$game_variables[370]}, #{$game_variables[371]})" + MODIFIER
          # Base Faradel
          elsif $game_variables[157] == 4
            @map_name_en = MODIFIER + "Base Faradel (#{$game_variables[370]}, #{$game_variables[371]})" + MODIFIER
          # Krotzvaldt
          elsif $game_variables[157] == 5
            @map_name_en = MODIFIER + "Región Krotzvaldt (#{$game_variables[370]}, #{$game_variables[371]})" + MODIFIER
          # Slein
          elsif $game_variables[157] == 6
            @map_name_en = MODIFIER + "Región Slein (#{$game_variables[370]}, #{$game_variables[371]})" + MODIFIER
          # Darwin
          elsif $game_variables[157] == 7
            @map_name_en = MODIFIER + "Región Darwin (#{$game_variables[370]}, #{$game_variables[371]})" + MODIFIER
          # Bailas
          elsif $game_variables[157] == 8
            @map_name_en = MODIFIER + "Región Bailas (#{$game_variables[370]}, #{$game_variables[371]})" + MODIFIER
          # Seraiden
          elsif $game_variables[157] == 9
            @map_name_en = MODIFIER + "Región Seraiden (#{$game_variables[370]}, #{$game_variables[371]})" + MODIFIER
          # Horipel
          elsif $game_variables[157] == 10
            @map_name_en = MODIFIER + "Región Horipel (#{$game_variables[370]}, #{$game_variables[371]})" + MODIFIER
          # Dorwein
          elsif $game_variables[157] == 11
            @map_name_en = MODIFIER + "Región Dorwein (#{$game_variables[370]}, #{$game_variables[371]})" + MODIFIER
          # Bosque de Hasala
          elsif $game_variables[157] == 12
            @map_name_en = MODIFIER + "Bosque de Hasala (#{$game_variables[370]}, #{$game_variables[371]})" + MODIFIER
          else
            @map_name_en = MODIFIER + "(#{$game_variables[370]}, #{$game_variables[371]})" + MODIFIER
          end
        end
      end
    end
    
    # 숲, 강가 소유권 좌표 확인
    tex_ro_map_xy = $game_map.display_name.split("(")
    if tex_ro_map_xy[1] != nil
      tex_ro_map_xy_2 = tex_ro_map_xy[1].to_s
      tex_ro_map_xy = tex_ro_map_xy_2.split(")")
      $game_variables[373] = tex_ro_map_xy[0].to_s
    end
    
    # 지금 맵 아이디를 저장해서 새로고침이 안되도록 한다.
    @map_id_name = $game_map.display_name # $game_map.map_id
    
    #print("맵 이름 관련 + Window_MapNamePlus - %s \n" % [$game_variables[373]])
  end
  
  def draw_map_name
    self.z = 1130
    set_line_position
    set_line_width
    temp_line_rect = Rect.new(@line_x, @line_y, set_line_width, LINE_HEIGHT)
    draw_line(temp_line_rect)
    temp_name_rect_ch = Rect.new(0, 0, contents.width, FONT_SIZE_CH)
    contents.font.name = FONT_NAME_CH
    contents.font.size = FONT_SIZE_CH
    draw_text(temp_name_rect_ch, @map_name_ch, 1)
    temp_name_rect_en = Rect.new(0, FONT_SIZE_CH, contents.width, FONT_SIZE_EN)
    contents.font.size = FONT_SIZE_EN
    contents.font.name = FONT_NAME_EN
    draw_text(temp_name_rect_en, @map_name_en, 1)
  end
  
  def set_line_width
    text_width_ch = text_size(@map_name_ch).width * 1.5
    text_width_en = text_size(@map_name_en).width * 1.5
    (text_width_ch >= text_width_en) ? text_width_ch : text_width_en
  end
  
  def set_line_position
    @line_x = (contents.width - set_line_width) / 2
    @line_y = (contents.height - LINE_HEIGHT) / 2
  end
  
  def color1
    Color.new(255, 255, 255, 255)
  end
  
  def color2
    Color.new(255, 255, 255, 0)
  end
end