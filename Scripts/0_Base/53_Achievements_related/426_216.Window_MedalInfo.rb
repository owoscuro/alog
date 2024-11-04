# encoding: utf-8
# Name: 216.Window_MedalInfo
# Size: 2147
class Window_MedalInfo < Window_Base
  def initialize
    super(0,0,Graphics.width,Graphics.height)
    self.opacity = 0
    self.contents_opacity = $game_party.medal_info_opacity
    self.z = 15000

    #begin # 오류 발생시 예외 처리
      refresh
    #rescue => e
    #end
  end
  
  #--------------------------------------------------------------------------
  # ● 프레임 업데이트
  #--------------------------------------------------------------------------
  def update
    super
    if $game_party.medal_info_count > 0
      self.contents_opacity += 16
      $game_party.medal_info_count -= 1
      $game_party.delete_new_medal if $game_party.medal_info_count == 0
    else
      if self.contents_opacity != 0
        self.contents_opacity -= 16
      elsif self.contents_opacity == 0
        open unless $game_party.new_medals.empty?
      end
    end
    $game_party.medal_info_opacity = self.contents_opacity
  end
  
  def open
    refresh
    TMMEDAL::SE_GAIN_MEDAL.play
    $game_party.medal_info_count = 150
    self.contents_opacity = 0
    #self
  end
  
  def refresh
    print("216.Window_MedalInfo - refresh \n");
    # 아래 원본이지만 오류 의심으로 주석 처리
    #contents.clear
    unless $game_party.new_medals.empty?
      draw_background(contents.rect)
      medal = TMMEDAL::MEDAL_DATA[$game_party.new_medals[0][0]]
      rect = contents.rect.clone
      draw_icon(medal[1], (contents.width / 2) - 26, (contents.height / 2) -8)
      rect.x += 24
      rect.width -= 24
      draw_text(contents.width / 2, (contents.height / 2) - 9, rect.width, 24, medal[0])
    end
  end
  
  def draw_background(rect)
    temp_rect = rect.clone
    temp_rect.width /= 2
    temp_rect.height = 32
    temp_rect.y = contents.height / 2 - 12
    contents.gradient_fill_rect(temp_rect, back_color2, back_color1)
    temp_rect.x = temp_rect.width
    contents.gradient_fill_rect(temp_rect, back_color1, back_color2)
  end
  
  def back_color1
    Color.new(0, 0, 0, 192)
  end
  
  def back_color2
    Color.new(0, 0, 0, 0)
  end
end