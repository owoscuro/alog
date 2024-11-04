# encoding: utf-8
# Name: 280.Shop Craft & Decompile
# Size: 71671
#===============================================================================
# Crafting Script: Shop Craft/Decompile Add on              updated: 12/03/2014
#  Author: Venka
#  REQUIRES Crafting Script
#===============================================================================
# - Change Log -
#------------------------------------------------------------------------------
# 12/03/2014 - Fixed notetag issue that was only scanning for one decon item.
# 10/14/2014 - Allowed to simple do a script call "craft_recipes" to make a 
#              deconstruction only shop (no crafting items or buying/selling).
# 09/20/2014 - Made some compatibility changes for the Actor Stat Changes Addon
# 09/18/2014 - Made update for compatibility for difficulty add-on
# 09/16/2014 - Made a new script call and scene so you can have shop crafters 
#              minus the buy/sell options.
# 09/02/2014 - Made the code more efficent for the Menu Add on.
#            - Allow you to set if shop fee is combined in the ingredient list
#              as a required item.
# 08/19/2014 - Fixed more issues with updating information with the craft shop
#            - Show shop fee again (oops)
#            - Fixed the shops charing 2x fees to craft items.
#            - Crafting shops will only show when the script call is used. It 
#              was staying craft shops 100% of the time after a script call.
# 08/16/2014 - Fixed issue where craft items weren't being created.
#            - Fixed double exp issue for normal crafting.
#            - Fixed a lot of issues with shops and gold fees
# 08/02/2014 - Added $imported tag to check if installed for stats add on
# 07/24/2014 - Made use of the font_height method for small fonts here.
#              Small fonts had the potential of messing up alignments.
# 07/22/2014 - Crafting at a shop was giving crafting exp.. OOPS! now fixed
# 07/21/2014 - Fixed error message when crafting recipes that require gold.
#            - Added display names for recipes
#            - Added ability to only use decon part of the shop
# 07/12/2014 - Lots of fixes to work with the release of 3.0. Crafting stacks, 
#              choice of craft times (none or timer)
#            - Fixed it so you can also use it as a normal shop to buy/sell 
#              items as well as enter the npc's crafting recipes and decon menu
# 06/13/2014 - Initial release of the add on script.
#------------------------------------------------------------------------------
# - Introduction -
#------------------------------------------------------------------------------
# This add on lets you use shop keepers to craft recipes for you at an added 
# cost. You can set a fee that will be required for each recipe or set a default
# flat fee the shop keeper will charge you to craft your item. The can also set 
# and inflation amount charges. For example, the Potion Recipe usually requires
# 1x Lizard Hearts and 1x Sea Shell. If you set the inflation rate to 0.5 (50%), 
# then it would cost 2x Lizard Hearts and 2x Sea Shell because it will round up.
# 
# These shop keepers can also decompile items for you. Perhaps you fund a hunk 
# of metal while adventuring. You could bring it to one of these shop keepers 
# and they could break it down into 2x Ore.
# 
#------------------------------------------------------------------------------
# - Item Note Tags -
#------------------------------------------------------------------------------
#  There's a few note tags you can use for the deconstruction of items.
#  
#  <decon item: x, y>       - x is the item ID and y is the amount you'll get
#  <decon weapon: x, y>     - x is the weapon ID and y is the amount you'll get
#  <decon armor: x, y>      - x is the armor ID and y is the amount you'll get
#  <decon fee: x>           - x is the amount of gold it costs to decon the item
#  <decon time: x>          - x is the time in frames to decon the item
#  
#  You can omit any or all of these. There is a default fee and time you can 
#  set in the customize section of this script.
#  
#------------------------------------------------------------------------------
# - Script Calls -
#------------------------------------------------------------------------------
# There are two script call options. You can use a shop crafting that will 
# give access to a shop where you can buy, sell, craft and decompile items all 
# from the same shop. For this type of shop use the following script call:
#   shop_recipes("Text", recipes)
#     "Text"  - The text shown in the shop to craft items. You can set it each 
#               time the scene is called. Incase you want a Baking Shop Keeper, 
#               a Smithing Shop Keeper, an Alchemy Shop Keeper, etc
#     recipes - this should be an array of recipe IDs that the shop keeper can 
#               craft for the player
#
# You can also just do a script call with "shop_recipes" without the recipes 
# and text to have NPCS deconstruct items without having the craft option.
#  
#   EXAMPLES: recipes = [3, 4, 5]
#             shop_recipes("Smith", recipes)
#   So this shop would use "Smith" as the crafting command and could craft
#   Cestus, Chain Mail, and Battle Axe.
# 
# 
# The other script call is to bring up a shop scene that only allows you to 
# crafting and/or decompile items but without the ability to buy and sell. It 
# follows all the same rules as the first script call but it has a different 
# name:
#   craft_recipes("Text", recipes)
#       -or-
#   craft_recipes     - for only decon (no crafting)
#==============================================================================
$imported ||= {}
$imported[:Venka_ShopCrafters] = true 
#===============================================================================
# ■ Venka Module
#===============================================================================
module Venka::Crafting
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  # - Shop Settings -
  #----------------------------------------------------------------------------
  # This settings will effect recipes that shop keepers can craft for you.
  # There's a few settings: 
  #   Default_Shop_Fee: just a default setting that shops will charge when
  #       crafting an item for you. This can be set for each recipe.
  #   Shop_Inflation: a bit more complicated. This number is a percetage.
  #       This is the inflation cost on the ingredients use to craft an item.
  #       A shop keeper may know recipes that you do not, but to craft at a 
  #       shop it costs more. So 0.5 would be a 50% increase in items required.
  #       This number rounds up so if a recipe only calls for 1 Iron Ore, it'd 
  #       now need 2 Iron Ore.
  #   Deconstruct: This is the text that will show in the shop for the 
  #       deconstructing items option
  #   Deconstruct_Fee: This is the default fee charged to deconstruct an item.
  #       to change an item's deconstruct fee use the <decon fee: x> notetag.
  #       where x is the amount to charge.
  #   Deconstruct_Time: This is the default deoncstruction time for items
  #       use the <decon time: x> note tag to change it
  #   Decon_Sound: This is the sound that will play while an item is being 
  #       deconstructed. It'll look first for the file in the Audio/BGS folder.
  #       It will then search in the Audio/SE folder. If it's a SE file, then 
  #       the sound will repeat every 2 seconds. Set to nil to disable.
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  Default_Shop_Fee  = 100        # Default charge fee for crafting at shops
  Shop_Inflation    = 0.5        # Inflation percentage on ingredients at shops
  Deconstruct  = "Deconstruct"   # Text show to deconstruct section of shops
  Deconstruct_Fee   = 200        # Default fee to deconstruct an item
  Deconstruct_Time  = 10         # Default deconstruction time in frames
  Decon_Sound = ["Darkness", 80, 100] # ["File_Name", Volume, Pitch]
  Shop_Fee = "Fee"               # Fee Header Text
  Combine_FeeCosts = true        # 공예 비용과 상점 수수료를 하나로 합치시겠습니까?
  Decon_Header = "Deconstructed Items:" # Header that says decon items
  Decon_Button_Text = "Break Down"      # Text show when ready to decon an item
  Craft_Category_Text = "Craft"  # Text for the crafting category in shops
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  # - Craft Shop Gauge Type Setting - 
  #----------------------------------------------------------------------------
  # This effects how the timer gauge will function in the craft shops. It can 
  # be set :timer or :none. 
  #   :timer  - This will be a bar to show progress made. The time on the bar 
  #             will be set to the craft_time for the recipe. There are no 
  #             failure items or key presses.. it's just a progress bar.
  #   :none   - Skip the gauge all togeather, instantly craft the item.
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  Shop_Timer = :timer             # Set to :timer or :none
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  # - Recipe Settings -
  #----------------------------------------------------------------------------
  # NOTE: Only use this area if you don't want to edit the recipes you already 
  # made in the main script. You can added a ":shop_fee => n," line to any of 
  # the recipes in the main script to create it's shop fee. See the updated 
  # notes in the main script for more information. -OR- you can just added the 
  # Changes here. Below is how to add a :shop_fee to Recipe[1]. I'll also add 
  # a shopfee to the smithing recipes here for more examples. If you want to 
  # just added them to the main script so all the recipe info is in one place, 
  # then delete all the Recipes[x][:shop_fee] = n entries you see here
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  Recipes[1][:shop_fee] = 20     # Loaf of Bread shop craft cost
#~   Recipes[3][:shop_fee] = 10     # Cestus shop craft cost
#~   Recipes[4][:shop_fee] = 50     # Chain Mail shop craft cost
#~   Recipes[5][:shop_fee] = 200    # Battle Axe shop craft cost
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
  Decon_Item   = /<decon item:\s*(\d+),\s*(\d+)>/i
  Decon_Weapon = /<decon weapon:\s*(\d+),\s*(\d+)>/i
  Decon_Armor  = /<decon armor:\s*(\d+),\s*(\d+)>/i
  Decon_Fee    = /<decon fee:\s*(\d+)>/i
  Decon_Time   = /<decon time:\s*(\d+)>/i
