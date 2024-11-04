# encoding: utf-8
# Name: 112.Game_Actor
# Size: 2900
class Game_Actor < Game_Battler  
  attr_accessor :base_inv
  attr_accessor :age
  attr_accessor :set_age
  attr_accessor :birthplace
  attr_accessor :set_birthplace
  attr_accessor :height
  attr_accessor :set_height
  attr_accessor :custom_bio
  attr_accessor :set_custom_bio
  
  alias :bm_status_setup :setup
  def setup(actor_id)
    bm_status_setup(actor_id)
    init_bio
    @base_inv = $data_actors[id].inv_mod
  end
  
  def equip_size
    return 0 unless Theo::LimInv::Include_Equip
    equips.compact.inject(0) {|total,equip| total + equip.inv_size}
  end

  def inv_max
    result = base_inv
    result += $data_classes[class_id].inv_mod
    result += states.inject(0) {|total,db| total + db.inv_mod}
    result += equips.compact.inject(0) {|total,db| total + db.inv_mod}
    result += eval(actor.inv_eval)
    result += eval(self.class.inv_eval)
    result
  end
  
  alias :zero_durability_wep_equip :equippable?
  def equippable?(item, slot = nil)
    if item.is_a?(RPG::EquipItem) && item.is_template?
      return zero_durability_wep_equip(item)
    end
    if item.is_a?(RPG::EquipItem)
      if item.use_durability && item.durability.zero?
        return false if item.is_a?(RPG::Weapon)
        return false if item.is_a?(RPG::Armor)
      end
    end
    return zero_durability_wep_equip(item)
    unless slot.nil?
      if slot == 1 and skill_learn?($data_skills[85])
        return (super(item) and not equip_type_sealed?(1)) if item.is_a?(RPG::Weapon)
      end
    end
    return super(item)
  end
  
  def description=(text)
    @description = text
  end
  
  def description
    return @description unless @description.nil?
    return actor.description
  end
  
  def init_bio
    return if actor.name == "" or actor.name == nil
    @init_year = 0
    @init_year = $game_variables[HM_SEL::YEAR]
    @set_age = actor.age
    @set_height = actor.height
    @set_birthplace = actor.birthplace
    @set_custom_bio = {}
    # 지금 동료들의 커스텀 바이오 정보 입력
    for i in 1..30
      #print("112.Game_Actor - ");
      #print("%s의 바이오 정보 입력, %s \n" % [actor.name, actor.custom_bio[i]]);
      @set_custom_bio[i] = actor.custom_bio[i]
    end
  end
  
  # 커스텀 바이오 정보 최대 수치 수정
  alias_bio = 1..30
  alias_bio.each {|i|
  aStr = %Q(
  attr_accessor :custom_bio#{i}
  attr_accessor :set_custom_bio#{i}
  def custom_bio#{i}
    @set_custom_bio[#{i}]
  end
  )
  module_eval(aStr)
  }
  
  def height
    return @set_height if @set_height == BM::STATUS::EMPTY_BIO
    height = sprintf("%scm", @set_height)
  end
  
  def birthplace
    @set_birthplace
  end
  
  def age
    return sprintf("%s살", @set_age)
    #return @set_age
    #@set_age = actor.age + ($game_variables[HM_SEL::YEAR] - @init_year)
  end
end