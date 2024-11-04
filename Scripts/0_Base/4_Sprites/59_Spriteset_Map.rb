# encoding: utf-8
# Name: Spriteset_Map
# Size: 13339
#==============================================================================
# ** Spriteset_Map
#------------------------------------------------------------------------------
#  This class brings together map screen sprites, tilemaps, etc. It's used
# within the Scene_Map class.
#==============================================================================

class Spriteset_Map
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    create_viewports
    create_tilemap
    create_parallax
    create_characters
    # Alog https://arca.live/b/alog
    #create_shadow
    create_weather
    create_pictures
    @load_ro_map_3 = 0
    # Alog https://arca.live/b/alog
    create_timer
    #print("Spriteset_Map - 타일셋 반투명 갱신 \n");
    update
  end
  #--------------------------------------------------------------------------
  # * Create Viewport
  #--------------------------------------------------------------------------
  def create_viewports
    @viewport1 = Viewport.new
    @viewport2 = Viewport.new
    @viewport3 = Viewport.new
    @viewport2.z = 50
    @viewport3.z = 100
  end
  #--------------------------------------------------------------------------
  # * Create Tilemap
  #--------------------------------------------------------------------------
  def create_tilemap
    @tilemap = Tilemap.new(@viewport1)
    @tilemap.map_data = $game_map.data
    load_tileset
    #if $game_variables[156] != $game_map.map_id
    #end
  end
  #--------------------------------------------------------------------------
  # * Load Tileset
  #--------------------------------------------------------------------------
  def load_tileset
    #print("Spriteset_Map - 타일셋 생성 진행중 \n");
    @load_ro_map_3 = 1
    #return if $game_variables[33] == $game_map.map_id
    # Alog https://arca.live/b/alog
    # 맵 타일셋 이미지 변환 실험
    @tileset = $game_map.tileset
    @tileset.tileset_names.each_with_index do |name, i|
      @load_ro_map_name = nil
      # 내부 조명 변경
      if name == "TileE_interior1"
        case $game_variables[6]
        when 0..4
          @tilemap.bitmaps[i] = Cache.tileset(name + '_3')
        when 5..7
          @tilemap.bitmaps[i] = Cache.tileset(name)
        when 8..18
          @tilemap.bitmaps[i] = Cache.tileset(name + '_2')
        when 19..24
          @tilemap.bitmaps[i] = Cache.tileset(name + '_4')
        end
      elsif name != "" and $game_switches[34] == false
        # 필드 계절 변경
        if $game_variables[23] == 1
          @load_ro_map_name = Cache.tileset(name + '_Autumn') rescue nil
        elsif $game_variables[23] == 2
          @load_ro_map_name = Cache.tileset(name + '_Winter') rescue nil
        else
          @load_ro_map_name = Cache.tileset(name)
        end
      elsif name != "" and $game_switches[34] == true
        # 필드 계절 변경
        if $game_variables[23] == 1
          @load_ro_map_name = Cache.tileset(name + '_Autumn_r50') rescue nil
          @load_ro_map_name = Cache.tileset(name + '_Autumn') rescue nil if @load_ro_map_name == nil
        elsif $game_variables[23] == 2
          @load_ro_map_name = Cache.tileset(name + '_Winter_r50') rescue nil
          @load_ro_map_name = Cache.tileset(name + '_Winter') rescue nil if @load_ro_map_name == nil
        else
          @load_ro_map_name = Cache.tileset(name + '_r50') rescue nil
          @load_ro_map_name = Cache.tileset(name) if @load_ro_map_name == nil
        end
      end
      if @load_ro_map_name != nil
        #print("Spriteset_Map - 업데이트 타일셋 100, %s \n" % [@load_ro_map_name]);
        @tilemap.bitmaps[i] = @load_ro_map_name
      else
        #print("Spriteset_Map - 업데이트 타일셋 50, %s \n" % [name]);
        @tilemap.bitmaps[i] = Cache.tileset(name)
      end
    end
    @load_ro_map_3 = 0
    @tilemap.flags = @tileset.flags
    # 갱신 취소 실험
    #$game_variables[156] = $game_map.map_id
    #$game_variables[33] = $game_map.map_id
  end
  #--------------------------------------------------------------------------
  # * Create Parallax
  #--------------------------------------------------------------------------
  def create_parallax
    @parallax = Plane.new(@viewport1)
    @parallax.z = -100
  end
  #--------------------------------------------------------------------------
  # * Create Character Sprite
  #--------------------------------------------------------------------------
  def create_characters
    #print("Spriteset_Map - 캐릭터 갱신 \n");
    @character_sprites = []
    $game_map.events.values.each do |event|
      @character_sprites.push(Sprite_Character.new(@viewport1, event))
    end
    $game_map.vehicles.each do |vehicle|
      @character_sprites.push(Sprite_Character.new(@viewport1, vehicle))
    end
    $game_player.followers.reverse_each do |follower|
      @character_sprites.push(Sprite_Character.new(@viewport1, follower))
    end
    @character_sprites.push(Sprite_Character.new(@viewport1, $game_player))
    @map_id = $game_map.map_id
  end
  #--------------------------------------------------------------------------
  # * Create Weather
  #--------------------------------------------------------------------------
  def create_weather
    @weather = Spriteset_Weather.new(@viewport2)
  end
  #--------------------------------------------------------------------------
  # * Create Picture Sprite
  #--------------------------------------------------------------------------
  def create_pictures
    @picture_sprites = []
  end
  #--------------------------------------------------------------------------
  # * Create Timer Sprite
  #--------------------------------------------------------------------------
  def create_timer
    @timer_sprite = Sprite_Timer.new(@viewport2)
  end
  #--------------------------------------------------------------------------
  # * Free
  #--------------------------------------------------------------------------
  def dispose
    dispose_tilemap # 주석 처리시 타겟 설정 후 오류 발생
    dispose_parallax
    dispose_characters
    # Alog https://arca.live/b/alog
    #dispose_shadow
    dispose_weather
    dispose_pictures
    # Alog https://arca.live/b/alog
    dispose_timer
    dispose_viewports
  end
  #--------------------------------------------------------------------------
  # * Free Tilemap
  #--------------------------------------------------------------------------
  def dispose_tilemap
    @tilemap.dispose
  end
  #--------------------------------------------------------------------------
  # * Free Parallax
  #--------------------------------------------------------------------------
  def dispose_parallax
    @parallax.bitmap.dispose if @parallax.bitmap
    @parallax.dispose
  end
  #--------------------------------------------------------------------------
  # * Free Character Sprite
  #--------------------------------------------------------------------------
  def dispose_characters
    @character_sprites.each {|sprite| sprite.dispose }
  end
  #--------------------------------------------------------------------------
  # * Free Airship Shadow Sprite
  #--------------------------------------------------------------------------
  #def dispose_shadow
  #  @shadow_sprite.dispose
  #end
  #--------------------------------------------------------------------------
  # * Free Weather
  #--------------------------------------------------------------------------
  def dispose_weather
    @weather.dispose
  end
  #--------------------------------------------------------------------------
  # * Free Picture Sprite
  #--------------------------------------------------------------------------
  def dispose_pictures
    @picture_sprites.compact.each {|sprite| sprite.dispose }
  end
  #--------------------------------------------------------------------------
  # * Free Timer Sprite
  #--------------------------------------------------------------------------
  def dispose_timer
    @timer_sprite.dispose
  end
  #--------------------------------------------------------------------------
  # * Free Viewport
  #--------------------------------------------------------------------------
  def dispose_viewports
    @viewport1.dispose
    @viewport2.dispose
    @viewport3.dispose
  end
  #--------------------------------------------------------------------------
  # * Refresh Characters
  #--------------------------------------------------------------------------
  def refresh_characters
    dispose_characters
    create_characters
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    if @load_ro_map_3 == 0 and @tileset != $game_map.tileset
      #if $game_variables[33] != $game_map.map_id
      update_tileset
    end
    update_tilemap
    update_parallax
    update_characters
    # Alog https://arca.live/b/alog
    #update_shadow
    update_weather
    update_pictures
    update_timer
    update_viewports
  end
  #--------------------------------------------------------------------------
  # * Update Tileset
  #--------------------------------------------------------------------------
  def update_tileset
    #print("Spriteset_Map - 업데이트 타일셋 \n");
    # 0.0.90 ver
    if @tileset != $game_map.tileset
      #print("Spriteset_Map - load_tileset, refresh_characters \n");
      load_tileset
      refresh_characters
    end
    #load_tileset # 0.1.54
  end
  #--------------------------------------------------------------------------
  # * Update Tilemap
  #--------------------------------------------------------------------------
  def update_tilemap
    #@tilemap.map_data = $game_map.data
    #@tilemap.ox = $game_map.display_x * 32
    #@tilemap.oy = $game_map.display_y * 32
    #@tilemap.update
    @tilemap.map_data = $game_map.data
    @tilemap.ox = $game_map.display_x * 32
    @tilemap.oy = $game_map.display_y * 32
    @tilemap.ox += 1 if $game_map.adjust_tile_slide_x
    @tilemap.oy += 1 if $game_map.adjust_tile_slide_y
    @tilemap.update
  end
  #--------------------------------------------------------------------------
  # * Update Parallax
  #--------------------------------------------------------------------------
  def update_parallax
    if @parallax_name != $game_map.parallax_name
      @parallax_name = $game_map.parallax_name
      @parallax.bitmap.dispose if @parallax.bitmap
      @parallax.bitmap = Cache.parallax(@parallax_name)
      Graphics.frame_reset
    end
    # Alog https://arca.live/b/alog
    # 수정
    @parallax.ox = $game_map.display_x * 32
    @parallax.oy = $game_map.display_y * 32
    #@parallax.ox = $game_map.parallax_ox(@parallax.bitmap)
    #@parallax.oy = $game_map.parallax_oy(@parallax.bitmap)
  end
  #--------------------------------------------------------------------------
  # * Update Character Sprite
  #--------------------------------------------------------------------------
  def update_characters
    refresh_characters if @map_id != $game_map.map_id
    @character_sprites.each {|sprite| sprite.update }
  end
  #--------------------------------------------------------------------------
  # * Update Weather
  #--------------------------------------------------------------------------
  def update_weather
    @weather.type = $game_map.screen.weather_type
    @weather.power = $game_map.screen.weather_power
    @weather.ox = $game_map.display_x * 32
    @weather.oy = $game_map.display_y * 32
    @weather.update
  end
  #--------------------------------------------------------------------------
  # *Update Picture Sprite
  #--------------------------------------------------------------------------
  def update_pictures
    $game_map.screen.pictures.each do |pic|
      @picture_sprites[pic.number] ||= Sprite_Picture.new(@viewport2, pic)
      @picture_sprites[pic.number].update
    end
  end
  #--------------------------------------------------------------------------
  # * Update Timer Sprite
  #--------------------------------------------------------------------------
  def update_timer
    # Alog https://arca.live/b/alog
    # 내용 추가
  	return if @timer_sprite == nil
    @timer_sprite.update
  end
  #--------------------------------------------------------------------------
  # * Update Viewport
  #--------------------------------------------------------------------------
  def update_viewports
    @viewport1.tone.set($game_map.screen.tone)
    @viewport1.ox = $game_map.screen.shake
    #print("Spriteset_Map - %s, %s \n" % [@viewport1.width, @viewport1.height]);
    @viewport2.color.set($game_map.screen.flash_color)
    @viewport3.color.set(0, 0, 0, 255 - $game_map.screen.brightness)
    @viewport1.update
    @viewport2.update
    @viewport3.update
  end
end