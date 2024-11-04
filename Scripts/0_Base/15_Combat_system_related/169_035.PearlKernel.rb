# encoding: utf-8
# Name: 035.PearlKernel
# Size: 14848
module MOVE_CONTROL
  # 이 번호의 스윗치가 ON 때, 8 방향 이동을 금지해, 4 방향 이동에만 합니다.
  FOUR_MOVE_SWITCH = 51
  
  # 이 번호의 스윗치가 ON 때, 플레이어 캐릭터의 조작을 금지합니다.
  MOVE_SEAL_SWITCH = 52
  
  # 이 번호의 스윗치가 ON 때, 대시 판정이 역전합니다.
  # (평상시가 대시, 대시 키를 누르고 있는 상태로 통상 보행이 됩니다)
  DASH_REV = 53
  
  # 월드맵에서 대쉬금지
  DASH_SEAL = 50
  
  # 이 번호의 변수가 0보다 클 때, 대시 때의 속도가 더욱 증가합니다.
  DASH_PLUS = 19
end

module PearlKernel
  # 기본 적 센서 자체 스위치
  Enemy_Sensor = "B"
  
  # 기본 적 센서(적이 플레이어를 볼 수 있는 타일의 거리
  Sensor = 3

  # 기본 적 넉다운 자체 스위치(넉다운된 그래픽을 표시하는 데 사용됨)
  KnockdownSelfW = "C"
  
  # 기본 적 붕괴
  DefaultCollapse = 'zoom_horizontal'
  
  # 플레이어가 적을 볼 수 있는 거리는?
  PlayerRange = 12
  
  # 추종자가 행동을 실패하면 이 풍선이 재생되고 마나가 부족합니다.
  FailBalloon = 12
  
  # ABS 허드를 켠 상태에서 게임을 시작하시겠습니까?
  StartWithHud = true
  
  # 팔로어 데드 포즈를 활성화 하시겠습니까?
  FollowerDeadPose = true
  
  # 싱글 플레이어 모드를 활성화하시겠습니까?
  SinglePlayer = false

  @gaugeback = Color.new(0, 0, 0, 100)
  @gaugeback2 = Color.new(0, 0, 0, 0)

  def self.draw_hp(obj, battler, x, y, w, h, color, name=nil)
    tag = 'HP' ; c = color
    name = battler.name if !name.nil?
    draw_gauge(obj, battler.hp, battler.mhp, x, y, w, h, c, tag, name)
  end

  def self.draw_mp(obj, battler, x, y, w, h, color, name=nil)
    tag = 'MP' ; c = color
    name = battler.name if !name.nil?
    draw_gauge(obj, battler.mp, battler.mmp, x, y, w, h, c, tag, name)
  end

  def self.draw_exp(obj, battler, x, y, w, h, color, name=nil)
    tag = 'EXP' ; c = color
    name = battler.name if !name.nil?
    draw_gauge2(obj, battler.exp, battler.next_level_exp, battler.current_level_exp, x, y, w, h, c, tag, name)
  end

  def self.draw_tp(obj, x, y, actor)
    string = 'TP ' + (actor.tp).to_i.to_s
    obj.fill_rect(x, y + 10 , string.length * 9, 12, @gaugeback2)
    obj.draw_text(x, y, obj.width, 32, string)
  end

  # 경험치 게이지바 전용
  def self.draw_gauge2(obj, nm, max, cur, x, y, w, h, col, tag, name)
    obj.font.name = "한컴 윤체 L"
    obj.font.shadow = true
    w2 = w - 2 ; max = 1 if max == 0
    obj.fill_rect(x, y - 1, w, h + 2, @gaugeback)
    now_exp = nm - cur
    next_exp = max - cur
    rate_ts = now_exp * 1.0 / next_exp
    rate_ts = [[rate_ts, 1.0].min, 0.0].max
    obj.gradient_fill_rect(x+1, y, w2 * rate_ts, h, col[0], col[1])
    ro_exp_te = (now_exp.to_f / next_exp.to_f * 100).to_i
    obj.draw_text(x, y + h - 22, w, 32, "#{ro_exp_te.to_i}" + '%', 2)
    obj.draw_text(x + 4, y + h - 22, w, 32, tag)
    obj.draw_text(x, y - 25 - 10, w, 32, name, 1) if !name.nil?
  end

  def self.draw_gauge(obj, nm, max, x, y, w, h, col, tag, name)
    obj.font.name = "한컴 윤체 L"
    obj.font.shadow = true
    w2 = w - 2 ; max = 1 if max == 0
    obj.fill_rect(x, y - 1, w, h + 2, @gaugeback)
    obj.gradient_fill_rect(x+1, y, w2*nm/max, h, col[0], col[1])
    obj.draw_text(x, y + h - 22, w, 32, nm.to_i, 2)
    obj.draw_text(x + 4, y + h - 22, w, 32, tag)
    obj.draw_text(x, y - 25 - 10, w, 32, name, 1) if !name.nil?
  end

  def self.image_hp(bitmap, x, y, back, image, battler, name=nil)
    tag = 'HP'
    name = battler.name if !name.nil?
    draw_i_gauge(bitmap, x, y, back, image, battler.hp, battler.mhp, tag, name)
  end
  
  def self.image_mp(bitmap, x, y, back, image, battler, name=nil)
    tag = 'MP'
    name = battler.name if !name.nil?
    draw_i_gauge(bitmap, x, y, back, image, battler.mp, battler.mmp, tag, name)
  end
  
  def self.image_exp(bitmap, x, y, back, image, battler, name=nil)
    tag = 'EXP'
    name = battler.name if !name.nil?
    exp, nexte = battler.exp, battler.next_level_exp
    draw_i_gauge(bitmap, x, y, back, image, exp, nexte, tag, name)
  end

  def self.draw_i_gauge(bitmap, x, y, back, image, nm, max, tag, name)
    cw = back.width  
    ch = back.height 
    max = 1 if max == 0
    src_rect = Rect.new(0, 0, cw, ch)    
    bitmap.blt(x - 10, y - ch + 30,  back, src_rect)
    cw = image.width  * nm / max
    ch = image.height 
    src_rect = Rect.new(0, 0, cw, ch)
    bitmap.blt(x - 10, y - ch + 30, image, src_rect)
    bitmap.draw_text(x - 4, y + back.height - 14, back.width, 32, tag)
    bitmap.draw_text(x - 12, y + back.height - 14, back.width, 32, nm.to_s, 2)
    bitmap.draw_text(x - 6, y - 10, back.width, 32, name, 1) if !name.nil?
  end

  def self.has_data?
    !user_graphic.nil?
  end

  def self.load_item(item)
    @item = item
  end

  def self.user_graphic()
    #print("035.PearlKernel - %s \n" % [@item]);
    if @item != nil
      @item.tool_data("User Graphic = ", false)
    else
      return nil
    end
  end
  def self.user_animespeed()   @item.tool_data("User Anime Speed = ")        end
  def self.tool_cooldown()     @item.tool_data("Tool Cooldown = ")           end
  def self.tool_graphic()      @item.tool_data("Tool Graphic = ", false)     end
  def self.tool_index()        @item.tool_data("Tool Index = ")              end
  def self.tool_size()         @item.tool_data("Tool Size = ")               end
  def self.tool_distance()
    @item.tool_data("Tool Distance = ")
  end
  # 다단 히트 횟수 추가
  #def self.tool_mt_hits()
  #  @item.tool_data("Tool Mt hits = ")
  #end
  def self.tool_effectdelay()  @item.tool_data("Tool Effect Delay = ")       end
  def self.tool_destroydelay() @item.tool_data("Tool Destroy Delay = ")      end
  def self.tool_speed()         @item.tool_float("Tool Speed = ")            end
  def self.tool_castime()       @item.tool_data("Tool Cast Time = ")         end
  def self.tool_castanimation() @item.tool_data("Tool Cast Animation = ")    end
  def self.tool_blowpower()     @item.tool_data("Tool Blow Power = ")        end
  def self.tool_piercing()      @item.tool_data("Tool Piercing = ", false)   end
  def self.tool_animation() @item.tool_data("Tool Animation When = ", false) end
  def self.tool_anirepeat() @item.tool_data("Tool Animation Repeat = ",false)end
  def self.tool_special()    @item.tool_data("Tool Special = ", false)       end
  def self.tool_target()    @item.tool_data("Tool Target = ", false)         end
  def self.tool_invoke() @item.tool_data("Tool Invoke Skill = ")             end
  def self.tool_guardrate() @item.tool_data("Tool Guard Rate = ")            end
  def self.tool_knockdown() @item.tool_data("Tool Knockdown Rate = ")        end
  def self.tool_stop_move2() @item.tool_data("Tool Stop Move = ")            end
  def self.tool_soundse() @item.tool_data("Tool Sound Se = ", false)         end
  def self.tool_itemcost() @item.tool_data("Tool Item Cost = ")              end
  def self.tool_shortjump() @item.tool_data("Tool Short Jump = ", false)     end
  def self.tool_through() @item.tool_data("Tool Through = ", false)          end
  def self.tool_priority() @item.tool_data("Tool Priority = ")               end
  def self.tool_selfdamage() @item.tool_data("Tool Self Damage = ", false)   end
  def self.tool_hitshake() @item.tool_data("Tool Hit Shake = ", false)       end
  def self.tool_combo() @item.tool_data("Tool Combo Tool = ", false)         end
  def self.tool_stopped() @item.tool_data("Tool Stop Move = ")               end

  # 욕구 데미지 추가
  def self.tool_hunger() @item.tool_data("hunger = ")                        end
  def self.tool_thirst() @item.tool_data("thirst = ")                        end
  def self.tool_sleep() @item.tool_data("sleep = ")                          end
  def self.tool_sexual() @item.tool_data("sexual = ")                        end
  def self.tool_hygiene() @item.tool_data("hygiene = ")                      end
  def self.tool_temper() @item.tool_data("temper = ")                        end
  def self.tool_stress() @item.tool_data("stress = ")                        end
  def self.tool_cold() @item.tool_data("cold = ")                            end
    
  def self.knock_actor(actor)
    a = actor.actor.tool_data("Knockdown Graphic = ", false)
    b = actor.actor.tool_data("Knockdown Index = ")
    c = actor.actor.tool_data("Knockdown pattern = ")
    d = actor.actor.tool_data("Knockdown Direction = ")
    return nil if a.nil?
    return [a, b, c, d]
  end
  
  def self.jump_hit?(target)
    t = target.enemy.tool_data("Hit Jump = ", false) if target.is_a?(Game_Enemy)
    t = target.actor.tool_data("Hit Jump = ", false) if target.is_a?(Game_Actor)
    return true if !t.nil? and t == "true"
    return true if t.nil?
    return false
  end

  def self.hit_blow?(target)
    hb = target.enemy.tool_data("Hit Blow = ", false) if target.is_a?(Game_Enemy)
    hb = target.actor.tool_data("Hit Blow = ", false) if target.is_a?(Game_Actor)
    return true if !hb.nil? and hb == "true"
    return true if hb.nil?
    return false
  end

  def self.voices(b)
    voices = b.actor.tool_data("Battler Voices = ",false) if b.is_a?(Game_Actor)
    voices = b.enemy.tool_data("Battler Voices = ",false) if b.is_a?(Game_Enemy)
    voices = voices.split(", ") unless voices.nil?
    voices
  end
  
  def self.hitvoices(b)
    voices = b.actor.tool_data("Hit Voices = ",false) if b.is_a?(Game_Actor)
    voices = b.enemy.tool_data("Hit Voices = ",false) if b.is_a?(Game_Enemy)
    voices = voices.split(", ") unless voices.nil?
    voices
  end

  def self.check_iconset(item, tag, object)
    data = item.tool_data(tag, false)
    return if data.nil?
    v = [item.icon_index, data.to_sym] if data == "animated" ||
    data == "static" || data == "shielding"
    object.is_a?(Projectile) ? object.pro_iconset = v : object.user_iconset = v
  end

  def self.clean_back?
    @clean_back == true
  end
