# encoding: utf-8
# Name: 041.Parameter_Bonuses
# Size: 1624
=begin

 매개변수 보너스를 정의하려면, TYPE은 다음 중 하나입니다.
 
 <param bonus: TYPE>
   FORMULA
 </param bonus>
 
   mhp - max HP
   mmp - max MP
   atk - attack
   def - defense
   mat - magic attack
   mdf - magic defense
   agi - agility
   luk - luck
   
 그리고 수식은 유효한 루비 수식이 될 수 있습니다.
 다음 수식 변수를 사용할 수 있습니다.
 
   a - the current battler (actor or enemy)
 obj - the tagged object
   p - game party
   t - game troop
   v - game variables
   s - game switches
   
 <param bonus: atk>
   a.atk * 1.5
 </param bonus>
   
 obj 변수는 참조하는 데 사용할 수 있는 특수 변수입니다.
 보너스가 첨부된 개체에.
 예를 들어, 무기에 태그를 지정했습니다.
 
 <param bonus: mhp>
    obj.params[2] * 10
 </param bonus>
 
 <param bonus: mhp>
   a.str * 10
 </param bonus>
 
 <param bonus: atk>
   a.str * 2
 </param bonus>
 
=end

$imported = {} if $imported.nil?
$imported["TH_ParameterBonus"] = true

module TH
  module Parameter_Bonuses
    Regex = /<param[-_ ]bonus:\s*(\w+)\s*>(.*?)<\/param[-_ ]bonus>/im
    Table = {
      :mhp => 0,
      :mmp => 1,
      :atk => 2,
      :def => 3,
      :mat => 4,
      :mdf => 5,
      :agi => 6,
      :luk => 7
    }
  end
end

class Data_ParamBonus
  attr_accessor :param_id
  attr_accessor :formula
	attr_accessor :obj
  
  def initialize(param_id, formula="0", obj)
    @param_id = param_id
    @formula = formula
		@obj = obj
  end
  
  def value(a, p=$game_party, t=$game_troop, s=$game_switches, v=$game_variables)
    eval(@formula)
  end
end