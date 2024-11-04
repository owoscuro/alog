# encoding: utf-8
# Name: 281.Actor Stat Changes
# Size: 37978
# encoding: utf-8
# Name: 281.Actor Stat Changes
# Size: 37741
#===============================================================================
# Crafting Script: Actor Stat Changes Add on                updated: 09/21/2014
#  Author: Venka
#  REQUIRES Crafting Script
#===============================================================================
# - Change Log -
#------------------------------------------------------------------------------
# 09/21/2014 - Updated the script for high resolution projects and put the 
#              scene info for the stats into the add ons they belong to.
#            - Adjusted the facesets to fit with in the columns neater and 
#              state and element icons now display properly when sever icons 
#              are in use.
# 09/01/2014 - Made the code more efficent.
# 08/21/2014 - Fixed issue with list windows having no items to show.
# 08/18/2014 - Fixed some compatibility issues with the shop decon add on.
# 08/15/2014 - Fixed compatiblity with Sixth's Addon and Shop Craft/Decompile.
# 08/07/2014 - Fixed issue with pop up window showing up when you didn't have 
#              the ingredients to craft the item.
# 07/17/2014 - Initial release of the add on script.
#------------------------------------------------------------------------------
# - Introduction -
#------------------------------------------------------------------------------
# Allows you to see how the crafted item will effect your party members' stats.
# It will filter throught stat changes and only show relevant changes. You can 
# craft and equip an item from the stats window.
# 
#------------------------------------------------------------------------------
# - Instructions -
#------------------------------------------------------------------------------
# Place this script above the Crafting Shop Craft & Decompile add on if you 
# are using it.
#==============================================================================
$imported ||= {}
$imported[:CraftingStats_Addon] = true
#==============================================================================
# ■ Venka Module
#==============================================================================
module Venka::Crafting
  
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  # - General Settings -
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  Stats_Width = 0.67
  Use_FaceSet = true               # true for face set, false for sprite
  StatsWin_Opacity   = 255         # Over all opacity of the stats window
  StatsWin_BGOpacity = 210         # Background opacity of the stats window
  Box_Color = [16, 16, 16, 100]    # [Red, Green, Blue, Opacity]
  Vert_Scrolling = false           # true - scroll through actors vertically
                                   # false - scroll through actors horizontally
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  # - Text Settings -
  #----------------------------------------------------------------------------
  # Most of the stat text settings will use the terms you set in the database 
  # but a few are never defined there and must be set up here.
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  Not_Gear_Text   = "No se puede equipar."    # Mensaje cuando el objeto no es equipable
  Key_Instruction = "Presiona el botón A para ver más información."  # Información para el jugador
  Currently_Equip = "Se puede equipar."        # Texto mostrado para los objetos ya equipados
  No_Equip   = "No se puede equipar."          # Texto cuando el actor no puede equipar
  No_Change  = "-"                            # Texto cuando no hay cambios en las estadísticas
  Add_Symbol = " +"                            # Símbolo usado cuando las estadísticas suben
  Sub_Symbol = " -"                            # Símbolo usado cuando las estadísticas bajan
  Confirm_Craft = "Sí"                         # Texto para confirmar la elaboración y equipar
  Cancel_Craft  = "No"                         # Texto para cancelar la elaboración y equipar
  
  # Below is the formula for the text that will appear in the confirmation box.
  # Don't edit the text inside the #{} symbols. That will put the actor's name.
  def self.craft_text(name)
    "Craft this item for #{name}?"
  end
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  # - Stats Comparision Settings -
  #----------------------------------------------------------------------------
  # Pick the terminology and stats that will get checked for each piece of gear.
  # You will need to pick and choose the stats that you will like to compare 
  # since not all will show on screen. Vert_Scrolling set to false will show 
  # slightly more info then when it is set to true.  Also screen resolution 
  # will effect how much info can be shown.
  #
  # You can set an icon for each stat if you'd like. If you don't want to use 
  # an icon then set the first part to nil. The second entry is the text as it 
  # will appear in game for each stat. If you want to use only icons, then set 
  # the text to be blank like so: "". The last option needs to be set to true 
  # if you want it to show on the screen.. flase if you don't want to use it.
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  Track_Prime    = true     # Track primary stats. Stats 0 - 7
  Track_Extra    = true     # Track extra stats. Stats 8 - 17
  Track_States   = true     # Track status effects. Stats 18
  Track_Elements = true     # Track elements. Stats 19
  Stats = [] # [IconID, "Name"]
  
  Stats[0]  = [ 625,  "HP"   ]      # Max Health
  Stats[1]  = [ 629,  "MP"   ]      # Max Mana
  Stats[2]  = [ 548,  "Ataque"  ]           # Attack
  Stats[3]  = [ 593,  "Defensa"  ]          # Defense
  Stats[4]  = [ 549,  "Ataque Mágico" ]     # Magic Attack
  Stats[5]  = [ 615,  "Defensa Mágica" ]    # Magic Defense
  Stats[6]  = [ 604,  "Agilidad"  ]         # Agility
  Stats[7]  = [ 550,  "Suerte"  ]           # Luck

  Stats[8]  = [ 579,  "Precisión"  ]        # Hit Rating
  Stats[9]  = [ 553,  "Evasión"  ]          # Evasion Rating
  Stats[10] = [ 534,  "Golpe Crítico" ]     # Critical Hit Rating
  Stats[11] = [ 535,  "Evasión Crítica" ]   # Critical Evasion Rating
  Stats[12] = [ 612,  "Evasión Mágica" ]    # Magic Evasion Rating
  Stats[13] = [ 539,  "Reflejo Mágico" ]    # Magic Reflection Rate
  Stats[14] = [ 547,  "Contraataque"  ]     # Counter Attack Rate
  Stats[15] = [ 619,  "Regeneración de HP" ]# Health Regeneration Rate
  Stats[16] = [ 620,  "Regeneración de MP" ]# Mana Regeneration Rate
  Stats[17] = [ 621,  "Recarga de TP" ]     # Tech Point Regeneration Rate
  Stats[18] = [ nil,  "Estado" ]            # States the gear will resist/inflict
  Stats[19] = [ nil,  "Elemento" ]          # Elements the gear will resist/inflict
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  # - Font Settings -
  #----------------------------------------------------------------------------
  # Use the following format:
  #   [["Font_Name, Font_Name, etc], Font_Size, Bold?, Color]],
  #      Font_Name = an array holding font choices. The fist one is your first 
  #         choice to use, but if the player doesn't have that font on their 
  #         computer, it will go through the list until it finds one it can use
  #      Font_Size = the size font you want to use
  #      Bold? = this should be true for bold, false to turn bold off
  #      Color = This is the same format as setting colors for Gauge Color.
  #         Use [red, blue, green, opacity] or window skin color number.
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  #                     [["Font1", "Font2"], Font_Size, Bold?, Color]
  Fonts[:stat_header] = [["Arial", "한컴 윤체 L"],  18,   false,  16]
  Fonts[:stat_text]   = [["Arial", "한컴 윤체 L"],  18,   false,  0]
  Add_Color = 3                # Can use a number 0 - 31 or a [R, G, B] value
  Sub_Color = 18               # Can use a number 0 - 31 or a [R, G, B] value
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  # - Trigger Key Setting -
  #----------------------------------------------------------------------------
  # You can choose the key that needs to be pressed to open the stats window 
  # while in the crafting menu. The default choice keys are:
  #   :DOWN, :LEFT, :RIGHT, :UP - direction keys. Don't use these if you are 
  #                               allowing crafting of stacks
  #   :F5, :F6, :F7, :F8, :ALT  - Feel free to use any of these keys
  #                               They are pretty self explainatory
  #   :A  - This is the Shift on the keyboard and is the Dash feature. You can 
  #         use it here if you'd like since you can't dash while in menus
  #   :X  - This is the A key on the keyboard and does nothing by default.
  #   :Y  - This is the S key on the keyboard and does nothing by default.
  #   :Z  - This is the D key on the keyboard and does nothing by default.
  #   :L  - This is the Q or Page Up key on the keyboard. The craft menu 
  #         doesn't use this key for anything so it's good choice
  #   :R  - This is the W or Page Down key on the keyboard. The craft menu 
  #         doesn't use this key for anything so it's good choice
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  Trigger_Key = :X                  # Pick the trigger key described from above
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  # - Element Icon Settings -
  #----------------------------------------------------------------------------
  # You can set the icons that will be used for each element here. The id must 
  # match the element ID found on the Terms Tab in the database for the elements
  # For example Element_Icon[1] = 27 would set the "Physical" element's icon 
  # to icon number 27 (the fists hitting icon). Physical is the first element 
  # in the Elements list by default.
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  Element_Icon     = []
  Element_Icon[1]  = 572         # Physical Icon
  Element_Icon[2]  = 573         # Absorb Icon
  Element_Icon[3]  = 528         # Fire Icon
  Element_Icon[4]  = 529         # Ice Icon
  Element_Icon[5]  = 530         # Thunder Icon
  Element_Icon[6]  = 532         # Water Icon
  Element_Icon[7]  = 531         # Earth Icon
  Element_Icon[8]  = 533         # Wind Icon
  Element_Icon[9]  = 542         # Holy Icon
  Element_Icon[10] = 543         # Dark Icon

