# encoding: utf-8
# Name: 165.Window_EventSelect
# Size: 1756
class Window_EventSelect < Window_Selectable
  attr_reader   :participants
  
  def initialize(object)
    super(0, 0,  150, 192)
    @participants = []
    refresh(object)
    self.index = -1
    self.visible = false
    activate
  end
  
  def item
    return @data[self.index]
  end

  def refresh(object)
    self.contents.clear if self.contents != nil
    @data = []
    # 타겟 설정, 가장 가까운 적 부터 나열 실험
    di = 15
    loop do
      di -= 1
      for character in object
        if character.is_a?(Game_Event)
          if $game_player.obj_size?(character, di)
            if character.on_battle_screen? and character.enemy_ready?
              @data.push(character)
              character.target_index = @data.size - 1
              @participants.push(character)
            end
          end
        elsif character.on_battle_screen?
          next if character.battler.deadposing != nil and
          $game_map.map_id != character.battler.deadposing
          @data.push(character)
          character.target_index = @data.size - 1
          @participants.push(character)
        end
      end
      if 1 > di
        break
      end
    end
    
    @item_max = @data.size
    if @item_max > 0
      self.contents = Bitmap.new(width - 32, row_max * 26)
      for i in 0...@item_max
        draw_item(i)
      end
    end
  end

  def draw_item(index)
    item = @data[index]
    x, y = index % col_max * (120 + 32), index / col_max  * 24
    self.contents.font.name = "한컴 윤체 L"
    self.contents.font.size = 16
    self.contents.draw_text(x + 24, y, 212, 32, 'none', 0)
  end

  def item_max
    return @item_max.nil? ? 0 : @item_max 
  end
end