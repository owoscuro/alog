# encoding: utf-8
# Name: 139.Sprite_PearlTool
# Size: 20552
class Sprite_PearlTool < Sprite
  include PearlSkillBar
  attr_accessor :actor
  def initialize(view, custom_pos=nil)
    super(view)
    @layout = ::Sprite.new(view)
    @layout.bitmap = Cache.picture(LayOutImage)
    @layout.z = 1120
    @icons = ::Sprite.new(view)
    @icons.bitmap = Bitmap.new(@layout.bitmap.width, @layout.bitmap.height)
    self.bitmap = Bitmap.new(@layout.bitmap.width, @layout.bitmap.height + 32)
    #if custom_pos.nil?
      @layout.x = Graphics.width / 2 - (@layout.bitmap.width / 2)
      @layout.y = ((Graphics.height / 32) - 2) * 32
    #else
    #  @layout.x = custom_pos[0]
    #  @layout.y = custom_pos[1]
    #end
    @icons.x = @layout.x
    @icons.y = @layout.y
    @icons.z = 1121
    self.x = @layout.x - 16
    self.y = @layout.y - 12
    self.z = 1122
    @actor = $game_player.actor
    @actor.apply_usability
    @old_usability = []
    13.times.each {|i| @old_usability[i] = @actor.usability[i]}
    @framer = 0
    @info_keys = ::Sprite.new(view)
    @info_keys.bitmap = Bitmap.new(self.bitmap.width, self.bitmap.height)
    @info_keys.x = self.x; @info_keys.y = self.y; @info_keys.z = self.z
    draw_key_info
    refresh_icons
    refresh_texts
    @view = view
    @on_map = SceneManager.scene_is?(Scene_Map)
    update
  end

  # 스킬바 아이콘 순서
  def draw_key_info
    @info_keys.bitmap.font.size = 15
    letters = [Key::Weapon[1], Key::Armor[1],
    Key::Item[1], Key::Item2[1], Key::Item3[1], Key::Item4[1],
    Key::Skill[1],Key::Skill2[1],Key::Skill3[1],Key::Skill4[1],
    Key::Skill5[1],Key::Skill6[1],Key::Skill7[1],Key::Skill8[1],Key::Follower[1]]
    x = 28
    for i in letters
      @info_keys.bitmap.draw_text(x, -2, @info_keys.bitmap.width, 32, i) 
      x += 32
    end
  end

  def refresh_texts
    self.bitmap.clear
    self.bitmap.font.size = 15
    refresh_cooldown
    refresh_ammo
  end

  def number(operand)
    return (operand / 60).to_i
  end

  def flagged(item, type)
    return :false if !item.cool_enabled? and type == 1
    return item.itemcost if type == 2
  end

  def baldo_wtype
    if @actor.state?(185) # 발도 상태
      return 1064         # 발도
    else
      return 1065         # 납도
    end
  end
  
  # 도구 모음 아이콘 새로 고침
  def refresh_icons
    @icons.bitmap.clear
    # 단축키창 아이콘 갱신
    # 동료 자동 사냥 아이콘 변경 실험 --------------------------------------------
    icon = [@actor.equips[0], @actor.equips[1], @actor.assigned_item,
    @actor.assigned_item2, @actor.assigned_item3, @actor.assigned_item4, 
    @actor.assigned_skill, @actor.assigned_skill2,
    @actor.assigned_skill3, @actor.assigned_skill4,
    @actor.assigned_skill5, @actor.assigned_skill6, 
    @actor.assigned_skill7, @actor.assigned_skill8, PearlSkillBar.ToggleIcon]
    $game_switches[197] = false
    #-------------------------------------------------------------------------
    
    x = 4
    icon.each {|i| 
    if !i.nil? and !i.is_a?(Integer) # Fixnum a Integer.
      # 스킬 무기, 방어구 착용 제한
      if i.is_a?(RPG::Skill)
        #print("139.Sprite_PearlTool - 스킬 무기 제한 확인 %s \n" % [@actor.skill_wtype_ok?(i)]);
        if @actor.skill_wtype_ok?(i)
          # 스킬 아이콘 새로고침
          draw_icon(i.icon_index, x, 6, @actor.usable?(i))
        else
          draw_icon(i.icon_index, x, 6, false)
        end
      elsif i.is_a?(RPG::Item)
        draw_icon(i.icon_index, x, 6, @actor.usable?(i))
      else
        if i.is_a?(RPG::Weapon)
          enable = @actor.usability[0] ; enable = true if enable.nil?
          enable = false if @actor.restriction >= 4  # 행동불가인지 확인
          draw_icon(i.icon_index, x, 6, enable)
        elsif i.is_a?(RPG::Armor)
          enable = @actor.usability[1] ; enable = true if enable.nil?
          enable = false if @actor.restriction >= 4  # 행동불가인지 확인
          draw_icon(i.icon_index, x, 6, enable)
        end
      end
    end
    draw_icon(i, x, 6) if i.is_a?(Integer) ; x += 32} # Fixnum a Integer.
    @now_equip = [@actor.equips[0], @actor.equips[1], @actor.assigned_item,
    @actor.assigned_item2, @actor.assigned_item3, @actor.assigned_item4, 
    @actor.assigned_skill, @actor.assigned_skill2, 
    @actor.assigned_skill3, @actor.assigned_skill4, @actor.assigned_skill5,
    @actor.assigned_skill6, @actor.assigned_skill7, @actor.assigned_skill8]
  end
  
  def update
    # 퀘스트 보드에서 스킬 바 삭제 실험 --------------------------------------------
    if $game_switches[186] == true or $game_switches[281] == false
      self.opacity = 0
    end
    
    # --------------------------------------------------------------------------
    # 아래는 시간 가속중이 아닌 경우에만 적용
    # --------------------------------------------------------------------------
    if $game_switches[283] == false
      # 쿨타임 프레임 조작
      if $sel_time_frame_10 == 8
      #print("139.Sprite_PearlTool - 단축키바 아이콘 갱신 \n");
      #if $sel_time_frame == 40 or $sel_time_frame == 100
        if !HM_SEL::time_stop?
          update_cooldown
          update_ammo_tools
          update_usability_enable
        end
      end
    end
    
    # --------------------------------------------------------------------------
    # 위는 시간 가속중이 아닌 경우에만 적용
    # --------------------------------------------------------------------------
    if Graphics.frame_count % 2 == 0
      if @now_equip[0] != @actor.equips[0] or @now_equip[1] != @actor.equips[1] or
        @now_equip[2] != @actor.assigned_item or @now_equip[3] != @actor.assigned_item2 or
        @now_equip[12] != @actor.assigned_item3 or @now_equip[13] != @actor.assigned_item4 or
        @now_equip[4] != @actor.assigned_skill or @now_equip[5] != @actor.assigned_skill2 or
        @now_equip[6] != @actor.assigned_skill3 or @now_equip[7] != @actor.assigned_skill4 or
        @now_equip[8] != @actor.assigned_skill5 or @now_equip[9] != @actor.assigned_skill6 or
        @now_equip[10] != @actor.assigned_skill7 or @now_equip[11] != @actor.assigned_skill8
        
        # 등록된 도구 및 스킬이 다른 경우에만 갱신한다.
        update_usability_enable
        
        # 단축키 설정창을 켜놓은 상태다.
        refresh_icons #if SceneManager.scene_is?(Scene_QuickTool)
        
        #print("041 + Sprite_PearlTool - 단축키바 아이콘 갱신 \n");
      end
      # 에르니는 무기 단축키 콤보 제외 -----------------------------------------------
      if @actor.id != 7
        actor.come_skill = 'nil'
        actor.come_skill2 = 'nil'
        actor.come_skill3 = 'nil'
        actor.come_skill4 = 'nil'
        actor.come_skill5 = 'nil'
        actor.come_skill6 = 'nil'
        actor.come_skill7 = 'nil'
        actor.come_skill8 = 'nil'
        actor.come_skill = @actor.assigned_skill.id if @actor.assigned_skill != nil
        actor.come_skill2 = @actor.assigned_skill2.id if @actor.assigned_skill2 != nil
        actor.come_skill3 = @actor.assigned_skill3.id if @actor.assigned_skill3 != nil
        actor.come_skill4 = @actor.assigned_skill4.id if @actor.assigned_skill4 != nil
        actor.come_skill5 = @actor.assigned_skill5.id if @actor.assigned_skill5 != nil
        actor.come_skill6 = @actor.assigned_skill6.id if @actor.assigned_skill6 != nil
        actor.come_skill7 = @actor.assigned_skill7.id if @actor.assigned_skill7 != nil
        actor.come_skill8 = @actor.assigned_skill8.id if @actor.assigned_skill8 != nil
      end
      # 동료 자동 사냥 아이콘 변경 실험 ----------------------------------------------
      if $game_switches[192] != $game_switches[196]
        $game_switches[192] = $game_switches[196]
        print("139.Sprite_PearlTool - 자동 사냥 변경시 새로고침 \n");
        refresh_icons
      end
    end
    # --------------------------------------------------------------------------
  end
  
  def behind_toolbar?
    return false unless @on_map
    px = ($game_player.screen_x / 32).to_i
    py = ($game_player.screen_y / 32).to_i
    9.times.each {|x| return true if px == Tile_X + x and py >= Tile_Y}
    return false
  end
  
  # 사용성 변경 시 아이콘 새로 고침
  def update_usability_enable
    refresh_icons_on = 0
    13.times.each {|i|
    if @old_usability[i] != @actor.usability[i] and @actor.usability[i] != ""
    #if @old_usability[i] != nil and @old_usability[i] != ""
      #if @actor.usability[i] != nil and @actor.usability[i] != ""
        #if @old_usability[i] != @actor.usability[i]
          @old_usability[i] = @actor.usability[i]
          print("139.Sprite_PearlTool - 단축키 변경시 새로고침 \n");
          #refresh_icons
          refresh_icons_on += 1
        #end
      #end
    #end
    end
    }
    refresh_icons if refresh_icons_on >= 1
  end

  # 탄약 엔진
  def ammo_ready?(item)
    return false if item.nil?
    return true if item.has_data.nil? && item.is_a?(RPG::Item) &&
    item.consumable
    return false if flagged(item, 2).nil?
    return true  if flagged(item, 2) != 0
    return false
  end
  
  # 아이템 비용을 얻다.
  def itemcost(item)
    return $game_party.item_number(item) if item.has_data.nil? &&
    item.is_a?(RPG::Item) && item.consumable
    if !flagged(item, 2).nil? and flagged(item, 2) != 0
      return $game_party.item_number($data_items[flagged(item, 2)])
    end
    return 0
  end
  
  # 탄약 리프레셔
  def refresh_ammo
    self.z = 1199
    if ammo_ready?(@actor.equips[0]) 
      @wnumber = itemcost(@actor.equips[0])
      self.bitmap.draw_text(18, 24, 32,32, @wnumber.to_s, 1)
    end
    if ammo_ready?(@actor.equips[1]) 
      @anumber = itemcost(@actor.equips[1])
      self.bitmap.draw_text(50, 24, 32,32, @anumber.to_s, 1)
    end
    if ammo_ready?(@actor.assigned_item) 
      @inumber = itemcost(@actor.assigned_item)
      self.bitmap.draw_text(82, 24, 32,32, @inumber.to_s, 1)
    end
    if ammo_ready?(@actor.assigned_item2) 
      @inumber2 = itemcost(@actor.assigned_item2)
      self.bitmap.draw_text(112, 24, 32,32, @inumber2.to_s, 1) # item 2
    end
    if ammo_ready?(@actor.assigned_item3) 
      @inumber9 = itemcost(@actor.assigned_item3)
      self.bitmap.draw_text(144, 24, 32,32, @inumber9.to_s, 1) # item 3
    end
    if ammo_ready?(@actor.assigned_item4) 
      @inumber10 = itemcost(@actor.assigned_item4)
      self.bitmap.draw_text(176, 24, 32,32, @inumber10.to_s, 1) # item 4
    end
    if ammo_ready?(@actor.assigned_skill)
      @snumber = itemcost(@actor.assigned_skill)
      self.bitmap.draw_text(208, 24, 32,32, @snumber.to_s, 1)
    end
    if ammo_ready?(@actor.assigned_skill2)
      @snumber2 = itemcost(@actor.assigned_skill2)
      self.bitmap.draw_text(240, 24, 32,32, @snumber2.to_s, 1) # skill 2
    end
    if ammo_ready?(@actor.assigned_skill3)
      @snumber3 = itemcost(@actor.assigned_skill3)
      self.bitmap.draw_text(272, 24, 32,32, @snumber3.to_s, 1) # skill 3
    end
    if ammo_ready?(@actor.assigned_skill4)
      @snumber4 = itemcost(@actor.assigned_skill4)
      self.bitmap.draw_text(304, 24, 32,32, @snumber4.to_s, 1) # skill 4
    end
    if ammo_ready?(@actor.assigned_skill5)
      @snumber5 = itemcost(@actor.assigned_skill5)
      self.bitmap.draw_text(336, 24, 32,32, @snumber5.to_s, 1)
    end
    if ammo_ready?(@actor.assigned_skill6)
      @snumber6 = itemcost(@actor.assigned_skill6)
      self.bitmap.draw_text(368, 24, 32,32, @snumber6.to_s, 1) # skill 2
    end
    if ammo_ready?(@actor.assigned_skill7)
      @snumber7 = itemcost(@actor.assigned_skill7)
      self.bitmap.draw_text(400, 24, 32,32, @snumber7.to_s, 1) # skill 3
    end
    if ammo_ready?(@actor.assigned_skill8)
      @snumber8 = itemcost(@actor.assigned_skill8)
      self.bitmap.draw_text(432, 24, 32,32, @snumber8.to_s, 1) # skill 4
    end
  end
  
  def update_ammo_tools
    # 아이템 수량 및 사용가능한지 확인 후 텍스트 새로고침
    if (ammo_ready?(@actor.equips[0]) && @wnumber != itemcost(@actor.equips[0])) or
      (ammo_ready?(@actor.equips[1]) && @anumber != itemcost(@actor.equips[1])) or
      (ammo_ready?(@actor.assigned_item) && @inumber != itemcost(@actor.assigned_item)) or
      (ammo_ready?(@actor.assigned_item2) && @inumber2 != itemcost(@actor.assigned_item2)) or
      (ammo_ready?(@actor.assigned_item3) && @inumber9 != itemcost(@actor.assigned_item3)) or
      (ammo_ready?(@actor.assigned_item4) && @inumber10 != itemcost(@actor.assigned_item4)) or
      (ammo_ready?(@actor.assigned_skill) && @snumber != itemcost(@actor.assigned_skill)) or
      (ammo_ready?(@actor.assigned_skill2) && @snumber2 != itemcost(@actor.assigned_skill2)) or
      (ammo_ready?(@actor.assigned_skill3) && @snumber3 != itemcost(@actor.assigned_skill3)) or
      (ammo_ready?(@actor.assigned_skill4) && @snumber4 != itemcost(@actor.assigned_skill4)) or
      (ammo_ready?(@actor.assigned_skill5) && @snumber5 != itemcost(@actor.assigned_skill5)) or
      (ammo_ready?(@actor.assigned_skill6) && @snumber6 != itemcost(@actor.assigned_skill6)) or
      (ammo_ready?(@actor.assigned_skill7) && @snumber7 != itemcost(@actor.assigned_skill7)) or
      (ammo_ready?(@actor.assigned_skill8) && @snumber8 != itemcost(@actor.assigned_skill8))
      refresh_texts
    end
  end

  def cool_down_active?
    return true if skill_cooldown > 0 || weapon_cooldown > 0 ||
    item_cooldown3 > 0 || item_cooldown4 > 0 ||
    item_cooldown > 0 || skill_cooldown2 > 0 ||
    #armor_cooldown > 40 || item_cooldown > 40 || skill_cooldown2 > 40 ||
    item_cooldown2 > 0 || skill_cooldown3 > 0 || skill_cooldown4 > 0 || 
    skill_cooldown5 > 0 || skill_cooldown6 > 0 || 
    skill_cooldown7 > 0 || skill_cooldown8 > 0
    return false
  end

  def weapon_cooldown
    if !@actor.equips[0].nil?
      return 0 if flagged(@actor.equips[0], 1) == :false
      cd =  @actor.weapon_cooldown[@actor.equips[0].id].to_i
      return cd unless cd.nil?
    end
    return 0
  end
  
