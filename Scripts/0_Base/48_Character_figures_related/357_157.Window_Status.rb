# encoding: utf-8
# Name: 157.Window_Status
# Size: 1773
class Window_Status < Window_Selectable
  def draw_exp_info(x, y)
    s1 = @actor.max_level? ? "?" : @actor.exp
    s2 = @actor.max_level? ? "?" : @actor.next_level_exp - @actor.exp
    s_next = sprintf(Vocab::ExpNext, Vocab::level)
    change_color(system_color)
    draw_text(x, y + line_height * 0, 180, line_height, Vocab::ExpTotal)
    draw_text(x, y + line_height * 2, 180, line_height, s_next)
    change_color(normal_color)
    s1 = s1.group if s1.is_a?(Integer)
    s2 = s2.group if s2.is_a?(Integer)
    draw_text(x, y + line_height * 1, 180, line_height, s1, 2)
    draw_text(x, y + line_height * 3, 180, line_height, s2, 2)
  end
  
  def draw_basic_info(x, y)
    draw_actor_level(@actor, x, y + line_height * 0)
    draw_actor_icons(@actor, x, y + line_height * 1)
    draw_actor_hp(@actor, x, y + line_height * 2)
    draw_actor_exp(@actor, x, y + line_height * 3, 124)
  end
  
  def draw_parameters(x, y)
    4.times {|i| draw_actor_param(@actor, x, y + line_height * i, i + 2) }
    draw_extra_bonus(x, y + line_height * 4)
  end

  def draw_extra_bonus(x, y)
    change_color(power_up_color)
    2.times do |i|
      item = @actor.equips[i+1]
      next unless item
      next unless item.note[/<desc\s*:\s*(.+)>/]
      text = $1.to_s
      draw_text(x, y, contents.width, line_height, text)
      y += line_height
    end if @actor
    change_color(normal_color)
  end

  def draw_actor_class(actor, x, y, width = 190)
    change_color(normal_color)
    #draw_text(x, y, width, line_height, actor.class.name)
    actor.nickname = actor.class.name if actor.nickname == ""
    text = sprintf("%s(%s)", actor.nickname, "#{(actor.repute).to_i}"+"점")
    draw_text(x, y, width, line_height, text)
  end
end