end
# Checks to see if the main crafting script is installed.
Venka::Crafting.imported?("Shop Recipes Add on")
#==============================================================================
# ■ RPG::BaseItem
#==============================================================================
class RPG::BaseItem
  #----------------------------------------------------------------------------
  # ○ new method: decon_rewards
  #----------------------------------------------------------------------------
  def decon_rewards
    @decon_rewards = Array.new(3) {Array.new}
    self.note.split(/[\r\n]+/).each { |line|
      info = []
      case line
      when Venka::Notetag::Decon_Item
        @decon_rewards[0] << [$1.to_i, $2.to_i] if [$1.to_i, $2.to_i]
      when Venka::Notetag::Decon_Armor
        @decon_rewards[1] << [$1.to_i, $2.to_i]
      when Venka::Notetag::Decon_Weapon
        @decon_rewards[2] << [$1.to_i, $2.to_i]
      end
    }
    @decon_rewards = nil if @decon_rewards.select {|info| !info.empty?} == []
    @decon_rewards
  end
  #----------------------------------------------------------------------------
  # ○ new method: decon_fee
  #----------------------------------------------------------------------------
  def decon_fee
    @decon_fee = Venka::Crafting::Deconstruct_Fee
    @decon_fee = $1.to_i if @note =~ Venka::Notetag::Decon_Fee
    @decon_fee
  end
  #----------------------------------------------------------------------------
  # ○ new method: decon_time
  #----------------------------------------------------------------------------
  def decon_time
    @decon_time = Venka::Crafting::Deconstruct_Time
    @decon_time = $1.to_i if @note =~ Venka::Notetag::Decon_Time
    @decon_time
  end
end
#==============================================================================
# ■ Game_Interpreter
#==============================================================================
class Game_Interpreter
  #----------------------------------------------------------------------------
  # ○ new method: shop_recipes
  #----------------------------------------------------------------------------
  def shop_recipes(text = "", recipes = nil)
    $craft.craft_shop = true
    $craft.set_craft_shop_info(text, recipes)
  end
  #----------------------------------------------------------------------------
  # ○ new method: craft_recipes
  #----------------------------------------------------------------------------
  def craft_recipes(text = nil, recipes = nil)
    $craft.craft_shop = true
    $craft.set_craft_shop_info(text, recipes)
    SceneManager.call(Craft_Shop)
  end
end
#==============================================================================
# ■ Game_Crafting
#==============================================================================
class Game_Crafting
  #----------------------------------------------------------------------------
  # ♦ Public Instance Variables
  #----------------------------------------------------------------------------
  attr_accessor  :craft_shop,       :shop_text,       :shop_recipes
  #----------------------------------------------------------------------------
  # ● alias method: initialize
  #----------------------------------------------------------------------------
  alias shop_crafting_ini initialize
  def initialize
    shop_crafting_ini
    @craft_shop   = false
    @shop_text    = ""
    @shop_recipes = nil
  end
  #----------------------------------------------------------------------------
  # ○ new method: set_craft_shop_info
  #----------------------------------------------------------------------------
  def set_craft_shop_info(text, recipes)
    @shop_text    = text
    @shop_recipes = recipes
  end
end
#==============================================================================
# ■ Game_Recipe
#==============================================================================
class Game_Recipe
  #----------------------------------------------------------------------------
  # ♦ Public Instance Variables
  #----------------------------------------------------------------------------
  attr_reader    :shop_fee
  #----------------------------------------------------------------------------
  # ● alias method: initialize
  #----------------------------------------------------------------------------
  alias shop_decon_gr_ini initialize
  def initialize(recipe_id)
    shop_decon_gr_ini(recipe_id)
    @shop_fee = @recipe[:shop_fee] ? @recipe[:shop_fee] : Venka::Crafting::Default_Shop_Fee
  end
end
#==============================================================================
# ■ Window_ShopCommand
#==============================================================================
class Window_ShopCommand < Window_HorzCommand
  #----------------------------------------------------------------------------
  # ● alias method: col_max
  #----------------------------------------------------------------------------
  alias craft_shop_col_max col_max
  def col_max
    $craft.craft_shop ? 3 : craft_shop_col_max if @purchase_only != true
    $craft.craft_shop ? 4 : craft_shop_col_max if @purchase_only == true
  end
  #----------------------------------------------------------------------------
  # ● overwrite method: make_command_list
  #----------------------------------------------------------------------------
  def make_command_list
    add_command(Vocab::ShopBuy,    :buy)
    # 판매 제거 실험
    #add_command(Vocab::ShopSell,   :sell, !@purchase_only)
    add_command(Venka::Crafting::Craft_Category_Text, :shop_craft) if $craft.craft_shop
    add_command(Vocab::ShopCancel, :cancel)
  end
