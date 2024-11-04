# encoding: utf-8
# Name: 056.YEA, EQUIP
# Size: 3962
#-------------------------------------------------------------------------------
# <equip slots>
#  string
#  string
# </equip slots>
# 액터의 기본 슬롯을 두 슬롯 사이에 나열된 것으로 설정합니다.
# 
# <starting gear: x>
# <starting gear: x, x>
# 배우의 시작 장비 목록에 갑옷 x를 추가합니다.
# 
# <fixed equip: x>
# <fixed equip: x, x>
# 장비 유형 x가 수정됩니다.
#
# <sealed equip: x>
# <sealed equip: x, x>
# 장비 유형 x를 봉인합니다.
#
# <equip slots>
#  string
#  string
# </equip slots>
#
# "문자열"을 적절한 장비 유형 이름으로 바꾸거나 의심스러운 경우 다음을 사용하십시오.
# 장비 유형이 x인 "장비 유형: x".
# 
# <fixed equip: x>
# <fixed equip: x, x>
#
# 장비 유형 x가 수정됩니다, 고정 장비 슬롯은 장비를 의미합니다.
# 
# <sealed equip: x>
# <sealed equip: x, x>
#
# 장비 유형 x를 봉인합니다, 밀봉된 장비 슬롯은 장비가 없음을 의미합니다.
#
# <fixed equip: x>
# <fixed equip: x, x>
#
# 장비 유형 x가 수정됩니다.
# 
# <sealed equip: x>
# <sealed equip: x, x>
#
# 장비 유형 x를 봉인합니다.
#-------------------------------------------------------------------------------
# <equip type: x>
# <equip type: string>
# 
# <fixed equip: x>
# <fixed equip: x, x>
# 장비 유형 x가 수정됩니다.
# 
# <sealed equip: x>
# <sealed equip: x, x>
# 장비 유형 x를 봉인합니다.
#
# <fixed equip: x>
# <fixed equip: x, x>
# 장비 유형 x가 수정됩니다.
# 
# <sealed equip: x>
# <sealed equip: x, x>
# 장비 유형 x를 봉인합니다.
#-------------------------------------------------------------------------------

$imported = {} if $imported.nil?
$imported["YEA-AceEquipEngine"] = true

module Vocab
  def self.etype(etype)
    #return $data_system.terms.etypes[etype] if [0,1,2,3,4,5,6,7,8,9,10,11].include?(etype)
    return $data_system.terms.etypes[etype] if [0,1,2,3,4].include?(etype)
    return YEA::EQUIP::TYPES[etype][0] if YEA::EQUIP::TYPES.include?(etype)
    return ""
  end
end

module Icon
  def self.remove_equip
    return YEA::EQUIP::REMOVE_EQUIP_ICON
  end
  
  def self.nothing_equip
    return YEA::EQUIP::NOTHING_ICON
  end
end

module YEA
  module REGEXP
    module BASEITEM
      EQUIP_SLOTS_ON  = /<(?:EQUIP_SLOTS|equip slots)>/i
      EQUIP_SLOTS_OFF = /<\/(?:EQUIP_SLOTS|equip slots)>/i
      
      EQUIP_TYPE_INT = /<(?:EQUIP_TYPE|equip type):[ ]*(\d+)>/i
      EQUIP_TYPE_STR = /<(?:EQUIP_TYPE|equip type):[ ]*(.*)>/i
      
      STARTING_GEAR = /<(?:STARTING_GEAR|starting gear):[ ](\d+(?:\s*,\s*\d+)*)>/i
      
      FIXED_EQUIP = /<(?:FIXED_EQUIP|fixed equip):[ ](\d+(?:\s*,\s*\d+)*)>/i
      SEALED_EQUIP = /<(?:SEALED_EQUIP|sealed equip):[ ](\d+(?:\s*,\s*\d+)*)>/i
    end
  end
  
  module EQUIP
    DEFAULT_BASE_SLOTS = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
    
    TYPES ={
           0 =>   ["오른손", true, true],
           1 =>   ["왼손", true, true],
           2 =>   ["머리", true, true],
           3 =>   ["몸", true, true],
           4 =>   ["발", true, true],
           5 =>   ["목", true, true],
           6 =>   ["귀", true, true],
           7 =>   ["허리", true, true],
           8 =>   ["반지", true, true],
           9 =>   ["기타", true, true],
           10 =>  ["기타", true, true],
           11 =>  ["성인용품", true, true],
    }
    
    COMMAND_LIST =[
      :equip,
      :clear,
    ]
    
    CUSTOM_EQUIP_COMMANDS ={
      :custom1 => [ "Custom Name",            0,          0, :command_name1],
      :custom2 => [ "Custom Text",           13,          0, :command_name2],
    }
    
    STATUS_FONT_SIZE = 20
    
    # 아이템 창에서 장비 제거 명령을 설정합니다.
    REMOVE_EQUIP_ICON = 1
    REMOVE_EQUIP_TEXT = "Desequip"
    
    # 슬롯 창에 장비 없음 텍스트를 설정합니다.
    NOTHING_ICON = 2
    NOTHING_TEXT = " - "
  end
end