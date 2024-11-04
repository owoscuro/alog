# encoding: utf-8
# Name: 079.RPG_UsableItem
# Size: 2245
class RPG::UsableItem < RPG::BaseItem
  def user_hunger; if @note =~ /<user-hunger: (.*)>/i; return $1.to_i; else; return 0; end; end
  def user_thirst; if @note =~ /<user-thirst: (.*)>/i; return $1.to_i; else; return 0; end; end
  def user_sleep; if @note =~ /<user-sleep: (.*)>/i; return $1.to_i; else; return 0; end; end
  def user_repute; if @note =~ /<user-repute: (.*)>/i; return $1.to_i; else; return 0; end; end
  def user_sexual; if @note =~ /<user-sexual: (.*)>/i; return $1.to_i; else; return 0; end; end
  def user_piety; if @note =~ /<user-piety: (.*)>/i; return $1.to_i; else; return 0; end; end
  def user_hygiene; if @note =~ /<user-hygiene: (.*)>/i; return $1.to_i; else; return 0; end; end
  def user_temper; if @note =~ /<user-temper: (.*)>/i; return $1.to_i; else; return 0; end; end
  def user_stress; if @note =~ /<user-stress: (.*)>/i; return $1.to_i; else; return 0; end; end
  def user_cold; if @note =~ /<user-cold: (.*)>/i; return $1.to_i; else; return 0; end; end
  def user_drunk; if @note =~ /<user-drunk: (.*)>/i; return $1.to_i; else; return 0; end; end
  def hunger; if @note =~ /<hunger: (.*)>/i; return $1.to_i; else; return 0; end; end
  def thirst; if @note =~ /<thirst: (.*)>/i; return $1.to_i; else; return 0; end; end
  def sleep; if @note =~ /<sleep: (.*)>/i; return $1.to_i; else; return 0; end; end
  def repute; if @note =~ /<repute: (.*)>/i; return $1.to_i; else; return 0; end; end
  def sexual; if @note =~ /<sexual: (.*)>/i; return $1.to_i; else; return 0; end; end
  def piety; if @note =~ /<piety: (.*)>/i; return $1.to_i; else; return 0; end; end
  def hygiene; if @note =~ /<hygiene: (.*)>/i; return $1.to_i; else; return 0; end; end
  def temper; if @note =~ /<temper: (.*)>/i; return $1.to_i; else; return 0; end; end
  def stress; if @note =~ /<stress: (.*)>/i; return $1.to_i; else; return 0; end; end
  def cold; if @note =~ /<cold: (.*)>/i; return $1.to_i; else; return 0; end; end
  def drunk; if @note =~ /<drunk: (.*)>/i; return $1.to_i; else; return 0; end; end

  def weight_mod
    @note =~ /<무게변경 ([\+\-]\d+)>/i ? $1.to_i : 0
  end
  
  def for_all_targets?
    return false
  end
  
  def element_set
    [damage.element_id]
  end
end