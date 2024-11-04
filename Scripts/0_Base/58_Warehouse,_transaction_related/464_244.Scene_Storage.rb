# encoding: utf-8
# Name: 244.Scene_Storage
# Size: 10364
class Scene_Storage < Scene_MenuBase
  def start
    super
    @storage_gold = $game_temp.storage_gold
    @storage_category = $game_temp.storage_category
    @storage_name_window = $game_temp.storage_name_window
    create_help_window
    create_command_window
    create_name_window
    create_dummy_window
    create_category_window
    create_item_window
    create_number_window
    create_gold_window
    create_itemsize_window

    # 상세 데이터 설명창 추가
    create_description_window
  end

  def create_itemsize_window
    return unless Theo::LimInv::Display_ItemSize
    wx = 0
    if @storage_category == false
      wy = @command_window.y + @command_window.height + @item_window.height
    else
      wy = @category_window.y + @category_window.height + @item_window.height
    end
    ww = Graphics.width
    @itemsize = Window_ItemSize.new(wx,wy,ww)
    @itemsize.viewport = @viewport
    @item_window.item_size_window = @itemsize
  end
  
  #--------------------------------------------------------------------------
  # 가온데 정렬 추가 수정
  #--------------------------------------------------------------------------
  def alignment
    return 1
  end
  
  def create_command_window
    @command_window = Window_StorageCommand.new
    @command_window.viewport = @viewport
    @command_window.y = @help_window.height
    @command_window.set_handler(:withdraw, method(:command_withdraw))
    @command_window.set_handler(:store, method(:command_store))
    @command_window.set_handler(:cancel, method(:return_scene))
  end
  
  def create_name_window
    @name_window = Window_StorageName.new
    @name_window.viewport = @viewport
    @name_window.x = @command_window.width
    @name_window.y = @help_window.height
    if @storage_name_window == true
      @name_window.show
    end
  end
  
  def create_dummy_window
    wy = @command_window.y + @command_window.height
    wh = Graphics.height - wy - @command_window.height
    @dummy_window = Window_Base.new(0, wy, Graphics.width, wh)
    @dummy_window.viewport = @viewport
  end
  
  def create_number_window
    @number_window = Window_StorageNumber.new
    @number_window.viewport = @viewport
    @number_window.x = ((Graphics.width / 2) - (@number_window.width / 2)) 
    @number_window.y = ((Graphics.height / 2) - (@number_window.height / 2)) 
    @number_window.hide
    @number_window.set_handler(:ok,     method(:on_number_ok))
    @number_window.set_handler(:cancel, method(:on_number_cancel))
  end
  
  def create_category_window
    @category_window = Window_StorageCategory.new(@storage_gold)
    @category_window.viewport = @viewport
    @category_window.help_window = @help_window
    @category_window.y = @dummy_window.y
    @category_window.hide.deactivate
    @category_window.set_handler(:ok,     method(:on_category_ok))
    @category_window.set_handler(:cancel, method(:on_category_cancel))
  end
  
  def create_item_window
    if @storage_category == false
      wy = @command_window.y + @command_window.height
      wh = Graphics.height - wy - @command_window.height
    else
      wy = @category_window.y + @category_window.height
      wh = Graphics.height - wy - @category_window.height
    end
    @item_window = Window_StorageItemList.new(0, wy, Graphics.width, wh)
    @item_window.viewport = @viewport
    @item_window.help_window = @help_window
    @item_window.hide
    @item_window.set_handler(:ok,     method(:on_item_ok))
    @item_window.set_handler(:cancel, method(:on_item_cancel))
    if @storage_category == false
      @item_window.category = :all
    else
      @category_window.item_window = @item_window
    end
    #--------------------------------------------------------------------------
    # 상세 데이터 설명창 추가
    #--------------------------------------------------------------------------
    @item_window.set_handler(:description, method(:on_item_description))
    #--------------------------------------------------------------------------
  end
  
  def create_gold_window
    @gold_window = Window_GoldTransfer.new
    @gold_window.viewport = @viewport
    @gold_window.x = ((Graphics.width / 2) - (@gold_window.width / 2)) 
    @gold_window.y = ((Graphics.height / 2) - (@gold_window.height / 2)) 
    @gold_window.hide
    @gold_window.set_handler(:ok,     method(:on_gold_ok))
    @gold_window.set_handler(:cancel, method(:on_gold_cancel))
  end
  
  def start_category_selection
    @dummy_window.hide
    @item_window.show
    @item_window.unselect
    @item_window.refresh
    @item_window.storage = @command_window.current_symbol
    @category_window.show.activate
  end
  
  def command_withdraw
    if @storage_category == false and @storage_gold == true
      case @command_window.current_symbol
      when :withdraw
        @gold_window.set(max_withdraw, 24)
      when :store
        @gold_window.set(max_store, 0)
      end
      @gold_window.show.activate
    elsif @storage_category == false
      @dummy_window.hide
      @item_window.show.activate
      @item_window.storage = @command_window.current_symbol
      @item_window.select_last
    else
      start_category_selection
    end
  end
  
  def command_store
    if @storage_category == false and @storage_gold == true
      case @command_window.current_symbol
      when :withdraw
        @gold_window.set(max_withdraw, 24)
      when :store
        @gold_window.set(max_store, 0)
      end
      @gold_window.show.activate
    elsif @storage_category == false
      @dummy_window.hide
      @item_window.show.activate
      @item_window.storage = @command_window.current_symbol
      @item_window.select_last
    else
      start_category_selection
    end
  end
  
  def on_category_ok
    case @category_window.current_symbol
    when :item, :weapon, :armor, "포션", "음식", "기타"
      @item_window.activate
      @item_window.select_last
    when :gold
      case @command_window.current_symbol
      when :withdraw
        @gold_window.set(max_withdraw, 24)
      when :store
        @gold_window.set(max_store, 0)
      end
      @gold_window.show.activate
    end
  end
  
  def on_category_cancel
    @command_window.activate
    @dummy_window.show
    @item_window.hide
    @category_window.hide
  end
  
  def on_item_ok
    @item = @item_window.item
    case @command_window.current_symbol
    when :withdraw
      @number_window.set(@item, max_withdraw)
    when :store
      @number_window.set(@item, max_store)
    end
    @number_window.show.activate
  end
  
  def on_item_cancel
    @item_window.unselect
    if @storage_category == false
      @item_window.hide
      @dummy_window.show
      @command_window.activate
    else
      @category_window.activate
    end
  end
  
  def on_number_ok
    Sound.play_ok
    case @command_window.current_symbol
    when :withdraw
      do_withdraw(@number_window.number)
    when :store
      do_store(@number_window.number)
    end
    @number_window.hide
    @item_window.refresh
    @item_window.activate
    @item_window.select_last
  end
  
  def on_number_cancel
    Sound.play_cancel
    @number_window.hide
    @item_window.activate
  end
  
  def create_description_window
    @description_window = Window_ItemDescription.new
    @description_window.hide
    @description_window.set_handler(:ok, method(:no_item_description))
    @description_window.set_handler(:cancel, method(:no_item_description))
  end
  
  def no_item_description
    Sound.play_cancel
    @command_window.show
    @item_window.show.activate
    @category_window.show
    @help_window.show
    @itemsize.show
    @description_window.hide.deactivate
  end
  
  def on_item_description
    @description_window.show.activate
    @description_window.refresh(@item_window.item)
    @dummy_window.hide
    @number_window.hide
    @command_window.hide
    @help_window.hide
    @itemsize.hide
    @item_window.hide
    @category_window.hide
  end
  
  def on_gold_ok
    case @command_window.current_symbol
    when :withdraw
      gold_withdraw(@gold_window.number)
      @gold_window.set(max_withdraw, 24)
    when :store
      gold_store(@gold_window.number)
      @gold_window.set(max_store, 0)
    end
    @gold_window.show.activate
    @gold_window.refresh
    Sound.play_ok
  end
  
  def on_gold_cancel
    Sound.play_cancel
    if @storage_category == false && @storage_gold == true
      @command_window.activate
    else
      start_category_selection
    end
    @gold_window.hide
  end
  
  def do_withdraw(number)
    $game_party.storage_lose_item(@item, number)
    $game_party.gain_item(@item, number)
  end
  
  def do_store(number)
    if $game_party.storage_item_number(@item) + number >= @item.storage_max
      number += @item.storage_max - ($game_party.storage_item_number(@item) + number)
    end
    if number >= 1
      $game_party.storage_gain_item(@item, number)
      $game_party.lose_item(@item, number)
    else
      Sound.play_buzzer
      # 오류 메세지 표시 실험 -----------------------
      $game_temp.pop_w(180, 'SYSTEM', 
      "  '%s' 아이템은 더 이상 넣을 수 없습니다.  " % [@item.name])
      # -------------------------------------------
    end
  end
  
  def gold_withdraw(number)
    $game_party.storage_lose_gold(number)
    $game_party.gain_gold(number)
  end
  
  def gold_store(number)
    $game_party.lose_gold(number)
    $game_party.storage_gain_gold(number)
  end
  
  def max_withdraw
    case @category_window.current_symbol
    when :item, :weapon, :armor, "포션", "음식", "기타"
      if $game_party.storage_item_number(@item) > BRAVO_STORAGE::ITEM_MAX
        return BRAVO_STORAGE::ITEM_MAX
      else
        $game_party.storage_item_number(@item)
      end
    when :gold
      if $game_party.storage_gold > BRAVO_STORAGE::GOLD_MAX
        return BRAVO_STORAGE::GOLD_MAX
      else
        $game_party.storage_gold
      end
    end
  end
  
  def max_store
    case @category_window.current_symbol
    when :item, :weapon, :armor, "포션", "음식", "기타"
      if $game_party.item_number(@item) > BRAVO_STORAGE::ITEM_MAX
        return BRAVO_STORAGE::ITEM_MAX
      else
        $game_party.item_number(@item)
      end
    when :gold
      if $game_party.gold > BRAVO_STORAGE::GOLD_MAX
        return BRAVO_STORAGE::GOLD_MAX
      else
        $game_party.gold
      end
    end
  end
end