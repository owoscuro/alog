# encoding: utf-8
# Name: 277.Menu Access Add On
# Size: 15644
#===============================================================================
# Crafting Script: Menu Access Add on                       updated: 09/20/2014
#  Author: Venka
#  REQUIRES Crafting Script
#===============================================================================
$imported ||= {}
$imported[:CraftMenu_Addon] = true
#===============================================================================
# ■ Venka Module
#===============================================================================
module Venka::Crafting

  Menu_Access = true        # 이것이 사실이라면 메뉴에서 항상 사용할 수 있습니다.
  Menu_Switch = 0           # Menu_Access = false인 경우 메뉴 액세스를 전환하려면 ID를 전환합니다.
                            # 스위치를 사용하지 않으려면 0으로 설정할 수 있습니다.
  Menu_Text = "보유 레시피"

#==============================================================================
#                          ♦ Edits end here!! ♦
#==============================================================================
  def self.imported?(script)
    unless $imported[:Venka_Crafting]
      raise("You must install Venka's Crafting script to use #{script}")
    end
  end
end
=begin
# Checks to see if the main crafting script is installed.
Venka::Crafting.imported?("Menu Access Add on")
#==============================================================================
# ■ Window_MenuCommand
#==============================================================================
class Window_MenuCommand < Window_Command
  #----------------------------------------------------------------------------
  # ● alias method: add_original_commands
  #----------------------------------------------------------------------------
  alias venka_crafting_menu_access_aoc       add_original_commands
  def add_original_commands
    venka_crafting_menu_access_aoc
    switch_id = Venka::Crafting::Menu_Switch
    if Venka::Crafting::Menu_Access
      add_command(Venka::Crafting::Menu_Text, :recipes)
    elsif switch_id > 0
      add_command(Venka::Crafting::Menu_Text, :recipes) if $game_switches[switch_id]
    end
  end
end
#==============================================================================
# ■ Scene_Menu
#==============================================================================
class Scene_Menu < Scene_MenuBase
  #----------------------------------------------------------------------------
  # ● alias method: create_command_window
  #----------------------------------------------------------------------------
  alias venka_crafting_menu_access_ccw       create_command_window
  def create_command_window
    venka_crafting_menu_access_ccw
    @command_window.set_handler(:recipes, method(:command_recipes))
  end
  #----------------------------------------------------------------------------
  # ○ new method: command_recipes
  #----------------------------------------------------------------------------
  def command_recipes
    SceneManager.call(Scene_Recipes)
  end
end
=end
#==============================================================================
# ■ Recipe_Command_Window
#==============================================================================
class Recipe_Command_Window < Window_Command
  #----------------------------------------------------------------------------
  # ♦ Public Instance Variables
  #----------------------------------------------------------------------------
  attr_reader   :list_window,   :detail_window,   :title_window
  #----------------------------------------------------------------------------
  # ● upgraded method: initialize
  #----------------------------------------------------------------------------
  def initialize
    @crafting_skills = {}
    @crafting_skills = Venka::Crafting::Craft_Info
    super(0, 24)
    self.opacity = 0
    self.arrows_visible = false
  end
  #--------------------------------------------------------------------------
  # 가온데 정렬 추가 수정
  #--------------------------------------------------------------------------
  def alignment
    return 1
  end
  #----------------------------------------------------------------------------
  # ● Window Settings
  #----------------------------------------------------------------------------
  def visible_line_number;    return 1;                         end
  def window_width;           Graphics.width;                   end
  def item_max;               @crafting_skills.size;            end
  def col_max;                [item_max, 4].min;                end
  #----------------------------------------------------------------------------
  # ● upgraded method: make_command_list
  #----------------------------------------------------------------------------
  def make_command_list
    @crafting_skills.each_key do |craft| 
      add_command(@crafting_skills[craft][:craft_name], craft.to_s.to_sym)
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: list_window
  #----------------------------------------------------------------------------
  def list_window=(list_window)
    @list_window = list_window
    call_update_help
  end
  #----------------------------------------------------------------------------
  # ○ new method: detail_window
  #----------------------------------------------------------------------------
  def detail_window=(detail_window)
    @detail_window = detail_window
  end
  #----------------------------------------------------------------------------
  # ○ new method: title_window
  #----------------------------------------------------------------------------
  def title_window=(title_window)
    @title_window = title_window
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: call_update_help
  #----------------------------------------------------------------------------
  def call_update_help
    super
    craft_type = current_symbol.to_s.to_i
    if @list_window && @list_window.craft != craft_type
      @list_window.craft   = craft_type
      @title_window.craft  = craft_type    if @title_window
    end
  end
end
#==============================================================================
# ■ Recipe_Menu_List
#==============================================================================
class Recipe_Menu_List < Recipe_List_Window
  #----------------------------------------------------------------------------
  # ● upgraded method: initialize
  #----------------------------------------------------------------------------
  def initialize
    super(0, 72)
    deactivate
  end
  #----------------------------------------------------------------------------
  # ● window_settings
  #----------------------------------------------------------------------------
  def window_height;     super - 24;          end
  def craft;             return @craft_id;    end
  #----------------------------------------------------------------------------
  # ● upgraded method: refresh
  #----------------------------------------------------------------------------
  alias craft_menu_list_refresh refresh
  def refresh
    select(0)
    craft_menu_list_refresh
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: call_update_help
  #----------------------------------------------------------------------------
  def call_update_help
    super
    @detail_window.recipe_id = current_symbol if @detail_window
  end
