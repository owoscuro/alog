# encoding: utf-8
# Name: 276.Difficulty Settings
# Size: 12041
#===============================================================================
# Crafting Script: Difficulty Settings                      updated: 09/20/2014
#  Author: Venka
#  REQUIRES Crafting Script
#===============================================================================
$imported ||= {}
$imported[:CraftDifficulty_Addon] = true
#===============================================================================
# ■ Venka Module
#===============================================================================
module Venka::Crafting
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  # - Difficulty Settings - 
  #----------------------------------------------------------------------------
  # Below is a chart for the difficulty settings. It is set up this way:
  #        [ Level Ranges, Fail Rate, Color ],
  # Level Ranges is first column. This is a number range of levels above your 
  #     current crafting level to start giving fail rates to. You can use 
  #     negative numbers if you want to build in fail rates for recipes that 
  #     are at or below your current crafting level.
  # Fail Rate is the second column. This is the chance to fail at crafting an 
  #     item. You have a 50% chance of making the :failed_item or :pre_failed
  #     set up in your Recipes.
  # Color is the color of the recipes name in the list window. This is just a 
  #     visual clue on how hard a recipe will be to craft. You can use either 
  #     windowskin colors (0-31) or [r,b,g,a] values.
  # EXAMPLE1: [ 1..5,  20,  14 ], 
  #     This means any recipe 1 to 5 levels above your current crafting level 
  #     will have a 20% chance to fail (even on a successful craft when using 
  #     the :active craft feature). The recipe's name will also appear yellow 
  #     in the recipe list window.
  # EXAMPLE2: [ -5..5,  20,  14 ],
  #     This would be the same as above, but recipes 5 levels below or above 
  #     your current crafting level would have a 20% chance to fail.
  # 
  # NOTE: You can add as many entries as you need to the chart below. To use a 
  #     single level as a range you could do 1...2 or 1..1 both would only 
  #     make it a range of 1 level above your current crafting level.
  #     Also, any recipes that are higher in level then the highest level in 
  #     the chart will not be able to be crafted until you level up some more.
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  Craft_Scale = [
    # [ +Lvl Range, Rate, Color],
      [     1..5,    20,    14 ],
      [    6..10,    40, [255, 127, 0]],
      [   11..15,    60,    18 ],
      [   16..20,    80,    30 ],
    ] # <- DO NOT REMOVE
    
  # List window color of recipes that are too high level to be crafted.
  # The color can be a windowskin color (0-31) or a [R,G,B,A] color
  No_Craft_Color = [120, 120, 120]
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  # - Additional Recipes - 
  #----------------------------------------------------------------------------
  # These are just additional recipes used to demo this add on. Feel free to 
  # delete this section.
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
=begin
  Recipes[15] = {     # Iron Plate
    :recipe_type  => 2,          # Smithing Recipe
    :req_level    => 7,          # Level required to use this recipe
    :craft_time   => 200,        # Time it takes to make the item
    :earned_exp   => 100,        # Exp gained on success
    :crafted_item => [:a23, 1],  # Makes 1x Iron Plate
    :failed_item  => [:i36, 1],  # 1x Slag on failed attempt
    :ingredients  => [# 2x Iron Ore, 3x Leather Straps, 1x Hammer
                     [:i33, 2], [:i34, 3], [:w43, 1]
  ]} # <- DO NOT REMOVE
  Recipes[16] = {     # Mithril Plate
    :recipe_type  => 2,          # Smithing Recipe
    :req_level    => 13,         # Level required to use this recipe
    :craft_time   => 200,        # Time it takes to make the item
    :earned_exp   => 500,        # Exp gained on success
    :crafted_item => [:a24, 1],  # Makes 1x Mithril Plate
    :failed_item  => [:i36, 1],  # 1x Slag on failed attempt
    :ingredients  => [# 2x Iron Ore, 3x Leather Straps, 1x Hammer
                     [:i33, 2], [:i34, 3], [:w43, 1]
  ]} # <- DO NOT REMOVE
  Recipes[17] = {     # Dragon Plate
    :recipe_type  => 2,          # Smithing Recipe
    :req_level    => 18,         # Level required to use this recipe
    :craft_time   => 200,        # Time it takes to make the item
    :earned_exp   => 500,        # Exp gained on success
    :crafted_item => [:a25, 1],  # Makes 1x Dragon Plate
    :failed_item  => [:i36, 1],  # 1x Slag on failed attempt
    :ingredients  => [# 2x Iron Ore, 3x Leather Straps, 1x Hammer
                     [:i33, 2], [:i34, 3], [:w43, 1]
  ]} # <- DO NOT REMOVE
  Recipes[18] = {     # Dragon Armor
    :recipe_type  => 2,          # Smithing Recipe
    :req_level    => 22,         # Level required to use this recipe
    :craft_time   => 200,        # Time it takes to make the item
    :earned_exp   => 900,        # Exp gained on success
    :crafted_item => [:a35, 1],  # Makes 1x Dragon Armor
    :failed_item  => [:i36, 1],  # 1x Slag on failed attempt
    :ingredients  => [# 2x Iron Ore, 3x Leather Straps, 1x Hammer
                     [:i33, 2], [:i34, 3], [:w43, 1]
  ]} # <- DO NOT REMOVE
