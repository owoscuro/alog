# encoding: utf-8
# Name: Venka's Bestiary v1.8
# Size: 94905
# encoding: utf-8
# Name: Venka's Bestiary v1.8
# Size: 96896
#==============================================================================
# ▼ Venka's Bestiary v1.8                                  Updated: 01/21/2014
#   author: Venka
#==============================================================================
# - Changelog -
#------------------------------------------------------------------------------
# 01/21/2014 - Added in a section for debuff resistances.
#            - Fixed display issue when a resistance was set to 120%
#            - Added compatibility with Yanfly's Element Absorb script
#            - Added a spot to set the text color for Immunity and Absorbtion
#            - Fixed a bug that wasn't displaying state immunities.
# 12/05/2014 - Stats will now correct if passive stats boost them for states 
#              and elements as well.
# 12/03/2014 - Stats will now correct if passive stats boost them
# 11/30/2014 - Fixed issue with manually adding enemy entries.
# 11/09/2014 - Added in a scroll speed setting so you can speed up the scroll
#              when viewing information about an enemy.
#            - Added in stats revealed by kill counts. You can set what 
#              information will be shown after you kill an enemy x amount of 
#              times
# 10/27/2014 - Forgot to dispose of the instructions on the battle scene.
# 10/14/2014 - Added ability to store quotes for the Actor's Input addon.
#            - Added KilloZapit's Word Wrapper support
# 09/24/2014 - Adjusted the contents of the bestiary stat windows so be able 
#              to show large amounts of elements and states. The window panes 
#              are now scrollable to view all the information.
#            - The scan window in battle was also updated in the above way.
# 09/21/2014 - Fixed a bug if no categories are set up in the enemy note tags.
# 09/14/2014 - changed the name of one of the methods so it's compatiable with
#              some of my other scripts.
# 08/14/2014 - Released for code off challenge
#------------------------------------------------------------------------------
# - Author's Note -
#------------------------------------------------------------------------------
# Just a quick note. This script was written for the Code Off Challenge found 
# here: http://forums.rpgmakerweb.com/index.php?/forum/102-code-off-challenge/
#------------------------------------------------------------------------------
# - Terms -
#------------------------------------------------------------------------------
# This script can be used commercially or non-commercially. If it's used 
# commercially, I'd like a PM via the forums with a link to the game so I can 
# follow it's progress.. but this isn't required ;) Just a I'd like to take a 
# peak type of thing :)
#------------------------------------------------------------------------------
# - Introduction -
#------------------------------------------------------------------------------
# This script will give you a scene that you can track the enemies you've 
# discovered and/or killed. It will keep track of the enemy's stats, skills, 
# drops, resistances to elements and status effects as well as showing a 
# description and image of the enemy.
#------------------------------------------------------------------------------
# - Instructions -
#------------------------------------------------------------------------------
# This script will work if you drop it into your game project. Knowledge of 
# note tagging will help take advantage of all the features.
# 
#------------------------------------------------------------------------------
# - Enemy Note Tags -
#------------------------------------------------------------------------------
# You can set a custom description for each enemy. If you skip this notetag, 
# then it'll use the description set at Default_Description. The text will 
# take the same codes you use in message windows but you'll need to add an 
# extra \ before each. So \C[1] will need to be \\C[1]. You can use KilloZapit's 
# word wrapper to auto fit the text into the box for you or use | to start a 
# new line of text if you don't want to use KilloZapit's Word Wrapper.
# See the demo enemy note tag boxes for examples.
#    <description1: your text goes here>
# 
# When in the Bestiary Scene, enemies will appear on a background that looks 
# the battleback images. You can set the default images used and set images to 
# use for each Category you set up. However, if you'd like certain enemies to 
# have their very own images that's different from the default or category 
# images then use the following tags:
#    <bg_floor: file>   - It'll look for the file in Battlebacks1 and if not 
#                         found, then it'll look in the Pictures folder.
#    <bg_wall: file>    - It'll look for the file in Battlebacks2 and if not 
#                         found, then it'll look in the Pictures folder.
# NOTE: Do not put ""'s around the file's name. If you want to use a single 
# file, then set either the bg_floor or bg_wall to the image you want to use 
# and set the other one to nil.
# 
# Sometimes there are enemies that you do not want to track or if you are like 
# me, you like to sort your database in sections and use labels. To make sure 
# none of these database entries make it into the bestiary scene, use this tag:
#    <skip>             - when this tag is used, no entry will be made
# 
# Some games have multiple database entries of the same enemy but they change 
# the stats a little for variance or change the graphic for varity. But they 
# are all still considered the same enemy. In this case you can use this tag 
# so no matter which one you encounter, it'll only show one entry.
#    <shown_id: x>      - x is the database ID to use in the Bestiary
# 
# 카테고리 태그는 가장 많이 사용되는 태그가 됩니다. 에서 카테고리를 설정할 수 있습니다.
# 사용자 정의 섹션. 원하는 방식으로 우화 장면을 정렬할 수 있습니다.
# 예를 들어 Common Enemies, Rare Enemies, Boss Enemies, Elite 등이 있을 수 있습니다.
# 또는 이 데모에서와 같이 위치별로. 적은 여러 범주로 나타날 수 있습니다.
# 다음 태그를 사용하여 적의 범주를 설정합니다.
#    <category: x>     - x is the Category ID defined below.
#
# To make an enemy immune to scans, use the following code
#    <no_scan>         - enemy is immune to scan skill
# 
#------------------------------------------------------------------------------
# - Item/Skill Note Tags -
#------------------------------------------------------------------------------
# The last note tag can go in a skill or items note tag. It allows you to scan 
# an emeny to learn information about it.
#    <scan>            - When used on an enemy, it unlocks information
# 
#------------------------------------------------------------------------------
# - Script Call -
#------------------------------------------------------------------------------
#                      - Manually Add Bestiary Entry -
# Just incase you need to manually add a bestiary entry, use the following:
#     add_enemy_entry(enemy_id)   - enemy_id is the id in the Database
# 
#              - Changing Enemy's Description via script call -
# You can change an enemy's description with a script call. When you set a 
# description with the script call it will override any other description text 
# that is found (the default description or custom descriptions by kills).
# To set the description by script call use the following format:
#     set_enemy_description(enemy_id, text)    - enemy_id is the database id
#                                              - text is text shown.
# The text follows the same rules as all the other description text. You can 
# use message codes to change text color, size, use icons.. etc. Use | to form 
# a line break. If you want the description to be blank, then set text to "".
#
# To reset the description text back to what it'd normally be use:
#     reset_enemy_description(enemy_id)        - enemy_id is the database id
# 
#              - Getting the kill count for an Enemy -
# You can get the amount of times you've killed a given enemy should you need 
# it for a conditional check or whatever reason. Use:
#     enemy_kill_count(enemy_id)               - enemy_id is the database id
# 
# NOTE: If the enemy_id given has the <shown_id: x> in it, then it'll go to 
#       the enemy id pointed to by the note tag.
#==============================================================================
# ■ Configuration
#==============================================================================
$imported ||= {}; $imported[:Venka_Bestiary] = true

