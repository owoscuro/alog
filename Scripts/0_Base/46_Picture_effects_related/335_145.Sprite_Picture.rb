# encoding: utf-8
# Name: 145.Sprite_Picture
# Size: 23083
#-------------------------------------------------------------------------------
# 0 - 쉐이크 타입 A
# 1 - 쉐이크 B형
# 2 - 호흡 효과
# 3 - 자동 줌 효과(루프)
# 4 - 페이드 효과(루프)
# 5 - 두 방향의 롤링 효과.
# 6 - 웨이브 효과.
# 7 - 프레임 애니메이션 효과, GIF 스타일.
#-------------------------------------------------------------------------------
# 이벤트 명령어를 통해 아래 명령어를 사용하세요.
#
# picture_effect(PICTURE_ID ,EFFECT_TYPE ,POWER , SPEED)
#
# PICTURE_ID = ID da imagem.
# EFFECT TYPE = Tipo de efetio da imagem. (0 a 7)
# POWER = Poder do efeito. 
# SPEED = Velocidade do efeito.
#
# picture_effect(1,5,10,50)
#-------------------------------------------------------------------------------
# Picture_Name.png
# Picture_Name0.png
# Picture_Name1.png
# Picture_Name2.png
# Picture_Name3.png
# Picture_Name4.png
#
# picture_position(PICTURE ID, TARGET ID)
#
# PICTURE ID = ID da imagem
# TARGET ID = ID do alvo
#
# 0        = 정상 위치.
# 1..999   = 이벤트 위치(ID).
# -1       = 선수 위치.
# -2       = 이미지의 고정 위치.
#
#-------------------------------------------------------------------------------
#
# picture_effects_clear(PICTURE_ID)
#
#-------------------------------------------------------------------------------


# `z=': Expected fixnum.
# Cambiado a Integer.
class Sprite
  alias original_z= z=
  def z=(value)
    if value.is_a?(Integer) || value.is_a?(Fixnum)
      original_z=(value)
    else
      raise TypeError, "Expected Integer for z=, got #{value.class} instead."
    end 
  end
end


$imported = {} if $imported.nil?
$imported[:mog_picture_effects] = true