#==============================================================================
#                          ♦ Edits stop here!! ♦
#==============================================================================
  def self.imported?(script)
    unless $imported[:Venka_Crafting]
      raise("You must install Venka's Crafting script to use #{script}")
    end
  end
end
# Checks to see if the main crafting script is installed.
Venka::Crafting.imported?("Actor Stat Changes")
#==============================================================================
# ■ Crafting_Details_Window
#==============================================================================
class Crafting_Details_Window < Window_Command
  #----------------------------------------------------------------------------
  # ● alias method: item_rect
  #----------------------------------------------------------------------------
  alias actor_stats_item_rect item_rect
  def item_rect(index)
    if SceneManager.scene_is?(Scene_Crafting)
      rect = actor_stats_item_rect(index)
      rect.y -= font_height
      return rect
    else
      rect = actor_stats_item_rect(index)
      return rect
    end
  end
  #----------------------------------------------------------------------------
  # ● alias method: refresh
  #----------------------------------------------------------------------------
  alias actor_stats_refresh refresh
  def refresh
    actor_stats_refresh
    return unless SceneManager.scene_is?(Scene_Crafting)
    # 수정 추가 실험
    set_font(:recipe_list)  # (:help_text)
    text = Venka::Crafting::Key_Instruction
    draw_text(0, contents.height - font_height, contents.width, font_height, text, 1)
  end