module Venka; module Bestiary
  
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  # - General Settings -
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  Windowskin       = "Window"    # 기본 스킨은 nil로 설정합니다.
  Window_Opacity   = 255         # 창은 모든 불투명도 위에 있습니다. 숫자 0 - 255
  Window_BGOpacity = 180         # 창의 배경 불투명도(기본값 192)
  Use_Dividers = true            # 구분선을 그려 정보를 나누시겠습니까?
  Line_Color = [150, 150, 250, 225] # [Red, Blue, Green, Alpha] color for lines
  Frame_Image = false            # 적 이미지 주위에 창 테두리를 그리시겠습니까?
  Menu_Access = true             # 메뉴에서 Bestiary에 액세스하시겠습니까?
  Scroll_Speed = 6               # ↑↓ 눌렀을 때 정보가 이동하는 속도
  Track_Progress = true          # 이것은 각 카테고리에 대한 완료를 보여줍니다
  Track_Kills = true             # 적을 죽인 시간 추적
  Show_Debuff_Info = true        # 디버프 정보 섹션 표시
  Use_Wordwrapper = true         # KilloZapit의 자동 줄 바꿈 스크립트를 사용하여
  
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  # - Default Settings -
  #----------------------------------------------------------------------------
  # You can set the default info for the back ground images used for each 
  # enemy and the enemy's description if you don't make custom info for each.
  # If you only want to use one background image, then set one to an image 
  # found in it's Battleback folder or the Pictures folder and set the other to 
  # nil.
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  Default_BGFloor = "Dirt1"      # Default ground image used (Battlebacks1)
  Default_BGWall  = "Forest1"    # Default wall image used (Battlebacks2)
  # The description text can use message codes (ex: \c[1] - changes text color).
  # Use | to force a line break.
  Default_Description = "No se sabe mucho sobre este enemigo."
  # Descriptions can evolve as you kill more enemies. These descriptions must 
  # be set via the note tags. If the description isn't set, then it will skip 
  # the description and show the lower message or default message instead.
  # Set the kill goals here:
  Description1 = 0               # This message will show at 0 kills
  Description2 = 3               # This message will show after 3 kills
  Description3 = 8               # This message will show after 8 kills
  
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  # - Reveal by Kill Settings -
  #----------------------------------------------------------------------------
  # You can set what information will be shown for enemies by the amount of 
  # times they have been killed. Using the scan skill will also unlock all of 
  # the following information regardless of the kills for a given enemy.
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  Show_BaseStats   = 3             # Shows base stats: Atk, Def, Mdf, Mat, etc
  Show_Elements    = 3             # Shows elemental resistances
  Show_States      = 5             # Shows state resistances
  Show_DebuffStats = 1             # Shows debuff rates
  Show_Abilities   = 7             # Shows a list of abilities that can be used
  Show_Loot        = 5             # Shows the drop list for the enemy
  
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  # - Text Settings -
  #----------------------------------------------------------------------------
  # You can set all text that appears in the Bestiary scene.
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  Bestiary_Command = "Bestiario"
  Category_Select  = "Seleccionar categoría"
  Enemy_Select     = "Seleccionar enemigo"
  Discovered_Text  = "Enemigo descubierto"
  Percent_Finished = "Completado"
  Unknown_Loot = "Sin información de botín."
  Unknown_Skills = "Habilidades desconocidas"
  View_More    = "Más información"
  View_Stats   = "Información básica"
  View_Element = "Elementos"
  View_States  = "Buffs"
  View_Debuff  = "Debuffs"
  Stats_Text   = "Información de estadísticas"
  Element_Text = "Eficacia elemental"
  Status_Text  = "Resistencia a estados alterados"
  Debuff_Text  = "Tasa de debuffs"
  Loot_Text    = "Experiencia obtenida"
  Loot_Item    = "Botín obtenido"
  Skill_Text   = "Habilidades"
  Immune_Text  = "Estado inmune"
  Absorb_Text  = "Absorción elemental"
  Unknown_Stat = "??"
  Exp_Text  = ["Exp : ", 113]
  #Exp_Text  = ["Exp :", 113]
  Gold_Text = ["Oro : ", 262]
  Kills_Text = "Muertes"
  #Instructions_Text = "Q 버튼으로 목록에서 위의 적, W 버튼으로 목록에서 아래의 적을 확인합니다."
  #Battle_Instructions = "자세한 정보를 보려면 Shift 버튼을 누르십시오."
  
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  # - Scan Skill Setting - 
  #----------------------------------------------------------------------------
  # You can set stuff for the scan skill here. Mostly this is setting text 
  # that appears in the game. You can also set the key that is pressed to 
  # make the pop up window show when you select an enemy in the enemy window.
  # NOTE: The window will pop up on a successful scan as well
  #
  # Key options are:                   :A  - this is the Shift key
  #   :X   - this is the A key         :Y  - this is the S key
  #   :Z   - this is the D key         :L  - this is PageUp/Q Keys
  #   :R   - this is PageDw/W keys     :SHIFT, :CTRL, :ATL - shift, cntl, atl keys
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\

  Target_Scanned = "%s escaneado!" # Mensaje de batalla cuando se escanea con éxito
  No_Scan = "%s no se puede escanear!" # Mensaje de batalla cuando el objetivo no puede ser escaneado
  No_Info = "No hay información." # Texto cuando el objetivo es inmune a los escaneos.
  Scan_PopUp = :SHIFT # Tecla de entrada para hacer que la ventana aparezca
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  # - List Sort Setting - 
  #----------------------------------------------------------------------------
  # You can set how the list will sort. You can sort it by order discovered 
  # (discovery order should be the default), by their database id, or name.
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  Sort_Type = :id      # choices are :id, :name, or :default
  
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  # - Font Settings -
  #----------------------------------------------------------------------------
  # :help_font    = font that appears in the top and bottom windows
  # :list_font    = font in the list windows
  # :header_font  = font used for statistic types
  # :stat_font    = font used for statistics
  # :description  = font for enemy description text.
  # 
  # For each text type you need to set up the Fonts, Size, Boldness and Color.
  # Use the following format:
  #   [["Font_Name, Font_Name, etc], Font_Size, Bold?, Color]],
  #      Font_Name = an array holding font choices. The fist one is your first 
  #         choice to use, but if the player doesn't have that font on their 
  #         computer, it will go through the list until it finds one it can use
  #      Font_Size = the size font you want to use
  #      Bold? = this should be true for bold, false to turn bold off
  #      Color = This is the same format as setting colors for Gauge Color.
  #         Use [red, blue, green, opacity] or window skin color number.
  #      Outline? = this turns the font's outline on or off
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  Fonts = {       # [["Fonts"]],           Size, Bold?, Color, Outline?
    :normal_font => [["한컴 윤체 L"], 22, false,  0,      true],
    :list_font   => [["한컴 윤체 L"], 23, false,  0,      true],
    :header_font => [["한컴 윤체 L"], 22, false,  1,      true],
    :stat_name   => [["한컴 윤체 L"], 19, false,  0,      true],
    :stats_font  => [["한컴 윤체 L"], 19, false,  0,      true],
    :description => [["한컴 윤체 L"], 21, false,  0,      true],
    } # <- DO NOT REMOVE
  # The two color settings below can be windowskin colors or [red, blue, green]
  High_Resist = 3       # Color used for high resistances
  Low_Resist  = 18      # Color used for low resistances (weaknesses)
  Immunity_Color = 17   # Color used for immunity/absorb text
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  # - Battle Font Settings -
  #----------------------------------------------------------------------------
  # The battle font is slightly different then the font that appears in windows.
  # For this one, colors MUST be in [red, blue, green] format.
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  #                   Font Family,      Size, Bold?,    Color,     Outline?]
  Battle_Font = [["한컴 윤체 L"], 23,  true, [255,255,255],   true]
  
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  # - Base Stat Settings -
  #----------------------------------------------------------------------------
  # Set the text and/or Icon used for base stats (HP, MP, Attack, etc)
  # You can set either the text or the icon to nil to omit them.
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  Base_Stats = [] #["Texto", Índice de Icono]
  Base_Stats[0] = ["HP", 626] # Salud Máxima
  Base_Stats[1] = ["MP", 630] # Mana Máximo
  Base_Stats[2] = ["Ataque", 549] # Ataque
  Base_Stats[3] = ["Defensa", 594] # Defensa
  Base_Stats[4] = ["Ataque Mágico", 550] # Ataque Mágico
  Base_Stats[5] = ["Defensa Mágica", 616] # Defensa Mágica
  Base_Stats[6] = ["Agilidad", 605] # Agilidad
  Base_Stats[7] = ["Suerte", 551] # Suerte
  
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  # - Element Settings -
  #----------------------------------------------------------------------------
  # Elements you want to track. Prioritize the elements. In the default game 
  # resolution, about 9 icons will show. If you make the screen wider, then 
  # more could be shown. So list the icons you want to show in order of 
  # importance.
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  Elements = [
  # [ID, IconIndex],
    [3,  529],   # 화
    [4,  530],   # 빙
    [5,  531],   # 뇌
    [6,  532],   # 수
    [7,  533],   # 지
    [8,  534],   # 풍
    [9,  539],   # 성
    [10, 544],   # 암
    ] # <- DO NOT REMOVE!!
    
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  # - State Settings -
  #----------------------------------------------------------------------------
  # This is just like setting the Elements, but there is no need to define an 
  # icon because all that status/states have an icon set in the database.
  # So for this one, just set the status id's that you want to track in order
  # of priority.
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  States = [1, 2, 3, 4, 5, 6, 7, 8]
  
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  # - Category Settings -
  #----------------------------------------------------------------------------
  # You can set up categories that the enemies will be sorted into. This can 
  # be by whatever you like. For example you could sort them by breed (mammal, 
  # avian, demon, etc) or by region (Forest, River, Mountains, etc). You must 
  # set up all the categories here and then use a note tag Enemies Tab of the 
  # database to set it. 
  # 
  #   Category[ID] = {               # ID must be a unique number.
  #    :name => "Miscellaneous",     # Name of Category as it appears in scene
  #    :bg_floor => "file",          # Image used if not default (can omit)
  #    :bg_wall  => "file",          # Image used if not default (can omit)
  #           file = file used instead of the default image. Set to "" if you 
  #                  want to use no image.
  #    }
  #
  # NOTE: both the floor and wall images can be omited to use the default 
  # images. If using a single image, then set one or the other to the image 
  # you want to use (found in the corrosponding battleback folder or the 
  # picture's folder) and then set the other to "" (a blank file). Do not set 
  # the other image to nil as this will pick up the default image.
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  Category ||= {}
  #----------------------------------------------------------------------------
  Category[0] = { # Esta es la categoría por defecto. Los enemigos aparecen en esta
  # categoría si no tienen una asignada o hay un error tipográfico en la etiqueta.
  :name => "Animal",
  } # <-NO ELIMINAR
  #----------------------------------------------------------------------------
  Category[1] = { # Enemigos encontrados en el área del Bosque Abandonado
  :name => "Planta", # Nombre de la Categoría
  }
  #----------------------------------------------------------------------------
  Category[2] = { # Enemigos encontrados en el área de las Minas Abandonadas
  :name => "Insecto", # Nombre de la Categoría
  }
  #----------------------------------------------------------------------------
  Category[3] = { # Enemigos encontrados en el área del Espacio Profundo
  :name => "Humanoide", # Nombre de la Categoría
  }
  #----------------------------------------------------------------------------
  Category[4] = { # Enemigos encontrados en el área de las Llanuras Nocturnas
  :name => "Pez", # Nombre de la Categoría
  }
  #----------------------------------------------------------------------------
  Category[5] = { # Enemigos No-Muertos
  :name => "Demonio", # Nombre de la Categoría
  }
  #----------------------------------------------------------------------------
  Category[6] = { # Enemigos encontrados en el área de las Llanuras Nocturnas
  :name => "Dragón", # Nombre de la Categoría
  }
  #----------------------------------------------------------------------------
  Category[7] = { # Enemigos encontrados en el área de las Llanuras Nocturnas
  :name => "Incorpóreo", # Nombre de la Categoría
  }
  #----------------------------------------------------------------------------
  Category[8] = { # Enemigos encontrados en el área de las Llanuras Nocturnas
  :name => "Ángel", # Nombre de la Categoría
  }
  #----------------------------------------------------------------------------
  Category[9] = { # Enemigos encontrados en el área de las Llanuras Nocturnas
  :name => "No-muerto", # Nombre de la Categoría
  }
