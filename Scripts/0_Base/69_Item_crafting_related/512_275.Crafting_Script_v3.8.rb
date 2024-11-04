# encoding: utf-8
# Name: 275.Crafting Script v3.8
# Size: 66062
# encoding: utf-8
# Name: 275.Crafting Script v3.8
# Size: 67568
#===============================================================================
# Crafting Script v3.7                                      updated: 12/15/2014
#  Based off of Cooking Script v1.0 for RPG Maker VX by GubiD 
#  Author: Venka
#===============================================================================
# ■ DataManager
#===============================================================================
module DataManager
  #----------------------------------------------------------------------------
  # ● alias methods:
  #----------------------------------------------------------------------------
  class << self
    alias venka_crafting_create_objects        create_game_objects
    alias venka_crafting_save_contents         make_save_contents
    alias venka_crafting_extract_contents      extract_save_contents
    alias load_database_craft_tools            load_database
  end
  #----------------------------------------------------------------------------
  # ● alias method: create_game_objects
  #----------------------------------------------------------------------------
  def self.create_game_objects
    venka_crafting_create_objects
    $craft  = Game_Crafting.new
    $recipe = Game_Recipes.new
  end
  #----------------------------------------------------------------------------
  # ● alias method: make_save_contents
  #----------------------------------------------------------------------------
  def self.make_save_contents
    contents = venka_crafting_save_contents
    contents[:crafting] = $craft
    contents
  end
  #----------------------------------------------------------------------------
  # ● alias method: extract_save_contents
  #----------------------------------------------------------------------------
  def self.extract_save_contents(contents)
    venka_crafting_extract_contents(contents)
    $craft = contents[:crafting]
  end
  #----------------------------------------------------------------------------
  # ● alias method: load_database
  #----------------------------------------------------------------------------
  def self.load_database
    load_database_craft_tools
    load_crafting_tools_notetags
  end
  #----------------------------------------------------------------------------
  # ○ new method: load_crafting_notetags
  #----------------------------------------------------------------------------
  def self.load_crafting_tools_notetags
    groups = [$data_items, $data_weapons, $data_armors]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_craft_tool_notetag
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
  attr_accessor :tool
  #----------------------------------------------------------------------------
  # ○ new method: load_craft_tool_notetag
  #----------------------------------------------------------------------------
  def load_craft_tool_notetag
    @tool = false
    self.note.split(/[\r\n]+/).each do |line|
      case line
      when Venka::Notetag::Tool;    @tool = true
      end
    end
  end
end
#==============================================================================
# ■ Craft_Gold
#==============================================================================
class Craft_Gold
  #----------------------------------------------------------------------------
  # ♦ Public Instance Variables
  #----------------------------------------------------------------------------
  attr_accessor :tool
  #----------------------------------------------------------------------------
  # ♦ Public Instance Variables
  #----------------------------------------------------------------------------
  attr_reader   :icon_index               # Icon Index
  attr_reader   :name                     # Gold Text Name
  attr_reader   :icon_hue                 # Icon Hue
  #----------------------------------------------------------------------------
  # ● upgrade method: initialize
  #----------------------------------------------------------------------------
  def initialize
    super
    @icon_index = Venka::Crafting::Gold_Icon
    @name       = Venka::Crafting::Gold_Text
    @icon_hue   = Venka::Crafting::Gold_Hue
    @tool = false
  end
end
#==============================================================================
# ■ Game_Craft_Info
#==============================================================================
class Game_Craft_Info
  #----------------------------------------------------------------------------
  # ♦ Public Instance Variables
  #----------------------------------------------------------------------------
  attr_reader    :name,            :mastered,            :craft_sound
  attr_reader    :level,           :bg_image,            :bg_music
  attr_reader    :active_sound,    :learned_recipes,     :default_time
  attr_reader    :buffer_time
  #----------------------------------------------------------------------------
  # ● upgrade method: initialize
  #----------------------------------------------------------------------------
  def initialize(craft_id)
    @craft_id     = craft_id
    @craft_info   = Venka::Crafting::Craft_Info[@craft_id]
    @name         = @craft_info[:craft_name]
    @max_level    = @craft_info[:max_level]
    @mastered     = @craft_info[:mastered]
    @bg_image     = @craft_info[:bg_image]
    @bg_music     = @craft_info[:bg_music]
    @craft_sound  = @craft_info[:craft_sound]
    @active_sound = @craft_info[:active_sound]
    @default_time = @craft_info[:craft_time] ? @craft_info[:craft_time] : Venka::Crafting::Default_Craft_Time
    @buffer_time  = @craft_info[:buffer_time] ? @craft_info[:buffer_time] : Venka::Crafting::Crafting_Buffer
    @level     = 1
    @exp       = {}
    @learned_recipes = nil
    init_exp
  end
  #----------------------------------------------------------------------------
  # ○ new method: exp_for_level
  #----------------------------------------------------------------------------
  def exp_for_level(level)
    lv = level.to_f
    basis = @craft_info[:exp_table][0].to_f
    extra = @craft_info[:exp_table][1].to_f
    acc_a = @craft_info[:exp_table][2].to_f
    acc_b = @craft_info[:exp_table][3].to_f
    return (basis*((lv-1)**(0.9+acc_a/250))*lv*(lv+1)/(6+lv**2/50/acc_b)+(lv-1)*extra).round.to_i
  end
  #----------------------------------------------------------------------------
  # ○ new method: init_exp
  #----------------------------------------------------------------------------
  def init_exp;    @exp[@craft_id] = current_level_exp;    end
  #----------------------------------------------------------------------------
  # ○ new method: exp related methods
  #----------------------------------------------------------------------------
  def exp;                 @exp[@craft_id];            end
  def current_level_exp;   exp_for_level(@level);      end
  def next_level_exp;      exp_for_level(@level + 1);  end
  def max_level?;          @level >= @max_level;       end
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
        if recipe[:recipe_type] == @craft_id && recipe_lv <= @level
          next if $craft.known_recipes.include?(recipe_id)
          $craft.learn_recipe(recipe_id) unless recipe[:auto_learn] == false
        end
      end
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: level_down
  #----------------------------------------------------------------------------
  def level_down
    @level -= 1
    return unless Venka::Crafting::Auto_Learn
    # Forget recipes if auto learning is on and craft level is lost
    $craft.known_recipes.each do |id|
      recipe = Venka::Crafting::Recipes[id]
      if recipe[:recipe_type] == @craft_id && recipe[:req_level] > @level
        $craft.forget_recipe(id) unless recipe[:auto_learn] == false
      end
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: change_exp
  #----------------------------------------------------------------------------
  def change_exp(exp)
    @learned_recipes = nil
    @exp[@craft_id] = [exp, 0].max
    last_level = @level
    recipes = $craft.known_recipes.clone
    if $imported[:Venka_Actor_Crafting]
      recipes += actor_recipes.clone
    end
    level_up while !max_level? && self.exp >= next_level_exp
    level_down while self.exp < current_level_exp
    new_recipes = $craft.known_recipes
    if $imported[:Venka_Actor_Crafting]
      new_recipes += actor_recipes
    end
    @learned_recipes = new_recipes - recipes if @level > last_level
  end
  #----------------------------------------------------------------------------
  # ○ new method: get_actor_access
  #----------------------------------------------------------------------------
  def get_actor_access
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
    get_actor_access
    actor_recipes = []
    @mode.each do |actor|
      actor.known_recipes.each { |recipe_id| actor_recipes << recipe_id }
    end
    return actor_recipes
  end
  #----------------------------------------------------------------------------
  # ○ new method: exp, gain_exp
  #----------------------------------------------------------------------------
  def exp;              @exp[@craft_id];                     end
  def gain_exp(exp);    change_exp(self.exp + exp.to_i);     end
  #----------------------------------------------------------------------------
  # ○ new method: change_level
  #----------------------------------------------------------------------------
  def change_level(change)
    change_exp(exp_for_level(@level + change))
  end
  #----------------------------------------------------------------------------
  # ○ new method: set_level
  #----------------------------------------------------------------------------
  def set_level(level)
    level = [[level, @max_level].min, 1].max
    change_exp(exp_for_level(level))
  end
