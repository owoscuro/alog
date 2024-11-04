# encoding: utf-8
# Name: 259.module HM_SEL 1
# Size: 7814
# encoding: utf-8
# Name: 259.module HM_SEL 1
# Size: 7754
=begin

다음은 지도 메모 상자 또는 타일셋 메모 상자에서 사용할 수 있습니다.

<stop_time> -   이 태그가 있는 지도는 시간을 비활성화합니다.
<no_tone> -     이 태그가 있는 지도는 톤을 자동으로 새로 고치지 않습니다.
<def_tone> -    이 태그가 있는 맵은 기본 톤 설정을 사용합니다(가장 잘 사용됨
                정시에 중지된 지도 또는 수동으로 변경하지 않을 지도
                음정.)
<inside_map> -  이 태그가 있는 지도는 날씨 효과를 표시하지 않지만
                배경음 볼륨은 3으로 나뉩니다.
<no_weather> -  이 태그가 있는 지도는 날씨를 표시하지 않거나 해당 날씨를 사용하지 않습니다.
                배경음.
<forest> -      이 태그가 있는 맵은 톤 설정을 가져옵니다.
                Forest_Tones 해시는 일반 해시 대신입니다.
                
모든 스크립트 호출은 HM_SEL::

next_day            - 이 스크립트 호출은 다음 날로 전환됩니다.
                      가장 가까운 오전 6시.
next_day(x)         - 또한 선택적 인수가 무엇을 선택하는지 허용합니다.
                      도착할 시간.
show_tint           - 이 스크립트 호출은 수동으로 변경한 후에 사용해야 합니다.
                      시간 변수, 필요한 톤 설정을 다시 조정하기 위해,
                      또는 DEF_TONE/INSIDE_SWITCH 스위치가 뒤집혔을 때.
show_weather        - 이 스크립트 호출은 수동으로 조정한 후에 사용해야 합니다.
                      날씨 변수 또는 DISABLE_WEATHER 스위치를 뒤집습니다.
festivalcheck(x)    - 이 스크립트 호출은 연도의 x일이 다음과 같은 경우 true를 반환합니다.
                      축제에 플래그가 지정되었습니다.
tomorrow_festival?  - 이 스크립트 호출은 내일 플래그가 지정되면 true를 반환합니다.
                      축제로.
exact_time(h, m)    - 지정된 시간이면 true를 반환합니다.
                      예: HM_SEL::exact_time(22, 10)은 오후 10시 10분에 true입니다.
hour_range(a, b)    - 현재 시간이 범위 내에 있으면 true를 반환합니다.
                      예: HM_SEL::hour_range(9, 21)는 오전 9시 이전에 거짓입니다.
                      오후 9시 이후에는 그렇지 않으면 true입니다.
week_range(a, b)    - 일을 제외하고 hour_range와 동일합니다.

=end