#==============================================================================
# ■ Edits should stop here unless you know what you're doing :)
#==============================================================================
  end
  module Notetag
    Skip_Enemy = /<skip>/i
    Enemy_Category = /<category:\s*(\d+(?:\s*,\s*\d+)*)>/i
    #BG_Floor   = /<bg_floor:\s*(\w+)>/i   # 몬스터 그래픽
    BG_Floor   = /<bg_floor:\s*(.*)>/i     # 몬스터 그래픽
    BG_Wall    = /<bg_wall:\s*(\w+)>/i
    Enemy_Desc1 = /<description1:\s*(.*)>/i
    Enemy_Desc2 = /<description2:\s*(.*)>/i
    Enemy_Desc3 = /<description3:\s*(.*)>/i
    Shown_ID   = /<shown_id:\s*(\d+)>/i
    Scan_Skill = /<scan>/i
    No_Scan    = /<no_scan>/i
  end
end
#------------------------------------------------------------------------------
# ○ Creating a way to store discovered info about the enemy with Struct.
#------------------------------------------------------------------------------
Bestiary_Entry = Struct.new(:enemy_id, :category, :elements, :states, :kills, 
    :quotes, :scanned, :dropitem)
#==============================================================================
# ■ Vocab
#==============================================================================
module Vocab
  # Scan Skill
  Scanned = Venka::Bestiary::Target_Scanned
  No_Scan = Venka::Bestiary::No_Scan
end
#==============================================================================
# ■ DataManager
#==============================================================================
module DataManager
  #----------------------------------------------------------------------------
  # ● alias method: load_database
  #----------------------------------------------------------------------------
  class << self;  alias bestiary_db_notetags load_database;   end
  def self.load_database
    bestiary_db_notetags
    load_bestiary_notetags
  end
  #----------------------------------------------------------------------------
  # ○ new method: load_bestiary_notetags
  #----------------------------------------------------------------------------
  def self.load_bestiary_notetags
    #($data_enemies + $data_skills + $data_items).compact.each do |item|
    $data_enemies.compact.each do |item|
      item.load_bestiary_notetags
    end
  end
end
#==============================================================================
# ■ RPG::UsableItem
#==============================================================================
class RPG::UsableItem
  #----------------------------------------------------------------------------
  # ♦ Public Instance Variables
  #----------------------------------------------------------------------------
  attr_accessor :scan
  #----------------------------------------------------------------------------
  # ○ new method: load_bestiary_notetags
  #----------------------------------------------------------------------------
  def load_bestiary_notetags
    @scan = false
    self.note.split(/[\r\n]+/).each do |line|
      info = []
      case line
      when Venka::Notetag::Scan_Skill;        @scan = true
      end
    end
  end
end
#==============================================================================
# ■ RPG::Enemy
#==============================================================================
class RPG::Enemy
  #----------------------------------------------------------------------------
  # ♦ Public Instance Variables
  #----------------------------------------------------------------------------
  attr_accessor :skip, :category, :bg_floor, :bg_wall, :description, :shown_id, :dropitem
  attr_accessor :no_scan, :descript1, :descript2, :descript3
  #----------------------------------------------------------------------------
  # ○ new method: load_bestiary_notetags
  #----------------------------------------------------------------------------
  def load_bestiary_notetags
    @skip = false
    @category = [0]
    @dropitem = []  # 드랍 아이템 추가
    @bg_floor = @bg_wall = ""
    @shown_id = @id
    @no_scan = false
    @description = nil
    @descript1 = @descript2 = @descript3 = nil
    self.note.split(/[\r\n]+/).each do |line|
      info = []
      case line
      when Venka::Notetag::Skip_Enemy;        @skip = true
      when Venka::Notetag::No_Scan;           @no_scan = true
      when Venka::Notetag::Enemy_Category
        $1.scan(/\d+/).each { |num| info.push(num.to_i) }
        @category = info ? info : 0
        #print("Venka's Bestiary v1.8 - @category, %s \n" % [@category]);
      when Venka::Notetag::BG_Floor
        @bg_floor = $1.to_s
        #print("Venka's Bestiary v1.8 - @bg_floor, %s \n" % [@bg_floor]);
      when Venka::Notetag::BG_Wall;           @bg_wall = $1.to_s
      when Venka::Notetag::Enemy_Desc1;       @descript1 = $1.to_s
      when Venka::Notetag::Enemy_Desc2;       @descript2 = $1.to_s
      when Venka::Notetag::Enemy_Desc3;       @descript3 = $1.to_s
      when Venka::Notetag::Shown_ID;          @shown_id = $1.to_i
      end
    end
  end
end
=begin
#==============================================================================
# ■ BattleManager
#==============================================================================
module BattleManager
  #----------------------------------------------------------------------------
  # ● alias method: battle_start
  #----------------------------------------------------------------------------
  class << self;  alias bestiary_battle_start battle_start;   end
  def self.battle_start
    bestiary_battle_start
    add_bestiary_enemies
  end
  #----------------------------------------------------------------------------
  # ○ new method: add_bestiary_enemies
  #----------------------------------------------------------------------------
  def self.add_bestiary_enemies
    $game_troop.members.each do |enemy|
      rpg_enemy = $data_enemies[enemy.enemy_id]
      next if rpg_enemy.nil? || rpg_enemy.skip
      unless $game_party.bestiary_include?(rpg_enemy.shown_id)
        $game_party.add_enemy($data_enemies[rpg_enemy.shown_id])
      end
    end
  end
end
=end
#==============================================================================
# ■ Game_Enemy
#==============================================================================
class Game_Enemy < Game_Battler
  #----------------------------------------------------------------------------
  # ● upgraded method: add_state
  #----------------------------------------------------------------------------
  def add_state(state_id)
    Venka::Bestiary::States.each_with_index do |id, i|
      next unless state_id == id
      next unless $game_party.bestiary  # 오류 방지
      $game_party.bestiary.each do |enemy|
        next unless enemy.enemy_id == $data_enemies[@enemy_id].shown_id
        enemy.states[i] = true
      end
    end
    super
  end
end
=begin
#==============================================================================
# ■ Game_Troop
#==============================================================================
class Game_Troop < Game_Unit
  #----------------------------------------------------------------------------
  # ● alias method: battle_start
  #----------------------------------------------------------------------------
  alias bestiary_kill_count make_drop_items
  def make_drop_items
    add_encounter_count
    bestiary_kill_count
  end
  #----------------------------------------------------------------------------
  # ○ new method: add_encounter_count
  #----------------------------------------------------------------------------
  def add_encounter_count
    dead_members.each do |enemy|
      rpg_enemy = $data_enemies[enemy.enemy_id]
      next if rpg_enemy.nil? || rpg_enemy.skip
      $game_party.bestiary.each do |entry|
        next unless entry.enemy_id == rpg_enemy.shown_id
        entry.kills += 1
        case entry.kills
        when Venka::Bestiary::Show_Elements
          entry.elements.size.times {|i| entry.elements[i] = true}
        when Venka::Bestiary::Show_States
          entry.states.size.times {|i| entry.states[i] = true}
        end
      end
    end
  end
end
=end
#==============================================================================
# ■ Game_Party
#==============================================================================
class Game_Party < Game_Unit
  #----------------------------------------------------------------------------
  # ♦ Public Instance Variables
  #----------------------------------------------------------------------------
  attr_accessor   :bestiary
  #----------------------------------------------------------------------------
  # ● alias method: initialize
  #----------------------------------------------------------------------------
  alias venka_bestiary_enounters_ini initialize
  def initialize
    venka_bestiary_enounters_ini
    @bestiary = []
  end
  #----------------------------------------------------------------------------
  # ○ new method: add_enemy
  #----------------------------------------------------------------------------
  # The entries are: EnemyID, BestiaryCategory, Array for Element info, 
  #   Array for State info, Kill Counter, Actor Quotes, and Scanned?
  #----------------------------------------------------------------------------
  def add_enemy(enemy)
    @bestiary << Bestiary_Entry.new(enemy.id, enemy.category, 
        Array.new(Venka::Bestiary::Elements.size, false), 
        Array.new(Venka::Bestiary::States.size, false), 0, [], false)
  end
  #----------------------------------------------------------------------------
  # ○ new method: reveal_resist
  #----------------------------------------------------------------------------
  def reveal_resist(enemy_id, reveal = true)
    rpg_enemy = $data_enemies[enemy_id]
    return if rpg_enemy.nil? || rpg_enemy.skip
    @bestiary.each do |entry|
      next unless entry.enemy_id == rpg_enemy.shown_id
      next if rpg_enemy.no_scan && !reveal
      entry.elements.size.times {|i| entry.elements[i] = true}
      entry.states.size.times {|i| entry.states[i] = true}
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: bestiary_include?
  #----------------------------------------------------------------------------
  def bestiary_include?(id)
    return false if @bestiary == nil # 오류 방지
    @bestiary.each do |entry|
      return true if entry.enemy_id == id
    end
    return false
  end
end
#==============================================================================
# ■ Game_Interpreter
#==============================================================================
class Game_Interpreter
  #----------------------------------------------------------------------------
  # ○ new method: add_enemy_entry
  #----------------------------------------------------------------------------
  def add_enemy_entry(enemy_id)
    rpg_enemy = $data_enemies[enemy_id]
    return if rpg_enemy.nil? || rpg_enemy.skip
    if $game_party.bestiary == []
      $game_party.add_enemy($data_enemies[rpg_enemy.shown_id])
    elsif !$game_party.bestiary_include?(rpg_enemy.shown_id)
      $game_party.add_enemy($data_enemies[rpg_enemy.shown_id])
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: set_enemy_description
  #----------------------------------------------------------------------------
  def set_enemy_description(enemy_id, text)
    id = $data_enemies[enemy_id].shown_id
    $data_enemies[id].description = text
  end
  #----------------------------------------------------------------------------
  # ○ new method: reset_enemy_description
  #----------------------------------------------------------------------------
  def reset_enemy_description(enemy_id)
    id = $data_enemies[enemy_id].shown_id
    $data_enemies[id].description = nil
  end
  #----------------------------------------------------------------------------
  # ○ new method: enemy_kill_count(enemy_id)
  #----------------------------------------------------------------------------
  def enemy_kill_count(enemy_id)
    kills = 0
    $game_party.bestiary.each do |entry|
      next unless entry.enemy_id == $data_enemies[enemy_id].shown_id
      kills = entry.kills
      case kills
      when Venka::Bestiary::Show_Elements
        entry.elements.size.times {|i| entry.elements[i] = true}
      when Venka::Bestiary::Show_States
        entry.states.size.times {|i| entry.states[i] = true}
      end
    end
    return kills
  end