end
#==============================================================================
# ■ Window_Craft_Command
#==============================================================================
class Window_Craft_Command < Window_HorzCommand
  #----------------------------------------------------------------------------
  # ● upgraded method: initialize
  #----------------------------------------------------------------------------
  def initialize(window_width, text, crafting = false)
    @window_width = window_width
    @text = text
    @crafting = crafting == [] ? false : true
    super(0, 0)
    deactivate
    hide
  end
  #----------------------------------------------------------------------------
  # ● window settings
  #----------------------------------------------------------------------------
  def window_width;    @window_width;                     end
  def col_max;         $craft.shop_recipes ? 3 : 2;       end
  #----------------------------------------------------------------------------
  # ● upgraded method: make_command_list
  #----------------------------------------------------------------------------
  def make_command_list
    add_command(@text, :recipe_list,    @crafting) if $craft.shop_recipes
    add_command(Venka::Crafting::Deconstruct,  :deconstruct)
    add_command(Vocab::ShopCancel,             :cancel)
  end
end
#==============================================================================
# ■ Recipe_List_Window
#==============================================================================
class Recipe_List_Window < Window_Command
  #----------------------------------------------------------------------------
  # ● alias method: initialize
  #----------------------------------------------------------------------------
  alias shop_crafters_list_win_ini initialize
  def initialize(x, y)
    shop_crafters_list_win_ini(x, y)
    deactivate if $craft.craft_shop
  end
  #----------------------------------------------------------------------------
  # ● alias method: window_height
  #----------------------------------------------------------------------------
  alias shop_window_height window_height
  def window_height
    shop_window_height - ($craft.craft_shop ? 72 : 0)
  end
  #----------------------------------------------------------------------------
  # ● alias method: make_command_list
  #----------------------------------------------------------------------------
  alias venka_shop_crafters_make_command_list make_command_list
  def make_command_list
    if $craft.craft_shop
      get_recipes
      sort_list
      @items.each do |item|
        add_command(item.crafted_item, item.recipe_id.to_s.to_sym, enabled?(item))
      end
    else
      venka_shop_crafters_make_command_list
    end
  end
  #----------------------------------------------------------------------------
  # ● alias method: get_recipes
  #----------------------------------------------------------------------------
  alias venka_shop_crafters_get_recipes get_recipes
  def get_recipes
    if $craft.craft_shop
      @recipes = $craft.shop_recipes
      @items = []
      @recipes.each { |recipe_id| @items << $recipe[recipe_id]} if @recipes
    else
      venka_shop_crafters_get_recipes
    end
  end
  #----------------------------------------------------------------------------
  # ● alias method: enabled?
  #----------------------------------------------------------------------------
  alias venka_craft_decompile_enabled? enabled?
  def enabled?(recipe)
    if $craft.craft_shop
      return false unless recipe
      return false if $game_party.item_number(recipe.crafted_item) == 999
      @ingredients = recipe.ingredients.clone
      add_shop_fee(recipe)
      for i in 0...@ingredients.size
        enabled = determine_required_ingredients(recipe, i)
        return false unless enabled
      end
      return true
    else
      venka_craft_decompile_enabled?(recipe)
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: add_shop_fee
  #----------------------------------------------------------------------------
  def add_shop_fee(recipe)
    @inflation = Venka::Crafting::Shop_Inflation
    @required = recipe.ingredient_amount.clone
    @gold_rec = false
    @ingredients.each {|item| @gold_rec = true if item.is_a?(Craft_Gold)}
    @ingredients << Craft_Gold.new unless @gold_rec
  end
  #----------------------------------------------------------------------------
  # ○ new method: determine_required_ingredients
  #----------------------------------------------------------------------------
  def determine_required_ingredients(recipe, i)
    @required << 0 unless @required[i]
    @required[i] += (@required[i] * @inflation).round unless @ingredients[i].tool
    if @ingredients[i].is_a?(Craft_Gold)
      owned = $game_party.gold
      @required[i] += recipe.shop_fee
      needed = @required[i]
    else
      owned = $game_party.item_number(@ingredients[i])
      needed = @required[i]
    end
    enabled = (owned >= needed)
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: update_help
  #----------------------------------------------------------------------------
  def update_help
    if @help_window
      @help_window.set_item(@items[@index].crafted_item) if @items != []
    end
  end
