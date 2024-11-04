# encoding: utf-8
# Name: 260.module HM_SEL 2
# Size: 41562
# encoding: utf-8
# Name: 260.module HM_SEL 2
# Size: 41501
$sel_time_frame = 0     # 프레임 조작 변수
$sel_time_frame_10 = 0  # 프레임 조작 변수
$sel_time_frame_30 = 0  # 프레임 조작 변수

$picture_12_op = 0      # 구름 이미지 투명도
$picture_49_op = 0      # 위험시 붉은색 테두리 투명도
$picture_140_op = 0
$picture_123_op = 0

module HM_SEL
  def self.prog_minute # 분의 끝
    $game_variables[MIN] += MINUTE_CYCLE
    
    # 각 마을의 구매, 판매 비율이 없으면 적용
    if $game_variables[158] == 0 or $game_variables[158] == nil
      village_tax = []
      a = SZS_Factions::Factions.size
      a += 5
      a.times.each {village_tax.push([rand(200)+10, rand(200)+10])}
      village_tax.shuffle
      $game_variables[158] = village_tax
    end
    # --------------------------------------------------------------------------
    # 아래는 시간 가속중이 아닌 경우에만 적용
    # --------------------------------------------------------------------------
    if $game_switches[283] == false
      # 임신 여부
      if $game_party.item_number($data_items[68]) == 0 and $game_actors[7].state?(160) == false
        # 임신 기간 0 로 갱신
        $game_variables[167] = 0
        # 달거리 기간 확인
        if $game_variables[DAYB] >= $game_variables[173] and $game_variables[174] >= $game_variables[DAYB]
          # 달거리 하는 중
          $game_variables[175] = 1
          $game_actors[7].add_state(137)
        elsif $game_actors[7].state?(137) == true
          # 달거리 안하는 중
          $game_variables[175] = 0
          $game_actors[7].remove_state(137)
        end
      else
        # 임신중 혹은 피임약 먹은 상태면 달거리 취소
        $game_variables[175] = 0
        $game_actors[7].remove_state(137) if $game_actors[7].state?(137) == true
      end
      # 모유 0 이 아니라면 모유 1 추가
      if $game_variables[327] != 0
        $game_variables[327] += 1 if $game_variables[328] >= $game_variables[327]
        $game_actors[7].learn_skill(203) if !$game_actors[7].skill_learn?(203)
      end
      # 몬스터들 강제 어그로 시간
      $game_variables[367] -= 1 if $game_variables[367] >= 1
      # 촉수 의상을 입은 경우 모유 강제 생산
      $game_variables[327] += 1 if $game_variables[114] == "I"
      # 흥분도 1씩 감소
      if $game_variables[68] > 100 and 500 > $game_variables[68]
        $game_variables[68] += 1
      end
      # 해당 맵 유지 시간
      $game_variables[32] += 1
      # 삶의 저울 시간 추가
      $game_variables[162] += rand(5)
      # 눈 깜박임 수치 더하기
      if $game_switches[55] == false and 50 > $game_variables[268]
        $game_variables[268] += rand(20)
        $game_switches[55] = true if $game_variables[268] > 50
      end
      # 출산 시기 놓친 경우 강제 진행
      if rand(10) >= 4 and $game_variables[167] >= 10
        $game_temp.reserve_common_event(237)
      end
      
      # 마지막 검문 경비병 위치 리셋
      if $game_variables[47] != $game_map.map_id and $game_variables[49] >= 1
        $game_variables[49] -= 1
      elsif $game_variables[47] == $game_map.map_id and $game_variables[49] != 1440
        $game_variables[49] = 1440
      elsif $game_variables[49] == 0 and $game_variables[47] != 0
        $game_variables[47] = 0
      end
      # 달거리 지정 실험
      if $game_variables[DAYB] > $game_variables[174] or $game_variables[174] == 0
        # 달거리 시작일 지정
        $game_variables[173] = $game_variables[DAYB] + rand(3) + 2
        # 달거리 종료일 지정
        $game_variables[174] = $game_variables[173] + rand(1) + 2
      end
      # 지금 시간과 다른 경우 바로 갱신 실험
      if @ro_hour != $game_variables[HOUR]
        # 동료 고용한 상태 확인
        if $game_party.members.size >= 2
          (1...$data_actors.size).each do |actor_id|
            if $game_actors[actor_id].nickname != "아들" and $game_actors[actor_id].nickname != "딸"
              if $game_actors[actor_id].name != "" and $game_actors[actor_id].name != nil
                if actor_id != 7 and $game_actors[actor_id].set_custom_bio[24].to_i == 1
                  if 0 >= $game_actors[actor_id].set_custom_bio[22].to_i
                    $game_variables[126] = actor_id
                    $game_variables[160] = actor_id
                    $game_temp.reserve_common_event(262)
                  end
                end
              end
            end
          end
        end
        # 시간이 지날때 에르니 레벨 확인
        if $game_actors[7].level >= 200 and $game_switches[133] == false
          $game_switches[133] = true
          $game_actors[7].skill_point += 20
          $game_party.gain_medal(18)
        end
        # 낮 근무자들 스위치 07시 ~ 18시
        hour_range(7, 19) ? $game_switches[87] = true : $game_switches[87] = false
        # 낮 근무자들 스위치 10시 ~ 20시
        hour_range(10, 21) ? $game_switches[88] = true : $game_switches[88] = false
        # 새벽 근무자들 스위치 21시 ~ 05시
        hour_range(0, 5) or hour_range(21, 24) ? $game_switches[89] = true : $game_switches[89] = false
        # 날씨 아이콘 변경 실험
        case $game_variables[HOUR]
          when 0;  $game_variables[20] = 3;   $picture_12_op = 0
          when 1;  $game_variables[20] = 7;   $picture_12_op = 0
          when 2;  $game_variables[20] = 7;   $picture_12_op = 0
          when 3;  $game_variables[20] = 15;  $picture_12_op = 0
          when 4;  $game_variables[20] = 15;  $picture_12_op = 0
          when 5;  $game_variables[20] = 12;  $picture_12_op = 10
          when 6;  $game_variables[20] = 8;   $picture_12_op = 10
          when 7;  $game_variables[20] = 4;   $picture_12_op = 30
          when 8;  $game_variables[20] = 0;   $picture_12_op = 30
          when 9;  $game_variables[20] = 5;   $picture_12_op = 80
          when 10; $game_variables[20] = 1;   $picture_12_op = 80
          when 11; $game_variables[20] = 1;   $picture_12_op = 140
          when 12; $game_variables[20] = 1;   $picture_12_op = 140
          when 13; $game_variables[20] = 5;   $picture_12_op = 230
          when 14; $game_variables[20] = 5;   $picture_12_op = 230
          when 15; $game_variables[20] = 9;   $picture_12_op = 170
          when 16; $game_variables[20] = 9;   $picture_12_op = 170
          when 17; $game_variables[20] = 2;   $picture_12_op = 140
          when 18; $game_variables[20] = 2;   $picture_12_op = 140
          when 19; $game_variables[20] = 2;   $picture_12_op = 120
          when 20; $game_variables[20] = 6;   $picture_12_op = 120
          when 21; $game_variables[20] = 10;  $picture_12_op = 10
          when 22; $game_variables[20] = 14;  $picture_12_op = 10
          when 23; $game_variables[20] = 11;  $picture_12_op = 5
          when 24; $game_variables[20] = 3;   $picture_12_op = 5
        end
        # 비오는 날씨
        if $game_variables[12] != 0
          $picture_12_op = 0
        end
        # 지금 시간 갱신
        @ro_hour = $game_variables[HOUR]
        show_tint
      end
    end
    # --------------------------------------------------------------------------
    # 위는 시간 가속중이 아닌 경우에만 적용
    # --------------------------------------------------------------------------
    if $game_variables[MIN] >= 60
      prog_hour # 시간의 끝을 실행한다.
    end
    # 공통 이벤트 해시 확인
    #call_common_event
  end
  
  def self.event_window_make_item_text(item, value)
    return unless SceneManager.scene_is?(Scene_Map)
    return if Switch.hide_event_window
    if value > 0
      text = YEA::EVENT_WINDOW::FOUND_TEXT
    else; return
    end
    text += sprintf("\ei[%d] %s", item.icon_index, item.name)
    if value.abs > 1
      fmt = YEA::EVENT_WINDOW::AMOUNT_TEXT
      text += sprintf(fmt, value.abs.group)
    end
    event_window_add_text(text)
  end
  
  def self.event_window_add_text(text)
    return unless SceneManager.scene_is?(Scene_Map)
    return if Switch.hide_event_window
    text = YEA::EVENT_WINDOW::HEADER_TEXT + text
    text += YEA::EVENT_WINDOW::CLOSER_TEXT
    SceneManager.scene.event_window_add_text(text)
  end
  
  def self.prog_hour # 시간의 끝
    # 시간 변수를 조절한다.
    $game_variables[MIN] = 0
    $game_variables[HOUR] += 1
    # --------------------------------------------------------------------------
    # 아래는 시간 가속중이 아닌 경우에만 적용
    # --------------------------------------------------------------------------
    if $game_switches[283] == false
      # 생존의 달인 스킬
      $game_switches[106] = true
      # 월드 상점 갱신 +1 추가
      $game_variables[76] += 1
      # 1시간에 1씩 더한다.
      $game_variables[166] += 1
      # 훔치기 변수 1씩 감소
      $game_variables[101] -= 1 if $game_variables[101] > 1
      # 자원 변수 추가
      $game_variables[133] += rand(4) # 물
      $game_variables[134] += rand(2) # 나무
      $game_variables[135] += rand(3) # 풀
      $game_variables[136] += rand(1) # 광석
      # 여관 방 여유 랜덤 적용
      if rand(10) >= 4
        $game_variables[165] = rand(10)
        # 출산 임박
        if $game_variables[167] >= 6
          $game_temp.reserve_common_event(237)
        end
      end
      # 흥분도 10씩 감소
      if $game_variables[68] > 100 and 500 > $game_variables[68]
        $game_variables[68] += 10 if $game_actors[7].skill_learn?($data_skills[79])
        $game_variables[68] += 10 if $game_actors[7].skill_learn?($data_skills[80])
        $game_variables[68] += 10 if $game_actors[7].skill_learn?($data_skills[81])
        $game_variables[68] += 10
      end
      # 절제 관련 변수 실험, 항상 배부르다.
      if 20 > $game_actors[7].hunger_rate
        # 모유 0 이 아니라면 모유 1 추가
        if $game_variables[327] != 0 and $game_variables[328] >= $game_variables[327]
          $game_variables[327] += ((100 - $game_actors[7].hunger_rate + 2) * 0.1).to_i # 모유 추가
        end
      end
      # 밤에 성욕 증가 수치 실험
      if $game_variables[HOUR] >= 0 and $game_variables[HOUR] > 5
        $game_variables[21] = 1
      else
        if $game_variables[HOUR] >= 21 and $game_variables[HOUR] > 23
          $game_variables[21] = 3
        else
          $game_variables[21] = 0
        end
      end
      # 의상이 촉수 의상인지 확인
      if $game_variables[114] != "I"
        # 임신 확률 조정
        @ro_157state = 0
        if $game_party.item_number($data_items[67]) >= 1
          # 배란일
          @ro_157state += 60 if $game_variables[8] >= $game_variables[173] - 3 and $game_variables[173] - 1 > $game_variables[8]
          @ro_157state -= 30 if $game_actors[7].state?(137) == false  # 달거리
          # 정액 보유량
          @ro_157state += $game_party.item_number($data_items[67])
          @ro_157state += 40 if $game_actors[7].state?(157) == true   # 배란 유도제
          @ro_157state += 20 if $game_actors[7].state?(166) == true   # 철웅성
          # 마력 체온, 마력 활성화
          @ro_157state += 10 if $game_actors[7].state?(168) == true
          @ro_157state += 10 if $game_actors[7].state?(174) == true
          # 죽음의 한기 속성 저항 마법 상태이상
          @ro_157state -= 20 if $game_actors[7].state?(170) == true   # 얼음 핏줄
          @ro_157state -= 20 if $game_actors[7].state?(171) == true   # 불꽃 심장
          @ro_157state -= 20 if $game_actors[7].state?(172) == true   # 전류 신경
          @ro_157state -= 20 if $game_actors[7].state?(173) == true   # 죽음의 한기
          # 피임약 상태이상
          @ro_157state -= 90 if $game_actors[7].state?(160) == true   # 피임약
          @ro_157state = 100 if @ro_157state > 100
        end
        # 확률이 0% 보다 작거나 이미 임신했다면 확률을 0% 로 변경
        @ro_157state = 0 if 0 > @ro_157state or $game_party.item_number($data_items[68]) != 0
        # 달거리 및 임신 조건 확인
        if $game_party.item_number($data_items[67]) >= 1 and @ro_157state >= (rand(100) + 1)
          # 임신 시작
          $game_variables[167] = 1
          # 임신중이면 모유 1 추가
          $game_variables[328] = 20 if 20 > $game_variables[328]  # 최대 모유 보유량
          $game_variables[327] += ((100 - $game_actors[7].hunger_rate + 1) * 0.1).to_i # 모유 추가
          $game_party.gain_item($data_items[68], 1)               # 임신
          event_window_make_item_text($data_items[68], 1)
          $game_party.lose_item($data_items[67], rand(2) + 1)     # 정액 제거
          $game_party.lose_item($data_items[69], rand(1) + 1)     # 죽은 태아 제거
          # 임신 카운터 +1
          $game_actors[7].set_custom_bio[7] = $game_actors[7].set_custom_bio[7].to_i + 1
          # 배란유도제 상태이상 제거
          $game_actors[7].remove_state(157)
        elsif $game_actors[7].set_custom_bio[3] != "비처녀" and $game_party.item_number($data_items[68]) >= 1
          # 처녀가 임신한 경우 제거
          $game_party.lose_item($data_items[67], rand(2) + 1)   # 정액 제거
          $game_party.lose_item($data_items[68], rand(2) + 1)   # 태아 제거
          $game_party.lose_item($data_items[69], rand(1) + 1)   # 죽은 태아 제거
        else
          # 임신 안됨
          $game_party.lose_item($data_items[67], rand(2) + 1)   # 정액 제거
          $game_party.lose_item($data_items[69], rand(1) + 1)   # 죽은 태아 제거
        end
      else
        # 촉수 의상
        $game_party.lose_item($data_items[67], rand(5) + 2)   # 정액 제거
        $game_party.lose_item($data_items[68], rand(5) + 2)   # 태아 제거
        $game_party.lose_item($data_items[69], rand(3) + 1)   # 죽은 태아 제거
      end
      # 날씨 변경 적용
      weather_manager
    end
    # --------------------------------------------------------------------------
    # 위는 시간 가속중이 아닌 경우에만 적용
    # --------------------------------------------------------------------------
    # 동료 고용 시간 감소
    if $game_party.members.size >= 2
      (1...$data_actors.size).each do |actor_id|
        if $game_actors[actor_id].name != "" and $game_actors[actor_id].name != nil
          # 기존 세이브 오류 방지
          $game_actors[actor_id].set_custom_bio[27] = 0 if $game_actors[actor_id].set_custom_bio[27] == "" or $game_actors[actor_id].set_custom_bio[27] == nil
          $game_actors[actor_id].set_custom_bio[28] = 0 if $game_actors[actor_id].set_custom_bio[28] == "" or $game_actors[actor_id].set_custom_bio[28] == nil
          if actor_id != 7 and $game_actors[actor_id].nickname != "아들" and $game_actors[actor_id].nickname != "딸"
            # 고용중인 캐릭터만 적용한다.
            if $game_actors[actor_id].set_custom_bio[24] == 1
              # 고용 일자 감소
              if $game_actors[actor_id].set_custom_bio[22] >= 1
                $game_actors[actor_id].set_custom_bio[22] -= 1
              end
              if $game_party.members.include?($game_actors[actor_id])
                # 절제 관련 변수 실험, 항상 배부르다.
                if 20 > $game_actors[actor_id].hunger_rate
                  if 10 > $game_actors[actor_id].set_custom_bio[27].to_i
                    $game_actors[actor_id].set_custom_bio[27] = $game_actors[actor_id].set_custom_bio[27].to_i + 1
                  end
                  if $game_actors[actor_id].set_custom_bio[28].to_i > 0
                    $game_actors[actor_id].set_custom_bio[28] = $game_actors[actor_id].set_custom_bio[28].to_i - 1
                  end
                # 식탐 관련 변수 실험, 항상 배고프다.
                elsif $game_actors[actor_id].hunger_rate > 80
                  if $game_actors[actor_id].set_custom_bio[27].to_i > 0
                    $game_actors[actor_id].set_custom_bio[27] = $game_actors[actor_id].set_custom_bio[27].to_i - 1
                  end
                  if 10 > $game_actors[actor_id].set_custom_bio[28].to_i
                    $game_actors[actor_id].set_custom_bio[28] = $game_actors[actor_id].set_custom_bio[28].to_i + 1
                  end
                end
              end
            end
          elsif actor_id == 7 or $game_actors[actor_id].nickname == "아들" or $game_actors[actor_id].nickname == "딸"
            if $game_party.members.include?($game_actors[actor_id])
              # 절제 관련 변수 실험, 항상 배부르다.
              if 20 > $game_actors[actor_id].hunger_rate
                if 10 > $game_actors[actor_id].set_custom_bio[27].to_i
                  $game_actors[actor_id].set_custom_bio[27] = $game_actors[actor_id].set_custom_bio[27].to_i + 1
                end
                if $game_actors[actor_id].set_custom_bio[28].to_i > 0
                  $game_actors[actor_id].set_custom_bio[28] = $game_actors[actor_id].set_custom_bio[28].to_i - 1
                end
              # 식탐 관련 변수 실험, 항상 배고프다.
              elsif $game_actors[actor_id].hunger_rate > 80
                if $game_actors[actor_id].set_custom_bio[27].to_i > 0
                  $game_actors[actor_id].set_custom_bio[27] = $game_actors[actor_id].set_custom_bio[27].to_i - 1
                end
                if 10 > $game_actors[actor_id].set_custom_bio[28].to_i
                  $game_actors[actor_id].set_custom_bio[28] = $game_actors[actor_id].set_custom_bio[28].to_i + 1
                end
              end
              if actor_id != 7
              # 아들, 딸 양육비 관련
                if $game_actors[actor_id].set_custom_bio[7].to_i >= 1
                  $game_actors[actor_id].set_custom_bio[7] = $game_actors[actor_id].set_custom_bio[7].to_i - 1
                end
              end
            end
          end
          if $game_party.members.include?($game_actors[actor_id])
            # 식탐 스킬, 허기 수치 50% 감소
            if $game_actors[actor_id].set_custom_bio[27].to_i >= 5
              $game_actors[actor_id].learn_skill(332)
              $game_party.gain_medal(7)
            elsif $game_actors[actor_id].skill_learn?($data_skills[332])
              $game_actors[actor_id].forget_skill(332)
            end
            # 절제 스킬, 허기 수치 50% 증가
            if $game_actors[actor_id].set_custom_bio[28].to_i >= 5
              $game_actors[actor_id].learn_skill(331)
              $game_party.gain_medal(22)
            elsif $game_actors[actor_id].skill_learn?($data_skills[331])
              $game_actors[actor_id].forget_skill(331)
            end
          end
        end
      end
    end
    # 6시에 각 마을의 구매, 판매 비율 변경
    if $game_variables[HOUR] == 6
      village_tax = []
      a = SZS_Factions::Factions.size
      a += 5
      a.times.each {village_tax.push([rand(200)+10, rand(200)+10])}
      village_tax.shuffle
      $game_variables[158] = village_tax
      
      print("260.module HM_SEL 2 - 의뢰 확인 %s \n" % [!$game_party.quests.revealed?(18)]);
      
      # 반복 의뢰 리셋
      $game_temp.reserve_common_event(57)
      
      # 지역 몬스터 비율
      $game_variables[271] = rand(SZS_Factions::Factions.size)
    end
    if $game_variables[HOUR] >= 24 && $game_variables[MIN] >= 0
      prog_day  # 하루의 끝 진행
    end
  end
  
  def self.prog_day  # 하루의 끝
    # 플레이 일자 +1 실험
    $game_variables[98] = $game_variables[98] + 1
    $game_variables[HOUR] = 0
    $game_variables[DAYA] += 1
    $game_variables[DAYB] += 1
    $game_variables[DAYC] += 1
    # --------------------------------------------------------------------------
    # 아래는 시간 가속중이 아닌 경우에만 적용
    # --------------------------------------------------------------------------
    # 식당에서 주는 크림 수프
    $game_switches[103] = true
    # 엘 자이렌 교단에서의 후원금 10은화
    $game_switches[105] = true
    # 집 버프, 안정감 가능 여부
    $game_switches[116] = true
    # 임신중이면 임신 기간 1 추가
    if $game_party.item_number($data_items[68]) >= 1 and $game_variables[167] != 0
      $game_variables[167] += 1
      # 임신중이면 모유 1 추가
      $game_variables[327] += 3 if $game_variables[328] >= $game_variables[327]
    end
    # 플레이어 신앙심
    $game_variables[218] -= 1 if $game_variables[218] >= 1
    # 월드 난이도 +1 추가
    $game_variables[99] += 1 if 150 > $game_variables[99]
    $game_variables[99] = 150 if $game_variables[99] > 150
    # 계절 변수 적용
    case $game_variables[MONTH]
      when 1..3
        $game_variables[23] = 2
      when 4..5
        $game_variables[23] = 3
      when 6..9
        $game_variables[23] = 0
      when 10..11
        $game_variables[23] = 1
      when 12
        $game_variables[23] = 2
      else
        $game_variables[23] = 3
    end
    # --------------------------------------------------------------------------
    # 위는 시간 가속중이 아닌 경우에만 적용
    # --------------------------------------------------------------------------
    # 주말 넘길 경우 수치 조정 실험
    $game_variables[DAYA] -= 7 if $game_variables[DAYA] >= 8
    # --------------------------------------------------------------------------
    # 월말
    # --------------------------------------------------------------------------
    if $game_variables[DAYB] > DAYS_IN_MONTH[$game_variables[MONTH]]
      # 달거리 종료일이 말일 보다 수치가 크면, 말일 만큼 감소시킨다.
      if $game_variables[174] > DAYS_IN_MONTH[$game_variables[MONTH]]
        $game_variables[173] = 1
        $game_variables[174] -= DAYS_IN_MONTH[$game_variables[MONTH]]
        $game_variables[174] += 1
      end
      $game_variables[DAYB] = 1
      $game_variables[MONTH] += 1
    end
    # --------------------------------------------------------------------------
    # 연말
    # --------------------------------------------------------------------------
    if $game_variables[MONTH] > DAYS_IN_MONTH.size
      $game_variables[DAYC] = 1
      $game_variables[MONTH] = 1
      $game_variables[YEAR] += 1
      # 나이 증가
      $game_party.members.each do |actor|
        actor.set_age = actor.set_age.to_i + 1
      end
    end
  end
  
  def self.time_manager
    # 천둥, 번개 적용
    if $game_variables[12] == 3 and $game_switches[94] == true
      if @thunder_count == nil
        @thunder_count = 0
        @flash_count = 0
        min = 110
        range = 180 - min
        @next_thunder = rand(range) + min
        min = 110
        range = 180 - min
        @next_flash = rand(range) + min
      end
      @thunder_count += 1
      if @thunder_count >= @next_thunder
        @thunder_count = 0
        se = RPG::SE.new('Thunder9')
        se.volume = rand(60)
        se.play
        min = 110
        range = 180 - min
        @next_thunder = rand(range) + min
      end
      @flash_count += 1
      if @flash_count >= @next_flash
        @flash_count = 0
        color = Color.new(255,255,255,(rand*200).round)
        $game_map.screen.start_flash(color,(rand*30).round)
        min = 110
        range = 180 - min
        @next_flash = rand(range) + min
      end
    end
    if $game_variables[DAYA] == 0
      #print("260.module HM_SEL 2 - 초기 셋팅, %s \n" % [$game_variables[DAYA]]);
      init_var
    end
    unless time_stop?
      #if $sel_time_frame >= ($game_switches[50] == true ? 30 : FRAMES_TIL_UPDATE)
      if $game_switches[283] == true ? ($sel_time_frame_10 == 1 or $sel_time_frame_10 == 3 or $sel_time_frame_10 == 5 or $sel_time_frame_10 == 7 or $sel_time_frame_10 == 9) : ($sel_time_frame >= ($game_switches[50] == true ? 30 : FRAMES_TIL_UPDATE))
        prog_minute
        # ----------------------------------------------------------------------
        # 시간 가속중이 아닌 경우에만 적용
        # ----------------------------------------------------------------------
        if $game_switches[283] == false and 1 > $game_variables[15]
          #print("260.module HM_SEL 2 - 시간 가속중이 아닌 경우 - %s \n" % [$game_variables[15]]);
          # 체온 조절 부분 실험
          case $game_variables[23]
            when 0
              # 여름 - 24 더위 / 40 추위
              $game_variables[24] = 4
              # 낮
              $game_variables[24] += 2 if $game_switches[89] != true
              $game_variables[40] = 0
            when 1
              # 가을 - 24 더위 / 40 추위
              $game_variables[24] = 0
              $game_variables[40] = 3
              # 밤
              $game_variables[40] += 1 if $game_switches[89] == true
            when 2
              # 겨울 - 24 더위 / 40 추위
              $game_variables[24] = 0
              $game_variables[40] = 12
              # 밤
              $game_variables[40] += 8 if $game_switches[89] == true
            when 3
              # 봄 - 24 더위 / 40 추위
              $game_variables[24] = 1
              # 낮
              $game_variables[24] += 1 if $game_switches[89] != true
              $game_variables[40] = 3
          end
          # 0 보다 작으면 0 으로 지정
          $game_variables[24] = 0 if 0 > $game_variables[24]
          $game_variables[40] = 0 if 0 > $game_variables[40]

          $game_party.members.each do |actor|
            #print("260.module HM_SEL 2 - 체온 변경, %s \n" % [actor.name]);
            # 추가한 취기 오류 발생시 리셋
            actor.drunk = 0 if actor.drunk == nil
            if !actor.dead?
              @ro_te_temper = 0
              @ro_te_temper += $game_actors[actor.id].equipment_equip_temper # 방한력
              @ro_te_temper -= $game_variables[121] * 0.1                    # 노출도
              # 외부에서만 적용
              if $game_switches[94] == true
                @ro_te_temper += $game_variables[24]         # 더위
                @ro_te_temper -= $game_variables[40]         # 추위
                @ro_te_temper -= $game_variables[12]         # 날씨
              # 내부에서만 적용
              else
                @ro_te_temper += $game_variables[24] * 0.5   # 더위
                @ro_te_temper -= $game_variables[40] * 0.5   # 추위
                @ro_te_temper -= $game_variables[12] * 0.5   # 날씨
              end
              actor.temper += @ro_te_temper * 0.3
              # 젖음 상태
              if actor.state?(24) == true
                actor.temper -= $game_variables[12] * 0.2
                actor.drunk -= 0.1
              end
              # 평균 체온으로 체온 변화
              if actor.state?(123) == true  # 온기
                if 50 > actor.temper
                  actor.temper += (50 - actor.temper) * 0.7
                elsif actor.temper > 50
                  actor.temper -= (actor.temper - 50) * 0.2
                end
              else
                if 50 > actor.temper
                  actor.temper += (50 - actor.temper) * 0.3
                  actor.drunk -= 0.1
                elsif actor.temper > 50
                  actor.temper -= (actor.temper - 50) * 0.3
                end
              end
            end
          end
        end
        # ----------------------------------------------------------------------
        # 시간 가속중인 경우에만 적용
        # ----------------------------------------------------------------------
        if $game_switches[283] == true and $game_variables[15] >= 1
          # 출산중
          if 11 == $game_variables[16]
            $game_temp.reserve_common_event(238) if $game_variables[15] == 400
            $game_temp.reserve_common_event(238) if $game_variables[15] == 300
            $game_temp.reserve_common_event(238) if $game_variables[15] == 200
            $game_temp.reserve_common_event(238) if $game_variables[15] == 100
            $game_temp.reserve_common_event(238) if $game_variables[15] == 40
            $game_actors[7].hunger += 0.3; $game_actors[7].thirst += 0.4; $game_actors[7].hygiene += 0.1
            $game_actors[7].sexual -= 0.1; $game_actors[7].piety += 0.1
            $game_actors[7].sleep += 1.7;  $game_actors[7].drunk -= 1
            $game_actors[7].hp -= ($game_actors[7].mhp * 0.001)
            $game_actors[7].hp -= ($game_actors[7].mhp * 0.001) if rand(5) == 1
            $game_variables[15] -= 1
          # 착유중
          elsif 14 == $game_variables[16]
            # 착유 효과음
            $game_actors[7].drunk -= 0.2
            $game_actors[7].hunger += 0.5; $game_actors[7].thirst += 0.5
            $game_actors[7].sexual += 0.2; $game_actors[7].stress -= 2
            $game_temp.reserve_common_event(182)  # 효과음
            $game_variables[15] -= 1
          # 자위중
          elsif 7 == $game_variables[16]
            $game_actors[7].drunk -= 0.3
            $game_actors[7].hunger += 1; $game_actors[7].thirst += 2; $game_actors[7].hygiene += 0.1
            $game_actors[7].sexual -= $game_variables[277]*0.1; $game_actors[7].stress -= 1; $game_actors[7].piety -= 0.1
            $game_temp.reserve_common_event(204)  # 대사
            $game_variables[15] -= 1
          # 성매매중
          elsif 8 == $game_variables[16]
            $game_actors[7].drunk -= 1
            $game_actors[7].hunger += 1; $game_actors[7].thirst += 2; $game_actors[7].hygiene += 0.1; $game_actors[7].repute -= 0.1
            $game_actors[7].sexual -= $game_variables[277]*0.1; $game_actors[7].stress -= 1; $game_actors[7].piety -= 0.1
            $game_temp.reserve_common_event(205)  # 대사
            $game_variables[15] -= 1
          # 펠라중
          elsif 16 == $game_variables[16]
            $game_actors[7].drunk -= 1
            $game_actors[7].hunger += 1; $game_actors[7].thirst += 2; $game_actors[7].hygiene += 0.1; $game_actors[7].repute -= 0.1
            $game_actors[7].sexual -= $game_variables[277]*0.1; $game_actors[7].stress -= 1; $game_actors[7].piety -= 0.1
            $game_temp.reserve_common_event(203)  # 대사
            $game_variables[15] -= 1
          # 인간형 몹에게 강간
          elsif 12 == $game_variables[16]
            $game_actors[7].drunk -= 1
            $game_actors[7].hunger += 1; $game_actors[7].thirst += 2; $game_actors[7].hygiene += 0.1; $game_actors[7].repute -= 0.1
            $game_actors[7].sexual -= $game_variables[277]*0.1; $game_actors[7].stress += 0.5; $game_actors[7].piety -= 0.1
            $game_temp.reserve_common_event(207)  # 대사
            $game_variables[15] -= 1
          # 동료랑 섹스중
          elsif 15 == $game_variables[16]
            $game_actors[7].drunk -= 1
            $game_actors[7].hunger += 1; $game_actors[7].thirst += 2
            $game_actors[7].hygiene += 0.1
            $game_actors[7].sexual -= $game_variables[277]*0.1
            $game_actors[7].stress -= 0.2; $game_actors[7].piety -= 0.1
            
            $game_actors[$game_variables[159]].drunk -= 1
            $game_actors[$game_variables[159]].hunger += 2; $game_actors[$game_variables[159]].thirst += 3
            $game_actors[$game_variables[159]].hygiene += 0.1
            $game_actors[$game_variables[159]].sexual -= $game_variables[277]*0.1
            $game_actors[$game_variables[159]].stress -= 0.3; $game_actors[$game_variables[159]].piety -= 0.1
            
            # 동료랑 친밀도 상승
            $game_actors[$game_variables[159]].set_custom_bio[21] = $game_actors[$game_variables[159]].set_custom_bio[21].to_i
            $game_actors[$game_variables[159]].set_custom_bio[21] = $game_actors[$game_variables[159]].set_custom_bio[21].to_i + 10
            $game_temp.reserve_common_event(208)  # 대사
            $game_variables[15] -= 1
          # 여관 성폭행중
          elsif 10 == $game_variables[16]
            if rand(10) >= 7
              $game_actors[7].repute -= 0.1
            else
              $game_actors[7].repute += 0.1
            end
            $game_actors[7].drunk -= 1
            $game_actors[7].hunger += 1; $game_actors[7].thirst += 2; $game_actors[7].hygiene += 0.1
            $game_actors[7].sexual -= $game_variables[277]*0.1; $game_actors[7].stress -= 1; $game_actors[7].piety -= 0.1
            $game_temp.reserve_common_event(206)  # 대사
            $game_variables[15] -= 1
          # --------------------------------------------------------------------
          # 시간 가속 스킵인 경우
          # --------------------------------------------------------------------
          else
            #print("260.module HM_SEL 2 - 시간 가속 스킵인 경우, %s \n" % [$game_variables[15]]);
            a15 = 0
            a15 = $game_variables[15]
            i = 0
            10.times.each {
              if a15 >= 1
                prog_minute
                a15 -= 1
                i += 1
              else
                break
              end
            }
            $game_variables[15] -= i
            $game_party.members.each do |actor|
              # 노숙
              if $game_variables[16] == 1
                actor.hunger += 0.3 * i; actor.thirst += 0.2 * i
                actor.sleep -= 0.5 * i;  actor.stress -= 0.2 * i
                actor.hp += 6 * i;       actor.mp += 4 * i
                actor.drunk -= 1 * i
              # 야영
              elsif $game_variables[16] == 2
                actor.hunger += 0.3 * i; actor.thirst += 0.2 * i
                actor.sleep -= 0.9 * i;  actor.stress -= 0.5 * i
                actor.hp += 12 * i;      actor.mp += 8 * i
                actor.drunk -= 1 * i
              # 여관 방 사용
              elsif $game_variables[16] == 3
                actor.hunger += 0.2 * i; actor.thirst += 0.1 * i
                actor.sleep -= 1.7 * i;  actor.stress -= 0.5 * i
                actor.hp += 24 * i;      actor.mp += 12 * i
                actor.drunk -= 1 * i
              # 말 이용
              elsif $game_variables[16] == 4
                actor.hunger += 0.2 * i; actor.thirst += 0.1 * i
                actor.sleep += 0.2 * i;  actor.drunk -= 0.1 * i
              # 경비병 몸 수색
              elsif $game_variables[16] == 5
                actor.hunger += 0.1 * i; actor.thirst += 0.1 * i
                actor.sexual += 0.3 * i; actor.stress += 0.1 * i
                actor.drunk -= 0.1 * i
              # 엘자이렌 기도
              elsif $game_variables[16] == 6
                actor.hunger += 0.1 * i; actor.thirst += 0.2 * i
                actor.piety += 0.1 * i;  actor.drunk -= 0.1 * i
                actor.sexual -= 0.3 * i; actor.stress -= 0.2 * i
              # 씻기
              elsif $game_variables[16] == 9
                actor.hunger += 0.1 * i; actor.sexual -= 0.03 * i
                actor.sleep += 0.1 * i;  actor.temper -= 0.1 * i
                if $game_variables[62] == 2
                  # 비누를 사용
                  actor.stress -= 0.08 * i; actor.hygiene -= 1 * i
                  actor.drunk -= 0.7 * i
                else
                  # 그냥 물만 사용
                  actor.stress -= 0.04 * i; actor.hygiene -= 0.5 * i
                  actor.drunk -= 0.5 * i
                end
              # 특식 사용
              elsif $game_variables[16] == 13
                actor.hunger -= 8 * i;   actor.thirst -= 1 * i
                actor.sleep -= 0.5 * i;  actor.drunk -= 0.5 * i
                actor.sexual += 0.1 * i; actor.stress -= 1 * i
                actor.hp += 12 * i;      actor.mp += 6 * i;
              end
              actor.check_death
            end
          end
        end
        # ----------------------------------------------------------------------
        # 시간 가속 종료한다.
        # ----------------------------------------------------------------------
        if $game_switches[283] == true and 0 == $game_variables[15]
          #print("260.module HM_SEL 2 - 시간 가속 종료, %s \n" % [$game_variables[15]]);
          $game_variables[15] -= 1
          # 휴식 종료
          if 4 >= $game_variables[16] or $game_variables[16] == 9 or $game_variables[16] == 13
            $game_temp.reserve_common_event(65)
          elsif 5 == $game_variables[16]
            $game_temp.reserve_common_event(126)
          elsif 6 == $game_variables[16]
            $game_temp.reserve_common_event(86)
          # 착유 종료
          elsif 14 == $game_variables[16]
            $game_temp.reserve_common_event(173)
          # 자위 종료
          elsif 7 == $game_variables[16]
            $game_temp.reserve_common_event(178)
          # 성매매 종료
          elsif 8 == $game_variables[16]
            $game_temp.reserve_common_event(174)
          # 펠라 종료
          elsif 16 == $game_variables[16]
            $game_temp.reserve_common_event(179)
          # 여관 성폭행중
          elsif 10 == $game_variables[16]
            $game_temp.reserve_common_event(177)
          # 출산 종료
          elsif 11 == $game_variables[16]
            $game_variables[16] = 99
            # 출산 카운터 +1
            $game_actors[7].set_custom_bio[8] = $game_actors[7].set_custom_bio[8].to_i + 1
            $game_temp.reserve_common_event(239)
          # 인간형 몹에게 강간 종료
          elsif 12 == $game_variables[16]
            $game_temp.reserve_common_event(175)
          # 동료랑 섹스 종료
          elsif 15 == $game_variables[16]
            $game_temp.reserve_common_event(176)
          end
        end
        $sel_time_frame = 0 if $sel_time_frame >= ($game_switches[50] == true ? 30 : FRAMES_TIL_UPDATE)
      end
      $sel_time_frame += 1
      $sel_time_frame_10 = 0 if $sel_time_frame_10 >= 10
      $sel_time_frame_10 += 1
      $sel_time_frame_30 = 0 if $sel_time_frame_30 >= 30
      $sel_time_frame_30 += 1
    end
  end
  
  def self.show_tint(dura = 60)
    #print("260.module HM_SEL 2 - 시간 조정 \n");
    # 시간 오버시 수치 조정 실험
    hour = $game_variables[HOUR]; hour -= 24 if hour >= 24
  end
  
  def self.weather_manager
    #print("260.module HM_SEL 2 - 날씨 변경 \n");
    $game_variables[WEATHA] = $game_variables[WEATHB]
    # 날씨 수정 기본 맑음
    t_weather = 0
    @thunder_switch = false
    @flash_switch = false
    random_number = rand(20)
    odds = WEATHER[$game_variables[MONTH]]
    if random_number >= 17
      case odds[1]
      when :rain
        t_weather = 2
      when :snow
        t_weather = 3
      when :storm
        t_weather = 4
      else
        t_weather = 0
      end
    else
      # 계속 비 와서 실험
      t_weather = 0
    end
    $game_variables[WEATHB] = t_weather
    
    # 기존 날씨에 현재 날씨 값 대입한다.
    if $game_variables[WEATHA] != $game_variables[22]
      #print("260.module HM_SEL 2 - 날씨 변경 적용 \n");
      $game_variables[22] = $game_variables[WEATHA]
      $game_temp.reserve_common_event(6)
    end
  end

  def self.show_weather(dura = 300)
    #print("260.module HM_SEL 2 - 날씨 효과 적용 \n");
    unless no_weather?
      temp = WEATHER[$game_variables[MONTH]]
      unless inside?
        case $game_variables[WEATHA]
        when 1  #Sun
          $game_map.screen.change_weather(:none, 0, dura)
        end
      else  #Inside
        $game_map.screen.change_weather(:none, 0, 0)
      end
    else
      $game_map.screen.change_weather(:none, 0, dura)
    end
  end
  
  def self.next_day(temp_hour = 6)
    case $game_variables[HOUR]
    when 0...temp_hour
      $game_variables[MIN] = 0
      $game_variables[HOUR] = temp_hour
    else
      prog_day
      $game_variables[MIN] = 0
      $game_variables[HOUR] = temp_hour
      show_tint
    end
  end
  
  def self.exact_time(hour, min)
    return ($game_variables[HOUR] == hour && $game_variables[MIN] == min)
  end
  
  def self.hour_range(hour_a, hour_b)
    #print("260.module HM_SEL 2 - 시간 범위 확인 \n");
    return ($game_variables[HOUR] >= hour_a && $game_variables[HOUR] < hour_b)
  end
  
  def self.week_range(day_a, day_b)
    return ($game_variables[DAYA] >= day_a && $game_variables[DAYA] < day_b)
  end
end