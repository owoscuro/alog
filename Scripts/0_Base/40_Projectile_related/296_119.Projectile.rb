# encoding: utf-8
# Name: 119.Projectile
# Size: 88574
# encoding: utf-8
# Name: 119.Projectile
# Size: 93718
class Projectile < Game_Character
  attr_accessor :draw_it, :destroy_it, :user, :tool_retracting, :customsteps
  attr_accessor :tool_distance, :original_distance, :agroto_f, :pick_able
  attr_accessor :tool_destroy_delay

  def initialize(user, item, custom=nil)
    super()
    return if item.nil? # 오류 방지용 추가
    
    PearlKernel.load_item(item)
    @tool_special = PearlKernel.tool_special
    @tool_distance = PearlKernel.tool_distance

    @draw_it = false
    @destroy_it = false
    @user = user
    @item = item

    @through = true if PearlKernel.tool_through == "true"
    @through = true if PearlKernel.tool_through.nil?
    
    # 활 관련 스킬 사거리 무기에서 가져오도록 수정
    #if @user.battler.is_a?(Game_Actor) and @user.battler.equips[0] != nil and PearlKernel.tool_graphic == $W_Arrow
    #  @tool_distance = user.battler.equips[0].tool_data("Tool Distance = ")
    #end

    # 마지막에 사용한 스킬 아이디 대입
    $game_variables[126] = @user.id if @user != nil
    $game_variables[128] = @item.id if @item != nil

    @step_anime = true
    
    moveto(user.x, user.y)
    set_direction(user.direction)
    
    @customsteps = custom if custom.is_a?(Integer)
    @original_item = @item
    @target_effect = [false, target=nil]
    
    set_targeting
    return if PearlKernel.user_graphic.nil?
    
    load_item_data
    
    jump(0, 0) if @user.passable?(@user.x, @user.y, @user.direction) and PearlKernel.tool_shortjump == "true"
    if @tool_special == "triple"
      @triple = custom
      move_forward if @tool_distance > 2
    elsif @tool_special == "quintuple"
      @quintuple = custom
      move_forward if @tool_distance > 2
    elsif @tool_special == "octuple"
      @octuple = custom
      if @octuple == :seis || @octuple == :siete || @octuple == :ocho
        @direction = 8 if @user.direction == 2
        @direction = 6 if @user.direction == 4
        @direction = 4 if @user.direction == 6
        @direction = 2 if @user.direction == 8
      end
    end
    
    @move_speed == 6 ? @mini_opacity = 7 : @mini_opacity = 9
    @opacity = 0
    
    if @user.battler.is_a?(Game_Enemy) or @user.is_a?(Game_Player)
      if !@item.is_a?(RPG::Weapon) and !@item.is_a?(RPG::Armor)
        check_combo_effect
      end
    elsif @user.battler.is_a?(Game_Actor)
      check_combo_effect
      check_combo_effect2 if @user.combodata.empty?
    end
  end

  # 콤보
  def check_combo_effect
    c = PearlKernel.tool_combo
    return if c == 'nil' || c.nil?
    c = c.split(", ")
    return if c[1] == 'nil'
    if rand(100) <= c[2].to_i + 30
      case c[0]
      when '무기' then @user.combodata << [:weapon, c[1].to_i, c[3], 20]
      when '방어구'  then @user.combodata << [:armor,  c[1].to_i, c[3], 20]
      when '도구'   then @user.combodata << [:item,   c[1].to_i, c[3], 20]
      when '스킬'  then @user.combodata << [:skill,  c[1].to_i, c[3], 20]
      end
    end
    @has_combo = true
  end
  
  def check_combo_effect2
    a = 0
    a += 30 if @user.battler.come_skill != 'nil'
    a += 30 if @user.battler.come_skill2 != 'nil'
    a += 10 if @user.battler.come_skill3 != 'nil'
    a += 10 if @user.battler.come_skill4 != 'nil'
    a += 5  if @user.battler.come_skill5 != 'nil'
    a += 5  if @user.battler.come_skill6 != 'nil'
    a += 5  if @user.battler.come_skill7 != 'nil'
    a += 5  if @user.battler.come_skill8 != 'nil'
    if a != 0
      loop do
        case rand(a)
          when 1..30;   @user.combodata << [:skill, @user.battler.come_skill, 100, 20]
          when 31..60;  @user.combodata << [:skill, @user.battler.come_skill2, 100, 20]
          when 61..70;  @user.combodata << [:skill, @user.battler.come_skill3, 100, 20]
          when 71..80;  @user.combodata << [:skill, @user.battler.come_skill4, 100, 20]
          when 81..85;  @user.combodata << [:skill, @user.battler.come_skill5, 100, 20]
          when 86..90;  @user.combodata << [:skill, @user.battler.come_skill6, 100, 20]
          when 91..95;  @user.combodata << [:skill, @user.battler.come_skill7, 100, 20]
          when 96..100; @user.combodata << [:skill, @user.battler.come_skill8, 100, 20]
        end
        break if !@user.combodata.empty?
      end
    end
    #print("119.Projectile - check_combo_effect2, %s \n" % [a]);
    @has_combo = true
  end
  
  # 발사체 배틀러를 얻으십시오, 사용자의 속성이 필요합니다.
  def battler
    return nil if @commonevent_id.nil?
    return @user.battler
  end

    # 목표를 정하다.
  def set_targeting
    return unless @item.is_a?(RPG::Item) || PearlKernel.tool_target == "true" || ["JP1", "JP2", "JP3"].include?(@tool_special)

    if @user.targeting[0] && !@user.battler.is_a?(Game_Enemy)
      unless ["JP1", "JP2", "JP3"].include?(@tool_special)
        @target_effect = [@user.targeting[0], @user.targeting[2]]
        @user.turn_toward_character(@target_effect[1])
      end
      if @tool_special == "JP1" && @user.targeting[2]
        @user.turn_toward_event(@user.targeting[2].id)
        @direction_fix = true
        @direction = @user.direction
        @targ_id = @user.targeting[2].id
        if rand(100) > @user.battler.hit * 100
          if $game_map.events[@targ_id]
            @user.jump_miss($game_map.events[@targ_id].x, $game_map.events[@targ_id].y, @tool_distance)
          end
        else
          if $game_map.events[@targ_id]
            @user.jump_m($game_map.events[@targ_id].x, $game_map.events[@targ_id].y, @tool_distance)
          end
        end
        @direction_fix = false
        moveto(@user.x, @user.y)
        move_forward
        return
      end

      if @tool_special == "JP2" && @user.targeting[2]
        @user.turn_toward_event(@user.targeting[2].id)
        @direction_fix = true
        @direction = @user.direction
        @targ_id = @user.targeting[2].id
        if rand(100) > @user.battler.hit * 100
          if $game_map.events[@targ_id]
            jump_miss($game_map.events[@targ_id].x, $game_map.events[@targ_id].y, @tool_distance)
          end
        else
          if $game_map.events[@targ_id]
            jump_m($game_map.events[@targ_id].x, $game_map.events[@targ_id].y, @tool_distance)
          end
        end
        @direction_fix = false
        return
      end

      if @tool_special == "JP3" && @user.targeting[2]
        @user.turn_toward_event(@user.targeting[2].id)
        @direction_fix = true
        @direction = @user.direction
        @targ_id = @user.targeting[2].id
        if rand(100) > @user.battler.hit * 100
          if $game_map.events[@targ_id]
            @user.jump_miss($game_map.events[@targ_id].x, $game_map.events[@targ_id].y, @tool_distance)
          end
        else
          if $game_map.events[@targ_id]
            @user.jump_m($game_map.events[@targ_id].x, $game_map.events[@targ_id].y, @tool_distance)
          end
        end
        @direction_fix = false
        moveto(@user.x, @user.y)
        return
      end
    end
  end
  # 항목 변수 로드
  def load_item_data
    @character_name = PearlKernel.tool_graphic
    # 휠윈드 스킬 처럼 착용한 무기 그래픽으로 표기하는 경우
    #if @character_name == "$W_Weapon" and @user.battler.is_a?(Game_Actor)
    #  if @user.battler.equips[0] != nil
    #    @character_name = @user.battler.equips[0].tool_data("User Graphic = ", false)
    #  end
    #end
    #@character_name = "$W_Weapon" if @character_name == "nil"
    
    if @character_name == "nil"
      @character_name = @user.character_name
      @transparent = true
    end
    
    @character_index      = PearlKernel.tool_index
    @tool_size            = PearlKernel.tool_size
    @tool_distance        = PearlKernel.tool_distance
    
    # 다단 히트 추가
    #@tool_mt_hits        = PearlKernel.tool_mt_hits
    #if @tool_mt_hits == nil
    #  @tool_mt_hits = 1
    #end
    
    # 활 관련 스킬 사거리 무기에서 가져오도록 수정
    #if @user.battler.is_a?(Game_Actor) and @user.battler.equips[0] != nil and PearlKernel.tool_graphic == $W_Arrow
    #  @tool_distance = user.battler.equips[0].tool_data("Tool Distance = ")
    #end
    
    @tool_effect_delay    = PearlKernel.tool_effectdelay
    @tool_destroy_delay   = PearlKernel.tool_destroydelay
    @move_speed           = PearlKernel.tool_speed
    @tool_blow_power      = PearlKernel.tool_blowpower

    # 욕구 데미지 추가
    @tool_hunger          = PearlKernel.tool_hunger
    @tool_thirst          = PearlKernel.tool_thirst
    @tool_sleep           = PearlKernel.tool_sleep
    @tool_sexual          = PearlKernel.tool_sexual
    @tool_hygiene         = PearlKernel.tool_hygiene
    @tool_temper          = PearlKernel.tool_temper
    @tool_stress          = PearlKernel.tool_stress
    @tool_cold            = PearlKernel.tool_cold
    
    @tool_piercing        = PearlKernel.tool_piercing
    @tool_piercing        = PearlKernel.tool_piercing == "true"
    @tool_end_anime       = PearlKernel.tool_animation
    if @tool_end_anime.split(" ").include?('delay')
      @tool_end_anime = @tool_end_anime.sub("delay ","").to_i
    end
    @tool_animerepeat     = PearlKernel.tool_anirepeat == "true"
    @tool_invoke = PearlKernel.tool_invoke
    @tool_guardrate = PearlKernel.tool_guardrate
    
    @tool_knockdownrate = 0
    #@tool_knockdownrate = PearlKernel.tool_knockdown
    
    @stopped_movement_2 = PearlKernel.tool_stop_move2
    
    if @user.is_a?(Game_Actor) or @user.is_a?(Game_Player)
      # 활 숙련도 확인
      if @item.tool_data("Tool Item Cost = ") == 19
        @tool_distance_pls = 0
        @tool_distance_pls += 1 if @user.battler.skill_learn?($data_skills[466])
        @tool_distance_pls += 1 if @user.battler.skill_learn?($data_skills[467])
        @tool_distance_pls += 1 if @user.battler.skill_learn?($data_skills[468])
        @tool_distance_pls += 1 if @user.battler.skill_learn?($data_skills[469])
        if @user.battler.skill_learn?($data_skills[470])
          @tool_distance_pls += 1
          @move_speed = PearlKernel.tool_speed + 1
        end
        @tool_distance = PearlKernel.tool_distance + @tool_distance_pls
      end
      # 메이스 숙련도
      if (@user.battler.equips[0] != nil and @user.battler.equips[0].wtype_id == 8) or
        (@user.battler.equips[1] != nil and @user.battler.equips[1].is_a?(RPG::Weapon) and @user.battler.equips[1].wtype_id == 8)
        @tool_stop_pls = 0
        @tool_stop_pls += 20 if @user.battler.skill_learn?($data_skills[475])
        @tool_stop_pls += 20 if @user.battler.skill_learn?($data_skills[476])
        @tool_stop_pls += 20 if @user.battler.skill_learn?($data_skills[477])
        @tool_stop_pls += 20 if @user.battler.skill_learn?($data_skills[478])
        @tool_stop_pls += 100 if @user.battler.skill_learn?($data_skills[479])
        if PearlKernel.tool_stop_move2 != nil
          @stopped_movement_2 = PearlKernel.tool_stop_move2 + @tool_stop_pls
        else
          @stopped_movement_2 = @tool_stop_pls
        end
      end
    end
    
    @tool_selfdamage = PearlKernel.tool_selfdamage == "true"
    @tool_hitshake = PearlKernel.tool_hitshake == "true"
    sound = PearlKernel.tool_soundse
    RPG::SE.new(sound, 80).play rescue nil if sound != "nil"
    @original_distance = @tool_distance
    @mnganime = 0
    if @customsteps != nil
      @pattern = 0
      @tool_distance = @customsteps
      @pattern = 1 if @customsteps + 1 == @original_distance
      @transparent = true if @customsteps == 0
      @user.battler_chain.push(self)
    end
    @tool_retracting = false
    if @tool_special == "area" and @target_effect[0]
      @user.turn_toward_character(@target_effect[1])
      moveto(@target_effect[1].x, @target_effect[1].y)
    end
    @originaldestory_delay = @tool_destroy_delay
    @priority_type = PearlKernel.tool_priority
    if @tool_special == "spiral"
      @spintimer = 0
      @dir_was = @user.direction
      moveto(@user.x + @user.adjustcxy[0], @user.y + @user.adjustcxy[1]) if
      !@user.facing_corners?
      @spintimes = @tool_distance
      @tool_distance = 0
      @user.making_spiral = true
    # 뒤로 회피 이동
    elsif @tool_special == "MF4"
      @user.move_backward
      @user.move_backward
      @tool_distance = 0
    end
    
    PearlKernel.check_iconset(@item, "Projectile Iconset = ", self)
    
    @character_name = "" if @pro_iconset != nil
    
    @pick_able = @item.note.include?('<pick up>')
    @ignore_followers = @item.note.include?('<ignore_followers>')

    # 공격시 해당 엑터 피로도 증가
    if !@user.battler.is_a?(Game_Enemy)
      @user.battler.sleep += 0.2    # 피로
      @user.battler.hunger += 0.2   # 허기
      @user.battler.thirst += 0.1   # 갈증
      @user.battler.sexual -= 0.2   # 성욕
      @user.battler.stress -= 0.1   # 스트레스
    end
    
    if @tool_special != "shield" and !@item.note.include?('<ignore_voices>')
      voices = PearlKernel.voices(@user.battler)
      # 아래는 플레이어만 해당
      if $game_switches[200] == true and @user.is_a?(Game_Player) and @user.battler.is_a?(Game_Enemy) == false
        # 공격시 이미지로 전환
        $game_variables[126] = $game_player.actor.id
        # 아래는 모든 동료 포함
        if $game_player.actor.id == 7 and $game_switches[46] == false and $game_switches[195] == false
          # 기본 공격시에도 모션을 적용
          if $game_switches[57] == false
            # 공격대사 진행
            $game_temp.reserve_common_event(7)
          elsif $game_switches[57] == true and magical_item? == true
            # 공격대사 진행
            $game_temp.reserve_common_event(7)
          end
        end
      end
      RPG::SE.new(voices[rand(voices.size)], 80).play unless voices.nil?
    end
    #apply_item_transform if @item.is_a?(RPG::Weapon) || @item.is_a?(RPG::Armor)
  end

  # 도구 변수를 로드한 후 도구를 변환할 수 있는지 확인합니다.
  def apply_item_transform
    if @tool_invoke > 0 and @tool_invoke != 1 and @tool_invoke != 2
      @item = $data_skills[@tool_invoke]
    end
  end

  def magical_item?
    return true if @item.is_a?(RPG::Skill) || @item.is_a?(RPG::Item)
    return false
  end

  def update
    super
    # --------------------------------------------------------------------------
    # 아래는 시간 가속중이 아닌 경우에만 적용
    # --------------------------------------------------------------------------
    if $game_switches[283] == false
      if magical_item?
        case @item.scope
        when 0 # 범위 0 사용자에게 효과를 적용합니다.
          apply_self_effect(@user, true);    return
        when 7 # 아군 1명 치료
          apply_effectto_selection;          return
        when 8 # 모두를 치유
          apply_effectto_all_allies;         return
        when 9 # 아군 1명 소생
          apply_effectto_selection;          return
        when 10 # 모두 소생
          apply_effectto_all_allies;         return
        when 11 # 사용자에게
          apply_self_effect(@user, true);    return
        end
      end

      @precombi = @user.doingcombo > 0 if @precombi.nil?
      
      # 도구 토큰 생략
      #update_tool_token
      
      # 범위가 유익한 효과가 없을 때 계속
      if @target_effect[0]
        follow_char(@target_effect[1]) if !moving?
        @tool_distance = 0
      end
      
      @tool_distance = 0 if @tool_special == "area"
      update_timer
      # 휠윈드 추가
      if @item.is_a?(RPG::Skill) and @tool_special == "hillwind"
        if @user.battler.is_a?(Game_Actor) and @user.is_a?(Game_Player)
          if @user.battler.tp >= 1
            if Keyboard.press?(Key::Skill[0]) or Keyboard.press?(Key::Skill2[0]) or
              Keyboard.press?(Key::Skill3[0]) or Keyboard.press?(Key::Skill4[0]) or
              Keyboard.press?(Key::Skill5[0]) or Keyboard.press?(Key::Skill6[0]) or
              Keyboard.press?(Key::Skill7[0]) or Keyboard.press?(Key::Skill8[0])
              case @user.direction
              when 2;  @user.set_direction(6)
              when 4;  @user.set_direction(2)
              when 6;  @user.set_direction(8)
              when 8;  @user.set_direction(4)
              end
              @tool_destroy_delay = 5
              @user.animation_id = 36
              @user.anime_speed = rand(30)+15
              # 플레이어는 휠윈드 사용중 이동 가능
              @user.move_speed = 2
              if !@user.moving?
                if Input.press?(:LEFT) && Input.press?(:DOWN)
                  if passable?(@user.x, @user.y, 4) && passable?(@user.x, @user.y, 2) &&
                    passable?(@user.x - 1, @user.y, 2) && passable?(@user.x, @user.y + 1, 4) &&
                    passable?(@user.x - 1, @user.y + 1, 6) && passable?(@user.x - 1, @user.y + 1, 8)
                    @user.move_diagonal(4, 2)
                  elsif @user.direction == 4
                    if passable?(@user.x, @user.y, 2) && passable?(@user.x, @user.y + 1, 8)
                      @user.move_straight(2)
                    elsif passable?(@user.x, @user.y, 4) && passable?(@user.x - 1, @user.y, 6)
                      @user.move_straight(4)
                    elsif Input.dir4 > 0
                      @user.move_straight(Input.dir4) if passable?(@user.x, @user.y, Input.dir4)
                    end
                  elsif @user.direction == 2
                    if passable?(@user.x, @user.y, 4) && passable?(@user.x - 1, @user.y, 6)
                      @user.move_straight(4)
                    elsif passable?(@user.x, @user.y, 2) && passable?(@user.x, @user.y + 1, 8)
                      @user.move_straight(2)
                    elsif Input.dir4 > 0
                      @user.move_straight(Input.dir4) if passable?(@user.x, @user.y, Input.dir4)
                    end
                  end
                elsif Input.press?(:RIGHT) && Input.press?(:DOWN)
                  if passable?(@user.x, @user.y, 6) && passable?(@user.x, @user.y, 2) &&
                    passable?(@user.x + 1, @user.y, 2) && passable?(@user.x, @user.y + 1, 6) &&
                    passable?(@user.x + 1, @user.y + 1, 4) && passable?(@user.x + 1, @user.y + 1, 8)
                    @user.move_diagonal(6, 2)
                  elsif @user.direction == 6
                    if passable?(@user.x, @user.y, 2) && passable?(@user.x, @user.y + 1, 8)
                      @user.move_straight(2)
                    elsif passable?(@user.x, @user.y, 6) && passable?(@user.x + 1, @user.y, 4)
                      @user.move_straight(6)
                    elsif Input.dir4 > 0
                      @user.move_straight(Input.dir4) if passable?(@user.x, @user.y, Input.dir4)
                    end
                  elsif @user.direction == 2
                    if passable?(@user.x, @user.y, 6) && passable?(@user.x + 1, @user.y, 4)
                      @user.move_straight(6)
                    elsif passable?(@user.x, @user.y, 2) && passable?(@user.x, @user.y + 1, 8)
                      @user.move_straight(2)
                    elsif Input.dir4 > 0
                      @user.move_straight(Input.dir4) if passable?(@user.x, @user.y, Input.dir4)
                    end
                  end
                elsif Input.press?(:LEFT) && Input.press?(:UP)
                  if passable?(@user.x, @user.y, 4) && passable?(@user.x, @user.y, 8) &&
                    passable?(@user.x - 1, @user.y, 8) && passable?(@user.x, @user.y - 1, 4) &&
                    passable?(@user.x - 1, @user.y - 1, 2) && passable?(@user.x - 1, @user.y - 1, 6)
                    @user.move_diagonal(4, 8)
                  elsif @user.direction == 4
                    if passable?(@user.x, @user.y, 8) && passable?(@user.x, @user.y - 1, 2)
                      @user.move_straight(8)
                    elsif passable?(@user.x, @user.y, 4) && passable?(@user.x - 1, @user.y, 6)
                      @user.move_straight(4)
                    elsif Input.dir4 > 0
                      @user.move_straight(Input.dir4) if passable?(@user.x, @user.y, Input.dir4)
                    end
                  elsif @user.direction == 8
                    if passable?(@user.x, @user.y, 4) && passable?(@user.x - 1, @user.y, 6)
                      @user.move_straight(4)
                    elsif passable?(@user.x, @user.y, 8) && passable?(@user.x, @user.y - 1, 2)
                      @user.move_straight(8)
                    elsif Input.dir4 > 0
                      @user.move_straight(Input.dir4) if passable?(@user.x, @user.y, Input.dir4)
                    end
                  end
                elsif Input.press?(:RIGHT) && Input.press?(:UP)
                  if passable?(@user.x, @user.y, 6) && passable?(@user.x, @user.y, 8) &&
                    passable?(@user.x + 1, @user.y, 8) && passable?(@user.x, @user.y - 1, 6) &&
                    passable?(@user.x + 1, @user.y - 1, 2) && passable?(@user.x + 1, @user.y - 1, 4)
                    @user.move_diagonal(6, 8)
                  elsif @user.direction == 6
                    if passable?(@user.x, @user.y, 8) && passable?(@user.x, @user.y - 1, 2)
                      @user.move_straight(8)
                    elsif passable?(@user.x, @user.y, 6) && passable?(@user.x + 1, @user.y, 4)
                      @user.move_straight(6)
                    elsif Input.dir4 > 0
                      @user.move_straight(Input.dir4) if passable?(@user.x, @user.y, Input.dir4)
                    end
                  elsif @user.direction == 8
                    if passable?(@user.x, @user.y, 6) && passable?(@user.x + 1, @user.y, 4)
                      @user.move_straight(6)
                    elsif passable?(@user.x, @user.y, 8) && passable?(@user.x, @user.y - 1, 2)
                      @user.move_straight(8)
                    elsif Input.dir4 > 0
                      @user.move_straight(Input.dir4) if passable?(@user.x, @user.y, Input.dir4)
                    end
                  end
                elsif Input.dir4 > 0
                  @user.move_straight(Input.dir4) if passable?(@user.x, @user.y, Input.dir4)
                end
              end
              if @x != @user.x or @y != @user.y
                moveto(@user.x, @user.y)
              end
              # 특정 상태이상 제거
              #@user.battler.remove_state(43) # 방어 태세
              #@user.battler.remove_state(166) # 철웅성 제거
              # 특정 상태이상 추가
              @user.battler.add_state(116) if rand(10) == 10  # 호흡 곤란
              # 공격대사 진행
              if @user.battler.id == 7 and $game_switches[46] == false and $game_switches[195] == false 
                $game_temp.reserve_common_event(7)
                # tp 감소 적용
                @user.battler.tp -= 1
              end
            end
          end
        else
          case @user.direction
          when 2;  @user.set_direction(6)
          when 4;  @user.set_direction(2)
          when 6;  @user.set_direction(8)
          when 8;  @user.set_direction(4)
          end
          @user.animation_id = 36
          @user.anime_speed = rand(30)+15
          @user.move_speed = 2
          move_speed = 2
          if @user.battler.is_a?(Game_Actor) and @user.targeted_character != nil
            if !@user.obj_size?(@user.targeted_character, 2) and @user.battler.set_custom_bio[19].to_i != 1
              move_toward_event(@user.targeted_character.id)
            else
              if $game_switches[196] == true
                @tool_destroy_delay += rand(3)
              else
                @tool_destroy_delay = 1
              end
            end
          # 몬스터 휠윈드
          elsif !@user.battler.is_a?(Game_Actor)
            if !@user.moving? and !obj_size?($game_player, 2)
              @user.pathfind($game_player.x, $game_player.y)
              pathfind($game_player.x, $game_player.y)
            elsif !@user.battler.dead?
              @tool_destroy_delay += rand(2)
            else
              @tool_destroy_delay = 1
            end
          end
          if @x != @user.x or @y != @user.y
            moveto(@user.x, @user.y)
          end
        end
      end
      # 도구 특수 쉴드 엔진
      if @item.is_a?(RPG::Armor) and @tool_special == "shield"
        if !@user.battler.state?(9)
          if @tool_invoke > 0
            @user.battler.melee_attack_apply(@user.battler,@tool_invoke)
          else
            @user.battler.item_apply(@user.battler, $data_skills[2])
          end
          @user.battler_guarding[0] = true
          @user.battler_guarding[1] = @tool_guardrate
        elsif @user.battler.state?(9)
          if @user.battler.is_a?(Game_Actor)
            if @user.is_a?(Game_Player)
              if Keyboard.press?(Key::Armor[0])
                @user.battler.add_state(9)
                @tool_destroy_delay = 10
                @user.anime_speed = 10
              else
                @user.battler.remove_state(9)
                @tool_destroy_delay = 0
                @user.anime_speed = 0
                @user.battler_guarding = [false, nil]
                return
              end
              @user.direction = 2 if Input.dir4 == 2
              @user.direction = 4 if Input.dir4 == 4
              @user.direction = 6 if Input.dir4 == 6
              @user.direction = 8 if Input.dir4 == 8
              # 플레이어는 방패 사용중 이동 가능
              # @user.move_speed = 3
              # 115.Game_Party 스크립트로 이동
              if !@user.moving?
                if Input.press?(:LEFT) && Input.press?(:DOWN)
                  if passable?(@user.x, @user.y, 4) && passable?(@user.x, @user.y, 2) &&
                    passable?(@user.x - 1, @user.y, 2) && passable?(@user.x, @user.y + 1, 4) &&
                    passable?(@user.x - 1, @user.y + 1, 6) && passable?(@user.x - 1, @user.y + 1, 8)
                    @user.move_diagonal(4, 2)
                  elsif @user.direction == 4
                    if passable?(@user.x, @user.y, 2) && passable?(@user.x, @user.y + 1, 8)
                      @user.move_straight(2)
                    elsif passable?(@user.x, @user.y, 4) && passable?(@user.x - 1, @user.y, 6)
                      @user.move_straight(4)
                    elsif Input.dir4 > 0
                      @user.move_straight(Input.dir4) if passable?(@user.x, @user.y, Input.dir4)
                    end
                  elsif @user.direction == 2
                    if passable?(@user.x, @user.y, 4) && passable?(@user.x - 1, @user.y, 6)
                      @user.move_straight(4)
                    elsif passable?(@user.x, @user.y, 2) && passable?(@user.x, @user.y + 1, 8)
                      @user.move_straight(2)
                    elsif Input.dir4 > 0
                      @user.move_straight(Input.dir4) if passable?(@user.x, @user.y, Input.dir4)
                    end
                  end
                elsif Input.press?(:RIGHT) && Input.press?(:DOWN)
                  if passable?(@user.x, @user.y, 6) && passable?(@user.x, @user.y, 2) &&
                    passable?(@user.x + 1, @user.y, 2) && passable?(@user.x, @user.y + 1, 6) &&
                    passable?(@user.x + 1, @user.y + 1, 4) && passable?(@user.x + 1, @user.y + 1, 8)
                    @user.move_diagonal(6, 2)
                  elsif @user.direction == 6
                    if passable?(@user.x, @user.y, 2) && passable?(@user.x, @user.y + 1, 8)
                      @user.move_straight(2)
                    elsif passable?(@user.x, @user.y, 6) && passable?(@user.x + 1, @user.y, 4)
                      @user.move_straight(6)
                    elsif Input.dir4 > 0
                      @user.move_straight(Input.dir4) if passable?(@user.x, @user.y, Input.dir4)
                    end
                  elsif @user.direction == 2
                    if passable?(@user.x, @user.y, 6) && passable?(@user.x + 1, @user.y, 4)
                      @user.move_straight(6)
                    elsif passable?(@user.x, @user.y, 2) && passable?(@user.x, @user.y + 1, 8)
                      @user.move_straight(2)
                    elsif Input.dir4 > 0
                      @user.move_straight(Input.dir4) if passable?(@user.x, @user.y, Input.dir4)
                    end
                  end
                elsif Input.press?(:LEFT) && Input.press?(:UP)
                  if passable?(@user.x, @user.y, 4) && passable?(@user.x, @user.y, 8) &&
                    passable?(@user.x - 1, @user.y, 8) && passable?(@user.x, @user.y - 1, 4) &&
                    passable?(@user.x - 1, @user.y - 1, 2) && passable?(@user.x - 1, @user.y - 1, 6)
                    @user.move_diagonal(4, 8)
                  elsif @user.direction == 4
                    if passable?(@user.x, @user.y, 8) && passable?(@user.x, @user.y - 1, 2)
                      @user.move_straight(8)
                    elsif passable?(@user.x, @user.y, 4) && passable?(@user.x - 1, @user.y, 6)
                      @user.move_straight(4)
                    elsif Input.dir4 > 0
                      @user.move_straight(Input.dir4) if passable?(@user.x, @user.y, Input.dir4)
                    end
                  elsif @user.direction == 8
                    if passable?(@user.x, @user.y, 4) && passable?(@user.x - 1, @user.y, 6)
                      @user.move_straight(4)
                    elsif passable?(@user.x, @user.y, 8) && passable?(@user.x, @user.y - 1, 2)
                      @user.move_straight(8)
                    elsif Input.dir4 > 0
                      @user.move_straight(Input.dir4) if passable?(@user.x, @user.y, Input.dir4)
                    end
                  end
                elsif Input.press?(:RIGHT) && Input.press?(:UP)
                  if passable?(@user.x, @user.y, 6) && passable?(@user.x, @user.y, 8) &&
                    passable?(@user.x + 1, @user.y, 8) && passable?(@user.x, @user.y - 1, 6) &&
                    passable?(@user.x + 1, @user.y - 1, 2) && passable?(@user.x + 1, @user.y - 1, 4)
                    @user.move_diagonal(6, 8)
                  elsif @user.direction == 6
                    if passable?(@user.x, @user.y, 8) && passable?(@user.x, @user.y - 1, 2)
                      @user.move_straight(8)
                    elsif passable?(@user.x, @user.y, 6) && passable?(@user.x + 1, @user.y, 4)
                      @user.move_straight(6)
                    elsif Input.dir4 > 0
                      @user.move_straight(Input.dir4) if passable?(@user.x, @user.y, Input.dir4)
                    end
                  elsif @user.direction == 8
                    if passable?(@user.x, @user.y, 6) && passable?(@user.x + 1, @user.y, 4)
                      @user.move_straight(6)
                    elsif passable?(@user.x, @user.y, 8) && passable?(@user.x, @user.y - 1, 2)
                      @user.move_straight(8)
                    elsif Input.dir4 > 0
                      @user.move_straight(Input.dir4) if passable?(@user.x, @user.y, Input.dir4)
                    end
                  end
                elsif Input.dir4 > 0
                  @user.move_straight(Input.dir4) if passable?(@user.x, @user.y, Input.dir4)
                end
              end
              # 방패 사용중 이동 가능 종료
            end
          else
            if @user.is_a?(Game_Event) and @user.agroto_f != nil
              @user.turn_toward_character(@user.agroto_f)
            else
              @user.turn_toward_character($game_player)
            end
          end
        end
        return
      end
      
      # 방패가 주어지지 않으면 계속
      update_hookshotdef if @customsteps != nil          # update hookshot
      update_boomerand if @tool_special == "boomerang"   # update boomerang
      update_spiral if @tool_special == "spiral"         # update spiral
      return if @transparent and @customsteps != nil     # return is tranparent
      update_damage                                      # update damage
    end
    # --------------------------------------------------------------------------
    # 위는 시간 가속중이 아닌 경우에만 적용
    # --------------------------------------------------------------------------
  end
  
  def update_hookshotdef
    @tool_destroy_delay = 1000
    @tool_size = 1
    # 이동 속도 증가
    @move_speed = 7
    @user.move_speed = 7
    @tool_piercing = true if !@tool_piercing
    for event in $game_map.events_withtags
      # 이동 속도 증가
      event.move_speed = 7
      if obj_size?(event, @tool_size)
        if event.hook_pull && !@user.hookshoting[1]
          break if @transparent
          break if event.x == @user.x and event.y == @user.y
          @user.hookshoting[1] = true
          @tool_distance = 0
          @user.user_move_distance[0] = @customsteps
          @user.user_move_distance[1] = @user.move_speed + 3
          @user.user_move_distance[2] = @user.through
          @user.user_move_distance[3] = [@x, @y]
          @user.move_speed = @move_speed
          @user.through = true
          @user.battler_chain.each {|c| c.tool_distance = 0
          if c.customsteps == c.original_distance - 1 # 이것이 마지막 사슬이다
            if c.in_frontof?(self)
              self.pattern = c.pattern # 편의를 위한 패턴 변경
              c.pattern = 0
            end
          end
          }
        elsif event.hook_grab and !@user.hookshoting[2]
          break if event.being_grabbed
          break if @user.in_frontof?(event)
          event.being_grabbed = true
          @user.hookshoting[2] = true
          @user.battler_chain.each {|i|
          i.pattern = 1 if i.customsteps == @customsteps - 2
          next if i.customsteps < @customsteps - 1
          i.transparent = true
          }
          event.user_move_distance[0] = @customsteps
          event.user_move_distance[1] = event.move_speed + 3
          event.user_move_distance[2] = event.through
          @user.user_move_distance[3] = event
          event.move_speed = @move_speed - 0.3
          event.through = true
          event.turn_toward_character(@user)
        end
      end
    end

    # 사용자가 당겨지는 경우
    if @user.hookshoting[1]
      @user.battler_chain.each do |pr|
        if pr.x == @user.x and pr.y == @user.y
          pr.destroy_it = true
          if @user.user_move_distance[3][0] == @user.x and @user.user_move_distance[3][1] == @user.y
            # 훅샷 실험
            if @user.direction == 2;  @user.y -= 1; end
            if @user.direction == 8;  @user.y += 1; end
            if @user.direction == 4;  @user.x += 1; end
            if @user.direction == 6;  @user.x -= 1; end
            @user.battler_chain.clear
            # 이동 속도 증가
            @user.move_speed = @user.user_move_distance[1] + 3
            @user.through = @user.user_move_distance[2]
            @user.hookshoting[3] = 30
            @user.hookshoting[1] = false
            if @user.is_a?(Game_Player) and !@user.follower_fighting?
              @user.followers.gather 
            end
          end
        end
      end
      return 
    # 사용자가 잡는 경우
    elsif @user.hookshoting[2]
      event = @user.user_move_distance[3]
      if @user.in_frontof?(event)
        # 이동 속도 증가
        event.move_speed = event.user_move_distance[1] + 3
        event.through = event.user_move_distance[2]
        @user.hookshoting[2] = false
        event.user_move_distance[0] = 0
        @user.hookshoting[3] = 70
      end
    end

    # 후퇴 엔진 훅샷
    if @customsteps + 1 == @original_distance && @tool_distance == 0 && !moving?
      @user.battler_chain.each do |projectile|
        next if projectile.tool_retracting
        projectile.tool_retracting = true
        projectile.direction_fix = true
      end
    end

    # 취소
    @user.battler_chain.each do |pr|
      if pr.tool_retracting
        pr.destroy_it = true if @user.facing_corners?
        pr.move_toward_character(@user) if !pr.moving?
        if pr.x == @user.x and pr.y == @user.y
          pr.destroy_it = true 
          if pr.customsteps == pr.original_distance - 1
            @user.battler_chain.clear
            @user.hookshoting[3] = 10
            # 오류 수정
            #@user.through = false if @user.is_a?(Game_Player)
          end
        end
      end
    end
  end 
  
  # 스페셜 부메랑
  def update_boomerand
    $game_map.events_withtags.each do |event|
      if event.boom_grab || !event.dropped_items.empty?
        if event.boom_grabdata.nil? and obj_size?(event, @tool_size)
          event.boom_grabdata = [event.move_speed, event.through]
          event.move_speed = 6
          event.through = true
        end
      end
      
      # 부메랑에게 잡혀가는 사건
      if !event.boom_grabdata.nil?
        event.x, event.y = @x, @y
        if event.obj_size?(@user, 2)
          reset_boomed(event)
          unless event.jumping?
            event.jumpto_tile(@user.x, @user.y) 
            event.direction = event.page.graphic.direction rescue 2
            event.start if event.boom_start && !event.killed
          end
        end
        reset_boomed(event) if @tool_destroy_delay == 1 and obj_size?(event, 1) 
      end
    end
    
    # 사용자와 충돌할 때 파괴될 도구를 준비합니다.
    if @tool_destroy_delay <= @originaldestory_delay - 50
      move_toward_character(@user) if !moving?
      if @x == @user.x and @y == @user.y
        @user.anime_speed = 0
        @destroy_it = true 
      end
    end
  end
  
  def reset_boomed(event)
    event.move_speed = event.boom_grabdata[0]
    event.through = event.boom_grabdata[1]
    event.boom_grabdata = nil
  end
  
  # 나선 업데이트
  def update_spiral
    @spintimer += 1
    case @spintimer
    when 6  then make_rounds(1)
    when 12 then make_rounds(2)
    when 18 then make_rounds(3)
    when 24 then make_rounds(4)
      if @spintimes > 1
        @spintimer = 0
        @spintimes -= 1
      end
    when 40
      @destroy_it = true 
      @user.anime_speed = 0
    end
  end
  
  # 방향을 찾기 위해 도구와 사용자를 이동
  def movetofront(dir, conditional)
    @user.direction = dir if @user.direction == conditional
    moveto(@user.x + @user.adjustcxy[0], @user.y + @user.adjustcxy[1]) if
    !@user.facing_corners?
    @direction = @user.direction
  end
  
  # 사용자 방향에 따라 둥글게 만들기
  def make_rounds(type)
    case type
    when 1
      movetofront(4, 2) if @dir_was == 2 ; movetofront(8, 4) if @dir_was == 4
      movetofront(2, 6) if @dir_was == 6 ; movetofront(6, 8) if @dir_was == 8
    when 2
      movetofront(8, 4) if @dir_was == 2 ; movetofront(6, 8) if @dir_was == 4
      movetofront(4, 2) if @dir_was == 6 ; movetofront(2, 6) if @dir_was == 8
    when 3
      movetofront(6, 8) if @dir_was == 2 ; movetofront(2, 6) if @dir_was == 4
      movetofront(8, 4) if @dir_was == 6 ; movetofront(4, 2) if @dir_was == 8
    when 4
      movetofront(2, 6) if @dir_was == 2 ; movetofront(4, 2) if @dir_was == 4
      movetofront(6, 8) if @dir_was == 6 ; movetofront(8, 4) if @dir_was == 8
    end
  end
  
  #=============================================================================
  # 사용자와 아군에게 이로운 효과 적용
  #=============================================================================
  # 단일 선택에 효과 적용
  def apply_effectto_selection
    # 배틀러가 게임 액터인 경우 효과가 대상에 적용됩니다.
    if @user.battler.is_a?(Game_Actor)
      # 사용자가 팔로어고 액터에 대한 범위인 경우
      if !@user.is_a?(Game_Player) and (@item.scope == 7 or @item.scope == 9)
        #print("119.Projectile - 타겟 지정 1, %s \n" % [@item.scope]);
        # 액터 1명에게 효과 적용
        @ai = nil
        @rand_follow = []
        $game_player.followers.each {|i|
        next unless i.visible?
        @rand_follow.push(i)}
        @ai = $game_player.followers[rand(@rand_follow.length)]
        apply_self_effect(@ai, pop=true)
      else
        # 플레이어 부분
        if $game_party.members.size == 1 and (@item.scope == 7 or @item.scope == 9)
          #print("119.Projectile - 타겟 지정 2, %s \n" % [@item.scope]);
          # 사용자에게 사용된다.
          apply_self_effect(@user, true)
        else
          #print("119.Projectile - 타겟 지정 3, %s \n" % [@item.scope]);
          # 타겟에게 사용된다.
          # 타겟 지정은 '027 + Game_CharacterBase' 에서 진행
          apply_self_effect(@target_effect[1], true)
        end
      end
    else
      # 적들은 무작위 대상 아군을 선택합니다.
      all = []
      for event in $game_map.event_enemies.select{|event| event.enemy_ready? and event.on_battle_screen?}
        if event.on_battle_screen?
          next if event.battler.object
          if @item.scope == 9 and event.killed
            all.push(event)
            apply_self_effect(event, true)
            event.apply_respawn
            return
          elsif @item.scope == 7
            all.push(event)
            apply_self_effect(event, true)
            event.apply_respawn
            return
          end
          all.push(event)
        end
      end
      # 사용자에 대한 범위인 경우
      if @item.scope == 7 or @item.scope == 9
        #print("119.Projectile - 타겟 지정 4, %s \n" % [@item.scope]);
        apply_self_effect(@user, true)
        return
      end
      all.push(@user)
      target = all[rand(all.size)]
      apply_self_effect(target, true) if !target.nil?
      apply_self_effect(@user, true) if target.nil?
    end
  end

  # 모든 아군에게 효과
  def apply_effectto_all_allies
    # 모든 배틀맨 액터에게 효과 적용
    if @user.battler.is_a?(Game_Actor)
      $game_player.followers.each {|i|
      next unless i.visible?
      next if i.battler.dead? and @item.scope == 8
      apply_self_effect(i, pop=true)}
      apply_self_effect($game_player, pop=true)
    # 적 전체 아군에게 효과 적용
    elsif @user.battler.is_a?(Game_Enemy)
      return if @item == nil # 오류 수정
      for event in $game_map.event_enemies.select{|event| event.enemy_ready? and event.on_battle_screen?}
        if event.on_battle_screen?
          # 오브젝트 제외 실험
          next if event.battler.object || event.page.nil?
          next if @item.scope == 8 and event.battler.dead?
          if event.battler.dead?
            @item.scope == 10 ? event.apply_respawn : next
          end
          event.battler.item_apply(event.battler, @item)
          $game_player.damage_pop.push(DamagePop_Obj.new(event))
          event.animation_id = animation
        end
      end
      apply_self_effect(@user, true)
      @item = nil # 오류 수정
    end
  end

  # 직접적인 효과
  def apply_self_effect(target, pop=true)
    # 스텍 오류 수정
    #return if @user == nil or @user.battler == nil or target.battler == nil
    return if @user == nil or @user.battler == nil or target == nil
    return if @user.battler.dead?

    if target.nil?
      @user.battler.item_apply(@user.battler, @item)
      @user.animation_id = animation
      $game_player.damage_pop.push(DamagePop_Obj.new(@user))
    else
      target.battler.item_apply(target.battler, @item)
      target.animation_id = animation
      $game_player.damage_pop.push(DamagePop_Obj.new(target))
    end
    @destroy_it = true
  end

  #=============================================================================
  # 사용자가 적인지 행위자인지에 따라 데미지 업데이트
  #=============================================================================
  def update_damage
    # 스텍 오류 수정
    return if @user == nil
    return if @user.battler == nil
    return if @user.battler.dead?
    if @user.battler.is_a?(Game_Actor)
      apply_damageto_enemy
      if @tool_selfdamage
        apply_damageto_player 
        apply_damageto_followers unless @ignore_followers
      end
    elsif @user.battler.is_a?(Game_Enemy)
      if $game_player.normal_walk?
        apply_damageto_player 
        apply_damageto_followers unless @ignore_followers
      end
      if @tool_selfdamage
        apply_damageto_enemy
      end
    end
  end

  # 타이머 업데이트
  def update_timer
    update_tool_movement if @tool_distance >= 1
    @mini_opacity -= 1 if @mini_opacity > 0
    @opacity = 255 if @mini_opacity == 1
    @tool_effect_delay -= 1 if @tool_effect_delay > 0
    # 오브젝트 제거, 발사체 제거
    if 1 > @tool_distance and !jumping?
      if @tool_destroy_delay > 0
        @tool_destroy_delay -= 1
        update_animation_setting
      else
        @destroy_it = true
      end
    # 오브젝트 잔상 제거 실험
    elsif 0 >= @tool_distance and 0 >= @tool_destroy_delay
      @destroy_it = true
    end
  end
  
  def make_diagonal_a
    move_diagonal(4, 2) if @direction == 2
    move_diagonal(4, 8) if @direction == 4
    move_diagonal(6, 8) if @direction == 6
    move_diagonal(4, 8) if @direction == 8
  end
  
  def make_diagonal_b
    move_diagonal(6, 2) if @direction == 2
    move_diagonal(4, 2) if @direction == 4
    move_diagonal(6, 2) if @direction == 6
    move_diagonal(6, 8) if @direction == 8
  end
  
  def make_direction_a
    @direction = 4 if @user.direction == 2
    @direction = 8 if @user.direction == 4
    @direction = 2 if @user.direction == 6
    @direction = 6 if @user.direction == 8
    @direction_done = true
  end
  
  def make_direction_b
    @direction = 6 if @user.direction == 2
    @direction = 2 if @user.direction == 4
    @direction = 8 if @user.direction == 6
    @direction = 4 if @user.direction == 8
    @direction_done = true
  end
  
  def update_tool_movement
    # 지옥의 룬 나비 착용시 타겟 지정을 오토타겟으로 지정
    if @user.is_a?(Game_Player)
      if $game_actors[7].equips[3] != nil and @user.battler.id == 7 and @item.is_a?(RPG::Skill)
        if $game_actors[7].equips[3].equip_number == "AE"
          if @item.id == 34 or @item.id == 35 or @item.id == 42 or @item.id == 227 or 
            @item.id == 228 or @item.id == 229 or @item.id == 143
            @tool_distance = @tool_distance + 6 if @tool_special != "autotarget"
            @tool_special = "autotarget"
            #print("119.Projectile - 오토타겟으로 변경 \n");
          end
        end
      end
      # 화살 직진 적용
      if @tool_special == "autotarget" and $game_switches[82] == true and @item.tool_data("Tool Item Cost = ") == 19 and $data_items[@item.tool_data("Tool Item Cost = ")] != nil
        #@tool_distance = @tool_distance + 1
        @tool_special = nil
      end
    end
    
    # 점프 이동이 아닌 경우에만 이동 거리 대입
    @tool_distance = 0 if @tool_special == "JP1" or @tool_special == "JP2" or @tool_special == "JP3"
    
    if @tool_distance > 0 and not moving?
      if @triple != nil         # tripple definition
        case @triple
        when :uno  then make_diagonal_a
        when :dos  then move_forward
        when :tres then make_diagonal_b
        end
        @tool_distance -= 1 if @tool_distance >= 1
      elsif @quintuple != nil   # quintuple definition
        case @quintuple
        when :uno    ; make_direction_a  if @direction_done.nil?; move_forward
        when :dos    ; make_diagonal_a
        when :tres   ; move_forward
        when :cuatro ; make_diagonal_b   
        when :cinco  ; make_direction_b if @direction_done.nil? ; move_forward
        end
        @tool_distance -= 1 if @tool_distance >= 1
      elsif @octuple != nil
        case @octuple
        when :uno    ; make_direction_a  if @direction_done.nil?; move_forward
        when :dos    ; make_diagonal_a
        when :tres   ; move_forward
        when :cuatro ; make_diagonal_b   
        when :cinco  ; make_direction_b if @direction_done.nil? ; move_forward
        when :seis   ; make_diagonal_a
        when :siete  ; move_forward
        when :ocho   ; make_diagonal_b
        end
        @tool_distance -= 1 if @tool_distance >= 1
      # 오토타겟 점프로 변경
      elsif @tool_special == "autotarget"
        @autotargeting = nil
        @autotargeting = []
        di = 0
        # 사용자가 액터인 경우 맵에서 이벤트 적을 선택했습니다.
        if @user.battler.is_a?(Game_Actor)
          loop do
            di += 1
            if di >= @tool_distance
              # 타겟이 없는 경우 직진
              #print("119.Projectile - 타겟이 없다[1], 이동 거리 - 1 \n");
              move_forward2
              @tool_distance -= 1 if @tool_distance >= 1
              return
            else
              for event in $game_map.event_enemies.select{|event| @user.obj_size?(event, di) and event.enemy_ready? and event.on_battle_screen?}
                if @user.is_a?(Game_Follower) and @user.targeted_character != nil
                  @autotargeting = [true, @user.targeted_character]
                  # 방향 전환
                  @user.turn_toward_event(@autotargeting[1].id)
                  # 방향 전환 불가능
                  @direction_fix = true
                  @direction = @user.direction
                  # 적중률 적용
                  if rand(100) > @user.battler.hit*100 and di > 6
                    jump_miss(@autotargeting[1].x,@autotargeting[1].y,@tool_distance)
                  else
                    jump_m(@autotargeting[1].x,@autotargeting[1].y,@tool_distance)
                  end
                  # 방향 전환 가능
                  @direction_fix = false
                  return
                elsif event.enemy_ready? and event.on_battle_screen?
                  @autotargeting = [true, event]
                  # 방향 전환
                  @user.turn_toward_event(@autotargeting[1].id)
                  # 방향 전환 불가능
                  @direction_fix = true
                  @direction = @user.direction
                  # 적중률 적용
                  if rand(100) > @user.battler.hit*100 and di > 6
                    jump_miss(@autotargeting[1].x,@autotargeting[1].y,@tool_distance)
                  else
                    jump_m(@autotargeting[1].x,@autotargeting[1].y,@tool_distance)
                  end
                  # 방향 전환 가능
                  @direction_fix = false
                  return
                end
              end
            end
          end
        # 사용자가 적인 경우 게임 배우를 선택하십시오.         
        elsif @user.battler.is_a?(Game_Enemy)
          # 오토타겟 다시 지정 실험
          @user.agroto_f.nil? ? target = $game_player : target = @user.agroto_f
          @autotargeting = [true, target]
          # 방향 전환
          @user.turn_toward_event(@autotargeting[1].id)
          # 방향 전환 불가능
          @direction_fix = true
          @direction = @user.direction
          # 적중률 적용
          if rand(100) > @user.battler.hit*rand(100)
            jump_miss(@autotargeting[1].x,@autotargeting[1].y,@tool_distance)
          else
            jump_m(@autotargeting[1].x,@autotargeting[1].y,@tool_distance)
          end
          # 방향 전환 가능
          @direction_fix = false
        end
        if @autotargeting[0]
          @autotargeting.clear if @autotargeting[1].x == @x and @autotargeting[1].y == @y
        else
          # 타겟이 없는 경우 직진
          move_forward2
          @tool_distance -= 1 if @tool_distance >= 1
          return
        end
        # 위로 오토타겟 종료
      # 오토타겟에 순간이동 공격, 어둠의 비수
      elsif @tool_special == "autotarget2"
        # 캐릭터 이팩트 제거
        if 1 > @tool_destroy_delay or 1 > @tool_distance
          ms_stop_speed_trail(@user.id)
          @tool_distance = 0
          return
        end
        @autotargeting = nil
        @autotargeting = []
        di = 0
        # 사용자가 액터인 경우 맵에서 이벤트 적을 선택했습니다.
        if @user.battler.is_a?(Game_Actor)
          loop do
            di += 1
            if di >= @tool_distance
              ms_stop_speed_trail(@user.id)
              @user.move_forward2
              move_forward2
              @tool_distance -= 1 if @tool_distance >= 1
              return
            else
              for event in $game_map.event_enemies.select{|event| @user.obj_size?(event, di) and event.enemy_ready? and event.on_battle_screen?}
                if @user.is_a?(Game_Follower) and @user.targeted_character != nil
                  @autotargeting = [true, @user.targeted_character]
                  @direction = @user.direction
                  @user.moveto(@autotargeting[1].x,@autotargeting[1].y)
                  moveto(@autotargeting[1].x,@autotargeting[1].y)
                  ms_start_speed_trail(@user.id, 5, 50, 1, 0.8)
                  @user.move_random
                  @user.turn_toward_event(@autotargeting[1].id)
                  @user.move_backward
                  @tool_destroy_delay -= 1 if @tool_destroy_delay >= 1
                  return
                elsif event.enemy_ready? and event.on_battle_screen?
                  @autotargeting = [true, event]
                  @direction = @user.direction
                  @user.moveto(@autotargeting[1].x,@autotargeting[1].y)
                  moveto(@autotargeting[1].x,@autotargeting[1].y)
                  ms_start_speed_trail(@user.id, 5, 50, 1, 0.8)
                  @user.move_random
                  @user.turn_toward_event(@autotargeting[1].id)
                  @user.move_backward
                  @tool_destroy_delay -= 1 if @tool_destroy_delay >= 1
                  return
                end
              end
            end
          end
        # 사용자가 적인 경우 게임 배우를 선택하십시오.         
        elsif @user.battler.is_a?(Game_Enemy)
          # 오토타겟 다시 지정 실험
          @user.agroto_f.nil? ? target = $game_player : target = @user.agroto_f
          @autotargeting = [true, target]
          @user.moveto(@autotargeting[1].x,@autotargeting[1].y)
          moveto(@autotargeting[1].x,@autotargeting[1].y)
          ms_start_speed_trail(@user.id, 5, 50, 1, 0.8)
          @user.move_random
          @user.turn_toward_event(@autotargeting[1].id)
          @user.move_backward
          @tool_destroy_delay -= 1 if @tool_destroy_delay >= 1
        end
        if @autotargeting[0]
          @autotargeting.clear if @autotargeting[1].x == @x and @autotargeting[1].y == @y
        else
          # 타겟이 없는 경우 직진
          ms_stop_speed_trail(@user.id)
          @user.move_forward2
          move_forward2
          @tool_distance -= 1 if @tool_distance >= 1
          return
        end
        # 위로 오토타겟2 종료
      # 이동
      elsif @tool_special == "MF2" and @tool_distance >= 1
        @user.move_forward
        moveto(@user.x, @user.y)
        move_forward
        @tool_distance -= 1
      # 1칸 앞, 1칸 뒤
      elsif @tool_special == "MF3" and @tool_distance >= 1
        if @original_distance == @tool_distance
          @user.move_forward
          moveto(@user.x, @user.y)
        end
        move_forward
        @tool_distance -= 1
        @user.move_backward if @tool_distance == 0
      # 이동거리 만큼 점프
      elsif @tool_special == "MF1" and @tool_distance >= 1
        @user.jump_forward(@tool_distance)
        moveto(@user.x, @user.y)
        move_forward
        @tool_distance = 0
      elsif @tool_special == "random" and @tool_distance >= 1
        move_forward if @tool_distance == @original_distance - 1
        move_forward if @tool_distance == @original_distance - 2
        move_random  if @tool_distance <= @original_distance - 3
        @tool_distance -= 1 if @tool_distance >= 1
      # 창
      elsif @tool_special == "MF_spear" and @tool_distance >= 1
        @user.move_forward
        case @user.direction
          when 2; moveto(@user.x, @user.y+1)
          when 4; moveto(@user.x-1, @user.y)
          when 6; moveto(@user.x+1, @user.y)
          when 8; moveto(@user.x, @user.y-1)
        end
        @user.move_backward
        @tool_destroy_delay -= 1 if @tool_destroy_delay >= 0
        @tool_distance -= 1 if @tool_destroy_delay == 0
      # 도끼
      elsif @tool_special == "MF_axe" and @tool_distance >= 1
        sx = @user.x - 2 + @tool_destroy_delay
        sy = @user.y - 2 + @tool_destroy_delay
        case @user.direction
          when 2; moveto(sx, @user.y+1)
          when 4; moveto(@user.x-1, sy)
          when 6; moveto(@user.x+1, sy)
          when 8; moveto(sx, @user.y-1)
        end
        @tool_destroy_delay -= 1 if @tool_destroy_delay >= 0
        @tool_distance -= 1 if @tool_destroy_delay == 0
      # 부메랑 리디렉션 이동
      elsif @tool_special == "boomerang" and @tool_distance >= 1
        if @user.is_a?(Game_Player)
          case Input.dir8
            when 1 then move_diagonal(4, 2) 
            when 3 then move_diagonal(6, 2)
            when 7 then move_diagonal(4, 8)
            when 9 then move_diagonal(6, 8)
          else
          # 입력하지 않고 바로 이동
            move_forward
          end
        # 게임 플레이어가 아니라 그냥 똑바로 이동
        else
          move_forward
        end
        @tool_distance -= 1 if @tool_distance >= 1
      elsif @tool_distance >= 1
        # 일반적인 정면 공격
        #print("119.Projectile - 일반적인 공격[1], 이동 거리 - 1 \n");
        if @item.tool_data("Tool Item Cost = ") == 19
          move_forward2
          @tool_distance -= 1 if @tool_distance >= 1
        else
          move_forward
          @tool_distance -= 1
          @tool_distance = 0 if 1 > @tool_distance
        end
      end
    end
    # 화살 땅에 떨어지면 제거
    if @item.tool_data("Tool Item Cost = ") == 19 and $data_items[@item.tool_data("Tool Item Cost = ")] != nil
      if !jumping? and !moving? and @tool_distance == 0
        @tool_destroy_delay = 5 if @tool_destroy_delay > 5
      end
    end
  end

  # 도구 애니메이션
  def update_animation_setting
    case @tool_end_anime
    when "end"
      if @tool_destroy_delay >= 4 and @tool_destroy_delay <= 16 and jumping? != true
        @animation_id = animation if @mnganime == 0
        @mnganime += 1
        @mnganime = 0 if @mnganime >= 12
      end
    when "hit_end"
      if @tool_destroy_delay >= 4 and @tool_destroy_delay <= 16 and jumping? != true
        @animation_id = animation if @mnganime == 0
        @mnganime += 1
        @mnganime = 0 if @mnganime >= 12
      end
    when "acting"
      if @tool_destroy_delay >= 4
        @animation_id = animation if @mnganime == 0
        @mnganime += 1
        @mnganime = 0 if @mnganime >= 12
      end
    when "acting_x"
      if @tool_destroy_delay >= 4
        @animation_id = animation if jumping? != true and @mnganime == 0
        @mnganime += 1
        @mnganime = 0 if @mnganime >= 12
      end
    when "acting_60"
      if @tool_destroy_delay >= 4 and @tool_destroy_delay <= 60
        @animation_id = animation if jumping? != true and @mnganime == 0
        @mnganime += 1
        @mnganime = 0 if @mnganime >= 12
      end
    when "acting_190"
      if @tool_destroy_delay >= 4 and @tool_destroy_delay <= 190
        @animation_id = animation if jumping? != true and @mnganime == 0
        @mnganime += 1
        @mnganime = 0 if @mnganime >= 12
      end
    when "acting_270"
      if @tool_destroy_delay >= 4 and @tool_destroy_delay <= 270
        @animation_id = animation if jumping? != true and @mnganime == 0
        @mnganime += 1
        @mnganime = 0 if @mnganime >= 12
      end
    when "acting_570"
      if @tool_destroy_delay >= 4 and @tool_destroy_delay <= 570
        @animation_id = animation if jumping? != true and @mnganime == 0
        @mnganime += 1
        @mnganime = 0 if @mnganime >= 12
      end
    end
    if @tool_end_anime.is_a?(Integer)
      @animation_id = animation  if @tool_destroy_delay == @tool_end_anime
    end
  end
  
  # 재생할 애니메이션 가져오기
  def animation
    if @item.is_a?(RPG::Armor)
      return $data_skills[@tool_invoke].animation_id if @tool_invoke > 0
      return 0
    end
    if @item != nil # 오류 수정
      return @item.animation_id
    end
  end
  
  # 적에게 피해를 입히다
  def apply_damageto_enemy
    # 점프중에도 맞도록 수정
    return if jumping?
    return if @tool_effect_delay > 0 and @tool_end_anime != "hit_end"
    $game_map.event_enemies.each do |event|
      next if event.collapsing?
      # 함정 해제 적용
      @ro_hit_ok = 1
      # 오브젝트인 경우 덫 및 함정 미적용적용
      if @item.is_a?(RPG::Skill) and event.battler.object
        if @item.id == 355 or @item.id == 353 or @item.id == 357
          @ro_hit_ok = 0
        end
      end
      if event.battler.body_sized > 0
        enabled = body_size?([event.x, event.y], @tool_size + event.battler.body_sized)