end
#==============================================================================
# ■ Crafting_Details_Window
#==============================================================================
class Crafting_Details_Window < Window_Command
  #----------------------------------------------------------------------------
  # ● alias method: window_height
  #----------------------------------------------------------------------------
  alias shop_window_height window_height
  def window_height
    shop_window_height - ($craft.craft_shop ? 72 : 0)
  end
  #----------------------------------------------------------------------------
  # ○ alias method: draw_level_required
  #----------------------------------------------------------------------------
  alias venka_shop_craft_decon_draw_level draw_level_required
  def draw_level_required(y, w)
    if $craft.craft_shop
      set_font(:header_text)
      tw = text_size(Shop_Fee).width + 5
      draw_text(contents.width - tw, y, tw, font_height, Shop_Fee, 2)
      set_font(:other_text)
      draw_text(contents.width - w, y, w - tw, font_height, @recipe.shop_fee, 2)
    else
      venka_shop_craft_decon_draw_level(y, w)
    end
  end
  #----------------------------------------------------------------------------
  # ○ alias method: draw_recipe_exp
  #----------------------------------------------------------------------------
  alias venka_shop_craft_decon_draw_exp draw_recipe_exp
  def draw_recipe_exp(y, w)
    return if $craft.craft_shop
    venka_shop_craft_decon_draw_exp(y, w)
  end
  #----------------------------------------------------------------------------
  # ○ alias method: draw_item_description
  #----------------------------------------------------------------------------
  alias shop_crafting_draw_item_description draw_item_description
  def draw_item_description(x, y, text)
    return if $craft.craft_shop
    shop_crafting_draw_item_description(x + 4, y, text)
  end
  #----------------------------------------------------------------------------
  # ○ overwrite method: draw_ingredients
  #----------------------------------------------------------------------------
  def draw_ingredients
    @ingredients = @recipe.ingredients.clone
    @required = @recipe.ingredient_amount.clone
    add_shop_fee if $craft.craft_shop
    for i in 0...@ingredients.size
      ingredient = determine_required_ingredients(@ingredients[i], i)
      @max = [[@max, ingredient[3]].min, 1].max
      set_font(:other_text, ingredient[2])
      if $imported[:MAIcon_Hue]
        draw_icon_with_hue(@ingredients[i].icon_index, @ingredients[i].icon_hue, 
          8, @y + 6, ingredient[2])
      else
        draw_icon(@ingredients[i].icon_index, 8, @y + 6, ingredient[2])
      end
      draw_text(38, @y + 6, contents.width - @w - 45, font_height, @ingredients[i].name)
      text = "×#{ingredient[1]} / ×#{ingredient[0]}"
      #draw_text(contents.width - @w, @y + 6, @w, font_height, text, 2)
      draw_text(contents.width/2-10, @y + 6, contents.width/2, font_height, text, 2)
      @y += font_height
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: add_shop_fee
  #----------------------------------------------------------------------------
  def add_shop_fee
    return unless $craft.craft_shop
    @req_gold = @recipe.shop_fee
    @inflation = $craft.craft_shop ? Shop_Inflation : 0
    @gold_rec = false
    @ingredients.each {|item| @gold_rec = true if item.is_a?(Craft_Gold)}
    if !@gold_rec && Combine_FeeCosts
      @ingredients << Craft_Gold.new
      @required << 0
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: determine_required_ingredients
  #----------------------------------------------------------------------------
  alias venka_shop_decon_req_ingredients determine_required_ingredients
  def determine_required_ingredients(ingredient, i)
    if $craft.craft_shop
      @required[i] += (@required[i] * @inflation).round unless ingredient.tool
      max_stacks = 999
      if ingredient.is_a?(Craft_Gold)
        owned = $game_party.gold
        @required[i] += @recipe.shop_fee if Combine_FeeCosts
        needed = @required[i] * @number
      else
        multiplier = ingredient.tool ? 1 : @number
        owned = $game_party.item_number(ingredient)
        needed = @required[i] * multiplier
      end
      enabled = (owned < needed ? false : @ingredient_count += 1)
      max_stacks = (owned / @required[i]).to_i if @required[i] > 0
      max_stacks = 999 if ingredient.tool
      results = [owned, needed, enabled, max_stacks]
    else
      results = venka_shop_decon_req_ingredients(ingredient, i)
    end
    results
  end
  #----------------------------------------------------------------------------
  # ○ overwrite method: current_item_enabled?
  #----------------------------------------------------------------------------
  alias :shop_crafting_item_enabled? :current_item_enabled?
  def current_item_enabled?
    if $craft.craft_shop
      return false unless @recipe_id
      return false if $game_party.item_number(@recipe.crafted_item) == 999
      return false if @ingredient_count != @ingredients.size
      return true
    else
      shop_crafting_item_enabled?
    end
  end
  #----------------------------------------------------------------------------
  # ○ alias method: start_crafting
  #----------------------------------------------------------------------------
  alias shop_crafting_start_crafting start_crafting
  def start_crafting
    if $craft.craft_shop
      @result_item = nil
      @elapsed = 0
      @success = true
      @started = true
      @timer   = 120
      @max_time = @recipe.craft_time * @number
    else
      shop_crafting_start_crafting
    end
  end
  #----------------------------------------------------------------------------
  # ● alias method: update_craft_bar   
  #----------------------------------------------------------------------------
  alias venka_decon_craft_bar update_craft_bar
  def update_craft_bar
    if $craft.craft_shop
      Graphics.update
      Input.update
      activate_craft
      if Venka::Crafting::Shop_Timer == :none
        rewards
      else
        rewards if @elapsed >= @max_time
      end
    else
      venka_decon_craft_bar
    end
  end
  #----------------------------------------------------------------------------
  # ● alias method: activate_craft
  #----------------------------------------------------------------------------
  alias venka_decompile_activate_craft activate_craft
  def activate_craft
    if $craft.craft_shop
      return if Venka::Crafting::Shop_Timer == :none
      play_sound
      rect = item_rect(index)
      unselect
      contents.clear_rect(rect)
      rate = [@elapsed.to_f / @max_time, 1.0].min
      gc1 = get_color(Craft_Gauge_Color1)
      gc2 = get_color(Craft_Gauge_Color2)
      draw_gauge(rect.x, rect.y, rect.width, rate, gc1, gc2)
      @elapsed += 1
    else
      venka_decompile_activate_craft
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: rewards
  #----------------------------------------------------------------------------
  alias shop_crafting_rewards rewards
  def rewards
    $game_party.lose_gold(@recipe.shop_fee * @number) unless Combine_FeeCosts
    shop_crafting_rewards
  end
  #----------------------------------------------------------------------------
  # ● alias method: success_rewards
  #----------------------------------------------------------------------------
  alias :craft_shop_success_rewards :success_rewards
  def success_rewards
    if $craft.craft_shop
      RPG::SE.new(*Success_Sound).play
      @result_item    = @recipe.crafted_item
      @result_amount  = @recipe.crafted_amount * @number
      $game_party.gain_item(@result_item, @result_amount)
    else
      craft_shop_success_rewards
    end
  end
end
#==============================================================================
# ■ Decon_List_Window
#==============================================================================
class Decon_List_Window < Window_Command
  #----------------------------------------------------------------------------
  # ♦ Public Instance Variables
  #----------------------------------------------------------------------------
  attr_reader   :decon_window
  #----------------------------------------------------------------------------
  # ● upgraded method: initialize
  #----------------------------------------------------------------------------
  def initialize
    collect_items
    super(0, 120)
    deactivate
    hide
  end
  #----------------------------------------------------------------------------
  # ● window_settings
  #----------------------------------------------------------------------------
  def window_width;      return 190;                       end
  def window_height;     return Graphics.height - 120;     end
  #----------------------------------------------------------------------------
  # ○ new method: collect_items
  #----------------------------------------------------------------------------
  def collect_items
    @decon_items = []
    $game_party.all_items.each do |item|
      @decon_items << item if item.decon_rewards
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: decon_window
  #----------------------------------------------------------------------------
  def decon_window=(decon_window)
    @decon_window = decon_window
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: make_command_list
  #----------------------------------------------------------------------------
  def make_command_list
    collect_items
    return if @decon_items == []
    @decon_items.each do |item|
      add_command(item.name, item.name.to_sym, enabled?(item))
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: enabled?
  #----------------------------------------------------------------------------
  def enabled?(item)
    $game_party.has_item?(item) && $game_party.gold >= item.decon_fee
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: draw_item
  #----------------------------------------------------------------------------
  def draw_item(index)
    rect = item_rect_for_text(index)
    return unless @list[index]
    set_font(:recipe_list, @list[index][:enabled])
    item = @decon_items[index]
    if $imported[:MAIcon_Hue]
      draw_icon_with_hue(item.icon_index, item.icon_hue, rect.x, rect.yy)
    else
      draw_icon(item.icon_index, rect.x, rect.y)
    end
    # 아이템 이름 좌표 수정 실험
    draw_text(rect.x + 25 + 5, rect.y, rect.width - 25, font_height, item.name)
  end
  #----------------------------------------------------------------------------
  # ○ new method: item
  #----------------------------------------------------------------------------
  def item
    @decon_items && index >= 0 ? @decon_items[index] : nil
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: update_help
  #----------------------------------------------------------------------------
  def update_help
    return unless item
    @help_window.set_item(item)
    @decon_window.set_item(item)
  end