=end
end
#==============================================================================
# ■ Game_Craft_Info
#==============================================================================
class Game_Craft_Info
  #----------------------------------------------------------------------------
  # ○ new method: level_up
  #----------------------------------------------------------------------------
  def level_up
    @level += 1
    # Note to self: don't use a return method here for the actor specific add on
    if Venka::Crafting::Auto_Learn
      # Learn new recipes if auto learning is on
      Venka::Crafting::Recipes.each do |recipe_info|
        recipe_id = recipe_info[0]
        recipe    = recipe_info[1]
        recipe_lv = recipe[:req_level] ? recipe[:req_level] : 1
        learn_lv  = Venka::Crafting::Craft_Scale[-1][0].end + @level
        if recipe[:recipe_type] == @craft_id && recipe_lv <= learn_lv
          next if $craft.known_recipes.include?(recipe_id)
          $craft.learn_recipe(recipe_id) unless recipe[:auto_learn] == false
        end
      end
    end
  end
  #----------------------------------------------------------------------------
  # ○ overwrite method: level_down
  #----------------------------------------------------------------------------
  def level_down
    @level -= 1
  end
end
#==============================================================================
# ■ Game_Crafting   
#==============================================================================
class Game_Crafting
  #----------------------------------------------------------------------------
  # ○ overwrite method: init_recipes
  #----------------------------------------------------------------------------
  def init_recipes
    @known_recipes = []
    return unless Venka::Crafting::Auto_Learn
    crafts = Venka::Crafting::Craft_Info
    recipe_list = Venka::Crafting::Recipes
    crafts.each_key do |craft_id|
      recipe_list.each do |recipe_info|
        recipe    = recipe_info[1]
        recipe_lv = recipe[:req_level] ? recipe[:req_level] : 1
        learn_lv  = Venka::Crafting::Craft_Scale[-1][0].end + 1
        if recipe[:recipe_type] == craft_id && recipe_lv <= learn_lv
          recipe_id = recipe_info[0]
          learn_recipe(recipe_id) unless recipe[:auto_learn] == false
        end
      end
    end
  end
end
#==============================================================================
# ■ Recipe_List_Window
#==============================================================================
class Recipe_List_Window < Window_Command
  #----------------------------------------------------------------------------
  # ○ overwrite method: enabled?
  #----------------------------------------------------------------------------
  def enabled?(recipe)
    if SceneManager.scene_is?(Scene_Crafting) || SceneManager.scene_is?(Scene_Recipes)
      @max_level = Venka::Crafting::Craft_Scale[-1][0].end
      @max_level += $craft[@craft_id].level
      return false if recipe.req_level > @max_level
    end
    ingredients = recipe.ingredients
    required = recipe.ingredient_amount
    for i in 0...ingredients.size
      if ingredients[i].is_a?(Craft_Gold)
        owned = $game_party.gold
      else
        owned = $game_party.item_number(ingredients[i])
      end
      enabled = (owned < required[i] ? false : true)
      return false unless enabled
    end
    return enabled
  end
  #----------------------------------------------------------------------------
  # ● overwrite method: draw_item
  #----------------------------------------------------------------------------
  def draw_item(index)
    rect = item_rect_for_text(index)
    return unless @items[index]
    set_font(:recipe_list, @list[index][:enabled])
    item = @list[index][:name]
    set_recipe_name_color(@items[index], @list[index][:enabled])
    if $imported[:MAIcon_Hue]
      draw_icon_with_hue(item.icon_index, item.icon_hue, 
        rect.x + 1, rect.y, @list[index][:enabled])
    else
      draw_icon(item.icon_index, rect.x + 1, rect.y, @list[index][:enabled])
    end
    text = @items[index].display_name
    draw_text(rect.x + 26, rect.y, rect.width - 27, font_height, text)
  end
  #----------------------------------------------------------------------------
  # ○ new method: set_recipe_name_color
  #----------------------------------------------------------------------------
  def set_recipe_name_color(recipe, enabled)
    return if $imported[:Venka_ShopCrafters] && $craft.craft_shop
    lv = recipe.req_level - $craft[@craft_id].level
    Venka::Crafting::Craft_Scale.each do |info|
      color = info[2].is_a?(Integer) ? text_color(info[2]) : Color.new(*info[2])
      change_color(color, enabled) if info[0].include?(lv)
    end
    if lv > Venka::Crafting::Craft_Scale[-1][0].end
      color = Venka::Crafting::No_Craft_Color
      new_c = color.is_a?(Integer) ? text_color(color) : Color.new(*color)
      change_color(new_c, enabled)
    end
  end
end
#==============================================================================
# ■ Crafting_Details_Window
#==============================================================================
class Crafting_Details_Window
  #----------------------------------------------------------------------------
  # ○ overwrite method: current_item_enabled?
  #----------------------------------------------------------------------------
  def current_item_enabled?
    return false unless @recipe_id
    max_level = $craft[@craft_id].level + Craft_Scale[-1][0].end
    return false if @recipe.req_level > max_level
    return false if $game_party.item_number(@recipe.crafted_item) == 999
    return false if @ingredient_count != @ingredients.size
    return true
  end
  #----------------------------------------------------------------------------
  # ○ alias method: success_rewards
  #----------------------------------------------------------------------------
  alias :failure_chance_rewards :success_rewards
  def success_rewards
    lvl = $craft[@craft_id].level
    lvl_dif = @recipe.req_level - $craft[@craft_id].level
    chance = 100
    Craft_Scale.each {|info| chance = info[1] if info[0].include?(lvl_dif)}
    return failure_chance_rewards if chance >= 100
    rand(100) >= chance ? failure_chance_rewards : failed_rewards
  end
end