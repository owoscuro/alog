# encoding: utf-8
# Name: + BM, MENU
# Size: 995
module BM
  module MENU
    OPTIONS ={
      :spacing      => 25,    # 메뉴 상태에서 배우 사이의 간격
      :actor_skip   => false, # 하나의 파티원이 있다면 액터 선택을 이동
    }
    
    ACTOR_OPTIONS ={
      :style        => 0, 
      :use_bust      => true, # 사용할 수 없음, 면을 사용하지 않는 경우
      :bust_height   => 380,  # 이미지의 크기
      :bust_offset_y => 300,  # 윈도우의 기본 오프셋 가슴
      :show_tp       => true, # HP와 MP 이하로 측정하는 방법
      :hp_fontsize   => 17,   # HP와 MP 게이지의 글꼴 크기
    }
    
    VARIABLE_OPTIONS = {
      :use_window => true, # 변수, 시간 단계 등을 표시하도록 아래쪽에 금 창을 변경
      :icons => true,
      :style => 0,
    }
    
    VARIABLES_HASH  ={
      -2 => [ 467, "지역"], # steps taken
      -1 => [ 280, "시간"], # game time
       0 => [ 262, "골드"], # gold
    }
  end
end