end
#==============================================================================
# ■ Window_Base
#==============================================================================
class Window_Base < Window
  #----------------------------------------------------------------------------
  # ○ new method: set_windowskin
  #----------------------------------------------------------------------------
  def set_windowskin
    return unless Venka::Bestiary::Windowskin
    self.windowskin = Cache.system(Venka::Bestiary::Windowskin)
    self.opacity = Venka::Bestiary::Window_Opacity
    self.back_opacity = Venka::Bestiary::Window_BGOpacity
  end
  #----------------------------------------------------------------------------
  # ○ new method: get_color - method determines if text color or new color
  #----------------------------------------------------------------------------
  def get_color(input)
    input.is_a?(Integer) ? text_color([[input, 0].max, 31].min) : Color.new(*input)
  end
  #----------------------------------------------------------------------------
  # ○ new method: font_color
  #----------------------------------------------------------------------------
  def font_color(text_type)
    f_color = Venka::Bestiary::Fonts[text_type][3]
    color = f_color.is_a?(Integer) ? text_color(f_color) : Color.new(*f_color)
  end
  #----------------------------------------------------------------------------
  # ○ new method: set_bestiary_font
  #----------------------------------------------------------------------------
  def set_bestiary_font(text_type, enabled = true)
    font = Venka::Bestiary::Fonts[text_type]
    contents.font.name = font[0]
    contents.font.size = font[1]
    contents.font.bold = font[2]
    contents.font.outline = font[4]
    change_color(font_color(text_type), enabled)
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
    return unless Venka::Bestiary::Use_Dividers
    color = get_color(Venka::Bestiary::Line_Color)
    contents.fill_rect(4, y, contents_width - 8, 2, color)
    contents.fill_rect(4, y + 2, contents_width - 8, 1, Color.new(16,16,16,100))
    #contents.fill_rect(0, y, contents_width, 2, line_color)
  end
  def draw_line2(y)
    return unless Venka::Bestiary::Use_Dividers
    color = get_color(Venka::Bestiary::Line_Color)
    contents.fill_rect(166, y, contents_width - 170, 2, color)
    contents.fill_rect(166, y + 2, contents_width - 170, 1, Color.new(16,16,16,100))
    #contents.fill_rect(0, y, contents_width, 2, line_color)
  end
=begin
  def line_color
    color = normal_color
    color.alpha = 48
    color
  end
=end
end
#==============================================================================
# ■ Window_Message
#==============================================================================
class Window_Message
  #----------------------------------------------------------------------------
  # ♦ Public Instance Variables
  #----------------------------------------------------------------------------
  attr_accessor :wordwrap
end
=begin
#==============================================================================
# ■ Window_MenuCommand
#==============================================================================
class Window_MenuCommand < Window_Command
  #----------------------------------------------------------------------------
  # ● alias method: add_original_commands
  #----------------------------------------------------------------------------
  alias bestiary_menu_access_aoc       add_original_commands
  def add_original_commands
    bestiary_menu_access_aoc
    add_command(Venka::Bestiary::Bestiary_Command, :bestiary) if Venka::Bestiary::Menu_Access
  end
end
=end
#==============================================================================
# ■ Window_BattleLog
#==============================================================================
class Window_BattleLog < Window_Selectable
  #----------------------------------------------------------------------------
  # ● alias method: display_failure
  #----------------------------------------------------------------------------
  alias bestiary_scan_fail_msg display_failure
  def display_failure(target, item)
    if item.scan && target.result.hit? && !target.result.success
      text = $data_enemies[target.enemy_id].no_scan ? Vocab::No_Scan : Vocab::Scanned
      add_text(sprintf(text, target.name))
      wait
    else
      bestiary_scan_fail_msg(target, item)
    end
  end
end
#==============================================================================
# ■ Window_BestiaryHelp
#==============================================================================
class Window_BestiaryHelp < Window_Base
  #----------------------------------------------------------------------------
  # ● upgraded method: initialize
  #----------------------------------------------------------------------------
  def initialize(x, y)
    height = [Venka::Bestiary::Fonts[:normal_font][1], 24].max + 24
    super(x, y, Graphics.width, height)
    set_windowskin
  end
  #----------------------------------------------------------------------------
  # ○ new method: set_text
  #----------------------------------------------------------------------------
  def set_text(text)
    contents.clear
    set_bestiary_font(:normal_font)
    draw_text(0, 0, contents.width, font_height, text, 1)
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_completion
  #----------------------------------------------------------------------------
  def draw_completion
    contents.clear
    draw_enemies_discovered
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_enemies_discovered
  #----------------------------------------------------------------------------
  def draw_enemies_discovered
    set_bestiary_font(:normal_font)
    enemies_discovered = $game_party.bestiary.size
    total = total_enemies
    text = "#{enemies_discovered}/#{total} #{Venka::Bestiary::Discovered_Text}"
    draw_text(0, 0, contents.width, font_height, text)
    discovered = (enemies_discovered.to_f / total) * 100
    text = "#{discovered.round(1)}% #{Venka::Bestiary::Percent_Finished}"
    draw_text(0, 0, contents.width, font_height, text, 2)
  end
  #----------------------------------------------------------------------------
  # ○ new method: total_enemies
  #----------------------------------------------------------------------------
  def total_enemies
    total = 0
    for i in 1...$data_enemies.size
      next if $data_enemies[i].shown_id != $data_enemies[i].id
      total += 1 unless $data_enemies[i].skip
    end
    total
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_instructions
  #----------------------------------------------------------------------------
  def draw_instructions
    contents.clear
    set_bestiary_font(:normal_font)
    text = Venka::Bestiary::Instructions_Text
    draw_text(0, 0, contents.width, font_height, text, 1)
  end
  #----------------------------------------------------------------------------
  # ○ new method: set_description
  #----------------------------------------------------------------------------
  def set_description(enemy)
    contents.clear
    create_contents             # Remake contents since the window size changed
    get_description_text(enemy)
    text = get_description_text(enemy)
    if Venka::Bestiary::Use_Wordwrapper
      wrapping = @wordwrap
      @wordwrap = true
      draw_text_ex(0, 0, text.gsub(/[|]/, ""))
      @wordwrap = wrapping
    else
      draw_text_ex(0, 0, text.gsub(/[|]/, "\n"))
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: get_description_text
  #----------------------------------------------------------------------------
  def get_description_text(enemy)
    if enemy.description
      text = enemy.description
    else
      text = Venka::Bestiary::Default_Description
      kills = 0
      $game_party.bestiary.each do |foe| 
        kills = foe.kills if foe.enemy_id == enemy.shown_id
      end
      if kills >= Venka::Bestiary::Description3 && enemy.descript3
        text = enemy.descript3
      elsif kills >= Venka::Bestiary::Description2 && enemy.descript2
        text = enemy.descript2
      elsif kills >= Venka::Bestiary::Description1 && enemy.descript1
        text = enemy.descript1
      end
    end
    text
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: draw_text_ex
  #----------------------------------------------------------------------------
  def draw_text_ex(x, y, text)
    set_bestiary_font(:description)
    text = convert_escape_characters(text)
    pos = {:x => x, :y => y, :new_x => x, :height => calc_line_height(text)}
    process_character(text.slice!(0, 1), text, pos) until text.empty?
  end
end
#==============================================================================
# ■ Window_BestiaryCategory
#==============================================================================
class Window_BestiaryCategory < Window_Command
  #----------------------------------------------------------------------------
  # ● upgraded method: initialize
  #----------------------------------------------------------------------------
  def initialize(x, y)
    @wy = y
    @categories = Venka::Bestiary::Category
    super(x, @wy)
    set_windowskin
  end
  #----------------------------------------------------------------------------
  # ● window settings
  #----------------------------------------------------------------------------
  def window_width;  Graphics.width * 0.3;                                end
  def window_height; Graphics.height - @wy;                         end
  #def window_height; Graphics.height - (@wy * 2);                         end
  def item_height;   [Venka::Bestiary::Fonts[:list_font][1], 24].max;     end
  #----------------------------------------------------------------------------
  # ● upgraded method: make_command_list
  #----------------------------------------------------------------------------
  def make_command_list
    @categories.each{|key, info| add_command(info[:name], key)}
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: draw_item
  #----------------------------------------------------------------------------
  def draw_item(index)
    set_bestiary_font(:normal_font)
    @width = Venka::Bestiary::Track_Progress ? text_size("99.9%").width + 5 : 0
    @width += 3
    rect = item_rect_for_text(index)
    set_bestiary_font(:list_font)
    draw_text(rect.x, rect.y, rect.width - @width, rect.height, command_name(index))
    found_text(index, rect) if Venka::Bestiary::Track_Progress
  end
  #----------------------------------------------------------------------------
  # ○ new method: found_text
  #----------------------------------------------------------------------------
  def found_text(index,  rect)
    set_bestiary_font(:normal_font)
    total = total_enemies(index)
    discovered = total_found(index)
    value = (total > 0) ? (discovered.to_f / total) * 100 : 0.0
    text = (value > 0 && value < 100) ? value.round(1) : value.round
    draw_text(rect.width - @width, rect.y, @width, rect.height, "#{text}%", 2)
  end
  #----------------------------------------------------------------------------
  # ○ new method: total_enemies
  #----------------------------------------------------------------------------
  def total_enemies(index)
    total = 0
    for i in 1...$data_enemies.size
      next unless $data_enemies[i].category.include?(index)
      next if $data_enemies[i].shown_id != $data_enemies[i].id
      total += 1 unless $data_enemies[i].skip
    end
    return total
  end
  #----------------------------------------------------------------------------
  # ○ new method: total_found
  #----------------------------------------------------------------------------
  def total_found(index)
    total = 0
    $game_party.bestiary.each {|e| total += 1 if e.category.include?(index)}
    return total
  end
