# encoding: utf-8
# Name: 036.CHARACTER_EX_EFFECTS_COMMAND
# Size: 1792
module CHARACTER_EX_EFFECTS_COMMAND
  def char_effect(event_id = 0, effect_type = "Breath")
    if event_id == -1
      for event in $game_map.events.values
        if $game_map.map_id == 35 and event.character_name == "Sign3_Quest_Scroll"
          execute_char_effect(event,effect_type) if event != nil
        elsif $game_map.map_id == 21 and event.character_name != "$W_Weapon" and event.character_name != "$Sign_3" and event.character_name != "$Sign_9" and event.character_name != ""
          execute_char_effect(event,"Dwarf") if event != nil
          $game_player.followers.each do |f|
            execute_char_effect(f,effect_type) if f != nil
          end
          execute_char_effect($game_player,effect_type) if $game_player != nil
        elsif event.character_name == "!$A_Warp" or event.character_name == "!$Quest"
          execute_char_effect(event,"Ghost") if event != nil
        end
      end
    elsif event_id == 0
      target = $game_player rescue nil
      execute_char_effect(target,effect_type) if target != nil
    else  
      target = $game_map.events[event_id] rescue nil
      execute_char_effect(target,effect_type) if target != nil
    end
  end

  def execute_char_effect(target,effect_type)
    if effect_type == "Clear"
      target.clear_effects rescue nil
      return
    end           
    target.effects[0] = effect_type.to_s rescue nil
    target.effects[2] = true rescue nil
  end
  
  def clear_all_events_effects
    for event in $game_map.events.values
        event.clear_effects
    end  
  end

  def clear_all_party_effects
    $game_player.clear_effects
    for folower in $game_player.followers
        folower.clear_effects
    end
  end
  
  def clear_all_ex_effects
    clear_all_events_effects
    clear_all_party_effects
  end
end