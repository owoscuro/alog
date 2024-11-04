# encoding: utf-8
# Name: 999.Pixel Movement (WIP)
# Size: 9509
=begin
#===============================================================================
 Title: Pixel Movement (WIP)
 Author: Hime
 Date: Oct 6, 2014
--------------------------------------------------------------------------------
 ** Change log
 Oct 6, 2014
   - improved collision checks for events so they can't walk into the player
   - added support for event interaction
 Oct 5, 2014
   - added support for map movement collision detection
 Sep 20, 2014
   - Initial release
--------------------------------------------------------------------------------   
 ** Terms of Use
 * Free to use in non-commercial projects
 * Contact me for commercial use
 * No real support. The script is provided as-is
 * Will do bug fixes, but no compatibility patches
 * Features may be requested but no guarantees, especially if it is non-trivial
 * Credits to Hime Works in your project
 * Preserve this header
--------------------------------------------------------------------------------
 ** Description
 
 This script allows you to implement pixel movement in your game. 
 
--------------------------------------------------------------------------------
 ** Installation
 
 Place this script below Materials and above Main

--------------------------------------------------------------------------------
 ** Usage 
 
 Plug and play.
 
 You can choose how many pixels are passed for each step you take in the
 configuration.
 
#===============================================================================
=end
=begin
$imported = {} if $imported.nil?
$imported["TH_PartyCommandManager"] = true
#===============================================================================
# Configuration
#===============================================================================
module TH
  module Pixel_Movement
    
    # Number of pixels you move per step. This is the size of the movement grid
    # The size of each tile is 32x32. You should use a size that evenly divides
    # into 32, such as 2, 4, 8, or 16.
    Pixels_Per_Step = 4
#===============================================================================
# Rest of Script
#===============================================================================
    Tiles_Per_Step = Pixels_Per_Step / 32.0
  end
end

class Game_Map
  include TH::Pixel_Movement

  alias :tile_x_with_direction :x_with_direction
  def x_with_direction(x, d)
    x + (d == 6 ? Tiles_Per_Step : d == 4 ? -Tiles_Per_Step : 0)
  end

  alias :tile_y_with_direction :y_with_direction
  def y_with_direction(y, d)
    y + (d == 2 ? Tiles_Per_Step : d == 8 ? -Tiles_Per_Step : 0)
  end

  alias :round_tile_x_with_direction :round_x_with_direction
  def round_x_with_direction(x, d)
    round_x(x + (d == 6 ? Tiles_Per_Step : d == 4 ? -Tiles_Per_Step : 0))
  end

  alias :round_tile_y_with_direction :round_y_with_direction
  def round_y_with_direction(y, d)
    round_y(y + (d == 2 ? Tiles_Per_Step : d == 8 ? -Tiles_Per_Step : 0))
  end
  
  #-----------------------------------------------------------------------------
  # Overwrite.
  # 포인트 주변 지역의 모든 이벤트를 반환합니다.
  #-----------------------------------------------------------------------------
  def events_xy(x, y)
    @events.values.select {|event| event.pos_area?(x, y)} 
  end

  #-----------------------------------------------------------------------------
  # 추가
  #-----------------------------------------------------------------------------
  def passable2?(x, y, d)
    if d == 2
      events_xy_nt_b(x, y + Tiles_Per_Step).count == 0
    elsif d == 8
      events_xy_nt_b(x, y - Tiles_Per_Step).count == 0
    elsif d == 4
      events_xy_nt_b(x - Tiles_Per_Step, y).count == 0
    elsif d == 6
      events_xy_nt_b(x + Tiles_Per_Step, y).count == 0
    end
  end
  
  def events_xy_nt_b(x, y)
    @events.values.select {|event| event.pos_area_nt?(x, y)}
    #@events.values.select {|event| event.pos_area_nt?(x, y) and !event.enemy_ready?}
  end
  
  #-----------------------------------------------------------------------------
  # Overwrite.
  # 포인트 주변 지역의 모든 non-through 이벤트를 반환합니다.
  #-----------------------------------------------------------------------------
  def events_xy_nt(x, y)
    @events.values.select {|event| event.pos_area_nt?(x, y)}
  end
end