end

module PearlSkillBar
  # 타일의 스킬바 X 위치
  Tile_X = 6
  
  # 타일의 스킬바 Y 위치
  Tile_Y = 13
  
  # 레이아웃 그래픽
  LayOutImage = "Pearl Skillbar"

  def self.ToggleIcon
    if $game_switches[196]
      return 3858
    else
      return 3859
    end
  end
  
  #-----------------------------------------------------------------------------
  # PearlSkillBar.hide        - hide the skillbar 
  # PearlSkillBar.show        - show the skillbar
  #-----------------------------------------------------------------------------
  
  def self.hide
    $game_system.skillbar_enable = true
  end
  
  def self.show
    $game_system.skillbar_enable = nil
  end
  
  def self.hidden?
    !$game_system.skillbar_enable.nil?
  end
end

module PearlScenes
  # 대상 선택 시 표시되는 커서 아이콘
  CursorIcon = 3857
  
  # 플레이어 선택 메뉴에 표시되는 상태 텍스트
  DeathStatus =     'Death'      # 죽을 때 표시
  BadStatus =       'Bad'        # HP의 0~25%일 때 표시
  OverageStatus =   'Overage'    # HP의 25~50%일 때 표시
  GoodStatus =      'Good'       # HP의 50~75%일 때 표시
  ExellentStatus =  'Exellent'   # HP의 75~100%일 때 표시