end
#==============================================================================
# ■ Window_BestiaryEnemyList
#==============================================================================
class Window_BestiaryEnemyList < Window_Command
  #----------------------------------------------------------------------------
  # ♦ Public Instance Variables
  #----------------------------------------------------------------------------
  attr_reader   :category_window,    :stats_window
  #----------------------------------------------------------------------------
  # ● upgraded method: initialize
  #----------------------------------------------------------------------------
  def initialize(x, y)
    @category = 0
    @wy = y
    super(x, @wy)
    set_windowskin
  end
  #----------------------------------------------------------------------------
  # ● window settings
  #----------------------------------------------------------------------------
  def window_width;  Graphics.width * 0.7;                                end
  #def window_height; Graphics.height - (@wy * 2);                         end
  def window_height; Graphics.height - @wy;                         end
  def item_height;   [Venka::Bestiary::Fonts[:list_font][1], 24].max;     end
  #----------------------------------------------------------------------------
  # ○ new method: category_window
  #----------------------------------------------------------------------------
  def category_window=(category_window)
    if @category_window != category_window
      @category_window = category_window
      @category = category_window.current_symbol.to_s.to_i
      refresh
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: stats_window
  #----------------------------------------------------------------------------
  def stats_window=(stats_window)
    if @stats_window != stats_window
      @stats_window = stats_window
    end
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: make_command_list
  #----------------------------------------------------------------------------
  def make_command_list
    @enemies = []
    sort_list
    @bestiary_list.each do |enemy|
      next if enemy.nil?
      next unless enemy.category.include?(@category)
      #print("Venka's Bestiary v1.8 - %s, %s \n" % [enemy.category, @category]);
      next if enemy.category == @category
      @enemies << enemy
      add_command($data_enemies[enemy.enemy_id].name, :ok, true, enemy.enemy_id)
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: sort_list
  #----------------------------------------------------------------------------
  def sort_list
    @bestiary_list = $game_party.bestiary.clone
    if Venka::Bestiary::Sort_Type == :id                # Sort by enemy id
      @bestiary_list.sort!{|a, b| a.enemy_id <=> b.enemy_id} 
    elsif Venka::Bestiary::Sort_Type == :name           # Sort by name
      @bestiary_list.sort!{|a, b| 
        $data_enemies[a.enemy_id].name <=> $data_enemies[b.enemy_id].name}
    end
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: draw_item
  #----------------------------------------------------------------------------
  def draw_item(index)
    set_bestiary_font(:normal_font)
    @width = contents_width * 0.33
    @width = 0 unless Venka::Bestiary::Track_Kills
    rect = item_rect_for_text(index)
    set_bestiary_font(:list_font)
    draw_text(rect.x, rect.y, rect.width - @width, rect.height, command_name(index))
    draw_kills(index) if Venka::Bestiary::Track_Kills
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_kills
  #----------------------------------------------------------------------------
  def draw_kills(index)
    set_bestiary_font(:normal_font)
    text = "총 " + "#{@enemies[index].kills} #{Venka::Bestiary::Kills_Text}"
    draw_text(item_rect_for_text(index), text, 2)
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: update
  #----------------------------------------------------------------------------
  def update
    super
    if @category_window && @category != @category_window.current_symbol.to_s.to_i
      @category = @category_window.current_symbol.to_s.to_i
      refresh
    end
  end
end
#==============================================================================
# ■ Window_BestiaryStatSelection
#==============================================================================
class Window_BestiaryStatSelection < Window_Selectable
  #----------------------------------------------------------------------------
  # ● upgraded method: initialize
  #----------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super(x, y, width, height)
    set_windowskin
    select(0)
    hide
    refresh
  end
  #----------------------------------------------------------------------------
  # ● window settings;
  #----------------------------------------------------------------------------
  def col_max;     return item_max;                                         end
  def spacing;     return 5;                                                end
  def item_height; [Venka::Bestiary::Fonts[:normal_font][1].size, 24].max;  end
  #----------------------------------------------------------------------------
  # ● upgraded method: item_max
  #----------------------------------------------------------------------------
  def item_max
    if SceneManager.scene_is?(Scene_Battle)
      Venka::Bestiary::Show_Debuff_Info ? 4 : 3
    else
      return 2
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: enemy_id
  #----------------------------------------------------------------------------
  def enemy_id=(enemy_id)
    return @enemy = nil if enemy_id == 0
    if @enemy != $data_enemies[enemy_id]
      @enemy = $data_enemies[enemy_id]
      refresh
    end
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: item_rect
  #----------------------------------------------------------------------------
  def item_rect(index)
    rect = super
    if SceneManager.scene_is?(Scene_Battle)
      rect.y += [Venka::Bestiary::Fonts[:normal_font][1], 24].max + 6 
    end
    rect
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: draw_item
  #----------------------------------------------------------------------------
  def draw_item(index)
    rect = item_rect_for_text(index)
    if SceneManager.scene_is?(Scene_Battle)
      text = [Venka::Bestiary::View_Stats, Venka::Bestiary::View_Element,
              Venka::Bestiary::View_States, Venka::Bestiary::View_Debuff]
    else
      text = [Venka::Bestiary::View_Stats, Venka::Bestiary::View_More]
    end
    set_bestiary_font(:normal_font) 
    draw_text(rect, text[index], 1)
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: refresh
  #----------------------------------------------------------------------------
  def refresh
    contents.clear
=begin
    if SceneManager.scene_is?(Scene_Battle)
      set_bestiary_font(:normal_font)
      @y = font_height
      draw_enemy_name if @enemy
    end
=end
    draw_all_items
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_enemy_name
  #----------------------------------------------------------------------------
  def draw_enemy_name
    draw_text(0, 0, contents.width, font_height, @enemy.name, 1)
    draw_line(@y + 2)
    @y += 6
    draw_line(@y + item_height + 3)
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: update_help
  #----------------------------------------------------------------------------
  def update_help
    @help_window.set_index(@index)
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: select
  #----------------------------------------------------------------------------
  def select(index)
    super
    @help_window.oy = 0 if @help_window
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: cursor_down
  #----------------------------------------------------------------------------
  def cursor_down(wrap = false)
    super
    if @help_window && display_window_oy < @help_window.total_height
      @help_window.oy += Venka::Bestiary::Scroll_Speed
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: display_window_oy
  #----------------------------------------------------------------------------
  def display_window_oy
    @help_window.oy + @help_window.height - (@help_window.standard_padding * 2)
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: cursor_up
  #----------------------------------------------------------------------------
  def cursor_up(wrap = false)
    super
    @help_window.oy -= Venka::Bestiary::Scroll_Speed if @help_window && @help_window.oy > 0
  end
  #----------------------------------------------------------------------------
  # ○ new method: wait_to_close
  #----------------------------------------------------------------------------
  def wait_to_close
    loop do
      Graphics.update
      Input.update
      update
      break if Input.trigger?(:C) || Input.trigger?(:B)
    end
    @help_window.hide
    deactivate
    self.hide
  end
end
#==============================================================================
# ■ Window_BestiaryStats
#==============================================================================
class Window_BestiaryStats < Window_Base
  #----------------------------------------------------------------------------
  # ♦ Public Instance Variables
  #----------------------------------------------------------------------------
  attr_accessor   :enemy, :total_height
  #----------------------------------------------------------------------------
  # ● upgraded method: initialize
  #----------------------------------------------------------------------------
  def initialize(x, y, width, height)
    @win_height = height
    super(x, y, width, height)
    self.opacity = 0
    @enemy = nil
    hide
  end
  #----------------------------------------------------------------------------
  # ○ new method: enemy_id
  #----------------------------------------------------------------------------
  def enemy_id=(enemy_id)
    return @enemy = nil if enemy_id == 0
    if @enemy != $data_enemies[enemy_id]
      @enemy = $data_enemies[enemy_id]
      refresh
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: set_index
  #----------------------------------------------------------------------------
  def set_index(index)
    if @index != index 
      @index = index 
      refresh
    end
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: contents_height
  #----------------------------------------------------------------------------
  def contents_height
    @total_height ? @total_height : super 
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: refresh
  #----------------------------------------------------------------------------
  def refresh
    contents.clear
    return if @enemy.nil?
    if SceneManager.scene_is?(Scene_Bestiary)
      @index == 0 ? draw_other_info : draw_basic_stats
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: determine_window_height
  #----------------------------------------------------------------------------
  def determine_window_height(text_lines)
    set_bestiary_font(:header_font)
    @total_height = font_height * text_lines
    self.height = ([(@total_height + standard_padding * 2), @win_height].min)
    create_contents
  end
  #----------------------------------------------------------------------------
  # ○ new method: info_rect
  #----------------------------------------------------------------------------
  def info_rect(index)
    rect = Rect.new
    rect.width = contents.width * 0.2 - 3
    rect.height = [Venka::Bestiary::Fonts[:stat_name][1], 24].max
    #rect.x = index % 4 * (rect.width + 3) + rect.width
    rect.x = index % 4 * (rect.width + 3) + 166
    rect.y = index / 4 * font_height
    rect
  end
  #----------------------------------------------------------------------------
  # ○ new method: info_rect
  #----------------------------------------------------------------------------
  def info_rect2(index)
    rect = Rect.new
    rect.width = contents.width * 0.2 - 3
    rect.height = [Venka::Bestiary::Fonts[:stat_name][1], 24].max
    rect.x = index % 5 * (rect.width + 3)
    rect.y = index / 5 * font_height
    rect
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_basic_stats
  #----------------------------------------------------------------------------
  def draw_basic_stats
    elements = Venka::Bestiary::Elements.size
    #states = Venka::Bestiary::States.size
    # 상태이상 면역 표기 수량
    #states = 5 #55
    # Get the total text lines to show
    #height = (elements / 2 + elements % 2) + (states / 2 + states % 2) + 10
    #height = (elements / 5 + elements % 5) + (states / 5 + states % 5) + 10
    #height += 4
    height = 18.5
    #height += 6 if Venka::Bestiary::Show_Debuff_Info
    determine_window_height(height)
    draw_line(5)
    @y = 10
    #draw_main_stats
    #draw_line(@y + 5)
    #@y += 6
    #get_revealed_resists
    #draw_elements
    #draw_line(@y + 5)
    #@y += 6
    draw_states
    #return unless Venka::Bestiary::Show_Debuff_Info
    #draw_line(@y + 5)
    #@y += 6
    #draw_debuffs
  end