class Sprite_Picture < Sprite
  alias mog_picture_ex_dispose dispose
  def dispose
    mog_picture_ex_dispose
    @picture.effect_ex[6][0] = true if @picture.effect_ex[6]
    @picture.anime_frames[0] = true if @picture.effect_ex[7]
    dispose_pic_frames if !@picture.effect_ex[7]
  end  

  def dispose_pic_frames
    return if @pic_frames.nil?
    @pic_frames.each {|picture| picture.dispose } ; @pic_frames = nil
  end

  alias mog_picture_ex_update_bitmap update_bitmap
  def update_bitmap
    refresh_effect_ex if @old_name_ex != @picture.name
    if !@picture.anime_frames.empty? and self.bitmap
       update_picture_animation ; return
    end
    mog_picture_ex_update_bitmap
    create_picture_animation if can_create_frame_picture?
    set_wave_effect if can_set_wave_effect?
  end

  def refresh_effect_ex
   (self.wave_amp = 0 ; self.wave_length = 1 ; self.wave_speed = 0) if !@picture.effect_ex[6]
    @old_name_ex = @picture.name
    create_picture_animation if @picture.effect_ex[7]
    set_wave_effect if can_set_wave_effect? 
  end

  def can_create_frame_picture?
    return false if !@picture.anime_frames[0]
    return false if !self.bitmap
    return true
  end

  def update_picture_animation
    return if @pic_frames == nil
    if @picture.anime_frames[6] > 0 ; @picture.anime_frames[6] -= 1 ; return 
    end
    @picture.anime_frames[4] += 1
    return if @picture.anime_frames[4] < @picture.anime_frames[2]
    self.bitmap = @pic_frames[@picture.anime_frames[3]]
    @picture.anime_frames[4] = 0 ; @picture.anime_frames[3] += 1
    if @picture.anime_frames[3] >= @pic_frames.size
       @picture.anime_frames[3] = 0 ; @picture.anime_frames[6] = @picture.anime_frames[5]
    end
  end

  def create_picture_animation
    dispose_pic_frames ; @pic_frames = [] ; @picture.anime_frames[0] = false     
    for index in 0...999
        @pic_frames.push(Cache.picture(@picture.name + index.to_s)) rescue nil
        break if @pic_frames[index] == nil
    end
    if @pic_frames.size <= 1
       dispose_pic_frames ; @pic_frames = nil ; @picture.anime_frames.clear
       @picture.effect_ex[7] = nil ; return
    end  
    self.bitmap = @pic_frames[@picture.anime_frames[3]]
    update_picture_animation
  end

  def update_position
    if @picture.number == 21
      self.z = -2000000000
    elsif @picture.number != 12 and @picture.number != 49
      self.z = @picture.number + $game_system.picture_screen_z
    elsif @picture.number == 22
      self.z = 2000
    else
      self.z = 1
    end
    if @picture.effect_ex[0] ; update_shake_effect(0) ; return ; end
    if @picture.effect_ex[1] ; update_shake_effect(1) ; return ; end
    self.x = pos_x; self.y = pos_y
    if self.bitmap != nil
      # 프롤로그 진행시
      if @picture.number == 2 and $game_map.map_id == 110
        $game_variables[83] = 70
        rate = $game_variables[83].to_f / 100
        $game_variables[292] = (Graphics.width * 0.45) - ((self.bitmap.width * rate) * 0.5).to_i
        $game_variables[293] = Graphics.height - (self.bitmap.height * rate).to_i
        self.x = $game_variables[292]
        self.y = $game_variables[293] + ($game_variables[83] - 70)
      # 쉬어가기 이미지 기준 중앙에 표시
      elsif @picture.number == 40 or @picture.number == 19 or
        $game_map.screen.pictures[22].name == "G_END_YOU_DIED" or
        $game_map.screen.pictures[22].name == "UI_Feast" or
        $game_map.screen.pictures[22].name == "UI_Sleep" or
        $game_map.screen.pictures[22].name == "UI_Carriage"
        #print("145.Sprite_Picture - 쉬어가기 이미지 중앙 표시 \n");
        self.x = (Graphics.width / 2) - (self.bitmap.width / 2)
        self.y = (Graphics.height / 2) - (self.bitmap.height / 2)
      # NPC 스탠딩 이미지 기준, H 씬 이미지가 아닌 경우에만 적용
      elsif $game_switches[283] == false and @picture.number == 22
        rate = $game_variables[83].to_f / 100
        $game_variables[292] = (Graphics.width * 0.18) - ((self.bitmap.width * rate) * 0.5).to_i
        $game_variables[293] = Graphics.height - (self.bitmap.height * rate).to_i
        #print("145.Sprite_Picture - NPC 스탠딩 이미지 좌표 적용 \n");
        self.x = $game_variables[292]
        self.y = $game_variables[293] + ($game_variables[83] - 70)
      end
      if @picture.number == 22 or @picture.number == 23 or @picture.number == 40
        # H 씬 이미지 반전 적용
        if $game_variables[60] == 3 and $game_switches[189] == true
          self.mirror = true
        # 시체 오브젝트 이미지
        elsif $game_variables[60] == 3 and @picture.number == 40
          self.mirror = true
        else
          self.mirror = false
        end
      end
    end
    set_oxy_correction
  end

  def pos_x
    # 시간 가속인 경우 에르니 스탠딩 이미지 안보이도록 수정
    if $game_switches[283] == true and self.bitmap != nil and @picture.number >= 2 and 10 >= @picture.number
      return Graphics.width
    else
      return @picture.x
    end
  end

  def pos_y
    return @picture.y
  end

  def set_oxy_correction
    return if @picture.position[0] == -2
    return if self.bitmap == nil
    # --------------------------------------------------------------------------
    # 아래는 시간 가속중이 아닌 경우에만 적용
    # --------------------------------------------------------------------------
    if $game_switches[283] == false
      # 에르니 이미지 이동
      if @picture.number == 3 and $game_switches[200] == true
        # 스탠딩 이미지 기준
        rate = $game_variables[83].to_f / 100
        $game_variables[84] = (Graphics.width * 0.8) - ((self.bitmap.width * rate) * 0.7).to_i + (($game_variables[83] - 70) * 4)
        #$game_variables[84] = (Graphics.width - (self.bitmap.width*0.7) - ($game_variables[83] - 70)).to_i
        if $game_map.screen.pictures[3].name == "body/Battler_Actor7_0_1(HP100)" or
          $game_map.screen.pictures[3].name == "body/Battler_Actor7_0_1(HP60)" or
          $game_map.screen.pictures[3].name == "body/Battler_Actor7_0_1(HP40)" or
          $game_map.screen.pictures[3].name == "body/Battler_Actor7_0_1(HP20)" or
          $game_map.screen.pictures[3].name == "body/Battler_Actor7_0_1(B_HP100)" or
          $game_map.screen.pictures[3].name == "body/Battler_Actor7_0_1(B_HP60)" or
          $game_map.screen.pictures[3].name == "body/Battler_Actor7_0_1(B_HP40)" or
          $game_map.screen.pictures[3].name == "body/Battler_Actor7_0_1(B_HP20)"
          $game_variables[87] = Graphics.height - (self.bitmap.height * rate).to_i
          $game_variables[87] += ($game_variables[83] - 70)
          #$game_variables[87] = (Graphics.height - (self.bitmap.height*0.75) - ($game_variables[83] - 70)).to_i
        else
          $game_variables[87] = Graphics.height - (self.bitmap.height * rate).to_i
          $game_variables[87] += ($game_variables[83] - 70) - 30
          #$game_variables[87] = (Graphics.height - (self.bitmap.height*0.8) - ($game_variables[83] - 70)).to_i
        end
        # 에르니 사망시 눈깜빡임 종료
        if $game_switches[46] != true and $game_switches[47] != true
          if $game_actors[7].state?(1) == true
            $game_variables[268] = 0
            $game_variables[115] = $game_variables[84]
            $game_variables[116] = $game_variables[87]
          else
            # 에르니 이미지 고정 및 이동
            if $game_switches[200] != true
              $game_variables[115] = $game_variables[84]
              $game_variables[116] = $game_variables[87]
            else
              if $game_variables[115] > $game_variables[84] + 20
                $game_variables[115] -= 21
              elsif $game_variables[84] > $game_variables[115] + 20
                $game_variables[115] += 21
              elsif $game_variables[115] > $game_variables[84] + 10
                $game_variables[115] -= 11
              elsif $game_variables[84] > $game_variables[115] + 10
                $game_variables[115] += 11
              elsif $game_variables[115] > $game_variables[84]
                $game_variables[115] -= 1
              elsif $game_variables[84] > $game_variables[115]
                $game_variables[115] += 1
              end
              if $game_variables[116] > $game_variables[87] + 20
                $game_variables[116] -= 21
              elsif $game_variables[87] > $game_variables[116] + 20
                $game_variables[116] += 21
              elsif $game_variables[116] > $game_variables[87] + 10
                $game_variables[116] -= 11
              elsif $game_variables[87] > $game_variables[116] + 10
                $game_variables[116] += 11
              elsif $game_variables[116] > $game_variables[87]
                $game_variables[116] -= 1
              elsif $game_variables[87] > $game_variables[116]
                $game_variables[116] += 1
              end
            end
          end
        end
      end
      if @picture.number >= 3 and 8 >= @picture.number
        self.x = $game_variables[115] if self.x != $game_variables[115]
        self.y = $game_variables[116] if self.y != $game_variables[116]
      elsif @picture.number >= 9 and 10 >= @picture.number
        self.x = $game_variables[115] if self.x != $game_variables[115]
        self.y = $game_variables[116] if self.y != $game_variables[116]
        self.blend_type = 1
      end
    end
    # --------------------------------------------------------------------------
    # 위는 시간 가속중이 아닌 경우에만 적용
    # --------------------------------------------------------------------------
    if @picture.number != 12
      self.x += self.ox if @picture.effect_ex[3] or @picture.effect_ex[5]
      self.y += self.oy if @picture.effect_ex[2] or @picture.effect_ex[3] or @picture.effect_ex[5]
    elsif @picture.number == 12 and $game_switches[283] == false
      self.x = $game_variables[138] + self.ox
      self.y = $game_variables[139] + self.oy
      self.blend_type = 1
    end
  end

  def update_shake_effect(type)
    @picture.effect_ex[type][2] += 1
    return if @picture.effect_ex[type][2] < @picture.effect_ex[type][1]
    @picture.effect_ex[type][2] = 0
    self.x = pos_x + shake_effect(type)
    self.y = @picture.effect_ex[1] ? pos_y + shake_effect(type) : pos_y
    set_oxy_correction
  end

  def shake_effect(type)
    -(@picture.effect_ex[type][0] / 2) +  rand(@picture.effect_ex[type][0]) 
  end

  def update_other
    if @picture.effect_ex[4]
      # ------------------------------------------------------------------------
      # 아래는 시간 가속중이 아닌 경우에만 적용
      # ------------------------------------------------------------------------
      if $game_switches[283] == false
        # 햇빛 효과
        if @picture.number == 12 and self.opacity > $picture_12_op
          #print("072 + Sprite_Picture - 햇빛 효과 \n");
          self.opacity = $picture_12_op
          self.blend_type = 1
          $picture_140_op = 1
        end
        # 죽음 효과
        if @picture.number == 49 and self.opacity > $picture_49_op
          #print("072 + Sprite_Picture - 죽음 효과 \n");
          self.opacity = $picture_49_op
          $picture_123_op = 1
        end
      end
      update_opacity_ex
    else
      if @picture.number != 12 and @picture.number != 49
        self.opacity = @picture.opacity
      else
        self.opacity = 0
      end
    end
    if @picture.effect_ex[5]
      update_angle_ex
    else
      self.angle = @picture.angle
    end   
    self.tone.set(@picture.tone)
  end  

  def update_angle_ex
    @picture.effect_ex[5][4] += 1
    return if @picture.effect_ex[5][4] < @picture.effect_ex[5][3]
    @picture.effect_ex[5][4] = 0 ; @picture.effect_ex[5][1] += 1
    case @picture.effect_ex[5][1]
      when 0..@picture.effect_ex[5][2]
        @picture.effect_ex[5][0] += 1
      when @picture.effect_ex[5][2]..(@picture.effect_ex[5][2] * 3)
        @picture.effect_ex[5][0] -= 1
      when (@picture.effect_ex[5][2] * 3)..(-1 + @picture.effect_ex[5][2] * 4)
        @picture.effect_ex[5][0] += 1
      else
        @picture.effect_ex[5][0] = 0 ; @picture.effect_ex[5][1] = 0
    end
    self.angle = @picture.angle + @picture.effect_ex[5][0]
  end

  def update_opacity_ex
    # --------------------------------------------------------------------------
    # 아래는 시간 가속중이 아닌 경우에만 적용
    # --------------------------------------------------------------------------
    if $game_switches[283] == false and $sel_time_frame_10 == 9
      if @picture.number == 12
        self.blend_type = 1
        if $picture_12_op != 0 and ($game_variables[12] == 0 or $game_variables[12] == nil)
          if $picture_140_op == 0
            #print("145.Sprite_Picture - 햇빛 투명도 +%s \n" % [$picture_12_op]);
            self.opacity += 1
            $picture_140_op = 1 if self.opacity > $picture_12_op
          elsif $picture_140_op == 1
            #print("145.Sprite_Picture - 햇빛 투명도 -%s \n" % [$picture_12_op]);
            self.opacity -= 1
            $picture_140_op = 0 if 1 > self.opacity
          end
        elsif $picture_12_op == 0
          #print("145.Sprite_Picture - 비오는 날씨, 햇빛 투명도 0 \n");
          self.opacity -= 1 if self.opacity > 1
        end
      elsif @picture.number == 49
        case $game_variables[117]
          when 5..7
            $picture_49_op = 155
          when 3..4
            $picture_49_op = 205
          when 2
            $picture_49_op = 255
          else
            $picture_49_op = 0
        end
        if $picture_123_op == 0
          self.opacity += 1
          $picture_123_op = 1 if self.opacity > $picture_49_op
        elsif $picture_123_op == 1
          self.opacity -= 1
          $picture_123_op = 0 if 1 > self.opacity
        end
      end
    end
    # --------------------------------------------------------------------------
    # 위는 시간 가속중이 아닌 경우에만 적용
    # --------------------------------------------------------------------------
    if @picture.number != 12 and @picture.number != 49
      @picture.effect_ex[4][6] += 1
      return if @picture.effect_ex[4][6] < @picture.effect_ex[4][5]
      @picture.effect_ex[4][6] = 0 ; @picture.effect_ex[4][2] += 1
      case @picture.effect_ex[4][2]
        when 0..@picture.effect_ex[4][4]
          @picture.effect_ex[4][0] -= @picture.effect_ex[4][3]
        when @picture.effect_ex[4][4]..(-1 + @picture.effect_ex[4][4] * 2)
          @picture.effect_ex[4][0] += @picture.effect_ex[4][3]
        else
          @picture.effect_ex[4][0] = 255
          @picture.effect_ex[4][2] = 0
      end
      self.opacity = @picture.effect_ex[4][0]
    end
  end

  def update_origin
    return if !self.bitmap
    if force_center_oxy?
      # NPC 스탠딩 이미지 기준, H 씬 이미지가 아닌 경우에만 적용
      if $game_switches[283] == false and @picture.number == 22
        rate = $game_variables[83].to_f / 100
        self.ox = @picture.effect_ex[2] ? n_ox : ((bitmap.width * rate) / 2) + n_ox
        self.oy = ((bitmap.height * rate) / 2) + n_oy
      # 에르니 스탠딩 이미지
      elsif (@picture.number >= 3 and 8 >= @picture.number) or (@picture.number >= 9 and 10 >= @picture.number) and $game_switches[200] == true
        rate = $game_variables[83].to_f / 100
        self.ox = @picture.effect_ex[2] ? n_ox : ((bitmap.width * rate) / 2) + n_ox
        self.oy = ((bitmap.height * rate) / 2) + n_oy
      # 프롤로그 진행시
      elsif @picture.number == 2 and $game_map.map_id == 110
        $game_variables[83] = 70
        rate = $game_variables[83].to_f / 100
        self.ox = @picture.effect_ex[2] ? n_ox : ((bitmap.width * rate) / 2) + n_ox
        self.oy = ((bitmap.height * rate) / 2) + n_oy
      else
        self.ox = @picture.effect_ex[2] ? n_ox : (bitmap.width / 2) + n_ox
        self.oy = (bitmap.height / 2) + n_oy
      end
      if @picture.position[0] > 0 or @picture.position[0] == -1
        execute_move(0,@picture.position[2],-@picture.position[1].screen_x) rescue nil
        execute_move(1,@picture.position[3],-@picture.position[1].screen_y) rescue nil
      end
      return
    end
    if @picture.effect_ex[2] ; self.oy = (bitmap.height + n_oy) ; return ; end
    if @picture.origin == 0
      self.ox = n_ox ; self.oy = n_oy
    else
      # NPC 스탠딩 이미지 기준, H 씬 이미지가 아닌 경우에만 적용
      if $game_switches[283] == false and @picture.number == 22
        self.ox = ((bitmap.width * rate) / 2) + n_ox 
        self.oy = ((bitmap.height * rate) / 2) + n_oy
      # 에르니 스탠딩 이미지
      elsif (@picture.number >= 3 and 8 >= @picture.number) or (@picture.number >= 9 and 10 >= @picture.number) and $game_switches[200] == true
        self.ox = ((bitmap.width * rate) / 2) + n_ox 
        self.oy = ((bitmap.height * rate) / 2) + n_oy
      # 프롤로그 진행시
      elsif @picture.number == 2 and $game_map.map_id == 110
        self.ox = ((bitmap.width * rate) / 2) + n_ox 
        self.oy = ((bitmap.height * rate) / 2) + n_oy
      else
        self.ox = (bitmap.width / 2) + n_ox 
        self.oy = (bitmap.height / 2) + n_oy
      end
    end
  end

  def force_center_oxy?
      return false if @picture.position.empty?
      return true if @picture.position[0] == -1
      return true if @picture.position[0] > 0
      return true if @picture.effect_ex[3]
      return true if @picture.effect_ex[5]
      return false
  end

  def n_ox
      return @picture.position[2] if @picture.position[0] > 0 and @picture.position[2]
      return @picture.position[2] if @picture.position[0] == -1 and @picture.position[2]
      return $game_map.display_x * 32 if @picture.position[0] == -2
      return 1000 if @picture.position[0] == -1000
      return 0
  end

  def n_oy
      return @picture.position[3] if @picture.position[0] > 0 and @picture.position[3] 
      return @picture.position[3] if @picture.position[0] == -1 and @picture.position[3] 
      return $game_map.display_y * 32 if @picture.position[0] == -2
      return 1000 if @picture.position[0] == -1000
      return 0
  end

  def execute_move(type,cp,np)
      sp = 5 + ((cp - np).abs / 5)
      if cp > np ;    cp -= sp ; cp = np if cp < np
      elsif cp < np ; cp += sp ; cp = np if cp > np
      end     
      @picture.position[2] = cp if type == 0 
      @picture.position[3] = cp if type == 1
  end    

  alias mog_picture_ex_update_zoom update_zoom
  def update_zoom
    if @picture.effect_ex[2] ;  update_breath_effect ; return ; end
    if @picture.effect_ex[3] ;  update_auto_zoom_effect ; return ; end
    mog_picture_ex_update_zoom
  end    

  def update_breath_effect
    self.zoom_x = @picture.zoom_x / 100.0
    self.zoom_y = @picture.zoom_y / 101.0 + auto_zoom(2)
  end  

  def update_auto_zoom_effect
    self.zoom_x = @picture.zoom_x / 100.0 + auto_zoom(3)
    self.zoom_y = @picture.zoom_y / 100.0 + auto_zoom(3)
  end

  def auto_zoom(type)
      if @picture.effect_ex[type][6] == 0
         @picture.effect_ex[type][6] = 1
         @picture.effect_ex[type][0] = rand(50)
      end
      if @picture.effect_ex[type][5] < @picture.effect_ex[type][4]
         @picture.effect_ex[type][5] += 1
         return @picture.effect_ex[type][1]
      end    
      @picture.effect_ex[type][5] = 0
      @picture.effect_ex[type][2] -= 1
      return @picture.effect_ex[type][1] if @picture.effect_ex[type][2] > 0
      @picture.effect_ex[type][2] = 2 ; @picture.effect_ex[type][0] += 1
      case @picture.effect_ex[type][0]
         when 0..25 ; @picture.effect_ex[type][1] += @picture.effect_ex[type][3]         
         when 26..60 ; @picture.effect_ex[type][1] -= @picture.effect_ex[type][3]
         else ; @picture.effect_ex[type][0] = 0 ; @picture.effect_ex[type][1] = 0
      end
      @picture.effect_ex[type][1] = 0 if @picture.effect_ex[type][1] < 0
      @picture.effect_ex[type][1] = 0.25 if @picture.effect_ex[type][1] > 0.25 if type == 2
      return @picture.effect_ex[type][1]
  end

  def can_set_wave_effect?
      return false if !@picture.effect_ex[6]
      return false if !@picture.effect_ex[6][0]
      return false if !self.bitmap
      return true
  end

  def set_wave_effect 
      @picture.effect_ex[6][0] = false
      self.wave_amp = @picture.effect_ex[6][1]
      self.wave_length = self.bitmap.width
      self.wave_speed = @picture.effect_ex[6][2]
  end
    
  alias wora_picbelow_sprpic_upd update
  def update(*args)
    wora_picbelow_sprpic_upd(*args)
    if @picture.number.between?(Spriteset_Map::FIRST_PICBELOW_ID,Spriteset_Map::LAST_PICBELOW_ID)
      self.z = 0
    end
  end
end