end
#==============================================================================
# ■ Game_Crafting   
#==============================================================================
class Game_Crafting
  #----------------------------------------------------------------------------
  # ♦ Public Instance Variables
  #----------------------------------------------------------------------------
  attr_reader    :known_recipes,    :results
  #----------------------------------------------------------------------------
  # ● upgraded method: initialize
  #----------------------------------------------------------------------------
  def initialize
    @craft = []
    clear_results
    init_recipes
  end
  #----------------------------------------------------------------------------
  # ○ new method: []
  #----------------------------------------------------------------------------
  def [](craft_id)
    return nil unless Venka::Crafting::Craft_Info[craft_id]
    @craft[craft_id] ||= Game_Craft_Info.new(craft_id)
  end
  #----------------------------------------------------------------------------
  # ○ new method: init_recipes
  #----------------------------------------------------------------------------
  def init_recipes
    @known_recipes = []
    return unless Venka::Crafting::Auto_Learn
    crafts = Venka::Crafting::Craft_Info
    recipe_list = Venka::Crafting::Recipes
    crafts.each_key do |craft_id|
      recipe_list.each do |recipe_info|
        recipe_id = recipe_info[0]
        recipe    = recipe_info[1]
        recipe_lv = recipe[:req_level] ? recipe[:req_level] : 1
        if recipe[:recipe_type] == craft_id && recipe_lv <= 1
          learn_recipe(recipe_id) unless recipe[:auto_learn] == false
        end
      end
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: learn_recipe
  #----------------------------------------------------------------------------
  def learn_recipe(recipe_id)
    @known_recipes ||= []
    @known_recipes << recipe_id unless @known_recipes.include?(recipe_id)
  end
  #----------------------------------------------------------------------------
  # ○ new method: forget_recipe
  #----------------------------------------------------------------------------
  def forget_recipe(recipe_id)
    @known_recipes.delete(recipe_id)
  end
  #----------------------------------------------------------------------------
  # ○ new method: set_results
  #----------------------------------------------------------------------------
  def set_results(id, exp, message, item, amount, leveled_up)
    clear_results
    @results = [id, [exp, message, item, amount, leveled_up]]
  end
  #----------------------------------------------------------------------------
  # ○ new method: clear_results
  #----------------------------------------------------------------------------
  def clear_results
    @results = []
  end
