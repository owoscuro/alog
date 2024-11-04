# encoding: utf-8
# Name: 040.Theo, LimInv
# Size: 3946
# encoding: utf-8
# Name: 040.Theo, LimInv
# Size: 4053
($imported ||= {})[:Theo_LimInventory] = true

=begin

  <inv size: n>
  n이 크기를 결정하는 숫자 값인 경우 이 메모 태그를 사용하십시오.
  항목의. 무제한 항목에는 0을 사용합니다.
  무기나 갑옷, 다음과 같은 항목 및 장비에만 작동합니다.
  
  <inv plus: n>
  이 메모 태그를 사용하여 사용 가능한 추가 인벤토리 슬롯을 결정하십시오.
  이 메모 태그는 Actor, Class, Equip, States에 대해 사용할 수 있습니다.
  액터의 경우 새로운 액터가 파티에 입장하면 사용 가능한 인벤토리 슬롯이 늘어납니다.
  장비용일 경우 특정 장비를 장착하면 사용 가능한 슬롯이 증가합니다.
  
  <inv minus: n>
  <inv plus: n> 의 역.
  사용 가능한 인벤토리 슬롯이 줄어듭니다.
  
  <inv formula>
  script
  </inv formula>
  
  이 메모 태그는 자신의 공식에 따라 재고 한도를 결정하는 데 사용됩니다.
  예를 들어, 액터의 인벤토리 제한은 민첩성 또는 심지어
  그 수준. 액터 또는 클래스 메모장 내에서 사용할 수 있습니다.
  
  재고 공식은 기본 재고와 함께 자동으로 누적됩니다.
  <inv plus: 100>
  
  <inv formula>
  level * 100
  </inv formula>
    
  이 공식을 사용하면 각 액터가 레벨을 올렸음을 의미합니다.
  인벤토리가 100만큼 증가합니다.
  
  - mhp
  - mmp
  - atk
  - def
  - mat
  - mdf
  - agi
  - luk
  - $game_variables[id]
  
  force_gain_item($data_items[id],amount)
  
  액터의 기본 인벤토리를 변경하려면 다음 스크립트 호출을 사용하십시오.
  $game_actors[id].base_inv = value     << Set
  $game_actors[id].base_inv += value    << Add
  $game_actors[id].base_inv -= value    << Substract
  
  동적 슬롯을 false로 설정하면 다음을 사용하여 인벤토리 제한을 변경할 수 있습니다.
  
  $game_party.base_inv = value
  
=end

module Theo
  module LimInv
    DynamicSlot       = true
    # 총 사용 가능한 인벤토리 슬롯은 배우, 주, 전체 파티에 따라 다릅니다.
  
    Display_ItemSize  = true
    # 항목 메뉴에 항목 크기 표시
  
    Include_Equip     = true
    # 사용된 총 인벤토리 슬롯에는 배우 장비도 포함됩니다.
  
    DrawTotal_Size    = true
    # true인 경우 항목 크기 창에 지정된 항목의 총 중량이 표시됩니다.
    # 예를 들어 10개의 물약이 있습니다.
    # 3 대신 30 을 표시합니다.
  
    ForceGain         = true
    # 항목이 가득 차면 강제로 항목을 얻으십시오.
    
    Full_DisableDash  = true
    # 인벤토리가 가득 차면 대시를 비활성화합니다.

    Default_FreeSlot  = 20
    # 각 액터에 제공되는 기본값입니다.

    NearMaxed_Percent = 25
    # 인벤토리가 거의 찼는지 확인하기 위해 사용 가능한 슬롯 비율을 유지합니다.

    NearMaxed_Color   = 21
    # 인벤토리가 거의 찼을 경우 인벤토리 창은
    # 다른 색상, 색상 코드는 메시지의 \C[n]과 동일합니다.

    UseCommand_Size   = 130    
    # 아이템 사용 명령창의 너비

    InvSlotVocab    = "Peso Límite"
    InvSizeVocab    = "Peso"
    InvSizeMax      = "Capacidad / Máxima Capacidad"
    SlotVocabShort  = "Peso Límite"
    UseVocab        = "Usar"
    CancelVocab     = "Cancelar"
  end
end

if $imported["YEA-MenuCursor"]
  class Sprite_MenuCursor
    def opacity_rate
      rate = 16
      return -rate if !@window.active || @window.close?
      return rate
    end
  end
end

if $imported[:mog_menu_cursor]
  module CURSOR_MENU_SPRITE
    def can_update_cursor_position?
      return false if !self.active     
      return false if self.index < 0 
      return false if !self.visible
      return false if self.close?
      return true
    end
  end
end