end
#==============================================================================
# ■ Crafting_Menu_Details_Window
#==============================================================================
class Crafting_Menu_Details_Window < Crafting_Details_Window
  #----------------------------------------------------------------------------
  # ● window settings
  #----------------------------------------------------------------------------
  def window_height;      super - 24;         end
  #----------------------------------------------------------------------------
  # ● overwrite method: draw_item
  #----------------------------------------------------------------------------
  def draw_item(index);   return;             end
end
#==============================================================================
# ■ Scene_Recipes
#==============================================================================
class Scene_Recipes < Scene_MenuBase
  #----------------------------------------------------------------------------
  # ● upgraded method: start
  #----------------------------------------------------------------------------
  def start
    super
    create_all_windows
  end
  #----------------------------------------------------------------------------
  # ○ new method: create_all_windows
  #----------------------------------------------------------------------------
  def create_all_windows
    create_title_window
    create_recipe_command_window
    create_recipe_list_window
    create_recipe_details_window
    create_craft_stats_window if $imported[:CraftingStats_Addon]
  end
  #----------------------------------------------------------------------------
  # ○ new method: create_title_window
  #----------------------------------------------------------------------------
  def create_title_window
    @title_window = Crafting_Title_Window.new
    @title_window.viewport = @viewport
    @title_window.height = 72
    @title_window.craft = 1
  end
  #----------------------------------------------------------------------------
  # ○ new method: create_recipe_command_window
  #----------------------------------------------------------------------------
  def create_recipe_command_window
    @command_window = Recipe_Command_Window.new
    @command_window.viewport = @viewport
    @command_window.set_handler(:ok,     method(:on_ok))
    @command_window.set_handler(:cancel, method(:return_scene))
    @command_window.title_window = @title_window
  end
  #----------------------------------------------------------------------------
  # ○ new method: on_ok
  #----------------------------------------------------------------------------
  def on_ok
    Sound.play_buzzer
    $game_temp.pop_w(180, 'SYSTEM', "  제작은 해당 제작대에서만 할 수 있습니다.  ")
    @list_window.activate
    @command_window.activate
  end
  #----------------------------------------------------------------------------
  # ○ new method: create_recipe_list_window
  #----------------------------------------------------------------------------
  def create_recipe_list_window
    @list_window = Recipe_Menu_List.new
    @list_window.viewport = @viewport
    #@list_window.set_handler(:cancel, method(:command_cancel))
    @list_window.activate
    @command_window.list_window = @list_window
  end
  #----------------------------------------------------------------------------
  # ○ new method: command_cancel
  #----------------------------------------------------------------------------
  def command_cancel
    @command_window.activate
  end
  #----------------------------------------------------------------------------
  # ○ new method: create_recipe_details_window
  #----------------------------------------------------------------------------
  def create_recipe_details_window
    @detail_window = Crafting_Menu_Details_Window.new
    @detail_window.y = @title_window.height
    @detail_window.viewport = @viewport
    @command_window.detail_window = @detail_window
    @list_window.detail_window = @detail_window
  end
  #----------------------------------------------------------------------------
  # ○ new method: create_craft_stats_window
  #----------------------------------------------------------------------------
  def create_craft_stats_window
    @craft_stats_window = Window_CraftStats.new
    @craft_stats_window.y += 24
    @craft_stats_window.height -= 24
    @craft_stats_window.set_handler(:cancel,  method(:return_to_details))
    @craft_stats_window.viewport = @viewport
    @craft_stats_window.list_window = @list_window
  end
  #----------------------------------------------------------------------------
  # ○ new method: open_stats_window
  #----------------------------------------------------------------------------
  def return_to_details
    @craft_stats_window.close.hide
    @details ? @detail_window.activate : @list_window.activate
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: update
  #----------------------------------------------------------------------------
  def update
    super
    if $imported[:CraftingStats_Addon] && @command_window.active
      #--------------------------------------------------------------------------
      # 상세 데이터 설명창 추가
      #--------------------------------------------------------------------------
      create_description_window if Input.trigger?(Venka::Crafting::Trigger_Key) or Keyboard.trigger?(:kN)
      #--------------------------------------------------------------------------
      #open_stats_window if Input.trigger?(Venka::Crafting::Trigger_Key)
    end
  end
  #--------------------------------------------------------------------------
  # 상세 데이터 설명창 추가
  #--------------------------------------------------------------------------
  def create_description_window
    @description_window = Window_ItemDescription.new
    @description_window.z = 2010
    on_item_description
    
    # 커맨드, 리스트창 비활성화
    @command_window.deactivate
    @list_window.deactivate
    @description_window.activate
    
    @description_window.set_handler(:ok,     method(:on_description_ok))
    @description_window.set_handler(:cancel, method(:on_description_cancel))
  end
  def on_description_ok
    @description_window.deactivate
    @command_window.activate
    @list_window.activate
    hide_sub_window(@description_window)
    #@description_window = nil
  end
  def on_description_cancel
    Sound.play_cancel
    @description_window.deactivate
    @command_window.activate
    @list_window.activate
    hide_sub_window(@description_window)
    #@description_window = nil
  end
  def on_item_description
    @description_window.refresh(@craft_stats_window.item)
    show_sub_window(@description_window)
  end
  def show_sub_window(window)
    @command_window.hide
    @title_window.hide
    @detail_window.hide
    @list_window.hide.deactivate
    window.show.activate
  end
  def hide_sub_window(window)
    window.hide.deactivate
    @command_window.show
    @title_window.show
    @detail_window.show
    @list_window.show.activate
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
      @list_window.deactivate
    end
    @craft_stats_window.show.open
    @craft_stats_window.activate
  end
end