end
#==============================================================================
# ■ Game_Recipe
#==============================================================================
class Game_Recipe
  #----------------------------------------------------------------------------
  # ♦ Public Instance Variables
  #----------------------------------------------------------------------------
  attr_reader    :recipe_type,      :req_level,       :ingredients
  attr_reader    :craft_time,       :earned_exp,      :ingredient_amount
  attr_reader    :pre_failed,       :auto_learn,      :recipe_id
  attr_reader    :display_name
  #----------------------------------------------------------------------------
  # ● upgrade method: initialize
  #----------------------------------------------------------------------------
  def initialize(recipe_id)
    @recipe_id    = recipe_id
    @recipe       = Venka::Crafting::Recipes[@recipe_id]
    @recipe_type  = @recipe[:recipe_type]
    if Venka::Crafting::Auto_Learn
      @auto_learn = @recipe[:auto_learn] == false ? false : true
    else
      @auto_learn = false
    end
    @req_level    = @recipe[:req_level] ? @recipe[:req_level] : 1
    @earned_exp   = @recipe[:earned_exp] ? @recipe[:earned_exp] : 0
    @craft_item   = @recipe[:crafted_item]
    @fail_item    = @recipe[:failed_item]
    @pre_failed   = @recipe[:pre_failed]
    @components   = @recipe[:ingredients]
    @ingredients  = []
    @ingredient_amount = []
    get_ingredients
    get_ingredient_amount
    get_display_name
  end
  #----------------------------------------------------------------------------
  # ○ new method: craft_time
  #----------------------------------------------------------------------------
  def craft_time 
    time = @recipe[:craft_time] ? @recipe[:craft_time] : $craft[@recipe_type].default_time #Venka::Crafting::Default_Craft_Time
    time += rand(Venka::Crafting::Time_Variance)
    if Venka::Crafting::Accelerate_Time
      rate = Venka::Crafting::Accelerate_Rate
      time = (time * (rate ** $craft[@recipe_type].level)).to_i
    end
    time = [[time, Venka::Crafting::Crafting_Time_Max].min, 0].max
    return time
  end
  #----------------------------------------------------------------------------
  # ○ new method: crafted_item, crafted_amount, failed_amount
  #----------------------------------------------------------------------------
  def crafted_item;       get_item_info(@craft_item[0]);                   end
  def crafted_amount;     @craft_item[1];                                  end
  def failed_amount;      @fail_item[1];                                   end
  #----------------------------------------------------------------------------
  # ○ new method: pre_failed_amount
  #----------------------------------------------------------------------------
  def pre_failed_amount
    return unless @recipe[:pre_failed]
    @pre_failed[1]
  end
  #----------------------------------------------------------------------------
  # ○ new method: failed_item
  #----------------------------------------------------------------------------
  def failed_item
    get_item_info(@fail_item[0]) if @recipe[:failed_item]
  end
  #----------------------------------------------------------------------------
  # ○ new method: pre_failed_item
  #----------------------------------------------------------------------------
  def pre_failed_item
    get_item_info(@pre_failed[0]) if @recipe[:pre_failed]
  end
  #----------------------------------------------------------------------------
  # ○ new method: ingredients
  #----------------------------------------------------------------------------
  def get_ingredients
    for i in 0...@components.size
      item = get_item_info(@components[i][0])
      @ingredients << item
    end
    return @ingredients
  end
  #----------------------------------------------------------------------------
  # ○ new method: ingredient_amount
  #----------------------------------------------------------------------------
  def get_ingredient_amount
    for i in 0...@components.size
      item = @components[i][0].to_s
      case item.slice(0, 1)
      # When the item is Gold, then get the amount of gold
      when "g"; @ingredient_amount << item.gsub!('g', '').to_i
      # Else get the amount of items used
      else;     @ingredient_amount << @components[i][1]
      end
    end
    return @ingredient_amount
  end
  #----------------------------------------------------------------------------
  # ○ new method: get_item_type
  #----------------------------------------------------------------------------
  def get_item_info(item)
    info = item.to_s
    case info.slice(0, 1)
    when "i";   return $data_items[info.gsub!('i', '').to_i]     # item
    when "a";   return $data_armors[info.gsub!('a', '').to_i]    # armor
    when "w";   return $data_weapons[info.gsub!('w', '').to_i]   # weapon
    when "g";   return Craft_Gold.new                            # gold
    else;       return
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: get_display_name
  #----------------------------------------------------------------------------
  def get_display_name
    if @recipe[:display_name]
      @display_name = @recipe[:display_name]
    else
      @display_name = crafted_item.name
    end
  end
end
#==============================================================================
# ■ Game_Recipes
#==============================================================================
class Game_Recipes
  #----------------------------------------------------------------------------
  # ● upgraded method: initialize
  #----------------------------------------------------------------------------
  def initialize
    @recipes = []
  end
  #----------------------------------------------------------------------------
  # ○ new method: []
  #----------------------------------------------------------------------------
  def [](recipe_id)
    return nil unless Venka::Crafting::Recipes[recipe_id]
    @recipes[recipe_id] ||= Game_Recipe.new(recipe_id)
  end
end
#==============================================================================
# ■ Game_Interpreter
#==============================================================================
class Game_Interpreter
  #----------------------------------------------------------------------------
  # ○ new method: craft
  #----------------------------------------------------------------------------
  def craft(craft_type)
    SceneManager.call(Scene_Crafting)
    SceneManager.scene.prepare(craft_type)
  end
  #----------------------------------------------------------------------------
  # ○ new method: learn_recipe
  #----------------------------------------------------------------------------
  def learn_recipe(recipe_id)
    $craft.learn_recipe(recipe_id)
  end
  #----------------------------------------------------------------------------
  # ○ new method: recipe_learned?
  #----------------------------------------------------------------------------
  def recipe_learned?(recipe_id)
    $craft.known_recipes.include?(recipe_id)
  end
  #----------------------------------------------------------------------------
  # ○ new method: forget_recipe
  #----------------------------------------------------------------------------
  def forget_recipe(recipe_id)
    $craft.forget_recipe(recipe_id)
  end
end
#==============================================================================
# ■ Window_Base
#==============================================================================
class Window_Base < Window
  #--------------------------------------------------------------------------
  # ● alias method: process_escape_character - credit LoneWolf (fixes trash symbols)
  #--------------------------------------------------------------------------
  alias lonewolf_trash_char_fix_process_normal_character process_normal_character
  def process_normal_character(c, pos)
    return unless c >= ' '
    lonewolf_trash_char_fix_process_normal_character(c, pos)
  end
  #----------------------------------------------------------------------------
  # ○ new method: get_color - method determines if text color or new color
  #----------------------------------------------------------------------------
  def get_color(input)
    input.is_a?(Integer) ? text_color([[input, 0].max, 31].min) : Color.new(*input)
  end
  #----------------------------------------------------------------------------
  # ○ new method: craft_font_color
  #----------------------------------------------------------------------------
  def craft_font_color(text_type)
    f_color = Venka::Crafting::Fonts[text_type][3]
    color = f_color.is_a?(Integer) ? text_color(f_color) : Color.new(*f_color)
  end
  #----------------------------------------------------------------------------
  # ○ new method: set_font
  #----------------------------------------------------------------------------
  def set_font(text_type, enabled = true)
    font = Venka::Crafting::Fonts[text_type]
    contents.font.name = font[0]
    contents.font.size = font[1]
    contents.font.bold = font[2]
    change_color(craft_font_color(text_type), enabled)
  end
  #----------------------------------------------------------------------------
  # ○ new method: font_height
  #----------------------------------------------------------------------------
  def font_height
    [contents.font.size, 24].max
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_line
  #----------------------------------------------------------------------------
  def draw_line(y)
    return unless Venka::Crafting::Use_Line_Dividers
    color = get_color(Venka::Crafting::Line_Color)
    # 수정 추가 실험
    contents.fill_rect(4, y + 2, contents_width - 8, 1, color)
    contents.fill_rect(4, y + 3, contents_width - 8, 1, Color.new(16,16,16,100))
  end