module HM_SEL
  MIN = 5       # 분변수
  HOUR  = 6     # 0 = 오전 12시, 13 = 오후 1시
  DAYA  = 7     # 요일 변수, 월요일은 1, 일요일은 7
  DAYB  = 8     # Day of the Month 변수에 대한 용도를 찾을 수 있을 거라 확신합니다.
  DAYC  = 9     # 축제일 확인에 사용되는 요일 변수입니다.
  MONTH = 10    # 월 변수
  YEAR  = 11    # 연도 변수
  WEATHA  = 12  # 현재 날씨
  WEATHB  = 13  # 내일의 날씨

  # 추가 제어에 사용할 수 있는 스위치. 원하지 않으면 0으로 설정
  # 사용합니다.
  
  STOP_TIME = 37
  NO_TONE = 0
  DEF_TONE = 0
  INSIDE_SWITCH = 0
  DISABLE_WEATHER = 0
  
  FRAMES_TIL_UPDATE = 120   # 시간 업데이트 속도, 대략 60 = 1초
  MINUTE_CYCLE = 1          # 업데이트당 몇 분 경과
 
  DAYS_IN_MONTH = {
  1 => 31,
  2 => 28,
  3 => 31,
  4 => 30,
  5 => 31,
  6 => 30,
  7 => 31,
  8 => 31,
  9 => 30,
  10 => 31,
  11 => 30,
  12 => 31,
  }

  TONE_DEFAULT = Tone.new(20,20,15,20)
  TONES = {
  #Hour => Tone Settings(Red, Green, Blue, Grey)
  0 => Tone.new(-65,-25,0,55),
  1 => Tone.new(-65,-25,0,55),
  2 => Tone.new(-65,-25,0,55),
  3 => Tone.new(-65,-25,0,65),
  4 => Tone.new(-40,-15,0,20),
  5 => Tone.new(-40,-15,0,20),
  6 => Tone.new(0,15,0,0),
  7 => Tone.new(0,15,0,0),
  8 => Tone.new(0,15,0,-5),
  9 => Tone.new(10,25,0,-5),
  10 => Tone.new(10,25,0,-5),
  11 => Tone.new(25,45,0,-15),
  12 => Tone.new(25,45,0,-15),
  13 => Tone.new(25,45,0,-15),
  14 => Tone.new(25,45,0,-15),
  18 => Tone.new(-25,-10,0,15),
  19 => Tone.new(-25,-10,0,15),
  20 => Tone.new(-25,-10,0,15),
  21 => Tone.new(-40,-30,0,45),
  22 => Tone.new(-40,-30,0,45),
  23 => Tone.new(-40,-30,0,45),
  }

  Forest_Tones = {
  #Hour => Tone Settings(Red, Green, Blue, Grey)
  0 => Tone.new(-65,-25,0,55),
  1 => Tone.new(-65,-25,0,55),
  2 => Tone.new(-65,-25,0,55),
  3 => Tone.new(-65,-25,0,65),
  4 => Tone.new(-40,-15,0,20),
  5 => Tone.new(-40,-15,0,20),
  6 => Tone.new(0,15,0,0),
  7 => Tone.new(0,15,0,0),
  8 => Tone.new(0,15,0,-5),
  9 => Tone.new(10,25,0,-5),
  10 => Tone.new(10,25,0,-5),
  11 => Tone.new(25,45,0,-15),
  12 => Tone.new(25,45,0,-15),
  13 => Tone.new(25,45,0,-15),
  14 => Tone.new(25,45,0,-15),
  18 => Tone.new(-25,-10,0,15),
  19 => Tone.new(-25,-10,0,15),
  20 => Tone.new(-25,-10,0,15),
  21 => Tone.new(-40,-30,0,45),
  22 => Tone.new(-40,-30,0,45),
  23 => Tone.new(-40,-30,0,45),
  }

  WEATHER = {
  #Month => [Odds, Weather, BGS, Volume, Pitch]
  1 => [60, :snow, "Wind", 75, 100],
  2 => [60, :snow, "Wind", 75, 100],
  3 => [60, :snow, "Wind", 75, 100],
  4 => [60, :snow, "Wind", 75, 100],
  5 => [45, :rain, "Rain", 95, 100],
  6 => [45, :rain, "Rain", 95, 100],
  7 => [45, :rain, "Rain", 95, 100],
  8 => [55, :rain, "Rain", 95, 100],
  9 => [55, :rain, "Rain", 95, 100],
  10 => [55, :rain, "Rain", 95, 100],
  11 => [45, :rain, "Rain", 95, 100],
  12 => [60, :snow, "Wind", 75, 100],
  }
  
  def self.time_stop?
    # 게임 시작 스위치, 에르니 사망
    return true if $game_switches[281] == false or $game_switches[44] == true or $game_switches[80] == true or $game_switches[182] == true
    return true if $game_message.visible == true
    return true if $game_switches[STOP_TIME]
    # 화면 전환중 시간 정지 추가
    return true if $game_player.transfer?
    #return true if $game_system.menu_disabled and $game_map.map_id != 35 #or $game_map.interpreter.running?
    return false
  end
 
  def self.no_tone?
    return true if $game_switches[NO_TONE]
    return true if $game_map.map.no_tone
    return true if $game_map.tileset.no_tone
    return false
  end
 
  def self.def_tone?
    return true if $game_switches[DEF_TONE]
    return true if $game_map.map.def_tone
    return true if $game_map.tileset.def_tone
    return false
  end
 
  def self.inside?
    return true if $game_switches[INSIDE_SWITCH]
    return true if $game_map.map.inside_map
    return true if $game_map.tileset.inside_map
    return false
  end
 
  def self.no_weather?
    return true if $game_switches[DISABLE_WEATHER]
    return true if $game_map.map.no_weather
    return true if $game_map.tileset.no_weather
    return false
  end
 
  def self.is_forest?
    return true if $game_map.map.is_forest?
    return true if $game_map.tileset.is_forest?
    return false
  end
 
  # 이것은 게임 시작 시 변수가 무엇인지 결정합니다.
  def self.init_var
    if $game_variables[DAYA] == 0
    #print("259.module HM_SEL 1, 초기 셋팅 설정 진행 \n");
    $game_variables[DAYA] = 1
    $game_variables[DAYB] = 1
    $game_variables[DAYC] = 1
    $game_variables[MONTH]  = 1
    $game_variables[YEAR] = 665
    $game_variables[WEATHA] = 0
    $game_variables[WEATHB] = 0
    $game_variables[MIN]  = 0
    $game_variables[HOUR] = 6
    # 말일도 변수로 지정
    $game_variables[14] = DAYS_IN_MONTH[$game_variables[MONTH]]
    # 날씨 아이콘 지정
    $game_variables[20] = 1
    end
  end
end