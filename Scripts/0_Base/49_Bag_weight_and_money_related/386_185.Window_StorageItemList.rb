# encoding: utf-8
# Name: 185.Window_StorageItemList
# Size: 2624
class Window_StorageItemList < Window_ItemList
  def initialize(x, y, width, height)
    super(x, y, width, height)
    @storage = :none
  end
  
  #--------------------------------------------------------------------------
  # 가온데 정렬 추가 수정
  #--------------------------------------------------------------------------
  def alignment
    return 1
  end
  
  def col_max
    # 해상도 좌표
    if Graphics.height == 640 or Graphics.height == 704
      return 3
    else
      return 2
    end
  end
  
  def storage=(storage)
    return if @storage == storage
    @storage = storage
    refresh
    self.oy = 0
  end
  
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
    when :equip
      return item.is_a?(RPG::EquipItem)
    when :weapon
      return item.is_a?(RPG::Weapon)
    when :armor
      return item.is_a?(RPG::Armor)
    when :key_item
      return item.is_a?(RPG::Item) && item.key_item?
    else
      case @category.to_s
      when REGEXP_ETYPE
        return item.is_a?(RPG::EquipItem) && item.etype_id == $1.to_i
      when REGEXP_WTYPE
        return item.is_a?(RPG::Weapon) && item.wtype_id == $1.to_i
      when REGEXP_ATYPE
        return item.is_a?(RPG::Armor) && item.atype_id == $1.to_i
      end
    end
    return false
  end
  
  def enable?(item)
    if item.is_a?(RPG::Item)
      return true if !item.key_item?
    elsif item.is_a?(RPG::Weapon) || item.is_a?(RPG::Armor)
      return true
    else
      return false
    end
  end
  
  def make_item_list
    case @storage
    when :store
      @data = $game_party.all_items.select {|item| include?(item) }
      @data.push(nil) if include?(nil)
    when :withdraw
      @data = $game_party.storage_all_items.select {|item| include?(item) }
      @data.push(nil) if include?(nil)
    end
  end
  
  def draw_item_number(rect, item)
    case @storage
    when :store
      draw_text(rect, sprintf("×%2d", $game_party.item_number(item)), 2)
    when :withdraw
      draw_text(rect, sprintf("×%2d", $game_party.storage_item_number(item)), 2)
    end
  end
end