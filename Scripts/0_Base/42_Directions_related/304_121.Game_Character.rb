# encoding: utf-8
# Name: 121.Game_Character
# Size: 5509
class Game_Character < Game_CharacterBase
  attr_reader    :altitude
  attr_accessor  :shadow
    
  def shadow_source(*args,shad_id)
    shadsource = [*args]
    if !$game_map.shad_id_ro.include?(shadsource)
      print("121.Game_Character - 그림자 적용[1] %s \n" % [$game_map.shad_id_ro]);
      $game_map.shad_id_ro.push(shadsource)
      shad_id = $game_map.shad_id_ro.index(shadsource)
      if (@character_name == "!$Map_Window_1" and @direction != 8) or @character_name == "!$Map_Window_2" or
        @character_name == "!$Map_Window_3" or @character_name == "!$Map_Window_4" or
        (@character_name == "!$Torchlight4" and @direction != 4)
        $game_map.light_source[shad_id] = [$game_map.events[shadsource[0]].real_x, $game_map.events[shadsource[0]].real_y - 3]
        shadow_options(100, 15, true)
      else
        $game_map.light_source[shad_id] = [$game_map.events[shadsource[0]].real_x, $game_map.events[shadsource[0]].real_y]
        shadow_options(100, 15, true)
      end
    end
=begin
    else
      print("121.Game_Character - 그림자 적용[2] %s \n" % [$game_map.shad_id_ro]);
      shad_id = $game_map.shad_id_ro.index(shadsource)
      if (@character_name == "!$Map_Window_1" and @direction != 8) or @character_name == "!$Map_Window_2" or
        @character_name == "!$Map_Window_3" or @character_name == "!$Map_Window_4" or
        (@character_name == "!$Torchlight4" and @direction != 4)
        if ($game_map.light_source[shad_id][0]).to_i != ($game_map.events[self.id].real_x).to_i or ($game_map.light_source[shad_id][1]).to_i != ($game_map.events[self.id].real_y).to_i
          $game_map.light_source[shad_id] = [$game_map.events[shadsource[0]].real_x, $game_map.events[shadsource[0]].real_y - 3]
        end
      else
        if ($game_map.light_source[shad_id][0]).to_i != ($game_map.events[self.id].real_x).to_i or ($game_map.light_source[shad_id][1]).to_i != ($game_map.events[self.id].real_y - 3).to_i
          $game_map.light_source[shad_id] = [$game_map.events[shadsource[0]].real_x, $game_map.events[shadsource[0]].real_y]
        end
      end
    end
=end
    $game_map.shad_id_ro.uniq  # 중복값을 제거한다.
  end
  
  def r_shadow_source(*args,shad_id)
    shadsource = [*args]
    if $game_map.shad_id_ro.include?(shadsource)
      shad_id = $game_map.shad_id_ro.index(shadsource)
      if (@character_name == "!$Map_Window_1" and @direction != 8)  or @character_name == "!$Map_Window_2" or
        @character_name == "!$Map_Window_3" or @character_name == "!$Map_Window_4" or
        (@character_name == "!$Torchlight4" and @direction != 4)
        if ($game_map.light_source[shad_id][0]).to_i != ($game_map.events[self.id].real_x).to_i or ($game_map.light_source[shad_id][1]).to_i != ($game_map.events[self.id].real_y).to_i
          $game_map.light_source[shad_id] = [$game_map.events[shadsource[0]].real_x, $game_map.events[shadsource[0]].real_y - 3]
        end
      else
        if ($game_map.light_source[shad_id][0]).to_i != ($game_map.events[self.id].real_x).to_i or ($game_map.light_source[shad_id][1]).to_i != ($game_map.events[self.id].real_y - 3).to_i
          $game_map.light_source[shad_id] = [$game_map.events[shadsource[0]].real_x, $game_map.events[shadsource[0]].real_y]
        end
      end
    end
    $game_map.shad_id_ro.uniq  # 중복값을 제거한다.
  end
  
  def d_shadow_source(*args,shad_id)
    shadsource = [*args]
    if $game_map.shad_id_ro.include?(shadsource)
      shad_id = $game_map.shad_id_ro.index(shadsource)
      $game_map.light_source.delete_at(shad_id)
      $game_map.shad_id_ro.delete_at(shad_id)
      SceneManager.scene.spriteset.refresh_effects
    end
  end
  
  def shadow_options(*args)
    $game_map.shadow_options = [*args]
    SceneManager.scene.spriteset.refresh_effects
  end
  
  def move_toward_position(x, y)
    sx = distance_x_from(x)
    sy = distance_y_from(y)
    if sx.abs > sy.abs
      move_straight(sx > 0 ? 4 : 6)
      move_straight(sy > 0 ? 8 : 2) if !@move_succeed && sy != 0
    elsif sy != 0
      move_straight(sy > 0 ? 8 : 2)
      move_straight(sx > 0 ? 4 : 6) if !@move_succeed && sx != 0
    end
  end
  
  def turn_toward_position(x, y)
    sx = distance_x_from(x)
    sy = distance_y_from(y)
    if sx.abs > sy.abs
      set_direction(sx > 0 ? 4 : 6)
    elsif sy != 0
      set_direction(sy > 0 ? 8 : 2)
    end
  end
  
  alias pearlagro_turn_toward_player turn_toward_player
  def turn_toward_player
    if self.is_a?(Game_Event) and self.agroto_f != nil
      turn_toward_character(self.agroto_f)
      return
    end
    pearlagro_turn_toward_player
  end
 
  alias pearlagro_turn_away_from_player turn_away_from_player
  def turn_away_from_player
    if self.is_a?(Game_Event) and self.agroto_f != nil
      turn_away_from_character(self.agroto_f)
      return
    end
    pearlagro_turn_away_from_player
  end
  
  alias pearlagro_move_toward_player move_toward_player
  def move_toward_player
    if self.is_a?(Game_Event) and self.agroto_f != nil
      move_toward_character(self.agroto_f)
      return
    end
    pearlagro_move_toward_player
  end
  
  alias pearlagro_move_away_from_player move_away_from_player
  def move_away_from_player
    if self.is_a?(Game_Event) and self.agroto_f != nil
      move_away_from_character(self.agroto_f)
      return
    end
    pearlagro_move_away_from_player
  end
end