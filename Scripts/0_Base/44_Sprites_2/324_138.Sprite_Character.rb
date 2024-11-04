# encoding: utf-8
# Name: 138.Sprite_Character
# Size: 18211
class Sprite_Base < Sprite
  def set_animation_rate
    @ani_rate = YEA::CORE::ANIMATION_RATE
  end
  
  def start_pseudo_animation(animation, mirror = false)
    dispose_animation
    @animation = animation
    return if @animation.nil?
    @ani_mirror = mirror
    set_animation_rate
    @ani_duration = @animation.frame_max * @ani_rate + 1
    @ani_sprites = []
  end
end

class Sprite_Character < Sprite_Base
  alias tmmrbt_sprite_character_initialize initialize
  def initialize(viewport, character = nil)
    @bitmap_mrbt = Cache.system("mrbt_window")
    @mrbt_duration = 0
    tmmrbt_sprite_character_initialize(viewport, character)
  end
  
  alias tmmrbt_sprite_character_dispose dispose
  def dispose
    dispose_mrbt
    dispose_namepop
    tmmrbt_sprite_character_dispose
  end
  
  def dispose_mrbt
    if @mrbt_sprite
      @mrbt_sprite.bitmap.dispose if @mrbt_sprite.bitmap
      @mrbt_sprite.dispose
      @mrbt_sprite = nil
      @mrbt_duration = 0
    end
  end

  # 적 배틀러 그래픽 엔진
  def set_character_bitmap
    update_character_info
    set_bitmap
    set_bitmap_position
  end
  
  def actor?
    @character.is_a?(Game_Player) || @character.is_a?(Game_Follower)
  end
  
  def actor
    actor? ? @character.actor : nil
  end
  
  def update_character_info
  end
  
  def hue
    @character.hue
  end
  
  def set_bitmap
    self.bitmap = Cache.character(set_bitmap_name, hue)
    #self.bitmap = Cache.character(set_bitmap_name)
  end
  
  def set_bitmap_name
    @character_name
  end
  
  def set_bitmap_position
    sign = get_sign
    if sign && sign.include?('$')
      @cw = bitmap.width / @character.frames
      @ch = bitmap.height / 4
    else
      @cw = bitmap.width / (@character.frames * 4)
      @ch = bitmap.height / 8
    end
    self.ox = @cw / 2
    self.oy = @ch
  end
  
  def get_sign
    @character_name[/^[\!\$]./]
  end

  alias tmnpop_sprite_character_update update
  def update
    # --------------------------------------------------------------------------
    # 아래는 시간 가속중이 아닌 경우에만 적용
    # --------------------------------------------------------------------------
    if $game_switches[283] == false
      if @character.is_a?(Game_Event)
        # 캐릭터가 보이지 않는 경우 진행
        unless @character.allow_update
          end_animation if @character.animation_id > 0
          end_balloon if @character.balloon_id > 0
          self.x = @character.screen_x
          self.y = @character.screen_y
          self.z = @character.screen_z
          #print("138.Sprite_Character - update %s \n" % [@character.id])
          return
        end
      end
    end
    
    tmnpop_sprite_character_update
    
    update_namepop if @namepop_sprite
    #update_namepop
    if @character != nil and @character.namepop != nil
      if @character.namepop == "Q" and @character_name != "" and @character_name != "!$Other_31"
        if $sel_time_frame_30 == 15
          @namepop = @character.namepop
          @qest_id = @character.qest_id
          start_namepop
        end
      else
        sx = (@character.x - $game_player.x).abs
        sy = (@character.y - $game_player.y).abs
        # 의뢰 게시판인 경우 조금 더 아래에 표시
        if $game_map.map_id == 35
          if $game_switches[186] == true
            if @namepop != @character.namepop
              sx + sy < 2 ? @namepop = @character.namepop : @namepop = "none"
              start_namepop
            elsif sx + sy > 2 and @namepop != "none"
              @namepop = "none"
            end
          else
            if @help_window != nil
              @help_window.dispose
            end
            @namepop = "none"
          end
        else
          if @namepop != @character.namepop
            sx + sy < 4 ? @namepop = @character.namepop : @namepop = "none"
            start_namepop
          elsif sx + sy > 4 and @namepop != "none"
            @namepop = "none"
          end
        end
      end
    end
  end
  
  def start_namepop
    #print(" + Sprite_Character - start_namepop \n")
    dispose_namepop
    return if @namepop == "none" || @namepop == nil
    # 의뢰 게시판인 경우 수정
    if $game_map.map_id == 35
      @help_window = Window_Help_Q35.new
      @help_window.viewport = @viewport
      @help_window.z = 400
      @help_window.refresh(@namepop)
      update_namepop
    elsif @namepop == "Q"
      #print("099_2.신규 이름 팝업 - %s, %s \n" % [@qest_id, $game_party.quests.include?(@qest_id, :complete)]);
      if $game_party.quests.include?(@qest_id, :active)
        if !$game_party.quests.include?(@qest_id, :complete)
          @character.balloon_id = 19
        end
      end
    else
      @namepop_sprite = ::Sprite.new(viewport)
      h = TMNPOP::FONT_SIZE + 4
      @namepop_sprite.bitmap = Bitmap.new(h * 10, h)
      @namepop_sprite.bitmap.font.name = TMNPOP::FONT_NAME
      @namepop_sprite.bitmap.font.size = TMNPOP::FONT_SIZE
      @namepop_sprite.bitmap.font.out_color.alpha = TMNPOP::FONT_OUT_ALPHA
      @namepop_sprite.bitmap.draw_text(0, 0, h * 10, h, @namepop, 1)
      @namepop_sprite.ox = h * 5
      @namepop_sprite.oy = h
      update_namepop
    end
  end
  
  def update_namepop
    if @namepop_sprite
      @namepop_sprite.x = x
      # 의뢰 게시판인 경우 조금 더 아래에 표시
      if $game_map.map_id == 35
        @namepop_sprite.y = y - height + 40
      else
        @namepop_sprite.y = y - height
      end
      @namepop_sprite.z = z + 200
    end
  end
  
  def dispose_namepop
    # 의뢰 게시판인 경우 수정
    if $game_map.map_id == 35
      if @help_window != nil
        @help_window.dispose
      end
    else
      if @namepop_sprite
        @namepop_sprite.bitmap.dispose
        @namepop_sprite.dispose
        @namepop_sprite = nil
      end
    end
  end
  
  def update_mrbt
    # 카메라 이동시 미니 대화창 바로 제거
    if $game_switches[54] == true or HM_SEL::time_stop? or $game_switches[283] == true
      @character.mrbt = nil
    else
      if @mrbt_duration > 0
        @mrbt_duration -= 1
        if @mrbt_duration == 0
          @character.mrbt = nil
        else
          @mrbt_sprite.x = x
          @mrbt_sprite.y = y - height
          @mrbt_sprite.y += 20 if $game_map.map_id == 21
          @mrbt_sprite.opacity = @mrbt_duration * 24
        end
      end
    end
  end
  
  alias tmmrbt_sprite_character_setup_new_effect setup_new_effect
  def setup_new_effect
    tmmrbt_sprite_character_setup_new_effect
    if @mrbt != @character.mrbt
      @mrbt = @character.mrbt
      start_mrbt(@mrbt)
    end
  end
  
  def text_color(n)
    x = (n % 8) * 8
    y = 32 + (n / 8) * 8
    return @bitmap_mrbt.get_pixel(x, y)
  end
  
  def convert_special_characters(text)
    text.gsub!(/\\/)               { "\e" }
    text.gsub!(/\e\e/)             { "\\" }
    text.gsub!(/\eV\[([0-9]+)\]/i) { $game_variables[$1.to_i] }
    text.gsub!(/\eV\[([0-9]+)\]/i) { $game_variables[$1.to_i] }
    text.gsub!(/\eN\[([0-9]+)\]/i) { actor_name($1.to_i) }
    text.gsub!(/\eP\[(\d+)\]/i)    { party_member_name($1.to_i) }
    text.gsub!(/\eG/i)             { Vocab::currency_unit }
    text.gsub!(/\eL/i)             { "\x00" }
    text.gsub!(/\eC\[([0-9]+)\]/i) { "\x01[#{$1}]" }
    text
  end
  
  def actor_name(n)
    actor = n >= 1 ? $game_actors[n] : nil
    actor ? actor.name : ""
  end
  
  def party_member_name(n)
    actor = n >= 1 ? $game_party.members[n - 1] : nil
    actor ? actor.name : ""
  end
  
  def start_mrbt(text)
    dispose_mrbt
    return unless text
    @mrbt_duration = TMMRBT::MESSAGE_DURATION
    text = convert_special_characters(text.clone)
    pos = {:x => 4, :y => 0, :width => 0, :line_height => TMMRBT::FONT_SIZE + 4}
    bitmap = Bitmap.new(160, 160)
    bitmap.font.size = TMMRBT::FONT_SIZE
    # 미니 대화창 폰트 변경 실험
    bitmap.font.name = "효과음 아앙체 2E"
    loop do
      c = text.slice!(/./m)
      case c
      when nil
        break
      when "\x00"
        process_new_line(pos)
      when "\x01"
        text.sub!(/\[([0-9]+)\]/, "")
        bitmap.font.color = text_color($1.to_i)
      else
        bitmap.draw_text(pos[:x], pos[:y], 40, pos[:line_height], c)
        c_width = bitmap.text_size(c).width
        pos[:x] += c_width
        # 미니 대화창 최대 길이 조절
        process_new_line(pos) if pos[:x] >= 160
      end
    end
    w = [pos[:x], pos[:width]].max + 4
    h = pos[:y] + (pos[:x] == 4 ? 0 : pos[:line_height])
    create_mrbt_sprite(w, h)
    @mrbt_sprite.bitmap.blt(0, 0, bitmap, bitmap.rect)
    bitmap.dispose
    update_mrbt
  end
  
  def process_new_line(pos)
    pos[:width] = pos[:x] if pos[:width] < pos[:x]
    pos[:x] = 4
    pos[:y] += pos[:line_height]
  end
  
  def create_mrbt_sprite(width, height)
    @mrbt_sprite = ::Sprite.new(nil)
    @mrbt_sprite.z = 90
    @mrbt_sprite.ox = width / 2
    @mrbt_sprite.oy = height + 4
    @mrbt_sprite.bitmap = Bitmap.new(width, height + 8)
    rect = Rect.new(0, 0, 8, 8)
    alpha = TMMRBT::BACK_OPACITY
    @mrbt_sprite.bitmap.blt(0, 0, @bitmap_mrbt, rect, alpha)
    rect.x += 8
    @mrbt_sprite.bitmap.blt(width - 8, 0, @bitmap_mrbt, rect, alpha)
    rect.y += 8
    @mrbt_sprite.bitmap.blt(width - 8, height - 8, @bitmap_mrbt, rect, alpha)
    rect.x -= 8
    @mrbt_sprite.bitmap.blt(0, height - 8, @bitmap_mrbt, rect, alpha)
    rect.set(16, 0, 8, 8)
    @mrbt_sprite.bitmap.blt(@mrbt_sprite.ox - 4, height, @bitmap_mrbt, rect, alpha)
    color = @bitmap_mrbt.get_pixel(8, 8)
    color.alpha = alpha
    @mrbt_sprite.bitmap.fill_rect(8, 0, width - 16, height, color)
    @mrbt_sprite.bitmap.fill_rect(0, 8, 8, height - 16, color)
    @mrbt_sprite.bitmap.fill_rect(width - 8, 8, 8, height - 16, color)
  end
  
  alias mog_character_ex_effects_update_other update_other
  def update_other
    mog_character_ex_effects_update_other
    if @character_name != ""
      update_mrbt
      update_other_ex
      # 빛 효과 블렌드 적용 안되는 오류 보정
      if @character_name == "!$Map_Window_1" or @character_name == "!$Map_Window_2" or
        @character_name == "!$Map_Window_3" or @character_name == "!$Map_Window_4" or
        @character_name == "!$Map_Window_5" or @character_name == "!$Torchlight4"
        self.blend_type = 1
      end
    end
  end
  
  def update_other_ex
    @character.zoom_x = 1 if @character.zoom_x == nil
    @character.zoom_y = 1 if @character.zoom_y == nil
    @character.mirror = 0 if @character.mirror == nil
    @character.angle  = 0 if @character.angle == nil
    self.zoom_x = @character.zoom_x
    self.zoom_y = @character.zoom_y
    self.mirror = @character.mirror
    self.angle = @character.angle
  end
  
  # 애니메이션 개체 위치 및 동작
  def update_anime_object_pos
    if @character.is_a?(Anime_Obj)
      # 잔상 제거 위한 실험
      if @character.user.anime_speed >= 1
        @character.user.anime_speed -= 1
      end
      if @character.custom_graphic
        add = 0
      else
        @ch == 128 ? add = 48 : add = (@ch / 2) / 2
      end
      self.x = @character.user.screen_x
      self.y = @character.user.screen_y + add
      # 방향 조건에 무기 그래픽 z 값 변경, 방패, 방어
      @character.direction = @character.user.direction
      if @character.user.direction == 4 || @character.user.direction == 8
        self.z = @character.user.screen_z - 1
      end
      if 0 >= @character.user.anime_speed
        if @character.custom_graphic
          @character.user.transparent = false
          @character.user.using_custom_g = false
        end
        @character.destroy_it = true
      end
      if @character.user.making_spiral
        @character.direction == 8 ? @character.pattern = 1 : @character.pattern = 2
        return
      end
      if @character.original_speed != 0
        a = (@character.user.anime_speed.to_f / @character.original_speed.to_f * 100).to_i
        case a
          when 80..100 ; @character.pattern = 0 
          when 60..79  ; @character.pattern = 1
          when 0..59   ; @character.pattern = 2
        end
      end
    end
  end
  
  def battler_graphic?
    if !@character.battler.nil? and @character.battler.is_a?(Game_Enemy) and @character.battler.battler_graphic
      return false if @character.page.nil?
      @character_name = @character.battler.battler_name
      return true 
    end
    return false
  end
  
  # 숨쉬기 효과
  def apply_breath_effect(char)
    return if @character.is_a?(Game_Event) and @character.erased
    
    # 오브젝트면 숨쉬기 취소 적용
    return if @character.is_a?(Anime_Obj) or @character.is_a?(Projectile)
    
    # 안죽었을때만 숨쉬도록 실험
    if @character.battler.dead?
      char.zoomfx_x = 0.8
      char.zoomfx_y = 0.8
    else
      # 이펙트 움직이는 버그 수정 실험
      char.zoomfx_x -= 0.0023 if !char.zfx_bol
      char.zoomfx_y -= 0.0023 if !char.zfx_bol
      char.zoomfx_x += 0.0023 if char.zfx_bol
      char.zoomfx_y += 0.0023 if char.zfx_bol
      char.zfx_bol = true if char.zoomfx_x <= 0.93
      char.zfx_bol = false if char.zoomfx_x >= 1.0
    end
  end
 
  def iconset_graphic?
    !@character.user_iconset.nil? || !@character.pro_iconset.nil?
  end
  
  alias falcao_fantastic_bit update_bitmap
  def update_bitmap
    if iconset_graphic?
      if @apply_iconset.nil?
        icon = @character.user_iconset[0] if !@character.user_iconset.nil? and
        @character.is_a?(Anime_Obj)
        icon = @character.pro_iconset[0] if !@character.pro_iconset.nil? and
        @character.is_a?(Projectile)
        set_iconsetbitmap(icon)
        @apply_iconset = true
      end
      # 주석 처리하면 이펙트 움직임, 주석 처리하지 말 것
      apply_breath_effect2(@character) if !@character.pro_iconset.nil? and @character.is_a?(Projectile) and @character.pro_iconset[1] == :animated
      @enable_angle = @character.user_iconset[1] if !@character.user_iconset.nil? and @character.is_a?(Anime_Obj)
      return
    end
    falcao_fantastic_bit
  end
 
  alias falcaopearl_update_position update_position
  def update_position
    falcaopearl_update_position
    update_anime_object_pos
    set_angle_changes(@enable_angle) if @enable_angle != nil
  end
  
  def apply_angle_pattern(x_plus, y_plus, angle)
    self.x = @character.user.screen_x + x_plus
    self.y = @character.user.screen_y + y_plus
    self.angle = angle
  end
 
  def set_angle_changes(type)
    ani= @character.user.anime_speed.to_f / @character.original_speed.to_f * 100.0
    case ani
    when 80..100
      perform_animated(0) if type == :animated
    when 60..80
      perform_animated(1) if type == :animated
    when 0..60
      perform_animated(2) if type == :animated
    end
    if type != :animated
      perform_static      if type == :static
      perform_shielding   if type == :shielding
    end
  end

  def perform_animated(pattern)
    case pattern
    when 0
      apply_angle_pattern(10, -12, -166)  if @character.user.direction == 2
      if @character.user.direction == 4 || @character.user.direction == 6
        apply_angle_pattern(-8, -26, -46)
        self.z = @character.user.screen_z - 1
      end
      apply_angle_pattern(-22, -10, 0)    if @character.user.direction == 8
    when 1
      apply_angle_pattern(0, 0, -266)     if @character.user.direction == 2
      apply_angle_pattern(-20, -10, 12)   if @character.user.direction == 4
      apply_angle_pattern(7, -20, -78)    if @character.user.direction == 6
      if @character.user.direction == 8
        apply_angle_pattern(-8, -26, -46)
        self.z = @character.user.screen_z - 1
      end
    when 2
      apply_angle_pattern(8, -5, -210)    if @character.user.direction == 2
      apply_angle_pattern(-10, 2, 52)     if @character.user.direction == 4
      apply_angle_pattern(8, -15, -126)   if @character.user.direction == 6
      apply_angle_pattern(10, -16, - 100) if @character.user.direction == 8
    end
  end
 
  def perform_static
    apply_angle_pattern(8, -5, -210)    if @character.user.direction == 2
    apply_angle_pattern(-10, 2, 52)     if @character.user.direction == 4
    apply_angle_pattern(8, -15, -126)   if @character.user.direction == 6
    if @character.user.direction == 8
      apply_angle_pattern(-8, -26, -46)
      self.z = @character.user.screen_z - 1
    end
  end
 
  def perform_shielding
    apply_angle_pattern(2, 4, 0)        if @character.user.direction == 2
    apply_angle_pattern(-10, 0, 0)      if @character.user.direction == 4
    if @character.user.direction == 6
      apply_angle_pattern(10, 0, 0)  
      self.z = @character.user.screen_z - 1
    elsif @character.user.direction == 8
      apply_angle_pattern(11, -9, 0)  
      self.z = @character.user.screen_z - 1
    end
  end
 
  def apply_breath_effect2(char)
    # 이펙트 움직이는 버그 수정
    char.zoomfx_x -= 0.03 if !char.zfx_bol
    char.zoomfx_y -= 0.03 if !char.zfx_bol
    char.zoomfx_x += 0.03 if char.zfx_bol
    char.zoomfx_y += 0.03 if char.zfx_bol
    char.zfx_bol = true if char.zoomfx_x <= 0.84
    char.zfx_bol = false if char.zoomfx_x >= 1.0
  end
 
  alias falcao_fantastic_src update_src_rect
  def update_src_rect
    return if iconset_graphic? or battler_graphic?
    falcao_fantastic_src
  end

  def set_iconsetbitmap(icon_index, enabled = true)
    self.bitmap = Bitmap.new(24, 24)
    icon_index += 1
    bit = Cache.system("icon/"+"#{icon_index}")
    rect = Rect.new(0, 0, 24, 24)
    self.bitmap.blt(0, 0, bit, rect, enabled ? 255 : 150)
    @cw = self.ox = 12
    @ch = self.oy = 24
  end
end