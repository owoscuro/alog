# encoding: utf-8
# Name: 068.ShopItemList
# Size: 1535
module SceneManager
  def self.force_recall(scene_class)
    print("067.SceneManager - ");
    print("force_recall \n");
    @scene = scene_class
  end
end

module ShopItemList
  REGEXP_ETYPE = /etype(\d+)/
  REGEXP_WTYPE = /(?:wtype|weapon)(\d+)/
  REGEXP_ATYPE = /(?:atype|armor)(\d+)/
  
  def current_item_enabled?
    enable?(@data[index])
  end
  
  def category=(category)
    return if @category == category
    @category = category
    refresh
    self.oy = 0
    self.index = 0
    if @status_window
      @status_window.item = self.item
      @status_window.refresh
    end
  end
  
  def include?(item)
    case @category
    when String
      return item && item.note.include?("<#{@category}>")
    when :item
      return item.is_a?(RPG::Item) && !item.key_item?
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
  
  def status_window=(status_window)
    @status_window = status_window
    call_update_help
  end
  
  def update_help
    @help_window.set_item(item) if @help_window
    @status_window.item = item if @status_window
  end
end