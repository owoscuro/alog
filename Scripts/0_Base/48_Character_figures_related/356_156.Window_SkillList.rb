# encoding: utf-8
# Name: 156.Window_SkillList
# Size: 457
class Window_SkillList < Window_Selectable
  alias include_noshow_original include?
  def include?(item)
    return false if item.note_field.include?(:noshow)
    include_noshow_original(item)
  end
  
  def draw_item(index)
    skill = @data[index]
    return if skill.nil?
    rect = item_rect(index)
    rect.width -= 4
    draw_item_name(skill, rect.x, rect.y, enable?(skill), rect.width - 24)
    draw_skill_cost(rect, skill)
  end
end