# encoding: utf-8
# Name: 123.Game_Player
# Size: 11213
class Game_Player < Game_Character
  attr_accessor :ms_speed_trail_previous
  alias_method(:ms_speed_trail_original_update, :update)
  def update
    # Original method.
    ms_speed_trail_original_update
    # If the effect is automatically active for player dashing.
    if MakerSystems::SpeedTrail::PLAYER_DASH_AUTOST
      print("123.Game_Player - update \n");
      # Player dashing?
      if dash?
        if @ms_speed_trail_enable && !@ms_speed_trail_enable_from_dashing
          @ms_speed_trail_previous ||= [@ms_speed_trail_rhythm,
          @ms_speed_trail_delay, @ms_speed_trail_blend_type,
          @ms_speed_trail_opacity, @ms_speed_trail_color,
          @ms_speed_trail_wave_amp, @ms_speed_trail_wave_length,
          @ms_speed_trail_wave_speed, @ms_speed_trail_blur_level,
          @ms_speed_trail_limit]
        end
        # Shortcut to Speed Trail module.
        ms_speed_trail = MakerSystems::SpeedTrail
        # Set up the effect using Player values.
        @ms_speed_trail_rhythm      = ms_speed_trail::PLAYER_DASH_RHYTHM
        @ms_speed_trail_delay       = ms_speed_trail::PLAYER_DASH_SPAWNDELAY
        @ms_speed_trail_blend_type  = ms_speed_trail::PLAYER_DASH_BLENDTYPE
        @ms_speed_trail_opacity     = ms_speed_trail::PLAYER_DASH_OPACITY
        @ms_speed_trail_color       = ms_speed_trail::PLAYER_DASH_COLOR
        @ms_speed_trail_wave_amp    = ms_speed_trail::PLAYER_DASH_WAVE_AMP
        @ms_speed_trail_wave_length = ms_speed_trail::PLAYER_DASH_WAVE_LENGTH
        @ms_speed_trail_wave_speed  = ms_speed_trail::PLAYER_DASH_WAVE_SPEED
        @ms_speed_trail_blur_level  = ms_speed_trail::PLAYER_DASH_BLUR_LEVEL
        @ms_speed_trail_limit       = ms_speed_trail::PLAYER_DASH_SIZE_LIMIT
        # Effect ready flag.
        @ms_speed_trail_enable = true
        @ms_speed_trail_enable_from_dashing = true
      else
        if @ms_speed_trail_enable_from_dashing
          @ms_speed_trail_enable_from_dashing = nil
          if @ms_speed_trail_previous
            # Restores previous effect.
            @ms_speed_trail_rhythm, @ms_speed_trail_delay,
            @ms_speed_trail_blend_type, @ms_speed_trail_opacity,
            @ms_speed_trail_color, @ms_speed_trail_wave_amp,
            @ms_speed_trail_wave_length, @ms_speed_trail_wave_speed,
            @ms_speed_trail_blur_level, @ms_speed_trail_limit =
            *@ms_speed_trail_previous
            @ms_speed_trail_previous = nil
          else
            # Cancels the effect and clears its information.
            @ms_speed_trail_enable = nil
            @ms_speed_trail_delay = @ms_speed_trail_rhythm =
            @ms_speed_trail_blend_type = @ms_speed_trail_opacity =
            @ms_speed_trail_color = @ms_speed_trail_wave_amp = 
            @ms_speed_trail_wave_length = @ms_speed_trail_wave_speed =
            @ms_speed_trail_blur_level = @ms_speed_trail_limit = nil
          end
        end
      end
    end
  end
end

