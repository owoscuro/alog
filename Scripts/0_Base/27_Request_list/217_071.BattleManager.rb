# encoding: utf-8
# Name: 071.BattleManager
# Size: 370
module BattleManager
  def self.process_defeat
    $game_message.add(sprintf(Vocab::Defeat, $game_party.name))
    wait_for_message
    if @can_lose
      revive_battle_members
      replay_bgm_and_bgs
      SceneManager.return
    else
      replay_bgm_and_bgs
      SceneManager.scene.check_gameover
    end
    battle_end(2)
    return true
  end
end