end

module DisplayTools
  def self.create(x, y)
    @viewport2 = Viewport.new
    @viewport2.z = 999
    @pearl_tool_sprite = Sprite_PearlTool.new(@viewport2, [x, y])
  end
  
  def self.sprite
    return @pearl_tool_sprite
  end
  
  def self.update
    @pearl_tool_sprite.update if @pearl_tool_sprite != nil
  end

  def self.dispose
    if @pearl_tool_sprite != nil
      @pearl_tool_sprite.dispose
      @viewport2.dispose
      @viewport2 = nil
      @pearl_tool_sprite = nil
    end
  end
end

#-------------------------------------------------------------------------------
# * Commands
# PearlBars.hide          - Hide the actor bars
# PearlBars.show          - Show the actor bars (by default)
#
# PearlBars.enemy_auto(id) - 필요 없이 적의 HP 바를 자동으로 표시
#-------------------------------------------------------------------------------

module PearlBars
  # 화면의 막대 x 및 y 위치
  ScreenPos_X = 10
  ScreenPos_Y = 10
  
  # 너비 300 x 높이 100을 초과할 수 없는 막대의 치수
  #                   x    y     width   height
  HP_BarDimentions = [8,   20,    80,    4]
  MP_BarDimentions = [8,   36,    80,    4]
  EX_BarDimentions = [8,   52,    80,    4]
  
  # TP 위치      x   y
  TP_Info =    [8,  58]
  
  # 색상 정의
  #           color 1    R    G    B   Opa     color 2   R   G    B    Opa
  HP_Color = [Color.new(115, 20, 20, 255),     Color.new(169, 43, 43,  255)]
  MP_Color = [Color.new(158, 113, 229, 255),   Color.new(203, 176, 244, 255)]
  EX_Color = [Color.new(180, 225, 245, 255),   Color.new(20, 160, 225, 255)]
  
  # 스크립트 그리기 막대 대신 그래픽을 표시하고 싶습니까?
  # 그렇다면 이 액터 바 그래픽 요구 사항을 채우십시오.
  
  ActorsHp    = ""       # Actor Hp 그래픽 막대 이름(따옴표 안에)
  ActorsMp    = ""       # Actor Mp 그래픽 막대 이름
  ActorsExp   = ""       # 배우 경험치
  ActorsBack  = ""       # 배경 반투명 바
  
  # 일반 적 화면의 x 및 y 위치 막대
  NeScreenPos_X = Graphics.width / 2 - 63
  NeScreenPos_Y = 20
  
  # 막대의 크기는 너비 300 x 높이 100을 초과할 수 없습니다.
  #                    x    y     width   height
  EHP_BarDimentions = [8,   20,    126,    6]
  
  # 색상 정의
  #            color 1    R    G    B   Opa     color 2   R   G    B    Opa
  EHP_Color = [Color.new(115, 20, 20, 200),   Color.new(169, 43, 43,  255)]
  
  # 게이지를 사진으로 표시하려면 이것을 채우십시오.
  NormalEne = ""           # 일반 적 HP 바
  NormalBack = ""          # 배경 반투명 바
  
  # 보스 적 화면의 바 x 및 y 위치
  BeScreenPos_X = Graphics.width / 2 - 165
  BeScreenPos_Y = 20
  
  # 너비 640 x 높이 100을 초과할 수 없는 막대의 치수
  #                    x    y     width   height
  BHP_BarDimentions = [8,   22,    330,    12]
  
  #            color 1    R    G    B   Opa     color 2   R   G    B    Opa
  BHP_Color = [Color.new(115, 20, 20, 200),   Color.new(169, 43, 43,  255)]
  
  # 게이지를 사진으로 표시하려면 이것을 채우십시오.
  BossEne = ""        # 보스 적 HP 바
  BossBack = ""       # 배경 반투명 바
  
  def self.show() $game_system.pearlbars = nil  end
  def self.hide() $game_system.pearlbars = true end
    
  def self.enemy_auto(event_id)
    $game_system.enemy_lifeobject = $game_map.events[event_id]
  end
end

module PartyHud
  Pos_X = 0
  Pos_Y = 100
end

module PearlAntilag
  # 스크립트가 허용하는 화면 외부의 타일 수
  OutRange = 2
end