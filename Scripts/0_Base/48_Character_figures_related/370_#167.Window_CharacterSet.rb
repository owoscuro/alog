# encoding: utf-8
# Name: #167.Window_CharacterSet
# Size: 1988
=begin
class Window_CharacterSet < Window_Selectable
  include PearlScenes
  def initialize(x=0, y=0)
    super(x, y, 544, 156)
    refresh
    self.index = 0
    activate
  end

  def item
    return @data[self.index]
  end

  def refresh
    self.contents.clear if self.contents != nil
    @data = []
    $game_party.battle_members.each {|actor| @data.push(actor)}
    @item_max = @data.size
    if @item_max > 0
      self.contents = Bitmap.new(width - 26, row_max * 128)
      for i in 0...@item_max
        draw_item(i)
      end
    end
  end

  def draw_item(index)
    item = @data[index]
    x, y = index % col_max * (138), index / col_max  * 130
    self.contents.font.name = "한컴 윤체 L"
    self.contents.font.size = 20
    contents.fill_rect(x, y, item_width, item_height, Color.new(0, 0, 0, 0))
    draw_character(item.character_name, item.character_index, x + 22, y + 56)
    hp_color = [Color.new(115, 20, 20, 200),   Color.new(169, 43, 43,  200)]
    mp_color = [Color.new(158, 113, 229, 200),   Color.new(203, 176, 244, 200)]
    PearlKernel.draw_hp(self.contents, item, x + 4, y + 66, 96, 12, hp_color)
    PearlKernel.draw_mp(self.contents, item, x + 4, y + 86, 96, 12, mp_color)
    contents.draw_text(x - 2, y, item_width, 32, item.name, 2)
    contents.draw_text(x - 2, y + 20, item_width, 32, item.class.name, 2)
    case (item.hp.to_f / item.mhp.to_f * 100.0)
      when 0       ; text = DeathStatus
      when 1..25   ; text = BadStatus
      when 26..50  ; text = OverageStatus
      when 51..75  ; text = GoodStatus
      when 76..100 ; text = ExellentStatus
    end
    if item.state?(1)
      draw_icon($data_states[1].icon_index, x + 50, y + 100)
    end
    contents.draw_text(x + 4, y + 100, item_width, 32, text) rescue nil
  end
  
  def item_max
    return @item_max.nil? ? 0 : @item_max 
  end 
  
  def col_max
    return 4
  end
  
  def line_height
    return 130
  end
end
=end