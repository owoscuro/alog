# encoding: utf-8
# Name: 129.Game_Factions
# Size: 642
class Game_Factions
  def initialize
    @data = []
  end
  
  def [](fac_id)
    return nil unless SZS_Factions::Factions[fac_id]
    @data[fac_id] ||= Game_Faction.new(fac_id)
  end
  
  def all_factions
    return @data.select{|f| !f.nil?}
  end
  
  def factions_of(type)
    return @data.select{|f| !f.nil? && f.type == type}
  end
  
  def gain_reputation(fac_id, amount)
    return nil unless SZS_Factions::Factions[fac_id]
    @data[fac_id] ||= Game_Faction.new(fac_id)
    @data[fac_id].gain_reputation(amount)
  end
  
  def lose_reputation(fac_id, amount)
    gain_reputation(fac_id, -amount)
  end
end