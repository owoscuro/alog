# encoding: utf-8
# Name: Sprite_Character
# Size: 10772
#==============================================================================
# ** Sprite_Character
#------------------------------------------------------------------------------
#  This sprite is used to display characters. It observes an instance of the
# Game_Character class and automatically changes sprite state.
#==============================================================================

class Sprite_Character < Sprite_Base
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :character
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     character : Game_Character
  #--------------------------------------------------------------------------
  def initialize(viewport, character = nil)
    super(viewport)
    @character = character
    @balloon_duration = 0
    update
  end
  #--------------------------------------------------------------------------
  # * Free
  #--------------------------------------------------------------------------
  def dispose
    end_animation
    end_balloon
    super
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    update_bitmap
    update_src_rect
    update_position
    update_other
    update_balloon
    # Alog https://arca.live/b/alog
    blend_update
    setup_new_effect
  end
  #--------------------------------------------------------------------------
  # Alog https://arca.live/b/alog
  def blend_update
    self.color = @character.blend_color
  end
  #--------------------------------------------------------------------------
  # * 지정된 타일을 포함하는 타일셋 이미지 가져오기
  #--------------------------------------------------------------------------
  def tileset_bitmap(tile_id)
    Cache.tileset($game_map.tileset.tileset_names[5 + tile_id / 256])
  end
  #--------------------------------------------------------------------------
  # * Update Transfer Origin Bitmap
  #--------------------------------------------------------------------------
  def update_bitmap
    if graphic_changed?
      @tile_id = @character.tile_id
      @character_name = @character.character_name
      @character_index = @character.character_index
      if @tile_id > 0
        set_tile_bitmap
      else
        set_character_bitmap
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Determine if Graphic Changed
  #--------------------------------------------------------------------------
  def graphic_changed?
    @tile_id != @character.tile_id ||
    @character_name != @character.character_name ||
    @character_index != @character.character_index
  end
  #--------------------------------------------------------------------------
  # * Set Tile Bitmap
  #--------------------------------------------------------------------------
  def set_tile_bitmap
    sx = (@tile_id / 128 % 2 * 8 + @tile_id % 8) * 32;
    sy = @tile_id % 256 / 8 % 16 * 32;
    self.bitmap = tileset_bitmap(@tile_id)
    self.src_rect.set(sx, sy, 32, 32)
    self.ox = 16
    self.oy = 32
  end
  #--------------------------------------------------------------------------
  # * Set Character Bitmap
  #--------------------------------------------------------------------------
  def set_character_bitmap
    self.bitmap = Cache.character(@character_name)
    sign = @character_name[/^[\!\$]./]
    if sign && sign.include?('$')
      @cw = bitmap.width / 3
      @ch = bitmap.height / 4
    else
      @cw = bitmap.width / 12
      @ch = bitmap.height / 8
    end
    self.ox = @cw / 2
    self.oy = @ch
  end
  #--------------------------------------------------------------------------
  # * 전송 원점 사각형 업데이트
  #--------------------------------------------------------------------------
  def update_src_rect
    if @tile_id == 0 and @character.character_index != nil # 22.08.27 추가
      index = @character.character_index
      pattern = @character.pattern < 3 ? @character.pattern : 1
      sx = (index % 4 * 3 + pattern) * @cw
      sy = (index / 4 * 4 + (@character.direction - 2) / 2) * @ch
      self.src_rect.set(sx, sy, @cw, @ch)
    end
  end
  #--------------------------------------------------------------------------
  # * Update Position
  #--------------------------------------------------------------------------
  def update_position
    move_animation(@character.screen_x - x, @character.screen_y - y)
    self.x = @character.screen_x
    self.y = @character.screen_y
    self.z = @character.screen_z
  end
  #--------------------------------------------------------------------------
  # * Update Other
  #--------------------------------------------------------------------------
  def update_other
    self.opacity = @character.opacity
    self.blend_type = @character.blend_type
    self.bush_depth = @character.bush_depth
    self.visible = !@character.transparent
  end
  #--------------------------------------------------------------------------
  # * Set New Effect
  #--------------------------------------------------------------------------
  def setup_new_effect
    if !animation? && @character.animation_id > 0
      animation = $data_animations[@character.animation_id]
      start_animation(animation)
    end
    if !@balloon_sprite && @character.balloon_id > 0
      @balloon_id = @character.balloon_id
      start_balloon
    end
  end
  #--------------------------------------------------------------------------
  # * Move Animation
  #--------------------------------------------------------------------------
  def move_animation(dx, dy)
    if @animation && @animation.position != 3
      @ani_ox += dx
      @ani_oy += dy
      @ani_sprites.each do |sprite|
        sprite.x += dx
        sprite.y += dy
      end
    end
  end
  #--------------------------------------------------------------------------
  # * End Animation
  #--------------------------------------------------------------------------
  def end_animation
    super
    @character.animation_id = 0
  end
  #--------------------------------------------------------------------------
  # * Start Balloon Icon Display
  #--------------------------------------------------------------------------
  def start_balloon
    dispose_balloon
    @balloon_duration = 8 * balloon_speed + balloon_wait
    @balloon_sprite = ::Sprite.new(viewport)
    #@balloon_sprite.bitmap = Cache.system("Balloon")
    case @balloon_id
      when 1..5
        @balloon_sprite.bitmap = Cache.system("Balloon(1-5)")
        @balloon_no = 1
      when 6..10
        @balloon_sprite.bitmap = Cache.system("Balloon(6-10)")
        @balloon_no = 6
        @balloon_id -= 5
      when 11..15
        @balloon_sprite.bitmap = Cache.system("Balloon(11-15)")
        @balloon_no = 11
        @balloon_id -= 10
      when 16..20
        @balloon_sprite.bitmap = Cache.system("Balloon(16-20)")
        @balloon_no = 16
        @balloon_id -= 15
      when 21..25
        @balloon_sprite.bitmap = Cache.system("Balloon(21-25)")
        @balloon_no = 21
        @balloon_id -= 20
      when 26..30
        @balloon_sprite.bitmap = Cache.system("Balloon(26-30)")
        @balloon_no = 26
        @balloon_id -= 25
    end
    @balloon_sprite.ox = 16
    @balloon_sprite.oy = 32
    update_balloon
  end
  #--------------------------------------------------------------------------
  # * Free Balloon Icon
  #--------------------------------------------------------------------------
  def dispose_balloon
    if @balloon_sprite
      @balloon_sprite.dispose
      @balloon_sprite = nil
    end
  end
  #--------------------------------------------------------------------------
  # * Update Balloon Icon
  #--------------------------------------------------------------------------
  def update_balloon
    if @balloon_duration > 0
      @balloon_duration -= 1
      if @balloon_duration > 0
        if @balloon_sprite != nil
          @balloon_sprite.x = x
          @balloon_sprite.y = y - (self.oy/2)
          @balloon_sprite.z = z + 200
          # Alog https://arca.live/b/alog
          #if @balloon_no == 16
          #  if @balloon_id == 4
          #    @balloon_sprite.y = y
          #  end
          #elsif @balloon_no == 21
          if @balloon_no == 21
            if @balloon_id == 1 or @balloon_id == 3
              if self.oy > 64
                @balloon_sprite.y = y - (self.oy/4)
              else
                @balloon_sprite.y = y
              end
            end
          elsif @balloon_no == 26
            if @balloon_id == 2 or @balloon_id == 5
              if self.oy > 64
                @balloon_sprite.y = y - (self.oy/4)
              else
                @balloon_sprite.y = y
              end
            end
          end
          sx = balloon_frame_index * 32
          sy = (@balloon_id - 1) * 32
          @balloon_sprite.src_rect.set(sx, sy, 32, 32)
        else
          end_balloon
        end
      else
        end_balloon
      end
    end
  end
  #--------------------------------------------------------------------------
  # * End Balloon Icon
  #--------------------------------------------------------------------------
  def end_balloon
    dispose_balloon
    @character.balloon_id = 0
  end
  #--------------------------------------------------------------------------
  # * Balloon Icon Display Speed
  #--------------------------------------------------------------------------
  def balloon_speed
    # Alog https://arca.live/b/alog
    # 이모티콘 스피드 실험
    #return 8
    return 3
  end
  #--------------------------------------------------------------------------
  # * Wait Time for Last Frame of Balloon
  #--------------------------------------------------------------------------
  def balloon_wait
    # Alog https://arca.live/b/alog
    # 이모티콘 스피드 실험
    #return 12
    return 24
  end
  #--------------------------------------------------------------------------
  # * Frame Number of Balloon Icon
  #--------------------------------------------------------------------------
  def balloon_frame_index
    return 7 - [(@balloon_duration - balloon_wait) / balloon_speed, 0].max
  end
end