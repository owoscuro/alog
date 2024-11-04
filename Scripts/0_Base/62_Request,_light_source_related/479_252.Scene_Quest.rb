# encoding: utf-8
# Name: 252.Scene_Quest
# Size: 9700
class Scene_Quest < Scene_MenuBase
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Start Scene Processing
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def start
    super
    @init_category, @init_quest_index = $game_party.quests.find_location($game_system.last_quest_id, $game_system.last_quest_cat)
    create_maqj_picture unless $game_system.quest_bg_picture.empty?
    create_all_windows
    adjust_window_positions
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Terminate Scene
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def terminate
    $game_system.quest_categories = QuestData::CATEGORIES
    $game_system.quest_scene_label = QuestData::VOCAB[:scene_label]
    $game_system.last_quest_id = @quest_list_window.item ? @quest_list_window.item.id : 0
    $game_system.last_quest_cat = @quest_category_window ? 
      @quest_category_window.item : $game_system.quest_categories[0]
    super
    dispose_maqj_picture
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Create Background Picture
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def create_maqj_picture
    @maqj_picture_sprite = Sprite.new
    @maqj_picture_sprite.bitmap = Cache.picture($game_system.quest_bg_picture)
    @maqj_picture_sprite.opacity = $game_system.quest_bg_opacity
    @maqj_picture_sprite.blend_type = $game_system.quest_bg_blend_type
    @maqj_picture_sprite.z = @background_sprite.z + 1 if @background_sprite
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Create All Windows
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def create_all_windows
    create_quest_label_window unless $game_system.quest_scene_label.empty?
    create_quest_category_window if $game_system.quest_categories.size > 1
    create_quest_category_label_window if QuestData::SHOW_CATEGORY_LABEL
    create_dummy_category_window if QuestData::CATEGORY_LABEL_IN_SAME_WINDOW &&
      @quest_category_window && @quest_category_label_window
    create_quest_list_window
    create_quest_data_window
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Create QuestLabel Window
  #    This window shows the name of the scene
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def create_quest_label_window
    @quest_label_window = Window_QuestLabel.new(0, 0, $game_system.quest_scene_label)
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Create QuestCategory Window
  #    This window allows the player to switch categories.
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def create_quest_category_window
    @quest_category_window = Window_QuestCategory.new(0, 0, $game_system.quest_categories)
    @quest_category_window.category = @init_category if @init_category
    @quest_category_window.set_handler(:cancel, method(:on_category_cancel))
    @quest_category_window.set_handler(:ok, method(:on_category_ok)) 
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Create QuestCategoryLabel Window
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def create_quest_category_label_window
    if @quest_category_window
      @quest_category_label_window = Window_QuestCategoryLabel.new(0, @quest_category_window.height)
      @quest_category_window.add_observing_proc(:label) { |category| 
        @quest_category_label_window.category = category }
    else
      @quest_category_label_window = Window_QuestCategoryLabel.new(0, 0)
      @quest_category_label_window.category = $game_system.quest_categories ? $game_system.quest_categories[0] : :all
    end
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Create Dummy Category Label Window
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def create_dummy_category_window
    @quest_category_label_window.y -= 12
    @quest_category_label_window.opacity = 0
    @quest_category_window.opacity = 0
    w = [@quest_category_window.width, @quest_category_label_window.width].max
    h = @quest_category_window.height + @quest_category_label_window.height - 12
    @category_dummy_window = Window_QuestCategoryDummy.new(0, 0, w, h)
    @category_dummy_window.z = [@quest_category_window.z, @quest_category_label_window.z].min - 1
    # Draw Horz Line
    @category_dummy_window.draw_horizontal_line(@quest_category_window.height - @quest_category_window.padding - 7, 2)
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Create QuestList Window
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def create_quest_list_window
    if @category_dummy_window
      y = @category_dummy_window.height
    else
      y = @quest_category_window ? @quest_category_window.height : 0
      y += @quest_category_label_window ? @quest_category_label_window.height : 0
      y = @quest_label_window.height if y == 0
    end
    @quest_list_window = Window_QuestList.new(0, y, QuestData::LIST_WINDOW_WIDTH, 
      Graphics.height - y)
    @quest_list_window.set_handler(:ok, method(:on_list_ok))
    @quest_list_window.deactivate if !QuestData::CONCURRENT_ACTIVITY
    if !QuestData::CONCURRENT_ACTIVITY || !@quest_category_window
      @quest_list_window.set_handler(:cancel, method(:on_list_cancel))
    end
    if @quest_category_window
      @quest_category_window.add_observing_proc(:list) { |category| 
        @quest_list_window.category = category }
    else
      @quest_list_window.category = $game_system.quest_categories[0]
    end
    @quest_list_window.index = @init_quest_index if @init_quest_index
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Create QuestData Window
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def create_quest_data_window
    x = @quest_list_window.width
    y = (@quest_label_window && (@quest_category_window || 
      @quest_category_label_window)) ? @quest_label_window.height : 0
    @quest_data_window = Window_QuestData.new(x, y, Graphics.width - x, 
      Graphics.height - y)
    @quest_list_window.help_window = @quest_data_window
    @quest_data_window.quest = @quest_list_window.item
    @quest_data_window.set_handler(:ok, method(:on_data_ok))
    @quest_data_window.set_handler(:cancel, method(:on_data_cancel))
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Dispose Background Picture
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def dispose_maqj_picture
    @maqj_picture_sprite.dispose if @maqj_picture_sprite
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Adjust Window Positions
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def adjust_window_positions
    if @quest_label_window && (@quest_category_window || @quest_category_label_window)
      @quest_label_window.x = QuestData::LIST_WINDOW_WIDTH 
    end
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Category OK
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def on_category_ok; @quest_list_window.activate; end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Category Cancel
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def on_category_cancel; return_scene; end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * List OK
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def on_list_ok
    @quest_category_window.deactivate if @quest_category_window
    @quest_data_window.activate
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * List Cancel
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def on_list_cancel
    @quest_category_window ? @quest_category_window.activate : return_scene
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Data OK
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def on_data_ok; on_data_cancel; end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Data Cancel
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def on_data_cancel
    @quest_list_window.activate
    @quest_category_window.activate if @quest_category_window && QuestData::CONCURRENT_ACTIVITY
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Update All Windows
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def update_all_windows(*args, &block)
    # To accomodate for concurrent activity, must deactivate category
    @quest_category_window.deactivate if @quest_category_window &&
      QuestData::CONCURRENT_ACTIVITY && @quest_list_window.active && 
      Input.trigger?(:C)
    super(*args, &block)
    @quest_category_window.activate if @quest_category_window &&
      QuestData::CONCURRENT_ACTIVITY && @quest_list_window.active
  end
end