=begin
  def armor_cooldown
   if !@actor.equips[1].nil?
      return 0 if flagged(@actor.equips[1], 1) == :false
      cd =  @actor.armor_cooldown[@actor.equips[1].id].to_i
      return cd unless cd.nil?
    end
    return 0
  end
=end

  def item_cooldown
    if !@actor.assigned_item.nil?
      return 0 if flagged(@actor.assigned_item, 1) == :false
      cd = @actor.item_cooldown[@actor.assigned_item.id].to_i
      return cd unless cd.nil?
    end
    return 0
  end
  
  def item_cooldown2
    if !@actor.assigned_item2.nil?
      return 0 if flagged(@actor.assigned_item2, 1) == :false
      cd = @actor.item_cooldown[@actor.assigned_item2.id].to_i
      return cd unless cd.nil?
    end
    return 0
  end
  
  def item_cooldown3
    if !@actor.assigned_item3.nil?
      return 0 if flagged(@actor.assigned_item3, 1) == :false
      cd = @actor.item_cooldown[@actor.assigned_item3.id].to_i
      return cd unless cd.nil?
    end
    return 0
  end
  
  def item_cooldown4
    if !@actor.assigned_item4.nil?
      return 0 if flagged(@actor.assigned_item4, 1) == :false
      cd = @actor.item_cooldown[@actor.assigned_item4.id].to_i
      return cd unless cd.nil?
    end
    return 0
  end
  
  def skill_cooldown
    if !@actor.assigned_skill.nil?
      return 0 if flagged(@actor.assigned_skill, 1) == :false
      cd = @actor.skill_cooldown[@actor.assigned_skill.id].to_i
      return cd unless cd.nil?
    end
    return 0
  end
  
  def skill_cooldown2
    if !@actor.assigned_skill2.nil?
      return 0 if flagged(@actor.assigned_skill2, 1) == :false
      cd = @actor.skill_cooldown[@actor.assigned_skill2.id].to_i
      return cd unless cd.nil?
    end
    return 0
  end
  
  def skill_cooldown3
    if !@actor.assigned_skill3.nil?
      return 0 if flagged(@actor.assigned_skill3, 1) == :false
      cd = @actor.skill_cooldown[@actor.assigned_skill3.id].to_i
      return cd unless cd.nil?
    end
    return 0
  end
  
  def skill_cooldown4 # 4
    if !@actor.assigned_skill4.nil?
      return 0 if flagged(@actor.assigned_skill4, 1) == :false
      cd = @actor.skill_cooldown[@actor.assigned_skill4.id].to_i
      return cd unless cd.nil?
    end
    return 0
  end
  
  def skill_cooldown5 # 5
    if !@actor.assigned_skill5.nil?
      return 0 if flagged(@actor.assigned_skill5, 1) == :false
      cd = @actor.skill_cooldown[@actor.assigned_skill5.id].to_i
      return cd unless cd.nil?
    end
    return 0
  end
  
  def skill_cooldown6 # 6
    if !@actor.assigned_skill6.nil?
      return 0 if flagged(@actor.assigned_skill6, 1) == :false
      cd = @actor.skill_cooldown[@actor.assigned_skill6.id].to_i
      return cd unless cd.nil?
    end
    return 0
  end
  
  def skill_cooldown7 # 7
    if !@actor.assigned_skill7.nil?
      return 0 if flagged(@actor.assigned_skill7, 1) == :false
      cd = @actor.skill_cooldown[@actor.assigned_skill7.id].to_i
      return cd unless cd.nil?
    end
    return 0
  end
  
  def skill_cooldown8 # 4
    if !@actor.assigned_skill8.nil?
      return 0 if flagged(@actor.assigned_skill8, 1) == :false
      cd = @actor.skill_cooldown[@actor.assigned_skill8.id].to_i
      return cd unless cd.nil?
    end
    return 0
  end

  def refresh_cooldown
    self.z = 1200
    # 무기 쿨타임
    wcd = number(weapon_cooldown)
    self.bitmap.draw_text(18, 36, 32, 32, wcd.to_i, 1) if wcd.to_i > 0
    #acd = number(armor_cooldown)
    #self.bitmap.draw_text(50, 36, 32, 32, acd.to_s, 1) if acd.to_i > 0
    # 도구 쿨타임
    icd = number(item_cooldown)
    self.bitmap.draw_text(82, 36, 32, 32, icd.to_i, 1) if icd.to_i > 0
    icd2 = number(item_cooldown2)
    self.bitmap.draw_text(112, 36, 32, 32, icd2.to_i, 1) if icd2.to_i > 0
    icd3 = number(item_cooldown3)
    self.bitmap.draw_text(144, 36, 32, 32, icd3.to_i, 1) if icd3.to_i > 0
    icd4 = number(item_cooldown4)
    self.bitmap.draw_text(176, 36, 32, 32, icd4.to_i, 1) if icd4.to_i > 0
    # 스킬 쿨타임
    scd = number(skill_cooldown)
    self.bitmap.draw_text(208, 36, 32, 32, scd.to_i, 1) if scd.to_i > 0
    scd2 = number(skill_cooldown2)
    self.bitmap.draw_text(240, 36, 32, 32, scd2.to_i, 1) if scd2.to_i > 0
    scd3 = number(skill_cooldown3)
    self.bitmap.draw_text(272, 36, 32, 32, scd3.to_i, 1) if scd3.to_i > 0
    scd4 = number(skill_cooldown4)
    self.bitmap.draw_text(304, 36, 32, 32, scd4.to_i, 1) if scd4.to_i > 0
    scd5 = number(skill_cooldown5)
    self.bitmap.draw_text(336, 36, 32, 32, scd5.to_i, 1) if scd5.to_i > 0
    scd6 = number(skill_cooldown6)
    self.bitmap.draw_text(368, 36, 32, 32, scd6.to_i, 1) if scd6.to_i > 0
    scd7 = number(skill_cooldown7)
    self.bitmap.draw_text(400, 36, 32, 32, scd7.to_i, 1) if scd7.to_i > 0
    scd8 = number(skill_cooldown8)
    self.bitmap.draw_text(432, 36, 32, 32, scd8.to_i, 1) if scd8.to_i > 0
  end
  
  def update_cooldown
    if @on_map and @actor != $game_player.actor
      @actor = $game_player.actor
    end
    
    # 스킬 아이콘 투명도 확인 실험
    if $game_player.refresh_skillbar > 0
      $game_player.refresh_skillbar -= 1
      if $game_player.refresh_skillbar == 0
        @actor.apply_usability
        refresh_icons
      end
    end
    
    if cool_down_active?
      # 쿨타임이 존재해서 갱신
      refresh_texts
      @cool_ammo = 0
    elsif @cool_ammo == 0
      # 쿨타임이 없어서 갱신
      @cool_ammo = 1
      self.bitmap.clear
      self.bitmap.font.size = 15
      refresh_ammo
    end
  end
  
  def dispose
    self.bitmap.dispose
    @layout.bitmap.dispose
    @layout.dispose
    @icons.bitmap.dispose
    @icons.dispose
    @info_keys.bitmap.dispose
    @info_keys.dispose
    super
  end

  def draw_icon(index, x, y, enabled = true)
    #print("139.Sprite_PearlTool - 아이콘 그리기 진행 \n");
    index += 1
    bit = Cache.system("icon/"+"#{index}")
    rect = Rect.new(0, 0, 24, 24)
    @icons.bitmap.blt(x, y, bit, rect, enabled ? 255 : 50)
  end
end