end
#==============================================================================
# ■ Crafting_Title_Window
#==============================================================================
class Crafting_Title_Window < Window_Base
  #----------------------------------------------------------------------------
  # ● upgraded method: initialize
  #----------------------------------------------------------------------------
  def initialize
    super(0, 0, Graphics.width, 48)
    self.opacity = Venka::Crafting::Window_Opacity
    self.back_opacity = Venka::Crafting::Window_BGOpacity
    @craft_id = nil
  end
  #----------------------------------------------------------------------------
  # ○ new method: craft
  #----------------------------------------------------------------------------
  def craft=(craft_id)
    return if @craft_id == craft_id
    @craft_id = craft_id
    @craft = $craft[@craft_id]
    @exp = @craft.exp
    refresh
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: refresh
  #----------------------------------------------------------------------------
  def refresh
    contents.clear
    x = w = contents.width * 0.5
    set_font(:title_text)
    if Venka::Crafting::Use_Craft_Exp
      align = 0
      set_font(:other_text)
      draw_crafting_gauge(x, 0, w) unless @craft.max_level?
      draw_craft_level(x, 0, w)
    else
      align = 1
    end
    set_font(:button_text)
    draw_text(4, 0, contents.width, font_height, @craft.name, align)
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_crafting_gauge
  #----------------------------------------------------------------------------
  def draw_crafting_gauge(x, y, width)
    s1 = @craft.exp - @craft.current_level_exp
    s2 = @craft.exp_for_level(@craft.level + 1) - @craft.current_level_exp
    rate = [s1.to_f/s2, 1.0].min
    color1 = get_color(Venka::Crafting::Exp_Gauge_Color1)
    color2 = get_color(Venka::Crafting::Exp_Gauge_Color2)
    draw_gauge(x - 4, y, width, rate, color1, color2)
    color1 = color2 = normal_color
    draw_current_and_max_values(x + 76, y, width - 80, s1, s2, color1, color2)
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_craft_level
  #----------------------------------------------------------------------------
  def draw_craft_level(x, y, w)
    if @craft.max_level?
      set_font(:title_text)
      draw_text(x - 4, y, w, font_height, @craft.mastered, 2)
    else
      set_font(:other_text)
      draw_text(x - 4, y, w, font_height, "LV : #{@craft.level}")
    end
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: update
  #----------------------------------------------------------------------------
  def update
    super
    if @exp != $craft[@craft_id].exp
      @exp = $craft[@craft_id].exp
      refresh
    end
  end
end
#==============================================================================
# ■ Recipe_List_Window
#==============================================================================
class Recipe_List_Window < Window_Command
  #----------------------------------------------------------------------------
  # ♦ Public Instance Variables
  #----------------------------------------------------------------------------
  attr_reader   :detail_window,     :status_window
  #----------------------------------------------------------------------------
  # ● upgraded method: initialize
  #----------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y)
    self.opacity = Venka::Crafting::Window_Opacity
    self.back_opacity = Venka::Crafting::Window_BGOpacity
    @craft_id = nil
    @recipes   = $craft.known_recipes
  end
  #----------------------------------------------------------------------------
  # ○ new method: craft
  #----------------------------------------------------------------------------
  def craft=(craft_id)
    return if @craft_id == craft_id
    @craft_id = craft_id
    refresh
  end
  #----------------------------------------------------------------------------
  # ● window_settings
  #----------------------------------------------------------------------------
  def window_width;      (Graphics.width * 0.33).to_i;           end
  def window_height;     return Graphics.height - 48;            end
  #----------------------------------------------------------------------------
  # ● upgraded method: update
  #----------------------------------------------------------------------------
  def update
    super
    if @detail_window && @detail_window.recipe_id != current_symbol
      @detail_window.recipe_id = current_symbol
    end
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: make_command_list
  #----------------------------------------------------------------------------
  def make_command_list
    if @recipes
      get_recipes
      sort_list
      # 실험
      @items.each do |item|
        # 만들수 있는 레시피만 표시한다.
        #if SceneManager.scene_is?(Scene_Crafting)
          #if enabled?(item)
            add_command(item.crafted_item, item.recipe_id.to_s.to_sym, enabled?(item))
          #end
        #else
        #  add_command(item.crafted_item, item.recipe_id.to_s.to_sym, enabled?(item))
        #end
      end
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: get_recipes
  #----------------------------------------------------------------------------
  def get_recipes
    @items = []
    @recipes.each do |recipe_id|
      next unless $recipe[recipe_id].recipe_type == @craft_id
      item = $recipe[recipe_id]
      @items << item
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: sort_list
  #----------------------------------------------------------------------------
  def sort_list
    if Venka::Crafting::Sort_Type == :level                # Sort by level
      @items.sort!{|a, b| a.req_level <=> b.req_level} 
    elsif Venka::Crafting::Sort_Type == :alphabet          # Sort by alpha
      @items.sort!{|a, b| a.crafted_item.name <=> b.crafted_item.name}
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: enabled?
  #----------------------------------------------------------------------------
  def enabled?(recipe)
    if SceneManager.scene_is?(Scene_Crafting) || SceneManager.scene_is?(Scene_Recipes)
      return false if recipe.req_level > $craft[@craft_id].level
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
  # ● upgraded method: draw_item
  #----------------------------------------------------------------------------
  def draw_item(index)
    rect = item_rect_for_text(index)
    return unless @items[index]
    set_font(:recipe_list, @list[index][:enabled])
    item = @list[index][:name]
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
  # ○ new method: detail_window
  #----------------------------------------------------------------------------
  def detail_window=(detail_window)
    @detail_window = detail_window
    update
  end
  #----------------------------------------------------------------------------
  # ○ new method: status_window
  #----------------------------------------------------------------------------
  def status_window=(status_window)
    @status_window = status_window
    update
  end
