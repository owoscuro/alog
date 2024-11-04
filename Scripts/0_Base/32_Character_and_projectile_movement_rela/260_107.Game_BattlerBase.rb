# encoding: utf-8
# Name: 107.Game_BattlerBase
# Size: 1292
class Game_BattlerBase
  attr_reader   :buffs
  
  def get_param(text)
    case text.upcase
    when "MAXHP" then self.mhp
    when "MAXMP" then self.mmp
    when "MAXTP" then self.max_tp
    else eval("self.#{text.downcase}")
    end
  end
  
  def type
    list = []
    get_all_notes.scan(/<BATTLER TYPE: ((?:\w+ *,? *)+)>/i) do
      $1.scan(/(\d+)/i) { list.push(make_symbol($1)) }
    end
    list.uniq
  end
  
  def danger?
    hp < mhp * 25 / 100
  end
  
  def sprite
    valid = SceneManager.scene_is?(Scene_Battle) && SceneManager.scene.spriteset
    valid ? SceneManager.scene.spriteset.sprite(self) : nil
  end
  
  def element_set(item)
    element_set  = item.element_set
    element_set += atk_elements if item.damage.element_id < 0
    element_set.delete(0)
    element_set.compact
  end
  
  def add_state_normal(state_id, rate = 1, user = self)
    chance  = rate
    chance *= state_rate(state_id)
    chance *= luk_effect_rate(user)
    print("107.Game_BattlerBase - ");
    print("상태이상 추가 확률 %s \n" % [chance]);
    add_state(state_id) if rand < chance
  end
  
  def damaged?
    @result.hp_damage != 0 || @result.mp_damage != 0 || @result.tp_damage != 0
  end
  
  def mtp
    return 100
  end
end