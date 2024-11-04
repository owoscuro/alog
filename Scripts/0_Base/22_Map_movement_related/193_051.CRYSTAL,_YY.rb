# encoding: utf-8
# Name: 051.CRYSTAL, YY
# Size: 1405
$imported ||= {}
$imported["CE-EquipmentWeight"] = true

=begin

Actor Notes
Class Notes
  <weight limit: x>         # 클래스의 가중치 제한을 x로 설정합니다.

Skill Notes
  <change weight limit: +x> # 표적의 무게 한계에 x를 더한다.
  <change weight limit: -x> # x를 목표 체중 제한으로 뺍니다.

Item Notes
  <change weight limit: +x> # 목표 체중 제한에 x를 더하십시오.
  <change weight limit: -x> # x를 목표 체중 제한으로 뺍니다.
  <weight: x>               # 항목의 무게를 x로 설정합니다.

Weapon Notes
  <weight: x>               # 무기의 무게를 x로 설정합니다.

Armor Notes
  <weight: x>               # 방어구의 무게를 x로 설정합니다.
  
스크립트 호출, 지정된 액터의 체중 제한 수정
  change_weight_limit(actor_id, amount)

=end

module CRYSTAL
  module EQUIP
    #--------------------------------------------------------------------------
    # * 액터의 기본 가중치 제한
    #--------------------------------------------------------------------------
    DEFAULT_WEIGHT_LIMIT = 20
    DEFAULT_SEXY_LIMIT = 60
    
    #--------------------------------------------------------------------------
    # * 장비의 기본 무게
    #--------------------------------------------------------------------------
    DEFAULT_WEIGHT = 5
  end
end

module YY
  MAX_LEVEL = 500
end