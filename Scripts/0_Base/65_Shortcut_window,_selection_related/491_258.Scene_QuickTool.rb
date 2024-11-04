# encoding: utf-8
# Name: 258.Scene_QuickTool
# Size: 11599
# encoding: utf-8
# Name: 258.Scene_QuickTool
# Size: 11523
class Scene_QuickTool < Scene_MenuBase
  def start
    super
    x, y = (Graphics.width * 0.1 / 2) - 2, Graphics.height / 2 - 85 / 2
    @top_text = Window_Base.new(x, y - 156, Graphics.width * 0.9 + 6, 85)
    # @statust = ['명령 대기중입니다.', 0]
    @statust = ['Esperando órdenes.', 0]
    refresh_top_info
    @type_select = Window_ItemSelect.new(@top_text.x, @top_text.y + 85)
    @type_select.set_handler(:weapon,     method(:refresh_tools))
    @type_select.set_handler(:armor,      method(:refresh_tools))
    @type_select.set_handler(:item,       method(:refresh_tools))
    @type_select.set_handler(:skill_1,    method(:refresh_tools))
    @type_select.set_handler(:skill_2,    method(:refresh_tools))
    @type_select.set_handler(:cancel,     method(:refresh_cancel))
    @type_index = @type_select.index
    @items_w = Window_ActorQuickTool.new(@type_select.x, @type_select.y + 50)
    @items_w.refresh($game_player.actor, @type_select.current_symbol)
    @description = Window_Base.new(@items_w.x, @items_w.y + 148, Graphics.width * 0.9 + 6, 75)
    DisplayTools.create(Graphics.width / 2 - 208, @description.y + 120)
    @background_sprite.color.set(16, 16, 16, 70)
  end

  def create_slot_confirm
    @slot_confirm = Window_SlotConfirm.new(Graphics.width / 2 - 170, @items_w.y + 36, 
    @type_select.current_symbol)
    if @type_select.current_symbol == :item
      @slot_confirm.set_handler(:slot1,     method(:open_slots))
      @slot_confirm.set_handler(:slot2,     method(:open_slots))
      @slot_confirm.set_handler(:slot3,     method(:open_slots))
      @slot_confirm.set_handler(:slot4,     method(:open_slots))
    else
      @slot_confirm.set_handler(:slot1,     method(:open_slots))
      @slot_confirm.set_handler(:slot2,     method(:open_slots))
      @slot_confirm.set_handler(:slot3,     method(:open_slots))
      @slot_confirm.set_handler(:slot4,     method(:open_slots))
      @slot_confirm.set_handler(:slot5,     method(:open_slots))
      @slot_confirm.set_handler(:slot6,     method(:open_slots))
      @slot_confirm.set_handler(:slot7,     method(:open_slots))
      @slot_confirm.set_handler(:slot8,     method(:open_slots))
    end
  end

  def dispose_slot_confirm
    return if @slot_confirm.nil?
    @slot_confirm.dispose
    @slot_confirm = nil
  end
  
  def refresh_top_info
    @top_text.contents.clear
    @top_text.contents.font.name = "Arial"
    @top_text.contents.font.size = 20
    @top_text.contents.fill_rect(0, 0, 58, 74, Color.new(0, 0, 0, 0))
    @top_text.draw_character(actor.character_name,actor.character_index, 26, 45)
    @top_text.draw_text(62, 0, @top_text.width - 10, 32, actor.name)
    @top_text.draw_text(62, 22, @top_text.width - 10, 32, actor.class.name)
    @top_text.draw_text(-22, 30, @top_text.width - 10, 32, @statust[0], 2)
    @top_text.draw_text(-22, 0, @top_text.width - 10, 32, 'Cambia de personaje con los botones Q y W', 2) 
	PearlKernel::SinglePlayer
  end
  
  def refresh_tools
    enable_items
  end
  
  def refresh_cancel
    # 다시 포지션 정리 동료 전환 금지
    member = $game_party.battle_members

    if member.size == 2 and member[0].id != 7
      $game_party.swap_order(0, 1)
    end
    if member.size == 3 and member[0].id != 7
      $game_party.swap_order(1, 2) if member[1].id != 7
      $game_party.swap_order(0, 1) if member[0].id != 7
    end
    if member.size == 4 and member[0].id != 7
      $game_party.swap_order(2, 3) if member[2].id != 7
      $game_party.swap_order(1, 2) if member[1].id != 7
      $game_party.swap_order(0, 1) if member[0].id != 7
    end

    SceneManager.return
  end
  
  def enable_items
    @items_w.activate
    @items_w.select(0)
  end

  def refresh_description
    @description.contents.clear
    @desc_index = @items_w.index
    return if @items_w.item.nil? || @items_w.index < 0
    @description.contents.font.name = "Arial"
    @description.contents.font.size = 20

    icon = BM::HELP_DISPLAY[0] ? '\i[' + @items_w.item.icon_index.to_s + '] ' : ""
    name = BM::HELP_DISPLAY[1] ? @items_w.item.name : ""
    desc = BM::HELP_DISPLAY[2] ? '\c[0]' + @items_w.item.description : ""

    if BM::HELP_DISPLAY[3]
      if @items_w.item.is_a?(RPG::Weapon) ; item_type = " (" + Vocab.weapon_types(@items_w.item.wtype_id) + ")" end
      if @items_w.item.is_a?(RPG::Armor) ; item_type = " (" + Vocab.armor_types(@items_w.item.atype_id) + ")" end
      if @items_w.item.is_a?(RPG::Skill) ; item_type = " (" + Vocab.skill_types(@items_w.item.stype_id) + ")" end
    else; item_type = ""
    end

    item_text = icon + name + item_type.to_s + " : " + desc
    @description.draw_text_ex2(0, 0, item_text)
  end

  def update
    super
    if @items_w != nil
      perform_item_ok if Input.trigger?(:C)
      perform_canceling if Input.trigger?(:B)
    end
  
    #--------------------------------------------------------------------------
    # 상세 데이터 설명창 추가
    #--------------------------------------------------------------------------
    if @items_w.active and @items_w.item != nil
      create_description_window if Input.trigger?(:X) or Keyboard.trigger?(:kN)
    end
    #--------------------------------------------------------------------------

    if Input.trigger?(:R) and @description_window == nil
      Sound.play_ok
      SceneManager.call(Scene_CharacterSet)
    end
    if Input.trigger?(:L) and @description_window == nil
      Sound.play_ok
      SceneManager.call(Scene_CharacterSet2)
    end

    DisplayTools.update
    perform_refresh
  end
  #--------------------------------------------------------------------------
  # 상세 데이터 설명창 추가
  #--------------------------------------------------------------------------
  def create_description_window
    # 플레이어 id 대입
    member = $game_party.battle_members
    $game_variables[126] = member[0].id
    
    @description_window = Window_ItemDescription.new
    on_item_description
    @description_window.set_handler(:ok,     method(:on_description_ok))
    @description_window.set_handler(:cancel, method(:on_description_cancel))
  end
  
  def on_description_ok
    hide_sub_window(@description_window)
    @description_window = nil
  end
  
  def on_description_cancel
    Sound.play_cancel
    hide_sub_window(@description_window)
    @description_window = nil
  end
  
  def on_item_description
    @description_window.refresh(@items_w.item)
    show_sub_window(@description_window)
  end
  
  def show_sub_window(window)
    @top_text.hide
    @type_select.hide
    @items_w.hide.deactivate
    @description.hide
    DisplayTools.dispose
    @viewport.rect.width = 0
    window.show.activate
  end
  
  def hide_sub_window(window)
    @description_window = nil
    @top_text.show
    @type_select.show
    @items_w.show.activate
    @description.show
    DisplayTools.create(Graphics.width / 2 - 208, @description.y + 120)
    @viewport.rect.width = Graphics.width
    window.hide.deactivate
  end
  
  def perform_item_ok
    return if @items_w.item.nil?
    case @type_select.current_symbol
    when :weapon
      actor.change_equip_by(0, @items_w.item)
      equip_play
    when :armor
      actor.change_equip_by(1, @items_w.item)
      equip_play
    when :item
      activate_slots
    when :skill_1, :skill_2
      activate_slots
    end
    DisplayTools.sprite.refresh_texts
  end
  
  def activate_slots
    @items_w.deactivate
    create_slot_confirm
    Sound.play_ok
  end
  
  def deactivate_slots
    @items_w.activate
    dispose_slot_confirm
  end
  
  def actor
    return $game_player.actor
  end
  
  def equip_play
    Sound.play_equip
    @statust[1] = 80
  end
  
  def open_slots
    # 이미 등록된 슬롯이 있으면 제거한다.
    #print("258.Scene_QuickTool - %s, %s \n" % [actor.assigned_skill7.id, @items_w.item.id]);
    if @type_select.current_symbol == :item
      actor.assigned_item = nil  if actor.assigned_item != nil  and actor.assigned_item.id  == @items_w.item.id
      actor.assigned_item2 = nil if actor.assigned_item2 != nil and actor.assigned_item2.id == @items_w.item.id
      actor.assigned_item3 = nil if actor.assigned_item3 != nil and actor.assigned_item3.id == @items_w.item.id
      actor.assigned_item4 = nil if actor.assigned_item4 != nil and actor.assigned_item4.id == @items_w.item.id
    else
      actor.assigned_skill = nil  if actor.assigned_skill != nil  and actor.assigned_skill.id  == @items_w.item.id
      actor.assigned_skill2 = nil if actor.assigned_skill2 != nil and actor.assigned_skill2.id == @items_w.item.id
      actor.assigned_skill3 = nil if actor.assigned_skill3 != nil and actor.assigned_skill3.id == @items_w.item.id
      actor.assigned_skill4 = nil if actor.assigned_skill4 != nil and actor.assigned_skill4.id == @items_w.item.id
      actor.assigned_skill5 = nil if actor.assigned_skill5 != nil and actor.assigned_skill5.id == @items_w.item.id
      actor.assigned_skill6 = nil if actor.assigned_skill6 != nil and actor.assigned_skill6.id == @items_w.item.id
      actor.assigned_skill7 = nil if actor.assigned_skill7 != nil and actor.assigned_skill7.id == @items_w.item.id
      actor.assigned_skill8 = nil if actor.assigned_skill8 != nil and actor.assigned_skill8.id == @items_w.item.id
    end
    
    if @type_select.current_symbol == :item
      case @slot_confirm.current_symbol
      when :slot1 then actor.assigned_item  = @items_w.item
      when :slot2 then actor.assigned_item2 = @items_w.item
      when :slot3 then actor.assigned_item3 = @items_w.item
      when :slot4 then actor.assigned_item4 = @items_w.item
      end
    else
      case @slot_confirm.current_symbol
      when :slot1 then actor.assigned_skill  = @items_w.item
      when :slot2 then actor.assigned_skill2 = @items_w.item
      when :slot3 then actor.assigned_skill3 = @items_w.item
      when :slot4 then actor.assigned_skill4 = @items_w.item
      when :slot5 then actor.assigned_skill5 = @items_w.item
      when :slot6 then actor.assigned_skill6 = @items_w.item
      when :slot7 then actor.assigned_skill7 = @items_w.item
      when :slot8 then actor.assigned_skill8 = @items_w.item
      end
    end
    
    equip_play; deactivate_slots
    DisplayTools.sprite.refresh_texts
  end
  
  def perform_canceling
    Sound.play_cancel
    if @items_w.active
      @items_w.deactivate
      @items_w.unselect
      @type_select.activate
    else
      deactivate_slots
    end
  end
  
  def perform_refresh
    if @type_index != @type_select.index
      @type_index = @type_select.index
      @items_w.refresh($game_player.actor, @type_select.current_symbol)
      refresh_description
    end
    if @desc_index != @items_w.index
      @desc_index = @items_w.index
      refresh_description
    end
    if @statust[1] > 0 
      @statust[1] -= 1 
      if @statust[1] == 78
        @statust[0] = @items_w.item.name + ' ha sido equipado.'
        refresh_top_info
      elsif @statust[1] == 0
        @statust = ['Esperando órdenes.', 0]
        refresh_top_info
      end
    end
  end

  def terminate
    super
    @top_text.dispose
    @type_select.dispose
    @items_w.dispose
    @description.dispose
    dispose_slot_confirm
    DisplayTools.dispose
  end
end