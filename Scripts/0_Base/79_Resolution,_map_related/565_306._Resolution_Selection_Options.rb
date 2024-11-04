# encoding: utf-8
# Name: 306. Resolution Selection Options
# Size: 13643
#~ ﻿#===============================================================================
#~ # Resolution Selection Script                               updated: 11/15/2014
#~ # collaborative work by: Dekita and Venka
#~ #===============================================================================
#~ # Dekita's web site and available scripts:
#~ # www.dekyde.com
#~ # www.dekitarpg.wordpress.com
#~ #===============================================================================
#~ # Contact Venka by private message via the official RPG Maker forums here:
#~ # http://forums.rpgmakerweb.com/index.php?/user/2313-venka/
#~ #===============================================================================
#~ # - DESCRIPTION -
#~ #-------------------------------------------------------------------------------
#~ # This script will allow the player to pick the resolution that they play in 
#~ # the game. This was created for the High Resolution dll. More info on that 
#~ # can be found here:
#~ # http://forums.rpgmakerweb.com/index.php?/topic/31953-high-res-rpg-maker-project/
#~ #
#~ # This script will work without it, but you won't be able to make resolutions 
#~ # above 640x480.
#~ # 
#~ #-------------------------------------------------------------------------------
#~ # - INSTRUCTIONS -
#~ #-------------------------------------------------------------------------------
#~ # This script also will let display images that fit the resolution the user 
#~ # selects. So if the player choices to play in Wide3 (1024x640) it will look in 
#~ # the Graphics folder for a folder called 1024x640. Inside the 1024x640 folder 
#~ # you should place folder just like in the Graphics folder. So if the player 
#~ # starts the game in 1024x640 resolution it will look for a title image in 
#~ #   "Graphics/1024x640/Title1/filename" instead of "Graphics/Title1/filename"
#~ # 
#~ # If it doesn't find a file in the resolution folder, it will look in the normal 
#~ # spot for the file. So name your files consistantly :)
#~ # 
#~ # This is a plug and play script. Place this script in the script editor towards
#~ # the bottom of the list in the section labeled "▼ Materials"
#~ #
#~ # NOTE: it's possible you will get an "RGSS Player stoped working." if the 
#~ # user's graphics card doesn't support the desired resolution!! Keep this in 
#~ # mind when picking a default resolution for the first time the game starts.
#~ #===============================================================================
#~ # ★☆★☆★☆★☆★☆★☆★☆★ TERMS AND CONDITIONS: ☆★☆★☆★☆★☆★☆★☆★☆★☆
#~ #===============================================================================
#~ # This script can be use in both commercial and non-commercial games.
#~ # Credit must be given to Dekita and Venka.
#~ #===============================================================================