end
#==============================================================================
# ■ Window_CraftStats
#==============================================================================
class Window_CraftStats < Window_Selectable
  #----------------------------------------------------------------------------
  # ♦ Public Instance Variables
  #----------------------------------------------------------------------------
  attr_accessor    :item
  attr_reader      :list_window
  #----------------------------------------------------------------------------
  # ● upgraded method: initialize
  #----------------------------------------------------------------------------
  def initialize
    get_window_size
    super(@wx, 48, @wwidth, Graphics.height - 48)
    self.arrows_visible = Venka::Crafting::Vert_Scrolling
    self.opacity = Venka::Crafting::StatsWin_Opacity
    self.back_opacity = Venka::Crafting::StatsWin_BGOpacity
    deactivate
    hide
    close
    @item = nil
    @have_items = false
    select(0)
  end
  #----------------------------------------------------------------------------
  # ○ new method: get_window_size
  #----------------------------------------------------------------------------
  def get_window_size
    # Get the window's width and x positions
    width = Venka::Crafting::Stats_Width
    @wwidth = width > 1 ? width : Graphics.width * width
    @wx = Graphics.width - @wwidth
    # Determine the item_width, spacing and columns
    win_width = @wwidth - (standard_padding * 2)
    item_width = [[(win_width / item_max), 96].max, 120].min
    @cols = (win_width / item_width).to_i
    @cols = 1 if Venka::Crafting::Vert_Scrolling
  end
  #----------------------------------------------------------------------------
  # ● window settings
  #----------------------------------------------------------------------------
  def spacing;                return 0;                                 end
  def col_max;                @cols;                                    end
  def item_max;               $game_party.members.size;                 end
  def standard_padding;       return 10;                                end
  def update_padding_bottom;  self.padding_bottom = standard_padding;   end
  #----------------------------------------------------------------------------
  # ● upgraded method: current_item_enabled?
  #----------------------------------------------------------------------------
  def current_item_enabled?
    return false if !@have_items
    return $game_party.members[@index].equippable?(@item)
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: item_height
  #----------------------------------------------------------------------------
  def item_height
    return 68 if Venka::Crafting::Vert_Scrolling
    height - (standard_padding * 2)
  end
  #----------------------------------------------------------------------------
  # ○ new method: list_window
  #----------------------------------------------------------------------------
  def list_window=(list_window)
    @list_window = list_window
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: update
  #----------------------------------------------------------------------------
  def update
    super
    if @list_window && @list_window.item_max > 0
      if @have_items != @list_window.command_enabled?(@list_window.index)
        @have_items = @list_window.command_enabled?(@list_window.index)
        refresh
      end
      if @item != @list_window.command_name(@list_window.index)
        @item = @list_window.command_name(@list_window.index)
        refresh
      end
    end
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: draw_item
  #----------------------------------------------------------------------------
  def draw_item(index)
    return unless @item
    @actor = $game_party.members[index]
    if @item.is_a?(RPG::EquipItem)
      select(0)
      rect = item_rect(index)
      draw_background_color(rect)
      draw_actor_sprite(rect) # 22.09.19 제거
      resize_rect(rect, @actor_width, 52)   # resize rect for the actor's image
      set_actor_info(index)
      # Draw the stat changes if the item is a piece of gear
      @actor.equippable?(@item) ? check_stat_changes(rect) : draw_no_equip(rect)
    else
      unselect
      set_font(:stat_header)
      draw_text(0, 0, width, height, Venka::Crafting::Not_Gear_Text, 1)
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: set_actor_info
  #----------------------------------------------------------------------------
  def set_actor_info(index)
    @stats_info = Venka::Crafting::Stats
    @temp_actor = Marshal.load(Marshal.dump(@actor))
  end
  #----------------------------------------------------------------------------
  # ○ new method: resize_rect
  #----------------------------------------------------------------------------
  def resize_rect(rect, width, height)
    rect.x += Venka::Crafting::Vert_Scrolling ? width : 3
    rect.y += Venka::Crafting::Vert_Scrolling ? 3 : height
    rect.width  -= Venka::Crafting::Vert_Scrolling ? width : 6
    rect.height -= Venka::Crafting::Vert_Scrolling ? 6 : height
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_background_color
  #----------------------------------------------------------------------------
  def draw_background_color(rect)
    color = Color.new(*Venka::Crafting::Box_Color)
    contents.fill_rect(rect.x+1, rect.y+1, rect.width-2, rect.height-2, color)
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_actor_sprite
  #----------------------------------------------------------------------------
  def draw_actor_sprite(rect)
    @actor_width = Venka::Crafting::Use_FaceSet ? 100 : 50
    x = rect.x + (Venka::Crafting::Vert_Scrolling ? @actor_width/2 : rect.width/2)
    y = rect.y + (Venka::Crafting::Use_FaceSet ? 2 : 7)
    draw_actor_face(@actor, x - 48, y + 4) # 22.09.19 수정
    # 아래 원본
    #if Venka::Crafting::Use_FaceSet
    #  draw_craft_face(@actor.face_name, @actor.face_index, rect.x, rect.y)
    #else
    #  draw_character(@actor.character_name, @actor.character_index, x, y + 34)
    #end
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: draw_craft_face
  #----------------------------------------------------------------------------
  def draw_craft_face(face_name, face_index, x, y)
    # 실험 수정 추가
    width = [item_width - 4, 96].min
    height = 96 #Venka::Crafting::Vert_Scrolling ? item_height - 4 : 50
    bitmap = Cache.face(face_name)
    rect = Rect.new(face_index % 4 * 96, (face_index / 4 * 96), width, height)
    #rect = Rect.new(face_index % 4 * 96, (face_index / 4 * 96) + 24, width, height)
    dx = Venka::Crafting::Vert_Scrolling ? 2 : (item_width - width) / 2
    contents.blt(x + dx, y + 10, bitmap, rect)
    bitmap.dispose
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_no_equip
  #----------------------------------------------------------------------------
  def draw_no_equip(rect)
    set_font(:stat_header)
    draw_text(rect, Venka::Crafting::No_Equip, 1)
  end
  #----------------------------------------------------------------------------
  # ○ new method: check_stat_changes
  #----------------------------------------------------------------------------
  def check_stat_changes(rect)
    set_font(:stat_text)
    h = Venka::Crafting::Vert_Scrolling ? rect.height / 2 : font_height
    if @actor.equips.include?(@item)
      color = Venka::Crafting::Add_Color
      change_color(color.is_a?(Integer) ? text_color(color) : Color.new(*color))
      draw_text(rect, Venka::Crafting::Currently_Equip, 1)
    else
      draw_primary_stats(rect)
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: change_temp_item
  #----------------------------------------------------------------------------
  def change_temp_item
    slot_id = @item.etype_id
    if $imported["YEA-AceEquipEngine"]
      @actor.equip_slots.each_with_index do |etype, i| 
        slot_id = i if etype == @item.etype_id 
      end
    end
    @temp_actor.force_change_equip(slot_id, @item)
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_primary_stats
  #----------------------------------------------------------------------------
  def draw_primary_stats(rect)
    width = Venka::Crafting::Vert_Scrolling ? rect.width * 0.33 : (rect.width - 2)
    #@x = rect.x + 1;            @y = rect.y + 2
    @x = rect.x + 3;            @y = rect.y + 57
    #실험 수정 추가
    @counter = 0
    change_temp_item
    if Venka::Crafting::Track_Prime
      8.times do |param|
        next if @temp_actor.param(param) == @actor.param(param)
        draw_stat_name(param, width, font_height)
        #draw_stat_name(param, width / 2, font_height)
        get_stat_change(@actor.param(param), @temp_actor.param(param), width - 43)
        #get_stat_change(@actor.param(param), @temp_actor.param(param), width / 2)
        @counter += 1
      end
    end
    if Venka::Crafting::Track_Extra
      10.times do |i|
        param = i + 8
        next if @temp_actor.xparam(i) == @actor.xparam(i)
        draw_stat_name(param, width, font_height)
        #draw_stat_name(param, width / 2, font_height)
        get_stat_change(@actor.xparam(i), @temp_actor.xparam(i), width - 43)
        #get_stat_change(@actor.xparam(i), @temp_actor.xparam(i), width / 2)
        @counter += 1
      end
    end
    get_item_features
    draw_icon_sets(rect, width)
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_stat_name
  #----------------------------------------------------------------------------
  def draw_stat_name(param, width, height)
    if @stats_info[param][0]
      draw_icon(@stats_info[param][0], @x, @y)
      draw_text(@x + 25, @y, width - 25, height, @stats_info[param][1])
    else
      draw_text(@x, @y, width, height, @stats_info[param][1], 1)
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: get_stat_change
  #----------------------------------------------------------------------------
  def get_stat_change(actor_stat, temp_stat, width)
    height = Venka::Crafting::Vert_Scrolling ? 25 : font_height
    if temp_stat > actor_stat
      color  = Venka::Crafting::Add_Color
      @symbol = Venka::Crafting::Add_Symbol
      @stat_change = temp_stat - actor_stat
    else
      color  = Venka::Crafting::Sub_Color
      @symbol = Venka::Crafting::Sub_Symbol
      @stat_change = actor_stat - temp_stat
    end
    @stat_change = @stat_change.is_a?(Float) ? @stat_change.round(2) : @stat_change
    @stat_text = "#{@symbol}#{@stat_change}"
    change_color(color.is_a?(Integer) ? text_color(color) : Color.new(*color))
    draw_text(@x + width, @y, width, height, @stat_text)
    if Venka::Crafting::Vert_Scrolling
      if @counter % 2 == 0
        @y += height
      else
        @y -= height unless @counter == 0
        @x += width * 2
      end
    else
      @y += height
    end
    set_font(:stat_text)
  end
  #----------------------------------------------------------------------------
  # ○ new method: get_item_features
  #----------------------------------------------------------------------------
  def get_item_features
    @ele_icons = [];       @state_icons = []
    @item.features.each do |feature| 
      case feature.code
      when 13, 14, 32                  # State Icons
        @state_icons << $data_states[feature.data_id].icon_index
      when 11, 31, 32                  # Element Icons
        @ele_icons << Venka::Crafting::Element_Icon[feature.data_id]
      end
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_icon_sets
  #----------------------------------------------------------------------------
  def draw_icon_sets(rect, width)
    if Venka::Crafting::Vert_Scrolling && @counter % 2 != 0
      @x += width + 1;         @y -= 25
    end
    if @state_icons != []
      draw_icons(@state_icons, @x, @y, width)
      Venka::Crafting::Vert_Scrolling ? @x += width + 1 : @y += 50
    end
    draw_icons(@ele_icons, @x, @y, width) if @ele_icons != []
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_icons
  #----------------------------------------------------------------------------
  def draw_icons(icons, x, y, width)
    header = icons == @state_icons ? @stats_info[18] : @stats_info[19]
    dx = 0
    if header[0] 
      draw_icon(header[0], x, y)
      dx + 25
    end
    set_font(:stat_text)
    draw_text(x + dx, y, width - dx, font_height, header[1], 1)
    y += line_height
    icons.each_with_index do |icon, i|
      # Determine how many icons can be shown
      max_icons = [(width / 24).to_i, icons.size].min
      return if i >= max_icons
      dx = ((width - (max_icons * 24)) * 0.5) + (i * 24)
      draw_icon(icon, x + dx, y)
    end
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: call_cancel_handler
  #----------------------------------------------------------------------------
  def call_cancel_handler
    close
    call_handler(:cancel)
  end
