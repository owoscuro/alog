# encoding: utf-8
# Name: 190.Window_StorageItemList_2
# Size: 15551
class Window_StorageItemList_2 < Window_ItemList
  def initialize(x, y, width, height)
    super(x, y, width, height)
    @storage = :none
  end
  
  #--------------------------------------------------------------------------
  # 가온데 정렬 추가 수정
  #--------------------------------------------------------------------------
  def alignment
    return 1
  end
  
  def col_max
    # 해상도 좌표
    if Graphics.height == 640 or Graphics.height == 704
      return 3
    else
      return 2
    end
  end
  
  def storage=(storage)
    return if @storage == storage
    @storage = storage
    refresh
    self.oy = 0
  end
  
  # 표기 활성화 여부
  def include?(item)
    return item != nil if @category == :all
    return false unless include_keyword?(item) unless @category.is_a?(String)
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
    else
      case @category.to_s
      when REGEXP_ETYPE
        return item.is_a?(RPG::EquipItem) && item.etype_id == $1.to_i
      when REGEXP_WTYPE
        return item.is_a?(RPG::Weapon) && item.wtype_id == $1.to_i
      when REGEXP_ATYPE
        return item.is_a?(RPG::Armor) && item.atype_id == $1.to_i
      end
    end
    return false
  end
  
  # 선택 활성화 여부
  def enable?(item)
    case @storage
      when :store
        if item.is_a?(RPG::Weapon) || item.is_a?(RPG::Armor)
          return false if item.durability == nil
        end
        return false if 1 > $game_party.item_number(item)
      when :withdraw
        if item.is_a?(RPG::Weapon) || item.is_a?(RPG::Armor)
          if item.durability != nil
            return false if 1 > $game_party.storage_item_number(item)
          else
            return false if 1 > $game_party.storage_item_number(item) - 1
          end
        else
          return false if 1 > $game_party.storage_item_number(item) - 1
        end
        # 구매 가격
        #n = item.price * (100 + $game_variables[TMPRICE::VN_BUYING_RATE] + $game_variables[170] - $game_variables[295]) / (500 - $game_variables[163])
        n = (item.price * ($game_variables[163] * 0.01).to_f).to_i
        return false if n > $game_party.gold
    end
    if item.is_a?(RPG::Item)
      return true if !item.key_item?
    elsif item.is_a?(RPG::Weapon) || item.is_a?(RPG::Armor)
      return true
    else
      return false
    end
  end
  
  def make_item_list
    case @storage
    when :store
      @data1 = $game_party.storage_all_items.select {|item| include?(item)}
      @data2 = $game_party.all_items.select {|item| include?(item)}
      @data = []
      @data1_ro = []

      # 상점에서 판매중인 아이템 및 장비와 겹치는지 확인한다.
      for k in @data1
        @data1_ro.push(k.template_id)
      end
      for i in @data2
        if @data1_ro.include?(i.template_id)
          @data.push(i)
        elsif $game_party.storage_name == "알린_라디예"
          @data.push(i)
        end
      end
      @data.push(nil) if include?(nil)
    when :withdraw
      if $game_party.storage_name != "알린_라디예"
        @quests = Game_Party.new
        @data1 = []
        @data1 = $game_party.storage_all_items.select {|item| include?(item)}
        if @category == :weapon
          #print("190.Window_StorageItemList_2 - 카테고리, %s \n" % [@category]);
          for k in @data1
            #-----------------------------------------------------------------------
            # 무기인 경우 인챈트 적용
            #-----------------------------------------------------------------------
            if k.is_a?(RPG::Weapon) and $game_switches[286] == true
              inh_rand = 0
              case rand(500)
                when 0..3;      inh_rand = rand(2) + 238; when 4..5;      inh_rand = 287
                when 6..7;      inh_rand = 289;           when 8..14;     inh_rand = rand(3) + 292
                when 14..20;    inh_rand = rand(2) + 297; when 21..40;    inh_rand = rand(3) + 232
                when 41..46;    inh_rand = rand(1) + 236; when 47..50;    inh_rand = rand(8) + 241
                when 51..52;    inh_rand = 284;           when 51..52;    inh_rand = 286
                when 53..55;    inh_rand = 290;           when 56..58;    inh_rand = 296
                when 59..61;    inh_rand = 300;           when 61..81;    inh_rand = rand(1) + 230
                else # 꽝
                  inh_rand = 302
              end
              if 10 >= rand(100) and inh_rand != 302 and inh_rand != 0
                k = $data_weapons[k.id]
                k = InstanceManager.get_instance(k)
                k.suffix_id = inh_rand
                $game_party.storage_gain_item(k, 1)
              elsif k.suffix_id == 0
                $game_party.storage_gain_item(k, rand(2))
              elsif k.durability != nil
                #print("190.Window_StorageItemList_2 - 무기 수량 -1 \n");
                $game_party.storage_gain_item(k, -1)
              end
            end
          end
          # 무기 상품 목록 인챈트 갱신 종료
          $game_switches[286] = false
        elsif @category == :armor
          #print("190.Window_StorageItemList_2 - 카테고리, %s \n" % [@category]);
          for k in @data1
            #-----------------------------------------------------------------------
            # 방어구인 경우 인챈트 적용
            #-----------------------------------------------------------------------
            if k.is_a?(RPG::Armor) and $game_switches[287] == true
              inh_rand = 0
              case rand(500)
                when 0..3;      inh_rand = rand(2) + 238; when 4..5;      inh_rand = 287
                when 6..7;      inh_rand = 289;           when 8..14;     inh_rand = rand(3) + 292
                when 14..20;    inh_rand = rand(2) + 297; when 21..40;    inh_rand = rand(3) + 232
                when 41..46;    inh_rand = rand(1) + 236; when 47..50;    inh_rand = rand(8) + 241
                when 51..52;    inh_rand = 284;           when 51..52;    inh_rand = 286
                when 53..55;    inh_rand = 290;           when 56..58;    inh_rand = 296
                when 59..61;    inh_rand = 300;           when 61..81;    inh_rand = rand(1) + 230
                else # 꽝
                  inh_rand = 302
              end
              if 10 >= rand(100) and inh_rand != 302 and inh_rand != 0
                k = $data_armors[k.id]
                k = InstanceManager.get_instance(k)
                k.suffix_id = inh_rand
                $game_party.storage_gain_item(k, 1)
              elsif k.suffix_id == 0
                $game_party.storage_gain_item(k, rand(2))
              elsif k.durability != nil
                #print("190.Window_StorageItemList_2 - 방어구 수량 -1 \n");
                $game_party.storage_gain_item(k, -1)
              end
            end
          end
          # 방어구 상품 목록 인챈트 갱신 종료
          $game_switches[287] = false
        elsif @category == "기타"
          #print("190.Window_StorageItemList_2 - 카테고리, %s \n" % [@category]);
          @data1 = $game_party.storage_all_items.select {|item| include?(item)}
          #print("기타 - %s \n" % [@data1]);
          #@data1 = $game_party.storage_all_items
          for k in @data1
            if !k.is_a?(RPG::Armor) and !k.is_a?(RPG::Weapon) and $game_switches[290] == true
              # 여관방 열쇠는 충전을 제외한다.
              if 370 > k.id and k.id > 404
              else
                $game_party.storage_gain_item(k, rand(11))
                # 의뢰를 아직 클리어하지 않았다면, 해당 품목 수량 0 으로 변경
                if @quests.quests[2].status?(:complete) == false
                  if k.id == 121
                    $game_party.storage_gain_item(k, -rand($game_party.storage_item_number(k)) - rand(5))
                  end
                end
                if @quests.quests[4].status?(:complete) == false or @quests.quests[23].status?(:complete) == false or @quests.quests[22].status?(:complete) == false
                  if k.id == 236
                    $game_party.storage_gain_item(k, -rand($game_party.storage_item_number(k)) - rand(5))
                  end
                end
                if @quests.quests[6].status?(:complete) == false or @quests.quests[19].status?(:complete) == false
                  if k.id == 255 or k.id == 256
                    $game_party.storage_gain_item(k, -rand($game_party.storage_item_number(k)) - rand(5))
                  end
                end
                if @quests.quests[9].status?(:complete) == false or @quests.quests[27].status?(:complete) == false
                  if k.id == 231
                    $game_party.storage_gain_item(k, -rand($game_party.storage_item_number(k)) - rand(5))
                  end
                end
                if @quests.quests[10].status?(:complete) == false or @quests.quests[21].status?(:complete) == false
                  if k.id == 250
                    $game_party.storage_gain_item(k, -rand($game_party.storage_item_number(k)) - rand(5))
                  end
                end
                if @quests.quests[22].status?(:complete) == false
                  if k.id == 344
                    $game_party.storage_gain_item(k, -rand($game_party.storage_item_number(k)) - rand(5))
                  end
                end
                if @quests.quests[24].status?(:complete) == false
                  if k.id == 112
                    $game_party.storage_gain_item(k, -rand($game_party.storage_item_number(k)) - rand(5))
                  end
                end
                if @quests.quests[25].status?(:complete) == false
                  if k.id == 126
                    $game_party.storage_gain_item(k, -rand($game_party.storage_item_number(k)) - rand(5))
                  end
                end
                if @quests.quests[30].status?(:complete) == false
                  if k.id == 268
                    $game_party.storage_gain_item(k, -rand($game_party.storage_item_number(k)) - rand(5))
                  end
                end
                $game_party.storage_gain_item(k, 1) if 1 > $game_party.storage_item_number(k)
              end
            end
          end
          $game_switches[290] = false
        elsif @category == "음식"
          #print("190.Window_StorageItemList_2 - 카테고리, %s \n" % [@category]);
          @data1 = $game_party.storage_all_items.select {|item| include?(item)}
          #print("음식 - %s \n" % [@data1]);
          #@data1 = $game_party.storage_all_items
          for k in @data1
            if !k.is_a?(RPG::Armor) and !k.is_a?(RPG::Weapon) and $game_switches[289] == true
              # 여관방 열쇠는 충전을 제외한다.
              if 370 > k.id and k.id > 404
              else
                $game_party.storage_gain_item(k, rand(9))
                # 의뢰를 아직 클리어하지 않았다면, 해당 품목 수량 0 으로 변경
                if @quests.quests[1].status?(:complete) == false or @quests.quests[26].status?(:complete) == false
                  if k.id == 160
                    $game_party.storage_gain_item(k, -rand($game_party.storage_item_number(k)) - rand(5))
                  end
                end
                if @quests.quests[3].status?(:complete) == false
                  if k.id == 155
                    $game_party.storage_gain_item(k, -rand($game_party.storage_item_number(k)) - rand(5))
                  end
                end
                if @quests.quests[1].status?(:complete) == false or @quests.quests[26].status?(:complete) == false or @quests.quests[28].status?(:complete) == false
                  if k.id == 159
                    $game_party.storage_gain_item(k, -rand($game_party.storage_item_number(k)) - rand(5))
                  end
                end
                $game_party.storage_gain_item(k, 1) if 1 > $game_party.storage_item_number(k)
              end
            end
          end
          $game_switches[289] = false
        elsif @category == "포션"
          #print("190.Window_StorageItemList_2 - 카테고리, %s \n" % [@category]);
          @data1 = $game_party.storage_all_items.select {|item| include?(item)}
          #print("포션 - %s \n" % [@data1]);
          #@data1 = $game_party.storage_all_items
          for k in @data1
            if !k.is_a?(RPG::Armor) and !k.is_a?(RPG::Weapon) and $game_switches[288] == true
              # 여관방 열쇠는 충전을 제외한다.
              if 370 > k.id and k.id > 404
              else
                $game_party.storage_gain_item(k, rand(10))
                $game_party.storage_gain_item(k, 1) if 1 > $game_party.storage_item_number(k)
              end
            end
          end
          $game_switches[288] = false
        end
      end
      @data = []
      @data = $game_party.storage_all_items.select {|item| include?(item)}
      @data.push(nil) if include?(nil)
    end
  end
  
  def draw_item_number(rect, item)
    case @storage
    when :store
      if item.is_a?(RPG::Weapon) or item.is_a?(RPG::Armor)
        if item.durability != nil
          @text = sprintf("×%2d", $game_party.item_number(item))
          draw_text(rect, @text, 2)
        else
          @text = sprintf("×%2d", "0")
          draw_text(rect, @text, 2)
        end
      else
        @text = sprintf("×%2d", $game_party.item_number(item))
        draw_text(rect, @text, 2)
      end
      # 판매 가격
      #n = item.price * (100 + $game_variables[TMPRICE::VN_SELLING_RATE] + $game_variables[171] + $game_variables[295]) / (500 - $game_variables[163])
      n = (item.price * ($game_variables[161] * 0.01).to_f).to_i
      draw_currency_value(n, "", rect.x, rect.y, rect.width - text_size(@text).width - 10, 4)
    when :withdraw
      if item.is_a?(RPG::Weapon) || item.is_a?(RPG::Armor)
        if item.durability != nil
          @text = sprintf("×%2d", $game_party.storage_item_number(item))
        else
          @text = sprintf("×%2d", $game_party.storage_item_number(item) - 1)
        end
      else
        @text = sprintf("×%2d", $game_party.storage_item_number(item) - 1)
      end
      draw_text(rect, @text, 2)
      # 구매 가격
      #n = item.price * (100 + $game_variables[TMPRICE::VN_BUYING_RATE] + $game_variables[170] - $game_variables[295]) / (500 - $game_variables[163])
      n = (item.price * ($game_variables[163] * 0.01).to_f).to_i
      draw_currency_value(n, "", rect.x, rect.y, rect.width - text_size(@text).width - 10, 4)
    end
  end
end