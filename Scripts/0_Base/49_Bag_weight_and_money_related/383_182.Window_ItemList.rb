# encoding: utf-8
# Name: 182.Window_ItemList
# Size: 1926
class Window_ItemList
  REGEXP_ETYPE = /etype(\d+)/
  REGEXP_WTYPE = /wtype(\d+)/
  REGEXP_ATYPE = /atype(\d+)/
  
  def include?(item)
    return item != nil if @category == :all
    return false unless include_keyword?(item) unless @category.is_a?(String)
    case @category
    when String
      prefix = CAO::CategorizeItem::KEYWORD_PREFIX
      suffix = CAO::CategorizeItem::KEYWORD_SUFFIX
      return item && item.note.include?("#{prefix}#{@category}#{suffix}")
    when :all
      return item != nil
    when :all_item
      return item.is_a?(RPG::Item)
    when :item
      return item.is_a?(RPG::Item) && !item.key_item?
    when :weapon
      return (item.is_a?(RPG::Weapon) and item.etype_id == 0)
    when :armor
      return (item.is_a?(RPG::Armor) and item.etype_id >= 1)
    when :key_item
      return item.is_a?(RPG::Item) && item.key_item?
    end
    return false
  end
  
  def include_keyword?(item)
    return true if CAO::CategorizeItem::INCLUDE_KEYWORD
    return !(item && keyword_item?(item))
  end
  
  def keyword_item?(item)
    return CAO::CategorizeItem::KEYWORDS.any? {|k| item.note.include?(k) }
  end
end

class Window_ItemList < Window_Selectable
  attr_reader :item_size_window
  
  def item_size_window=(window)
    @item_size_window = window
    @item_size_window.set_item(item)
  end
  
  alias theo_liminv_update_help update_help
  def update_help
    theo_liminv_update_help
    @item_size_window.set_item(item) if @item_size_window
  end

  alias theo_liminv_height= height=
  def height=(height)
    self.theo_liminv_height = height
    refresh
  end
  
  def enable?(item)
    if item.is_a?(RPG::Item)
    # 커먼 이벤트 예약이 된 경우 취소
    item.effects.each {|effects| 
      return false if effects.code == 44 and $game_temp.common_event_reserved?
    }
    end
    return !item.nil?
  end
end