class MS_SpeedTrail_Sprite < Sprite
  def initialize(parent)
    # Superclass method.
    super(parent.viewport)
    # Get parent character.
    character = parent.character
    # Get parent Sprite rect.
    rect  = parent.src_rect
    # Get parent character shift_y.
    shift = character.shift_y
    # Get parent character jump_height.
    jump  = character.jump_height
    # Set up target X & target Y.
    @target_x = $game_map.display_x * 32 + parent.x
    @target_y = $game_map.display_y * 32 + parent.y
    # Set up Offset X & Offset Y.
    self.ox = parent.ox
    self.oy = parent.oy
    # Opacity value.
    transparency = character.ms_speed_trail_opacity
    # If transparency value represents a percentage.
    if transparency < 1.0
      # Set opacity according to percentage given.
      @target_opacity = parent.opacity * transparency
    else
      # Set opacity according to desired value.
      @target_opacity = transparency
    end
    # Step value.
    @target_step = @target_opacity.to_f / character.ms_speed_trail_delay.to_f
    # Z order.
    self.z = character.direction == 8 ? parent.z + 1 : parent.z - 1
    # Set up X & Y position.
    self.x = -$game_map.display_x * 32 + @target_x
    self.y = -$game_map.display_y * 32 + @target_y
    # Set up desired blend type.
    self.blend_type = parent.character.ms_speed_trail_blend_type
    # Set up opacity.
    self.opacity = @target_opacity
    # Set up bitmap for correct character pose.
    self.bitmap = Bitmap.new(rect.width, rect.height)
    self.bitmap.blt(0, 0, parent.bitmap, rect)
    # Apply blur if needed.
    if character.ms_speed_trail_blur_level
      character.ms_speed_trail_blur_level.times { self.bitmap.blur }
    end
    # Set up wave effect if needed.
    if character.ms_speed_trail_wave_amp
      self.wave_amp    = character.ms_speed_trail_wave_amp
      self.wave_length = character.ms_speed_trail_wave_length
      self.wave_speed  = character.ms_speed_trail_wave_speed
    end
    # Set up Sprite color if needed.
    if parent.character.ms_speed_trail_color
      self.color = character.ms_speed_trail_color
    end
  end
  
  def update
    # Superclass method.
    super
    # Updates X & Y position.
    self.x = -$game_map.display_x * 32 + @target_x
    self.y = -$game_map.display_y * 32 + @target_y
    # Updates opacity and returns vital signs.
    self.opacity -= @target_step
    self.opacity > 0
  end
end

class Sprite_Character < Sprite_Base
  alias_method(:ms_speed_trail_original_update, :update)
  def update
    # Original method.
    ms_speed_trail_original_update
    # If child sprites exists.
    if @ms_speed_trail_sprites
      # Iterate through each Speed Trail Sprite.
      @ms_speed_trail_sprites.each do |sprite|
        # Update and check vitality.
        unless sprite.update
          # Dispose Bitmap and Sprite when dead.
          sprite.bitmap.dispose
          sprite.dispose
          # Remove from array.
          @ms_speed_trail_sprites.delete(sprite)
        end
      end
    end
    # If the effect is enabled.
    if @character.ms_speed_trail_enable
      # Unless there is already a Sprite container.
      unless @ms_speed_trail_sprites
        # Create Speed Trail if moving.
        if @character.moving?
          @ms_speed_trail_sprites = [MS_SpeedTrail_Sprite.new(self)] 
        end
        # Save this position for future reference.
        @ms_speed_trail_last_x = @character.real_x
        @ms_speed_trail_last_y = @character.real_y
        # Set up spawn rate.
        @ms_speed_trail_spawn_rate = @character.ms_speed_trail_rhythm
      end
      # Update rate.
      @ms_speed_trail_spawn_rate -= 1
      # Correct rate if needed.
      if @ms_speed_trail_spawn_rate < 0
        @ms_speed_trail_spawn_rate = 0 
      end
      # If time is up.
      if @ms_speed_trail_spawn_rate == 0
        # If character moved.
        if @character.real_x != @ms_speed_trail_last_x ||
           @character.real_y != @ms_speed_trail_last_y
          # Custom limit?
          if @character.ms_speed_trail_limit
            limit = @character.ms_speed_trail_limit
          else
            # Default limit.
            limit = MakerSystems::SpeedTrail::SIZE_LIMIT
          end
          # If trail is smaller than limit.
          if @ms_speed_trail_sprites.size < limit
            # Create Speed Trail if visible.
            if self.visible
              @ms_speed_trail_sprites << MS_SpeedTrail_Sprite.new(self) 
            end
          end
          # Save this position for future reference.
          @ms_speed_trail_last_x = @character.real_x
          @ms_speed_trail_last_y = @character.real_y
          # Reset spawn rate.
          @ms_speed_trail_spawn_rate = @character.ms_speed_trail_rhythm
        end
      end
    else
      # Speed Trail container?
      if @ms_speed_trail_sprites && @ms_speed_trail_sprites.empty?
        # Clear container.
        @ms_speed_trail_sprites.clear
        # Clear used variables.
        @ms_speed_trail_sprites = @ms_speed_trail_last_x =
        @ms_speed_trail_last_y = @ms_speed_trail_spawn_rate = nil
      end
    end
  end
  
  alias_method(:ms_speed_trail_original_dispose, :dispose)
  def dispose
    # Original method.
    ms_speed_trail_original_dispose
    # Dispose existing trail Sprites.
    if @ms_speed_trail_sprites
      @ms_speed_trail_sprites.each do |sprite| 
        sprite.bitmap.dispose
        sprite.dispose
      end
    end
  end
