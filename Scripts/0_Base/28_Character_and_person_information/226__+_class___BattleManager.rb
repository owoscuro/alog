# encoding: utf-8
# Name:  + class _ BattleManager
# Size: 302
class << BattleManager
  def all_battle_members
    $game_party.members + $game_troop.members
  end
  
  def all_dead_members
    $game_party.dead_members + $game_troop.dead_members
  end
  
  def all_movable_members
    $game_party.movable_members + $game_troop.movable_members
  end
end