# encoding: utf-8
# Name: 223.Window_SkillLearnList
# Size: 6078
class Window_ActorCommand < Window_Command
  alias add_skill_commands_passive_battle_original add_skill_commands
  def add_skill_commands
    add_skill_commands_passive_battle_original
    BATTLE_IGNORE.each {|command| @list.delete_if {|x| x[:name] == command } }
  end
end

class Window_SkillLearnList < Window_Selectable
  attr_reader   :status_window            # 스테이터스 윈도우
  def initialize(x, y, height)
    super(x, y, window_width, height)
    @actor = nil
    @stype_id = 0
    refresh
    select(0)
  end
  
  #--------------------------------------------------------------------------
  # ● 윈도우폭의 취득
  #--------------------------------------------------------------------------
  def window_width
    Graphics.width
  end
  
  #--------------------------------------------------------------------------
  # 가온데 정렬 추가 수정
  #--------------------------------------------------------------------------
  def alignment
    return 1
  end
  
  def col_max
    # 해상도 좌표
    if Graphics.height == 640
      return 4
    elsif Graphics.height == 704
      return 3
    else
      return 3
    end
  end
  
  def item_max
    @data ? @data.size : 1
  end
  
  def item
    @data[index]
  end
  
  def current_item_enabled?
    enable?(@data[index])
  end
  
  def needpt(item_id)
    @needpt[item_id]
  end
  
  def process_ok
    if current_item_enabled?
      Sound.play_ok
      Input.update
      deactivate
      call_ok_handler
    else
      Sound.play_buzzer
    end
  end
  
  def enable?(item)
    if @actor.id != 7
      con_list = IMIR_SkillPoint::Conditions[1]
    else
      con_list = IMIR_SkillPoint::Conditions[@actor.id]
    end
    condition = []
    for i in 0..4
      condition[i] = con_list[item.id][i]
    end
    switch1 = true
    @text = ""
    if condition[1] != []
      condition[1].each { |id| 
        skill = $data_skills[id]
        switch1 = false if !@actor.skill_learn?(skill)
      }
    end
    if item != nil and switch1 == true
      @actor && needpt(item.id) <= @actor.skill_point && !@actor.skill_learn?(item)
    else
    end
  end
  
  def include?(item)
    return false unless @actor
    return false unless item
    return false if item.stype_id != @stype_id
    #return false if item.stype_id != $game_variables[381]
    
    # 튜토리얼 진행
    $game_variables[17] = 7 if $game_variables[17] == 6
    
    return true
  end
  
  def refresh
    make_item_list
    create_contents
    draw_all_items
  end
  
  def update
    super
    if @stype_id != $game_variables[381]
      @stype_id = $game_variables[381]
      refresh
      select(0)
      unselect
    end
  end
  
  def make_item_list
    @data = []
    @needpt = []
    if @actor && @actor.id != 7
      if @actor && IMIR_SkillPoint::SkillList[1]
        con_list = IMIR_SkillPoint::Conditions[1]
        IMIR_SkillPoint::SkillList[1].each { |skill_id|
          item = $data_skills[skill_id]
          if item
            if include?(item)
              # 수정 추가
              if @actor.skill_learn?(item)
                @data.push(item)
                @needpt[item.id] = con_list[item.id][0]
              else
                # 아직 안 배움
                if 100 == con_list[item.id][0]
                else
                  @data.push(item)
                  @needpt[item.id] = con_list[item.id][0]
                end
              end
            end
          end
        }
      end
    else
      if @actor && IMIR_SkillPoint::SkillList[@actor.id]
        con_list = IMIR_SkillPoint::Conditions[@actor.id]
        IMIR_SkillPoint::SkillList[@actor.id].each { |skill_id|
          item = $data_skills[skill_id]
          if item
            if include?(item)
              # 수정 추가
              if @actor.skill_learn?(item)
                @data.push(item)
                @needpt[item.id] = con_list[item.id][0]
              else
                # 아직 안 배움
                if 100 == con_list[item.id][0]
                else
                  @data.push(item)
                  @needpt[item.id] = con_list[item.id][0]
                end
              end
            end
          end
        }
      end
    end
  end
  
  def draw_item(index)
    item = @data[index]
    rect = item_rect(index)
    if @actor.skill_learn?(item)
      # 이미 배움
      draw_item_name_ok(item, rect.x, rect.y, enable?(item))
      rect.width -= 4
    else
      draw_item_name(item, rect.x, rect.y, enable?(item))
      rect.width -= 4
      if @actor.equips[0] != nil
        at_wt_1 = @actor.equips[0].wtype_id
      else
        at_wt_1 = nil
      end
      
      text_wt = "E, "
      
      sk_wt_1 = []
      sk_wt_1 << item.tool_data("Tool Wtype_1 = ").to_i
      sk_wt_1 << item.tool_data("Tool Wtype_2 = ").to_i
      sk_wt_1 << item.tool_data("Tool Wtype_3 = ").to_i
      sk_wt_1 << item.tool_data("Tool Wtype_4 = ").to_i

      sk_wt_2 = 0
      sk_wt_2 = item.tool_data("Tool Shield = ").to_i
      
      if sk_wt_2 == 1
        text_wt = "" if !@actor.equips[1].is_a?(RPG::Armor) # 방패 확인
      end
      
      sk_wt_3 = 0
      sk_wt_3 = item.tool_data("Tool Wtype_1 = ").to_i
      sk_wt_3 += item.tool_data("Tool Wtype_2 = ").to_i
      sk_wt_3 += item.tool_data("Tool Wtype_3 = ").to_i
      sk_wt_3 += item.tool_data("Tool Wtype_4 = ").to_i

      if sk_wt_3 != 0
        if !sk_wt_1.include?(at_wt_1) or at_wt_1 == nil
          text_wt = ""
        end
      end
      
      text = sprintf("%sSP %d",text_wt, needpt(item.id))
      draw_text(rect, text, 2)
    end
  end
  
  def update_help
    if @help_window
      @help_window.set_item(item)
    end
  end
  
  def actor=(actor)
    select(0)
    @actor = actor
    # 오류 보정 추가
    $game_variables[126] = @actor.id
    refresh
  end
end