# encoding: utf-8
# Name: 278.Actor Specific Recipes
# Size: 11732
#===============================================================================
# Crafting Script: Actor Specific Recipes Add-on            updated: 07/21/2014
#  Author: Venka
#  REQUIRES Crafting Script
#===============================================================================
#------------------------------------------------------------------------------
# - Introduction -
#------------------------------------------------------------------------------
#  Allows actors/classes to learn recipes instead of the party knowning them. 
#  To use an Actor specific recipe, then must be in the party. Their recipes 
#  can be level specific as well (can be class or craft level based).
#  
#  For Example: Ralph can learn to make minor healing potions at level 2
#               and normal healing potions at level 10
#------------------------------------------------------------------------------
# - Actor and Class Note Tags -
#------------------------------------------------------------------------------
#  Use the following format for the note tag in the actor or class tab:
#    <recipe: recipe_id, req_level, craft_id (optional)>
#      recipe_id    - id of the recipe at "Recipes" in the main script
#      req_level    - the level required to learn this recipe
#      craft_id     - This is the ID of craft in the "Craft_Info" part of the 
#                     main script. (1 is cooking, 2 smithing, 3 alchemy, etc)
#                     If you use this part of the tag, then the req_level will 
#                     be the craft level required by the craft_id.
#                     For example, if the craft_id = 1, then it's using the 
#                     Cooking level to see when the recipe is learned.
#  
#  EXAMPLES:
#    <recipe: 1, 1>    - This would teach Recipe 1 (Bread) at level 1
#    <recipe: 2, 2, 1> - This would teach Recipe 2 (Stew) at Cooking level 2
#===============================================================================
$imported ||= {}
$imported[:Venka_Actor_Crafting] = true
#===============================================================================
# ■ Venka Module
#===============================================================================
module Venka::Crafting
  
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  # - Actor Recipe Access Setting -
  #----------------------------------------------------------------------------
  #  You can set how you want to access the actor's known recipes.
  #     :party     - the actor must have joined the party
  #     :active    - the actor must be in the active party
  #     :leader    - the actor must be the party leader
  #  NOTE: if there is a typo in any of the commands it will default to 
  #     leader mode. So if it's doing that to you when you don't want it to, 
  #     double check the command
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  Actor_Access = :active
  
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  # - Recipe Retainment Setting -
  #----------------------------------------------------------------------------
  # 배우가 레시피를 항상 기억하도록 하려면 true로 설정하세요.
  # 그들이 레벨을 잃어도. 잊은 경우 false로 설정합니다.
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  Retain_Recipes = true
  
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
  Actor_Recipes = /<(?:RECIPE|recipe):[ ](\d+(?:\s*,\s*\d+)*)>/i
end
# Checks to see if the main crafting script is installed.
Venka::Crafting.imported?("Actor Specific Recipes Add on")
#==============================================================================
# ■ DataManager
#==============================================================================
module DataManager
  #----------------------------------------------------------------------------
  # ● alias method: load_database
  #----------------------------------------------------------------------------
  class <<self; alias load_database_venka_craft load_database; end
  def self.load_database
    load_database_venka_craft
    load_crafting_notetags
  end
  #----------------------------------------------------------------------------
  # ○ new method: load_crafting_notetags
  #----------------------------------------------------------------------------
  def self.load_crafting_notetags
    groups = [$data_classes, $data_actors]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_crafting_notetags
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
  attr_accessor :recipes
  #----------------------------------------------------------------------------
  # ○ new method: load_crafting_notetags
  #----------------------------------------------------------------------------
  def load_crafting_notetags
    @recipes = []
    self.note.split(/[\r\n]+/).each { |line|
      info = []
      case line
      when Venka::Notetag::Actor_Recipes
        $1.scan(/\d+/).each { |num| info.push(num.to_i) if num.to_i > 0 }
        @recipes.push(info)
      end
    }
  end