class Game_CharacterBase
  include TH::Pixel_Movement
  
  #-----------------------------------------------------------------------------
  # 스프라이트 주변의 4개 지점을 확인합니다, 충돌 상자가 약간 더 작다고 가정합니다.
  # 32 x 32보다
  #-----------------------------------------------------------------------------
  def map_passable?(x, y, d)
    delta = Tiles_Per_Step * 1.5
    x_lo = x + delta
    y_lo = y + delta
    x_hi = x + 1 - delta
    y_hi = y + 1 - delta
    return false unless $game_map.passable?(x_lo, y_lo, d)
    return false unless $game_map.passable?(x_lo, y_hi, d)
    return false unless $game_map.passable?(x_hi, y_lo, d)
    return false unless $game_map.passable?(x_hi, y_hi, d)
    return true
  end
  
  #-----------------------------------------------------------------------------
  # New.
  # 현재 지점 주변의 사각형을 확인합니다, 면적은 타일 크기와 같습니다.
  #-----------------------------------------------------------------------------
  def pos_area?(x, y)
    x_lo = @x - 0.5
    y_lo = @y - 0.5
    x_hi = @x + 0.5
    y_hi = @y + 0.5
    x >= x_lo && x <= x_hi && y >= y_lo && y <= y_hi
  end
  
  #-----------------------------------------------------------------------------
  # New.
  # pos_area 및 no-through
  #-----------------------------------------------------------------------------
  def pos_area_nt?(x, y)
    !@through && pos_area?(x, y)
  end
  
  #-----------------------------------------------------------------------------
  # 상자를 사용하여 타일이 카운터 타일인지 확인하십시오.
  #-----------------------------------------------------------------------------
  def counter_tile_area?(x, y)
    delta = Tiles_Per_Step * 2
    x_lo = x + delta
    y_lo = y + delta
    x_hi = x + 1 - delta
    y_hi = y + 1 - delta
    return true if $game_map.counter?(x_lo, y_lo)
    return true if $game_map.counter?(x_lo, y_hi)
    return true if $game_map.counter?(x_hi, y_lo)
    return true if $game_map.counter?(x_hi, y_hi)
    return false
  end
end

class Game_Player < Game_Character
  include TH::Pixel_Movement
  #-----------------------------------------------------------------------------
  # Overwrite.
  # Use tile-based coordinate system to check across the counter
  #-----------------------------------------------------------------------------
  def check_event_trigger_there(triggers)
    x2 = $game_map.round_x_with_direction(@x, @direction)
    y2 = $game_map.round_y_with_direction(@y, @direction)
    start_map_event(x2, y2, triggers, true)
    return if $game_map.any_event_starting?
    return unless counter_tile_area?(x2, y2)    
    x3 = $game_map.round_tile_x_with_direction(x2, @direction)
    y3 = $game_map.round_tile_y_with_direction(y2, @direction)
    
    # offset due to sprite origin being in the center, not corner
    x3 += @direction == 6 ? 0.5 : @direction == 4 ? -0.5 : 0
    y3 += @direction == 2 ? 0.5 : @direction == 8 ? -0.5 : 0
    start_map_event(x3, y3, triggers, true)
  end
  
  def update
    last_real_x = @real_x
    last_real_y = @real_y
    last_moving = moving?
    move_by_input
    super
    update_scroll(last_real_x, last_real_y)
    update_vehicle
    update_nonmoving(last_moving) unless moving?
    @followers.update
  end
end

class Game_Event < Game_Character

  #-----------------------------------------------------------------------------
  # 덮어쓰기, 이벤트는 자신과 충돌할 수 없습니다.
  #-----------------------------------------------------------------------------
  def collide_with_events?(x, y)
    $game_map.events_xy_nt(x, y).any? do |event|
      event != self && (event.normal_priority? || self.is_a?(Game_Event))
    end
  end
  
  #-----------------------------------------------------------------------------
  # 별명, 지금 플레이어와의 충돌을 확인해야 함
  #-----------------------------------------------------------------------------
  alias :th_pixel_movement_collide_with_characters? :collide_with_characters?
  def collide_with_characters?(x, y)
    collide_with_player?(x,y) || th_pixel_movement_collide_with_characters?(x, y)
  end
  
  #-----------------------------------------------------------------------------
  # New.
  #-----------------------------------------------------------------------------
  def collide_with_player?(x, y)
    $game_player.pos_area?(x, y)
  end
  
  #-----------------------------------------------------------------------------
  # 덮어쓰기, 터치 여부를 결정하기 위해 플레이어 주변 영역을 확인하십시오.
  #-----------------------------------------------------------------------------
  def check_event_trigger_touch(x, y)
    return if $game_map.interpreter.running?
    if @trigger == 2 && $game_player.pos_area?(x, y)
      start if !jumping? && normal_priority?
    end
  end
end
=end