end
#==============================================================================
# ■ Crafting_Details_Window
#==============================================================================
class Crafting_Details_Window < Window_Command;         include Venka::Crafting
  #----------------------------------------------------------------------------
  # ♦ Public Instance Variables
  #----------------------------------------------------------------------------
  attr_reader      :recipe_id,        :started
  attr_reader      :result_exp,       :result_item,        :result_level
  attr_reader      :result_amount,    :result_message
  attr_accessor    :number
  #----------------------------------------------------------------------------
  # ● upgraded method: initialize
  #----------------------------------------------------------------------------
  def initialize
    super((Graphics.width * 0.33).to_i, 48)
    self.opacity = Venka::Crafting::Window_Opacity
    self.back_opacity = Venka::Crafting::Window_BGOpacity
    @recipe_id = :none
    @recipe    = []
    @number    = 1
    @max_time  = Crafting_Time_Max
    @result_item    = nil
    @result_message = ""
    @started = @success = @failed = @result_level = false
    @result_exp = @result_amount = 0
    @ingredients = []
    unselect
    deactivate
  end
  #----------------------------------------------------------------------------
  # ● window settings
  #----------------------------------------------------------------------------
  def window_width;    Graphics.width - (Graphics.width * 0.33).to_i;   end
  def window_height;            Graphics.height - 48;              end
  def item_max;                 return 1;                          end
  def contents_height;          height - standard_padding * 2;     end
  def update_padding_bottom;    self.padding_bottom = 0;           end
  #----------------------------------------------------------------------------
  # ● upgraded method: item_height
  #----------------------------------------------------------------------------
  def item_height
    if Craft_Stacks
      Fonts[:button_text][1] + [24, Fonts[:recipe_name][1], Fonts[:other_text][1]].max
    else
      Fonts[:button_text][1]
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: recipe_id
  #----------------------------------------------------------------------------
  def recipe_id=(recipe_id)
    return if @recipe_id == recipe_id
    @recipe_id = recipe_id
    @recipe = $recipe[recipe_id.to_s.to_i]
    @craft_id = @recipe.recipe_type if @recipe
    refresh
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: make_command_list
  #----------------------------------------------------------------------------
  def make_command_list
    add_command(Craft_Button_Text, :craft, current_item_enabled?)
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
    return unless @recipe_id
    rect = item_rect_for_text(index)
    set_font(:button_text, current_item_enabled?)
    # 수정 추가 실험
    draw_text(rect.x, rect.y-3, rect.width, font_height, Craft_Button_Text, 1)
    if Craft_Stacks
      draw_craft_number(rect.width/2, rect.y + font_height-3, rect.width, 
            rect.height - font_height)
    end
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: refresh
  #----------------------------------------------------------------------------
  def refresh
    @max = 999
    contents.clear
    @ingredient_count = 0
    super
    return unless @recipe_id && @craft_id
    width = contents.width
    @y = 0
    draw_recipe_header(0, @y, width)
    @y += 5
    draw_line(@y)
    @y += 5
    draw_item_description(0, @y, @recipe.crafted_item.description)
    @y += 5
    draw_line(@y)
    @y += 5
    draw_ingredient_header(0, @y, width)
    draw_ingredients
    #@y += 5
    #draw_line(@y + 10)
    #@y += 5
    draw_all_items
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_recipe_header
  #----------------------------------------------------------------------------
  def draw_recipe_header(x, y, w)
    set_font(:header_text);    h2 = font_height
    set_font(:other_text);     h3 = font_height
    set_font(:recipe_name);    h1 = font_height
    lh = [h1, h2, h3].max
    draw_recipe_name(x, y, w - 60)
    draw_owned_items(x, y + lh, w)
    @y += lh * 2
    return unless Use_Craft_Exp
    draw_level_required(y, w)
    draw_recipe_exp(y + lh, w)
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_recipe_name
  #----------------------------------------------------------------------------
  def draw_recipe_name(x, y, w)
    if $imported[:MAIcon_Hue]
      draw_icon_with_hue(@recipe.crafted_item.icon_index, @recipe.crafted_item.icon_hue, 
        x, y)
    else
      draw_icon(@recipe.crafted_item.icon_index, x, y)
    end
    draw_text(x + 25, y, w, font_height, @recipe.display_name)
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_owned_items
  #----------------------------------------------------------------------------
  def draw_owned_items(x, y, w)
    set_font(:header_text)
    draw_text(x, y, w, font_height, Possessed_Text)
    width = text_size(Possessed_Text).width + 5
    set_font(:other_text)
    text = sprintf("%2d", equip_items(@recipe.crafted_item))
    draw_text(x + width, y, w - width, font_height, text)
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_level_required
  #----------------------------------------------------------------------------
  def draw_level_required(y, w)
    level = sprintf("%2d", @recipe.req_level)
    set_font(:header_text)
    lw = text_size(level).width + 5
    tw = text_size(Level_Text).width + 5
    draw_text(w - lw - tw, y, tw, font_height, Level_Text)
    set_font(:other_text)
    change_color(power_down_color) if @recipe.req_level > $craft[@craft_id].level
    draw_text(w - lw, y, lw, font_height, level, 2)
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_recipe_exp
  #----------------------------------------------------------------------------
  def draw_recipe_exp(y, w)
    set_font(:header_text)
    width = text_size(EXP_Text).width + 5
    w2 = text_size(Possessed_Text).width + 5
    draw_text(w - width, y, width, font_height, EXP_Text, 2)
    set_font(:other_text)
    draw_text(w - 135, y, 100, font_height, @recipe.earned_exp.to_s, 2)
  end
  #----------------------------------------------------------------------------
  # ○ new method: equip_items
  #----------------------------------------------------------------------------
  def equip_items(item)
    count = $game_party.item_number(item)
    if Include_Equipment
      $game_party.members.each do |actor| 
        actor.equips.each {|gear| count +=1 if gear == item}
      end
    end
    return count
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_item_description
  #----------------------------------------------------------------------------
  def draw_item_description(x, y, text)
    set_font(:description)
    text = convert_escape_characters(text)
    pos = {:x => x, :y => y, :new_x => x, :height => font_height}
    process_character(text.slice!(0, 1), text, pos) until text.empty?
    @y += font_height * 2
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
  # ○ new method: draw_craft_number
  #----------------------------------------------------------------------------
  def draw_craft_number(x, y, w, h)
    # Set font to get true width of the string
    set_font(:recipe_name, current_item_enabled?)
    item_width = text_size("×#{@recipe.crafted_item.name}").width + 5
    set_font(:other_text, current_item_enabled?)
    amount = @recipe.crafted_amount * @number
    num_width  = text_size("×#{amount}").width + 5
    # Funky math to get how to center the string
    x -= (num_width + item_width + 24) * 0.5
    draw_text(x, y, w, h, "×#{amount}")
    x += num_width
    if $imported && $imported[:MAIcon_Hue]
      draw_icon_with_hue(@recipe.crafted_item.icon_index, 
              @recipe.crafted_item.icon_hue, x, y, enabled)
    else
      draw_icon(@recipe.crafted_item.icon_index, x, y)
    end
    x += 24
    set_font(:recipe_name, current_item_enabled?)
    # 아이템 이름 좌표 수정 실험
    draw_text(x + 5, y, w, h, @recipe.crafted_item.name)
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_ingredient_header
  #----------------------------------------------------------------------------
  def draw_ingredient_header(x, y, width)
    set_font(:header_text)
    @w = [text_size(Needed_Owned_Text).width + 5, 20].max
    #@w = [text_size(Needed_Owned_Text).width + 5, width * 0.3].max
    draw_text(x, y, width - @w, font_height, Ingredients_Text)
    draw_text(width - @w, y, @w, font_height, Needed_Owned_Text, 1)
    #draw_text(x + (width - @w), y, @w, font_height, Needed_Owned_Text, 1)
    @y += font_height
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_ingredients
  #----------------------------------------------------------------------------
  def draw_ingredients
    @ingredients = @recipe.ingredients
    @required = @recipe.ingredient_amount.clone
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
  # ○ new method: determine_required_ingredients
  #----------------------------------------------------------------------------
  def determine_required_ingredients(ingredient, i)
    if @ingredients[i].is_a?(Craft_Gold)
      owned = $game_party.gold
      needed = @required[i] * @number
    elsif ingredient.tool
      owned = $game_party.item_number(ingredient)
      needed = @required[i]
    else
      owned = $game_party.item_number(ingredient)
      needed = @required[i] * @number
    end
    max_stacks = 999
    if !ingredient.is_a?(Craft_Gold) && ingredient.tool
      enabled = (owned >= needed) ? @ingredient_count += 1 : false
      max_stacks = (owned >= needed) ? 999 : owned / @required[i] if @required[i] > 0
    else
      enabled = (owned < needed ? false : @ingredient_count += 1)
      max_stacks = owned / @required[i] if @required[i] > 0
    end
    [owned, needed, enabled, max_stacks]
  end
  #----------------------------------------------------------------------------
  # ○ new method: current_item_enabled?
  #----------------------------------------------------------------------------
  def current_item_enabled?
    return false unless @recipe_id
    return false if @recipe.req_level > $craft[@craft_id].level
    return false if $game_party.item_number(@recipe.crafted_item) == 999
    return false if @ingredient_count != @ingredients.size
    return true
  end
  #----------------------------------------------------------------------------
  # ○ new method: start_crafting
  #----------------------------------------------------------------------------
  def start_crafting
    @claim_time   = @recipe.craft_time * @number
    # 제작 최소 값 적용
    @claim_time = 10 if 10 >= @claim_time
    @result_item  = nil
    @result_message = ""
    @elapsed = 0
    @buffer = Venka::Crafting::Timer_Type == :timer ? 0 : $craft[@craft_id].buffer_time
    @success = @failed = @result_level = false
    @result_exp = @result_amount = 0
    @started    = true
    @timer = 120
    if 100 > @number
      @max_time = Crafting_Time_Max * @number
    else
      @max_time = Crafting_Time_Max * 100
    end
    @max_time = @claim_time if Venka::Crafting::Timer_Type == :timer
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: update
  #----------------------------------------------------------------------------
  def update
    super
    update_craft_bar while @started
    update_number if Craft_Stacks && self.active == true
  end
  #----------------------------------------------------------------------------
  # ○ new method: update_craft_bar
  #----------------------------------------------------------------------------
  def update_craft_bar
    Graphics.update
    Input.update
    activate_craft
    if Venka::Crafting::Timer_Type == :none
      @success = true
      rewards
    end
    rewards if Venka::Crafting::Timer_Type == :timer && @elapsed >= @max_time
    if Venka::Crafting::Timer_Type != :timer
      rewards if Input.trigger?(Input::C) || @elapsed >= @max_time
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: activate_craft
  #----------------------------------------------------------------------------
  def activate_craft
    return if Venka::Crafting::Timer_Type == :none
    play_sound
    rect = item_rect(index)
    unselect
    contents.clear_rect(rect)
    rate = [@elapsed.to_f / @max_time, 1.0].min
    #print("079.제작 - %s / %s, (%s) \n" % [@elapsed.to_f, @max_time, rate]);
    if Venka::Crafting::Timer_Type == :timer
      @elapsed += 1
    else
      set_font(:help_text)
      draw_text(rect.x, rect.y + font_height, rect.width, rect.height - font_height, Directions_Msg, 1)
      if @elapsed < @max_time
        @elapsed += 1
      else
        @failed  = true
        @success = false
      end
    end
    if @claim_time + @buffer >= @elapsed and @elapsed >= @claim_time - @buffer
      @success = true
      gc1 = get_color(Claim_Gauge_Color1)
      gc2 = get_color(Claim_Gauge_Color2)
    else
      if @claim_time + @buffer < @elapsed
        @failed = true
      end
      @success = false
      gc1 = get_color(Craft_Gauge_Color1)
      gc2 = get_color(Craft_Gauge_Color2)
    end
    draw_gauge(rect.x, rect.y, rect.width, rate, gc1, gc2)
  end
  #----------------------------------------------------------------------------
  # ○ new method: play_sound
  #----------------------------------------------------------------------------
  def play_sound
    return unless $craft[@craft_id].active_sound
    file_info = $craft[@craft_id].active_sound
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
    @started  = false
    level = $craft[@craft_id].level           # Check current level
    recipes = $craft.known_recipes            # Check current known recipes
    for i in 0...@ingredients.size            # Remove ingredients from bags
      if @ingredients[i].is_a?(Craft_Gold)
        $game_party.lose_gold(@required[i].round * @number)
      elsif !@ingredients[i].tool
        $game_party.lose_item(@ingredients[i], @required[i].round * @number) 
      end
    end
    # Get exp, items, and pop up message based on success
    @success ? success_rewards : failed_rewards
    # If crafting level changed, then do pop up message and play sound
    if level != $craft[@craft_id].level
      RPG::SE.new(*Level_Up_Sound).play
      @result_level = true
    end
    $craft.set_results(@craft_id, @result_exp, @result_message, @result_item, 
          @result_amount, @result_level)
    select(0)
    refresh
  end
  #----------------------------------------------------------------------------
  # ○ new method: success_rewards
  #----------------------------------------------------------------------------
  def success_rewards
    RPG::SE.new(*Success_Sound).play
    # 연금술사의 의상을 입은 경우 수량 추가
    #print("084.Shop Craft & Decompile - %s \n" % [@craft_id]);
    if @craft_id == 1
      @number += 1 if $game_variables[114] == "AF"
      @number += 2 if $game_variables[114] == "AF2"
    end
    @result_exp     = @recipe.earned_exp * @number
    @result_message = Result_Msg
    @result_item    = @recipe.crafted_item
    @result_amount  = @recipe.crafted_amount * @number
    $game_party.gain_item(@result_item, @result_amount)
    $craft[@craft_id].gain_exp(@result_exp) if SceneManager.scene_is?(Scene_Crafting)
  end
  #----------------------------------------------------------------------------
  # ○ new method: failed_rewards
  #----------------------------------------------------------------------------
  def failed_rewards
    # Get the right sound file info
    sound_file = @failed ? Failure_Sound : Premature_Sound
    RPG::SE.new(*sound_file).play
    # Determine if you get a failure item
    @result_item = @failed ? @recipe.failed_item : @recipe.pre_failed_item
    # Get the right pop up message
    @result_message = @result_item ? Result_Msg : Failed_Msg
    # Determine if failure exp is allowed
    failed_exp = (@recipe.earned_exp * Failure_Exp_Rate).round * @number
    @result_exp = (Failure_Exp_Rate > 0 ? [failed_exp, 1].max : 0)
    # Give failure exp
    $craft[@craft_id].gain_exp(@result_exp) unless @result_exp == 0
    if @result_item && @failed
      @result_amount = @recipe.failed_amount * @number
    elsif @result_item
      @result_amount = @recipe.pre_failed_amount * @number
    end
    # 존재하는 경우 실패 항목 부여
    $game_party.gain_item(@result_item, @result_amount) if @result_item
  end