end

  #--------------------------------------------------------------------------
  # * Start Speed Trail.                                                [NEW]
  #--------------------------------------------------------------------------
  def ms_start_speed_trail(id, rhythm, delay, blend_type = 1, opacity = 0.9,
                           color = nil, wave_amp = nil, wave_length = nil,
                           wave_speed = nil, ms_speed_trail_blur_level = nil,
                           limit = nil)
    # Get character based on id.
    character = id == 0 ? $game_player : $game_map.events[id]
    #character = $game_map.events[id]
    # Color object generation.
    if color
      if color.include?('#')
        color = color.delete!('#').scan(/../).map { |c| c.to_i(16) }
      else
        color = color.split(' ').map { |c| c.to_i }
      end
      color = Color.new(*color)
    end
    # Default value correction.
    blend_type = 1   unless blend_type
    opacity    = 0.9 unless opacity
    # Set up basic effect information.
    character.ms_speed_trail_rhythm      = rhythm
    character.ms_speed_trail_delay       = delay
    character.ms_speed_trail_blend_type  = blend_type
    character.ms_speed_trail_opacity     = opacity
    character.ms_speed_trail_wave_amp    = wave_amp
    character.ms_speed_trail_wave_length = wave_length
    character.ms_speed_trail_wave_speed  = wave_speed
    character.ms_speed_trail_blur_level  = ms_speed_trail_blur_level
    character.ms_speed_trail_limit       = limit
    character.ms_speed_trail_color       = color
    # Effect enabled.
    character.ms_speed_trail_enable = true
  end
  
  #--------------------------------------------------------------------------
  # * Stop Speed Trail.                                                 [NEW]
  #--------------------------------------------------------------------------
  def ms_stop_speed_trail(id)
    # Get character based on id.
    character = id == 0 ? $game_player : $game_map.events[id]
    #character = $game_map.events[id]
    # Effect disabled.
    character.ms_speed_trail_enable = false
    # Clears effect information.
    character.ms_speed_trail_rhythm = character.ms_speed_trail_delay =
    character.ms_speed_trail_blend_type = character.ms_speed_trail_opacity =
    character.ms_speed_trail_wave_amp = character.ms_speed_trail_wave_length =
    character.ms_speed_trail_wave_speed = character.ms_speed_trail_blur_level =
    character.ms_speed_trail_limit = character.ms_speed_trail_color = nil
  end