#~ module SelRes
#~   #-----------------------------------------------------------------------------
#~   # Set up resoltion settings
#~   # You can add or take away from this list. It's best to use multiples of 32 
#~   # because tileset are 32 pixels.
#~   #-----------------------------------------------------------------------------
#~   Sizes = [
#~   # [ "Name Text", Width, Height],
#~   # [ "Normal1"  ,   544,   416 ],
#~   # [ "Normal2"  ,   640,   480 ],
#~   # [ "Normal3"  ,   736,   576 ],
#~     [ "일반 모니터"    ,   928,   704 ],
#~   #  [ "Wide1"    ,   640,   416 ],
#~   #  [ "조이플 모니터"  ,   800,   600 ],
#~     [ "와이드 모니터"  ,   832,   544 ],
#~   #  [ "와이드 모니터"  ,   960,   540 ],
#~     [ "와이드 모니터"  ,  1024,   640 ],
#~   ] # <- Don't remove
#~   #-----------------------------------------------------------------------------
#~   # Pick the default resolution for when the game starts up for the first time.
#~   # The next time the game starts, the resolution will be whatever the player 
#~   # picks.
#~   #-----------------------------------------------------------------------------
#~   #Default_Size = nil
#~   Default_Size = ["와이드 모니터", 832, 544]
#~   #-----------------------------------------------------------------------------
#~   # Select the first scene to show after the player picks their resolution. In 
#~   # most cases this is "Scene_Title" unless you are using some custom start up.
#~   #-----------------------------------------------------------------------------
#~   First_Scene  = Scene_Title
#~   #First_Scene  = Scene_Map
#~   Options_Text = "해상도 변경"
#~ end
#~ #===============================================================================
#~ module SceneManager
#~ #===============================================================================
#~   #----------------------------------------------------------------------------
#~   # ● overwrite method: first_scene_class
#~   #----------------------------------------------------------------------------
#~   def self.first_scene_class
#~     #if Graphics.initialize_resolution[1]
#~     #  size = Graphics.initialize_resolution[0]
#~     #  Graphics.resize_screen(size[1],size[2])
#~     $BTEST ? Scene_Battle : SelRes::First_Scene
#~     #else
#~     #  Scene_ResSel
#~     #end
#~   end
#~ end
#~ #===============================================================================
#~ module Cache
#~ #===============================================================================
#~   #----------------------------------------------------------------------------
#~   # ● overwrite method: normal_bitmap
#~   #----------------------------------------------------------------------------
#~   def self.normal_bitmap(path)
#~     if path[0..8] == "Graphics/"
#~       begin
#~         #if $game_switches[48] == true
#~         reso_path = path.clone
#~         reso_path.insert(9, "#{Graphics.width}x#{Graphics.height}/")
#~         @cache[reso_path] = Bitmap.new(reso_path) unless include?(reso_path)
#~         @cache[reso_path]
#~         #else
#~         #  @cache[path] = Bitmap.new(path) unless include?(path)
#~         #  @cache[path]
#~         #end
#~       rescue
#~         @cache[path] = Bitmap.new(path) unless include?(path)
#~         @cache[path]
#~       end
#~     end
#~   end
#~ end
#~ #===============================================================================
#~ class Window_ResSel < Window_Command
#~ #===============================================================================
#~   #----------------------------------------------------------------------------
#~   # ● upgraded method: initialize
#~   #----------------------------------------------------------------------------
#~   def initialize(reso_size)
#~     super(0, 0)
#~     select(get_index(reso_size))
#~     @reso = reso_size
#~     hide
#~     move_window
#~   end
#~   #----------------------------------------------------------------------------
#~   # ○ new method: get_index
#~   #----------------------------------------------------------------------------
#~   def get_index(reso_size)
#~     item_max.times do |i|
#~       return i if @list[i][:name] == "#{reso_size[1]}x#{reso_size[2]}"
#~     end
#~   end
#~   #----------------------------------------------------------------------------
#~   # ○ new method: move_window
#~   #----------------------------------------------------------------------------
#~   def move_window
#~     self.x = (Graphics.width - window_width) * 0.5
#~     self.y = (Graphics.height - height) / 2
#~     show
#~   end
#~   #----------------------------------------------------------------------------
#~   # ● window settings
#~   #----------------------------------------------------------------------------
#~   def window_width; return 220; end
#~   #----------------------------------------------------------------------------
#~   # ● upgraded method: make_command_list
#~   #----------------------------------------------------------------------------
#~   def make_command_list
#~     SelRes::Sizes.compact.each do |data|
#~       add_command("#{data[1]}x#{data[2]}", :reso)
#~     end
#~   end
#~   #----------------------------------------------------------------------------
#~   # ● upgraded method: draw_item
#~   #----------------------------------------------------------------------------
#~   def draw_item(index)
#~     rect = item_rect_for_text(index)
#~     rect.width = item_rect_for_text(index).width * 0.5
#~     draw_text(rect, SelRes::Sizes[index][0], 1)
#~     rect.x += rect.width
#~     draw_text(rect, command_name(index), 1)
#~   end
#~ end
#~ #===============================================================================
#~ class Scene_ResSel < Scene_Base
#~ #===============================================================================
#~   #----------------------------------------------------------------------------
#~   # ● upgraded method: start
#~   #----------------------------------------------------------------------------
#~   def start
#~     #size = Graphics.initialize_resolution[0]
#~     #Graphics.resize_screen(size[1],size[2])
#~     size = ["와이드 모니터", 832, 544]
#~     super
#~     @command = Window_ResSel.new(size)
#~     @command.set_handler(:reso, method(:fix_reso))
#~   end
#~   #----------------------------------------------------------------------------
#~   # ○ new method: fix_reso
#~   #----------------------------------------------------------------------------
#~   def fix_reso
#~     @command.hide
#~     size = SelRes::Sizes.compact[@command.index]
#~     Graphics.resize_screen(size[1], size[2])
#~     Graphics.save_resolution(size)
#~     SceneManager.goto($BTEST ? Scene_Battle : SelRes::First_Scene)
#~   end
#~ end
#~ #===============================================================================
#~ class << Graphics
#~ #===============================================================================
#~   #----------------------------------------------------------------------------
#~   # ♦ Private Instance Variables
#~   #----------------------------------------------------------------------------
#~   ReadIni  = Win32API.new('kernel32', 'GetPrivateProfileString'  , 'ppppip', 'i')
#~   WriteIni = Win32API.new('kernel32', 'WritePrivateProfileString', 'pppp'  , 'i')
#~   #----------------------------------------------------------------------------
#~   # ○ new method: initialize_resolution
#~   #----------------------------------------------------------------------------
#~   def initialize_resolution
#~     @reso_setting = []
#~     load_resolution
#~     set_up = (@reso_setting[1] == 0 ? false : true)
#~     #print("108_2.해상도 선택 옵션 - 초기화 \n")
#~     @reso_setting = SelRes::Default_Size if @reso_setting[1] == 0
#~     return [@reso_setting, set_up]
#~   end
#~   #----------------------------------------------------------------------------
#~   # ○ new method: load_resolution
#~   #----------------------------------------------------------------------------
#~   def load_resolution
#~     buffer = [].pack('x256')
#~     get_option = Proc.new do |key|
#~       l = ReadIni.call('Resolution', key, '0', buffer, buffer.size, './Game.ini')
#~       buffer[0, l]
#~     end
#~     @reso_setting[1] = get_option.call('Width', '0').to_i
#~     @reso_setting[2] = get_option.call('Height', '0').to_i
#~   end
#~   #----------------------------------------------------------------------------
#~   # ○ new method: save_resolution
#~   #----------------------------------------------------------------------------
#~   def save_resolution(setting)
#~     @reso_setting = setting
#~     set_option = Proc.new do |key, value|
#~       WriteIni.call('Resolution', key, value.to_s, './Game.ini')
#~     end
#~     set_option.call('Width', @reso_setting[1])
#~     set_option.call('Height', @reso_setting[2])
#~   end
#~ end
#~ #===============================================================================
#~ class Window_TitleCommand < Window_Command
#~ #===============================================================================
#~   #----------------------------------------------------------------------------
#~   # ● overwrite method: make_command_list
#~   #----------------------------------------------------------------------------
#~   def make_command_list
#~     add_command(Vocab::new_game,      :new_game)
#~     add_command(Vocab::continue,      :continue, continue_enabled)
#~     #add_command("빠른 불러오기", :autosave)
#~     add_command(SelRes::Options_Text, :settings)
#~     add_command(Vocab::shutdown,      :shutdown)
#~   end
#~ end
#~ #===============================================================================
#~ class Scene_Title < Scene_Base
#~ #===============================================================================
#~   #----------------------------------------------------------------------------
#~   # ● alias method: create_command_window
#~   #----------------------------------------------------------------------------
#~   alias :reso_settings_ccw :create_command_window
#~   def create_command_window
#~     reso_settings_ccw
#~     @command_window.set_handler(:settings, method(:command_settings))
#~     #@command_window.set_handler(:autosave, method(:command_autosave))
#~   end
#~   #----------------------------------------------------------------------------
#~   # ○ new method: command_settings
#~   #----------------------------------------------------------------------------
#~   def command_settings
#~     SceneManager.goto(Scene_ResSel)
#~   end
#~ end