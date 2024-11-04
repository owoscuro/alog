# encoding: utf-8
# Name: 245.Scene_Storage_2
# Size: 14306
class Scene_Storage_2 < Scene_MenuBase
  def start
    super
    @storage_category = $game_temp.storage_category
    @storage_name_window = $game_temp.storage_name_window
    create_help_window
    create_command_window
    create_name_window
    create_dummy_window
    create_category_window
    create_item_window
    create_number_window
    create_status_window
    create_buy_window
    create_sell_window
    
    # 상세 데이터 설명창 추가
    create_description_window
  end
  
  def create_freeslot_window
    if @storage_category == false
      wy = @command_window.y + @command_window.height + @item_window.height
    else
      wy = @category_window.y + @category_window.height + @item_window.height
    end
    wh = Theo::LimInv::Display_ItemSize ? Graphics.width/2 : Graphics.width
    @freeslot = Window_FreeSlot_2.new(0,wy,wh)
    @freeslot.viewport = @viewport
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
    @command_window = Window_StorageCommand_2.new
    @command_window.viewport = @viewport
    @command_window.y = @help_window.height
    @command_window.set_handler(:withdraw, method(:command_withdraw))
    @command_window.set_handler(:store, method(:command_store))
    @command_window.set_handler(:cancel, method(:return_scene))
  end
  
  def create_name_window
    @name_window = Window_StorageName_2.new
    @name_window.viewport = @viewport
    @name_window.x = @command_window.width
    @name_window.y = @help_window.height
    if @storage_name_window == true
      @name_window.show
    end
  end
  
  def create_dummy_window
    wy = @command_window.y + @command_window.height
    wh = Graphics.height - wy
    @dummy_window = Window_Base.new(0, wy, Graphics.width, wh)
    @dummy_window.viewport = @viewport
  end
  
  def create_number_window
    wy = @dummy_window.y + @category_window.height
    wh = @dummy_window.height - @category_window.height
    @number_window = Window_ShopNumber.new(0, wy, wh)
    @number_window.viewport = @viewport
    @number_window.hide
    # 구매 혹은 판매 수량 조절 활성화 상태
    @number_window.set_handler(:ok,     method(:on_number_ok))
    @number_window.set_handler(:cancel, method(:on_number_cancel))
  end
  
  def on_number_ok
    Sound.play_shop
    case @command_window.current_symbol
    when :withdraw
      activate_buy_window
    when :store
      activate_sell_window
    end
  end
  
  def create_category_window
    @category_window = Window_StorageCategory_2.new
    @category_window.viewport = @viewport
    @category_window.help_window = @help_window
    @category_window.y = @dummy_window.y
    @category_window.hide.deactivate
    @category_window.set_handler(:ok,     method(:on_category_ok))
    @category_window.set_handler(:cancel, method(:on_category_cancel))
    if @help_window
      @help_window.set_text(BRAVO_STORAGE_2::HELP_TEXT_01, nil)
    end
  end
  
  def create_item_window
    if @storage_category == false
      wy = @command_window.y + @command_window.height
      wh = Graphics.height - wy
    else
      wy = @category_window.y + @category_window.height
      wh = Graphics.height - wy
    end
    @item_window = Window_StorageItemList_2.new(0, wy, Graphics.width, wh)
    @item_window.viewport = @viewport
    @item_window.help_window = @help_window
    @item_window.hide
    @item_window.set_handler(:ok,     method(:on_item_ok))
    @item_window.set_handler(:cancel, method(:on_item_cancel))
    @category_window.item_window = @item_window
    #--------------------------------------------------------------------------
    # 상세 데이터 설명창 추가
    #--------------------------------------------------------------------------
    @item_window.set_handler(:description, method(:on_item_description))
    #--------------------------------------------------------------------------
  end
  
  def start_category_selection
    @dummy_window.hide
    @item_window.show
    @item_window.unselect
    @item_window.refresh
    @item_window.storage = @command_window.current_symbol
    
    # 카테고리 변경시 새로고침 적용
    @category_window.item_window = @item_window
    @category_window.show.activate
    if @help_window
      @help_window.set_text(BRAVO_STORAGE_2::HELP_TEXT_01, nil)
      #@help_window.set_text("상인마다 구매 및 판매하는 아이템이 다르며, 재고 수량이 있습니다.\n재고는 특정 시간 및 상황에 따라 변화하며 가끔 희귀한 아이템도 등장합니다.", nil)
    end
  end
  
  def command_withdraw
    $game_switches[141] = false
    start_category_selection
  end
  
  def command_store
    $game_switches[141] = true
    start_category_selection
  end
  
  def on_category_ok
    case @category_window.current_symbol
    when :item, :weapon, :armor, "포션", "음식", "기타"
      @item_window.activate
      @item_window.select_last
    end
  end
  
  def on_category_cancel
    @command_window.activate
    @dummy_window.show
    @item_window.hide
    @category_window.hide
  end
  
  def on_item_ok
    # 아이템 선택시 우측에 착용시 능력치 변경 간단 데이터 표기
    if @status_window
      @status_window.item = 0
      @status_window.item = @item_window.item
      @status_window.refresh
    end
    @item = @item_window.item
    @item_window.hide
    @dummy_window.hide
    case @command_window.current_symbol
    when :withdraw
      # 아이템 선택시 바로 구매로 이동
      on_buy_ok
    when :store
      # 아이템 선택시 바로 판매로 이동
      on_sell_ok
    end
  end
  
  def on_item_cancel
    @item_window.unselect
    @category_window.activate
    if @help_window and SceneManager.scene_is?(Scene_Item)
      @help_window.set_text(BRAVO_STORAGE_2::HELP_TEXT_02, nil)
    elsif @help_window and SceneManager.scene_is?(Scene_Storage_2)
      @help_window.set_text(BRAVO_STORAGE_2::HELP_TEXT_01, nil)
    end
  end
  
  def on_number_cancel
    Sound.play_cancel
    @number_window.hide
    @status_window.hide
    @item_window.show.activate
    @category_window.item_window = @item_window
  end
  
  def create_status_window
    wx = @number_window.width
    wy = @dummy_window.y + @category_window.height
    ww = Graphics.width - wx
    wh = @dummy_window.height - @category_window.height
    @status_window = Window_ShopStatus.new(wx, wy, ww, wh)
    @status_window.viewport = @viewport
    @status_window.hide
  end
  
  def create_buy_window
    wy = @category_window.y + @category_window.height
    wh = Graphics.height - wy - @category_window.height
    @goods = $game_party.storage_all_items.select {|item| include?(item) }
    @buy_window = Window_ShopBuy.new(0, wy, wh, @goods)
    @buy_window.viewport = @viewport
    @buy_window.help_window = @help_window
    @buy_window.hide
    @buy_window.set_handler(:ok,     method(:on_buy_ok))
    @buy_window.set_handler(:cancel, method(:on_buy_cancel))
    @category_window.item_window = @item_window
    @category_window.item_window = @buy_window
  end
  
  #--------------------------------------------------------------------------
  # 상세 데이터 설명창 추가
  #--------------------------------------------------------------------------
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
    @description_window.hide.deactivate
  end
  
  def on_item_description
    @description_window.show.activate
    @description_window.refresh(@item_window.item)
    @dummy_window.hide
    @number_window.hide
    @command_window.hide
    @help_window.hide
    @item_window.hide
    @buy_window.hide if @buy_window
    @sell_window.hide if @sell_window
    @status_window.hide
    @category_window.hide
  end
  
  def include?(item)
    return item != nil if @category == :all
    case @category
    when String
      prefix = CAO::CategorizeItem::KEYWORD_PREFIX
      suffix = CAO::CategorizeItem::KEYWORD_SUFFIX
      return item && item.note.include?("#{prefix}#{@category}#{suffix}")
    when :all
      return item != nil
    when :all_item
      return item.is_a?(RPG::Item)
    when :item
      return item.is_a?(RPG::Item) && !item.key_item?
    when :equip
      return item.is_a?(RPG::EquipItem)
    when :weapon
      return item.is_a?(RPG::Weapon)
    when :armor
      return item.is_a?(RPG::Armor)
    when :key_item
      return item.is_a?(RPG::Item) && item.key_item?
    end
    return false
  end
  
  def on_buy_ok
    @category_window.item_window = @buy_window
    @buy_window.hide
    @status_window.show
    @number_window.set(@item, max_buy, buying_price, currency_unit)
    @number_window.show.activate
  end
  
  def buying_price
    #@item.price * (100 + $game_variables[TMPRICE::VN_BUYING_RATE] + $game_variables[170] - $game_variables[295]) / (500 - $game_variables[163])
    # 구매 가격
    (@item.price * ($game_variables[163] * 0.01).to_f).to_i
  end
  
  def selling_price
    #@item.price * (100 + $game_variables[TMPRICE::VN_SELLING_RATE] + $game_variables[171] + $game_variables[295]) / (500 - $game_variables[161])
    # 판매 가격
    (@item.price * ($game_variables[161] * 0.01).to_f).to_i
  end
  
  def max_buy
    if @item.is_a?(RPG::Weapon) || @item.is_a?(RPG::Armor)
      if @item.durability != nil
        max = $game_party.storage_item_number(@item)
      else
        max = $game_party.storage_item_number(@item) - 1
      end
    else
      max = $game_party.storage_item_number(@item) - 1
    end
    buying_price == 0 ? max : [max, money / buying_price].min
  end
  
  def on_buy_cancel
    return_scene
  end
  
  def money
    @status_window.value
  end
  
  def create_sell_window
    wy = @category_window.y + @category_window.height
    wh = Graphics.height - wy - @category_window.height
    @sell_window = Window_ShopSell.new(0, wy, Graphics.width, wh)
    @sell_window.viewport = @viewport
    @sell_window.help_window = @help_window
    @sell_window.hide
    @sell_window.set_handler(:ok,     method(:on_sell_ok))
    @sell_window.set_handler(:cancel, method(:on_sell_cancel))
    @category_window.item_window = @item_window
    @category_window.item_window = @sell_window
  end
  
  def on_sell_ok
    @category_window.item_window = @sell_window
    @sell_window.hide
    @status_window.show
    @number_window.set(@item, max_sell, selling_price, currency_unit)
    @number_window.show.activate
  end
  
  def currency_unit
    @status_window.currency_unit
  end
  
  def max_sell
    $game_party.item_number(@item)
  end
  
  def on_sell_cancel
    @number_window.hide.deactivate
    @sell_window.hide.deactivate
    @status_window.item = nil
    @status_window.hide.deactivate
    @help_window.clear
    @item_window.show.activate
  end
  
  def activate_buy_window
    number = @number_window.number
    item_price = number * buying_price
    $game_party.gain_gold(-item_price)
    $game_party.gain_item(@item, number)
    
    # 지역 공헌도 추가, 더하기
    $game_factions = Game_Factions.new if $game_factions == nil
    if $game_variables[157]-1 >= 1
      @fac_gold = (item_price / 10000).to_i
      if @fac_gold != nil and @fac_gold >= 1
        $game_factions.gain_reputation(($game_variables[157]-1).to_i, @fac_gold)
      end
    end
    
    # 상점에 물건을 제거
    $game_party.storage_lose_item(@item, number)
    
    @help_window.clear
    @number_window.hide.deactivate
    @buy_window.hide.deactivate
    @status_window.hide
    
    @buy_window.money = money

    @item_window.show
    @item_window.refresh
    @item_window.index -= 1 if @item_window.item == nil
    @item_window.index == -1 ? @item_window.activate.select(0) : @item_window.activate

    @category_window.item_window = @item_window
  end
  
  def activate_sell_window
    number = @number_window.number
    item_price = number * selling_price
    $game_party.gain_gold(item_price)
    $game_party.lose_item(@item, number)
    
    # 지역 공헌도 추가, 더하기
    $game_factions = Game_Factions.new if $game_factions == nil
    if $game_variables[157]-1 >= 1
      @fac_gold = (item_price / 10000).to_i
      if @fac_gold != nil and @fac_gold >= 1
        $game_factions.gain_reputation(($game_variables[157]-1).to_i, @fac_gold)
      end
    end
    
    # 상점에 물건을 추가
    $game_party.storage_gain_item(@item, number)
    
    @help_window.clear
    @number_window.hide.deactivate
    @sell_window.hide.deactivate
    @status_window.hide

    @item_window.show
    @item_window.refresh
    @item_window.index -= 1 if @item_window.item == nil
    @item_window.index == -1 ? @item_window.activate.select(0) : @item_window.activate

    @category_window.item_window = @item_window
  end
  
  def max_withdraw
    case @category_window.current_symbol
    when :item, :weapon, :armor, "포션", "음식", "기타"
      if $game_party.storage_item_number(@item) > BRAVO_STORAGE_2::ITEM_MAX
        return BRAVO_STORAGE_2::ITEM_MAX
      else
        $game_party.storage_item_number(@item)
      end
    end
  end
  
  def max_store
    case @category_window.current_symbol
    when :item, :weapon, :armor, "포션", "음식", "기타"
      if $game_party.item_number(@item) > BRAVO_STORAGE_2::ITEM_MAX
        return BRAVO_STORAGE_2::ITEM_MAX
      else
        $game_party.item_number(@item)
      end
    end
  end
end