end
#==============================================================================
# ■ Crafting_Results_Window
#==============================================================================
class Crafting_Results_Window < Window_Base
  #----------------------------------------------------------------------------
  # ● upgraded method: initialize
  #----------------------------------------------------------------------------
  def initialize
    super(0, 0, Graphics.width * 0.8, fitting_height(4))
    self.opacity = Venka::Crafting::Result_Opacity
    self.back_opacity = Venka::Crafting::Result_BGOpacity
    self.openness = 0
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: refresh
  #----------------------------------------------------------------------------
  def refresh
    contents.clear
    return if $craft.results == []
    result_info
    # 결과창 사이즈 변경
    resize_window
    draw_header
    draw_items_received
    draw_exp_received    if @exp > 0
    draw_level_up        if @leveled
    draw_new_recipes     if @learned
    wait_to_close
  end
  #----------------------------------------------------------------------------
  # ○ new method: result_info
  #----------------------------------------------------------------------------
  def result_info
    @craft_id = $craft.results[0]
    @results  = $craft.results[1]
    @learned  = $craft[@craft_id].learned_recipes
    @exp, @message, @item, @amount, @leveled = *@results
  end
  #----------------------------------------------------------------------------
  # ○ new method: resize_window
  #----------------------------------------------------------------------------
  def resize_window
    #self.x = (Graphics.width - win_width) * 0.5
    #self.y = (Graphics.height - win_height) * 0.5
    #self.width  = win_width * 1.2
    #self.height = win_height
    self.x = (Graphics.width * 0.33).to_i
    self.y = 48
    self.width  = Graphics.width - (Graphics.width * 0.33).to_i
    self.height = Graphics.height - 48
    create_contents
    open
  end
  #----------------------------------------------------------------------------
  # ○ new method: win_width
  #----------------------------------------------------------------------------
  def win_width
    set_font(:other_text)
    if @message == Venka::Crafting::Result_Msg
      text  = @message + "×#{@amount}" + @item.name
      width1 = text_size(text).width + 50 + standard_padding * 2
    else
      width1 = text_size(@message).width + 10 + standard_padding * 2
    end
    width2 = text_size(Venka::Crafting::Learn_Text).width + standard_padding * 2
    if @learned
      width = 0
      @learned.each do |recipe_id|
        recipe = $recipe[recipe_id]
        size   = text_size(recipe.display_name).width
        width  = size if size > width
      end
      width2 += width + 50
    end
    return [[width1, width2].max + 15, Graphics.width].min
  end
  #----------------------------------------------------------------------------
  # ○ new method: win_height
  #----------------------------------------------------------------------------
  def win_height
    h1 = Venka::Crafting::Fonts[:recipe_name][1] + standard_padding * 2
    h2 = [Venka::Crafting::Fonts[:other_text][1], 24].max
    height = h1 + h2 + (h2 * (@learned ? @learned.size : 0))
    height += h2 if @exp > 0
    height += [Venka::Crafting::Fonts[:button_text][1], 24].max if @leveled
    return height
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_header
  #----------------------------------------------------------------------------
  def draw_header
    set_font(:recipe_name)
    # 결과 내용 좌표 수정 추가 실험
    draw_text(0, -5, contents.width, font_height, Venka::Crafting::Results_Text, 1)
    set_font(:recipe_list)
    draw_text(4, font_height - 1, contents.width, font_height, "Has completado la fabricación y has obtenido los siguientes ítems.")
    @y = font_height
    @y += font_height + 5
    draw_line(@y)
    @y += 5
