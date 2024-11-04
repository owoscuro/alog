# encoding: utf-8
# Name: 009.RPG, EquipItem
# Size: 5416
=begin

 항목은 최대 하나의 접두사와 하나의 접미사를 가질 수 있습니다.
 
 %s은(는) 원래 장비로 대체될 자리 표시자입니다.
 설명이 있는 숏소드가 있다면

   "Basic short sword."

 그리고 당신은 설명과 함께 접두사를 가지고

   "%s 화염 속성 피해를 추가합니다."

 접두사 또는 접미사를 설정하려면 스크립트 호출을 사용하십시오.
 
   set_prefix(equip, prefix_id)
   set_suffix(equip, suffix_id)
   
 장비가 RPG::Weapon 또는 RPG::Armor 개체인 경우.
 
=end

module RPG
  class EquipItem < BaseItem
    #---------------------------------------------------------------------------
    # Returns the equip's prefix. Returns nil if there is no prefix
    #---------------------------------------------------------------------------
    def prefix
      $data_armors[self.prefix_id]
    end

    #---------------------------------------------------------------------------
    # Returns the equip's suffix. Returns nil if there is no suffix
    #---------------------------------------------------------------------------
    def suffix
      $data_armors[self.suffix_id]
    end
    
    #---------------------------------------------------------------------------
    # Returns the equip's prefix ID. 0 if there is no prefix
    #---------------------------------------------------------------------------
    def prefix_id
      @prefix_id ||= 0
    end
    
    #---------------------------------------------------------------------------
    # Sets the equip's prefix. Takes the ID of the prefix to set
    #---------------------------------------------------------------------------
    def prefix_id=(id)
      @prefix_id = id
      refresh
    end
    
    #---------------------------------------------------------------------------
    # Returns the equip's suffix ID. 0 if there is no suffix
    #---------------------------------------------------------------------------
    def suffix_id
      @suffix_id ||= 0
    end
    
    #---------------------------------------------------------------------------
    # Sets the equip's suffix. Takes the ID of the suffix to set
    #---------------------------------------------------------------------------
    def suffix_id=(id)
      @suffix_id = id
      refresh
    end
    
    alias :th_item_affixes_make_name :make_name
    def make_name(name)
      name = th_item_affixes_make_name(name)
      name = apply_name_suffix(name) if self.suffix
      name
    end
    
    alias :th_item_affixes_make_params :make_params
    def make_params(params)
      params = th_item_affixes_make_params(params)
      params = apply_prefix_params(params) if self.prefix
      params = apply_suffix_params(params) if self.suffix
      params
    end
    
    alias :th_item_affixes_make_description :make_description
    def make_description(desc)
      desc = th_item_affixes_make_description(desc)
      # 접두, 접미 아이템 설명에 대입하는 부분
      desc = apply_prefix_description(desc) if self.prefix
      desc = apply_suffix_description(desc) if self.suffix
      desc
    end
    
    def apply_name_prefix(name)
      @ro_desc_name = sprintf("%s",self.prefix.name)
      @ro_desc_name += sprintf("%s",name)
      name = @ro_desc_name
    end
    
    def apply_name_suffix(name)
      @ro_desc_name = sprintf("%s",self.suffix.name)
      @ro_desc_name += sprintf("%s",name)
      name = @ro_desc_name
    end
    
    def apply_prefix_description(desc)
      @ro_desc = sprintf("%s",desc)
      @ro_desc += sprintf("%s",self.prefix.description)
    end
    
    def apply_suffix_description(desc)
      @ro_desc2 = sprintf("%s",self.suffix.description)
      @ro_desc2 += sprintf("%s",desc)
    end
    
    def apply_prefix_params(params)
      prefix.params.size.times do |i|
        params[i] += prefix.params[i] 
      end
      return params
    end
    
    def apply_suffix_params(params)
      suffix.params.size.times do |i|
        params[i] += suffix.params[i]
      end
      return params
    end
    
    alias :th_item_affixes_make_price :make_price
    def make_price(price)
      price = th_item_affixes_make_price(price)
      price = apply_affix_price(price)
      price
    end
    
    def apply_affix_price(price)
      price += self.prefix.price if self.prefix
      price += self.suffix.price if self.suffix
      price
    end
    
    alias :th_item_affixes_make_features :make_features
    def make_features(feats)
      feats = th_item_affixes_make_features(feats)
      apply_affix_features(feats)
      feats
    end
    
    def apply_affix_features(feats)
      feats.concat(prefix.features) if self.prefix
      feats.concat(suffix.features) if self.suffix
    end
    
    alias :th_item_affixes_make_note :make_note
    def make_note(note)
      note = th_item_affixes_make_note(note)
      apply_affix_notes(note)
    end
    
    def apply_affix_notes(note)
      note << self.prefix.note if self.prefix
      note << self.suffix.note if self.suffix
      note
    end
    
    alias :th_affix_rarity_make_item_rarity :make_item_rarity
    def make_item_rarity(rarity)
      rarity = th_affix_rarity_make_item_rarity(rarity)
      rarity = apply_affix_item_rarity
      rarity
    end

    def apply_affix_item_rarity
      arr = [self.rarity]
      arr = suffix.rarity if suffix
    end
  end
end