end
#==============================================================================
# ■ Decon_Window
#==============================================================================
class Decon_Window < Window_Command
  #----------------------------------------------------------------------------
  # ♦ Public Instance Variables
  #----------------------------------------------------------------------------
  attr_reader      :started
  #----------------------------------------------------------------------------
  # ● upgraded method: initialize
  #----------------------------------------------------------------------------
  def initialize
    super(190, 120)
    @button_text = Venka::Crafting::Decon_Button_Text
    @started = false
    @number  = 1
    unselect
    deactivate
    hide
  end
  #----------------------------------------------------------------------------
  # ● window settings
  #----------------------------------------------------------------------------
  def window_width;           Graphics.width - 190;              end
  def window_height;          Graphics.height - 120;             end
  def item_max;               return 1;                          end
  def contents_height;        height - standard_padding * 2;     end
  def update_padding_bottom;  self.padding_bottom = 0;           end
  #----------------------------------------------------------------------------
  # ● upgraded method: item_height
  #----------------------------------------------------------------------------
  def item_height
    font = Venka::Crafting::Fonts
    if Venka::Crafting::Craft_Stacks
      font[:button_text][1] + [24, font[:recipe_name][1], font[:other_text][1]].max
    else
      font[:button_text][1]
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: set_item
  #----------------------------------------------------------------------------
  def set_item(item)
    if item != @item
      @item = item
      @fee = @item.decon_fee
      refresh
    end
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: make_command_list
  #----------------------------------------------------------------------------
  def make_command_list
    add_command(@button_text, :start_decon, enabled?)
  end
  #----------------------------------------------------------------------------
  # ○ new method: enabled?
  #----------------------------------------------------------------------------
  def enabled?
    $game_party.has_item?(@item) && $game_party.gold >= @fee
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: item_rect
  #----------------------------------------------------------------------------
  def item_rect(index)
    rect = super(index)
    rect.y = contents.height - item_height
    return rect
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_item
  #----------------------------------------------------------------------------
  def draw_item(index)
    rect = item_rect_for_text(index)
    set_font(:button_text, @list[index][:enabled])
    draw_text(rect.x, rect.y, rect.width, font_height, @button_text, 1)
    if Venka::Crafting::Craft_Stacks
      draw_craft_number(rect.width/2, rect.y + font_height, rect.width, 
            rect.height - font_height)
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_craft_number
  #----------------------------------------------------------------------------
  def draw_craft_number(x, y, w, h)
    return unless @item
    # Set font to get true width of the string
    set_font(:recipe_name, enabled?)
    item_width = text_size("×#{@item.name}").width + 5
    set_font(:other_text, enabled?)
    num_width  = text_size("×#{@number}").width + 5
    # Funky math to get how to center the string
    x -= (num_width + item_width + 24) * 0.5
    draw_text(x, y, w, h, "×#{@number}")
    x += num_width
    if $imported && $imported[:MAIcon_Hue]
      draw_icon_with_hue(@item.icon_index, @item.icon_hue, x, y, enabled)
    else
      draw_icon(@item.icon_index, x, y)
    end
    x += 24
    set_font(:recipe_name, enabled?)
    draw_text(x, y, w, h, @item.name)
  end
  #----------------------------------------------------------------------------
  # ○ new method: update_number
  #----------------------------------------------------------------------------
  def update_number
    change_number(1)   if Input.repeat?(:RIGHT)
    change_number(-1)  if Input.repeat?(:LEFT)
    change_number(10)  if Input.repeat?(:UP)
    change_number(-10) if Input.repeat?(:DOWN)
  end
  #----------------------------------------------------------------------------
  # ○ new method: change_number
  #----------------------------------------------------------------------------
  def change_number(amount)
    @number = [[@number + amount, @max].min, 1].max
    Sound.play_cursor
    refresh
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: refresh
  #----------------------------------------------------------------------------
  def refresh
    contents.clear
    super
    return unless @item
    @max = [[999, $game_party.item_number(@item)].min, 1].max
    @fee = @item.decon_fee * @number
    width = contents.width
    @y = 0
    draw_header(0, @y, width)
    draw_line(@y)
    @y += 3
    draw_items(0, @y, width)
    #draw_line(@y + 5)
    #@y += 3
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_header
  #----------------------------------------------------------------------------
  def draw_header(x, y, w)
    set_font(:recipe_name)
    h1 = contents.font.size
    if $imported[:MAIcon_Hue]
      draw_icon_with_hue(@item.icon_index, @item.icon_hue, x, y)
    else
      draw_icon(@item.icon_index, x, y)
    end
    draw_text(x + 25, y, w - 150, h1, @item.name)
    set_font(:header_text)
    h2 = contents.font.size;    @y += h1
    tw = text_size(Venka::Crafting::Shop_Fee).width + 5
    draw_text(contents.width - tw, y, tw, font_height, Venka::Crafting::Shop_Fee, 2)
    draw_text(x, @y, w, h2, Venka::Crafting::Possessed_Text)
    width = text_size(Venka::Crafting::Possessed_Text).width + 5
    set_font(:other_text)
    h3 = contents.font.size
    draw_text(contents.width - w, y, w - tw, font_height, @fee, 2)
    owned = sprintf("×%2d", $game_party.item_number(@item))
    draw_text(x + width, @y, 50, h3, owned)
    @y += [h2, h3].max + 5
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_items
  #----------------------------------------------------------------------------
  def draw_items(x, y, width)
    set_font(:header_text)
    draw_text(x, y, width, contents.font.size, Venka::Crafting::Decon_Header)
    @y += font_height
    set_font(:other_text)
    @item.decon_rewards.each_with_index do |items, i|
      next if items.empty?
      items.each do |decon_item|
        case i
        when 0;      item = $data_items[decon_item[0]]
        when 1;      item = $data_armors[decon_item[0]]
        when 2;      item = $data_weapons[decon_item[0]]
        end
        draw_text(x, @y, 30, font_height, "×#{decon_item[1] * @number}")
        draw_item_name(item, x + 30, @y, true, width)
        @y += font_height
      end
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: start_decon_gauge
  #----------------------------------------------------------------------------
  def start_decon_gauge
    @decon_time = @item.decon_time * @number
    @elapsed    = 0
    @started    = true
    @timer      = 120
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: update
  #----------------------------------------------------------------------------
  def update
    super
    update_number if Venka::Crafting::Craft_Stacks && self.active == true
    update_craft_bar while @started
  end
  #----------------------------------------------------------------------------
  # ○ new method: update_craft_bar
  #----------------------------------------------------------------------------
  def update_craft_bar
    Graphics.update
    Input.update
    activate_craft
    if Venka::Crafting::Shop_Timer == :none
      @success = true
      rewards
    end
    rewards if @elapsed >= @decon_time
  end
  #----------------------------------------------------------------------------
  # ○ new method: activate_craft
  #----------------------------------------------------------------------------
  def activate_craft
    return if Venka::Crafting::Shop_Timer == :none
    play_sound
    rect = item_rect(index)
    unselect
    contents.clear_rect(rect)
    rate = [@elapsed.to_f / @decon_time, 1.0].min
    gc1 = get_color(Venka::Crafting::Craft_Gauge_Color1)
    gc2 = get_color(Venka::Crafting::Craft_Gauge_Color2)
    draw_gauge(rect.x, rect.y, rect.width, rate, gc1, gc2)
    @elapsed += 1
  end
  #----------------------------------------------------------------------------
  # ○ new method: play_sound
  #----------------------------------------------------------------------------
  def play_sound
    return unless Venka::Crafting::Decon_Sound
    file_info = Venka::Crafting::Decon_Sound
    begin
      RPG::BGS.new(*file_info).play
    rescue
      RPG::SE.new(*file_info).play if @timer == 120
      @timer -= 1  if @timer > 0
      @timer = 120 if @timer == 0
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: rewards
  #----------------------------------------------------------------------------
  def rewards
    RPG::BGS.stop
    RPG::SE.new(*Venka::Crafting::Success_Sound).play
    @started = false
    $game_party.lose_item(@item, @number)
    @item.decon_rewards.each_with_index do |items, i|
      next if items.empty?
      items.each do |decon_item|
        case i
        when 0;      item = $data_items[decon_item[0]]
        when 1;      item = $data_armors[decon_item[0]]
        when 2;      item = $data_weapons[decon_item[0]]
        end
        $game_party.gain_item(item, decon_item[1] * @number)
      end
    end
    $game_party.lose_gold(@fee)
    refresh
  end