=begin
  #----------------------------------------------------------------------------
  # ○ new method: draw_main_stats
  #----------------------------------------------------------------------------
  def draw_main_stats
    set_bestiary_font(:header_font) 
    draw_text(0, @y, contents.width, font_height, Venka::Bestiary::Stats_Text, 1)
    @y += font_height
    8.times {|stat| draw_stat(stat, :stat)}
    @y += info_rect(0).height * 2
  end
=end
  #----------------------------------------------------------------------------
  # ○ new method: draw_stat
  #----------------------------------------------------------------------------
  def draw_stat(stat, stat_type)
    rect = info_rect(stat)
    rect.y += @y
    stat_info = Venka::Bestiary::Base_Stats[stat]
    if stat_info[1]
      draw_icon(stat_info[1] - 1, rect.x, rect.y)
      #rect.x += 25;            rect.width -= 25
      rect.x += 30;            rect.width -= 30
    end
    if stat_info[0]
      set_bestiary_font(:stat_name)
      draw_text(rect, stat_info[0])
      text_width = text_size(stat_info[0]).width + 5
      rect.x += text_width;    rect.width -= text_width
    end
    set_bestiary_font(:stats_font)
    text = Venka::Bestiary::Unknown_Stat
    $game_party.bestiary.each do |entry|
      next unless entry.enemy_id == @enemy.shown_id
      if stat_type == :stat && (entry.scanned || entry.kills >= Venka::Bestiary::Show_BaseStats)
      #if stat_type == :stat && (entry.kills >= Venka::Bestiary::Show_BaseStats)
        #text = Game_Enemy.new(0, @enemy.shown_id).param(stat)
        
        base = Game_Enemy.new(0, @enemy.shown_id).param(stat)
        level = (@enemy.level_max - @enemy.level_min) / 2
        level += @enemy.level_min
        # 월드 레벨 더하기
        level += $game_variables[99]
        per = @enemy.level_growth[stat][1]
        set = @enemy.level_growth[stat][2]
        # 난이도 적용
        total = eval(YEA::ENEMY_LEVEL::STAT_FORMULA) if $game_variables[18] == 3
        total = eval(YEA::ENEMY_LEVEL::STAT_FORMULA_0) if $game_variables[18] == 0
        total = eval(YEA::ENEMY_LEVEL::STAT_FORMULA_1) if $game_variables[18] == 1
        total = eval(YEA::ENEMY_LEVEL::STAT_FORMULA_2) if $game_variables[18] == 2
        total = eval(YEA::ENEMY_LEVEL::STAT_FORMULA_4) if $game_variables[18] == 4
        total = eval(YEA::ENEMY_LEVEL::STAT_FORMULA_5) if $game_variables[18] == 5
        
        text = total.to_i
        
      elsif stat_type == :debuff && (entry.scanned || entry.kills >= Venka::Bestiary::Show_DebuffStats)
      #elsif stat_type == :debuff && (entry.kills >= Venka::Bestiary::Show_DebuffStats)
        rate = Game_Enemy.new(0, @enemy.shown_id).debuff_rate(stat)
        text = get_resist_info(stat, rate)
      end
    end
    draw_text(rect, text, 2)
  end
=begin
  #----------------------------------------------------------------------------
  # ○ new method: get_revealed_resists
  #----------------------------------------------------------------------------
  def get_revealed_resists
    $game_party.bestiary.each do |entry|
      @eles = entry.elements if entry.enemy_id == @enemy.shown_id
      @states = entry.states if entry.enemy_id == @enemy.shown_id
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_elements
  #----------------------------------------------------------------------------
  def draw_elements
    set_bestiary_font(:header_font)
    draw_text(0, @y, contents.width, font_height, Venka::Bestiary::Element_Text, 1)
    @y += font_height
    elements = Venka::Bestiary::Elements
    (elements.size).times {|i| draw_ele_info(i, elements[i], info_rect(i))}
    #@y += (info_rect(0).height) * (elements.size * 0.5 + elements.size % 2)
    @y += info_rect(0).height * 2
  end
=end
  #----------------------------------------------------------------------------
  # ○ new method: draw_ele_info
  #----------------------------------------------------------------------------
  def draw_ele_info(i, element, rect)
    rect.y += @y
    if element[1]
      draw_icon(element[1] - 1, rect.x, rect.y)
      #rect.x += 25;            rect.width -= 25
      rect.x += 30;            rect.width -= 30
    end
    set_bestiary_font(:stat_name)
    tw = text_size(99).width + 5
    draw_text(rect, $data_system.elements[element[0]])
    text_width = text_size(element[0]).width + 5
    # Scale text so the value will fit as well in small resolutions
    rect.x = [(rect.x + text_width), (rect.x + rect.width - tw)].min
    rect.width = [(rect.width - text_width), tw].max
    set_bestiary_font(:stats_font)
    text = @eles[i] ? get_resist_info(element[0], 11) : Venka::Bestiary::Unknown_Stat
    #draw_text(rect, text, 2)
    draw_text(rect, "#{text}" + '%', 2)
  end
  #----------------------------------------------------------------------------
  # ○ new method: get_resist_info
  #----------------------------------------------------------------------------
  def get_resist_info(stat_id, code_id)
    case code_id
    when 11   # Element
      resist = Game_Enemy.new(0, @enemy.shown_id).element_rate(stat_id)
      if $imported["YEA-Element Absorb"] && Game_Enemy.new(0, @enemy.shown_id).element_absorb?(stat_id)
        set_resist_style(resist, Venka::Bestiary::Absorb_Text)
      else
        set_resist_style(resist)
      end
    when 13
      enemy = Game_Enemy.new(0, @enemy.shown_id)
      if enemy.features_with_id(14, stat_id).empty?
        resist = enemy.state_rate(stat_id)
        set_resist_style(resist)
      else
        set_resist_style(1.0, Venka::Bestiary::Immune_Text)
      end
    else
      set_resist_style(code_id)
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: set_resist_style
  #----------------------------------------------------------------------------
  def set_resist_style(resist, text = "")
    if text != ""
      color = Venka::Bestiary::Immunity_Color
    else
      color = Venka::Bestiary::Fonts[:stats_font][3]
      color = Venka::Bestiary::High_Resist if resist > 1.0
      color = Venka::Bestiary::Low_Resist  if resist < 1.0
      resist -= 1.0 if resist >= 1.0
      text = (resist * 100).round
    end
    new_color = color.is_a?(Integer) ? text_color(color) : Color.new(*color)
    change_color(new_color)
    return text
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_states
  #----------------------------------------------------------------------------
  def draw_states
    set_bestiary_font(:header_font)
    draw_text(0, @y, contents.width, font_height, Venka::Bestiary::Status_Text, 1)
    @y += font_height + 5
    #states = Venka::Bestiary::States
    #(states.size).times {|i| draw_state_info(i, states[i], info_rect(i))}
    #@y += (info_rect(0).height) * (states.size / 2).round
    a = 0
    b = [9,14,15,16,18,19,20,21,22,24,29,32,34,86,87,88,90,91,92,93,97,101,102,
        103,104,105,110,111,150,151,152,153,154,156,157,158,159,161,177,178,
        179,180,181,185,190,191,192,193,194,195,196,197,198,199]
    for i in 1..$data_states.size
      if $data_states[i] != nil
        if $data_states[i].icon_index != nil and $data_states[i].name != "" and $data_states[i].icon_index != 0
          if $data_states[i].icon_index >= 704 and 1381 > $data_states[i].icon_index
            if !b.include?(i)
              #draw_state_info(i, i, info_rect(a))
              draw_state_info(i, i, info_rect2(a))
              a += 1
            end
          end
        end
      end
    end
    #@y += (info_rect(0).height) * ($data_states.size / 2).round
    #@y += (info_rect(0).height) * ($data_states.size / 5).round
    @y += (info_rect2(0).height) * ($data_states.size / 5).round
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_state_info
  #----------------------------------------------------------------------------
  # 상태이상 관련 표기
  def draw_state_info(i, state_id, rect)
    state = $data_states[state_id]
    #if @states[i]
      rect.y += @y
      draw_icon(state.icon_index, rect.x, rect.y)
      #rect.x += 25;            rect.width -= 25
      rect.x += 30;            rect.width -= 30
      set_bestiary_font(:stat_name)
      tw = text_size(99).width + 5
      draw_text(rect.x, rect.y, rect.width - tw, rect.height, state.name)
      text_width = text_size(state.name).width + 5
      # Scale text so the value will fit as well in small resolutions
      rect.x = [(rect.x + text_width), (rect.x + rect.width - tw)].min
      rect.width = [(rect.width - text_width), tw].max
      set_bestiary_font(:stats_font)
      text = @states[i] ? get_resist_info(state_id, 13) : Venka::Bestiary::Unknown_Stat
      #text = get_resist_info(state_id, 13)
      #draw_text(rect, text, 2)
      draw_text(rect, "#{text}" + '%', 2)
    #end
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_debuffs
  #----------------------------------------------------------------------------
  def draw_debuffs
    set_bestiary_font(:header_font)
    draw_text(0, @y, contents.width, font_height, Venka::Bestiary::Debuff_Text, 1)
    @y += font_height
    8.times do |stat|
      draw_stat(stat, :debuff)
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_other_info
  #----------------------------------------------------------------------------
  def draw_other_info
    #drops = 10  #@enemy.dropitem
