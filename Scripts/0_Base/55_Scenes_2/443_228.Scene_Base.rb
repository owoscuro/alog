# encoding: utf-8
# Name: 228.Scene_Base
# Size: 1582
class Scene_Base
  alias bravo_checkpoint_check_gameover check_gameover
  def check_gameover
    # 에르니 사망시 진행
    if $game_actors[7].dead? and $game_switches[44] != true
      if $game_switches[BRAVO_CHECKPOINT::CHECKPOINT_SWITCH] == true
        if $game_switches[BRAVO_CHECKPOINT::LIFE_SWITCH] == true
          # 에르니 사망시 진행
          $game_temp.reserve_common_event(35)
        #else
        #  process_respawn
        end
      else
        bravo_checkpoint_check_gameover
      end
    end
  end
  
=begin
  def process_respawn
    $game_party.battle_members.each do |actor|
      if BRAVO_CHECKPOINT::HP_RESTORE == 1
        actor.hp = 1 if actor.dead?
      elsif BRAVO_CHECKPOINT::HP_RESTORE == 2
        actor.hp = actor.mhp if actor.dead?
      elsif BRAVO_CHECKPOINT::HP_RESTORE == 3
        amount = (BRAVO_CHECKPOINT::HP_PERCENT * 0.01) * actor.mhp
        actor.hp = amount.to_i if actor.dead?
      end
      current_exp = actor.exp - actor.current_level_exp
      exp_loss = (BRAVO_CHECKPOINT::GOLD_LOSS * 0.01) * current_exp
      actor.change_exp(actor.exp - exp_loss.to_i, false)
    end

    gold_loss = (BRAVO_CHECKPOINT::GOLD_LOSS * 0.01) * $game_party.gold
    $game_party.lose_gold(gold_loss.to_i)

    # 부활 지점으로 이동 제거 실험
    $game_map.setup($game_party.checkpoint_mapid)
    SceneManager.goto(Scene_Map)
    $game_player.moveto($game_party.checkpoint_x, $game_party.checkpoint_y)
    $game_player.set_direction($game_party.checkpoint_dir)
  end
=end

end