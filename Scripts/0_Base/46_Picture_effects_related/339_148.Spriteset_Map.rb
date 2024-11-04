# encoding: utf-8
# Name: 148.Spriteset_Map
# Size: 18261
class Spriteset_Map
  #begin # 오류 발생시 예외 처리
  #  include Planeset_FOG
  #rescue => e
  #end
  
  FIRST_PICBELOW_ID = 1  # 문자 아래에 표시될 사진의 첫 번째 ID
  LAST_PICBELOW_ID = 2   # 문자 아래에 표시될 사진의 마지막 ID

  #-----------------------------------------------------------------------------
  # 예를 들어 FIRST를 10으로, LAST를 15로 설정하면 사진 ID 10~15
  # 은 지도의 문자 아래에 표시됩니다.
  #-----------------------------------------------------------------------------
  
  alias :initialize_ve_light_effects :initialize
  def initialize
    # fog 주석처리해도 잘 적용된다.
    #create_fog
    create_effects
    
    initialize_ve_light_effects
    
    2.times { update_light(true) }
    
    #create_effects
    
    # 팔세린에서 렉 발생으로 인해 주석 처리
    refresh_characters
  end
  
  alias falcaopearl_lifebars_create create_pictures
  def create_pictures
    # 게임 시작 진행 완료
    create_hud_lifebars if $game_switches[281] == true
    falcaopearl_lifebars_create
  end
  
  def create_hud_lifebars
    @enemy_lifeobject = $game_system.enemy_lifeobject
    @enemyhpsp = Sprite_LifeBars.new(@viewport2, @enemy_lifeobject) if not @enemy_lifeobject.nil?
  end
  
  def create_actorlifebars
    return if !@actor_lifebar.nil?
    @actor_lifebar = Sprite_LifeBars.new(@viewport2, $game_player) if $game_switches[281] == true
  end
  
  def dispose_actorlifebars
    return if @actor_lifebar.nil?
    @actor_lifebar.dispose
    @actor_lifebar = nil
  end
  
  def update_lifebars_sprites
    $game_system.pearlbars.nil? ? create_actorlifebars : dispose_actorlifebars
    @actor_lifebar.update unless @actor_lifebar.nil?

    if !@enemyhpsp.nil?
      unless @enemyhpsp.disposed?
        @enemyhpsp.update 
      else
        @enemyhpsp.dispose
        @enemyhpsp = nil
        $game_system.enemy_lifeobject = nil
        @enemy_lifeobject = nil
      end
    end

    if @enemy_lifeobject != $game_system.enemy_lifeobject
      @enemyhpsp.dispose if !@enemyhpsp.nil?
      @enemyhpsp = nil
      @enemyhpsp = Sprite_LifeBars.new(@viewport2,$game_system.enemy_lifeobject)
      @enemy_lifeobject = $game_system.enemy_lifeobject
    end
  end
  
  alias wora_picbelow_sprsetmap_crepic create_pictures
  def update_pictures
    $game_map.screen.pictures.each do |pic|
      case pic.number
      when FIRST_PICBELOW_ID..LAST_PICBELOW_ID
        @picture_sprites[pic.number] ||= Sprite_Picture.new(@viewport1, pic)
      else
        @picture_sprites[pic.number] ||= Sprite_Picture.new(@viewport2, pic)
      end
      @picture_sprites[pic.number].update
    end
  end
  
  alias falcaopearl_create_characters create_characters
  def create_characters
    create_pearl_abs_sprites
    falcaopearl_create_characters
  end
  
  def create_pearl_abs_sprites
    if $game_player.send_dispose_signal
      dispose_pearlabs_sprites
      $game_player.send_dispose_signal = false
    end
    @projectile_sprites = []
    $game_player.projectiles.each do |projectile|
      @projectile_sprites.push(Sprite_Character.new(@viewport1, projectile))
    end
    @damagepop_sprites = []
    $game_player.damage_pop.each do |target|
      @damagepop_sprites.push(Sprite_DamagePop.new(@viewport1, target))
    end
    @animeabs_sprites = []
    $game_player.anime_action.each do |anime|
      @animeabs_sprites.push(Sprite_Character.new(@viewport1, anime))
    end
    
    @dead_iconsprites = []
    @dead_characters = []
    
    # 팔로워 게이지 관련
    @framerr = 0
  end
  
  alias :update_ve_light_effects :update
  def update
    # 스킬창, 체력 게이지 표시 여부를 적용
    # 캐릭터 조작 금지, 퀘스트 보드에서는 숨김 적용
    if $game_switches[52] == true or $game_switches[186] == true
      PearlBars.hide
      PearlSkillBar.hide
    elsif !HM_SEL::time_stop?
      PearlBars.show
      PearlSkillBar.show
    else
      PearlBars.hide
      PearlSkillBar.hide
    end
    update_lifebars_sprites
    update_fog
    # --------------------------------------------------------------------------
    # 다음을 주석처리하면 단축키 창이 갱신이 안된다.
    # --------------------------------------------------------------------------
    update_pearl_abs_main_sprites if !$game_actors[7].dead?
    update_ve_light_effects
    # --------------------------------------------------------------------------
    # 아래는 시간 가속중이 아닌 경우에만 적용
    # --------------------------------------------------------------------------
    if $game_switches[283] == false and Graphics.frame_count % 2 == 0
      # 캐릭터 그림자 끄기
      if $game_switches[91] == false
        @shadow_sprites.each {|s| s.update} if @shadow_sprites != nil and $game_map.char_effects2[1]
      elsif @shadow_sprites != nil
        dispose_effects
      end
      update_light if $game_map.map_id != 35
    end
    update_party_hud_sprites
  end
  
  def create_fog
    gm = $game_map
    # create_fog_a(gm)
    # create_fog_b(gm)
    # create_fog_c(gm)
  end
  
  # def create_fog_a(gm)
  #   @fogg_a = Plane_FOG.new(gm.fog_a_name,:type_a)
  #   @fogg_a_name = gm.fog_a_name
  # end

  # def create_fog_b(gm)
  #   @fogg_b = Plane_FOG.new(gm.fog_b_name,:type_b)
  #   @fogg_b_name = gm.fog_b_name
  # end

  # def create_fog_c(gm)
  #   @fogg_c = Plane_FOG.new(gm.fog_c_name,:type_c)
  #   @fogg_c_name = gm.fog_c_name
  # end

  def dispose_fog
    # @fogg_a.dispose if @fogg_a != nil
    # @fogg_b.dispose if @fogg_b != nil
    # @fogg_c.dispose if @fogg_c != nil
  end
  
  def update_fog
    # if @fogg_a_name != $game_map.fog_a_name
    #   @fogg_a.dispose if @fogg_a != nil
    #   create_fog_a($game_map)
    # end
    # if @fogg_b_name != $game_map.fog_b_name
    #   @fogg_b.dispose if @fogg_b != nil
    #   create_fog_b($game_map)
    # end
    # if @fogg_c_name != $game_map.fog_c_name
    #   @fogg_c.dispose if @fogg_c != nil
    #   create_fog_c($game_map)
    # end
    # @fogg_a.update if @fogg_a != nil
    # @fogg_b.update if @fogg_b != nil
    # @fogg_c.update if @fogg_c != nil
  end
  
  def update_party_hud_sprites
    if $game_player.pearl_menu_call[1] == 1
      dispose_party_hud
      return
    end
    if $game_player.follower_fighting?
      create_party_hud
      @framerr = 60
    elsif @framerr >= 1
      #print("148.Spriteset_Map - 파티 HUD %s \n" % [@framerr]);
      @framerr -= 1
      dispose_party_hud if 1 > @framerr
    end
    @party_hud.update unless @party_hud.nil?
  end
  
  def create_party_hud
    return if !@party_hud.nil?
    @party_hud = PearlPartyHud.new(@viewport2)
  end
  
  def dispose_party_hud
    return if @party_hud.nil?
    @party_hud.dispose
    @party_hud = nil
  end
  
  # 진주 복근 메인 스프라이트 업데이트
  def update_pearl_abs_main_sprites
    # 메뉴 진입시 이미지 갱신 관련 오류 추가
    if $game_player.pearl_menu_call[1] == 1
      # 스프라이트 메인 업데이트
      dispose_tool_sprite
      dispose_state_icons
      dispose_actorlifebars if $imported["Falcao Pearl ABS Life"]
      $game_player.pearl_menu_call[1] = 0
      case $game_player.pearl_menu_call[0]
        when :tools     then SceneManager.call(Scene_QuickTool) 
        when :character then SceneManager.call(Scene_CharacterSet)
        when :battler   then SceneManager.call(Scene_BattlerSelection)
      end
      return
    end
    update_projectile_sprites
    update_damagepop_sprites
    update_absanime_sprites
    
    $game_system.skillbar_enable.nil? ? create_tool_sprite : dispose_tool_sprite
    @pearl_tool_sprite.update unless @pearl_tool_sprite.nil?
    $game_player.actor.state_icons.empty? ? dispose_state_icons : create_state_icons
    @states_sprites.update unless @states_sprites.nil?
  end
  
  def create_tool_sprite
    return if !@pearl_tool_sprite.nil?
    # 월드 맵인 경우 취소
    return if $game_map.map_id == 21
    @pearl_tool_sprite = Sprite_PearlTool.new(@viewport2)
  end

  def dispose_tool_sprite
    return if @pearl_tool_sprite.nil?
    @pearl_tool_sprite.dispose
    @pearl_tool_sprite = nil
  end
  
  def create_state_icons
    return if !@states_sprites.nil?
    @states_sprites = StateBuffIcons.new(@viewport2, '상태')
    # 버프 아이콘 위치 값 수정
    @states_sprites.z = 501
  end
  
  def dispose_state_icons
    return if @states_sprites.nil?
    @states_sprites.dispose
    @states_sprites = nil
  end
  
  # 발사체
  def update_projectile_sprites
    @projectile_sprites.each {|sprite| sprite.update if !sprite.disposed?}
    $game_player.projectiles.each do |projectile|
      unless projectile.draw_it
        @projectile_sprites.push(Sprite_Character.new(@viewport1, projectile))
        projectile.draw_it = true
      end
      if projectile.destroy_it
        @projectile_sprites.each {|i|
        if i.character.is_a?(Projectile) and i.character.destroy_it
          # 발사체 제거
          i.dispose
          @projectile_sprites.delete(i)
        end
        }
        if projectile.user.making_spiral
          projectile.user.making_spiral = false
        end
        if projectile.user.battler_guarding[0]
          projectile.user.battler_guarding = [false, nil]
          projectile.user.battler.remove_state(9)
        end
        $game_player.projectiles.delete(projectile)
      end
    end
  end

  # 데미지 이미지, 스프라이트
  def update_damagepop_sprites
    @damagepop_sprites.each {|sprite| sprite.update if !sprite.disposed?}
    $game_player.damage_pop.each do |target|
      unless target.draw_it
        @damagepop_sprites.push(Sprite_DamagePop.new(@viewport1, target))
        target.draw_it = true
      end
      if target.destroy_it
        @damagepop_sprites.each {|i|
        if i.target.destroy_it
          # 대상 데미지 제거
          i.dispose
          @damagepop_sprites.delete(i)
        end
        }
        $game_player.damage_pop.delete(target)
      end
    end
  end
  
  def update_absanime_sprites
    @animeabs_sprites.each {|s| s.update if !s.disposed?
    unless $game_player.anime_action.include?(s.character)
      s.dispose
      @animeabs_sprites.delete(s)
      $game_player.anime_action.delete(s.character)
    end
    }
    $game_player.anime_action.each do |anime|
      unless anime.draw_it
        @animeabs_sprites.push(Sprite_Character.new(@viewport1, anime))
        anime.draw_it = true
      end
      if anime.destroy_it
        @animeabs_sprites.each {|i|
        if i.character.is_a?(Anime_Obj) and i.character.destroy_it
          # 애니메이션 제거
          i.dispose
          @animeabs_sprites.delete(i)
        end
        }
        $game_player.anime_action.delete(anime)
      end
    end
  end
  
  def dispose_pearl_main_sprites
    @dead_iconsprites.each {|icon| icon.dispose}
    dispose_tool_sprite
    dispose_state_icons
    dispose_pearlabs_sprites
    dispose_party_hud
  end

  def dispose_pearlabs_sprites
    if @projectile_sprites != nil
      @projectile_sprites.each {|pro| pro.dispose}
      @projectile_sprites.clear
    end
    if @damagepop_sprites != nil
      @damagepop_sprites.each {|target| target.dispose}
      @damagepop_sprites.clear
    end
    if @animeabs_sprites != nil
      @animeabs_sprites.each {|anime| anime.dispose}
      @animeabs_sprites.clear
    end
  end
  
  alias galv_reflect_sm_refresh_characters refresh_characters
  def refresh_characters
    print("148.Spriteset_Map - refresh_characters \n");
    galv_reflect_sm_refresh_characters
    create_effects
  end

  def refresh_effects
    print("148.Spriteset_Map - refresh_effects \n");
    dispose_effects
    create_effects
  end

  def create_viewports
    if Graphics.width > $game_map.width * 32 && !$game_map.loop_horizontal?
      dx = (Graphics.width - $game_map.width * 32) / 2
    else
      dx = 0
    end
    dw = [Graphics.width, $game_map.width * 32].min
    dw = Graphics.width if $game_map.loop_horizontal?
    if Graphics.height > $game_map.height * 32 && !$game_map.loop_vertical?
      dy = (Graphics.height - $game_map.height * 32) / 2
    else
      dy = 0
    end
    dh = [Graphics.height, $game_map.height * 32].min
    dh = Graphics.height if $game_map.loop_vertical?
    @viewport1 = Viewport.new(dx, dy, dw, dh)
    @viewport2 = Viewport.new(dx, dy, dw, dh)
    @viewport3 = Viewport.new(dx, dy, dw, dh)
    @viewport2.z = 50
    @viewport3.z = 100
    print("148.Spriteset_Map - 뷰포트 생성 \n");
  end
  
  def update_viewport_sizes
    if Graphics.width > $game_map.width * 32 && !$game_map.loop_horizontal?
      dx = (Graphics.width - $game_map.width * 32) / 2
    else
      dx = 0
    end
    dw = [Graphics.width, $game_map.width * 32].min
    dw = Graphics.width if $game_map.loop_horizontal?
    if Graphics.height > $game_map.height * 32 && !$game_map.loop_vertical?
      dy = (Graphics.height - $game_map.height * 32) / 2
    else
      dy = 0
    end
    dh = [Graphics.height, $game_map.height * 32].min
    dh = Graphics.height if $game_map.loop_vertical?
    rect = Rect.new(dx, dy, dw, dh)
    for viewport in [@viewport1, @viewport2, @viewport3]
      viewport.rect = rect
    end
    print("148.Spriteset_Map - 뷰포트 업데이트 \n");
  end
   
  def create_effects
    @shadow_sprites = []
    print("148.Spriteset_Map - 그림자 생성 \n");
    # 캐릭터 그림자 끄기
    if $game_switches[91] == false
      # Do Shadows
      if $game_map.char_effects2[1]
        return if $game_map.light_source.empty?
        $game_map.light_source.count.times { |s|
          $game_map.events.values.each { |e|
          #print("%s \n" % [e.character_name]);
          # 제외 캐릭터 그래픽
          if e.character_name != "!$A_Warp" and e.character_name != "$Sign_9" and
            e.character_name != "!$Map_Window_1" and e.character_name != "!$Map_Window_2" and
            e.character_name != "!$Map_Window_3" and e.character_name != "!$Map_Window_4" and
            e.character_name != "!$Map_Window_5" and e.character_name != "!Door_3" and
            e.character_name != "!Door_1" and e.character_name != "!Door_2" and 
            e.character_name != "!$Quest" and e.character_name != "Sign3_Quest_Scroll" and
            e.character_name != "!$Other_27" and e.character_name != "!$Other_27_2" and
            e.character_name != "Sign3_Quest_Scroll_2" and e.character_name != "$Sign_1" and
            e.character_name != "$Sign_2" and e.character_name != "$Sign_3" and 
            e.character_name != "$Sign_4" and e.character_name != "$Sign_5" and 
            e.character_name != "$Sign_6" and e.character_name != "$Sign_7" and 
            e.character_name != "$Sign_8" and e.character_name != "$Sign_9" and 
            e.character_name != "!Torchlight_0" and e.character_name != "!Torchlight_1" and 
            e.character_name != "!Torchlight_2" and e.character_name != "!Torchlight_3" and 
            e.character_name != "!Torchlight_4" and e.character_name != "!$Torchlight4" and
            e.character_name != "$Other_6" and e.character_name != "$Other_5" and
            e.character_name != "$Animal_56" and e.character_name != "$Animal_57" and
            e.character_name != "!$Other_10" and
            e.character_name != "" and e.character_name != "!$Other_34_2"

            @shadow_sprites.push(Sprite_Shadow.new(@viewport1, e, s)) if e.shadow
          end
          }
          $game_player.followers.each { |f|
            @shadow_sprites.push(Sprite_Shadow.new(@viewport1, f, s)) if f.shadow
          }
          if $game_player.shadow
            @shadow_sprites.push(Sprite_Shadow.new(@viewport1, $game_player, s))
          end
        }
      end
    end
  end
  
  alias galv_reflect_sm_dispose_characters dispose_characters
  def dispose_characters
    galv_reflect_sm_dispose_characters
    dispose_effects
  end
   
  def dispose_effects
    @shadow_sprites.each {|s| s.dispose}
  end
  
  alias :dispose_ve_light_effects :dispose
  def dispose
    dispose_pearl_main_sprites
    dispose_actorlifebars
    @enemyhpsp.dispose unless @enemyhpsp.nil?
    dispose_fog
    
    dispose_ve_light_effects
    
    dispose_light unless SceneManager.scene_is?(Scene_Map)
  end
  
  def update_light(forced = false)
    return unless Graphics.frame_count % 2 == 0 || forced
    update_shade
    update_effects
  end
  
  def dispose_light
    if @light_effect
      @light_effect.dispose
      @light_effect = nil
      @screen_shade = nil
    end
  end
  
  def update_shade
    if !@light_effect && $game_map.screen.shade.visible
      refresh_lights
    elsif $game_map.screen.shade.visible && @light_effect
      @light_effect.update
    elsif @light_effect && !$game_map.screen.shade.visible
      dispose_light
    end
  end
  
  def refresh_lights
    @light_effect.dispose if @light_effect
    @screen_shade = $game_map.screen.shade
    @light_effect = Sprite_Light.new(@screen_shade, @viewport2)
    $game_map.event_list.each {|event| event.refresh_lights}
    @light_effect.update
  end  
  
  def update_effects
    return if !@light_effect || $game_map.screen.lights.empty?
    $game_map.screen.lights.keys.each {|key| create_light(key) }
    $game_map.screen.remove_light.clear
  end
  
  def create_light(key)
    effect = @light_effect.lights[key]
    return if remove_light(key)
    return if effect && effect.light == $game_map.screen.lights[key]
    @light_effect.create_light($game_map.screen.lights[key])
  end
  
  def remove_light(key)
    return false if !$game_map.screen.remove_light.include?(key) 
    @light_effect.remove_light(key)
    $game_map.screen.lights.delete(key)
    return true
  end
end