end
#==============================================================================
# ■ Scene_Shop
#==============================================================================
class Scene_Shop < Scene_MenuBase
  #----------------------------------------------------------------------------
  # ● alias method: start
  #----------------------------------------------------------------------------
  alias venka_shop_crafters_start start
  def start
    venka_shop_crafters_start
    return unless $craft.craft_shop
    create_craft_commands
    create_recipe_list_window
    create_detail_window
    create_decon_list_window
    create_decon_window
    if $imported[:CraftingStats_Addon]
      create_stats_window
      create_confirm_window
    end
  end
  #----------------------------------------------------------------------------
  # ● alias method: create_command_window
  #----------------------------------------------------------------------------
  alias venka_shop_crafters_create_command_window create_command_window
  def create_command_window
    venka_shop_crafters_create_command_window
    @command_window.set_handler(:shop_craft,    method(:craft_options))
  end
  #----------------------------------------------------------------------------
  # ● alias method: on_number_ok
  #----------------------------------------------------------------------------
  alias venka_decon_shop_on_number_ok on_number_ok
  def on_number_ok
    venka_decon_shop_on_number_ok
    refresh_shop_windows
  end
  #----------------------------------------------------------------------------
  # ○ new method: craft_options
  #----------------------------------------------------------------------------
  def craft_options
    @craft_command_window.show.activate.select(0)
    @command_window.hide
  end
  #----------------------------------------------------------------------------
  # ○ new method: create_craft_commands
  #----------------------------------------------------------------------------
  def create_craft_commands
    @craft_command_window = Window_Craft_Command.new(@gold_window.x, $craft.shop_text)
    @craft_command_window.viewport = @viewport
    @craft_command_window.y = @help_window.height
    @craft_command_window.set_handler(:recipe_list,  method(:command_craft))
    @craft_command_window.set_handler(:deconstruct,  method(:command_deconstruct))
    @craft_command_window.set_handler(:cancel,       method(:return_command))
  end
  #----------------------------------------------------------------------------
  # ○ new method: command_craft
  #----------------------------------------------------------------------------
  def command_craft
    @recipe_list.refresh
    @detail_window.refresh
    @recipe_list.show.activate
    @detail_window.show
    @dummy_window.hide
  end
  #----------------------------------------------------------------------------
  # ○ new method: command_deconstruct
  #----------------------------------------------------------------------------
  def command_deconstruct
    @decon_list.show.activate
    @decon_window.show
    @dummy_window.hide
  end
  #----------------------------------------------------------------------------
  # ○ new method: return_command
  #----------------------------------------------------------------------------
  def return_command
    @command_window.show.activate
    @craft_command_window.hide
  end
  #----------------------------------------------------------------------------
  # ○ new method: create_recipe_list_window
  #----------------------------------------------------------------------------
  def create_recipe_list_window
    @recipe_list = Recipe_List_Window.new(0, 120)
    @recipe_list.deactivate.hide
    @recipe_list.viewport = @viewport
    @recipe_list.help_window = @help_window
    @recipe_list.set_handler(:ok,      method(:to_detail_window))
    @recipe_list.set_handler(:cancel,  method(:craft_commands))
  end
  #----------------------------------------------------------------------------
  # ○ new method: to_detail_window
  #----------------------------------------------------------------------------
  def to_detail_window
    @detail_window.activate.select(0)
  end
  #----------------------------------------------------------------------------
  # ○ new method: craft_commands
  #----------------------------------------------------------------------------
  def craft_commands
    @recipe_list.hide.deactivate
    @detail_window.hide.deactivate
    @decon_list.hide.deactivate
    @decon_window.hide.deactivate
    @help_window.clear
    @craft_command_window.activate
    @dummy_window.show
  end
  #----------------------------------------------------------------------------
  # ○ new method: create_detail_window
  #----------------------------------------------------------------------------
  def create_detail_window
    @detail_window = Crafting_Details_Window.new
    @detail_window.y = 120
    @detail_window.viewport  = @viewport
    @detail_window.deactivate.hide
    @detail_window.set_handler(:craft,      method(:craft_start))
    @detail_window.set_handler(:cancel,     method(:return_to_list))
    @recipe_list.detail_window = @detail_window
  end
  #----------------------------------------------------------------------------
  # ○ new method: craft_start
  #----------------------------------------------------------------------------
  def craft_start
    Sound.play_ok
    @detail_window.start_crafting
    while @detail_window.started
      Graphics.update
      Input.update
      update
    end
    refresh_shop_windows
    to_detail_window
  end
  #----------------------------------------------------------------------------
  # ○ new method: return_to_list
  #----------------------------------------------------------------------------
  def return_to_list
    Sound.play_cancel
    @detail_window.unselect
    @recipe_list.activate
  end
  #----------------------------------------------------------------------------
  # ○ new method: create_decon_list_window
  #----------------------------------------------------------------------------
  def create_decon_list_window
    @decon_list = Decon_List_Window.new
    @decon_list.viewport = @viewport
    @decon_list.help_window = @help_window
    @decon_list.set_handler(:ok,      method(:to_decon_window))
    @decon_list.set_handler(:cancel,  method(:craft_commands))
  end
  #----------------------------------------------------------------------------
  # ○ new method: to_decon_window
  #----------------------------------------------------------------------------
  def to_decon_window
    @decon_window.activate.select(0)
  end
  #----------------------------------------------------------------------------
  # ○ new method: create_decon_window
  #----------------------------------------------------------------------------
  def create_decon_window
    @decon_window = Decon_Window.new
    @decon_window.viewport = @viewport
    @decon_window.set_handler(:start_decon,   method(:decon_start))
    @decon_window.set_handler(:cancel,        method(:to_decon_list))
    @decon_list.decon_window = @decon_window
  end
  #----------------------------------------------------------------------------
  # ○ new method: decon_start
  #----------------------------------------------------------------------------
  def decon_start
    Sound.play_ok
    @decon_window.start_decon_gauge
    while @decon_window.started
      Graphics.update
      Input.update
      update
    end
    refresh_shop_windows
    to_decon_window
  end
  #----------------------------------------------------------------------------
  # ○ new method: decon_start
  #----------------------------------------------------------------------------
  def refresh_shop_windows
    return unless @recipe_list
    @decon_list.refresh
    @decon_window.refresh
    @recipe_list.refresh
    @detail_window.refresh
    @gold_window.refresh
  end
  #----------------------------------------------------------------------------
  # ○ new method: to_decon_list
  #----------------------------------------------------------------------------
  def to_decon_list
    @decon_window.unselect
    @decon_list.activate
  end
  #----------------------------------------------------------------------------
  # ○ new method: create_stats_window
  #----------------------------------------------------------------------------
  def create_stats_window
    @stats_window = Window_CraftStats.new
    @stats_window.set_handler(:ok,      method(:command_confirm))
    @stats_window.set_handler(:cancel,  method(:return_to_details))
    @stats_window.viewport = @viewport
    @stats_window.list_window = @recipe_list
  end
  #----------------------------------------------------------------------------
  # ○ new method: command_confirm
  #----------------------------------------------------------------------------
  def command_confirm
    @actor = $game_party.members[@stats_window.index]
    @confirm_window.actor = @actor
    @confirm_window.refresh
    @confirm_window.activate
  end
  #----------------------------------------------------------------------------
  # ○ new method: return_to_details
  #----------------------------------------------------------------------------
  def return_to_details
    @details ? @detail_window.activate : @recipe_list.activate
  end
  #----------------------------------------------------------------------------
  # ○ new method: create_confirm_window
  #----------------------------------------------------------------------------
  def create_confirm_window
    @confirm_window = Crafting_Confirmation_Window.new
    @confirm_window.viewport = @viewport
    @confirm_window.set_handler(:ok,      method(:craft_and_equip))
    @confirm_window.set_handler(:cancel,  method(:return_to_stats))
  end
  #----------------------------------------------------------------------------
  # ○ new method: craft_and_equip
  #----------------------------------------------------------------------------
  def craft_and_equip
    return return_to_stats if !@recipe_list.command_enabled?(@recipe_list.index)
    @confirm_window.hide
    @stats_window.close.hide
    @detail_window.number = 1
    @detail_window.refresh
    craft_start
    item = $craft.results[1][2]
    gear = item.is_a?(Array) ? item[0] : item
    equip_item(@actor, gear)
    @stats_window.refresh
    return_to_stats
  end
  #----------------------------------------------------------------------------
  # ○ new method: equip_item
  #----------------------------------------------------------------------------
  def equip_item(actor, item)
    return unless actor.equippable?(item)
    slot_id = item.etype_id
    if $imported["YEA-AceEquipEngine"]
      actor.equip_slots.each_with_index do |etype, i| 
        slot_id = i if etype == gear.etype_id 
      end
    end
    actor.change_equip(slot_id, item)
  end
  #----------------------------------------------------------------------------
  # ○ new method: return_to_stats
  #----------------------------------------------------------------------------
  def return_to_stats
    @confirm_window.hide
    @stats_window.activate
  end
  #----------------------------------------------------------------------------
  # ○ new method: open_stats_window
  #----------------------------------------------------------------------------
  def open_stats_window
    @details = false
    if @detail_window.active
      @detail_window.deactivate
      @details = true
    else
      @recipe_list.deactivate
    end
    @stats_window.show.open
    @stats_window.activate
  end
  #--------------------------------------------------------------------------
  # 상세 데이터 설명창 추가
  #--------------------------------------------------------------------------
  def create_craft_description_window
    @description_window = Window_ItemDescription.new
    @description_window.z = 2010
    on_craft_item_description
    @description_window.set_handler(:ok,     method(:on_craft_description_ok))
    @description_window.set_handler(:cancel, method(:on_craft_description_cancel))
  end
  def on_craft_description_ok
    craft_hide_sub_window(@description_window)
    #@description_window = nil
  end
  def on_craft_description_cancel
    Sound.play_cancel
    craft_hide_sub_window(@description_window)
    #@description_window = nil
  end
  def on_craft_item_description
    @description_window.refresh(@status_window.item)
    show_sub_window(@description_window)
  end
  def craft_show_sub_window(window)
    @title_window.hide
    @detail_window.hide.deactivate
    @list_window.hide.deactivate
    window.show.activate
  end
  def craft_hide_sub_window(window)
    window.hide.deactivate
    @title_window.show
    @detail_window.show.activate
    @list_window.show.activate
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: update
  #----------------------------------------------------------------------------
  def update
    super
    if @detail_window && @recipe_list && $imported[:CraftingStats_Addon]
      if @detail_window.active || @recipe_list.active
        #--------------------------------------------------------------------------
        # 상세 데이터 설명창 추가
        #--------------------------------------------------------------------------
        create_craft_description_window if Input.trigger?(Venka::Crafting::Trigger_Key)
        #--------------------------------------------------------------------------
        #open_stats_window if Input.trigger?(Venka::Crafting::Trigger_Key)
      end
    end
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: terminate
  #----------------------------------------------------------------------------
  def terminate
    super
    $craft.craft_shop = false
  end
