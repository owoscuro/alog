# encoding: utf-8
# Name: 024.Window_RepairCommand
# Size: 1827
class Window_RepairCommand < Window_HorzCommand
  def initialize(window_width)
    @window_width = window_width
    super(0, 0)
  end
  
  def window_width
    @window_width
  end
  
  def col_max
    return 2
  end
  
  def make_command_list
    add_command(TH_Instance::Scene_Repair::Vocab, :repair)
    add_command(Vocab::ShopCancel, :cancel)
  end
end

module TH
  module Random_Event_Positions
    # 위치를 무작위화할지 여부를 결정하는 전역 스위치.
    # 켜져 있으면 위치가 무작위로 지정되지 않습니다.
    Disable_Switch = 0
    
    # 기본적으로 무작위화 유형.
    Default_Type = :init
    
    Regex = /<random[-_ ]position[-_ ]region:\s*(v\[\d+\]|\d+)\s*(\w+)?>/i
  end
  
  module Map_Drops
    Drop_Item_Key = :C        # 아이템을 떨어뜨릴 때 사용하는 키
  end
end

class Window_Base < Window
  def draw_item_name(item, x, y, enabled = true, width = contents.width)
    return unless item
    draw_icon(item.icon_index, x, y, enabled)
    change_color(item.rarity_colour, enabled)
    # 아이템 이름 좌표 수정 실험
    draw_text(x + 24 + 5, y, width, line_height, item.name)
		change_color(normal_color, enabled)
  end
  
  def draw_item_name_ok(item, x, y, enabled = true, width = contents.width)
    return unless item
    draw_icon(item.icon_index, x, y, enabled)
    change_color(system_color, enabled)
    draw_text(x + 24 + 5, y, width, line_height, item.name)
		change_color(normal_color, enabled)
  end
  
  def draw_item_name_2(item, value, x, y, enabled = true, width = contents.width)
    return unless item
    draw_icon(item.icon_index, x, y, enabled)
    change_color(item.rarity_colour, enabled)
    draw_text(x + 24 + 5, y, width, line_height, "#{item.name}"+' ×'+"#{value}")
		change_color(normal_color, enabled)
  end
end