=begin
    # Get the number of lines to display loot
    drops = @enemy.drop_items.select {|d| d.kind > 0 }
    # Get the number of lines to display enemy skills
    ids = []
    @enemy.actions.each do |action|
      ids << action.skill_id unless ids.include?(action.skill_id)
    end
=end
    # Total number of lines to display with skills, loot, headers, etc
    #height = 5 + drops.size + ids.size
    #height = 5 + drops.size
    height = 18.5
    determine_window_height(height)
    draw_line2(5)
    @y = 10
    
    draw_main_stats       # 능력치 정보
    draw_line2(@y + 5)
    @y += 8
    
    get_revealed_resists  # 속성 정보
    draw_elements
    draw_line2(@y + 5)
    @y += 8
    
    set_bestiary_font(:header_font)
    draw_text(0, @y, contents.width, font_height, Venka::Bestiary::Loot_Text, 1)
    @y += font_height + 5
    draw_exp_and_gold
    draw_line2(@y + 5)
    @y += 8
    
    set_bestiary_font(:header_font)
    draw_text(0, @y, contents.width, font_height, Venka::Bestiary::Loot_Item, 1)
    @y += font_height + 5
    draw_drops
    #draw_skills
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_main_stats
  #----------------------------------------------------------------------------
  def draw_main_stats
    set_bestiary_font(:header_font)
    draw_text(0, @y, contents.width, font_height, Venka::Bestiary::Stats_Text, 1)
    @y += font_height + 5
    8.times {|stat| draw_stat(stat, :stat)}
    @y += info_rect(0).height * 2
  end
  #----------------------------------------------------------------------------
  # ○ new method: get_revealed_resists
  #----------------------------------------------------------------------------
  def get_revealed_resists
    $game_party.bestiary.each do |entry|
      @eles = entry.elements if entry.enemy_id == @enemy.shown_id
      @states = entry.states if entry.enemy_id == @enemy.shown_id
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_elements
  #----------------------------------------------------------------------------
  def draw_elements
    set_bestiary_font(:header_font)
    draw_text(0, @y, contents.width, font_height, Venka::Bestiary::Element_Text, 1)
    @y += font_height + 5
    elements = Venka::Bestiary::Elements
    (elements.size).times {|i| draw_ele_info(i, elements[i], info_rect(i))}
    #@y += (info_rect(0).height) * (elements.size * 0.5 + elements.size % 2)
    @y += info_rect(0).height * 2
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_exp
  #----------------------------------------------------------------------------
  def draw_exp_and_gold
    exp  = Venka::Bestiary::Exp_Text
    #gold = Venka::Bestiary::Gold_Text
    width = contents.width
    #tw = contents.width * 0.2
    tw = 166
    draw_text(-5, @y - 13, tw, font_height, @enemy.name, 1)
    #width = ((@enemy.exp > 0 || @enemy.gold > 0) ? width * 0.5 : width).to_i
    
    base = @enemy.exp
    level = (@enemy.level_max - @enemy.level_min) / 2
    level += @enemy.level_min
    # 월드 레벨 더하기
    level += $game_variables[99]
    per = @enemy.level_growth[8][1]
    set = @enemy.level_growth[8][2]
    total = eval(YEA::ENEMY_LEVEL::STAT_FORMULA_0)
    
    draw_icon_text_exp(exp, tw, width, total.to_i) if total.to_i > 0
    x = total.to_i > 0 ? width : 0
    
    #draw_icon_text_exp(exp, tw, width, @enemy.exp) if @enemy.exp > 0
    #x = @enemy.exp > 0 ? width : 0
    
    #draw_icon_text(gold, x, width, @enemy.gold) if @enemy.gold > 0
    @y += font_height
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_icon_and_text
  #----------------------------------------------------------------------------
  def draw_icon_text_exp(info, x, width, amount)
    draw_icon(info[1] - 1, x, @y) if info[1]
    dx = info[1] ? 30 : 0
    set_bestiary_font(:stat_name)
    draw_text(x + dx, @y, width - dx, font_height, info[0])
    set_bestiary_font(:stats_font)
    dx += text_size(info[0]).width
    draw_text(x + dx, @y, width - dx, font_height, amount)
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_icon_and_text
  #----------------------------------------------------------------------------
  def draw_icon_text(info, x, width, amount)
    draw_icon(info[1] - 1, x, @y) if info[1]
    dx = info[1] ? 25 : 0
    set_bestiary_font(:stat_name)
    draw_text(x + dx, @y, width - dx, font_height, info[0])
    set_bestiary_font(:stats_font)
    dx += text_size(info[0]).width + 10
    draw_text(x + dx, @y, width - dx, font_height, amount)
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_drops
  #----------------------------------------------------------------------------
  def draw_drops
    drops_revealed = false
    drops_data = []
    $game_party.bestiary.each do |entry|
      next unless entry.enemy_id == @enemy.shown_id
      if entry.dropitem != nil
        if entry.scanned || entry.kills >= Venka::Bestiary::Show_Loot || entry.dropitem.length >= 1
        #if entry.kills >= Venka::Bestiary::Show_Loot || entry.dropitem.length >= 1
          drops_revealed = true
          entry.dropitem = entry.dropitem.compact  # nil 값 제거
          drops_data = entry.dropitem
        end
      end
    end
    if drops_revealed
      # 드롭 아이템 수정
      @x = 0
      tw = 0
      for i in 1..drops_data.size
        item = drops_data[i - 1]
        return if item == nil
        set_bestiary_font(:stat_name)
        draw_drop_item_name(item, @x + tw, @y, text_size("100%").width + 5)
        tw = i % 5 * (contents.width * 0.2)
        @y += font_height if i % 5 == 0
      end
    else
      set_bestiary_font(:stat_name)
      draw_text(0, @y, contents.width, font_height, Venka::Bestiary::Unknown_Loot)
      @y += font_height
    end
  end
  
  def draw_drop_item_name(item, x, y, enabled = true, width = contents.width)
    draw_icon(item[1], x, y, enabled)
    draw_text(x + 24 + 5, y, width, line_height, item[0])
  end
  
=begin
  #----------------------------------------------------------------------------
  # ○ new method: draw_skills
  #----------------------------------------------------------------------------
  def draw_skills
    set_bestiary_font(:header_font)
    draw_text(0, @y, contents.width, font_height, Venka::Bestiary::Skill_Text, 1)
    @y += font_height
    set_bestiary_font(:stat_name)
    skills_revealed = false
    $game_party.bestiary.each do |entry|
      next unless entry.enemy_id == @enemy.shown_id
      if entry.scanned || entry.kills >= Venka::Bestiary::Show_Abilities
        skills_revealed = true
      end
    end
    if skills_revealed
      skills.each do |id| 
        draw_item_name($data_skills[id], 0, @y, contents.width)
        @y += font_height
      end
    else
      draw_text(0, @y, contents.width, font_height, Venka::Bestiary::Unknown_Skills)
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: skills
  #----------------------------------------------------------------------------
  def skills
    ids = []
    @enemy.actions.each do |action|
      ids << action.skill_id unless ids.include?(action.skill_id)
    end
    return ids
  end
=end
end
#==============================================================================
# ■ Window_BattleScan
#==============================================================================
class Window_BattleScan < Window_BestiaryStats
  #----------------------------------------------------------------------------
  # ♦ Public Instance Variables
  #----------------------------------------------------------------------------
  attr_accessor    :show_stats
  #----------------------------------------------------------------------------
  # ● upgraded method: initialize
  #----------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super(x, y, width, height)
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: refresh
  #----------------------------------------------------------------------------
  def refresh
    contents.clear
    return if @enemy.nil?
    if $game_party.bestiary_include?(@enemy.shown_id)
      @y = 0
      case @index
      when 0; draw_basic_stats
      when 1; draw_enemy_resists
      when 2; draw_enemy_states
      when 3; draw_debuff_rates
      end
    else
      set_bestiary_font(:stat_name)
      text = Venka::Bestiary::No_Info
      draw_text(0, 0, contents.width, contents.height, text, 1)
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_basic_stats
  #----------------------------------------------------------------------------
  def draw_basic_stats
    determine_window_height(4)
    8.times {|stat| draw_stat(stat, :stat)}
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_enemy_resists
  #----------------------------------------------------------------------------
  def draw_enemy_resists
    elements = Venka::Bestiary::Elements
    height = (elements.size / 2) + (elements.size % 2)
    determine_window_height(height)
    get_revealed_resists
    (elements.size).times {|i| draw_ele_info(i, elements[i], info_rect(i))}
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_enemy_states
  #----------------------------------------------------------------------------
  def draw_enemy_states
    states = Venka::Bestiary::States
    height = (states.size / 2) + (states.size % 2)
    determine_window_height(height)
    (states.size).times {|i| draw_state_info(i, states[i], info_rect(i))}
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_debuff_rates
  #----------------------------------------------------------------------------
  def draw_debuff_rates
    determine_window_height(4)
    8.times {|stat| draw_stat(stat, :debuff)}
  end