=begin
    color = get_color(Venka::Crafting::Line_Color)
    #color = normal_color
    contents.fill_rect(4, @y, contents_width - 8, 1, color)
    contents.fill_rect(4, @y - 1, contents_width - 8, 1, Color.new(16,16,16,100))
    #color.alpha = 90
    #contents.fill_rect(0, font_height - 1, contents_width, 1, color)
=end
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_items_received
  #----------------------------------------------------------------------------
  def draw_items_received
    set_font(:other_text)
    x = 6
    case @message
    when Venka::Crafting::Result_Msg
      
      set_font(:help_text)
      self.contents.font.size = 22
      self.contents.font.color = (text_color(1))
      draw_text(0, @y, contents.width - x, font_height, "Ítems obtenidos")
      @y += font_height + 8
      
      set_font(:other_text)
      #draw_text(x, @y, contents.width, font_height, @message)
      #x += text_size(@message).width + 5
      if $imported[:MAIcon_Hue]
        draw_icon_with_hue(@item.icon_index, @item.icon_hue, x, @y)
      else
        draw_icon(@item.icon_index, x, @y)
      end
      x += 25
      draw_text(x, @y, contents.width - x, font_height, @item.name)
      x += text_size(@item.name).width + 5
      draw_text(x - 8, @y, contents.width - x, font_height, "×#{@amount}", 2)
    when Venka::Crafting::Failed_Msg
      draw_text(0, @y, contents.width, font_height, @message, 1)
    end
    @y += font_height
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_exp_received
  #----------------------------------------------------------------------------
  def draw_exp_received
    draw_text(6, @y, contents.width, font_height, Venka::Crafting::Exp_Earned)
    x = text_size(Venka::Crafting::Exp_Earned).width + 5
    text = $craft[@craft_id].max_level? ? Venka::Crafting::Max_Exp : @exp.to_s
    draw_text(x - 8, @y, contents.width - x, font_height, text, 2)
    @y += font_height
    #draw_line(@y)
    #color = get_color(Venka::Crafting::Line_Color)
    #contents.fill_rect(4, @y + 5, contents_width - 8, 1, color)
    #contents.fill_rect(4, @y + 6, contents_width - 8, 1, Color.new(16,16,16,100))
    #@y += font_height
    @y += 5
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_level_up
  #----------------------------------------------------------------------------
  def draw_level_up
    draw_line(@y)
    @y += 5
    set_font(:button_text)
    draw_text(0, @y, contents.width, font_height, Venka::Crafting::Lv_Gain, 1)
    @y += font_height
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_new_recipes
  #----------------------------------------------------------------------------
  def draw_new_recipes
    set_font(:other_text)
    prefix = Venka::Crafting::Learn_Text
    @learned.each do |recipe_id|
      recipe = $recipe[recipe_id]
      x = 0
      draw_text(x, @y, contents.width, font_height, prefix)
      x += text_size(prefix).width + 5
      if $imported[:MAIcon_Hue]
        draw_icon_with_hue(recipe.crafted_item.icon_index, @item.icon_hue, x, @y)
      else
        draw_icon(recipe.crafted_item.icon_index, x, @y)
      end
      x += 25
      draw_text(x, @y, contents.width - x, font_height, recipe.display_name)
      @y += font_height
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: wait_to_close
  #----------------------------------------------------------------------------
  def wait_to_close
    loop do
      Graphics.update
      Input.update
      update
      break if Input.trigger?(Input::C)
    end
    self.close
  end
