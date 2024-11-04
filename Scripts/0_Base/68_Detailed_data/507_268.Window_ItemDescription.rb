# encoding: utf-8
# Name: 268.Window_ItemDescription
# Size: 35774
# encoding: utf-8
# Name: 268.Window_ItemDescription
# Size: 37426
class Window_ItemDescription < Window_Selectable
  def initialize
    # 소지금 초과시 빨간색으로 표시 적용
    $game_switches[141] = false if $game_switches[141] == true
    super(0, 0, Graphics.width, Graphics.height)
    hide.deactivate
  end
  
  def process_handling
    super
    return unless open? && active
    # 스위치 확인 실험
    if $game_switches[TMITWIN::SW_NOUSE_ITEM_INFO] == false and !SceneManager.scene_is?(Scene_Map)
      return process_description if Input.trigger?(TMITWIN::KEY_SYMBOL) or Keyboard.trigger?(:kN)
    end
  end
  
  def process_description
    Input.update
    call_handler(:description)
  end
  
  def refresh(item = nil)
    return unless item
    contents.clear
    if item.class == RPG::Item
      refresh_item(item)
    elsif item.class == RPG::Skill
      refresh_skill(item)
    else
      refresh_equip(item)
    end
  end
  
  def refresh_item(item)
    draw_item_name(item, 4, line_height * 0, true, Graphics.width)
    draw_item_type(item, 320, line_height * 0)
    draw_horz_line(line_height * 1)
    draw_item_params(item, 32, line_height * 2)
    draw_item_effects(item, TMITWIN::FEATURE_X, line_height * 2)
  end
  
  def refresh_equip(item)
    # 1번째 설명
    draw_item_name(item, 4, line_height * 0, true, Graphics.width)
    draw_item_type(item, 320, line_height * 0)

    x = 8
    w = Graphics.width / 3 - 25
    ro_ln = 0

    contents.font.size = TMITWIN::RO_WI_FS
    draw_horz_line(line_height * 1)

    ro_l = 2
    if item.params[1] != 0
      ro_ln += 1
      ro_l += 1
      draw_equip_param(item, x, line_height * (ro_l), 1)
    end
    if item.params[2] != 0
      ro_ln += 1
      ro_l += 1
      draw_equip_param(item, x, line_height * (ro_l), 2)
    end
    if item.params[3] != 0
      ro_ln += 1
      ro_l += 1
      draw_equip_param(item, x, line_height * (ro_l), 3)
    end
    if item.params[4] != 0
      ro_ln += 1
      ro_l += 1
      draw_equip_param(item, x, line_height * (ro_l), 4)
    end
    if item.params[5] != 0
      ro_ln += 1
      ro_l += 1
      draw_equip_param(item, x, line_height * (ro_l), 5)
    end
    if item.params[6] != 0
      ro_ln += 1
      ro_l += 1
      draw_equip_param(item, x, line_height * (ro_l), 6)
    end
    if item.params[7] != 0
      ro_ln += 1
      ro_l += 1
      draw_equip_param(item, x, line_height * (ro_l), 7)
    end
    if item.params[8] != 0
      ro_ln += 1
      ro_l += 1
      draw_equip_param(item, x, line_height * (ro_l), 8)
    end
    if ro_ln > 1
      change_color(system_color)
      draw_text(x, line_height * 2, w, line_height, "Estadísticas", 0)
    else
      ro_l = 1
    end

    # 2번째, 3번째 설명 적용
    draw_equip_features(item, TMITWIN::FEATURE_X, line_height * 2)

    ro_l += 1
    
    change_color(system_color)
    draw_text(x, line_height * ro_l, w, line_height, "Información básica", 0)
    ro_l += 1
    
    change_color(normal_color)
    draw_text(x + 12, line_height * ro_l, w, line_height, "Peso")
    draw_text(x, line_height * ro_l, w, line_height, item.weight, 2)

    if item.is_a?(RPG::Weapon)
      # 무기 타입 별로 쿨타임 증가치 표기
      case item.wtype_id
      when 1; w_cr = 4 * 60   #도끼
      when 2; w_cr = 0 * 60   #너클
      when 3; w_cr = 2 * 60   #창
      when 4; w_cr = 4 * 60   #검
      when 5; w_cr = 4 * 60   #도
      when 6; w_cr = 2 * 60   #활
      when 7; w_cr = 0 * 60   #단검
      when 8; w_cr = 2 * 60   #메이스
      when 9; w_cr = 2 * 60   #지팡이
      else; w_cr = 2 * 60     #Otros
      end
      w_cr = (w_cr - (w_cr % 60))/60.to_i - 1
      w_cr = 0 if 1 > w_cr
      ro_l += 1
	  draw_text(x + 12, line_height * ro_l, w, line_height, "Tiempo de reutilización adicional")
	  draw_text(x, line_height * ro_l, w, line_height, "#{w_cr.to_i} segundos", 2)
	end
	if item.item_max != 0
	  ro_l += 1
	  draw_text(x + 12, line_height * ro_l, w, line_height, "Cantidad máxima")
	  draw_text(x, line_height * ro_l, w, line_height, item.item_max, 2)
	end
	if item.equip_temper != 0
	  ro_l += 1
	  draw_text(x + 12, line_height * ro_l, w, line_height, "Resistencia al frío")
	  draw_text(x, line_height * ro_l, w, line_height, item.equip_temper, 2)
	end
	if (100 - item.equip_sexy) != 100
	  ro_l += 1
	  draw_text(x + 12, line_height * ro_l, w, line_height, "Exposición")
	  draw_text(x, line_height * ro_l, w, line_height, (100 - item.equip_sexy), 2)
	end
	if item.tool_data("Tool Guard Rate = ") != 0 and item.tool_data("Tool Guard Rate = ") != nil
	  ro_l += 1
	  draw_text(x + 12, line_height * ro_l, w, line_height, "Probabilidad de defensa exitosa")
	  draw_text(x, line_height * ro_l, w, line_height, "#{item.tool_data("Tool Guard Rate = ")}%", 2)
	end
	if item.tool_data("Tool Blow Power = ") != nil
	  ro_l += 1
	  draw_text(x + 12, line_height * ro_l, w, line_height, "Poder de empuje")
	  draw_text(x, line_height * ro_l, w, line_height, item.tool_data("Tool Blow Power = "), 2)
	end
	if item.tool_data("Tool Stop Move = ") != nil
	  ro_l += 1
	  draw_text(x + 12, line_height * ro_l, w, line_height, "Tiempo de inactividad")
	  draw_text(x, line_height * ro_l, w, line_height, "#{(item.tool_data("Tool Stop Move = ") * 1.0 / 20).round(1)} segundos", 2)
	end
	if item.price != 0
	  ro_l += 1
	  ro_item_price = item.price
	  draw_text(x + 12, line_height * ro_l, w, line_height, "Precio medio")
	  draw_currency_value(ro_item_price, Vocab::currency_unit, x, line_height * ro_l, w, 4)
	end
	end

	def refresh_skill(item)
	  draw_item_name(item, 4, line_height * 0, true, Graphics.width)
	  draw_item_type(item, 320, line_height * 0)
	  draw_horz_line(line_height * 1)
	  draw_skill_params(item, 32, line_height * 2)
	  draw_item_effects(item, TMITWIN::FEATURE_X, line_height * 2)
	end

	def draw_item_type(item, x, y)
	  if item.class == RPG::Item
		text = item.itype_id == 1 ? Vocab.item : Vocab.key_item
	  elsif item.class == RPG::Weapon
		text = sprintf("%s [%s]", $data_system.terms.etypes[item.etype_id],
		  $data_system.weapon_types[item.wtype_id])
	  elsif item.class == RPG::Armor
		text = sprintf("%s [%s]", "Armadura",
		  $data_system.armor_types[item.atype_id])
	  elsif item.class == RPG::Skill
		text = sprintf("%s", $data_system.skill_types[item.stype_id])
	  end
	  change_color(normal_color)
	  draw_text(x, y, contents.width - x, line_height, text)
	end
  
  def draw_item_params(item, x, y)
    # 튜토리얼 진행
    $game_variables[17] = 4 if $game_variables[17] == 3
    
    # 1번째 설명
    x = 8
    w = Graphics.width / 3 - 25

    contents.font.size = TMITWIN::RO_WI_FS
    
	y3 = 2
	change_color(system_color)
	draw_text(x, line_height * y3, w, line_height, "Información básica", 0)

	change_color(normal_color)
	y3 += 1
	draw_text(x + 12, line_height * y3, w, line_height, "Consumible")
	draw_text(x, line_height * y3, w, line_height, (item.consumable ? "O" : "X"), 2)

	y3 += 1
	draw_text(x + 12, line_height * y3, w, line_height, "Peso")
	draw_text(x, line_height * y3, w, line_height, item.weight, 2)

	y3 += 1
	draw_text(x + 12, line_height * y3, w, line_height, "Cantidad máxima")
	draw_text(x, line_height * y3, w, line_height, item.item_max, 2)

	y3 += 1
	draw_text(x + 12, line_height * y3, w, line_height, "Probabilidad de éxito")
	draw_text(x, line_height * y3, w, line_height, sprintf("%d%%", item.success_rate), 2)

	if item.tool_data("Tool Size = ") != nil
	  y3 += 1
	  draw_text(x + 12, line_height * y3, w, line_height, "Tamaño del ataque")
	  draw_text(x, line_height * y3, w, line_height, item.tool_data("Tool Size = "), 2)
	end

	if item.damage.type > 0
	  y3 += 1
	  draw_text(x + 12, line_height * y3, w, line_height, "Elemento de ataque")
	  if item.damage.element_id > 0
		text = sprintf("%s", $data_system.elements[item.damage.element_id])
	  end
	  draw_text(x, line_height * y3, w, line_height, text, 2)
	end

	if item.tool_data("Tool Distance = ") != nil
	  if item.tool_data("Tool Distance = ") >= 1
		y3 += 1
		draw_text(x + 12, line_height * y3, w, line_height, "Distancia de movimiento")
		draw_text(x, line_height * y3, w, line_height, item.tool_data("Tool Distance = "), 2)
	  end
	end

	if item.tool_data("Tool Blow Power = ") != nil
	  if item.tool_data("Tool Blow Power = ") >= 1
		y3 += 1
		draw_text(x + 12, line_height * y3, w, line_height, "Poder de empuje")
		draw_text(x, line_height * y3, w, line_height, item.tool_data("Tool Blow Power = "), 2)
	  end
	end

	if item.tool_data("Tool Stop Move = ") != nil
	  if item.tool_data("Tool Stop Move = ") >= 1
		y3 += 1
		draw_text(x + 12, line_height * y3, w, line_height, "Tiempo de inactividad")
		draw_text(x, line_height * y3, w, line_height, "#{(item.tool_data("Tool Stop Move = ") * 1.0 / 20).round(1)} segundos", 2)
	  end
	end

	if item.tool_data("Tool Self Damage = ") == true
	  y3 += 1
	  draw_text(x + 12, line_height * y3, w, line_height, "Daño a uno mismo")
	  draw_text(x, line_height * y3, w, line_height, "O", 2)
	end
    
    if item.price != 0
      y3 += 1
      #rate = (100 + $game_variables[TMPRICE::VN_BUYING_RATE] + $game_variables[170] - $game_variables[295]) / 100
      #ro_item_price = (item.price * rate).round
      ro_item_price = item.price
      draw_text(x + 12, line_height * y3, w, line_height, "Precio promedio")
      draw_currency_value(ro_item_price, Vocab::currency_unit, x, line_height * y3, w, 4)
    end
  end
  
  def draw_equip_param(item, x, y, param_id)
    w = Graphics.width / 3 - 25
    change_color(normal_color)
    draw_text(x + 12, y, w, line_height, Vocab::param(param_id), 0)
    change_color(normal_color)
    draw_text(x, y, w, line_height, item.params[param_id], 2)
  end
  
  def draw_skill_params(item, x, y)
    # 1번째 설명
    x = 8
    w = Graphics.width / 3 - 25
    y3 = 2

    #print("077.아이템, 스킬 상세 데이터 - %s \n" % [$game_variables[126]])
    
    contents.font.size = TMITWIN::RO_WI_FS
    
	change_color(system_color)
	draw_text(x, line_height * y3, w, line_height, "Información básica", 0)

	change_color(normal_color)
	mp_cost = item.mp_cost
	tp_cost = item.tp_cost

	if $tmscripts["skcost"] and item.hp_cost >= 1
	  y3 += 1
	  draw_text(x + 12, line_height * y3, w, line_height, "Costo de HP")
	  draw_text(x, line_height * y3, w, line_height, item.hp_cost, 2)
	end
	if mp_cost >= 1
	  y3 += 1
	  if $game_actors[$game_variables[126]].mmp >= mp_cost
		change_color(normal_color)
		draw_text(x + 12, line_height * y3, w, line_height, "Costo de MP")
		draw_text(x, line_height * y3, w, line_height, mp_cost, 2)
	  else
		change_color(text_color(10))
		draw_text(x + 12, line_height * y3, w, line_height, "Costo de MP")
		draw_text(x, line_height * y3, w, line_height, mp_cost, 2)
		change_color(normal_color)
	  end
	end
	if item.tool_data("Tool Special = ", false) == "hillwind"
	  y3 += 1
	  draw_text(x + 12, line_height * y3, w, line_height, "Costo de TP, costo de TP por segundo")
	  draw_text(x, line_height * y3, w, line_height, "#{tp_cost}, 1", 2)
	elsif tp_cost >= 1
	  y3 += 1
	  draw_text(x + 12, line_height * y3, w, line_height, "Costo de TP")
	  draw_text(x, line_height * y3, w, line_height, tp_cost, 2)
	end

	if item.tool_data("Tool Cast Time = ") != nil
	  if item.tool_data("Tool Cast Time = ") >= 1
		y3 += 1
		draw_text(x + 12, line_height * y3, w, line_height, "Tiempo de lanzamiento")
		draw_text(x, line_height * y3, w, line_height, "#{(item.tool_data("Tool Cast Time = ") * 1.0 / 30).round(1)} segundos", 2)
	  end
	end
    
    if item.tool_data("Tool Cooldown = ") != nil
      if item.tool_data("Tool Cooldown = ") >= 1
        y3 += 1
        draw_text(x + 12, line_height * y3, w, line_height, "Tiempo de reutilización base")
        w_cr = item.tool_data("Tool Cooldown = ")
        # 해당 캐릭터의 민첩, 공격 속도 만큼 공격속도 감소
        #@ro_atk_speed = (100 + $game_actors[$game_variables[126]].atk_speed - ($game_actors[$game_variables[126]].param(6)*0.01)).to_f / 100
        #w_cr = w_cr * @ro_atk_speed
        w_cr = (w_cr - (w_cr % 60))/60.to_i - 1
        w_cr = 0 if 1 > w_cr
        draw_text(x, line_height * y3, w, line_height, "#{w_cr.to_i} segundos", 2)
      end
    end
    
    if $game_actors[$game_variables[126]].equips[0] != nil
      if item.tool_data("Tool Cooldown = ") != nil
        if item.tool_data("Tool Cooldown = ") >= 1
          y3 += 1
          draw_text(x + 12, line_height * y3, w, line_height, "Tiempo de reutilización final")
          w_cr = item.tool_data("Tool Cooldown = ")
          # 해당 캐릭터의 민첩, 공격 속도 만큼 공격속도 감소
          @ro_atk_speed = (100 + $game_actors[$game_variables[126]].atk_speed - ($game_actors[$game_variables[126]].param(6)*0.01)).to_f / 100
          w_cr = w_cr * @ro_atk_speed
          case $game_actors[$game_variables[126]].equips[0].wtype_id
          when 1; w_cr += 4 * 60   # 도끼
          when 2; w_cr += 0 * 60   #너클
            w_cr -= 60 if $game_actors[$game_variables[126]].skill_learn?($data_skills[460])
            w_cr -= 60 if $game_actors[$game_variables[126]].skill_learn?($data_skills[461])
            w_cr -= 60 if $game_actors[$game_variables[126]].skill_learn?($data_skills[462])
            w_cr -= 60 if $game_actors[$game_variables[126]].skill_learn?($data_skills[463])
            w_cr -= 60 if $game_actors[$game_variables[126]].skill_learn?($data_skills[464])
          when 3; w_cr += 2 * 60   #창
          when 4; w_cr += 4 * 60   #검
          when 5; w_cr += 4 * 60   #도
          when 6; w_cr += 2 * 60   #활
          when 7; w_cr += 0 * 60   #단검
          when 8; w_cr += 2 * 60   #메이스
          when 9; w_cr += 2 * 60   #지팡이
          else; w_cr += 2 * 60     #Otros
          end
          # 쿨타임 감소 스킬
          w_cr -= 60 if $game_actors[$game_variables[126]].skill_learn?($data_skills[322])
          w_cr -= 60 if $game_actors[$game_variables[126]].skill_learn?($data_skills[323])
          
          w_cr = (w_cr - (w_cr % 60))/60.to_i - 1
          w_cr = 0 if 1 > w_cr
          draw_text(x, line_height * y3, w, line_height, "#{w_cr.to_i} segundos", 2)
        end
      end
    end
    
	if item.tool_data("Tool Item Cost = ") != nil and $data_items[item.tool_data("Tool Item Cost = ")] != nil
	  y3 += 1
	  if $game_party.item_number($data_items[item.tool_data("Tool Item Cost = ").to_i]) >= 1
		change_color(normal_color)
		draw_text(x + 12, line_height * y3, w, line_height, "Ítem consumido")
		draw_text(x, line_height * y3, w, line_height, $data_items[item.tool_data("Tool Item Cost = ").to_i].name, 2)
	  else
		change_color(text_color(10))
		draw_text(x + 12, line_height * y3, w, line_height, "Ítem consumido")
		draw_text(x, line_height * y3, w, line_height, $data_items[item.tool_data("Tool Item Cost = ").to_i].name, 2)
		change_color(normal_color)
	  end
	end

	y3 += 1
	draw_text(x + 12, line_height * y3, w, line_height, "Tasa de éxito")
	draw_text(x, line_height * y3, w, line_height, sprintf("%d%%", item.success_rate), 2)

	if item.tool_data("Tool Size = ") != nil
	  y3 += 1
	  draw_text(x + 12, line_height * y3, w, line_height, "Tamaño del ataque")
	  draw_text(x, line_height * y3, w, line_height, item.tool_data("Tool Size = "), 2)
	end

	if item.damage.type > 0
	  y3 += 1
	  draw_text(x + 12, line_height * y3, w, line_height, "Elemento de ataque")
	  if item.damage.element_id > 0
		text = sprintf("%s", $data_system.elements[item.damage.element_id])
	  end
	  draw_text(x, line_height * y3, w, line_height, text, 2)
	end

	if item.tool_data("Tool Distance = ") != nil
	  if item.tool_data("Tool Distance = ") >= 1
		y3 += 1
		draw_text(x + 12, line_height * y3, w, line_height, "Distancia de movimiento")
		draw_text(x, line_height * y3, w, line_height, item.tool_data("Tool Distance = "), 2)
	  end
	end

	if item.tool_data("Tool Blow Power = ") != nil
	  if item.tool_data("Tool Blow Power = ") >= 1
		y3 += 1
		draw_text(x + 12, line_height * y3, w, line_height, "Poder de empuje")
		draw_text(x, line_height * y3, w, line_height, item.tool_data("Tool Blow Power = "), 2)
	  end
	end

	if item.tool_data("Tool Stop Move = ") != nil
	  if item.tool_data("Tool Stop Move = ") >= 1
		y3 += 1
		draw_text(x + 12, line_height * y3, w, line_height, "Tiempo de inactividad")
		draw_text(x, line_height * y3, w, line_height, "#{(item.tool_data("Tool Stop Move = ") * 1.0 / 20).round(1)} segundos", 2)
	  end
	end

	if item.tool_data("Tool Self Damage = ") == true
	  y3 += 1
	  draw_text(x + 12, line_height * y3, w, line_height, "Daño a uno mismo")
	  draw_text(x, line_height * y3, w, line_height, "O", 2)
	end

    con_list = IMIR_SkillPoint::Conditions[7]
    condition = []
    for i in 0..4
      condition[i] = con_list[item.id][i]
    end
    switch1 = true
    @text = ""
    @text2 = ""
    @text3 = ""
    @text4 = ""
    @type_name = ""
    if condition[1] != []
      condition[1].each { |id| 
        skill = $data_skills[id]
        if $game_actors[$game_variables[126]].skill_learn?($data_skills[id])
          if @text == ""
            @text += skill.name
            @type_name = $data_system.skill_types[$data_skills[id].stype_id]
            @text += ' (' + "#{@type_name}" + ')'
          else
            @text += ", " + skill.name
            @type_name = $data_system.skill_types[$data_skills[id].stype_id]
            @text += ' (' + "#{@type_name}" + ')'
          end
        else
          if @text2 == ""
            @text2 += skill.name
            @type_name = $data_system.skill_types[$data_skills[id].stype_id]
            @text2 += ' (' + "#{@type_name}" + ')'
          else
            @text2 += ", " + skill.name
            @type_name = $data_system.skill_types[$data_skills[id].stype_id]
            @text2 += ' (' + "#{@type_name}" + ')'
          end
        end
      }
    end
      if $game_actors[$game_variables[126]].skill_wtype_ok?($data_skills[item.id])
        @text3 = "가능"
      else
        @text3 = "불가능"
      end
      wtype_id1 = item.tool_data("Tool Wtype_1 = ").to_i
      wtype_id2 = item.tool_data("Tool Wtype_2 = ").to_i
      wtype_id3 = item.tool_data("Tool Wtype_3 = ").to_i
      wtype_id4 = item.tool_data("Tool Wtype_4 = ").to_i
      atype_id1 = item.tool_data("Tool Shield = ").to_i
      if wtype_id1 > 0 or wtype_id2 > 0 or wtype_id3 > 0 or wtype_id4 > 0 or atype_id1 > 0
        if atype_id1 == 0
          @text4 += sprintf("%s%s%s%s%s%s%s",
          $data_system.weapon_types[wtype_id1] ||= "",
          wtype_id1 > 0 && wtype_id2 > 0 ? ", " : "",
          $data_system.weapon_types[wtype_id2] ||= "",
          wtype_id2 > 0 && wtype_id3 > 0 ? ", " : "",
          $data_system.weapon_types[wtype_id3] ||= "",
          wtype_id3 > 0 && wtype_id4 > 0 ? ", " : "",
          $data_system.weapon_types[wtype_id4] ||= "")
        elsif atype_id1 == 1
          @text4 += sprintf("%s%s%s%s%s%s%s%sUsar escudo",
          $data_system.weapon_types[wtype_id1] ||= "",
          wtype_id1 > 0 && wtype_id2 > 0 ? ", " : "",
          $data_system.weapon_types[wtype_id2] ||= "",
          wtype_id2 > 0 && wtype_id3 > 0 ? ", " : "",
          $data_system.weapon_types[wtype_id3] ||= "",
          wtype_id3 > 0 && wtype_id4 > 0 ? ", " : "",
          $data_system.weapon_types[wtype_id4] ||= "",
          wtype_id1 + wtype_id2 + wtype_id3 + wtype_id4 > 0 ? " / " : "")
        elsif atype_id1 == 2
          @text4 += sprintf("%s%s%s%s%s%s%s%sNo usar escudo", 
          $data_system.weapon_types[wtype_id1] ||= "",
          wtype_id1 > 0 && wtype_id2 > 0 ? ", " : "",
          $data_system.weapon_types[wtype_id2] ||= "",
          wtype_id2 > 0 && wtype_id3 > 0 ? ", " : "",
          $data_system.weapon_types[wtype_id3] ||= "",
          wtype_id3 > 0 && wtype_id4 > 0 ? ", " : "",
          $data_system.weapon_types[wtype_id4] ||= "",
          wtype_id1 + wtype_id2 + wtype_id3 + wtype_id4 > 0 ? " / " : "")
        end
      end
    if @text != "" or @text2 != ""
      # 3번째 설명
      y3 += 2

      x = 8
      change_color(system_color)
      draw_text(x, line_height * y3, w, line_height, "Habilidades previas necesarias", 0)
      
      y3 += 1
      if @text != ""
        change_color(normal_color)
        if @text2 != ""
          draw_text(x + 12, line_height * y3, text_size(@text).width + 12, line_height, "#{@text}" + ',')
        else
          draw_text(x + 12, line_height * y3, text_size(@text).width + 12, line_height, @text)
        end
      end
      if @text2 != ""
        change_color(text_color(10))
        if @text != ""
          draw_text(x + 22 + text_size(@text).width, line_height * y3, text_size(@text2).width + 22, line_height, @text2)
        else
          draw_text(x + 12 + text_size(@text).width, line_height * y3, text_size(@text2).width + 12, line_height, @text2)
        end
      end
    end
    if @text4 != ""
      # 3번째 설명
      y3 += 2
      x = 8
      change_color(system_color)
      draw_text(x, line_height * y3, w, line_height, "Condiciones de equipo necesarias", 0)
      y3 += 1
      if @text3 == "가능"
        change_color(normal_color)
      else
        change_color(text_color(10))
      end
      draw_text(x + 12, line_height * y3, Graphics.width, line_height, @text4)
    end
  end
  
  def draw_base_price(item, x, y)
    w = Graphics.width / 3 - 25
    change_color(system_color)
    draw_text(x, y, w, line_height, "Precio base")
    n = item.price
    draw_currency_value(n, Vocab::currency_unit, x, y + line_height, w, 4)
  end
  
  def draw_item_effects(item, x, y)
    # 3번째 설명
    x = Graphics.width / 3 * 2
    y2 = y
    w = Graphics.width / 3 - 25
    contents.font.size = TMITWIN::RO_WI_FS
    change_color(system_color)
	draw_text(x, y2, w, line_height, "Funciones fisiológicas", 0)
	change_color(normal_color)
	# Mostrar necesidades básicas
	if item.hunger != 0
	  draw_text(x + 12, y2 + line_height, w, line_height, "Hambre", 0)
	  draw_text(x, y2 + line_height, w, line_height, "#{(item.hunger.to_f / 1300 * 100).round}%", 2)
	  y2 += line_height
	end
	if item.thirst != 0
	  draw_text(x + 12, y2 + line_height, w, line_height, "Sed", 0)
	  draw_text(x, y2 + line_height, w, line_height, "#{(item.thirst.to_f / 1100 * 100).round}%", 2)
	  y2 += line_height
	end
	if item.sleep != 0
	  draw_text(x + 12, y2 + line_height, w, line_height, "Fatiga", 0)
	  draw_text(x, y2 + line_height, w, line_height, "#{(item.sleep.to_f / 900 * 100).round}%", 2)
	  y2 += line_height
	end
	if item.temper != 0
	  draw_text(x + 12, y2 + line_height, w, line_height, "Temperatura corporal", 0)
	  draw_text(x, y2 + line_height, w, line_height, "#{(item.temper.to_f / 100 * 100).round}%", 2)
	  y2 += line_height
	end
	if item.sexual != 0
	  draw_text(x + 12, y2 + line_height, w, line_height, "Deseo sexual", 0)
	  draw_text(x, y2 + line_height, w, line_height, "#{(item.sexual.to_f / 100 * 100).round}%", 2)
	  y2 += line_height
	end
	if item.hygiene != 0
	  draw_text(x + 12, y2 + line_height, w, line_height, "Higiene", 0)
	  draw_text(x, y2 + line_height, w, line_height, "#{(item.hygiene.to_f / 100 * 100).round}%", 2)
	  y2 += line_height
	end
	if item.stress != 0
	  draw_text(x + 12, y2 + line_height, w, line_height, "Estrés", 0)
	  draw_text(x, y2 + line_height, w, line_height, "#{(item.stress.to_f / 100 * 100).round}%", 2)
	  y2 += line_height
	end
	if item.drunk != 0
	  draw_text(x + 12, y2 + line_height, w, line_height, "Embriaguez", 0)
	  draw_text(x, y2 + line_height, w, line_height, "#{(item.drunk.to_f / 100 * 100).round}%", 2)
	end
    
	# Segunda descripción
	x = Graphics.width / 3 + 8
	w = Graphics.width / 3 - 25
	y = line_height * 2

	change_color(system_color)
	if item.class == RPG::Item
	  draw_text(x, y, w, line_height, "Estilo de herramienta", 0)
	elsif item.class == RPG::Weapon
	  draw_text(x, y, w, line_height, "Estilo de arma", 0)
	elsif item.class == RPG::Armor
	  draw_text(x, y, w, line_height, "Estilo de armadura", 0)
	elsif item.class == RPG::Skill
	  draw_text(x, y, w, line_height, "Estilo de habilidad", 0)
	end

	y += line_height
	change_color(normal_color)
	if item.tool_data("Tool Distance = ") != nil and item.tool_data("Tool Distance = ") != 0
	  if item.tool_data("Tool Special = ", false) == nil
		draw_text(x + 12, y, w, line_height, "Uso normal o pasivo")
	  elsif item.tool_data("Tool Special = ", false) == "nil"
		draw_text(x + 12, y, w, line_height, "Movimiento de habilidad")
	  elsif item.tool_data("Tool Special = ", false) == "MF_spear"
		draw_text(x + 12, y, w, line_height, "Movimiento del usuario y habilidad, retroceso")
	  elsif item.tool_data("Tool Special = ", false) == "MF_axe"
		draw_text(x + 12, y, w, line_height, "Movimiento de habilidad, rango adicional a los lados")
	  elsif item.tool_data("Tool Special = ", false) == "hillwind"
		draw_text(x + 12, y, w, line_height, "Habilidad mantiene la posición del usuario")
	  elsif item.tool_data("Tool Special = ", false) == "MF1"
		draw_text(x + 12, y, w, line_height, "Usuario salta, movimiento de habilidad")
	  elsif item.tool_data("Tool Special = ", false) == "MF2"
		draw_text(x + 12, y, w, line_height, "Movimiento del usuario y habilidad")
	  elsif item.tool_data("Tool Special = ", false) == "MF4"
		draw_text(x + 12, y, w, line_height, "Movimiento del usuario")
	  elsif item.tool_data("Tool Special = ", false) == "MF3"
		draw_text(x + 12, y, w, line_height, "Usuario se mueve 1 casilla, movimiento de habilidad")
	  elsif item.tool_data("Tool Special = ", false) == "autotarget"
		draw_text(x + 12, y, w, line_height, "Salto de habilidad al objetivo cercano")
	  elsif item.tool_data("Tool Special = ", false) == "autotarget2"
		draw_text(x + 12, y, w, line_height, "Teletransportación al objetivo cercano")
	  elsif item.tool_data("Tool Special = ", false) == "JP1"
		draw_text(x + 12, y, w, line_height, "Salto y movimiento del usuario y habilidad al objetivo designado")
	  elsif item.tool_data("Tool Special = ", false) == "JP2"
		draw_text(x + 12, y, w, line_height, "Salto de habilidad al objetivo designado")
	  elsif item.tool_data("Tool Special = ", false) == "JP3"
		draw_text(x + 12, y, w, line_height, "Salto del usuario y habilidad al objetivo designado")
	  elsif item.tool_data("Tool Special = ", false) == "octuple"
		draw_text(x + 12, y, w, line_height, "Movimiento de habilidad en 8 direcciones")
	  end
	else
	  if item.tool_data("Tool Special = ", false) == nil
		draw_text(x + 12, y, w, line_height, "Uso normal o pasivo")
	  elsif item.tool_data("Tool Special = ", false) == "nil" or 
		item.tool_data("Tool Special = ", false) == "area"
		draw_text(x + 12, y, w, line_height, "Habilidad en la posición del usuario")
	  elsif item.tool_data("Tool Special = ", false) == "hillwind"
		draw_text(x + 12, y, w, line_height, "Habilidad mantiene la posición del usuario")
	  end
	end

	if item.class == RPG::Skill or item.class == RPG::Item
	  # Añadir descripción de objetivo de habilidad
	  case item.scope
	  #when 0 # Ninguno
	  #  draw_text(x + 12, y, w, line_height, "Pasiva")
	  when 1 # Enemigo
		y += line_height
		draw_text(x + 12, y, w, line_height, "Usar en enemigo")
	  when 2 # Todos los enemigos
		y += line_height
		draw_text(x + 12, y, w, line_height, "Usar en todos los enemigos")
	  when 7 # Un aliado
		y += line_height
		draw_text(x + 12, y, w, line_height, "Usar en un aliado")
	  when 8 # Todos los aliados
		y += line_height
		draw_text(x + 12, y, w, line_height, "Usar en todos los aliados")
	  when 11 # Usuario
		y += line_height
		draw_text(x + 12, y, w, line_height, "Usar en el usuario")
	  #else
	  #  draw_text(x + 12, y, w, line_height, "#{item.scope}")
	  end
	end
    
    x = Graphics.width / 3 + 8
    y += line_height * 2
    change_color(system_color)
    draw_text(x, y, w, line_height, "Efecto al usar", 0)

    change_color(normal_color)
    item.effects.each_with_index do |effect, i|
      text = nil
      text2 = nil
      case effect.code
      when 11   # HP 회복
        text = sprintf("%s", Vocab.hp)
        if effect.value1 != 0
          text2 = sprintf("%d%%", (effect.value1 * 100).round)
        end
        text2 = sprintf("%d", effect.value2) if effect.value2 != 0
      when 12   # MP 회복
        text = sprintf("%s", Vocab.mp)
        if effect.value1 != 0
          text2 = sprintf("%d%%", (effect.value1 * 100).round)
        end
        text2 = sprintf("%d", effect.value2) if effect.value2 != 0
      when 13   # TP 회복
        text = sprintf("%s", Vocab.tp)
        text2 = sprintf("%d%%", effect.value1)
      when 21   # 상태 추가
        if effect.data_id > 0
          text = sprintf("Añadir estado %s", $data_states[effect.data_id].name)
          text2 = sprintf("%d%%", (effect.value1 * 100).round)
        end
		when 22   # Eliminar estado
			text = sprintf("Eliminar estado %s", $data_states[effect.data_id].name)
			text2 = sprintf("%d%%", (effect.value1 * 100).round)
		when 31   # Incrementar habilidad
			text = sprintf("Incremento de %s", Vocab::param(effect.data_id))
			text2 = sprintf("%d turnos", effect.value1)
		when 32   # Reducir habilidad
			text = sprintf("Reducción de %s", Vocab::param(effect.data_id))
			text2 = sprintf("%d turnos", effect.value1)
		when 33   # Eliminar incremento de habilidad
			text = sprintf("Eliminar incremento de %s", Vocab::param(effect.data_id))
		when 34   # Eliminar reducción de habilidad
			text = sprintf("Eliminar reducción de %s", Vocab::param(effect.data_id))
		when 41   # Efecto especial
			text = "Huir"
		when 42   # Crecimiento
			text = sprintf("Crecimiento de %s", Vocab::param(effect.data_id))
			text2 = sprintf("+%d", effect.value1)
      #when 43   # 스킬 습득
        # 스킬 습득이 제거로 변경되어 생략 처리 실험 ---------------------
        #text = sprintf("%s 습득", $data_skills[effect.data_id].name)
        # -----------------------------------------------------------
      when 44   # 공통 이벤트
        text = $data_common_events[effect.data_id].name
      end
      if text
        y += line_height
        draw_text(x + 12, y, w, line_height, text, 0)
        draw_text(x, y, w, line_height, text2, 2) if text2 != nil
      end
    end

    item.note.each_line do |line|
      if /<메모\s+(.+)\s+(.+)>/ =~ line
        y += line_height
        draw_text(x + 12, y, w, line_height, $1)
        draw_text(x, y, w, line_height, $2, 2)
      end
    end
  end
  
  def draw_equip_features(item, x, y)
    # 3번째 설명
    x = Graphics.width / 3 * 2
    y2 = y
    w = Graphics.width / 3 - 25
    contents.font.size = TMITWIN::RO_WI_FS
    change_color(system_color)
    draw_text(x, y2, w, line_height, "Efecto del equipamiento", 0)
    
    change_color(normal_color)
	item.features.each_with_index do |feature, i|
	  text = nil
	  text2 = nil
	  case feature.code
	  when 11   # Eficiencia de elemento
		n = 100 - (feature.value * 100).round
		text = sprintf("Resistencia a elemento %s", $data_system.elements[feature.data_id])
		text2 = sprintf("%+d%%", n)
	  when 12   # Eficiencia de debilitación
		n = 100 - (feature.value * 100).round
		text = sprintf("Resistencia a debilitación de %s", Vocab::param(feature.data_id))
		text2 = sprintf("%+d%%", n)
	  when 13   # Eficiencia de estado
		n = 100 - (feature.value * 100).round
		text = sprintf("Eficiencia de estado %s", $data_states[feature.data_id].name)
		text2 = sprintf("%+d%%", n)
	  when 21   # Parámetros generales
		n = (feature.value * 100).round - 100
		text = sprintf("%s", Vocab::param(feature.data_id))
		text2 = sprintf("%+d%%", n)
	  when 22   # Parámetros adicionales
		n = (feature.value * 100).round
		text = sprintf("%s", Vocab::ex_param(feature.data_id))
		text2 = sprintf("%+d%%", n)
	  when 23   # Parámetros especiales
		n = (feature.value * 100).round - 100
		text = sprintf("%s", Vocab::special_param(feature.data_id))
		text2 = sprintf("%+d%%", n)
	  when 33   # Modificación de velocidad de ataque
		text = "Reducción de tiempo de reutilización"
		text2 = sprintf("%+d%%", feature.value * -1)
	  when 34   # Adiciones de ataque
		text = "Vel Movimiento"
		text2 = sprintf("%+d%%", feature.value * 100)
	  when 41   # Tipos de habilidad adicionales
		text = sprintf("Puede usar %s", $data_system.skill_types[feature.data_id])
	  when 42   # Tipos de habilidad sellados
		text = sprintf("No puede usar %s", $data_system.skill_types[feature.data_id])
	  when 43   # Habilidad adicional
		text = sprintf("Puede usar %s", $data_skills[feature.data_id].name)
	  when 44   # Habilidad sellada
		text = sprintf("No puede usar %s", $data_skills[feature.data_id].name)
	  when 51   # Equipamiento de tipo de arma
		text = sprintf("Puede equipar %s", $data_system.weapon_types[feature.data_id])
	  when 52   # Equipamiento de tipo de armadura
		text = sprintf("Puede equipar %s", $data_system.armor_types[feature.data_id])
	  end
	  if text
		y2 += line_height
		draw_text(x + 12, y2, w, line_height, text, 0)
		draw_text(x, y2, w, line_height, text2, 2) if text2 != nil
	  end
	end

	item.note.each_line do |line|
	  if /<inv plus:\s+(.+)>/ =~ line
		y2 += line_height
		draw_text(x + 12, y2, w, line_height, "Límite de peso", 0)
		draw_text(x, y2, w, line_height, "+#{$1}", 2)
	  end
	end

    # 2번째 설명
    x = Graphics.width / 3 + 8
    w = Graphics.width / 3 - 25

	change_color(system_color)
	draw_text(x, y, w, line_height, "Efecto de ataque", 0)
	change_color(normal_color)
	item.features.each_with_index do |feature, i|
	  text = nil
	  text2 = nil
	  case feature.code
	  when 14   # Estado inmune
		text = sprintf("Elimina %s", $data_states[feature.data_id].name)
	  when 31   # Característica en ataque
		unless TMITWIN::EXCLUDE_ELEMENTS.include?(feature.data_id)
		  text = sprintf("Añade propiedad %s al atacar", $data_system.elements[feature.data_id])
		end
	  when 32   # Estado en ataque
		n = (feature.value * 100).round
		text = sprintf("Añade %s al atacar", $data_states[feature.data_id].name)
		text2 = sprintf("%d%%", n)
	  when 61   # Adicional de acciones
		text = "Probabilidad de ignorar retroceso"
		text2 = sprintf("%d%%", (feature.value * 10).round)
	  when 62   # Bandera especial
		text = Vocab.special_flag(feature.data_id)
	  end
	  if text
		y += line_height
		draw_text(x + 12, y, w, line_height, text, 0)
		draw_text(x, y, w, line_height, text2, 2) if text2 != nil
	  end
	end

    item.note.each_line do |line|
      if /<메모\s+(.+)\s+(.+)>/ =~ line
        y += line_height
        draw_text(x + 12, y, w, line_height, $1)
        draw_text(x, y, w, line_height, $2, 2)
      end
    end
  end
  
  def draw_horz_line(y)
    line_y = y + line_height / 2 - 1
    contents.fill_rect(0, line_y, contents_width, 2, line_color)
  end
  
  def line_color
    color = normal_color
    color.alpha = 48
    color
  end
end