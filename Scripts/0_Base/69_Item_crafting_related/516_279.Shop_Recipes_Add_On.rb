# encoding: utf-8
# Name: 279.Shop Recipes Add On
# Size: 7914
#===============================================================================
# Crafting Script: Shop Recipes Add on                      updated: 07/07/2014
#  Author: Venka
#  REQUIRES Crafting Script
#===============================================================================
# - Change Log -
#------------------------------------------------------------------------------
# 07/07/2014 - Fixed some compatiability issues with the use of Tools.
# 05/29/2014 - Initial release of the add on script.
#------------------------------------------------------------------------------
# - Introduction -
#------------------------------------------------------------------------------
#  Allows you to buy/learn recipes from a shop.
#
#  Place this add on below the Crafting Script but above Main.
#------------------------------------------------------------------------------
# - Item Note Tags -
#------------------------------------------------------------------------------
#  Use the following format for the note tag in the item tab:
#     <recipe_id: x, y, z, ...>
#        x, y, z      - recipe ids taught when bought
#  
#  EXAMPLES:
#    <recipe_id: 1, 2>   - This would teach Recipe 1 (Bread) and 2 (Stew)
#    <recipe_id: 2>      - This would teach Recipe 2 (Stew)
#------------------------------------------------------------------------------
# - Compatiblity -
#------------------------------------------------------------------------------
# This script works with all other crafting scripts I've written, however, 
# there may be some complications if using it with the actor specific recipes.
# There isn't a way to buy an actor only recipe. Also you can buy a recipe if 
# an Actor knows it already. You can't buy a recipe if they party knows the 
# recipe. 
# 
# For example, in the demo, Eric learns alchemy recipes. You can buy them 
# from the merchant since Eric's recipes don't count as party recipes. If you 
# buy the book, then the party learns all the alchemy recipes and can craft 
# them even if Eric leaves the party. Once the book is bought, you won't ever 
# need to buy it again (nor will the merchant let you because it checks if 
# the recipe is known).
# 
# This script should work with most other scripts.
#==============================================================================
$imported ||= {}
#===============================================================================
# ■ Venka Module
#===============================================================================
module Venka::Crafting
  
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  # - Item Settings -
  #----------------------------------------------------------------------------
  # When you buy the recipe or recipe book from a merchant, would you like 
  # to keep a physical copy of the item in your inventory or discard the item
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  Keep_Item = true     # Set to true to keep the item. False will discard it.
  
#==============================================================================
#                          ♦ Edits end here!! ♦
#==============================================================================
  def self.imported?(script)
    unless $imported[:Venka_Crafting]
      raise("You must install Venka's Crafting script to use #{script}")
    end
  end
end
module Venka::Notetag
  RECIPE_ID = /<(?:RECIPE_ID|recipe_id):[ ](\d+(?:\s*,\s*\d+)*)>/i
end
# Checks to see if the main crafting script is installed.
Venka::Crafting.imported?("Shop Recipes Add on")
#==============================================================================
# ■ DataManager
#==============================================================================
module DataManager
  #----------------------------------------------------------------------------
  # ● alias method: load_database
  #----------------------------------------------------------------------------
  class <<self; alias load_database_venka_craft_shop load_database; end
  def self.load_database
    load_database_venka_craft_shop
    load_crafting_shop_notetags
  end
  #----------------------------------------------------------------------------
  # ○ new method: load_crafting_shop_notetags
  #----------------------------------------------------------------------------
  def self.load_crafting_shop_notetags
    groups = [$data_items, $data_weapons, $data_armors]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_shop_crafting_notetags
      end
    end
  end  
end
#==============================================================================
# ■ RPG::BaseItem
#==============================================================================
class RPG::BaseItem
  #----------------------------------------------------------------------------
  # ♦ Public Instance Variables
  #----------------------------------------------------------------------------
  attr_accessor :recipe_id
  #----------------------------------------------------------------------------
  # ○ new method: load_shop_crafting_notetags
  #----------------------------------------------------------------------------
  def load_shop_crafting_notetags
    @recipe_id = []
    self.note.split(/[\r\n]+/).each { |line|
      case line
      when Venka::Notetag::RECIPE_ID
        $1.scan(/\d+/).each{ |num| @recipe_id.push(num.to_i) if num.to_i >= 0 }
      end
    }
  end
end
#==============================================================================
# ■ Window_ShopNumber
#==============================================================================
class Window_ShopNumber < Window_Selectable
  #----------------------------------------------------------------------------
  # ● alias method: set
  #----------------------------------------------------------------------------
  alias venka_craft_shop_buy_recipe_set set
  def set(item, max, price, currency_unit = nil)
    venka_craft_shop_buy_recipe_set(item, max, price, currency_unit = nil)
    @max = (item.recipe_id == [] ? max : 1)
    refresh
  end
end
#==============================================================================
# ■ Window_ShopBuy
#==============================================================================
class Window_ShopBuy < Window_Selectable
  #----------------------------------------------------------------------------
  # ● alias method: enable?
  #----------------------------------------------------------------------------
  alias venka_craft_shop_buy_recipe_enable? enable?
  def enable?(item)
    if item.recipe_id == []
      # 아이템이 레시피를 가르쳐주지 않으면 원래의 방법을 따르십시오.
      venka_craft_shop_buy_recipe_enable?(item)
    else
      # 그렇지 않으면 레시피가 이미 알려져 있는지 확인하십시오.
      result = venka_craft_shop_buy_recipe_enable?(item)
      sell_recipe = false
      item.recipe_id.each do |id|
        sell_recipe = true unless $craft.known_recipes.include?(id)
      end
      result && sell_recipe
    end
  end
end
#==============================================================================
# ■ Scene_Shop
#==============================================================================
class Scene_Shop < Scene_MenuBase
  #----------------------------------------------------------------------------
  # ● alias method: do_buy
  #----------------------------------------------------------------------------
  alias venka_craft_shop_buy_recipe_do_buy do_buy
  def do_buy(number)
    venka_craft_shop_buy_recipe_do_buy(number)
    @item.recipe_id.each do |id|
      $craft.learn_recipe(id) unless $craft.known_recipes.include?(id)
    end
    if @item.recipe_id.size > 0
      $game_party.lose_item(@item, number) unless Venka::Crafting::Keep_Item
    end
  end
end