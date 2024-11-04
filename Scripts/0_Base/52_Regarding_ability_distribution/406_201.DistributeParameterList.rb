# encoding: utf-8
# Name: 201.DistributeParameterList
# Size: 2804
# encoding: utf-8
# Name: 201.DistributeParameterList
# Size: 2759
class Window_DistributeParameterList < Window_Selectable
  attr_accessor :actor
  def initialize(actor)
    off_h = line_height + 48
    super(0, off_h, 286, Graphics.height - off_h)
    @actor = actor
    refresh
    self.index = 0
  end
  
  def parameter_key
    return @data[self.index]
  end
  
  def item_max
    return @data == nil ? 0 : @data.size
  end
  
  def page_row_max
    return super - 1
  end
  
  def item_rect(index)
    rect = super(index)
    rect.y += line_height
    return rect
  end
  
  def cursor_pagedown
    return if Input.repeat?(Input::R)
    super
  end
  
  def cursor_pageup
    return if Input.repeat?(Input::L)
    super
  end
  
  def refresh
    @gain_list = @actor.gain_parameter_list
    @data = []
    @gain_list.each { |gain| @data << gain.key }
    @item_max = @data.size + 1
    create_contents
    @item_max -= 1
    draw_caption
    @item_max.times { |i| draw_item(i, @actor.can_distribute?(@data[i])) }
  end
  
  def draw_caption
    change_color(system_color)
	draw_text(7, 0, contents.width, line_height, "Name", 0)
	draw_text(0, 0, contents.width, line_height, Vocab.rp, 1)
	draw_text(0, 0, contents.width - 7, line_height, "Repartos", 2)
    change_color(normal_color)
  end
  
  def draw_item(index, enabled = true)
    rect = item_rect(index)
    contents.clear_rect(rect)
    item = @data[index]
    if item != nil
      draw_parameter(rect.x, rect.y, @data[index], enabled)
    end
  end
  
  def draw_parameter(x, y, param, enabled)
    gain = @gain_list.find { |v| v.key == param }
    return if gain == nil

    change_color(normal_color)
    contents.font.color.alpha = enabled ? 255 : 128
    draw_text(4, y, contents.width, line_height, gain.name, 0)

    # 비용 그리기
    value = @actor.distribute_cost(param)
    draw_text(0, y, contents.width, line_height, value, 1)
    
    # 분배 횟수 그리기
    if gain.limit > 0
      value = sprintf("%3d/%3d", @actor.distributed_count(param), gain.limit)
    else
      value = sprintf("%3d%s", @actor.distributed_count(param),
        KMS_DistributeParameter::HIDE_MAX_COUNT_INFINITE ? "" : "/---")
    end
    draw_actor_distribute_gauge(@actor, param, x + 170, y, 80)
    draw_text(0, y, contents.width - 7, line_height, value, 2)
    
    change_color(normal_color)
  end
  
  def process_handling
    super
    call_handler(:increase) if handle?(:increase) && Input.repeat?(:RIGHT)
    call_handler(:decrease) if handle?(:decrease) && Input.repeat?(:LEFT)
    call_handler(:up)       if handle?(:up)       && Input.repeat?(:UP)
    call_handler(:down)     if handle?(:down)     && Input.repeat?(:DOWN)
  end
end