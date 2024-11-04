# encoding: utf-8
# Name: 178.Window_MenuLimInv
# Size: 1692
class Window_MenuLimInv < Window_Base
  def initialize(width)
    super(0,0,width,fitting_height(1))
    refresh
  end
  
  def refresh
    contents.clear
    change_color(system_color)
    txt = Theo::LimInv::SlotVocabShort
    draw_text(0,0,contents.width,line_height,txt)
    draw_inv_slot(0,0)
    # 아이템 수량 표기 실험
    draw_item_max_size(0,0)
  end
end

class Window_FreeSlot < Window_Base
  def initialize(x,y,width)
    super(x,y,width,fitting_height(1))
    refresh
  end

  def refresh
    contents.clear
    print("179.Window_FreeSlot - 무게 제한 표기 갱신 \n");
    draw_inv_info(0,0)
  end
end

# 무게 제한, 무게 표기
class Window_ItemSize < Window_Base
  def initialize(x,y,width)
    super(x,y,width,fitting_height(1))
  end

  def set_item(item)
    @item = item
    refresh 
  end
  
  def refresh
    contents.clear
    # 무게 제한, 무게 표기, 소지금 통합 실험
    print("180.Window_ItemSize - 무게 제한, 표기, 소지금 갱신 \n");
    draw_inv_info(10,0,contents.width/3-60)
    draw_item_size(@item,contents.width/3+10,0,true,contents.width/3-60)
    draw_currency_value($game_party.gold,"",contents.width/3*2,0,contents.width/3-10,1)
  end
end

# 무게 제한, 무게 표기 없는 창
class Window_ItemSize2 < Window_Base
  
  def initialize(x,y,width)
    super(x,y,width,fitting_height(1))
  end

  def set_item(item)
    @item = item
    refresh 
  end
  
  def refresh
    contents.clear
    print("181.Window_ItemSize2 - 소지금 갱신 \n");
    draw_currency_value($game_party.gold,"",contents.width/3*2,0,contents.width/3-10,1)
  end
end