=begin
        enabled = body_size?([event.x, event.y], @tool_size)
        enabled = body_size?([event.x - 1, event.y], @tool_size) if !enabled 
        enabled = body_size?([event.x, event.y - 1], @tool_size) if !enabled
        enabled = body_size?([event.x + 1, event.y], @tool_size) if !enabled
        if event.battler.body_sized == 2
          enabled = body_size?([event.x-1, event.y-1], @tool_size) if !enabled 
          enabled = body_size?([event.x, event.y - 2], @tool_size) if !enabled
          enabled = body_size?([event.x+1, event.y-1], @tool_size) if !enabled
        end
=end
      else
        enabled = body_size?([event.x, event.y], @tool_size)
      end
      # 지뢰 본인인 경우 취소
      if @ro_hit_ok == 1
        # 점프중에도 맞도록 수정
        return if jumping? and !enabled
        if enabled and event.just_hitted == 0
          event.just_hitted = 10
          next if event.page.nil?
          execute_damageto_enemy(event)
        end
      end
    end
  end

  # 특정 아이템으로 적이 죽었는지 확인
  def enable_dame_execution?(enemy)
    weapon = enemy.kill_weapon if @original_item.is_a?(RPG::Weapon)
    armor = enemy.kill_armor   if @original_item.is_a?(RPG::Armor)
    item = enemy.kill_item     if @original_item.is_a?(RPG::Item)
    skill = enemy.kill_skill   if @original_item.is_a?(RPG::Skill)
    if enemy.has_kill_with?
      return true if !weapon.nil? && weapon.include?(@original_item.id)
      return true if !armor.nil?  && armor.include?(@original_item.id)
      return true if !item.nil?   && item.include?(@original_item.id)
      return true if !skill.nil?  && skill.include?(@original_item.id)
      return false
    end
    return true
  end
  
  # 적에게 피해를 입히다
  def execute_damageto_enemy(event)
    event.being_targeted = false if event.being_targeted
    event.epassive = false if event.epassive

    if event.agroto_f.nil? and @user.is_a?(Game_Follower)
      event.agroto_f = @user if rand(5) == 1
    end
    if event.agroto_f != nil and @user.is_a?(Game_Player)
      event.agroto_f = nil if rand(2) == 1
    end

    if !event.battler.object
      return if guard_success?(event, 1)
    end

    # 무적 제외 실험
    return if event.battler.invin
    
    # 캐릭터 그래픽이 없는 경우 제외
    return if event.character_name == "" or event.character_name == nil

    # 지하수로 의뢰 진행
    if $game_map.map_id == 184 and event.battler.name =~ /철창/i
      if $game_self_switches[[184, 5, "B"]] == true
        $game_self_switches[[184, 5, "C"]] = true
      end
      $game_self_switches[[184, 5, "A"]] = true
    end
    
    # 피해, 데미지, 피격 진행
    execute_damage(event)

    $game_player.damage_pop.push(DamagePop_Obj.new(event)) unless
    guard_success?(event, 2)
    apply_blow_power(event) unless event.battler.k_back_dis

    # 체력 10% 미만 실험
    if event.battler.lowhp_10 != nil or event.battler.lowhp_25 != nil or
      event.battler.lowhp_50 != nil or event.battler.lowhp_75 != nil
      case ((event.battler.hp/event.battler.mhp).to_f * 100).to_i
        when 0..10 then activate_lhp_switch(event.battler.lowhp_10)
        when 11..25 then activate_lhp_switch(event.battler.lowhp_25)
        when 26..50 then activate_lhp_switch(event.battler.lowhp_50)
        when 51..75 then activate_lhp_switch(event.battler.lowhp_75)
      end
    end
  end

  def activate_lhp_switch(switch)
    $game_switches[switch] = true if !switch.nil? and !$game_switches[switch]
  end
  
  # 아이템 획득 로그 팝업창
  def event_window_make_item_text(item, value)
    return unless SceneManager.scene_is?(Scene_Map)
    return if Switch.hide_event_window
    if value > 0
      text = YEA::EVENT_WINDOW::FOUND_TEXT
    else; return
    end
    text += sprintf("\ei[%d] %s", item.icon_index, item.name)
    if value.abs > 1
      fmt = YEA::EVENT_WINDOW::AMOUNT_TEXT
      text += sprintf(fmt, value.abs.group)
    end
    event_window_add_text(text)
  end
  
  def event_window_add_text(text)
    return unless SceneManager.scene_is?(Scene_Map)
    return if Switch.hide_event_window
    text = YEA::EVENT_WINDOW::HEADER_TEXT + text
    text += YEA::EVENT_WINDOW::CLOSER_TEXT
    SceneManager.scene.event_window_add_text(text)
  end
  
  # 플레이어에게 데미지 적용
  def apply_damageto_player
    return if @tool_effect_delay > 0
    #return if @tool_effect_delay > 0 || $game_player.battler.dead?
    if obj_size?($game_player, @tool_size) and $game_player.just_hitted == 0
      $game_player.just_hitted = 10
      # 에르니를 죽인 몬스터
      if @user != nil and @user.battler != nil
        @ro_batl_name = @user.battler.name.split(") ")
        $game_variables[92] = @ro_batl_name[1].to_s if @ro_batl_name[1] != nil
      end
      # 함정 해제 적용
      @ro_hit_ok = 1
      # 덫 해제 적용
      if @item.is_a?(RPG::Skill) and @item.id == 355
        if $game_player.battler.skill_learn?($data_skills[418])
          $game_party.gain_item($data_items[30], 1)
          event_window_make_item_text($data_items[30], 1)
          @ro_hit_ok = 0
        end
      # 목함 지뢰 해제 적용
      elsif @item.is_a?(RPG::Skill) and @item.id == 353
        if $game_player.battler.skill_learn?($data_skills[419])
          $game_party.gain_item($data_items[31], 1)
          event_window_make_item_text($data_items[31], 1)
          @ro_hit_ok = 0
        end
      # 섬광 지뢰 해제 적용
      elsif @item.is_a?(RPG::Skill) and @item.id == 357
        if $game_player.battler.skill_learn?($data_skills[419])
          $game_party.gain_item($data_items[33], 1)
          event_window_make_item_text($data_items[33], 1)
          @ro_hit_ok = 0
        end
      # 거미줄 1 받음
      elsif @item.is_a?(RPG::Skill) and @item.id == 342
        $game_party.gain_item($data_items[241], 1)
        event_window_make_item_text($data_items[241], 1)
      # 거미줄 3 받음
      elsif @item.is_a?(RPG::Skill) and @item.id == 392
        $game_party.gain_item($data_items[241], 3)
        event_window_make_item_text($data_items[241], 3)
      end
      if @ro_hit_ok == 1
        return if guard_success?($game_player, 1)
        #print("119.Projectile - 데미지 적용 \n");
        execute_damage($game_player)
        $game_player.damage_pop.push(DamagePop_Obj.new($game_player)) unless
        guard_success?($game_player, 2)
        apply_blow_power($game_player)
      else
        #print("119.Projectile - 데미지 생략 \n");
        @tool_destroy_delay = 0
        @animation_id = 0
        @tool_size = 0
      end
    end
  end

  # 추종자에게 피해 적용
  def apply_damageto_followers
    return if @tool_effect_delay > 0
    for actor in $game_player.followers
      next unless actor.visible?
      if obj_size?(actor, @tool_size) and actor.just_hitted == 0
        next if actor.battler.dead?
        actor.just_hitted = 10
        # 함정 해제 적용
        @ro_hit_ok = 1
        if actor.is_a?(Game_Follower) or actor.is_a?(Game_Actor)
          # 덫 해제 적용
          if @item.is_a?(RPG::Skill) and @item.id == 355
            if actor.battler.skill_learn?($data_skills[418])
              $game_party.gain_item($data_items[30], 1)
              event_window_make_item_text($data_items[30], 1)
              @ro_hit_ok = 0
            end
          # 목함 지뢰 해제 적용
          elsif @item.is_a?(RPG::Skill) and @item.id == 353
            if actor.battler.skill_learn?($data_skills[419])
              $game_party.gain_item($data_items[31], 1)
              event_window_make_item_text($data_items[31], 1)
              @ro_hit_ok = 0
            end
          # 섬광 지뢰 해제 적용
          elsif @item.is_a?(RPG::Skill) and @item.id == 357
            if actor.battler.skill_learn?($data_skills[419])
              $game_party.gain_item($data_items[33], 1)
              event_window_make_item_text($data_items[33], 1)
              @ro_hit_ok = 0
            end
          # 거미줄 1 받음
          elsif @item.is_a?(RPG::Skill) and @item.id == 342
            $game_party.gain_item($data_items[241], 1)
            event_window_make_item_text($data_items[241], 1)
          # 거미줄 3 받음
          elsif @item.is_a?(RPG::Skill) and @item.id == 392
            $game_party.gain_item($data_items[241], 3)
            event_window_make_item_text($data_items[241], 3)
          end
        end
        if @ro_hit_ok == 1
          return if guard_success?(actor, 1)
          execute_damage(actor)
          $game_player.damage_pop.push(DamagePop_Obj.new(actor)) unless
          guard_success?(actor, 2)
          apply_blow_power(actor)
        else
          @tool_destroy_delay = 0
          @animation_id = 0
          @tool_size = 0
        end
      end
    end
  end

  def precombo(sym)
    @item.is_a?(RPG::Weapon) ? e = @user.actor.equips[0] : e = @user.actor.equips[1]
    return if e.nil?
    if sym == :apply
      @user.apply_weapon_param(e, false) 
      @user.apply_weapon_param(@item, true)
    elsif sym == :remove
      @user.apply_weapon_param(@item, false)  
      @user.apply_weapon_param(e, true) 
    end
  end

  # 대상에게 피해를 입힙니다.
  def execute_damage(target)
    # 다단 히트 횟수 확인
    #if @tool_mt_hits != nil
    #  @tool_mt_hits -= 1
    #  @tool_destroy_delay = 0 if 1 > @tool_mt_h7its
    #end
    #print("119.Projectile - 다단 히트 횟수 %s \n" % [@tool_mt_hits]);
    
    #print("119.Projectile - %s는 피해를 받았다. \n" % [target.battler.name]);
    if magical_item?
      target.battler.item_apply(@user.battler, @item)
      # 타격, 피격당한 이벤트 id 실험
      $game_variables[300] = target.id
    else
      @user.apply_weapon_param(@item, true) if @user.battler.is_a?(Game_Enemy)
      precombo(:apply) if @user.battler.is_a?(Game_Actor) && @precombi
      if @tool_invoke > 0
        target.battler.melee_attack_apply(@user.battler, @tool_invoke)
      else
        target.battler.attack_apply(@user.battler)
      end
      @user.apply_weapon_param(@item, false) if @user.battler.is_a?(Game_Enemy)
      precombo(:remove) if @user.battler.is_a?(Game_Actor) && @precombi
    end
    
    # 타겟이 오브젝트인 경우
    return if target.battler.is_a?(Game_Enemy) and target.battler.object
    
    # 스프라이트 좌표 조작
    case self.direction
      when 2; @next_y -= 5
      when 4; @next_x += 5
      when 6; @next_x -= 5
      when 8; @next_y += 5
    end
      
    # 플레이어가 데미지를 받은 경우
    $game_variables[126] = $game_player.actor.id if target.battler.is_a?(Game_Actor)
    
    # 데미지가 흡수 관련된 데미지인 경우
	if target.battler.result.hp_drain != 0
	  hp_d = target.battler.result.hp_drain
	  @user.pop_damage(['Absorber ' + hp_d.to_s, Color.new(10,220,45)])
	end
	if target.battler.result.mp_drain != 0
	  mp_d = target.battler.result.mp_drain
	  @user.pop_damage(['Absorber ' + mp_d.to_s, Color.new(20,160,225)])
	end
    # 주먹으로 공격한 경우
    if @item.is_a?(RPG::Weapon) and @item.id == 130 and target.battler.result.hp_damage >= 1
      target.battler.result.hp_damage = 1
    end
    # 방어, 데미지가 0 이하인 경우 취소
    if target.battler_guarding[0]
      return
    end
    return if target.battler.result.mp_damage < 1 and target.battler.result.hp_damage < 1
    
    # 인간형 몬스터가 에르니 강간 진행
    if @item.is_a?(RPG::Skill) and @item.id == 407 and target != nil
      if target.battler.id == 7 and $game_variables[114] != "I"
        tex_ro_map_xy = @user.battler.name.split(") ")
        $game_variables[29] = tex_ro_map_xy[1].to_s
        target.stopped_movement_2 = 30
        $game_temp.reserve_common_event(158)  # 강간 진행
        @user.battler.add_state(159)          # 상대방은 피로함 적용
      else
        target.animation_id = 6               # 에르니가 아니면 그냥 주먹 공격
      end
    end
    # 데미지 1 이상만 아래 적용 --------------------------------------------------
    if target.battler.result.hp_damage > 1
      # ------------------------------------------------------------------------
      # 특수 상태이상 적용
      # ------------------------------------------------------------------------
      # 피격시 공격자 상태이상
		if target.battler.state?(173) # Frío de la Muerte, Congelación
		  @user.battler.add_state(133)
		  @user.animation_id = 92
		  target.battler.remove_state(173)
		end
		# Vampirismo
		if @user.battler.state?(216)   # Deseo de Sangre, 30% absorción
		  hp_d = (target.battler.result.hp_damage * 0.3).to_i
		  @user.battler.hp += hp_d
		  @user.pop_damage(['Absorber ' + hp_d.to_s, Color.new(10,220,45)])
		end
		if @user.battler.state?(40)   # Llamada de Sangre, 2% absorción
		  hp_d = (target.battler.result.hp_damage * 0.02).to_i
		  @user.battler.hp += hp_d
		  @user.pop_damage(['Absorber ' + hp_d.to_s, Color.new(10,220,45)])
		end
		if @user.battler.state?(167)  # Batalla Sangrienta, 10% absorción
		  hp_d = (target.battler.result.hp_damage * 0.1).to_i
		  @user.battler.hp += hp_d
		  @user.pop_damage(['Absorber ' + hp_d.to_s, Color.new(10,220,45)])
		end
		if @user.battler.state?(61)   # Guerrero Perfecto, 25% absorción
		  hp_d = (target.battler.result.hp_damage * 0.25).to_i
		  @user.battler.hp += hp_d
		  @user.pop_damage(['Absorber ' + hp_d.to_s, Color.new(10,220,45)])
		end      # 피해 감소
      if target.battler.state?(166) # 철웅성, 피해 감소 5%
        target.battler.result.hp_damage -= (target.battler.result.hp_damage * 0.05).to_i
      end
      # 피격시 상처 상태이상 추가 실험
      if @user.battler.is_a?(Game_Actor) and target.battler.result.hp_damage >= target.battler.mhp
        # 스트레스 해소
        @user.battler.stress -= 1
      elsif target.battler.result.hp_damage > target.battler.mhp * 0.5
        # 50% 이상의 데미지를 받을 경우 공포 적용
        target.battler.add_state(138) if !target.battler.state?(138)
        target.battler.add_state(84) if rand(10) > 8 and !target.battler.state?(84)
      elsif target.battler.result.hp_damage > target.battler.mhp * 0.3
        target.battler.add_state(136) if !target.battler.state?(136)
        target.battler.remove_state(135) if target.battler.state?(135)
        target.battler.remove_state(120) if target.battler.state?(120)
      elsif target.battler.result.hp_damage > target.battler.mhp * 0.2 and !target.battler.state?(136)
        target.battler.add_state(135) if !target.battler.state?(135)
        target.battler.remove_state(120) if target.battler.state?(120)
      elsif target.battler.result.hp_damage > target.battler.mhp * 0.1 and !target.battler.state?(135) and !target.battler.state?(136)
        target.battler.add_state(120) if !target.battler.state?(120)
      end
      # 상대방에게 백어텍 날리는 경우 확률 적으로 치명상 적용
      if target.direction == @user.direction
        # tp 추가 적용
        @user.battler.tp += rand(10)
        target.battler.add_state(117) if !target.battler.state?(117)
        if !target.battler.state?(118) and target.battler.result.hp_damage > target.battler.mhp * 0.3
          target.battler.add_state(118) if rand(10) > 6
        end
      end
      # 피격시 보이스 출력 -------------------------------------------------------
      voices = PearlKernel.hitvoices(target.battler)
      RPG::SE.new(voices[rand(voices.size)], 80).play unless voices.nil?
      # ------------------------------------------------------------------------
      # 스턴, 빙결, 석화 상태일때 공격 당하면 스턴 상태 제거
      if target.battler.state?(8) and rand(4) == 1
        target.battler.remove_state(8)
        target.stopped_movement = 0 if target.stopped_movement > 0
      end
      if target.battler.state?(133) and rand(4) == 1
        target.battler.remove_state(133)
        target.stopped_movement = 0 if target.stopped_movement > 0
      end
      if target.battler.state?(11) and rand(4) == 1
        target.battler.remove_state(11)
        target.stopped_movement = 0 if target.stopped_movement > 0
      end
      # 피격시 피격 당한 방향으로 전환 ---------------------------------------------
      if rand(2) == 1
        # 수면 상태일때 공격 당하면 수면 상태 제거
        if target.battler.state?(6)
          target.battler.remove_state(6)
          target.stopped_movement = 0 if target.stopped_movement > 0
        end
        # 용사의 육신 상태라면 방향 변경을 하지 않는다.
        if target.battler.state?(220) == false
          target.direction = 8 if @user.direction == 2
          target.direction = 6 if @user.direction == 4
          target.direction = 4 if @user.direction == 6
          target.direction = 2 if @user.direction == 8
        end
      end
      # ------------------------------------------------------------------------
      if target.battler.is_a?(Game_Actor) or target.battler.is_a?(Game_Player)
        # 플레이어, 동료 공격당하면 자동 공격 강제 시작
        $game_switches[196] = true
        # 피격시 욕구 증가
        target.battler.sleep += 1       # 피로
        target.battler.hunger += 1      # 허기
        target.battler.thirst += 0.5    # 갈증
        target.battler.sexual -= 3      # 성욕
        target.battler.hygiene += 0.5   # 위생
        target.battler.stress += 1      # 스트레스
        target.battler.drunk -= 3       # 취기
        # 에르니 피격 커먼 이벤트
        if target.battler.id == 7 and $game_switches[195] == false and $game_switches[47] == false
          $game_temp.reserve_common_event(8)
          # 낮은 확률로 임신한 아이 유산
          if rand(150) == 1 and $game_party.item_number($data_items[68]) >= 1
            $game_party.lose_item($data_items[68], 1)             # 태아 제거
            $game_party.lose_item($data_items[67], rand(2) + 1)   # 정액 제거
            $game_party.gain_item($data_items[69], 1)             # 죽은 태아 추가
            $game_actors[7].set_custom_bio[9] = $game_actors[7].set_custom_bio[9].to_i + 1
          end
          # 업적 추가
          $game_variables[331] += 1
          if $game_variables[331] >= 999
            $game_party.gain_medal(26)
          end
		elsif target.battler.id != 7
		  # Mostrar diálogos cuando un compañero recibe un golpe
		  if 1 >= rand(10)
			text = nil
			text = ['¡Argh!', '¡Esquiva mejor!', '¡Ugh!', '¡Maldición!', '¡Maldita sea!']
			target.mrbt = text[rand(text.size)] if text != nil
		  end
		end
		elsif target.battler.is_a?(Game_Enemy)
		  # Mostrar diálogos de monstruos, goblins
		  if target.battler.name =~ /Goblin/i
			if 1 >= rand(10)
			  text = nil
			  text = ['¡No duele!', '¡Kikikik!', '¡Ven aquí!', '¡Mujer!', '¡Mujer!', '¡Kieek!', '¡Humano de mierda!']
			  target.mrbt = text[rand(text.size)] if text != nil
			end
		  elsif target.battler.name =~ /Orco/i
			if 1 >= rand(10)
			  text = nil
			  text = ['¡Eso hace cosquillas!', '¡Kekekek!', '¡Mujer de mierda!', '¡Nada mal para ser una mujer!', '¡Kueek!', '¡Kieek!', '¡Humano despreciable!']
			  target.mrbt = text[rand(text.size)] if text != nil
			end
		  elsif target.battler.name =~ /Aventurero/i
			if 1 >= rand(10)
			  text = nil
			  text = ['¡Eso duele bastante!', '¡Ugh!', '¡Te haré arrepentir!', '¡Nada mal!', '¡Eek!', '¡Ugh!', '¿Qué... qué demonios?!']
			  target.mrbt = text[rand(text.size)] if text != nil
			end
		  end
		end
	end    
	# 카메라 이동시, 배틀러 사망시 미니 대화창 바로 제거
    if $game_switches[54] == true or target.battler.dead?
      self.mrbt = nil if self.mrbt != nil
    end
    if @tool_hitshake
      $game_map.screen.start_shake(8, 6, 24)
    end
    return if target.hookshoting[0] || @user.making_spiral
    # 대상에게 경직 추가, 오브젝트 제외
    if target != nil
      if target.battler.is_a?(Game_Enemy)
        if @stopped_movement_2 != nil and target.battler.object == false
          if @stopped_movement_2 > 0
            # 보스 몬스터는 경직 안됨
            if target.battler.boss_hud
              target.stopped_movement = 0
            else
              target.stopped_movement = @stopped_movement_2.to_i
            end
          end
        end
      else
        if @stopped_movement_2 != nil
          if @stopped_movement_2 > 0
            # 용사의 육신 상태라면 경직을 받지 않는다.
            if target.battler.state?(220)
              target.stopped_movement = 0
            else
              target.stopped_movement = @stopped_movement_2.to_i
            end
          end
        end
      end
    end
    if target.battler.is_a?(Game_Actor) or target.battler.is_a?(Game_Player)
      # 욕구 데미지 추가
      target.battler.hunger += @tool_hunger.to_i
      target.battler.thirst += @tool_thirst.to_i
      target.battler.sleep += @tool_sleep.to_i
      target.battler.sexual += @tool_sexual.to_i
      target.battler.hygiene += @tool_hygiene.to_i
      target.battler.temper += @tool_temper.to_i
      target.battler.stress += @tool_stress.to_i
      target.battler.cold += @tool_cold.to_i
      # 반격 확률 확인 및 반격 진행
      if ((target.battler.cnt).to_f) * 100 >= rand(100)
        if target.battler.equips[0] != nil
          if target.battler.equips[0].wtype_id == 4
            target.stopped_movement = 0
            target.process_tool_action(target.battler.equips[0])
          end
        end
      end
    end
  end

  # 사용자가 쉴드를 사용 중인지 확인 가드
  def guard_success?(userr, type)
    if userr.battler_guarding[0]
      if type == 1
        if rand(101) <= userr.battler_guarding[1]
          return false unless faceto_face?(userr)
          # 방패 방향
          if userr != nil
            if @user.direction != userr.direction
              # 철웅성 상태에서 충격 흡수 버프 적용
              if userr.battler.state?(166) == true
                if userr.battler.state?(180) or userr.battler.state?(181)
                  userr.battler.add_state(181)
                elsif userr.battler.state?(179)
                  userr.battler.add_state(180)
                elsif userr.battler.state?(178)
                  userr.battler.add_state(179)
                elsif userr.battler.state?(177)
                  userr.battler.add_state(178)
                else
                  userr.battler.add_state(177)
                end
              end
              RPG::SE.new(Key::GuardSe, 80).play
              $game_player.damage_pop.push(DamagePop_Obj.new(userr, 2))
              unless @user.making_spiral
                @tool_distance = 0
                @tool_destroy_delay = 0
              end
              play_hit_animation(userr)
              return true
            end
          else
            # 방어 + 공격시 오류 수정
            return false
          end
        end
      elsif type == 2
        return false unless faceto_face?(userr)
        $game_player.damage_pop.push(DamagePop_Obj.new(userr, 1))
        return true
      end
    end
    return false
  end

  # 히트 시 애니메이션이 표시 대기
  def apply_passive_state
    @transparent = true
    @tool_effect_delay = 60
    @tool_destroy_delay = 30
    @animation_id = animation
    @tool_distance = 0
  end

  # 히트 애니메이션
  def play_hit_animation(target)
    if @tool_end_anime == "hit_end" or @tool_end_anime == "hit"
      target.animation_id = animation
      # 다단 히트 방지
      if @tool_special != "hillwind" and @tool_special != "autotarget2"
        @tool_distance = 0
        @tool_destroy_delay = 0
      end
    end
    if @tool_end_anime == "hit_move_stop"
      target.animation_id = animation
      @tool_distance = 1
      # 다단 히트 방지
      @tool_destroy_delay = 0
    end
  end

  # 블로우 파워 효과
  def apply_blow_power(target)
    play_hit_animation(target)

    # 넉백 금지
    if target.battler.action_plus_set2 >= rand(10)
      # 넉백 무시 발동
      target.blowpower[0] = 0
      return
    end
    return if PearlKernel.jump_hit?(target.battler) != true
    return if target.battler.result.hp_damage < 1
    return if target.hookshoting[0] || @user.making_spiral
    target.blowpower = [@tool_blow_power, @user.direction, target.direction_fix, target.move_speed, 0] #if target.blowpower[0] == 0 and target.blowpower[4] == 0
    # 팔로어 넉백
    if target.is_a?(Game_Player)
      target.followers.each {|f|
      next unless f.visible?
      next if f.battler.dead?
      f.blowpower = [@tool_blow_power, @user.direction, f.direction_fix, f.move_speed, 0] #if f.blowpower[0] == 0 and f.blowpower[4] == 0
      }
    end

    @orig_move_speed = target.move_speed
    
    # 방향 전환 금지인 경우 캐릭터 움직임 제거
    if target.direction_fix == false
      target.direction = 10 - @user.direction
      @direction_fix = true   # 방향 고정
    end
    if target.passable?(target.x, target.y, @user.direction)
      target.move_speed = 8
      target.blowpower[0].times.each {|i| target.move_backward}
      target.blowpower[0] = 0
      target.move_speed = @orig_move_speed
    else
      # 벽 궁 이펙트
      target.animation_id = 166 if target.animation_id == nil or target.animation_id == 0
      target.turn_right_or_left_90
      target.move_speed = 8
      target.blowpower[0].times.each {|i| target.move_backward}
      target.blowpower[0] = 0
      target.move_speed = @orig_move_speed
      # 벽 궁시 80% 확률로 스턴 적용
      target.battler.add_state(8) if 2 >= rand(10)
    end
    if target.direction_fix == false
      @direction_fix = false  # 방향 고정 해제
    end
  end
  
  # 애니메이션 패턴
  def update_anime_pattern
    return if @tool_special == "hook"
    super
  end
  
  # 도구 토큰 ID로 이벤트 활성화
  def update_tool_token
    return if @tool_effect_delay > 0
    $game_map.events_withtags.each do |event|
      if obj_size?(event, @tool_size) and event.start_delay == 0
        wid = event.token_weapon
        aid = event.token_armor
        iid = event.token_item
        sid = event.token_skill
        item = @original_item    
        case item
        when RPG::Weapon; start_token(event) if wid.include?(item.id)
        when RPG::Armor ; start_token(event) if aid.include?(item.id)
        when RPG::Item  ; start_token(event) if iid.include?(item.id)
        when RPG::Skill ; start_token(event) if sid.include?(item.id)
        end
      end
    end
  end
  
  # 트리거 이벤트
  def start_token(event)
    $game_map.events_withtags.delete(event)
    event.start
    event.start_delay = 30
  end
  
  def move_straight(d, turn_ok = true)
    return if force_stopped?
    super
  end
end