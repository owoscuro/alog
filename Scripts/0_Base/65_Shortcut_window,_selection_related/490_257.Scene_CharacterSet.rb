# encoding: utf-8
# Name: 257.Scene_CharacterSet
# Size: 1443
class Scene_CharacterSet < Scene_MenuBase
  def start
    super
    Sound.play_ok
    member = $game_party.battle_members
    # 에르니가 죽어있다면 교체하지 않는다.
    if !member[0].dead?
      if member.size == 2
        $game_party.swap_order(0, 1) if !member[1].dead?
      end
      if member.size == 3
        $game_party.swap_order(1, 2) if !member[2].dead?
        $game_party.swap_order(0, 1) if !member[1].dead?
      end
      if member.size == 4
        $game_party.swap_order(1, 0) if !member[0].dead?
        $game_party.swap_order(1, 3) if !member[3].dead?
        $game_party.swap_order(1, 2) if !member[2].dead?
      end
    end
    SceneManager.return
  end
end

class Scene_CharacterSet2 < Scene_MenuBase
  def start
    super
    Sound.play_ok
    member = $game_party.battle_members
    # 에르니가 죽어있다면 교체하지 않는다.
    if !member[0].dead?
      if member.size == 2
        $game_party.swap_order(1, 0) if !member[1].dead?
      end
      if member.size == 3
        $game_party.swap_order(2, 1) if !member[2].dead?
        $game_party.swap_order(1, 0) if !member[1].dead?
      end
      if member.size == 4
        $game_party.swap_order(0, 1) if !member[0].dead?
        $game_party.swap_order(3, 1) if !member[3].dead?
        $game_party.swap_order(2, 1) if !member[2].dead?
      end
    end
    SceneManager.return
  end
end