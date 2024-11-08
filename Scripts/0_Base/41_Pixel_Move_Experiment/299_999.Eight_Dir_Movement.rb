# encoding: utf-8
# Name: 999.Eight_Dir_Movement
# Size: 10328
=begin
#===============================================================================
 Title: Eight-Directional Movement
 Author: Hime
 Date: Feb 19, 2015
--------------------------------------------------------------------------------
 ** Change log
 Feb 19, 2015
   - removed distance per frame mod
 Dec 29, 2014
   - added a switch that allows you to enable 8-dir movement during the game
 Nov 3, 2014 
   - fixed followers chasing too slow when you move diagonally too quickly
 Nov 1, 2014 
   - Initial Release
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
 
 By default, the game only allows you to move in the four orthogonal
 directions: up, left, down, right.
 
 This script provides support for eight-directional movement in your game.
 Eight-directional movement adds support for diagonal movement. To move
 diagonally, hold down two direction keys simultaneously.
 
 This script also adds support for eight-directional character sprites, 
 allowing you to face the appropriate direction when you are moving
 diagonally.
 
 You do not need diagonal sprites to use this script. 

--------------------------------------------------------------------------------
 ** Installation
 
 In the script editor, place this script below Materials and above Main
 
--------------------------------------------------------------------------------
 ** Usage
 
 In the configuration, you can choose whether you want to use diagonal sprites
 or not. If you don't use them, then you can still walk around diagonally, but
 the sprites will be facing one of the orthogonal directions.
 
 Diagonal sprites require you to follow a specific sprite-sheet format.
 It assumes you are using the default 3x4 character format on a 384x256
 character sheets. If you are using VX style character sheets, resize
 them to 384x256.
 
 A full character sheet for one character consists of the orthogonal directions
 as well as the diagonal directions. You will first place your orthogonal
 sprites onto the sheet, and then right beside it, place your diagonal sprites.
 
 The sprite directions should be as follows
 
 ------------------------
 |  down   | down-left  |
 |  left   | up-left    |
 |  right  | down-right |
 |  up     | up-right   |
 ------------------------
 
 This means that you can have up to 4 characters per sheet.
 
 -- Enable Switch --
 
 In the configuration, you can choose a specific switch to use to determine
 whether 8-dir movement is enabled. When the switch is ON, 8-dir movement is
 enabled. If the switch if OFF, then 8-dir movement is disabled.
 
#===============================================================================
=end
=begin
$imported = {} if $imported.nil?
$imported[:TH_EightDirMovement] = true
#===============================================================================
# ** Configuration
#===============================================================================
module TH
  module Eight_Dir_Movement
    
    #---------------------------------------------------------------------------
    # Turn this switch ON to enable 8-dir movement.
    # Turn it off to disable 8-dir.
    # Set the switch to 0 to always enable 8-dir movement
    #---------------------------------------------------------------------------
    Enable_Switch = 0
    
    #---------------------------------------------------------------------------
    # You can choose to use 8-directional sprites or not. If this is true,
    # then diagonal sprites will be used. If it's false, they will not be used
    #---------------------------------------------------------------------------
    Use_8Dir_Sprites = false
  end
end
#===============================================================================
# ** Rest of Script
#===============================================================================
class Game_System
  def eight_dir_movement_enabled?
    TH::Eight_Dir_Movement::Enable_Switch == 0 || $game_switches[TH::Eight_Dir_Movement::Enable_Switch]    
  end
end
#-------------------------------------------------------------------------------
# Handle 8-dir input
#-------------------------------------------------------------------------------
class Game_Player < Game_Character
  #-----------------------------------------------------------------------------
  # Overwrite.
  #-----------------------------------------------------------------------------
  def move_by_input
    return if !movable? || $game_map.interpreter.running?
    return if Input.dir4 == 0
    return move_straight(Input.dir4) if !$game_system.eight_dir_movement_enabled? || Input.dir8 % 2 == 0
    case Input.dir8
    when 1
      return move_diagonal(4, 2)
    when 3
      return move_diagonal(6, 2)
    when 7
      return move_diagonal(4, 8)
    when 9
      return move_diagonal(6, 8)
    end
  end
end