end
#==============================================================================
# ■ Crafting_Confirmation_Window
#==============================================================================
class Crafting_Confirmation_Window < Window_Command
  #----------------------------------------------------------------------------
  # ● upgraded method: initialize
  #----------------------------------------------------------------------------
  def initialize
    super((Graphics.width - window_width)/2, (Graphics.height - window_height)/2)
    self.opacity = Venka::Crafting::Result_Opacity
    self.back_opacity = Venka::Crafting::Result_BGOpacity
    hide
    @actor = nil
    deactivate
  end
  #----------------------------------------------------------------------------
  # ● window settings
  #----------------------------------------------------------------------------
  def window_width;   Graphics.width * 0.8;                               end
  def window_height;  item_height * 3;                                    end
  def col_max;        return 2;                                           end
  def item_height;    [Venka::Crafting::Fonts[:other_text][1], 24].max;   end
  def alignment;      return 1;                                           end
  #----------------------------------------------------------------------------
  # ○ new method: actor
  #----------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    @actor = actor.name
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: item_rect
  #----------------------------------------------------------------------------
  def item_rect(index)
    rect = super
    rect.y += contents.height - item_height
    rect
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: make_command_list
  #----------------------------------------------------------------------------
  def make_command_list
    add_command(Venka::Crafting::Confirm_Craft, :ok)
    add_command(Venka::Crafting::Cancel_Craft,  :cancel)
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: refresh
  #----------------------------------------------------------------------------
  def refresh
    contents.clear
    return if @actor.nil?
    resize_window
    show
    set_font(:other_text)
    draw_all_items
    draw_text(0, 0, contents.width, font_height, Venka::Crafting.craft_text(@actor), 1)
  end
  #----------------------------------------------------------------------------
  # ○ new method: resize_window
  #----------------------------------------------------------------------------
  def resize_window
    clear_command_list
    make_command_list
    self.x = (Graphics.width - win_width) * 0.5
    self.width = win_width
    create_contents
    update_cursor
  end
  #----------------------------------------------------------------------------
  # ○ new method: win_width
  #----------------------------------------------------------------------------
  def win_width
    set_font(:other_text)
    width = text_size(Venka::Crafting.craft_text(@actor)).width + 50 
    return [width, Graphics.width].min
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: draw_text_ex
  #----------------------------------------------------------------------------
  def draw_text_ex(x, y, text)
    text = convert_escape_characters(text)
    pos = {:x => x, :y => y, :new_x => x, :height => calc_line_height(text)}
    process_character(text.slice!(0, 1), text, pos) until text.empty?
  end
