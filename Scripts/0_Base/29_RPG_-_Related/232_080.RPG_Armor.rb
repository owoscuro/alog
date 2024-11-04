# encoding: utf-8
# Name: 080.RPG_Armor
# Size: 1155
class RPG::Armor
  def graphic_equip(equip_arr = [])
    self.note.split(/[\r\n]+/).each { |line|
      case line
      when Jene::GRAPHIC_EQUIP
        equip_arr.push([$1.to_i, $2.to_s, $3.to_i])
      end
    }
    equip_arr.concat(Jene.graphic_equip(@id))
    return equip_arr
  end
  
  def face_equip(equip_arr = [])
    self.note.split(/[\r\n]+/).each { |line|
      case line
      when Jene::FACE_EQUIP
        equip_arr.push([$1.to_i, $2.to_s, $3.to_i])
      end
    }
    equip_arr.concat(Jene.face_equip(@id))
    return equip_arr
  end
end

class RPG::Weapon
  def graphic_equip(equip_arr = [])
    self.note.split(/[\r\n]+/).each { |line|
      case line
      when Jene::GRAPHIC_EQUIP
        equip_arr.push([$1.to_i, $2.to_s, $3.to_i])
      end
    }
    equip_arr.concat(Jene.graphic_equip(@id))
    return equip_arr
  end
  
  def face_equip(equip_arr = [])
    self.note.split(/[\r\n]+/).each { |line|
      case line
      when Jene::FACE_EQUIP
        equip_arr.push([$1.to_i, $2.to_s, $3.to_i])
      end
    }
    equip_arr.concat(Jene.face_equip(@id))
    return equip_arr
  end
end