end
#==============================================================================
# ■ Game_Actor
#==============================================================================
class Game_Actor < Game_Battler
  #----------------------------------------------------------------------------
  # ♦ Public Instance Variables
  #----------------------------------------------------------------------------
  attr_accessor :known_recipes                  # Actor's known recipes
  #----------------------------------------------------------------------------
  # ● alias method: setup
  #----------------------------------------------------------------------------
  alias venka_crafting_actor_setup setup
  def setup(actor_id)
    venka_crafting_actor_setup(actor_id)
    @known_recipes = []
    get_recipes
  end
  #----------------------------------------------------------------------------
  # ○ new method: get_recipes
  #----------------------------------------------------------------------------
  def get_recipes
    # Check class notetag recipes
    self.class.recipes.each do |recipe_info|
      compare_recipe(*recipe_info)
    end
    # Check actor notetag recipes
    actor.recipes.each do |recipe_info|
      compare_recipe(*recipe_info)
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: compare_recipe
  #----------------------------------------------------------------------------
  def compare_recipe(recipe_id, level_req, craft_type = nil)
    # Determine level type required and gets the current level
    level = craft_type ? $craft[craft_type].level : @level
    if @known_recipes.include?(recipe_id)
      # Forget the recipe if Retain_Recipes is set to false
      return if Venka::Crafting::Retain_Recipes
      forget_recipe(recipe_id) if level_req > level
    else
      # Learn the new recipe
      learn_recipe(recipe_id) if level_req <= level
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: learn_recipe
  #----------------------------------------------------------------------------
  def learn_recipe(recipe_id)
    unless @known_recipes.include?(recipe_id)
      @known_recipes.push(recipe_id)
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: forget_recipe
  #----------------------------------------------------------------------------
  def forget_recipe(recipe_id)
    @known_recipes.delete(recipe_id)
  end
  #----------------------------------------------------------------------------
  # ● alias method: level_up
  #----------------------------------------------------------------------------
  alias actor_craft_recipes_level_up level_up
  def level_up
    actor_craft_recipes_level_up
    get_recipes
  end
  #----------------------------------------------------------------------------
  # ● alias method: level_down
  #----------------------------------------------------------------------------
  alias actor_craft_recipes_level_down level_down
  def level_down
    actor_craft_recipes_level_down
    get_recipes
  end
end
#==============================================================================
# ■ Game_Craft_Info
#==============================================================================
class Game_Craft_Info
  #----------------------------------------------------------------------------
  # ● alias method: level_up
  #----------------------------------------------------------------------------
  alias actor_spec_craft_level_up level_up
  def level_up
    actor_spec_craft_level_up
    $game_party.members.each {|actor| actor.get_recipes}
  end
  #----------------------------------------------------------------------------
  # ○ new method: level_down
  #----------------------------------------------------------------------------
  alias actor_spec_craft_level_down level_down
  def level_down
    @level -= 1
    $game_party.members.each {|actor| actor.get_recipes}
  end
end
#==============================================================================
# ■ Recipe_List_Window
#==============================================================================
class Recipe_List_Window < Window_Command
  #----------------------------------------------------------------------------
  # ● upgraded method: make_command_list
  #----------------------------------------------------------------------------
  alias actor_spec_recipes_command_list make_command_list
  def make_command_list
    get_recipe_access
    actor_recipes
    actor_spec_recipes_command_list
  end
  #----------------------------------------------------------------------------
  # ○ new method: get_recipe_access
  #----------------------------------------------------------------------------
  def get_recipe_access
    @mode = []
    case Venka::Crafting::Actor_Access
    when :party  ;         @mode = $game_party.members
    when :active ;         @mode = $game_party.battle_members
    else         ;         @mode << $game_party.leader
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: actor_recipes
  #----------------------------------------------------------------------------
  def actor_recipes
    @recipes = $craft.known_recipes
    actor_recipes = []
    @mode.each do |actor|
      actor.known_recipes.each { |recipe_id| actor_recipes << recipe_id }
    end
    @recipes = @recipes ? @recipes + actor_recipes : actor_recipes
    @recipes = @recipes.uniq
  end
end