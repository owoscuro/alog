# encoding: utf-8
# Name: 117_2. Map Movement During Prostitution
# Size: 19754
class Game_Map
  #-----------------------------------------------------------------------------
  # 지역 공헌도 위치
  #-----------------------------------------------------------------------------
  def rose_Factions
    #print("118.Game_Map - rose_Factions \n");
    $game_variables[157] = 0
    for i in 1...15
      # 아일로
      if i >= (17-$game_variables[370]).abs + (17-$game_variables[371]).abs
      $game_variables[157] = 1; return; end;
      # 팔세린
      if i >= (22-$game_variables[370]).abs + (12-$game_variables[371]).abs
      $game_variables[157] = 2; return; end;
      # 세라트
      if i >= (28-$game_variables[370]).abs + (25-$game_variables[371]).abs
      $game_variables[157] = 3; return; end;
      # 파르아델 거점
      if i >= (38-$game_variables[370]).abs + (51-$game_variables[371]).abs
      $game_variables[157] = 4; return; end;
      # 크로츠발트
      if i >= (11-$game_variables[370]).abs + (7-$game_variables[371]).abs
      $game_variables[157] = 5; return; end;
      # 슬라인
      if i >= (43-$game_variables[370]).abs + (29-$game_variables[371]).abs
      $game_variables[157] = 6; return; end;
      # 다윈
      if i >= (42-$game_variables[370]).abs + (19-$game_variables[371]).abs
      $game_variables[157] = 7; return; end;
      # 바일라스
      if i >= (36-$game_variables[370]).abs + (40-$game_variables[371]).abs
      $game_variables[157] = 8; return; end;
      # 세라이튼
      if i >= (10-$game_variables[370]).abs + (14-$game_variables[371]).abs
      $game_variables[157] = 9; return; end;
      # 호리펠
      if i >= (24-$game_variables[370]).abs + (92-$game_variables[371]).abs
      $game_variables[157] = 10; return; end;
      # 드로와인
      if i >= (69-$game_variables[370]).abs + (93-$game_variables[371]).abs
      $game_variables[157] = 11; return; end;
      # 하살라의 숲
      if i >= (101-$game_variables[370]).abs + (114-$game_variables[371]).abs
      $game_variables[157] = 12; return; end;
    end
  end
  
  #--------------------------------------------------------------------------
  # 매춘시 여관 열쇠, 빈방 확인
  #--------------------------------------------------------------------------
  def storage_add_item(name, type, id, amount)
    $game_party.storage_name = name
    case type
    when :item, "포션", "음식", "기타"
      item = $data_items[id]
    when :weapon
      item = $data_weapons[id]
    when :armor
      item = $data_armors[id]
    end
    $game_party.storage_gain_item(item, amount)
  end
  def storage_remove_item(name, type, id, amount)
    $game_party.storage_name = name
    case type
    when :item, "포션", "음식", "기타"
      item = $data_items[id]
    when :weapon
      item = $data_weapons[id]
    when :armor
      item = $data_armors[id]
    end
    $game_party.storage_lose_item(item, amount)
  end
  
  #-----------------------------------------------------------------------------
  # 매춘시 여관으로 이동, 워프
  #-----------------------------------------------------------------------------
  def rose_rand_wape
    rand_wape = []
    
    $game_map.screen.pictures[21].erase if !$game_map.screen.pictures[21].nil?
    $game_map.screen.pictures[22].erase if !$game_map.screen.pictures[22].nil?
    
    # 지역을 확인한다.
    rose_Factions
    $game_variables[181] = 0
    
    # 이름없는 길 - 상인
    if $game_map.map_id == 339
      rand_wape = [7, 10, 0, 339],[16, 7, 0, 339],[20, 13, 0, 339],
                  [15, 4, 0, 339]
      rand_wape.shuffle
      $game_variables[181] = rand_wape[0][3]
      $game_variables[182] = rand_wape[0][0]
      $game_variables[183] = rand_wape[0][1]
      rose_sex_room(rand_wape[0][2])
    # 파르아델 거점
    elsif $game_map.map_id == 382
      rand_wape = [14, 23, 0, 382],[17, 22, 0, 382]
      rand_wape.shuffle
      $game_variables[181] = rand_wape[0][3]
      $game_variables[182] = rand_wape[0][0]
      $game_variables[183] = rand_wape[0][1]
      rose_sex_room(rand_wape[0][2])
    # 다윈
    elsif $game_map.map_id == 335
      rand_wape = [6, 15, 0, 335],[13, 21, 0, 335],[10, 28, 0, 335],
                  [29, 28, 0, 335],[38, 27, 0, 335],[43, 15, 0, 335]
      rand_wape.shuffle
      $game_variables[181] = rand_wape[0][3]
      $game_variables[182] = rand_wape[0][0]
      $game_variables[183] = rand_wape[0][1]
      rose_sex_room(rand_wape[0][2])
    # 헤르슨 남문
    elsif $game_map.map_id == 179
      rand_wape = [5, 19, 0, 179],[2, 8, 0, 179],[37, 7, 0, 179],
                  [40, 16, 0, 179],[39, 26, 0, 179],[14, 25, 0, 179]
      rand_wape.shuffle
      $game_variables[181] = rand_wape[0][3]
      $game_variables[182] = rand_wape[0][0]
      $game_variables[183] = rand_wape[0][1]
      rose_sex_room(rand_wape[0][2])
    # 휴식의 숲
    elsif $game_map.map_id == 117 or $game_map.map_id == 118
      storage_add_item("라븐_1", :item, 404, 10)
      $game_self_switches[[118, 19, "A"]] = false
      rand_wape = [24, 14, 404, 118],[26, 14, 404, 118],[28, 14, 404, 118],
                  [34, 9, 0, 117],[37, 14, 0, 117],[5, 17, 0, 117],
                  [22, 6, 0, 117]
      if $game_variables[165] == 3 or $game_variables[165] == 4 or $game_variables[165] == 6
        storage_remove_item("라븐_1", :item, 404, 100)
        storage_add_item("라븐_1", :item, 404, 1)
        $game_self_switches[[118, 19, "A"]] = true
        rand_wape.delete_at(0)
        rand_wape.delete_at(1)
        rand_wape.delete_at(2)
      end
      rand_wape.shuffle
      $game_variables[181] = rand_wape[0][3]
      $game_variables[182] = rand_wape[0][0]
      $game_variables[183] = rand_wape[0][1]
      rose_sex_room(rand_wape[0][2])
      if rand_wape[0][2] != 0
        $game_party.gain_item($data_items[rand_wape[0][2]], 1) if rand_wape[0][2] != 0
        storage_remove_item("라븐_1", :item, rand_wape[0][2], 100)
        storage_add_item("라븐_1", :item, rand_wape[0][2], 1)
      end
    # 아일로
    elsif $game_variables[157] == 1
      storage_add_item("헤간리비_1", :item, 376, 10)
      storage_add_item("헤간리비_1", :item, 377, 10)
      $game_self_switches[[22, 24, "A"]] = false
      $game_self_switches[[22, 25, "A"]] = false
      rand_wape = [9, 18, 376, 22],[8, 10, 377, 22],[10, 10, 377, 22],
                  [2, 28, 0, 312],[29, 33, 0, 312],[9, 4, 0, 312],
                  [2, 10, 0, 312]
      if $game_variables[165] == 1 or $game_variables[165] == 5 or $game_variables[165] == 8
        storage_remove_item("헤간리비_1", :item, 376, 100)
        storage_add_item("헤간리비_1", :item, 376, 1)
        $game_self_switches[[22, 24, "A"]] = true
        rand_wape.delete_at(0)
      elsif $game_variables[165] == 2 or $game_variables[165] == 4 or $game_variables[165] == 7
        storage_remove_item("헤간리비_1", :item, 377, 100)
        storage_add_item("헤간리비_1", :item, 377, 1)
        $game_self_switches[[22, 25, "A"]] = true
        rand_wape.delete_at(1)
        rand_wape.delete_at(2)
      end
      rand_wape.shuffle
      $game_variables[181] = rand_wape[0][3]
      $game_variables[182] = rand_wape[0][0]
      $game_variables[183] = rand_wape[0][1]
      rose_sex_room(rand_wape[0][2])
      if rand_wape[0][2] != 0
        storage_remove_item("헤간리비_1", :item, rand_wape[0][2], 100)
        storage_add_item("헤간리비_1", :item, rand_wape[0][2], 1)
        $game_party.gain_item($data_items[rand_wape[0][2]], 1) if rand_wape[0][2] != 0
      end
    # 팔세린
    elsif $game_variables[157] == 2
      storage_add_item("아텔레이네_1", :item, 379, 10)
      storage_add_item("아텔레이네_1", :item, 380, 10)
      storage_add_item("아텔레이네_1", :item, 381, 10)
      storage_add_item("아텔레이네_1", :item, 382, 10)
      storage_add_item("아텔레이네_1", :item, 383, 10)
      storage_add_item("아텔레이네_1", :item, 384, 10)
      storage_add_item("아텔레이네_1", :item, 385, 10)
      storage_add_item("아텔레이네_1", :item, 386, 10)
      $game_self_switches[[24, 26, "A"]] = false
      $game_self_switches[[24, 27, "A"]] = false
      $game_self_switches[[24, 28, "A"]] = false
      $game_self_switches[[24, 29, "A"]] = false
      $game_self_switches[[25, 25, "A"]] = false
      $game_self_switches[[25, 26, "A"]] = false
      $game_self_switches[[25, 27, "A"]] = false
      $game_self_switches[[25, 28, "A"]] = false
      rand_wape = [5, 17, 379, 24],[5, 8, 380, 24],[29, 8, 381, 24],
                  [29, 17, 382, 24],
                  [81, 14, 0, 264],[80, 32, 0, 264],[70, 46, 0, 264],
                  [23, 50, 0, 264]
      if $game_variables[165] == 1 or $game_variables[165] == 5
        storage_remove_item("아텔레이네_1", :item, 379, 100)
        storage_add_item("아텔레이네_1", :item, 379, 1)
        $game_self_switches[[24, 26, "A"]] = true
        rand_wape.delete_at(0)
        storage_remove_item("아텔레이네_1", :item, 383, 100)
        storage_add_item("아텔레이네_1", :item, 383, 1)
        $game_self_switches[[25, 25, "A"]] = true
      elsif $game_variables[165] == 2 or $game_variables[165] == 6
        storage_remove_item("아텔레이네_1", :item, 380, 100)
        storage_add_item("아텔레이네_1", :item, 380, 1)
        $game_self_switches[[24, 27, "A"]] = true
        rand_wape.delete_at(1)
        storage_remove_item("아텔레이네_1", :item, 384, 100)
        storage_add_item("아텔레이네_1", :item, 384, 1)
        $game_self_switches[[25, 26, "A"]] = true
      elsif $game_variables[165] == 3 or $game_variables[165] == 7
        storage_remove_item("아텔레이네_1", :item, 381, 100)
        storage_add_item("아텔레이네_1", :item, 381, 1)
        $game_self_switches[[24, 28, "A"]] = true
        rand_wape.delete_at(2)
        storage_remove_item("아텔레이네_1", :item, 385, 100)
        storage_add_item("아텔레이네_1", :item, 385, 1)
        $game_self_switches[[25, 27, "A"]] = true
      elsif $game_variables[165] == 4 or $game_variables[165] == 8
        storage_remove_item("아텔레이네_1", :item, 382, 100)
        storage_add_item("아텔레이네_1", :item, 382, 1)
        $game_self_switches[[24, 29, "A"]] = true
        rand_wape.delete_at(3)
        storage_remove_item("아텔레이네_1", :item, 386, 100)
        storage_add_item("아텔레이네_1", :item, 386, 1)
        $game_self_switches[[25, 28, "A"]] = true
      end
      rand_wape.shuffle
      $game_variables[181] = rand_wape[0][3]
      $game_variables[182] = rand_wape[0][0]
      $game_variables[183] = rand_wape[0][1]
      rose_sex_room(rand_wape[0][2])
      if rand_wape[0][2] != 0
        $game_party.gain_item($data_items[rand_wape[0][2]], 1) if rand_wape[0][2] != 0
        storage_remove_item("아텔레이네_1", :item, rand_wape[0][2], 100)
        storage_add_item("아텔레이네_1", :item, rand_wape[0][2], 1)
      end
    # 크로츠발트
    elsif $game_variables[157] == 5
      storage_add_item("벤_1", :item, 388, 10)
      $game_self_switches[[63, 21, "A"]] = false
      rand_wape = [15, 7, 388, 63],[17, 7, 388, 63],[19, 7, 388, 63],
                  [8, 2, 0, 62],[10, 27, 0, 62],[27, 24, 0, 62],[40, 1, 0, 62]
      if $game_variables[165] == 3 or $game_variables[165] == 7 or $game_variables[165] == 9
        storage_remove_item("벤_1", :item, 388, 100)
        storage_add_item("벤_1", :item, 388, 1)
        $game_self_switches[[63, 21, "A"]] = true
        rand_wape.delete_at(0)
        rand_wape.delete_at(1)
        rand_wape.delete_at(2)
      end
      rand_wape.shuffle
      $game_variables[181] = rand_wape[0][3]
      $game_variables[182] = rand_wape[0][0]
      $game_variables[183] = rand_wape[0][1]
      rose_sex_room(rand_wape[0][2])
      if rand_wape[0][2] != 0
        $game_party.gain_item($data_items[rand_wape[0][2]], 1) if rand_wape[0][2] != 0
        storage_remove_item("벤_1", :item, rand_wape[0][2], 100)
        storage_add_item("벤_1", :item, rand_wape[0][2], 1)
      end
    # 슬라인
    elsif $game_variables[157] == 6
      storage_add_item("비샹트_1", :item, 390, 10)
      storage_add_item("비샹트_1", :item, 391, 10)
      storage_add_item("비샹트_1", :item, 392, 10)
      storage_add_item("비샹트_1", :item, 393, 10)
      storage_add_item("비샹트_1", :item, 394, 10)
      storage_add_item("비샹트_1", :item, 395, 10)
      storage_add_item("비샹트_1", :item, 396, 10)
      storage_add_item("비샹트_1", :item, 397, 10)
      $game_self_switches[[127, 26, "A"]] = false
      $game_self_switches[[127, 27, "A"]] = false
      $game_self_switches[[127, 28, "A"]] = false
      $game_self_switches[[127, 29, "A"]] = false
      $game_self_switches[[128, 25, "A"]] = false
      $game_self_switches[[128, 26, "A"]] = false
      $game_self_switches[[128, 27, "A"]] = false
      $game_self_switches[[128, 28, "A"]] = false
      rand_wape = [5, 17, 390, 127],[5, 8, 391, 127],[29, 8, 392, 127],
                  [29, 17, 393, 127],
                  [64, 54, 0, 68],[66, 32, 0, 68],[4, 18, 0, 68],
                  [21, 5, 0, 68],[11, 35, 0, 68],[68, 5, 0, 68]
      if $game_variables[165] == 1 or $game_variables[165] == 5
        storage_remove_item("비샹트_1", :item, 390, 100)
        storage_add_item("비샹트_1", :item, 390, 1)
        $game_self_switches[[127, 26, "A"]] = true
        rand_wape.delete_at(0)
        storage_remove_item("비샹트_1", :item, 394, 100)
        storage_add_item("비샹트_1", :item, 394, 1)
        $game_self_switches[[128, 25, "A"]] = true
      elsif $game_variables[165] == 2 or $game_variables[165] == 6
        storage_remove_item("비샹트_1", :item, 391, 100)
        storage_add_item("비샹트_1", :item, 391, 1)
        $game_self_switches[[127, 27, "A"]] = true
        rand_wape.delete_at(1)
        storage_remove_item("비샹트_1", :item, 395, 100)
        storage_add_item("비샹트_1", :item, 395, 1)
        $game_self_switches[[128, 26, "A"]] = true
      elsif $game_variables[165] == 3 or $game_variables[165] == 7
        storage_remove_item("비샹트_1", :item, 392, 100)
        storage_add_item("비샹트_1", :item, 392, 1)
        $game_self_switches[[127, 28, "A"]] = true
        rand_wape.delete_at(2)
        storage_remove_item("비샹트_1", :item, 396, 100)
        storage_add_item("비샹트_1", :item, 396, 1)
        $game_self_switches[[128, 27, "A"]] = true
      elsif $game_variables[165] == 4 or $game_variables[165] == 8
        storage_remove_item("비샹트_1", :item, 393, 100)
        storage_add_item("비샹트_1", :item, 393, 1)
        $game_self_switches[[127, 29, "A"]] = true
        rand_wape.delete_at(3)
        storage_remove_item("비샹트_1", :item, 397, 100)
        storage_add_item("비샹트_1", :item, 397, 1)
        $game_self_switches[[128, 28, "A"]] = true
      end
      rand_wape.shuffle
      $game_variables[181] = rand_wape[0][3]
      $game_variables[182] = rand_wape[0][0]
      $game_variables[183] = rand_wape[0][1]
      rose_sex_room(rand_wape[0][2])
      if rand_wape[0][2] != 0
        $game_party.gain_item($data_items[rand_wape[0][2]], 1) if rand_wape[0][2] != 0
        storage_remove_item("비샹트_1", :item, rand_wape[0][2], 100)
        storage_add_item("비샹트_1", :item, rand_wape[0][2], 1)
      end
    # 바일라스
    elsif $game_variables[157] == 8
      storage_add_item("벨란스_1", :item, 399, 10)
      storage_add_item("벨란스_1", :item, 400, 10)
      storage_add_item("벨란스_1", :item, 401, 10)
      storage_add_item("벨란스_1", :item, 402, 10)
      $game_self_switches[[79, 24, "A"]] = false
      $game_self_switches[[79, 25, "A"]] = false
      $game_self_switches[[79, 26, "A"]] = false
      $game_self_switches[[79, 27, "A"]] = false
      rand_wape = [7, 17, 399, 79],[7, 8, 400, 79],[27, 8, 401, 79],
                  [27, 17, 402, 79],
                  [15, 13, 0, 76],[73, 22, 0, 76],[73, 31, 0, 76],
                  [46, 34, 0, 76],[8, 28, 0, 76],[59, 34, 0, 76]
      if $game_variables[165] == 1 or $game_variables[165] == 5
        storage_remove_item("벨란스_1", :item, 399, 100)
        storage_add_item("벨란스_1", :item, 399, 1)
        $game_self_switches[[79, 24, "A"]] = true
        rand_wape.delete_at(0)
      elsif $game_variables[165] == 2 or $game_variables[165] == 6
        storage_remove_item("벨란스_1", :item, 400, 100)
        storage_add_item("벨란스_1", :item, 400, 1)
        $game_self_switches[[79, 25, "A"]] = true
        rand_wape.delete_at(1)
      elsif $game_variables[165] == 3 or $game_variables[165] == 7
        storage_remove_item("벨란스_1", :item, 401, 100)
        storage_add_item("벨란스_1", :item, 401, 1)
        $game_self_switches[[79, 26, "A"]] = true
        rand_wape.delete_at(2)
      elsif $game_variables[165] == 4 or $game_variables[165] == 8
        storage_remove_item("벨란스_1", :item, 402, 100)
        storage_add_item("벨란스_1", :item, 402, 1)
        $game_self_switches[[79, 27, "A"]] = true
        rand_wape.delete_at(3)
      end
      rand_wape.shuffle
      $game_variables[181] = rand_wape[0][3]
      $game_variables[182] = rand_wape[0][0]
      $game_variables[183] = rand_wape[0][1]
      rose_sex_room(rand_wape[0][2])
      if rand_wape[0][2] != 0
        $game_party.gain_item($data_items[rand_wape[0][2]], 1) if rand_wape[0][2] != 0
        storage_remove_item("벨란스_1", :item, rand_wape[0][2], 100)
        storage_add_item("벨란스_1", :item, rand_wape[0][2], 1)
      end
    # 세라이튼
    elsif $game_variables[157] == 9
      storage_add_item("여관_1", :item, 371, 10)
      storage_add_item("여관_1", :item, 372, 10)
      storage_add_item("여관_1", :item, 373, 10)
      storage_add_item("여관_1", :item, 374, 10)
      $game_self_switches[[277, 23, "A"]] = false
      $game_self_switches[[277, 24, "A"]] = false
      $game_self_switches[[277, 25, "A"]] = false
      $game_self_switches[[277, 26, "A"]] = false
      rand_wape = [7, 17, 371, 277],[7, 8, 372, 277],[27, 8, 373, 277],
                  [27, 17, 374, 277],
                  [41, 19, 0, 395],[5, 7, 0, 395],[19, 0, 0, 395]
      if $game_variables[165] == 1 or $game_variables[165] == 5
        storage_remove_item("여관_1", :item, 371, 100)
        storage_add_item("여관_1", :item, 371, 1)
        $game_self_switches[[277, 23, "A"]] = true
        rand_wape.delete_at(0)
      elsif $game_variables[165] == 2 or $game_variables[165] == 6
        storage_remove_item("여관_1", :item, 372, 100)
        storage_add_item("여관_1", :item, 372, 1)
        $game_self_switches[[277, 24, "A"]] = true
        rand_wape.delete_at(1)
      elsif $game_variables[165] == 3 or $game_variables[165] == 7
        storage_remove_item("여관_1", :item, 373, 100)
        storage_add_item("여관_1", :item, 373, 1)
        $game_self_switches[[277, 25, "A"]] = true
        rand_wape.delete_at(2)
      elsif $game_variables[165] == 4 or $game_variables[165] == 8
        storage_remove_item("여관_1", :item, 374, 100)
        storage_add_item("여관_1", :item, 374, 1)
        $game_self_switches[[277, 26, "A"]] = true
        rand_wape.delete_at(3)
      end
      rand_wape.shuffle
      $game_variables[181] = rand_wape[0][3]
      $game_variables[182] = rand_wape[0][0]
      $game_variables[183] = rand_wape[0][1]
      rose_sex_room(rand_wape[0][2])
      if rand_wape[0][2] != 0
        $game_party.gain_item($data_items[rand_wape[0][2]], 1) if rand_wape[0][2] != 0
        storage_remove_item("여관_1", :item, rand_wape[0][2], 100)
        storage_add_item("여관_1", :item, rand_wape[0][2], 1)
      end
    end
  end
end