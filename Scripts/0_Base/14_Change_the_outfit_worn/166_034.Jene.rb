# encoding: utf-8
# Name: 034.Jene
# Size: 1584
#-------------------------------------------------------------------------------
# <ge: actor_id, sprite_name, sprite_index>
# <fe: actor_id, face_name, face_index>
#-------------------------------------------------------------------------------
module Jene
  CHANGE_DEFAULT_GRAPHIC = true
  CHANGE_DEFAULT_GRAPHIC_SWITCH = 184
  #--------------------------------------------------------------------------
  #     0 = Weapon         3 = Body Armor
  #     1 = Shield         4 = Accessory
  #     2 = Headgear
  #--------------------------------------------------------------------------
  PRIORITY_EQUIP = [3]
  #--------------------------------------------------------------------------
  # * 그래픽 장비
  # [[액터 아이디, 스프라이트 이름, 스프라이트 인덱스]]
  #
  # 예: 20일 때
  # 반환 [[1, Actor2, 2], [2, Actor2, 3]]
  #--------------------------------------------------------------------------
  def self.graphic_equip(id)
    case id
    when 1
      return [[0, nil, 0]]
    end
    return [[0, nil, 0]]
  end
  #--------------------------------------------------------------------------
  # [[actor_id, sprite_name, sprite_index]]
  #
  # Example: when 20
  # return [[1, Actor2, 2], [2, Actor2, 3]]
  #--------------------------------------------------------------------------
  def self.face_equip(id)
    case id
    when 1
      return [[0, nil, 0]]
    end
    return [[0, nil, 0]]
  end
  GRAPHIC_EQUIP = /<ge[:]?\s*(\d+)\s*[,]?\s*([$]*\w+)?\s*[,]?\s*(\d+)\s*>/i
  FACE_EQUIP = /<fe[:]?\s*(\d+)\s*[,]?\s*(\w+)?\s*[,]?\s*(\d+)\s*>/i
end