end
#==============================================================================
# ■ Scene_Crafting
#==============================================================================
class Scene_Crafting < Scene_Base;                      include Venka::Crafting
  #----------------------------------------------------------------------------
  # ○ new method: prepare
  #----------------------------------------------------------------------------
  def prepare(craft_id)
    @craft_id = craft_id
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: start
  #----------------------------------------------------------------------------
  def start
    super
    create_background if $craft[@craft_id].bg_image
    craft_sounds
    create_all_windows
  end
  #----------------------------------------------------------------------------
  # ○ new method: create_all_windows
  #----------------------------------------------------------------------------
  def create_all_windows
    create_title_window
    create_list_window
    create_detail_window
    create_result_window
    if $imported[:CraftingStats_Addon]
      create_status_window
      create_confirm_window
    end
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: terminate
  #----------------------------------------------------------------------------
  def terminate
    super
    dispose_background if $craft[@craft_id].bg_image
    if $craft[@craft_id].bg_music
      fadeout_all(60)
      @map_bgm.replay
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: craft_sounds
  #----------------------------------------------------------------------------
  def craft_sounds
    RPG::SE.new(*Start_Scene).play
    if $craft[@craft_id].bg_music
      @map_bgm = RPG::BGM.last
      fadeout_all(60)
      RPG::BGM.new(*$craft[@craft_id].bg_music).play
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: dispose_background
  #----------------------------------------------------------------------------
  def dispose_background
    @background_sprite.dispose
  end
  #----------------------------------------------------------------------------
  # ○ new method: create_background
  #----------------------------------------------------------------------------
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = Bitmap.new(Graphics.width, Graphics.height)
    begin;      bitmap = Cache.title1($craft[@craft_id].bg_image)
    rescue;     bitmap = Cache.picture($craft[@craft_id].bg_image)
    end
    rect = Rect.new(0, 0, Graphics.width, Graphics.height)
    @background_sprite.bitmap.stretch_blt(rect, bitmap, bitmap.rect)
  end
  #----------------------------------------------------------------------------
  # ○ new method: create_title_window
  #----------------------------------------------------------------------------
  def create_title_window
    @title_window = Crafting_Title_Window.new
    @title_window.viewport = @viewport
    @title_window.craft = @craft_id
  end
  #----------------------------------------------------------------------------
  # ○ new method: create_list_window
  #----------------------------------------------------------------------------
  def create_list_window
    @list_window = Recipe_List_Window.new(0, @title_window.height)
    @list_window.viewport = @viewport
    @list_window.craft = @craft_id
    @list_window.set_handler(:ok,      method(:to_detail_window))
    @list_window.set_handler(:cancel,  method(:return_scene))
  end
  #----------------------------------------------------------------------------
  # ○ new method: to_detail_window
  #----------------------------------------------------------------------------
  def to_detail_window
    @detail_window.show
    @detail_window.activate.select(0)
  end
  #----------------------------------------------------------------------------
  # ○ new method: create_detail_window
  #----------------------------------------------------------------------------
  def create_detail_window
    @detail_window = Crafting_Details_Window.new
    @detail_window.viewport = @viewport
    @detail_window.set_handler(:craft,      method(:craft_start))
    @detail_window.set_handler(:cancel,  method(:return_to_list))
    @list_window.detail_window = @detail_window
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
    @list_window.refresh
    @detail_window.hide
    @result_window.refresh if Pop_up_Window
    to_detail_window
  end
  #----------------------------------------------------------------------------
  # ○ new method: return_to_list
  #----------------------------------------------------------------------------
  def return_to_list
    Sound.play_cancel
    @detail_window.unselect
    @list_window.activate
  end
  #----------------------------------------------------------------------------
  # ○ new method: create_result_window
  #----------------------------------------------------------------------------
  def create_result_window
    @result_window = Crafting_Results_Window.new
    @result_window.viewport = @viewport
  end
end