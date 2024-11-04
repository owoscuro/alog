# encoding: utf-8
# Name: 085.RPG_Class
# Size: 564
class RPG::Class < RPG::BaseItem
  def weight_limit
    @note =~ /<무게제한 (\d+)>/i ? $1.to_i : CRYSTAL::EQUIP::DEFAULT_WEIGHT_LIMIT
  end
  
  def sexy_limit
    @note =~ /<허용노출도 (\d+)>/i ? $1.to_i : CRYSTAL::EQUIP::DEFAULT_SEXY_LIMIT
  end
end

class RPG::Troop::Page
  def note
    return "" if !@list || @list.size <= 0
    comment_list = []
    @list.each do |item|
      next unless item && (item.code == 108 || item.code == 408)
      comment_list.push(item.parameters[0])
    end
    comment_list.join("\r\n")
  end
end