#-------------------------------------------------------------------------------
# The following are only necessary if you're using 8 directional sprites
#-------------------------------------------------------------------------------
if TH::Eight_Dir_Movement::Use_8Dir_Sprites
  
  class Game_CharacterBase
    #---------------------------------------------------------------------------
    # Overwrite. Set the appropriate 8-dir direction and check for touch trigger
    #---------------------------------------------------------------------------
    def move_diagonal(horz, vert)
      @move_succeed = diagonal_passable?(x, y, horz, vert)
      if @move_succeed
        @x = $game_map.round_x_with_direction(@x, horz)
        @y = $game_map.round_y_with_direction(@y, vert)
        @real_x = $game_map.x_with_direction(@x, reverse_dir(horz))
        @real_y = $game_map.y_with_direction(@y, reverse_dir(vert))
        increase_steps
        if horz == 4
          if vert == 2
            set_direction(1)
          elsif vert == 8
            set_direction(7)
          end
        elsif horz == 6
          if vert == 2
            set_direction(3)
          elsif vert == 8
            set_direction(9)
          end
        end
      else
        check_event_trigger_touch_front
      end
    end
  end

  #-----------------------------------------------------------------------------
  # Overwrite. Draw the appropriate sprite based on direction
  #-----------------------------------------------------------------------------
  class Sprite_Character < Sprite_Base
    def update_src_rect
      if @tile_id == 0      
        if @character.direction % 2 == 0
          index = @character.character_index
          pattern = @character.pattern < 3 ? @character.pattern : 1
          sx = (index % 4 * 3 + pattern) * @cw
          sy = (index / 4 * 4 + (@character.direction - 2) / 2) * @ch
          self.src_rect.set(sx, sy, @cw, @ch)
        else
          index = @character.character_index + 1
          pattern = @character.pattern < 3 ? @character.pattern : 1
          sx = (index % 4 * 3 + pattern) * @cw
          sy = (index / 4 * 4 + (((@character.direction * 2) % 10) - 2) / 2) * @ch
          self.src_rect.set(sx, sy, @cw, @ch)
        end
      end
    end
  end

  #-----------------------------------------------------------------------------
  # Directions can now be diagonal
  #-----------------------------------------------------------------------------
  class Game_Map
    def x_with_direction(x, d)
      x + (d % 3 == 0 ? 1 : (d + 2) % 3 == 0 ? -1 : 0)
    end

    def y_with_direction(y, d)
      y + (d < 4 ? 1 : d > 6 ? -1 : 0)
    end

    def round_x_with_direction(x, d)
      round_x(x + (d % 3 == 0 ? 1 : (d + 2) % 3 == 0 ? -1 : 0))
    end

    def round_y_with_direction(y, d)
      round_y(y + (d < 4 ? 1 : d > 6 ? -1 : 0))
    end
  end
  
  class Game_Character < Game_CharacterBase
    #---------------------------------------------------------------------------
    # Overwrite. Turn towards or away from character need to consider diagonal. 
    #---------------------------------------------------------------------------
    def turn_toward_character(character)
      sx = distance_x_from(character.x)
      sy = distance_y_from(character.y)
      
      if sx > sy      
        if sx == -sy
          set_direction(1)
        elsif sx.abs > sy.abs
          set_direction(4)
        else
          set_direction(2)
        end
      else
        if -sx == sy
          set_direction(9)
        elsif -sx < sy
          if sx == sy
            set_direction(7)
          else
            set_direction(8)
          end
        else
          if sx == sy
            set_direction(3)
          else
            set_direction(6)
          end
        end      
      end
    end
    
    #---------------------------------------------------------------------------
    # Overwrite. Turn towards or away from character need to consider diagonal. 
    #---------------------------------------------------------------------------
    def turn_away_from_character(character)
      sx = distance_x_from(character.x)
      sy = distance_y_from(character.y)
      
      if sx > sy      
        if sx == -sy
          set_direction(9)
        elsif sx.abs > sy.abs
          set_direction(6)
        else
          set_direction(8)
        end
      else
        if -sx == sy
          set_direction(1)
        elsif -sx < sy
          if sx == sy
            set_direction(3)
          else
            set_direction(2)
          end
        else
          if sx == sy
            set_direction(7)
          else
            set_direction(4)
          end
        end      
      end
    end
  end
end
=end