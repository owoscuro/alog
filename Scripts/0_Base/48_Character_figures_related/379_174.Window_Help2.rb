# encoding: utf-8
# Name: 174.Window_Help2
# Size: 2316
class Window_Help2 < Window_Base
  attr_accessor :item_color
  alias bm_base_init initialize
  def initialize(line_number = 3)
    bm_base_init(line_number)
  end
  
  def set_item_color(item)
    @item_color = normal_color
    @item_color = item_name_color
    return unless item.is_a?(RPG::BaseItem)         
    return unless $imported[:TH_ItemRarity] || $imported[:Vlue_WARandom]
    if $imported[:TH_ItemRarity]
      @item_color = item.rarity_colour
    elsif $imported[:Vlue_WARandom]
      if item.is_a?(RPG::Weapon) || item.is_a?(RPG::Armor)
        @item_color = item.color
      elsif !item.is_a?(RPG::Weapon) || !item.is_a?(RPG::Armor)
        @item_color = item_name_color
      end     
    end    
  end
  
  alias :bm_base_si2 :set_item
  def set_item(item)
    return bm_base_si2(item) unless BM::ADVANCED_HELP
    unless item; set_text("", nil) ; return; end
    #unless item; set_text("") ; return; end
    new_line = "\n"
    icon = BM::HELP_DISPLAY[0] ? '\i[' + item.icon_index.to_s + '] ' : ""
    name = BM::HELP_DISPLAY[1] ? item.name : ""
    desc = BM::HELP_DISPLAY[2] ? '\c[0]' + item.description : ""
    if item.is_a?(RPG::Weapon) || item.is_a?(RPG::Armor)
      weight = $imported["XAIL-INVENTORY-WEIGHT"] ? weight = " - Weight: #{item.weight}." : ""
      durability = $imported["XAIL-ITEM-DURABILITY"] ? durability = " - Durability: #{item.durability} / #{item.max_durability}." : ""
    else weight = ""; durability = ""
    end
    if BM::HELP_DISPLAY[3]
      if item.is_a?(RPG::Weapon) ; item_type = " (" + Vocab.weapon_types(item.wtype_id) + ")" end
      if item.is_a?(RPG::Armor) ; item_type = " (" + Vocab.armor_types(item.atype_id) + ")" end
      if item.is_a?(RPG::Skill) ; item_type = " (" + Vocab.skill_types(item.stype_id) + ")" end
    else; item_type = ""
    end
    item_text = icon + name + item_type.to_s + weight + durability + new_line + desc
    set_item_color(item)
    # item 추가
    #set_text(item_text)
    set_text(item_text, item)
  end
  
  def draw_text_ex(x, y, text)
    reset_font_settings
    text = convert_escape_characters(text)
    pos = {:x => x, :y => y, :new_x => x, :height => calc_line_height(text)}
    process_character(text.slice!(0, 1), text, pos) until text.empty?
  end
end