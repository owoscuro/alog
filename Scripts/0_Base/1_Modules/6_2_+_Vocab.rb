# encoding: utf-8
# Name: 2 + Vocab
# Size: 5905
# encoding: utf-8
# Name: + Vocab
# Size: 5884
module Vocab
  # BuffAdd         = "%s's %s 상승!"
  # DebuffAdd       = "%s's %s 하락!"
  # BuffRemove      = "%s's %s 무시!"
 
  BuffAdd         = "¡%s aumentó %s!"
  DebuffAdd       = "¡%s disminuyó %s!"
  BuffRemove      = "¡%s restauró %s!"

  def self.exp;   "EXP";  end
  def self.exp_a; "EXP";  end
    
  ExpTotal        = "Current #{self.exp}"
  ObtainExp       = "%s #{self.exp} received!"
  
  def self.element(id); $data_system.elements[id] ? $data_system.elements[id] : ""; end
  def self.state(id); $data_states[id] ? $data_states[id].name : ""; end
  def self.enemies(id); $data_enemies[id] ? $data_enemies[id].name : ""; end
  def self.classes(id); $data_classes[id] ? $data_classes[id].name : ""; end
  def self.items(id); $data_items[id] ? $data_items[id].name : ""; end
  def self.weapons(id); $data_weapons[id] ? $data_weapons[id].name : ""; end
  def self.armors(id); $data_armor[id] ? $data_armor[id].name : ""; end
  def self.skills(id); $data_skills[id] ? $data_skills[id].name : ""; end
  def self.skill_types(id); $data_system.skill_types[id] ? $data_system.skill_types[id] : ""; end
  def self.weapon_types(id); $data_system.weapon_types[id] ?$data_system.weapon_types[id] : ""; end
  def self.armor_types(id); $data_system.armor_types[id] ? $data_system.armor_types[id] : ""; end
  def self.variables(id); $data_system.variables[id] ? $data_system.variables[id] : ""; end
  def self.switches(id); $data_system.switches[id] ? $data_system.switches[id] : ""; end
  
  def self.param_a(id)
    case id
    when 0, :hp, :maxhp then self.param(0)
    when 1, :mp, :maxmp then self.param(1)
    when 2, :atk then self.param(2)
    when 3, :def then self.param(3)
    when 4, :mat then self.param(4)
    when 5, :mdf then self.param(5)
    when 6, :agi then self.param(6)
    when 7, :luk then self.param(7)
    else; ""
    end
  end
  
  def self.param_f(id)
    case id
    when 0, :maxhp, :hp then BM::PARAM_VOCAB_FULL[0]
    when 1, :maxmp, :mp then BM::PARAM_VOCAB_FULL[1]
    when 2, :atk then BM::PARAM_VOCAB_FULL[2]
    when 3, :def then BM::PARAM_VOCAB_FULL[3]
    when 4, :mat then BM::PARAM_VOCAB_FULL[4]
    when 5, :mdf then BM::PARAM_VOCAB_FULL[5]
    when 6, :agi then BM::PARAM_VOCAB_FULL[6]
    when 7, :luk then BM::PARAM_VOCAB_FULL[7]
    else; ""
    end
  end
  
  def self.xparam_a(id)
    case id
    when 0, :hit then BM::XPARAM_VOCAB[0]
    when 1, :eva then BM::XPARAM_VOCAB[1]
    when 2, :cri then BM::XPARAM_VOCAB[2]
    when 3, :cev then BM::XPARAM_VOCAB[3]
    when 4, :mev then BM::XPARAM_VOCAB[4]
    when 5, :mrf then BM::XPARAM_VOCAB[5]
    when 6, :cnt then BM::XPARAM_VOCAB[6]
    when 7, :hrg then BM::XPARAM_VOCAB[7]
    when 8, :mrg then BM::XPARAM_VOCAB[8]
    when 9, :trg then BM::XPARAM_VOCAB[9]
    else; ""
    end
  end  
  
  def self.xparam_f(id)
    case id
    when 0, :hit then BM::XPARAM_VOCAB_FULL[0]
    when 1, :eva then BM::XPARAM_VOCAB_FULL[1]
    when 2, :cri then BM::XPARAM_VOCAB_FULL[2]
    when 3, :cev then BM::XPARAM_VOCAB_FULL[3]
    when 4, :mev then BM::XPARAM_VOCAB_FULL[4]
    when 5, :mrf then BM::XPARAM_VOCAB_FULL[5]
    when 6, :cnt then BM::XPARAM_VOCAB_FULL[6]
    when 7, :hrg then BM::XPARAM_VOCAB_FULL[7]
    when 8, :mrg then BM::XPARAM_VOCAB_FULL[8]
    when 9, :trg then BM::XPARAM_VOCAB_FULL[9]
    else; ""
    end
  end
  
  def self.sparam_a(id)
    case id
    when 0, :tgr then BM::SPARAM_VOCAB[0] 
    when 1, :grd then BM::SPARAM_VOCAB[1]
    when 2, :rec then BM::SPARAM_VOCAB[2]
    when 3, :pha then BM::SPARAM_VOCAB[3]
    when 4, :mcr then BM::SPARAM_VOCAB[4]  
    when 5, :tcr then BM::SPARAM_VOCAB[5]
    when 6, :pdr then BM::SPARAM_VOCAB[6]
    when 7, :mdr then BM::SPARAM_VOCAB[7]
    when 8, :fdr then BM::SPARAM_VOCAB[8]
    when 9, :exr then BM::SPARAM_VOCAB[9]
    when 10, :rose_gold1 then BM::SPARAM_VOCAB[10]  # 구매 가격 비율
    when 11, :rose_gold2 then BM::SPARAM_VOCAB[11]  # 판매 가격 비율
    else; ""
    end    
  end   
  
  def self.sparam_f(id)
    case id
    when 0, :tgr then BM::SPARAM_VOCAB_FULL[0]
    when 1, :grd then BM::SPARAM_VOCAB_FULL[1]
    when 2, :rec then BM::SPARAM_VOCAB_FULL[2]
    when 3, :pha then BM::SPARAM_VOCAB_FULL[3]
    when 4, :mcr then BM::SPARAM_VOCAB_FULL[4]
    when 5, :tcr then BM::SPARAM_VOCAB_FULL[5]
    when 6, :pdr then BM::SPARAM_VOCAB_FULL[6]
    when 7, :mdr then BM::SPARAM_VOCAB_FULL[7]
    when 8, :fdr then BM::SPARAM_VOCAB_FULL[8]
    when 9, :exr then BM::SPARAM_VOCAB_FULL[9]
    when 10, :rose_gold1 then BM::SPARAM_VOCAB[10]  # 구매 가격 비율
    when 11, :rose_gold2 then BM::SPARAM_VOCAB[11]  # 판매 가격 비율
    when 12, :el_3 then BM::SPARAM_VOCAB_FULL[12]   # 속성 유효도
    when 13, :el_4 then BM::SPARAM_VOCAB_FULL[13]
    when 14, :el_5 then BM::SPARAM_VOCAB_FULL[14]
    when 15, :el_6 then BM::SPARAM_VOCAB_FULL[15]
    when 16, :el_7 then BM::SPARAM_VOCAB_FULL[16]
    when 17, :el_8 then BM::SPARAM_VOCAB_FULL[17]
    when 18, :el_9 then BM::SPARAM_VOCAB_FULL[18]
    when 19, :el_10 then BM::SPARAM_VOCAB_FULL[19]
    when 20, :el_12 then BM::SPARAM_VOCAB_FULL[20]
    when 21, :aps then BM::SPARAM_VOCAB_FULL[21]    # 넉백 무시 확률
    when 22, :atk_lk then BM::SPARAM_VOCAB_FULL[22] # 치명타 공격력 비율
    else; ""
    end
  end
  
  def self.cparam_a(id)
    case id
      when :hcr, :tcr_y, :gcr, :cdr, :wur, :hp_physical, :mp_physical, :mp_magical, :hp_magical
        BM::CPARAM_VOCAB[id]
      when :gut
        return unless $imported["BubsGuts"]
        Vocab.guts_a
      else; ""
    end
  end
  
  def self.cparam_f(id)
    case id
      when :hcr, :tcr_y, :gcr, :cdr, :wur, :hp_physical, :mp_physical, :mp_magical, :hp_magical
        BM::CPARAM_VOCAB_FULL[id] 
      when :gut
        return unless $imported["BubsGuts"]
        Vocab.guts
      else; ""
    end
  end  
end