end
#==============================================================================
# ■ Craft_Shop
#==============================================================================
class Craft_Shop < Scene_MenuBase
  #----------------------------------------------------------------------------
  # ● upgrade method: start
  #----------------------------------------------------------------------------
  def start
    super
    create_all_windows
  end
  #----------------------------------------------------------------------------
  # ○ new method: to_decon_list
  #----------------------------------------------------------------------------
  def create_all_windows
    create_help_window
    create_gold_window
    create_craft_commands
    create_dummy_window
    create_recipe_list_window
    create_detail_window
    create_decon_list_window
    create_decon_window
    if $imported[:CraftingStats_Addon] && $craft.craft_shop
      create_stats_window
      create_confirm_window
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: to_decon_list
  #----------------------------------------------------------------------------
  def create_gold_window
    @gold_window = Window_Gold.new
    @gold_window.viewport = @viewport
    @gold_window.x = Graphics.width - @gold_window.width
    @gold_window.y = @help_window.height
  end
  #----------------------------------------------------------------------------
  # ○ new method: create_craft_commands
  #----------------------------------------------------------------------------
  def create_dummy_window
    wy = @command_window.y + @command_window.height
    wh = Graphics.height - wy
    @dummy_window = Window_Base.new(0, wy, Graphics.width, wh)
    @dummy_window.viewport = @viewport
  end
  #----------------------------------------------------------------------------
  # ○ new method: create_craft_commands
  #----------------------------------------------------------------------------
  def create_craft_commands
    @command_window = Window_Craft_Command.new(@gold_window.x, $craft.shop_text)
    @command_window.viewport = @viewport
    @command_window.y = @help_window.height
    @command_window.set_handler(:recipe_list,  method(:command_craft))
    @command_window.set_handler(:deconstruct,  method(:command_deconstruct))
    @command_window.set_handler(:cancel,       method(:return_scene))
    @command_window.activate.show
  end
  #----------------------------------------------------------------------------
  # ○ new method: command_craft
  #----------------------------------------------------------------------------
  def command_craft
    @recipe_list.refresh
    @detail_window.refresh
    @recipe_list.show.activate
    @detail_window.show
    @dummy_window.hide
  end
  #----------------------------------------------------------------------------
  # ○ new method: command_deconstruct
  #----------------------------------------------------------------------------
  def command_deconstruct
    @decon_list.show.activate
    @decon_window.show
    @dummy_window.hide
  end
  #----------------------------------------------------------------------------
  # ○ new method: create_recipe_list_window
  #----------------------------------------------------------------------------
  def create_recipe_list_window
    @recipe_list = Recipe_List_Window.new(0, 120)
    @recipe_list.deactivate.hide
    @recipe_list.viewport = @viewport
    @recipe_list.help_window = @help_window
    @recipe_list.set_handler(:ok,      method(:to_detail_window))
    @recipe_list.set_handler(:cancel,  method(:craft_commands))
  end
  #----------------------------------------------------------------------------
  # ○ new method: to_detail_window
  #----------------------------------------------------------------------------
  def to_detail_window
    @detail_window.activate.select(0)
  end
  #----------------------------------------------------------------------------
  # ○ new method: craft_commands
  #----------------------------------------------------------------------------
  def craft_commands
    @recipe_list.hide.deactivate
    @detail_window.hide.deactivate
    @decon_list.hide.deactivate
    @decon_window.hide.deactivate
    @help_window.clear
    @command_window.activate
    @dummy_window.show
  end
  #----------------------------------------------------------------------------
  # ○ new method: create_detail_window
  #----------------------------------------------------------------------------
  def create_detail_window
    @detail_window = Crafting_Details_Window.new
    @detail_window.y = 120
    @detail_window.viewport  = @viewport
    @detail_window.deactivate.hide
    @detail_window.set_handler(:craft,      method(:craft_start))
    @detail_window.set_handler(:cancel,     method(:return_to_list))
    @recipe_list.detail_window = @detail_window
  end
  #----------------------------------------------------------------------------
  # ○ new method: craft_start
  #----------------------------------------------------------------------------
  def craft_start
    Sound.play_ok
    @detail_window.start_crafting
    while @detail_window.started
      Graphics.update
      Input.update
      update
    end
    refresh_shop_windows
    to_detail_window
  end
  #----------------------------------------------------------------------------
  # ○ new method: return_to_list
  #----------------------------------------------------------------------------
  def return_to_list
    Sound.play_cancel
    @detail_window.unselect
    @recipe_list.activate
  end
  #----------------------------------------------------------------------------
  # ○ new method: create_decon_list_window
  #----------------------------------------------------------------------------
  def create_decon_list_window
    @decon_list = Decon_List_Window.new
    @decon_list.viewport = @viewport
    @decon_list.help_window = @help_window
    @decon_list.set_handler(:ok,      method(:to_decon_window))
    @decon_list.set_handler(:cancel,  method(:craft_commands))
  end
  #----------------------------------------------------------------------------
  # ○ new method: to_decon_window
  #----------------------------------------------------------------------------
  def to_decon_window
    @decon_window.activate.select(0)
  end
  #----------------------------------------------------------------------------
  # ○ new method: create_decon_window
  #----------------------------------------------------------------------------
  def create_decon_window
    @decon_window = Decon_Window.new
    @decon_window.viewport = @viewport
    @decon_window.set_handler(:start_decon,   method(:decon_start))
    @decon_window.set_handler(:cancel,        method(:to_decon_list))
    @decon_list.decon_window = @decon_window
  end
  #----------------------------------------------------------------------------
  # ○ new method: decon_start
  #----------------------------------------------------------------------------
  def decon_start
    Sound.play_ok
    @decon_window.start_decon_gauge
    while @decon_window.started
      Graphics.update
      Input.update
      update
    end
    refresh_shop_windows
    to_decon_window
  end
  #----------------------------------------------------------------------------
  # ○ new method: decon_start
  #----------------------------------------------------------------------------
  def refresh_shop_windows
    @decon_list.refresh
    @decon_window.refresh
    @recipe_list.refresh
    @detail_window.refresh
    @gold_window.refresh
  end
  #----------------------------------------------------------------------------
  # ○ new method: to_decon_list
  #----------------------------------------------------------------------------
  def to_decon_list
    @decon_window.unselect
    @decon_list.activate
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: terminate
  #----------------------------------------------------------------------------
  def terminate
    super
    $craft.craft_shop = false
  end
  #----------------------------------------------------------------------------
  # ○ new method: create_stats_window
  #----------------------------------------------------------------------------
  def create_stats_window
    @stats_window = Window_CraftStats.new
    @stats_window.set_handler(:ok,      method(:command_confirm))
    @stats_window.set_handler(:cancel,  method(:return_to_details))
    @stats_window.viewport = @viewport
    @stats_window.list_window = @recipe_list
  end
  #----------------------------------------------------------------------------
  # ○ new method: command_confirm
  #----------------------------------------------------------------------------
  def command_confirm
    @actor = $game_party.members[@stats_window.index]
    @confirm_window.actor = @actor
    @confirm_window.refresh
    @confirm_window.activate
  end
  #----------------------------------------------------------------------------
  # ○ new method: return_to_details
  #----------------------------------------------------------------------------
  def return_to_details
    @details ? @detail_window.activate : @recipe_list.activate
  end
  #----------------------------------------------------------------------------
  # ○ new method: create_confirm_window
  #----------------------------------------------------------------------------
  def create_confirm_window
    @confirm_window = Crafting_Confirmation_Window.new
    @confirm_window.viewport = @viewport
    @confirm_window.set_handler(:ok,      method(:craft_and_equip))
    @confirm_window.set_handler(:cancel,  method(:return_to_stats))
  end
  #----------------------------------------------------------------------------
  # ○ new method: craft_and_equip
  #----------------------------------------------------------------------------
  def craft_and_equip
    return return_to_stats if !@recipe_list.command_enabled?(@recipe_list.index)
    @confirm_window.hide
    @stats_window.close.hide
    @detail_window.number = 1
    @detail_window.refresh
    craft_start
    item = $craft.results[1][2]
    gear = item.is_a?(Array) ? item[0] : item
    equip_item(@actor, gear)
    @stats_window.refresh
    return_to_stats
  end
  #----------------------------------------------------------------------------
  # ○ new method: equip_item
  #----------------------------------------------------------------------------
  def equip_item(actor, item)
    return unless actor.equippable?(item)
    slot_id = item.etype_id
    if $imported["YEA-AceEquipEngine"]
      actor.equip_slots.each_with_index do |etype, i| 
        slot_id = i if etype == gear.etype_id 
      end
    end
    actor.change_equip(slot_id, item)
  end
  #----------------------------------------------------------------------------
  # ○ new method: return_to_stats
  #----------------------------------------------------------------------------
  def return_to_stats
    @confirm_window.hide
    @stats_window.activate
  end
  #----------------------------------------------------------------------------
  # ○ new method: open_stats_window
  #----------------------------------------------------------------------------
  def open_stats_window
    @details = false
    if @detail_window.active
      @detail_window.deactivate
      @details = true
    else
      @recipe_list.deactivate
    end
    @stats_window.show.open
    @stats_window.activate
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: update
  #----------------------------------------------------------------------------
  def update
    super
    if @detail_window && @recipe_list && $imported[:CraftingStats_Addon]
      if @detail_window.active || @recipe_list.active
        open_stats_window if Input.trigger?(Venka::Crafting::Trigger_Key)
      end
    end
  end
end