end
#==============================================================================
# ■ Scene_Crafting
#==============================================================================
class Scene_Crafting < Scene_Base;                      include Venka::Crafting
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
    # 배경 반투명 적용
    create_background
  end
  #----------------------------------------------------------------------------
  # 배경 반투명 적용
  #----------------------------------------------------------------------------
  def terminate
    super
    dispose_background
  end
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
  def dispose_background
    @background_sprite.dispose
  end
  def dispose_main_viewport
    @background_sprite.dispose
  end
  #----------------------------------------------------------------------------
  # ○ new method: create_status_window
  #----------------------------------------------------------------------------
  def create_status_window
    @status_window = Window_CraftStats.new
    @status_window.set_handler(:ok,      method(:command_confirm))
    @status_window.set_handler(:cancel,  method(:return_to_details))
    @status_window.viewport = @viewport
    @status_window.list_window = @list_window
  end
  #----------------------------------------------------------------------------
  # ○ new method: command_confirm
  #----------------------------------------------------------------------------
  def command_confirm
    @actor = $game_party.members[@status_window.index]
    @confirm_window.actor = @actor
    @confirm_window.refresh
    @confirm_window.activate
  end
  #----------------------------------------------------------------------------
  # ○ new method: return_to_details
  #----------------------------------------------------------------------------
  def return_to_details
    #@details ? @detail_window.activate : @list_window.activate
    if @details
      @detail_window.activate
    else
      @detail_window.unselect
      @list_window.activate
    end
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
    return return_to_stats if !@list_window.command_enabled?(@list_window.index)
    @confirm_window.hide
    @status_window.close.hide
    @detail_window.number = 1
    @detail_window.refresh
    craft_start
    item = $craft.results[1][2]
    gear = item.is_a?(Array) ? item[0] : item
    equip_item(@actor, gear)
    @status_window.refresh
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
    @status_window.activate
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
    @status_window.show.open
    @status_window.activate
  end
  #--------------------------------------------------------------------------
  # 상세 데이터 설명창 추가
  #--------------------------------------------------------------------------
  def create_description_window
    @description_window = Window_ItemDescription.new
    @description_window.z = 2010
    on_item_description
    
    # 리스트, 제작창 비활성화
    @list_window.deactivate
    @detail_window.deactivate
    
    @description_window.activate
    @description_window.set_handler(:ok,     method(:on_description_ok))
    @description_window.set_handler(:cancel, method(:on_description_cancel))
  end
  def on_description_ok
    @description_window.deactivate
    #@list_window.activate
    #@detail_window.activate
    hide_sub_window(@description_window)
    #@description_window = nil
    return_to_details # 리스트, 제작창 활성화 결정
  end
  def on_description_cancel
    Sound.play_cancel
    @description_window.deactivate
    #@list_window.activate
    #@detail_window.activate
    hide_sub_window(@description_window)
    #@description_window = nil
    return_to_details # 리스트, 제작창 활성화 결정
  end
  def on_item_description
    @description_window.refresh(@status_window.item)
    show_sub_window(@description_window)
  end
  def show_sub_window(window)
    @title_window.hide
    @detail_window.hide
    @list_window.hide.deactivate
    window.show.activate
  end
  def hide_sub_window(window)
    window.hide.deactivate
    @title_window.show
    @detail_window.show
    @list_window.show.activate
  end
  #----------------------------------------------------------------------------
  # ● alias method: update
  #----------------------------------------------------------------------------
  alias actor_stats_window_update update
  def update
    actor_stats_window_update
    #--------------------------------------------------------------------------
    # 상세 데이터 설명창 추가
    #--------------------------------------------------------------------------
    if @status_window.item != nil
      create_description_window if Input.trigger?(Venka::Crafting::Trigger_Key) or Keyboard.trigger?(:kN)
    end
    #--------------------------------------------------------------------------
    #open_stats_window if Input.trigger?(Venka::Crafting::Trigger_Key)
  end
end