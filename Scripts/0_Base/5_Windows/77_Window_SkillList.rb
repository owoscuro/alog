# encoding: utf-8
# Name: Window_SkillList
# Size: 5654
#==============================================================================
# ** Window_SkillList
#------------------------------------------------------------------------------
#  This window is for displaying a list of available skills on the skill window.
#==============================================================================

class Window_SkillList < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super
    @actor = nil
    @stype_id = 0
    @data = []
  end
  #--------------------------------------------------------------------------
  # * Set Actor
  #--------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    # 스킬 상세 데이터를 위해 추가
    $game_variables[126] = @actor.id
    refresh
    self.oy = 0
  end
  #--------------------------------------------------------------------------
  # * 기술 유형 ID 설정
  #--------------------------------------------------------------------------
  def stype_id=(stype_id)
    return if @stype_id == stype_id
    @stype_id = stype_id
    refresh
    self.oy = 0
  end
  #--------------------------------------------------------------------------
  # * Get Digit Count
  #--------------------------------------------------------------------------
  def col_max
    return 3
  end
  #--------------------------------------------------------------------------
  # * Get Number of Items
  #--------------------------------------------------------------------------
  def item_max
    @data ? @data.size : 1
  end
  #--------------------------------------------------------------------------
  # * Get Skill
  #--------------------------------------------------------------------------
  def item
    @data && index >= 0 ? @data[index] : nil
  end
  #--------------------------------------------------------------------------
  # * 선택 항목의 활성화 상태 가져오기
  #--------------------------------------------------------------------------
  def current_item_enabled?
    enable?(@data[index])
  end
  #--------------------------------------------------------------------------
  # * 기술 목록에 포함하시겠습니까?
  #--------------------------------------------------------------------------
  def include?(item)
    item && item.stype_id == @stype_id
  end
  #--------------------------------------------------------------------------
  # * Display Skill in Active State?
  #--------------------------------------------------------------------------
  def enable?(item)
    # 오류 수정 추가
    return false if item == nil
    
    # 커먼 이벤트 예약이 된 경우 취소
    item.effects.each {|effects| 
      return false if effects.code == 44 and $game_temp.common_event_reserved?
    }
    # 생존의 달인 스킬
    if item.id == 241 and $game_switches[106] == false
      return false
    else
      return true if @actor && @actor.usable?(item)
    end
  end
  #--------------------------------------------------------------------------
  # * Create Skill List
  #--------------------------------------------------------------------------
  def make_item_list
    @data = @actor ? @actor.skills.select {|skill| include?(skill) } : []
  end
  #--------------------------------------------------------------------------
  # * Restore Previous Selection Position
  #--------------------------------------------------------------------------
  def select_last
    select(@data.index(@actor.last_skill.object) || 0)
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    skill = @data[index]
    if skill
      rect = item_rect(index)
      rect.width -= 4
      draw_item_name(skill, rect.x, rect.y, enable?(skill))
      draw_skill_cost(rect, skill)
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Skill Use Cost
  #--------------------------------------------------------------------------
  def draw_skill_cost(rect, skill)
    if @actor.skill_tp_cost(skill) > 0 and @actor.skill_mp_cost(skill) > 0
      change_color(tp_cost_color, enable?(skill))
      draw_text(rect, @actor.skill_tp_cost(skill), 2)
      @text = text_size(@actor.skill_tp_cost(skill)).width
      rect.x -= @text + 5
      change_color(mp_cost_color, enable?(skill))
      draw_text(rect, @actor.skill_mp_cost(skill), 2)
    elsif @actor.skill_tp_cost(skill) > 0
      change_color(tp_cost_color, enable?(skill))
      draw_text(rect, @actor.skill_tp_cost(skill), 2)
    elsif @actor.skill_mp_cost(skill) > 0
      change_color(mp_cost_color, enable?(skill))
      draw_text(rect, @actor.skill_mp_cost(skill), 2)
    end
  end
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_item(item)
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    make_item_list
    create_contents
    draw_all_items
  end
end