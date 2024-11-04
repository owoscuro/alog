# encoding: utf-8
# Name: 168.Window_ActorQuickTool
# Size: 6373
class Window_ActorQuickTool < Window_Selectable
  def initialize(x = 0, y = 124, w = Graphics.width * 0.9 + 6, h = 148)
    super(x, y, w, h)
    unselect
  end
  
  def item()
    return @data[self.index]
  end
    
  def col_max()
    if Graphics.height == 544 or Graphics.height == 704
      return 3
    elsif Graphics.height == 640
      return 4
    else
      return 3
    end
  end
  
  def spacing()
    return 0
  end
  
  def refresh(actor, kind)
    self.contents.clear if self.contents != nil
    @data = []
    if kind == :weapon
      operand = $game_party.weapons
      operand.push(actor.equips[0]) if actor.equips[0] != nil
    end
    if kind == :armor
      # 이도류 배운 상태에서 보조 무기에 일반 무기 착용할 수 있도록 수정
      if actor.skill_learn?($data_skills[85])
        operand = $game_party.weapons
        operand += $game_party.armors
      else
        operand = $game_party.armors
      end
      operand.push(actor.equips[1]) if actor.equips[1] != nil
    end
    operand = $game_party.items if kind == :item
    #operand = actor.skills if kind == :skill
    
    if kind == :skill_1
      operand = []
      actor.skills.each {|i| operand.push(i) if i.stype_id == 1 or i.stype_id == 2 }
    elsif kind == :skill_2
      operand = []
      actor.skills.each {|i| operand.push(i) if i.stype_id != 1 and i.stype_id != 2 }
    end
    
    for item in operand
      if kind == :weapon
        next unless actor.equippable?(item, actor.equip_slots[0])
        next if item.etype_id > 1
      elsif kind == :armor
        next unless actor.equippable?(item, actor.equip_slots[1])
        next if item.etype_id > 1
      end
      
      unless @data.include?(item)
        next if item.tool_data("Exclude From Tool Menu = ", false) == "true"
        # 이도류 무기, 방패 착용 가능 여부 확인
        if kind == :weapon
          @ro_armo_sld = []
          item.features.each do |feature, i|
            @ro_armo_sld.push(feature.code)
          end
          if @ro_armo_sld.include?(54) and actor.equips[1] != nil
          else
            @data.push(item)
          end
        elsif kind == :armor
          @ro_armo_sld = []
          item.features.each do |feature, i|
            @ro_armo_sld.push(feature.code)
            #print("168.1 - %s \n" % [@ro_armo_sld]);
          end
          if actor.equips[0] != nil
            actor.equips[0].features.each do |feature, i|
              @ro_armo_sld.push(feature.code)
              #print("168.2 - %s \n" % [@ro_armo_sld]);
            end
          end
          if @ro_armo_sld.include?(54)
          else
            @data.push(item)
          end
        else
          @data.push(item)
        end
      end
    end
    @item_max = @data.size
    if @item_max > 0
      self.contents = Bitmap.new(width - 32, row_max * 24)
      for i in 0...@item_max
        draw_item(actor, i)
      end
    end
  end
  
  def draw_item(actor, index)
    return if @data[index] == nil
    item = @data[index]
    
    if Graphics.height == 640
      x, y = index % col_max * (self.contents.width / 4), index / col_max * 24
      x -= 3 if index % col_max == 0
      x -= 1 if index % col_max == 1
      x += 1 if index % col_max == 2
      x += 2 if index % col_max == 3
    else
      x, y = index % col_max * (self.contents.width / 3), index / col_max * 24
      x -= 3 if index % col_max == 0
      x += 3 if index % col_max == 2
    end

    self.contents.font.name = "한컴 윤체 L"
    self.contents.font.size = 20
    
    if item.is_a?(RPG::Skill) and actor != nil
      if actor.equips[0] != nil
        at_wt_1 = actor.equips[0].wtype_id
      else
        at_wt_1 = nil
      end
      
      enabled = true
      
      sk_wt_1 = []
      sk_wt_1 << item.tool_data("Tool Wtype_1 = ").to_i
      sk_wt_1 << item.tool_data("Tool Wtype_2 = ").to_i
      sk_wt_1 << item.tool_data("Tool Wtype_3 = ").to_i
      sk_wt_1 << item.tool_data("Tool Wtype_4 = ").to_i

      sk_wt_2 = 0
      sk_wt_2 = item.tool_data("Tool Shield = ").to_i
      
      if sk_wt_2 == 1 and !actor.equips[1].is_a?(RPG::Armor) # 방패 확인
        enabled = false
      end

      sk_wt_3 = 0
      sk_wt_3 = item.tool_data("Tool Wtype_1 = ").to_i
      sk_wt_3 += item.tool_data("Tool Wtype_2 = ").to_i
      sk_wt_3 += item.tool_data("Tool Wtype_3 = ").to_i
      sk_wt_3 += item.tool_data("Tool Wtype_4 = ").to_i

      if sk_wt_3 != 0
        if !sk_wt_1.include?(at_wt_1) or at_wt_1 == nil
          enabled = false
          # 만약 무기가 없는 경우, 방패 자리의 무기도 확인한다.
          if actor.equips[1] != nil and actor.equips[1].is_a?(RPG::Weapon)
            at_wt_1 = actor.equips[1].wtype_id
            if sk_wt_1.include?(at_wt_1)
              enabled = true
            end
          end
        end
      end

      draw_item_name(item, x + 3, y, enabled, self.contents.width - 3)
    else
      draw_item_name(item, x + 3, y, enabled = true, self.contents.width - 3)
    end

    # 아이템 수량 표기
    if item.is_a?(RPG::Item)
      rect = item_rect(index)
      if Graphics.height == 640
        rect.width = self.contents.width / 4 - 3
      else
        rect.width = self.contents.width / 3 - 3
      end
      draw_text(rect, sprintf("×%s",$game_party.item_number(item)), 2)
    elsif item.is_a?(RPG::Skill)
      rect = item_rect(index)
      if Graphics.height == 640
        rect.width = self.contents.width / 4 - 3
      else
        rect.width = self.contents.width / 3 - 3
      end
      if item.tp_cost > 0 and item.mp_cost > 0
        change_color(tp_cost_color)
        draw_text(rect, item.tp_cost, 2)
        @text = text_size(item.tp_cost).width
        rect.x -= @text + 5
        change_color(mp_cost_color)
        draw_text(rect, item.mp_cost, 2)
      elsif item.tp_cost > 0
        change_color(tp_cost_color)
        draw_text(rect, item.tp_cost, 2)
      elsif item.mp_cost > 0
        change_color(mp_cost_color)
        draw_text(rect, item.mp_cost, 2)
      end
      change_color(normal_color)
    end
  end

  def item_max
    return @item_max.nil? ? 0 : @item_max 
  end 
end