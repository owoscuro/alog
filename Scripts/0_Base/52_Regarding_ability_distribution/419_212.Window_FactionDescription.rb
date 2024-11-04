# encoding: utf-8
# Name: 212.Window_FactionDescription
# Size: 2968
class Window_FactionDescription < Window_Base
  attr_reader :faction
  def initialize(x,y,w,h)
    super(x,y,w,h)
  end
  
  def faction=(faction)
    @faction=faction
    # 메뉴 배경을 반투명하게 변경
    self.back_opacity = 192
    create_background
    refresh
  end
  
  # 메뉴 배경을 반투명하게 변경
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
  
  def dispose_background
    @background_sprite.dispose
  end
  
  def refresh
    contents.clear
    return unless @faction
    draw_faction_graphic if SZS_Factions::UseGraphics
    draw_faction_desc if SZS_Factions::UseDescriptions
  end
  
  def draw_faction_graphic
    return unless SZS_Factions::Factions[@faction.id][:graphic]
    gr = Cache.picture('Town/' + "#{SZS_Factions::Factions[@faction.id][:graphic]}")
    # 마을 로고 이미지 적용
    contents.stretch_blt(Rect.new(10, 10, 68, 69), gr, gr.rect, 128)
  end
  
  def mapf_format_paragraph(text, max_width = contents_width)
    text = text.clone
    real_contents = contents
    self.contents = Bitmap.new(contents_width, 24)
    reset_font_settings
    paragraph = ""
    while !text.empty?
      text.lstrip!
      oline, nline, tw = mapf_format_by_line(text.clone, max_width)
      text.sub!(/#{Regexp.escape(oline)}/m, nline)
      paragraph += text.slice!(/.*?(\n|$)/)
    end
    contents.dispose
    self.contents = real_contents
    return paragraph
  end
  
  def draw_faction_desc
    return unless SZS_Factions::Factions[@faction.id][:description]
    i = 0
    
    # 강제 줄바꿈 추가
    line = mapf_format_paragraph(SZS_Factions::Factions[@faction.id][:description], contents.width)
    
=begin
    # 각 마을의 가격 비율
    tax = []
    tax = $game_variables[158]
    
    print("212.Window_FactionDescription - %s \n" % [@faction.id]);
    
    # 구매 가격, 판매 가격
    a = 100 * (100 + $game_variables[TMPRICE::VN_BUYING_RATE] + $game_variables[170] - $game_variables[295]) / (500 - tax[@faction.id + 1][0]).to_i
    b = 100 * (100 + $game_variables[TMPRICE::VN_SELLING_RATE] + $game_variables[171] + $game_variables[295]) / (500 - tax[@faction.id + 1][1]).to_i
    
    line += sprintf("\n\n현재 해당 지역의 구매 가격 비율 %1.0f%%, 판매 가격 비율 %1.0f%%다.", a, b)
=end

    draw_text_ex(0, line_height * i, line)
    i += 1
  end
  
  def draw_line_back(x,y,w,h)
    contents.fill_rect(x,y+1,w,h-2, Color.new(0,0,0,96))
  end
  
  def split_text(txt)
    txt_splits = []
    line = ""
    txt.split.each do |word|
      line += word + " "
      if contents.text_size(line).width > width - 100
        txt_splits << line
        line = ""
      end
    end
    txt_splits << line if line.size > 0
    txt_splits
  end
end