# encoding: utf-8
# Name: 128.Game_Faction
# Size: 638
class Game_Faction
  attr_reader :id
  attr_reader :name
  attr_reader :reputation
  attr_reader :type
  attr_reader :level
  
  def initialize(id)
    @id = id
    fac = SZS_Factions::Factions[id]
    @name = fac[:name]
    @type = fac[:type]
    @reputation = fac[:initial_value]
    check_level
  end
  
  def gain_reputation(amount)
    @reputation += amount
    check_level
  end
  
  def lose_reputation(amount)
    gain_reputation(-amount)
  end
  
  def check_level
    lv = -1
    SZS_Factions::Levels.each do |rlv|
      lv += 1 if @reputation >= rlv[:rep_min]
    end
    @level = lv
  end
end