end
=begin
#==============================================================================
# ■ Scene_Menu
#==============================================================================
class Scene_Menu < Scene_MenuBase
  #----------------------------------------------------------------------------
  # ● alias method: create_command_window
  #----------------------------------------------------------------------------
  alias bestiary_menu_access_ccw       create_command_window
  def create_command_window
    bestiary_menu_access_ccw
    @command_window.set_handler(:bestiary,  method(:command_bestiary))
  end
  #----------------------------------------------------------------------------
  # ○ new method: command_bestiary
  #----------------------------------------------------------------------------
  def command_bestiary
    SceneManager.call(Scene_Bestiary)
  end
end
=end
#==============================================================================
# ■ Scene_Bestiary
#==============================================================================
class Scene_Bestiary < Scene_MenuBase
  #----------------------------------------------------------------------------
  # ● upgraded method: start
  #----------------------------------------------------------------------------
  def start
    super
    @enemy = nil
    create_all_windows
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: create_background
  #----------------------------------------------------------------------------
  def create_background
    super
  end
  #----------------------------------------------------------------------------
  # ○ new method: create_all_windows
  #----------------------------------------------------------------------------
  def create_all_windows
    create_help_window
    create_category_window
    create_bestiary_list
    create_enemy_image
    create_stats_selection
    create_stats_window
    #create_image_frame if Venka::Bestiary::Frame_Image
  end
  #----------------------------------------------------------------------------
  # ● upgraded method: create_help_window
  #----------------------------------------------------------------------------
  def create_help_window
    @help_window = Window_BestiaryHelp.new(0, 0)
    @help_window.viewport = @viewport
    @help_window.y = 0
    @help_window.set_text(Venka::Bestiary::Category_Select)
  end
  #----------------------------------------------------------------------------
  # ○ new method: create_category_window
  #----------------------------------------------------------------------------
  def create_category_window
    @category_window = Window_BestiaryCategory.new(0, @help_window.height)
    @category_window.viewport = @viewport
    @category_window.set_handler(:ok,     method(:command_list))
    @category_window.set_handler(:cancel, method(:return_scene))
  end
  #----------------------------------------------------------------------------
  # 오류 방지 추가
  #----------------------------------------------------------------------------
  def return_scene
    $game_temp.call_menu = false
    SceneManager.call(Scene_Menu)
  end
  #----------------------------------------------------------------------------
  # ○ new method: command_list
  #----------------------------------------------------------------------------
  def command_list
    @help_window.show
    @list_window.show.activate
    @help_window.set_text(Venka::Bestiary::Enemy_Select)
  end
  #----------------------------------------------------------------------------
  # ○ new method: create_bestiary_list
  #----------------------------------------------------------------------------
  def create_bestiary_list
    @list_window = Window_BestiaryEnemyList.new(@category_window.width, @help_window.height)
    @list_window.viewport = @viewport
    @list_window.category_window = @category_window
    @list_window.deactivate
    @list_window.set_handler(:ok,     method(:command_bestiary))
    @list_window.set_handler(:cancel, method(:command_category))
  end
  #----------------------------------------------------------------------------
  # ○ new method: command_category
  #----------------------------------------------------------------------------
  def command_category
    #@list_window.unselect
    @list_window.select(0) # 선택 취소 추가
    @category_window.activate
    @help_window.set_text(Venka::Bestiary::Category_Select)
  end
  #----------------------------------------------------------------------------
  # ○ new method: command_bestiary
  #----------------------------------------------------------------------------
  def command_bestiary
    @help_window.hide
    @list_window.hide
    @category_window.hide
    @stats_selection.show.activate
    @stats_window.show
    @frame_window.show if @frame_window
    # 몬스터 리스트 번호
    #print("Venka's Bestiary v1.8 - %s \n" % [@list_window.index]);
    # 몬스터 정보 메뉴
    #print("Venka's Bestiary v1.8 - %s \n" % [@stats_selection.index]);
    #@enemy_bg.visible = true
    @stats_selection.index = 0
    @enemy_bg.z = 1000
    update_enemy_info
  end
  #----------------------------------------------------------------------------
  # ○ new method: create_enemy_image
  #----------------------------------------------------------------------------
  # 몬스터 그래픽 좌표
  def create_enemy_image
    width = Graphics.width
    height = Graphics.height
    @enemy_bg = Sprite.new(@viewport)
    @enemy_bg.visible = false
    @enemy_bg.x = 10
    @enemy_bg.y = 40
    @enemy_bg.bitmap = Bitmap.new(156, 236)
  end
  #----------------------------------------------------------------------------
  # ○ new method: create_stats_selection
  #----------------------------------------------------------------------------
  def create_stats_selection
    # 몬스터 정보 창의 넓이 수정
    height = Graphics.height
    @stats_selection = Window_BestiaryStatSelection.new(0, 0, Graphics.width, height)
    @stats_selection.viewport = @viewport
    @stats_selection.set_handler(:pageup,     method(:prev_enemy))
    @stats_selection.set_handler(:pagedown,   method(:next_enemy))
    @stats_selection.set_handler(:cancel,     method(:to_enemy_list))
  end
  def update
    super
    if @stats_selection != nil
      @stats_selection.index == 0 ? @enemy_bg.visible = true : @enemy_bg.visible = false
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: create_stats_window
  #----------------------------------------------------------------------------
  def create_stats_window
    y = @stats_selection.y + @stats_selection.item_height
    height = @stats_selection.height - @stats_selection.item_height
    @stats_window = Window_BestiaryStats.new(0, y, @stats_selection.width, height)
    @stats_window.viewport = @viewport
    @stats_selection.help_window = @stats_window
    @list_window.stats_window = @stats_window
  end
  #----------------------------------------------------------------------------
  # ○ new method: prev_enemy
  #----------------------------------------------------------------------------
  def prev_enemy
    if @list_window.index == 0
      @list_window.index = @list_window.item_max - 1
    else
      @list_window.index -= 1
    end
    update_enemy_info
    @stats_selection.activate
  end
  #----------------------------------------------------------------------------
  # ○ new method: next_enemy
  #----------------------------------------------------------------------------
  def next_enemy
    if @list_window.index == @list_window.item_max - 1
      @list_window.index = 0
    else
      @list_window.index += 1
    end
    update_enemy_info
    @stats_selection.activate
  end
  #----------------------------------------------------------------------------
  # ○ new method: to_enemy_list
  #----------------------------------------------------------------------------
  def to_enemy_list
    @help_window.set_text(Venka::Bestiary::Category_Select)
    @category_window.show
    @stats_selection.index = 1
    @stats_selection.hide.deactivate
    @stats_window.hide
    @frame_window.hide if @frame_window
    #dispose_enemy_image
    #@enemy_bg.visible = false
    command_list
  end
  #----------------------------------------------------------------------------
  # ○ new method: create_image_frame
  #----------------------------------------------------------------------------
  def create_image_frame
    @frame_window = Window_Base.new(@enemy_bg.x, @enemy_bg.y, @enemy_bg.width, 
        @enemy_bg.height)
    @frame_window.viewport = @viewport
    @frame_window.set_windowskin
    @frame_window.back_opacity = 0
    @frame_window.hide
  end
  #----------------------------------------------------------------------------
  # ○ new method: update_enemy_info
  #----------------------------------------------------------------------------
  def update_enemy_info
    enemy = $data_enemies[@list_window.current_ext]
    @stats_window.enemy_id = @list_window.current_ext
    update_enemy_image2(enemy)
  end
  #----------------------------------------------------------------------------
  # ○ new method: update_enemy_image
  #----------------------------------------------------------------------------
  # 몬스터 그래픽 표시
  def update_enemy_image2(enemy)
    @enemy_bg.bitmap.clear
    #print("Venka's Bestiary v1.8 - %s, %s \n" % [enemy.name, enemy.bg_floor]);
    if enemy.bg_floor != ""
      bitmap = Cache.character(enemy.bg_floor)
      sign = enemy.bg_floor[/^[\!\$]./]
      if sign && sign.include?('$')
        cw = bitmap.width / 3
        ch = bitmap.height / 4
      else
        cw = bitmap.width / 12
        ch = bitmap.height / 8
      end
      n = 0
      src_rect = Rect.new((n%4*3+1)*cw, (n/4*4)*ch, cw, ch)
      @enemy_bg.bitmap.blt(-cw / 2 + 80, -ch / 2 + 90, bitmap, src_rect)
    end
    bitmap = Cache.picture("Monster_Portrait")
    rect = Rect.new(0, 0, bitmap.width, bitmap.height)
    @enemy_bg.bitmap.blt(0, 0, bitmap, rect, 255)
  end
  #----------------------------------------------------------------------------
  # ○ new method: enemy_image
  #----------------------------------------------------------------------------
  def enemy_image(type, file, hue = 0)
    begin
      case type
      when :floor;      Cache.battleback1(file)
      when :wall;       Cache.battleback2(file)
      when :battler;    Cache.battler(file, hue)
      end
    rescue;             Cache.picture(file)
    end
  end
  #----------------------------------------------------------------------------
  # ○ new method: draw_image
  #----------------------------------------------------------------------------
  def draw_image(bitmap, width, height)
    x = (bitmap.width - width) * 0.5
    y = (bitmap.height - height) * 0.5
    src_rect = Rect.new(x, y, width, height)
    @enemy_bg.bitmap.blt(0, 0, bitmap, src_rect)
  end
  #----------------------------------------------------------------------------
  # ○ new method: dispose_enemy_image
  #----------------------------------------------------------------------------
  def dispose_enemy_image
    return unless @enemy_bg
    @enemy_bg.bitmap.dispose if @enemy_bg.bitmap
    @enemy_bg.dispose
  end
end