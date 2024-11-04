# encoding: utf-8
# Name: 033.YEA, CloneEvents
# Size: 5642
# encoding: utf-8
# Name: 033.YEA, CloneEvents
# Size: 5830
module Key
  Weapon   =  [:kA,     'A']           # Weapon usage
  Armor    =  [:kS,     'S']           # Armor usage
  Item     =  [:kD,     'D']           # Item  usage
  Item2    =  [:kF,     'F']           # Item2 usage
  Item3     = [:kG,     'G']           # Item  usage
  Item4    =  [:kH,     'H']           # Item2 usage
  Skill    =  [:kQ,     'Q']           # Skill usage
  Skill2   =  [:kW,     'W']           # Skill2 usage
  Skill3   =  [:kE,     'E']           # Skill3 usage
  Skill4   =  [:kR,     'R']           # Skill4 usage
  Skill5   =  [:k1,     '1']           # Skill usage
  Skill6   =  [:k2,     '2']           # Skill2 usage
  Skill7   =  [:k3,     '3']           # Skill3 usage
  Skill8   =  [:k4,     '4']           # Skill4 usage
  
  # 팔로어 공격 토글
  Follower =  [:kC,      'C']
  
  # 빠른 도구 선택 키
  QuickTool = :kN
  
  # 플레이어 선택 호출 키
  PlayerSelect = :kM
  
  # 가드 성공 시 재생되는 사운드
  GuardSe = "Hammer"
end

module ADIK
  module QUICK
    # 빠른 저장 / 빠른 불러오기 슬롯
    INDEX = 0
    SAVE_KEY = 60
    LOAD_KEY = 65
  end
end

module YEA
  module EVENT_WINDOW
    HIDE_SWITCH = 183       # 스위치를 ON으로 하면 이벤트 창이 나타나지 않습니다.
    NEW_MAP_CLEAR = true    # 새 지도를 입력할 때 텍스트를 지우시겠습니까?
    WINDOW_WIDTH  = 280     # 이벤트 창 너비.
    VISIBLE_TIME  = 220     # 창을 페이드하기 전에 볼 수 있는 프레임입니다.
    MAX_LINES     = 6       # 표시되는 최대 줄 수입니다.
    WINDOW_FADE   = 10      # 이벤트 창의 페이드 속도.
    
    HEADER_TEXT = "\e} "              # 머리에 항상 사용되는 텍스트입니다.
    FOUND_TEXT  = "\ec[6] +\ec[0] "   # 항목을 찾았을 때 사용되는 텍스트입니다.
    LOST_TEXT   = "\ec[4] -\ec[0] "   # 아이템을 잃어버렸을 때 사용하는 문구.
    AMOUNT_TEXT = "×%s"               # 금액을 표시하는 데 사용되는 텍스트입니다.
    CLOSER_TEXT = " "                 # 항상 마지막에 사용되는 텍스트입니다.
  end
  
  module CORE
    # 해상도 설정
    RESIZE_WIDTH  = 832
    RESIZE_HEIGHT = 544

    # 프레임 설정 1 ~ 4
    ANIMATION_RATE = 1

    # 숫자 표기 설정
    GROUP_DIGITS = false
    
    FONT_NAME = ["Arial"]
    FONT_SIZE = 20
    FONT_BOLD = false
    FONT_ITALIC = false
    FONT_SHADOW = false
    FONT_OUTLINE = true
    FONT_COLOUR = Color.new(255, 255, 255, 255)
    FONT_OUTLINE_COLOUR = Color.new(0, 0, 0, 128)
    
    # 강제 조치 설정
    FORCED_ACTION_REMOVE_SWITCH = 0
    
    # 게이지 메뉴 설정
    GAUGE_OUTLINE = false
    GAUGE_HEIGHT = 12

    COLOURS ={
      :normal     =>  0,   # Default:  0
      :system     => 16,   # Default: 16
      :crisis     => 17,   # Default: 17
      :knockout   => 18,   # Default: 18
      :gauge_back => 32,   # Default: 19
      :hp_gauge1  => 28,   # Default: 20
      :hp_gauge2  => 29,   # Default: 21
      :mp_gauge1  => 22,   # Default: 22
      :mp_gauge2  => 23,   # Default: 23
      :mp_cost    => 23,   # Default: 23
      :power_up   => 24,   # Default: 24
      :power_down => 25,   # Default: 25
      :tp_gauge1  => 10,   # Default: 28
      :tp_gauge2  =>  2,   # Default: 29
      :tp_cost    =>  2,   # Default: 29
    }
    
    TRANSPARENCY = 160   # 비활성화된 항목의 투명도를 조정합니다.
    HP_CRISIS = 0.25     # 체력이 중요한 것으로 간주되는 경우.
    MP_CRISIS = 0.25     # 마력이 크리티컬로 간주되는 경우.
    ITEM_AMOUNT = "×%s"  # 상품 금액에 사용되는 접두사.
  end
  
  module SAVE
    # 저장 파일 슬롯 최대치
    MAX_FILES = 24
    SLOT_NAME = "Archivo %s"
    SLOT_NAME2 = " Archivo %s"
    
    SAVE_ICON  = 368
    EMPTY_ICON = 375
    
    ACTION_LOAD   = "Cargar"
    ACTION_SAVE   = "Guardar"
    ACTION_DELETE = "Eliminar"
    DELETE_SOUND  = RPG::SE.new("Collapse3", 100, 100)
    
    SELECT_HELP = "Seleccione el archivo para guardar o cargar. \n\\C[10]* 'Archivo F4' es el espacio utilizado para la función de guardado rápido (botón F4).\\C[0]"
    LOAD_HELP   = "Cargar datos del juego guardado."
    SAVE_HELP   = "Guardar el progreso actual del juego."
    SAVE_HELP_OK   = "El progreso actual del juego ha sido guardado."
    SAVE_HELP_NO   = "En los niveles HARD, HELL, y LUNATIC solo se puede guardar usando la cama en la posada."
    SAVE_HELP_NO2   = "No es posible guardar en esta área."
    SAVE_HELP_NO3   = "No es posible guardar en este momento."
    DELETE_HELP = "Eliminar completamente el archivo de datos del juego guardado."
    
    EMPTY_TEXT = "Espacio de guardado vacío"
    PLAYTIME   = "Tiempo de juego"
    TOTAL_SAVE = "Total de guardados"
    TOTAL_GOLD = ""
    LOCATION   = "Última ubicación"
  end
end

module Switch
  def self.forced_action_remove
    return false if YEA::CORE::FORCED_ACTION_REMOVE_SWITCH <= 0
    return $game_switches[YEA::CORE::FORCED_ACTION_REMOVE_SWITCH]
  end
  def self.hide_event_window
    return false if YEA::EVENT_WINDOW::HIDE_SWITCH <= 0
    return $game_switches[YEA::EVENT_WINDOW::HIDE_SWITCH]
  end
end

module CloneEvents
  CLONE_MAP = 1

  # 이벤트 이름 또는 이벤트 ID 를 사용하시겠습니까?
  # true = 이벤트 이름 사용, false = 이벤트 ID 사용
  USE_NAME = false

  # 정규 표현식 패턴
  PATT_MAP_NAME = /<clone\s+(\d+)\s+(\w+)>/i
  PATT_MAP_ID = /<clone\s+(\d+)\s+(\d+)>/i
  PATT_NAME = /<clone\s+(\w+)>/i
  PATT_ID = /<clone\s+(\d+)>/i
end