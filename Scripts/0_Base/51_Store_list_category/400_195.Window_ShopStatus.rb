# encoding: utf-8
# Name: 195.Window_ShopStatus
# Size: 3272
class Window_ShopStatus < Window_Base
  alias :bm_shop_init :initialize
  def initialize(x, y, width, height)
    @walk = 0
    @step = 0
    @animtime = 0
    @e_images = {}
    bm_shop_init(x, y, width, height)
  end
  
  if Theo::LimInv::Display_ItemSize
    alias theo_liminv_draw_posses draw_possession
    def draw_possession(x, y)
      theo_liminv_draw_posses(x,y)
    end
  end
  
  def page_size; member_size; end
  
  def member_size
    ms = $game_party.max_battle_members
    minh = BM::SHOP::ACTOR_OPTIONS[:image_height]
    loop do
      maxh = (contents.height - line_height*1.5)/ ms
      if maxh >= minh; return ms; end
      ms -= 1
    end
    return ms
  end
  
  def col_height; (contents.height - line_height*1.5) / page_size + 10; end
  
  def draw_equip_info(x, y)
    shown = BM::SHOP::PARAM_SHOWN; size = 0
    for id in shown; size += 1; end      
    width = (contents.width - 32)/size
    dx = 0
    width -= 20
    x += 110
    y += 6
    contents.font.size = BM::SHOP::PARAM_FONT_SIZE
    status_members.each_with_index do |actor, i|
    draw_actor_equip_info(x, y * i + 95, actor)
    end
    reset_font_settings
  end
  
  def draw_actor_equip_info(dx, dy, actor)
    enabled = actor.equippable?(@item)
    change_color(normal_color, enabled)
    item1 = current_equipped_item(actor, @item.etype_id)
    iwidth = BM::SHOP::ACTOR_OPTIONS[:image_width]
    iheight = BM::SHOP::ACTOR_OPTIONS[:image_height]
    image_rect = Rect.new(dx-5, dy+13, iwidth, iheight)
    contents.fill_rect(dx, dy, contents_width, col_height, standby_color(actor))
    draw_face2(actor, actor.face_index, dx-90, dy-29, enabled)
    contents.font.size = 22
    draw_actor_name2(actor, dx-151, dy)
    y = (iheight - line_height)/2
    draw_actor_param_change(dx, dy + y + 3, actor, item1) if enabled
  end
  
  def draw_actor_param_change(x, y, actor, item1)
    shown = BM::SHOP::PARAM_SHOWN; size = 0
    for id in shown; size += 1; end      
    width = (contents.width-32)/size
    dx = 0
    width -= 20
    x += 30
    for id in shown
      status_members.each_with_index do |actor, i|
        icon1 = BM::SHOP::PARAM_ICONS[id]
        draw_icon(icon1, x + 14 + width * dx, y - 10 - line_height)
      end
      if @item == item1
        draw_text(x, y + 1, contents.width - x, line_height, BM::SHOP::ITEM_EQUIPPED, 1)
        return
      end
      change = actor_param_change_value(actor, item1, id)
      change_color(param_change_color(change))
      text = change.group
      text = "+" + text if change >= 0
      text = "-" if change == 0
      draw_icon(Icon.param_compare(change), x + width * dx, y + 1) if $imported[:bm_icon]  
      draw_text(x + width * dx, y + 1, width, line_height, text, 1)
      dx += 1
    end
  end
  
  def actor_param_change_value(actor, item1, id)
    n = @item.params[id] - (item1 ? item1.params[id] : 0)
    return n unless $imported["YEA-EquipDynamicStats"]
    n += @item.per_params[id] * actor.param_base(id) rescue 0
    n += $game_variables[@item.var_params[id]] rescue 0
    n -= item1.per_params[id] * actor.param_base(id) rescue 0
    n -= $game_variables[item1.var_params[id]] rescue 0
    return n
  end
end