# encoding: utf-8
# Name: 069.QuestData
# Size: 153766
#-------------------------------------------------------------------------------
#        quest(quest_id)
#          quest_id : 액세스하려는 퀘스트의 정수 ID
#
#   이를 통해 퀘스트에 저장된 관련 데이터에 액세스하거나 변경할 수 있습니다.
#   이름, 설명, 목표 등... 예:
#
#         quest(1).name = "조각난 휴식"
#
# 더 관련성이 높은 퀘스트 진행 상황을 제어할 때
# 다음 코드는 스크립트 이벤트 명령에서 사용할 수 있습니다. 인수는
# 각 명령에 대해 동일하므로 한 번만 설명합니다. 그들 모두는
# 꽤 자명하고 둘 중 하나를 사용하면 퀘스트가 활성화됩니다.
# (라인 267에서 MANUAL REVEAL 설정을 사용하지 않는 한).
#    
#        reveal_objective(quest_id, objective_id_1, ..., objective_id_n)
#            quest_id : 액세스하려는 퀘스트의 정수 ID입니다.
#               objective_id_1, ..., objective_id_n : 의 ID 목록 
#               운영하려는 목표. 하나 또는 다음과 같이 적을 수 있습니다.
#               모두와 마찬가지로 많습니다.
#               나열된 목표를 퀘스트 정보에 표시합니다.
#
#        conceal_objective(quest_id, objective_id_1, ..., objective_id_n)
#               나열된 목표를 퀘스트 정보에 숨깁니다.
#
#        complete_objective(quest_id, objective_id_1, ..., objective_id_n)
#               나열된 목표의 색상을 완성된 색상으로 변경합니다.
#               주요 목표를 모두 달성하면 퀘스트가 완료됩니다.
#
#        uncomplete_objective (quest_id, objective_id_1, ..., objective_id_n)
#               활성 다시 나열된 전체 목표의 상태를 변경
#
#        fail_objective(quest_id, objective_id_1, ..., objective_id_n)
#               나열된 목표의 색상을 실패한 색상으로 변경합니다.
#               퀘스트는 주 목표가 하나면 실패합니다.
#
#        unfail_objective(quest_id, objective_id_1, ..., objective_id_n)
#               나열된 실패한 목표의 상태를 다시 활성 상태로 변경합니다.
#
#        change_reward_status(quest_id, value)
#               value : 참이든 거짓이든. 제외된 경우 기본값은 true입니다.
#               완전히 선택 사항이지만 이것은 개인 스위치일 뿐입니다.
#               보상이 주어지면 켜집니다. 그런 다음 조건을 만들 수 있습니다.
#               플레이어에게 두 번 이상 보상하지 않도록 합니다. (180행 참조)
#
#  EXAMPLES:
#    reveal_objective(1, 0)
#      이것은 ID 1의 퀘스트의 첫 번째 목표를 나타냅니다.
#    complete_objective(6, 2, 3)
#      이것은 ID 6의 퀘스트의 세 번째 및 네 번째 목표를 완료합니다.
#    change_reward_status(8)
#      이것은 ID 8의 퀘스트에 대한 보상 스위치를 true로 설정합니다.
#    change_reward_status2(8)
#      이것은 ID 8의 퀘스트에 대한 보상 스위치를 false로 설정합니다.
#
#   또 다른 새로운 기능은
#   메뉴(편집 가능한 영역 B 참조). 그 외에도 다음을 사용할 수 있습니다.
#   퀘스트에 대해 지정된 보상을 자동으로 분배하는 코드
#   퀘스트가 완료되었으며 아직 보상이 주어지지 않았습니다:
#
#        distribute_quest_rewards(quest_id)
#          quest_id : 보상 배포 할 퀘스트의 ID
#
# 물론 물질적 보상(아이템, 무기, 갑옷, 금 또는 경험치)
# 문자열로 지정한 보상을 분배하지 않습니다.
# 이를 위해 조건부 분기에서 이 코드를 사용할 수도 있습니다.
# 보상을 나눠주어야만 만족합니다. 따라서 만약 당신이
# 특별한 보상을 추가하거나 그런 일을 하고 싶다면
# 그것이 참일 때를 위해 분기에 있습니다. 이 기능은 정말
# 이벤트로 하는게 좋을 것 같아서 추천합니다.
#
#    유용할 수 있는 스크립트 이벤트 명령의 다른 코드는 다음과 같습니다.
#    
#        reset_quest(quest_id)
#           quest_id : 액세스하려는 퀘스트의 정수 ID입니다.
#           이렇게 하면 퀘스트가 다시 초기화됩니다.
#           즉, 모든 퀘스트가 다음으로 진행됩니다.
#           날짜가 손실됩니다.
#
#        delete_quest(quest_id)
#           퀘스트를 비활성화하고 재설정합니다.
#
#        conceal_quest(quest_id)
#           퀘스트를 비활성화하여 씬에 나타나지 않지만 진행
#           저장되었습니다
#
#        reveal_quest(quest_id)
#           퀘스트를 활성화하거나 재활성화합니다. 이 명령은 다음과 같은 경우에 필요합니다.
#           284행의 MANUAL_REVEAL이 참이거나 이전에
#           은폐. 그렇지 않으면 퀘스트를 수행하는 것으로 충분합니다.
#
#        change_quest_access(:symbol)
#           :symbol은 6가지 옵션 중 하나여야 합니다(콜론 포함!):
#           :disable - 퀘스트 장면에 대한 액세스를 방지합니다(메뉴에서 회색으로 표시됨).
#           :enable - 퀘스트 장면에 대한 액세스를 활성화합니다.
#           :disable_menu - 메뉴에서 퀘스트 옵션을 제거합니다.
#           :enable_menu - 메뉴에 퀘스트 옵션을 추가합니다.
#           :disable_map - 지도에서 키로 액세스하는 것을 방지합니다.
#           :enable_map - 키를 사용하여 지도에 액세스할 수 있습니다.
#
#        change_quest_background("bg_filename", bg_opacity, bg_blend_type)
#           bg_filename : 배경에 대한 그림의 파일 이름 사진 폴더
#           bg_opacity : 배경 그래픽의 불투명도. 만약에
#                         제외됨, 기본값은 434행의 설정 값입니다.
#           bg_blend_type : 배경 그래픽의 블렌드 타입. 만약에
#                         제외됨, 기본값은 437행의 설정 값입니다.
#
#        change_quest_windows ("windowskin_filename", tone, opacity)
#           windowskin_filename : 창 그래픽의 이름 Graphics의 시스템 폴더
#           opacity : 창의 불투명도. 제외되는 경우,
#                     이것은 423행의 설정 값으로 기본 설정됩니다.
#           blend_type : 창의 blend_type. 제외되는 경우,
#                     이것은 426행의 설정 값으로 기본 설정됩니다.
#
# 또한 Script 명령에서 사용할 수 있는 몇 가지 코드가 있습니다.
# 조건부 분기. 나는 이 모든 것이 선택 사항이라는 점에 주목합니다. 당신은 할 수
# 스위치 및 변수 검사를 사용하고 다음을 통해서만 퀘스트 진행 상황을 모니터링합니다.
# 이벤트. 그러나 이러한 명령을 사용하면 좀 더 쉽게 할 수 있으며 다음과 같습니다.
# 
#        quest_revealed?(quest_id)
#            quest_id : 액세스하려는 퀘스트의 정수 ID입니다.
#                       퀘스트가 활성화되면 만족합니다.
#
#        quest_complete?(quest_id)
#                       퀘스트의 모든 주요 목표가 완료되면 충족됩니다.
#
#        quest_failed?(quest_id)
#                       퀘스트의 주요 목표 중 하나라도 실패하면 충족됩니다.
#
#        quest_rewarded?(quest_id)
#                       보상 상태를 true로 변경하면 만족합니다.
#
#        objective_revealed?(quest_id, objective_id_1, ... objective_id_n)
#           Objective_id_1, ..., objective_id_n : ID 목록
#                       목표. 하나 또는 다음과 같이 적을 수 있습니다.작업하려는
#                       모두와 마찬가지로 많습니다.
#                       나열된 목표가 공개되면 충족됩니다.
#
#        objective_active?(quest_id, objective_id_1, ... objective_id_n)
#                       나열된 모든 목표가 공개되고
#                       완료되지도 실패하지도 않았습니다.
#
#        objective_complete?(quest_id, objective_id_1, ... objective_id_n)
#                       나열된 모든 목표가 완료되면 충족됩니다.
#
#        objective_failed?(quest_id, objective_id_1, ... objective_id_n)
#                       나열된 모든 목표가 실패한 경우 충족됩니다.
#
#                       이벤트에서 퀘스트 장면을 호출하고 싶다면 다음을 사용합니다.
#                       호출 스크립트의 코드:
# 
#        call_quest_journal(quest_id)
#          quest_id : 장면을 열고자 하는 퀘스트의 ID
#
# quest_id(198행)를 지정하지 않으면 단순히
# 평소와 같은 장면. quest_id(199행)를 지정하면
# 공개되고 있는 한 해당 퀘스트의 장면을 엽니다.
# 일반적으로 퀘스트 메뉴를 통해 액세스할 수 있습니다.
#
# 마지막으로 이 스크립트가 작동하는 기본 방식은 자동으로 퀘스트를 수행하는 것입니다.
# 주요 목표의 상태에 따라 완료하거나 실패합니다. 그러나 당신은
# 주요 목표가 없도록 설정할 수 있습니다.
# 다음 코드를 통해 수동으로 퀘스트를 완료, 실패 또는 (재)활성화합니다.
# 스크립트 호출에서:
#
#        manually_complete_quest(quest_id)
#          quest_id : 수동으로 완료하려는 퀘스트의 ID
#        manually_fail_quest(quest_id)
#          quest_id : 수동으로 실패하려는 퀘스트의 ID
#        manually_activate_quest(quest_id)
#          quest_id : 수동으로 활성화하려는 퀘스트의 ID
#-------------------------------------------------------------------------------

$imported ||= {}
$imported[:"MA_QuestJournal_1.0"] = true
$imported[:"MA_QuestJournal_1.0.1"] = true

module QuestData
  # MENU_ACCESS - true인 경우 명령어를 통해 퀘스트 일지 접속 가능
  MENU_ACCESS = true
  
  # MENU_INDEX - MENU_ACCESS가 true이면 표시되는 위치를 결정합니다.
  MENU_INDEX = 4
  
  # MAP_ACCESS - true인 경우 다음을 통해 퀘스트 저널에 액세스할 수 있습니다.
  MAP_ACCESS = true
  
  # MAP_BUTTON - MAP_ACCESS가 true이면 어떤 버튼이
  # 퀘스트 일지
  MAP_BUTTON = :J
  
  # OPEN_TO_LAST_REVEALED_QUEST - true인 경우 처음 열 때
  # 퀘스트 일지 신규 퀘스트 공개 후, 신규 퀘스트로 오픈됩니다.
  OPEN_TO_LAST_REVEALED_QUEST = true
  
  # OPEN_TO_LAST_CHANGED_QUEST - 참이면 퀘스트 저널이 열립니다.
  # 목표 상태가 변경된 마지막 퀘스트.
  OPEN_TO_LAST_CHANGED_QUEST = false
  
  # LIST_WINDOW_WIDTH - 목록 창의 너비(픽셀)
  LIST_WINDOW_WIDTH = 192
  
  # BASIC_DATA_TYPES - 추가 데이터 유형을 설정할 수 있습니다. 단지
  # 배열에 식별 신호를 포함합니다. 그런 다음 제공해야 합니다.
  # 각 신호는 아이콘(라인 322의 ICONS 해시)과 신호 텍스트(
  # VOCAB 배열은 333행에 있지만 빈 문자열일 수 있음). 그러면 당신은
  # 단순히 다음을 추가하여 퀘스트를 설정할 때 데이터 자체를 설정할 수 있습니다.
  # q[:기호] = ""
  # 퀘스트 라인. 또한 어딘가에 데이터 유형을 포함해야 합니다.
  # 306행의 DATA_LAYOUT. 예를 들어 다음을 포함했습니다.
  # 기본적으로 및 :location입니다. 이 섹션의 모든 항목에 대해 Ctrl+F를 사용할 수 있습니다.
  # 해당 기호 중 하나(: 제외)를 추가해야 합니다.
  # 추가하는 새 데이터 유형에 대해.
  BASIC_DATA_TYPES = [:client, :location]
  
  # BASIC_DATA_WIDTH - 이것은 픽셀 단위로 얼마나 많은 공간이
  # 데이터 창에서 설정한 모든 기본 데이터 유형.
  BASIC_DATA_WIDTH = Graphics.width
  
  # CONCURRENT_ACTIVITY - 참이면 퀘스트 저널 장면에서
  # 카테고리를 전환하거나 동시에 퀘스트 목록을 아래로 스크롤할 수 있습니다. 만약에
  # false, 시작하기 전에 먼저 범주를 선택해야 합니다.
  # 퀘스트 목록을 스크롤합니다.
  CONCURRENT_ACTIVITY = true
  
  # HIDE_CATEGORY_CURSOR - true인 경우 범주 창에는
  # 커서를 이동하고 대신 현재 선택한 범주를 강조 표시합니다.
  # CONCURRENT_ACTIVITY가 true일 때 가장 좋습니다.
  HIDE_CATEGORY_CURSOR = true
  
  # SHOW_QUEST_ICONS - true인 경우 각 퀘스트에 대해 선택한 아이콘은
  # 퀘스트 목록 창에서 이름 왼쪽에 표시
  SHOW_QUEST_ICONS = true
  
  # MANUAL_REVEAL - 거짓일 경우 퀘스트를 받는 순간 공개됩니다.
  # 먼저 목표를 밝히거나, 완료하거나, 실패합니다. 이것이 사실이라면 당신은
  # 별도의 스크립트 호출을 통해 각 퀘스트를 구체적으로 공개해야 합니다.
  # 공개_퀘스트(퀘스트_ID)
  MANUAL_REVEAL = false
  
  # DATA_LAYOUT - 퀘스트 창이 모든 레이아웃을 배치하는 방식을 제어합니다.
  # 관련 데이터. 항목 중 하나를 배열로 설정하면 모든
  # 명령이 같은 y에 그려집니다. :line을 제외하고,
  # 퀘스트가 그렇게 설정되어 있지 않으면 명령이 그려지지 않습니다.
  # 특정 데이터. 기호는 다음과 같습니다.
  # :line - 창을 가로질러 수평선을 그립니다.
  # :name - 퀘스트 이름을 그립니다.
  # :level - 퀘스트의 레벨을 그립니다.
  # :banner - 퀘스트 배너를 그립니다.
  # :client - 퀘스트에서 설정한 클라이언트를 그린다(기본 데이터)
  # :location - 퀘스트에서 설정한 위치를 그립니다(기본 데이터).
  # :description - 퀘스트 설명을 그립니다.
  # :objectives - 공개된 모든 퀘스트의 목표를 그립니다.
  # :rewards - 설정된 보상을 가져옵니다.
  #
  # 또한 배치하는 새 BASIC_DATA에 대한 항목을 추가해야 합니다.
  # 264행의 BASIC_DATA_TYPES에 있습니다.
  #
  # 각 항목 뒤에 쉼표를 넣는 것을 잊지 마십시오. 또한 이것은 단지
  # 기본 레이아웃. 모든 퀘스트에 대해 다른 레이아웃을 설정할 수 있습니다.
  # 해당 퀘스트를 보면 사용자 정의 레이아웃이 표시됩니다.
  DATA_LAYOUT = [
    [:line, :name, :level], 
    :banner, 
    :client, 
    :location, 
    :description,
    :objectives,
    [:line, :rewards], 
    :line,
  ]
  
  # ICONS - 스크립트에 사용되는 많은 아이콘을 설정하는 곳입니다. NS
  # 각각의 목적이 옆에 나열됩니다. 또한 사용자 정의를 만들 경우
  # 카테고리, 다음과 같은 라인을 배치하여 아이콘을 제공해야 합니다.
  # Otros. 따라서 새 사용자 정의 카테고리가 :로맨스인 경우 다음을 수행해야 합니다.
  # 다음과 같이 설정합니다.
  #    romance:     107,
  ICONS = {
    all:         3888,    # 모든 퀘스트 카테고리 아이콘
    active:      3889,    # 활성 퀘스트 카테고리 아이콘
    complete:    3890,    # 퀘스트 완료 카테고리 아이콘
    failed:      3891,    # 실패한 퀘스트 카테고리 아이콘
    client:      3896,    # 클라이언트 데이터의 아이콘입니다. 원하지 않는 경우 0으로 설정
    location:    3893,    # 위치 데이터의 아이콘입니다. 원하지 않는 경우 0으로 설정
    reward_gold: 3702,    # 골드 보상 아이콘입니다. 원하지 않는 경우 0으로 설정
    reward_exp:  3894,    # 경험치 보상 아이콘입니다. 원하지 않는 경우 0으로 설정
  }
  
  # VOCAB - 이를 통해 퀘스트 장면에서 사용된 단어 중 일부를 선택할 수 있습니다.
  VOCAB = {
    # menu_label: Nombre del comando en el menú si MENU_ACCESS es verdadero
    menu_label:       "Lista de misiones",
    # scene_label: Etiqueta en la parte superior de la escena. Si está vacío, no hay ventana
    scene_label:      "", 
    # description: Título que identifica la descripción
    description:      "Detalles de la misión",
    # objectives: Título que identifica los objetivos
    objectives:       "Objetivos",
    # objective_bullet: Viñeta que se muestra a la izquierda de cada ítem
    # objetivo. Si incluye %d, mostrará el ID del objetivo.
    objective_bullet: "-",
    # rewards: Título que identifica las recompensas
    rewards:          "Recompensas",
    # reward_amount: Texto que muestra la cantidad de las recompensas de ítems.
    # Debe incluir %d para mostrar la cantidad.
    reward_amount:    "×%d",
    # reward_gold: Texto que identifica la recompensa en oro
    reward_gold:      " Moneda",
    # reward_exp: Texto que identifica la recompensa en experiencia
    reward_exp:       "Experiencia",
    # level: Si LEVEL_ICON es 0, texto que precede al nivel.
    level:            "Rango: ",
    # location: 퀘스트 위치에 대한 텍스트 레이블
    location:         "",
    # location: 퀘스트 클라이언트의 텍스트 레이블
    client:           "",
  }
  
  # CATEGORIES - 이 배열을 사용하면 사용 가능한 범주를 설정할 수 있습니다.
  # 퀘스트 장면에서. 기본 카테고리는 :all, :active, :complete,
  # 및 :failed 및 해당 이름은 자명합니다. 사용자 정의를 추가할 수 있습니다.
  # 카테고리도 있지만 각 새로운
  # 카테고리에는 ICONS 해시에 설정된 아이콘과 레이블에 설정된 레이블이 있습니다.
  # CATEGORY_VOCAB 해시(SHOW_CATEGORY_LABEL을 사용하는 경우). 그것은 또한
  # 정렬에 문제가 없다면 정렬 유형을 지정하는 것이 좋습니다.
  # ID별, 기본값입니다.
  CATEGORIES = [:all, :active, :complete, :failed]
  
  # SHOW_CATEGORY_LABEL - 이름을 표시할지 여부를 선택할 수 있습니다.
  # true이면 이름을 선택합니다. 현재 선택된 카테고리의 
  # CATEGORY_VOCAB 해시의
  SHOW_CATEGORY_LABEL = true
  
  # CATEGORY_LABEL_IN_SAME_WINDOW - SHOW_CATEGORY_LABEL이 참이면 이
  # options를 사용하면 레이블을 다음과 같은 창에 표시할지 여부를 선택할 수 있습니다.
  # 카테고리 아이콘 또는 아래의 별도 창에서. true = 같은 창입니다.
  CATEGORY_LABEL_IN_SAME_WINDOW = true
  
  # CATEGORY_VOCAB - SHOW_CATEGORY_LABEL이 true인 경우
  # 이 해시를 사용하여 설정할 수 있습니다.
  # 각 카테고리에 대한 레이블. 생성한 사용자 정의 범주에 대해 다음을 수행합니다.
  # 아래에 동일한 형식으로 줄을 추가해야 합니다.
  # :카테고리 => "레이블",
  # 각 줄 끝에 쉼표를 추가하는 것을 잊지 마십시오.
  CATEGORY_VOCAB = {
    :all =>      "Todas las misiones",       # La etiqueta para la categoría :all
    :active =>   "Misiones en curso",        # La etiqueta para la categoría :active
    :complete => "Misiones completadas",     # La etiqueta para la categoría :complete
    :failed =>   "Misiones fallidas",        # La etiqueta para la categoría :failed
  }
  
  # SORT_TYPE - 이 해시를 사용하면 각 범주가 정렬되는 방식을 선택할 수 있습니다.
  # 각 카테고리, 기본 또는 사용자 정의에 대해 다른 정렬 방법을 설정할 수 있습니다.
  # 선택할 수 있는 7가지 옵션이 있습니다.
  #    :id -        퀘스트는 가장 낮은 ID에서 가장 높은 ID로 정렬됩니다.
  #    :alphabet -  퀘스트는 알파벳 순으로 정렬됩니다.
  #    :level -     퀘스트는 가장 낮은 수준에서 가장 높은 수준으로 정렬됩니다.
  #    :reveal -    퀘스트는 가장 최근에 공개된 것부터 정렬됩니다.
  #                 새로운 퀘스트가 공개될 때마다 맨 위에 표시됩니다.
  #    :change -    퀘스트는 가장 최근 상태인 퀘스트부터 정렬됩니다.
  #                 변경되었습니다. 따라서 목표가 수정될 때마다 해당 퀘스트는
  #                 맨 위로 던져집니다.
  #    :complete -  퀘스트는 가장 최근에 완료된 것부터 정렬됩니다.
  #                 퀘스트를 완료할 때마다 맨 위로 던집니다.
  #    :failed -    퀘스트는 가장 최근에 실패한 것부터 정렬됩니다.
  #                 퀘스트가 실패할 때마다 맨 위로 던져집니다.
  #
  # 추가로, 정렬 옵션의 끝에 _r을 넣을 수 있습니다.
  # 순서를 반대로 합니다. 예를 들어 범주에 대한 정렬 방법이
  # is :alphabet_r, 그러면 Z-A에서 퀘스트가 나타납니다.
  SORT_TYPE = {
    :all =>      :id,       # Sort type for the All Quests category
    :active =>   :change,   # Sort type for the Active Quests category
    :complete => :complete, # Sort type for the Complete Quests category
    :failed =>   :failed,   # Sort type for the Failed Quests category
  }
  
  # WINDOWSKIN - 퀘스트 장면의 각 창에 대한 창 스킨입니다. 그것은 반드시
  # Graphics의 System 폴더에 있는 그래픽을 참조합니다. false로 설정하면
  # 윈도우스킨이 기본값인 것을 사용합니다. 스크립트를 사용하는 경우
  # 플레이어가 윈도우 스킨을 선택할 수 있도록 하고, false는 권장 값입니다.
  WINDOWSKIN = false
  
  # WINDOW_TONE - 각 창의 톤입니다. 다음 형식의 배열이어야 합니다.
  # WINDOW_TONE = [빨강, 초록, 파랑, 회색]
  # 회색은 제외할 수 있지만 나머지 3개는 반드시 있어야 합니다. 이것을 설정하면
  # 값을 false로 설정하면 창의 톤이 기본값이 됩니다.
  WINDOW_TONE = false
  
  # WINDOW_OPACITY - 퀘스트 장면에서 창의 불투명도입니다. 로 설정하면
  # false, 창의 기본 불투명도를 사용합니다.
  WINDOW_OPACITY = false
  
  # BG_PICTURE - Picture 폴더에 있는 그림을 참조하는 문자열입니다.
  # 그래픽의 ""로 설정하면 사진이 없습니다. 그렇지 않으면
  # 선택한 그림이 창 아래에 표시되지만 지도 위에는
  # 퀘스트 장면.
  BG_PICTURE = ""
  
  # BG_OPACITY - 이렇게 하면 배경 그림의 불투명도를 설정할 수 있습니다.
  # 하나를 선택했다면.
  BG_OPACITY = 0
  
  # BG_BLEND_TYPE - 이를 통해 배경의 혼합 유형을 설정할 수 있습니다.
  # 사진, 하나를 선택한 경우.
  BG_BLEND_TYPE = 0 
  
  # DESCRIPTION_IN_BOX - 이것은 그래픽 옵션이며 다음을 수행할 수 있습니다.
  # 설명을 상자에 표시할지 여부를 선택합니다.
  DESCRIPTION_IN_BOX = true
  
  #  LEVEL_ICON - 레벨이 표시되는 방식을 설정합니다. 정수로 설정하면
  # 퀘스트 레벨까지 같은 아이콘을 여러 번 그립니다. 즉. 만약에
  # 레벨의 퀘스트가 1이면 아이콘이 한 번만 그려지지만,
  # 레벨의 퀘스트는 4, 4번 추첨됩니다. LEVEL_ICONS_SPACE 결정
  # 그들 사이의 공간. 그러나 LEVEL_ICON을 0으로 설정하면
  # 대신 해당 인덱스에 해당하는 레벨에 대한 신호를 그립니다.
  # LEVEL_SIGNALS 배열. LEVEL_SIGNALS 배열이 비어 있으면
  # 레벨의 정수를 그립니다. 마지막으로 LEVEL_ICON은 다음과 같은 배열일 수도 있습니다.
  # 정수, 이 경우 레벨은 아이콘 세트로만 표시됩니다.
  # 배열에서 이에 해당합니다.
  LEVEL_ICON = 125
  
  # LEVEL_ICONS_SPACE - LEVEL_ICON이 정수인 경우 이것은 다음의 양입니다.
  # 아이콘이 그려질 때마다 간격.
  LEVEL_ICONS_SPACE = 16
  
  # LEVEL_SIGNALS - LEVEL_ICON이 0이면 어떤 문자열을 설정할 수 있습니다.
  # 각 레벨에 대한 신호여야 합니다. 이 배열이 비어 있으면
  # 레벨 정수를 그리기만 하면 됩니다. 즉. 퀘스트가 레벨 4인 경우 4를 뽑습니다.
  LEVEL_SIGNALS = ["F", "E", "D", "C", "B", "A", "S"]
  
  #  COLOURS - 이를 통해 다양한 측면의 색상을 변경할 수 있습니다.
  #               퀘스트 장면. 각각은 다음 세 가지 방법 중 하나로 설정할 수 있습니다.
  #    :symbol - 기호를 사용하는 경우 색상은 호출한 결과입니다.
  #               같은 이름의 메소드. 예를 들어 다음과 같이 설정하면
  #               :system_color, Window_Base의 결과로 색상을 설정합니다.
  #               system_color 메소드.
  #    Integer - 색상을 정수로 설정하면
  #               메시지에서 \c[x]를 사용하는 것처럼 윈도우 스킨 팔레트의 색상.
  #    Array - rgba 값을 배열로 직접 설정할 수도 있습니다.
  #               format: [red, green, blue, alpha]. 알파는 제외할 수 있지만
  #               빨강, 초록, 파랑에 대한 값이 있습니다.
  COLOURS = {
    # active: 목록에 있는 활성 퀘스트의 색상과 이름을 설정합니다.
    # 데이터 창에 표시될 때 활성 퀘스트의 입니다.
    active:           :normal_color,
    # complete: 목록에 있는 전체 퀘스트의 색상을 설정하고
    # 데이터 창에 표시될 때 완료된 퀘스트의 이름입니다.
    complete:         3,
    # failed: 이것은 목록에서 실패한 퀘스트의 색상과 이름을 설정합니다.
    # 데이터 창에 표시될 때 실패한 퀘스트의 입니다.
    failed:           10,
    # line:  퀘스트 장면에 그려진 선이나 상자의 색상을 설정합니다.
    line:             :system_color,
    # line_shadow:  그려진 선이나 상자의 그림자 색상을 설정합니다.
    # 퀘스트 씬에서
    line_shadow: [0, 0, 0, 128],
    # scene_label: 표시된 경우 장면 레이블의 색상을 설정합니다.
    scene_label:      :system_color,
    # category_label: 표시된 경우 카테고리 레이블의 색상을 설정합니다.
    category_label:   :normal_color,
    # level_signal: 표시된 경우 레벨 신호의 색상을 설정합니다.
    level_signal:     :normal_color,
    # objective_bullet: 이것은 대물렌즈의 색상을 설정합니다. 로 설정하면
    # :maqj_objective_color, 완료 상태를 반영합니다.
    # 목적이지만 원하는 경우 다른 것으로 변경할 수 있습니다.
    objective_bullet: :maqj_objective_color,
    # reward_amount: 항목 금액의 색상(표시된 경우)
    reward_amount:    :normal_color,
    # heading: "설명"과 같은 스크립트 제목의 색상
    heading:          :system_color,
    # basic_label: 클라이언트와 같은 기본 데이터의 경우 레이블의 색상
    basic_label:      :system_color,
    # basic_value: 클라이언트와 같은 기본 데이터의 경우 값의 색상
    basic_value:      :normal_color,
  }
  
  # HEADING_ALIGN - 나열된 측면에 대한 정렬을 설정합니다. 0은 왼쪽입니다.
  # 1은 센터입니다. 2가 맞다
  HEADING_ALIGN = {
    description: 0, # 설명 제목 정렬
    objectives:  0, # 목표 제목 정렬
    rewards:     1, # 보상 제목 정렬
    level:       2  # 레벨 표시 시 정렬
  }
  
  #````````````````````````````````````````````````````````````````````````````
  #    Font Aspects
  # 
  # 다음 모든 옵션(FONTNAMES, FONTSIZES, FONTBOLDS 및
  # FONTITALICS)의 다양한 측면에 사용되는 글꼴을 변경할 수 있습니다.
  # 장면. 거기에 기본적으로 나열되는 유일한 것은 normal:입니다.
  # 전체 장면에 기본적으로 사용되는 글꼴입니다. 그러나 다음을 변경할 수 있습니다.
  # 거의 모든 측면에 사용할 수 있는 글꼴 - 다음과 같은 행을 추가하기만 하면 됩니다.
  #
  #    description: value,
  #
  # 설명을 그릴 때 글꼴 측면을 변경합니다. NS
  # 변경할 수 있는 기호는 다음과 같습니다.
  #
  #   normal:         The default font used for every part of the scene
  #   list:           The font used in the List Window
  #   scene_label:    The font used when drawing the Scene Label, if shown
  #   category_label: The font used when drawing the Category Label, if shown
  #   heading:        The font used when drawing any headings, like "Description"
  #   name:           The font used when drawing the quest name in data window
  #   description:    The font used when drawing the Description
  #   objectives:     The font used when drawing the objectives
  #   rewards:        The font used when drawing the rewards
  #   client:         The font used when drawing the client
  #   location:       The font used when drawing the location
  #
  # 어느 쪽이든 값을 설정해야 합니다. 가치가 무엇인지에 달려 있습니다.
  # 변경하고 있는 글꼴 측면에 대해 아래에 설명되어 있지만,
  # false로 설정하면 단순히 기본값을 사용한다는 의미입니다.
  #
  # 추가하는 모든 항목의 경우 값 뒤에 쉼표를 넣어야 합니다.
  #````````````````````````````````````````````````````````````````````````````
  # FONTNAMES - 여기에서 다양한 글꼴에 사용되는 글꼴을 변경할 수 있습니다.
  # 옵션. 다음 유형의 값을 사용할 수 있습니다.
  #     false    - 기본 글꼴이 사용됩니다.
  #     "String" - 이름이 "String"인 글꼴이 사용됩니다.
  #     [Array]  - 배열은 ["String1", "String2", ...] 형식이어야 합니다.
  #                사용된 글꼴은 배열의 첫 번째 글꼴이 될 것입니다.
  #                플레이어가 설치되었습니다.
  #
  #  EXAMPLES:
  #
  #    normal:      false,
  #       장면의 변경되지 않은 측면에 사용되는 글꼴은 기본 글꼴입니다.
  #    scene_label: "Algerian",
  #       장면 레이블에 사용된 글꼴은 Algerian입니다.
  #    description: ["Cambria", "Times New Roman"],
  #       설명을 그릴 때 사용된 글꼴은 다음과 같은 경우 Cambria입니다.
  #       플레이어가 Cambria를 설치했습니다. 플레이어에 Cambria가 없는 경우
  #       설치하면 사용되는 글꼴은 Times New Roman이 됩니다.
  FONTNAMES = {
    # normal: false, # normal: the default font name 
    normal: true,
  }
  
  #  FONTSIZES - 여기에서 글꼴 크기를 변경할 수 있습니다. 두 가지 유형이 있습니다
  #              설정할 수 있는 값:
  #    false   - 기본 글꼴 크기가 사용됩니다.
  #    Integer - fontsize는 Integer 값과 같습니다.
  #  
  # 레이블 창을 제외한 모든 항목에 대해 24를 초과해서는 안 됩니다.
  # 은 line_height입니다. 그러나 scene_label: 및 category_label:의 경우 크기
  # 창의 은 글꼴을 설정한 크기로 조정됩니다.
  FONTSIZES = {
    normal:         false, # normal: default font size
    scene_label:    22,    # scene_label: fontsize for the Scene Label window
    category_label: 18,    # category_label: fontsize for Category Label window
  }
  
  # FONTBOLDS - 여기에서 글꼴을 굵게 표시할지 여부를 설정할 수 있습니다. 당신은 설정할 수 있습니다
  #             false로 설정하면 굵게 표시되지 않거나 true로 설정됩니다.
  #             경우 굵게 표시됩니다.
  FONTBOLDS = {
    scene_label:  true, # scene_label: whether font is bold for Scene Label
    heading:      true, # heading: whether font is bold for the headings
    level_signal: true, # level_signal: whether font is bold for level
  }
  
  # FONTITALICS - 여기에서 글꼴을 기울임꼴로 표시할지 여부를 설정할 수 있습니다. 너
  #               false로 설정할 수 있으며 이 경우 기울임꼴로 표시되지 않습니다.
  #               true, 이 경우 기울임꼴로 표시됩니다.
  FONTITALICS = {
  }
  
  CATEGORIES = [:all] if !CATEGORIES || CATEGORIES.empty?
  VOCAB.default = ""
  ICONS.default = 0
  CATEGORY_VOCAB.default = ""
  SORT_TYPE.default = :id
  COLOURS.default = :normal_color
  HEADING_ALIGN.default = 0
  FONTNAMES.default = false
  FONTSIZES.default = false
  FONTBOLDS.default = false
  FONTITALICS.default = false
  
  def self.setup_quest(quest_id)
    q = { objectives: [] }
    case quest_id
    #\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    #  BEGIN Editable Region B
    #||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    #    Quest Setup
    #
    # 게임 내 모든 퀘스트에 대한 데이터를 설정하는 곳입니다. 하는 동안
    # 복잡해 보일 수 있으니 주의를 기울이고 이해가 되면
    # 버릇, 나는 그것이 곧 제2의 천성이 될 것이라고 확신한다.
    #
    # 모든 단일 퀘스트는 다음과 같은 형식으로 설정해야 합니다.
    # 특정 측면에 대해 아무 것도 설정하지 않으면 다음을 수행할 수 있습니다.
    # 해당 줄을 삭제합니다. 어쨌든, 이것은 각 퀘스트의 모양입니다.
    # 왼쪽에 있는 값은 설정하지 않은 경우 기본값입니다.
    #
    #  when quest_id
    #   q[:name]              = "??????"
    #   q[:icon_index]        = 0
    #   q[:level]             = 0
    #   q[:description]       = ""
    #   q[:banner]            = ""
    #   q[:banner_hue]        = 0
    #   q[:objectives][0]     = ""
    #   q[:objectives][1]     = ""
    #   q[:objectives][2]     = ""
    #   q[:objectives][n]     = ""
    #   q[:prime_objectives]  = [0, 1, 2, n]
    #   q[:custom_categories] = []
    #   q[:client]            = ""
    #   q[:location]          = ""
    #   q[:rewards]           = []
    #   q[:common_event_id]   = 0
    #   q[:layout]            = false
    #
    # 목적을 제외하고 각 행에 대해 값만
    # 등호 오른쪽은 변경해야 함을 나타냅니다. 이제 나는 할 것이다
    # 각 줄을 설명합니다.
    #
    # when quest_id
    # quest_id - 는 선택한 정수이며 이것이 당신이
    # 진행하고 다른 작업을 수행하기 위해 퀘스트를 참조하십시오. 그것
    # 모든 퀘스트에 대해 고유해야 합니다. 첫 번째 퀘스트에 1을 사용하면
    # 다른 퀘스트에는 1을 사용할 수 없습니다.
    #
    #   q[:name]              = ""
    #     "" - 이 줄은 퀘스트에 표시되는 퀘스트의 이름을 설정합니다.
    #          목록.
    #   
    #   q[:icon_index]        = 0
    #     0  - 이 줄은 이 퀘스트에 사용할 아이콘을 설정합니다. 그것은 보여줄 것이다
    #          퀘스트 목록에서 퀘스트 이름 왼쪽에 있습니다.
    #
    #   q[:level]             = 0
    #     0  - 이 라인은 퀘스트의 레벨을 설정합니다. 0이면 레벨이 없습니다.
    #          표시됩니다. 자세한 내용은 441-458행의 레벨 옵션을 참조하십시오.
    #   
    #   q[:description]       = ""
    #     "" - 이 줄은 퀘스트에 대한 설명을 설정합니다. 당신은 메시지를 사용할 수 있습니다
    #          이 문자열의 코드이지만 ""를 사용하는 경우 다음을 사용해야 합니다.
    #          \\는 \가 아닌 코드를 식별합니다. 즉. \v[x]가 아니라 \\v[x]입니다.
    #
    #   q[:objectives][0]     = ""
    #   q[:objectives][1]     = ""
    #   q[:objectives][2]     = ""
    #   q[:objectives][n]     = ""
    # 목표는 약간 다릅니다. q[:objectives] 이후에
    # 각 줄에는 대괄호로 묶인 정수가 있습니다.
    #    [n] - 이것은 목표의 ID이며 n은 정수여야 합니다. 아니요
    #          퀘스트는 동일한 ID를 가진 두 개 이상의 목표를 가질 수 있습니다. 이것은
    #          공개, 완료 또는 공개하려는 목표를 식별하는 방법
    #          불합격. 즉, 원하는 만큼 많은 목표를 만들 수 있습니다.
    #          모든 고유한 ID를 제공하는 한. ID는 다음 위치에 있어야 합니다.
    #          시퀀스도 있으므로 q[:objectives][5]가 없어야 합니다.
    #          q[:objectives][4]가 없습니다.
    #     "" - 이것은 목표의 텍스트입니다. 다음에서 메시지 코드를 사용할 수 있습니다.
    #          이 문자열이지만 ""를 사용하는 경우 다음을 사용해야 합니다.
    #          \\는 \가 아닌 코드를 식별합니다. 예: \v[x]가 아니라 \\v[x]입니다.
    #
    #   q[:prime_objectives]  = [0, 1, 2, n]
    #     [0, 1, 2, n] - 이 어레이는 어떤 목표를 달성해야 하는지 결정합니다.
    #                    퀘스트를 완료하기 위해 완료되었습니다. 다시 말해,
    #                    이 배열의 ID를 가진 모든 목표는 다음과 같아야 합니다.
    #                    퀘스트를 완료하려면 완료해야 합니다. 그 중 하나라도 있다면
    #                    실패하면 퀘스트가 실패합니다. 이 줄을 제거하면
    #                    전체적으로 모든 목표가 최우선입니다. 이것을 []로 설정하면,
    #                    그러면 퀘스트가 자동으로 완료되거나 실패하지 않으며
    #                    208-219행에 설명된 수동 옵션을 사용해야 합니다.
    #
    #   q[:custom_categories] = []
    #     [] - 이를 통해 이에 대한 사용자 정의 범주 배열을 설정할 수 있습니다.
    #          퀘스트, 즉 이 퀘스트가 각각의 퀘스트에 표시됨을 의미합니다.
    #          370행의 CATEGORIES 배열에 추가하면 범주입니다.
    #          당신이 만드는 각 카테고리는 고유한
    #          :symbol, 그리고 그에 대한 모든 카테고리 세부 정보를 설정해야 합니다.
    #          :기호.
    #
    #   q[:banner]            = ""
    #     "" - 이 줄은 퀘스트에 사용할 배너를 설정합니다. 그것은 있어야합니다
    #          Graphics의 Pictures 폴더에 있는 이미지의 파일 이름.
    #
    #   q[:banner_hue]        = 0
    #     0 -   배너 그래픽의 색조(사용된 경우)
    #
    #   q[:client]            = ""
    #     "" -  이 줄은 이 퀘스트의 클라이언트 이름을 설정합니다. (기본적인 정보)
    #
    #   q[:location]          = ""
    #     "" -  이 줄은 퀘스트의 위치를 ​​설정합니다. (기본적인 정보)
    #
    #   q[:rewards]           = []
    #    [] - 이 배열에서 다음과 같은 특정 보상을 식별할 수 있습니다.
    #         나타나다. 각 보상은 자체 배열에 있어야 하며 다음 중 하나일 수 있습니다.
    #         다음과 같은:
    #          [:item, ID, n],
    #          [:weapon, ID, n],
    #          [:armor, ID, n],
    #          [:gold, n],
    #          [:exp, n],
    #         여기서 ID는 원하는 아이템, 무기 또는 방어구의 ID입니다.
    #         분배되고 n은 아이템, 무기, 방어구, 골드,
    #         또는 배포하고 싶은 경험. 또한 다음을 설정할 수도 있습니다.
    #         보상 형식으로 표시되지만 표시되지 않는 일부 텍스트
    #         자동 배포됩니다. 해당 유형을 지정해야 합니다.
    #         다음 형식의 보상 텍스트:
    #
    #         [:string, icon_index, "string", "vocab"],
    #         여기서 icon_index는 표시할 아이콘이고 "string"은 표시할 아이콘입니다.
    #         금액으로 표시되고 "vocab"은 다음과 같이 표시됩니다.
    #         아이콘과 금액 사이의 레이블.
    #      
    #
    #   q[:common_event_id]   = 0
    #     0  - 이를 통해 식별된 공통 이벤트를 즉시 호출할 수 있습니다.
    #          퀘스트가 완료되면 자동으로. 그것은 일반적으로
    #          대부분의 퀘스트에서 제어해야 하므로 권장하지 않음
    #          이 기능이 필요하지 않을 정도로.
    #
    #   q[:layout]            = false
    #     false - 기본값은 false이며 false이면
    #             퀘스트의 레이아웃은 설정한 기본값에서 상속됩니다.
    #             그러나 퀘스트 자체 레이아웃을 지정할 수도 있습니다.
    #             형식은 307행에서 기본값으로 설정한 것과 동일합니다.
    #  
    # Template:
    #
    # 신규퀘스트 하실때 복사해서 붙여넣기 하시는걸 추천드립니다
    # 다음 템플릿에서 변경하고 싶지 않은 줄을 제거합니다.
    # 당연히 #~를 제거해야 합니다. 강조 표시하여 그렇게 할 수 있습니다.
    # 전체를 보고 CTRL+Q를 누르면:

#     when 2 # <= REMINDER: The Quest ID MUST be unique
#     q[:name]              = "??????"
#     q[:icon_index]        = 0
#     q[:level]             = 0
#     q[:description]       = ""
#     # REMINDER: You can make as many objectives as you like, but each must 
#     # have a unique ID.
#     q[:objectives][0]     = "" 
#     q[:objectives][1]     = ""
#     q[:objectives][2]     = ""
#     q[:prime_objectives]  = [0, 1, 2]
#     q[:custom_categories] = []
#     q[:banner]            = ""
#     q[:banner_hue]        = 0
#     q[:client]            = ""
#     q[:location]          = ""
#     q[:rewards]           = []
#     q[:common_event_id]   = 0

                when 1
      q[:name]              = " Entregar carne "
      q[:level]             = 1
      q[:icon_index]        = 3892  # Icono de misión de recolección
      q[:description]       = "Últimamente hay muchos clientes y estamos escasos de carne."
      q[:objectives][0]     = "Carne pequeña cruda (\\IT[160]/10)"
      q[:objectives][1]     = "Carne cruda (\\IT[159]/5)"
      q[:prime_objectives]  = [0, 1]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "Jemi"
      q[:location]          = "Seraiton (10,14) - Cazador de osos (Restaurante)"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:item, 161, 5],
        [:item, 320, 2],
        [:gold, 600],
      ]
      q[:layout]            = false

                when 2
      q[:name]              = " Entregar hierro "
      q[:level]             = 1
      q[:icon_index]        = 3892  # Icono de misión de recolección
      q[:description]       = "Últimamente estamos escasos de hierro."
      q[:objectives][0]     = "Mineral de hierro (\\IT[121]/10)"
      q[:prime_objectives]  = [0]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "Gail Lant"
      q[:location]          = "Seraiton (10,14) - Taller de Lant (Herrería)"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:item, 1, 5],
        [:item, 320, 2],
        [:gold, 2500],
      ]
      q[:layout]            = false

                when 3
      q[:name]              = " Entregar setas "
      q[:level]             = 1
      q[:icon_index]        = 3892  # Icono de misión de recolección
      q[:description]       = "Necesitamos muchas setas saborosas para experimentos."
      q[:objectives][0]     = "Seta saborosa (\\IT[155]/10)"
      q[:prime_objectives]  = [0]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "Marly Hent"
      q[:location]          = "Seraiton (10,14)"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:item, 320, 2],
        [:gold, 3000],
      ]
      q[:layout]            = false

                when 4
      q[:name]              = " Entregar piel de oso "
      q[:level]             = 2
      q[:icon_index]        = 3892  # Icono de misión de recolección
      q[:description]       = "Necesitamos piel de oso con urgencia."
      q[:objectives][0]     = "Piel de oso (\\IT[236]/5)"
      q[:prime_objectives]  = [0]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "Helen"
      q[:location]          = "Seraiton (10,14)"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:item, 1, 5],
        [:item, 320, 3],
        [:gold, 26000],
      ]
      q[:layout]            = false

                when 5
      q[:name]              = " Entregar mercancía "
      q[:level]             = 2
      q[:icon_index]        = 266  # Icono de misión de entrega
      q[:description]       = "Hay un paquete para Petron en Palserin (22,12)."
      q[:objectives][0]     = "Recoge el paquete de Lant en el Taller de Lant en Seraiton (10,14)"
      q[:objectives][1]     = "Entrega el paquete a Petron en Palserin (22,12)"
      q[:prime_objectives]  = [0, 1]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "Petron"
      q[:location]          = "Palserin (22,12)"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:item, 320, 3],
        [:gold, 13000],
      ]
      q[:layout]            = false

                when 6
      q[:name]              = " Eliminar slimes (1) "
      q[:level]             = 2
      q[:icon_index]        = 3892  # Icono de misión de recolección
      q[:description]       = "Por favor, elimina los slimes que se están multiplicando y entrega el botín como prueba."
      q[:objectives][0]     = "Núcleo de slime (\\IT[255]/5)"
      q[:objectives][1]     = "Restos de slime (\\IT[256]/10)"
      q[:prime_objectives]  = [0, 1]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "Recepcionista del Gremio de Aventureros"
      q[:location]          = "Gremio de Aventureros"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:item, 320, 3],
        [:item, 2, 10],
        [:item, 202, 3],
        [:gold, 20000],
      ]
      q[:layout]            = false

                when 7
      q[:name]              = " Investigar la cueva de Fikav "
      q[:level]             = 3
      q[:icon_index]        = 115  # Icono de misión de combate
      q[:description]       = "La población de goblins está aumentando. Por favor, averigua la causa."
      q[:objectives][0]     = "Investigar la cueva de Fikav (6,14)"
      q[:objectives][1]     = "Eliminar goblins en la cueva de Fikav (6,14) (\\V[221]/20)"
      q[:prime_objectives]  = [0, 1]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "Recepcionista del Gremio de Aventureros"
      q[:location]          = "Gremio de Aventureros"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:item, 320, 4],
        [:item, 3, 10],
        [:item, 75, 5],
        [:gold, 63000],
      ]
      q[:layout]            = false

                when 8
      q[:name]              = " Eliminar bandidos (1) "
      q[:level]             = 4
      q[:icon_index]        = 115  # Icono de misión de combate
      q[:description]       = "La zona de actividad de los bandidos está creciendo. Por favor, reduce su número."
      q[:objectives][0]     = "Eliminar bandidos (\\V[222]/10)"
      q[:prime_objectives]  = [0]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "Recepcionista del Gremio de Aventureros"
      q[:location]          = "Gremio de Aventureros"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:item, 321, 1],
        [:item, 3, 20],
        [:item, 78, 5],
        [:gold, 130000],
      ]
      q[:layout]            = false

                when 9
      q[:name]              = " Eliminar conejos "
      q[:level]             = 1
      q[:icon_index]        = 3892  # Icono de misión de recolección
      q[:description]       = "Por favor, elimina los conejos y entrega el botín como prueba."
      q[:objectives][0]     = "Piel de conejo (\\IT[231]/10)"
      q[:prime_objectives]  = [0]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "Recepcionista del Gremio de Aventureros"
      q[:location]          = "Gremio de Aventureros"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:item, 320, 2],
        [:item, 2, 10],
        [:armor, 7, 1],
        [:gold, 10000],
      ]
      q[:layout]            = false

                when 10
      q[:name]              = " Eliminar avispas (1) "
      q[:level]             = 1
      q[:icon_index]        = 3892  # Icono de misión de recolección
      q[:description]       = "Por favor, elimina las avispas y entrega el botín como prueba."
      q[:objectives][0]     = "Aguijón de avispa (\\IT[250]/15)"
      q[:prime_objectives]  = [0]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "Recepcionista del Gremio de Aventureros"
      q[:location]          = "Gremio de Aventureros"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:item, 320, 2],
        [:item, 15, 10],
        [:item, 78, 10],
        [:gold, 30000],
      ]
      q[:layout]            = false

                when 11
      q[:name]              = " Verificar la vida de los exploradores (1) "
      q[:level]             = 3
      q[:icon_index]        = 274  # Icono de misión de investigación
      q[:description]       = "Por favor, verifica la vida de los exploradores que entraron a la entrada de la Cueva Aullante (14,12)."
      q[:objectives][0]     = "Verificar la vida de los exploradores"
      q[:objectives][1]     = "Verificar la vida de los exploradores"
      q[:objectives][2]     = "Verificar la vida de los exploradores"
      q[:objectives][3]     = "Verificar la vida de los exploradores"
      q[:prime_objectives]  = [0, 1, 2, 3]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "Recepcionista del Gremio de Aventureros"
      q[:location]          = "Gremio de Aventureros"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:item, 320, 4],
        [:gold, 42000],
      ]
      q[:layout]            = false

                when 12
      q[:name]              = " Recuperar tesoro del escondite subterráneo "
      q[:level]             = 4
      q[:icon_index]        = 3892  # Icono de misión de recolección
      q[:description]       = "Por favor, recupera el tesoro escondido en el Escondite Subterráneo (29,15)."
      q[:objectives][0]     = "Recuperar tesoro del Escondite Subterráneo (29,15)"
      q[:objectives][1]     = "Recuperar tesoro del Escondite Subterráneo (29,15)"
      q[:objectives][2]     = "Recuperar tesoro del Escondite Subterráneo (29,15)"
      q[:prime_objectives]  = [0, 1, 2]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "Lasant"
      q[:location]          = "Bosque de la Anciana (29,15)"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:item, 321, 1],
        [:armor, 55, 1],
        [:gold, 20000],
      ]
      q[:layout]            = false

                when 13
      q[:name]              = " Entregar mercancía "
      q[:level]             = 2
      q[:icon_index]        = 266  # Icono de misión de entrega
      q[:description]       = "Hay un paquete para Lant en Vailas (36,40)."
      q[:objectives][0]     = "Entrega el paquete a Lant en Vailas (36,40)"
      q[:prime_objectives]  = [0]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "Lant"
      q[:location]          = "Vailas (36,40)"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:item, 320, 3],
        [:armor, 185, 1],
        [:gold, 23000],
      ]
      q[:layout]            = false

                when 14
      q[:name]              = " Encontrar al hermano de Sylvie "
      q[:level]             = 2
      q[:icon_index]        = 3892  # Icono de misión de recolección
      q[:description]       = "Por favor, encuentra al hermano de Sylvie, Helen."
      q[:objectives][0]     = "Encuentra a Helen en algún lugar del continente de Ailans"
      q[:objectives][1]     = "Informa a Sylvie sobre Helen"
      q[:prime_objectives]  = [0]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "Sylvie"
      q[:location]          = "Vailas (36,40) - Noche del Conocimiento (Restaurante)"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:item, 320, 3],
        [:gold, 8300],
      ]
      q[:layout]            = false

                when 15
      q[:name]              = " Encontrar a la madre (Ellen) "
      q[:level]             = 5
      q[:icon_index]        = 3632  # Icono de misión principal
      q[:description]       = "¡Encuentra a tu madre (Ellen) desaparecida durante el incidente del portal!"
      q[:objectives][0]     = "Encuentra pistas sobre la madre (Ellen) desaparecida"
      q[:objectives][1]     = "Encuentra pistas sobre la madre (Ellen) desaparecida"
      q[:objectives][2]     = "Encuentra pistas sobre la madre (Ellen) desaparecida"
      q[:objectives][3]     = "Encuentra a la madre (Ellen) en algún lugar del continente de Ailans"
      q[:prime_objectives]  = [0,1,2,3]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "Ellen"
      q[:location]          = "?"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:item, 320, 1],
        [:item, 321, 1],
        [:item, 348, 1],
      ]
      q[:layout]            = false

                when 16
      q[:name]              = " Encontrar a la hermana (Elena) "
      q[:level]             = 5
      q[:icon_index]        = 3632  # Icono de misión principal
      q[:description]       = "¡Encuentra a tu hermana (Elena) desaparecida durante el incidente del portal!"
      q[:objectives][0]     = "Encuentra pistas sobre la hermana (Elena) desaparecida"
      q[:objectives][1]     = "Encuentra pistas sobre la hermana (Elena) desaparecida"
      q[:objectives][2]     = "Encuentra pistas sobre la hermana (Elena) desaparecida"
      q[:objectives][3]     = "Encuentra a la hermana (Elena) en algún lugar del continente de Ailans"
      q[:prime_objectives]  = [0,1,2,3]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "Elena"
      q[:location]          = "?"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:item, 320, 1],
        [:item, 321, 1],
        [:item, 347, 1],
      ]
      q[:layout]            = false

                when 17
      q[:name]              = " Vengar a tu padre (Joey) "
      q[:level]             = 5
      q[:icon_index]        = 3632  # Icono de misión principal
      q[:description]       = "¡Encuentra y elimina al demonio de piel púrpura y cabello plateado que apareció durante el incidente del portal para vengar a tu padre (Joey)!"
      q[:objectives][0]     = "Investiga al demonio de piel púrpura y cabello plateado"
      q[:objectives][1]     = "Investiga al demonio de piel púrpura y cabello plateado"
      q[:objectives][2]     = "Investiga al demonio de piel púrpura y cabello plateado"
      q[:objectives][3]     = "Investiga al demonio de piel púrpura y cabello plateado"
      q[:objectives][4]     = "Mata o sella al demonio de piel púrpura y cabello plateado"
      q[:prime_objectives]  = [0,1,2,3,4]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "?"
      q[:location]          = "?"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:item, 320, 1],
        [:item, 321, 1],
        [:item, 346, 1],
      ]
      q[:layout]            = false

                when 18
      q[:name]              = " Eliminar slimes (2) "
      q[:level]             = 1
      q[:icon_index]        = 115  # Icono de misión de combate
      q[:description]       = "La población de slimes está creciendo exponencialmente y están atacando a los residentes y viajeros. Por favor, elimínalos.\n\\C[10]* Se restablece al cargar la partida o a las 06:00.\\C[0]"
      q[:objectives][0]     = "Eliminar slimes (\\V[223]/20)"
      q[:prime_objectives]  = [0]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "Recepcionista del Gremio de Aventureros"
      q[:location]          = "Gremio de Aventureros"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:item, 320, 2],
        [:item, 443, 2],
        [:gold, 5020],
      ]
      q[:layout]            = false

                when 19
      q[:name]              = " Eliminar slimes (3) "
      q[:level]             = 2
      q[:icon_index]        = 3892  # Icono de misión de recolección
      q[:description]       = "Necesitamos subproductos de slime para la investigación alquímica. Por favor, entrégalos en el gremio si tienes alguno o si puedes recoger más."
      q[:objectives][0]     = "Núcleo de slime (\\IT[255]/5)"
      q[:objectives][1]     = "Restos de slime (\\IT[256]/10)"
      q[:prime_objectives]  = [0, 1]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "Recepcionista del Gremio de Aventureros"
      q[:location]          = "Gremio de Aventureros"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:item, 2, 3],
        [:item, 321, 1],
        [:gold, 9060],
      ]
      q[:layout]            = false

                when 20
      q[:name]              = " Eliminar avispas (2) "
      q[:level]             = 2
      q[:icon_index]        = 115  # Icono de misión de combate
      q[:description]       = "La población de avispas ha aumentado y los residentes tienen dificultades para recolectar y cazar. Por favor, reduce su número."
      q[:objectives][0]     = "Eliminar avispas (\\V[343]/15)"
      q[:prime_objectives]  = [0]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "Recepcionista del Gremio de Aventureros"
      q[:location]          = "Gremio de Aventureros"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:item, 320, 3],
        [:gold, 6010],
      ]
      q[:layout]            = false

                when 21
      q[:name]              = " Eliminar avispas (3) "
      q[:level]             = 2
      q[:icon_index]        = 3892  # Icono de misión de recolección
      q[:description]       = "La acupuntura está de moda, pero estamos escasos de hierro, por lo que necesitamos aguijones de avispas como sustituto. Por favor, entrega los aguijones de avispas en el gremio."
      q[:objectives][0]     = "Aguijón de avispa (\\IT[250]/20)"
      q[:prime_objectives]  = [0]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "Recepcionista del Gremio de Aventureros"
      q[:location]          = "Gremio de Aventureros"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:item, 323, 2],
        [:gold, 7020],
      ]
      q[:layout]            = false

                when 22
      q[:name]              = " Eliminar osos (1) "
      q[:level]             = 2
      q[:icon_index]        = 115  # Icono de misión de combate
      q[:description]       = "La serrería se está retrasando debido a los osos. Uno de los empleados de la serrería está furioso y ha pedido pieles de oso como prueba."
      q[:objectives][0]     = "Eliminar osos (\\V[344]/20)"
      q[:objectives][1]     = "Piel de oso (\\IT[236]/10)"
      q[:prime_objectives]  = [0, 1]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "Recepcionista del Gremio de Aventureros"
      q[:location]          = "Gremio de Aventureros"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:item, 38, 2],
        [:item, 136, 10],
        [:item, 322, 1],
        [:item, 323, 3],
        [:gold, 603000],
      ]
      q[:layout]            = false

                when 23
      q[:name]              = " Eliminar osos (2) "
      q[:level]             = 2
      q[:icon_index]        = 3892  # Icono de misión de recolección
      q[:description]       = "La demanda de pieles de oso ha aumentado recientemente, por lo que necesitamos más. Por favor, entrega las pieles de oso en el gremio."
      q[:objectives][0]     = "Piel de oso (\\IT[236]/15)"
      q[:prime_objectives]  = [0]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "Recepcionista del Gremio de Aventureros"
      q[:location]          = "Gremio de Aventureros"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:item, 322, 1],
        [:item, 323, 3],
        [:gold, 100000],
      ]
      q[:layout]            = false

                when 24
      q[:name]              = " Entregar hierbas "
      q[:level]             = 2
      q[:icon_index]        = 3892  # Icono de misión de recolección
      q[:description]       = "Necesitamos algunas hierbas venenosas Ceratum para la alquimia. El alquimista ha pedido estas hierbas porque el exterior es peligroso."
      q[:objectives][0]     = "Hierbas venenosas Ceratum (\\IT[112]/15)"
      q[:prime_objectives]  = [0]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "Recepcionista del Gremio de Aventureros"
      q[:location]          = "Gremio de Aventureros"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:item, 1, 3],
        [:item, 16, 2],
        [:item, 320, 1],
        [:item, 2, 5],
        [:item, 7, 2],
        [:gold, 3000],
      ]
      q[:layout]            = false

                when 25
      q[:name]              = " Entregar minerales "
      q[:level]             = 2
      q[:icon_index]        = 3892  # Icono de misión de recolección
      q[:description]       = "El suministro de denverita se está retrasando debido al aumento de monstruos. Los aventureros o residentes que puedan resolver este problema serán recompensados."
      q[:objectives][0]     = "Denverita (\\IT[126]/10)"
      q[:prime_objectives]  = [0]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "Recepcionista del Gremio de Aventureros"
      q[:location]          = "Gremio de Aventureros"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:armor, 31, 1],
        [:armor, 129, 1],
        [:gold, 3500],
      ]
      q[:layout]            = false

                when 26
      q[:name]              = " Reclutamiento de cazadores (1) "
      q[:level]             = 2
      q[:icon_index]        = 3892  # Icono de misión de recolección
      q[:description]       = "¡Necesitamos carne, tanta como sea posible!"
      q[:objectives][0]     = "Carne cruda (\\IT[159]/15)"
      q[:objectives][1]     = "Carne pequeña cruda (\\IT[160]/15)"
      q[:prime_objectives]  = [0, 1]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "Recepcionista del Gremio de Aventureros"
      q[:location]          = "Gremio de Aventureros"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:item, 191, 1],
        [:armor, 193, 1],
        [:gold, 5000],
      ]
      q[:layout]            = false

                when 27
      q[:name]              = " Preparativos para el invierno "
      q[:level]             = 2
      q[:icon_index]        = 3892  # Icono de misión de recolección
      q[:description]       = "Necesitamos pieles para prepararnos para el invierno. Las pieles de conejo serán suficientes, por favor ayúdanos."
      q[:objectives][0]     = "Piel de conejo (\\IT[231]/5)"
      q[:prime_objectives]  = [0]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "Recepcionista del Gremio de Aventureros"
      q[:location]          = "Gremio de Aventureros"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:armor, 21, 1],
        [:gold, 2380],
      ]
      q[:layout]            = false

                when 28
      q[:name]              = " Reclutamiento de cazadores (2) "
      q[:level]             = 2
      q[:icon_index]        = 115  # Icono de misión de combate
      q[:description]       = "Las salchichas de ciervo se han vuelto populares últimamente. El gremio solicita a los aventureros que cacen ciervos y recojan carne para asegurarse de que la oferta sea suficiente. También hay un aumento en la población de ciervos debido a anomalías recientes en el portal."
      q[:objectives][0]     = "Eliminar ciervos (\\V[345]/10)"
      q[:objectives][1]     = "Carne cruda (\\IT[159]/20)"
      q[:prime_objectives]  = [0, 1]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "Recepcionista del Gremio de Aventureros"
      q[:location]          = "Gremio de Aventureros"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:item, 323, 2],
        [:gold, 8095],
      ]
      q[:layout]            = false

                when 29
      q[:name]              = " Eliminar goblins (1) "
      q[:level]             = 2
      q[:icon_index]        = 115  # Icono de misión de combate
      q[:description]       = "Se han visto pequeños grupos de goblins cerca de las cuevas y los bosques. Por favor, elimínalos. Especialmente las aventureras deben tener cuidado, hay rumores recientes de que están siendo llevadas a sus guaridas.\n\\C[10]* Se restablece al cargar la partida o a las 06:00.\\C[0]"
      q[:objectives][0]     = "Eliminar goblins (\\V[346]/10)"
      q[:prime_objectives]  = [0]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "Recepcionista del Gremio de Aventureros"
      q[:location]          = "Gremio de Aventureros"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:item, 436, 1],
        [:item, 440, 1],
        [:item, 322, 1],
        [:gold, 10900],
      ]
      q[:layout]            = false

                when 30
      q[:name]              = " Entrega de líquido blanco "
      q[:level]             = 1
      q[:icon_index]        = 3892  # Icono de misión de recolección
      q[:description]       = "El alquimista necesita... un líquido blanco de goblin. Por cierto, también se acepta el líquido blanco de un hombre."
      q[:objectives][0]     = "Líquido blanco (\\IT[268]/10)"
      q[:prime_objectives]  = [0]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "Recepcionista del Gremio de Aventureros"
      q[:location]          = "Gremio de Aventureros"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:item, 13, 1],
        [:item, 205, 4],
        [:item, 320, 2],
        [:item, 321, 1],
        [:item, 3, 5],
        [:item, 5, 3],
        [:gold, 6000],
      ]
      q[:layout]            = false

                when 31
      q[:name]              = " Eliminar arañas (1) "
      q[:level]             = 2
      q[:icon_index]        = 115  # Icono de misión de combate
      q[:description]       = "Recientemente, se ven esas criaturas repugnantes en los caminos y bosques. Por favor, mátenlas. Los trabajadores no pueden hacer su trabajo por culpa de esas criaturas, así que eliminen tantas como sea posible lo antes posible."
      q[:objectives][0]     = "Eliminar pequeñas Tarantectas (\\V[347]/15)"
      q[:prime_objectives]  = [0]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "Recepcionista del Gremio de Aventureros"
      q[:location]          = "Gremio de Aventureros"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:item, 216, 6],
        [:item, 224, 2],
        [:item, 320, 1],
        [:item, 321, 1],
        [:gold, 20000],
      ]
      q[:layout]            = false

                when 32
      q[:name]              = " Eliminar arañas (2) "
      q[:level]             = 2
      q[:icon_index]        = 115  # Icono de misión de combate
      q[:description]       = "Se rumorea que los goblins están criando arañas. Para prevenir problemas, por favor reduzcan su número.\n\\C[10]* Se restablece al cargar la partida o a las 06:00.\\C[0]"
      q[:objectives][0]     = "Eliminar pequeñas Tarantectas (\\V[348]/15)"
      q[:prime_objectives]  = [0]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "Recepcionista del Gremio de Aventureros"
      q[:location]          = "Gremio de Aventureros"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:item, 3, 2],
        [:item, 320, 3],
        [:item, 321, 1],
        [:item, 443, 3],
        [:gold, 22000],
      ]
      q[:layout]            = false

                when 33
      q[:name]              = " Eliminar bandidos (1) "
      q[:level]             = 3
      q[:icon_index]        = 115  # Icono de misión de combate
      q[:description]       = "Hay una solicitud para reducir el número de bandidos que han aparecido recientemente en Ailo, Krotsvalt y Serat. Aunque es una misión difícil, se ofrece una gran recompensa. Pedimos a los aventureros que acepten esta misión.\n\\C[10]* Se restablece al cargar la partida o a las 06:00.\\C[0]"
      q[:objectives][0]     = "Eliminar bandidos (\\V[349]/20)"
      q[:prime_objectives]  = [0]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "Recepcionista del Gremio de Aventureros"
      q[:location]          = "Gremio de Aventureros"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:item, 437, 1],
        [:item, 441, 1],
        [:item, 3, 5],
        [:item, 321, 1],
        [:item, 322, 1],
        [:item, 443, 5],
        [:gold, 108020],
      ]
      q[:layout]            = false

                when 34
      q[:name]              = " Trata de personas "
      q[:level]             = 4
      q[:icon_index]        = 115  # Icono de misión de combate
      q[:description]       = "Recientemente, ha habido secuestros en Darwin, Palserin y Serat. Parece ser obra de bandidos, así que por favor elimínenlos y rescaten a los secuestrados. Hay riesgo de ser capturado y convertido en esclavo, así que solo aventureros con habilidades deben aceptar.\n\\C[10]* Se restablece al cargar la partida o a las 06:00.\\C[0]"
      q[:objectives][0]     = "Eliminar bandidos (\\V[350]/10)"
      q[:objectives][1]     = "Rescatar a los sobrevivientes (\\V[351]/3)"
      q[:prime_objectives]  = [0, 1]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "Recepcionista del Gremio de Aventureros"
      q[:location]          = "Gremio de Aventureros"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:item, 3, 5],
        [:item, 6, 2],
        [:item, 320, 1],
        [:item, 321, 1],
        [:item, 322, 1],
        [:item, 443, 4],
        [:gold, 129060],
      ]
      q[:layout]            = false

                when 35
      q[:name]              = " Eliminar orcos en celo (1) "
      q[:level]             = 4
      q[:icon_index]        = 115  # Icono de misión de combate
      q[:description]       = "Recientemente, debido a la influencia del portal, los orcos se han puesto en celo y están atacando a hombres y mujeres. Por favor, elimínenlos para mantener el orden."
      q[:objectives][0]     = "Eliminar orcos (\\V[352]/10)"
      q[:prime_objectives]  = [0]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "Recepcionista del Gremio de Aventureros"
      q[:location]          = "Gremio de Aventureros"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:item, 321, 1],
        [:item, 322, 1],
        [:item, 323, 2],
        [:gold, 106974],
      ]
      q[:layout]            = false

                when 36
      q[:name]              = " ¡Waaagh! "
      q[:level]             = 4
      q[:icon_index]        = 115  # Icono de misión de combate
      q[:description]       = "Parece que un extraño orco negro está liderando orcos y goblins, según el informe del caballero. Por favor, elimínenlos.\nCuriosamente, grita 'Waaagh' mientras se mueve. Se dice que convierte en carne a hombres y mujeres, y es un sujeto de estudio para los académicos."
      q[:objectives][0]     = "Eliminar orco negro (\\V[353]/1)"
      q[:objectives][1]     = "Eliminar orcos (\\V[354]/4)"
      q[:objectives][2]     = "Eliminar goblins (\\V[355]/6)"
      q[:prime_objectives]  = [0, 1, 2]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "Recepcionista del Gremio de Aventureros"
      q[:location]          = "Gremio de Aventureros"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:item, 322, 2],
        [:item, 323, 5],
        [:gold, 200000],
      ]
      q[:layout]            = false

                when 37
      q[:name]              = " Eliminar bandidos (2) "
      q[:level]             = 4
      q[:icon_index]        = 115  # Icono de misión de combate
      q[:description]       = "Un grupo de bandidos está robando dinero a los comerciantes. Los caballeros han solicitado la ayuda de aventureros debido a la falta de personal. Por favor, elimínenlos lo antes posible. Se dice que uno de ellos es muy habilidoso, así que tengan cuidado."
      q[:objectives][0]     = "Eliminar bandidos (\\V[356]/20)"
      q[:objectives][1]     = "Eliminar jefe de bandidos (\\V[357]/1)"
      q[:prime_objectives]  = [0, 1]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "Recepcionista del Gremio de Aventureros"
      q[:location]          = "Gremio de Aventureros"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:item, 130, 5],
        [:item, 322, 3],
        [:item, 323, 5],
        [:gold, 230000],
      ]
      q[:layout]            = false

                when 38
      q[:name]              = " Detener la invasión de orcos "
      q[:level]             = 5
      q[:icon_index]        = 115  # Icono de misión de combate
      q[:description]       = "Se ha detectado un gran movimiento de orcos. Por favor, deténganlos hasta que lleguen los refuerzos.\n\\C[10]* Esta misión se trasladará y procederá a una zona donde no se puede guardar inmediatamente después de aceptarla.\\C[0]"
      q[:objectives][0]     = "Detener a los orcos hasta que lleguen los refuerzos"
      q[:prime_objectives]  = [0]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "Gailex"
      q[:location]          = "Puerta Sur de Herson (19,72)"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:item, 436, 3],
        [:item, 440, 3],
        [:item, 454, 20],
        [:item, 322, 5],
        [:gold, 100000],
      ]
      q[:layout]            = false

                when 39
      q[:name]              = " Rescate de Dwali "
      q[:level]             = 3
      q[:icon_index]        = 115  # Icono de misión de combate
      q[:description]       = "¡Ayuda! ¡He caído en una trampa y estoy atrapado en esta maldita habitación! Si me rescatas, te daré el tesoro que he encontrado e información sobre una habitación oculta en este alcantarillado."
      q[:objectives][0]     = "Rescate de Dwali"
      q[:prime_objectives]  = [0]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "Dwali"
      q[:location]          = "Alcantarillado (44,33)"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:item, 520, 10],
        [:item, 528, 5],
        [:item, 145, 1],
        [:item, 144, 2],
        [:gold, 10000],
      ]
      q[:layout]            = false

                when 40
      q[:name]              = " Verificar la vida de los exploradores (2) "
      q[:level]             = 5
      q[:icon_index]        = 274  # Icono de misión de investigación
      q[:description]       = "Por favor, verifica la vida de los exploradores que entraron en la base de Verbial (31,12)."
      q[:objectives][0]     = "Verificar la vida de los exploradores"
      q[:objectives][1]     = "Verificar la vida de los exploradores"
      q[:objectives][2]     = "Verificar la vida de los exploradores"
      q[:objectives][3]     = "Verificar la vida de los exploradores"
      q[:prime_objectives]  = [0, 1, 2, 3]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "Recepcionista del Gremio de Aventureros"
      q[:location]          = "Gremio de Aventureros"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:item, 322, 2],
        [:item, 323, 1],
        [:gold, 96000],
      ]
      q[:layout]            = false

                when 41
      q[:name]              = " Verificar la vida de los exploradores (3) "
      q[:level]             = 3
      q[:icon_index]        = 274  # Icono de misión de investigación
      q[:description]       = "Por favor, verifica la vida de los exploradores que entraron en la Cueva Profana (50,19)."
      q[:objectives][0]     = "Verificar la vida de los exploradores"
      q[:objectives][1]     = "Verificar la vida de los exploradores"
      q[:objectives][2]     = "Verificar la vida de los exploradores"
      q[:objectives][3]     = "Verificar la vida de los exploradores"
      q[:prime_objectives]  = [0, 1, 2, 3]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "Recepcionista del Gremio de Aventureros"
      q[:location]          = "Gremio de Aventureros"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:item, 321, 1],
        [:item, 185, 1],
        [:gold, 35000],
      ]
      q[:layout]            = false

                when 42
      q[:name]              = " Experimento mágico de Sacha (1) "
      q[:level]             = 2
      q[:icon_index]        = 274  # Icono de misión de investigación
      q[:description]       = "Por favor, ayuda en el experimento de teletransporte de Sacha."
      q[:objectives][0]     = "Participar en el experimento de teletransporte"
      q[:prime_objectives]  = [0]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "Sacha"
      q[:location]          = "Slain (43,29) - La lámpara de Sacha (Tienda de magia)"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:gold, 40000],
      ]
      q[:layout]            = false

                when 43
      q[:name]              = " Recoger trampas "
      q[:level]             = 1
      q[:icon_index]        = 3892  # Icono de misión de recolección
      q[:description]       = "Por favor, recoge las trampas que han sido colocadas indiscriminadamente y abandonadas.\n\\C[10]* Solo se consideran las trampas recogidas con el botón Z.\\C[0]"
      q[:objectives][0]     = "Recoger trampas (\\V[358]/30)"
      q[:prime_objectives]  = [0]
      q[:custom_categories] = []
      q[:banner]            = ""
      q[:banner_hue]        = 0
      q[:client]            = "Recepcionista del Gremio de Aventureros"
      q[:location]          = "Gremio de Aventureros"
      q[:common_event_id]   = 0
      q[:rewards]           = [
        [:item, 202, 3],
        [:item, 322, 2],
        [:item, 323, 1],
        [:gold, 40000],
      ]
      q[:layout]            = false
    #||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    #  END Editable Region B
    #//////////////////////////////////////////////////////////////////////
    end
    q
  end
end

#==============================================================================
# *** DataManager
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  Summary of Changes:
#    aliased method - self.extract_save_contents
#==============================================================================

class << DataManager
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Extract Save Contents
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  alias maqj_extractsavecons_2kw5 extract_save_contents
  def extract_save_contents(*args, &block)
    maqj_extractsavecons_2kw5(*args, &block) # Call Original Method
    if $game_party.quests.nil?
      $game_party.init_maqj_data
      $game_system.init_maqj_data
    end
  end
end

#==============================================================================
# ** MAQJ_SortedArray
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  This module mixes in to an array to maintain the sorted order when inserting
#==============================================================================

module MAQJ_SortedArray
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Insert to Array
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def maqj_insert_sort(el, &block)
    index = bsearch_index(el, 0, size, &block)
    index ? insert(index, el) : push(el)
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Retrieve Index from Binary Search
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def bsearch_index(el, b = 0, e = size, &block)
    return bsearch_index(el, b, e) { |a,b| a <=> b } if block.nil?
    return b if b == e # Return the discovered insertion index
    return if b > e
    m = (b + e) / 2    # Get Middle
    block.call(el, self[m]) > 0 ? b = m + 1 : e = m 
    bsearch_index(el, b, e, &block) 
  end
end

#==============================================================================
# ** Game_Quest
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  This class holds all instance data for a quest
#==============================================================================

class Game_Quest
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Public Instance Variables
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  attr_reader   :id                  # Unique identifier for this quest
  attr_reader   :name                # The name to be shown for the quest
  attr_reader   :level               # The level of difficulty of the quest
  attr_reader   :objectives          # An array of objective strings
  attr_reader   :prime_objectives    # An array of crucial objective IDs
  attr_reader   :revealed_objectives # An array of revealed objective IDs
  attr_reader   :complete_objectives # An array of completed objective IDs
  attr_reader   :failed_objectives   # An array of failed objective IDs
  attr_reader   :custom_categories   # An array of category symbols
  attr_accessor :icon_index          # Icon associated with this quest
  attr_accessor :common_event_id     # ID of common event to call upon complete
  attr_accessor :description         # The description for the quest
  attr_accessor :banner              # Picture shown to represent the quest
  attr_accessor :banner_hue          # The hue of the banner
  attr_accessor :layout              # The layout of this quest in scene
  attr_accessor :rewards             # An array of rewards to show
  attr_accessor :reward_given        # Boolean tracking if quest was rewarded
  attr_accessor :concealed           # Whether or not the quest is visible
  attr_accessor :manual_status       # Quest status if not using prime objectives
  QuestData::BASIC_DATA_TYPES.each { |data_type| attr_accessor(data_type) }
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Object Initialization
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def initialize(quest_id)
    @id = quest_id
    @concealed = default_value_for(:concealed)
    @reward_given = default_value_for(:reward_given)
    reset
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Reset
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def reset
    data = QuestData.setup_quest(@id)
    data_symbol_array.each { |meth| instance_variable_set(:"@#{meth}", 
      data[meth] ? data[meth] : default_value_for(meth)) }
    @revealed_objectives = [].send(:extend, MAQJ_SortedArray)
    @complete_objectives = [].send(:extend, MAQJ_SortedArray)
    @failed_objectives =   [].send(:extend, MAQJ_SortedArray)
    @manual_status = default_value_for(:manual_status)
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Data Symbol Array
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def data_symbol_array
    [:name, :level, :objectives, :prime_objectives, :custom_categories, 
      :icon_index, :description, :banner, :banner_hue, :common_event_id, 
      :layout, :rewards] + QuestData::BASIC_DATA_TYPES
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Default Value
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def default_value_for(method)
    case method
    when :name then "??????"
    when :description, :banner then ""
    when :level, :banner_hue, :icon_index, :common_event_id then 0
    when :objectives, :rewards, :custom_categories then []
    when :prime_objectives then Array.new(objectives.size) { |x| x }
    when :concealed then QuestData::MANUAL_REVEAL
    when :manual_status then :active
    when :layout, :reward_given then false
    else ""
    end
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Reveal/Conceal Objective
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def reveal_objective(*obj)
    valid_obj = obj.select {|x| x < objectives.size && !@revealed_objectives.include?(x) }
    valid_obj.each {|i| @revealed_objectives.maqj_insert_sort(i) }
    quest_status_changed unless valid_obj.empty?
  end
  def conceal_objective(*obj)
    quest_status_changed unless (obj & @revealed_objectives).empty?
    obj.each { |obj_id| @revealed_objectives.delete(obj_id) }
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Complete/Uncomplete Objective
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def complete_objective(*obj)
    valid_obj = obj.select {|x| x < objectives.size && !@complete_objectives.include?(x) }
    reveal_objective(*valid_obj)
    unfail_objective(*valid_obj)
    was_complete = status?(:complete)
    valid_obj.each {|i| @complete_objectives.maqj_insert_sort(i) }
    quest_status_changed unless valid_obj.empty?
    # If just completed
    if status?(:complete) && !was_complete
      # 커먼 이벤트 자동 실행 취소
      #$game_temp.reserve_common_event(common_event_id)
      $game_party.quests.add_to_sort_array(:complete, @id)
    end
  end
  def uncomplete_objective(*obj)
    quest_status_changed unless (obj & @complete_objectives).empty?
    obj.each { |obj_id| @complete_objectives.delete(obj_id) }
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Fail/Unfail Objective
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def fail_objective(*obj)
    valid_obj = obj.select {|x| x < objectives.size && !@failed_objectives.include?(x) }
    reveal_objective(*valid_obj)
    uncomplete_objective(*valid_obj)
    was_failed = status?(:failed)
    valid_obj.each {|i| @failed_objectives.maqj_insert_sort(i) }
    quest_status_changed unless valid_obj.empty?
    $game_party.quests.add_to_sort_array(:failed, @id) if status?(:failed) && !was_failed
  end
  def unfail_objective(*obj)
    quest_status_changed unless (obj & @failed_objectives).empty?
    obj.each { |obj_id| @failed_objectives.delete(obj_id) }
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Updates when the quest status has been changed
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def quest_status_changed
    $game_party.quests.add_to_sort_array(:change, @id) 
    $game_system.last_quest_id = @id if QuestData::OPEN_TO_LAST_CHANGED_QUEST
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Objective Status?
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def objective_status?(status_check, *obj)
    return false if obj.empty?
    case status_check
    when :failed   then !(obj & @failed_objectives).empty?
    when :complete then obj.size == (obj & @complete_objectives).size
    when :revealed then obj.size == (obj & @revealed_objectives).size
    when :active then objective_status?(:revealed, *obj) && 
      !objective_status?(:complete, *obj) && !objective_status?(:failed, *obj)
    end
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Status?
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def status?(status_check)
    case status_check
    when :failed  
      @prime_objectives.empty? ? @manual_status == :failed : 
        !(@failed_objectives & @prime_objectives).empty?
    when :complete
      @prime_objectives.empty? ? @manual_status == :complete : !status?(:failed) && 
        ((@prime_objectives & @complete_objectives) == @prime_objectives)
    when :active then !concealed && !status?(:complete) && !status?(:failed)
    when :reward then @reward_given
    end
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Set Name
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def name=(new_name)
    @name = new_name
    $game_party.quests.add_to_sort_array(:alphabet, @id) if $game_party && 
      $game_party.quests
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Set Level
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def level=(new_lvl)
    @level = new_lvl
    $game_party.quests.add_to_sort_array(:level, @id) if $game_party && 
      $game_party.quests
  end
end

#==============================================================================
# ** Game_Quests 
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  This is a wrapper for an array holding Game_Quest objects
#==============================================================================

class Game_Quests
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Object Initialization
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def initialize
    @data = {}
    @sort_arrays = {
      reveal: [], change: [], complete: [], failed: [],
      id:       [].send(:extend, MAQJ_SortedArray),
      alphabet: [].send(:extend, MAQJ_SortedArray),
      level:    [].send(:extend, MAQJ_SortedArray)
    }
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Get Quest
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def [](quest_id)
    reset_quest(quest_id) if !@data[quest_id]
    @data[quest_id]
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Set Quest <- 이것이 언제 유용할지 확실하지 않습니다.
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def []=(quest_id, value)
    @data[quest_id] = value
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * List
  #    list_type : 반환할 목록의 유형
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def list(list_type = :all, sort_type = $game_system.quest_sort_type[list_type])
    sort_type_s = sort_type.to_s
    reverse = !(sort_type_s.sub!(/_r$/, "")).nil?
    sort_type = sort_type_s.to_sym
    list = @sort_arrays[sort_type].select { |quest_id| include?(quest_id, list_type) }
    list.reverse! if reverse
    list.collect { |quest_id| @data[quest_id] }
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Include?
  #    목록 유형에 따라 특정 퀘스트를 포함할지 여부를 결정합니다.
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def include?(quest_id, list_type = :all)
    return false if !revealed?(quest_id)
    case list_type
    when :all then true
    when :complete, :failed, :active then @data[quest_id].status?(list_type)
    else
      @data[quest_id].custom_categories.include?(list_type)
    end
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Revealed? 
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def revealed?(quest_id)
    (!@data[quest_id].nil? && !@data[quest_id].concealed)
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Setup Quest
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def setup_quest(quest_id)
    return if @data[quest_id]
    @data[quest_id] = Game_Quest.new(quest_id)
    # 다음에 QJ가 열릴 때 이 퀘스트를 열 수 있습니다.
    $game_system.last_quest_id = quest_id if QuestData::OPEN_TO_LAST_REVEALED_QUEST
    # 매번 다시 정렬하지 않도록 별도의 배열에 정렬 순서를 저장합니다.
    @sort_arrays.keys.each { |sym| add_to_sort_array(sym, quest_id) }
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Delete Quest
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def delete_quest(quest_id)
    @data.delete(quest_id)
    @sort_arrays.values.each { |ary| ary.delete(quest_id) }
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Reset Quest
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def reset_quest(quest_id)
    delete_quest(quest_id)
    setup_quest(quest_id)
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Add to Sorted Array
  #    sort_type : array to alter
  #    quest_id  : ID of the quest to add.
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def add_to_sort_array(sort_type, quest_id)
    @sort_arrays[sort_type].delete(quest_id) # Make sure always unique
    case sort_type
    when :reveal, :change, :complete, :failed
      @sort_arrays[sort_type].unshift(quest_id)
    when :id
      @sort_arrays[sort_type].maqj_insert_sort(quest_id)
    when :alphabet 
      @sort_arrays[sort_type].maqj_insert_sort(quest_id) { |a, b| @data[a].name.downcase <=> @data[b].name.downcase }
    when :level
      @sort_arrays[sort_type].maqj_insert_sort(quest_id) { |a, b| @data[a].level <=> self[b].level }
    end
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Find Location
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def find_location(quest_id, cat = nil)
    if revealed?(quest_id)
      categories = $game_system.quest_categories.dup
      # If cat specified, check in that category first.
      if cat && categories.include?(cat)
        categories.delete(cat)
        categories.unshift(cat)
      end
      for category in categories # Check all categories
        index = list(category).index(@data[quest_id])
        return category, index if index != nil
      end
    end
    return nil, nil
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Clear
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def clear
    @data.clear
  end
end

#==============================================================================
# ** Game System
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  Summary of Changes:
#    new attr_accessor - quest_menu_access; quest_map_access; quest_sort_type;
#      quest_bg_picture; quest_bg_opacity; quest_windowskin; 
#      quest_window_opacity; quest_access_disabled; last_quest_cat; 
#      last_quest_id
#    aliased methods - initialize
#    new methods - init_maqj_data
#==============================================================================

class Game_System
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Public Instance Variables
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  attr_reader   :quest_menu_access     # Whether the scene is called from menu
  attr_accessor :quest_map_access      # Whether the scene is called from map
  attr_accessor :quest_sort_type       # The sort types for each category
  attr_accessor :quest_bg_picture      # The filename of the background picture
  attr_accessor :quest_bg_opacity      # The opacity of the background picture
  attr_accessor :quest_bg_blend_type   # The blend type of the background pic
  attr_accessor :quest_windowskin      # The windowskin used for the scene
  attr_accessor :quest_window_tone     # The tone of windows in the scene
  attr_accessor :quest_window_opacity  # The opacity of windows in the scene
  attr_accessor :quest_access_disabled # Whether access to Quests is disabled
  attr_accessor :quest_categories      # The categories to show in the scene
  attr_accessor :quest_scene_label     # The label to show in the scene
  attr_accessor :last_quest_cat        # The category to open to
  attr_accessor :last_quest_id         # The ID to open to
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Object Initialization
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  alias maqj_initialze_2cy9 initialize
  def initialize(*args, &block)
    maqj_initialze_2cy9(*args, &block)
    init_maqj_data
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Initialize Quest Data
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def init_maqj_data
    # Initialize new variables
    self.quest_menu_access = QuestData::MENU_ACCESS
    @quest_map_access = QuestData::MAP_ACCESS
    @quest_sort_type = QuestData::SORT_TYPE
    @quest_bg_picture = QuestData::BG_PICTURE
    @quest_bg_opacity = QuestData::BG_OPACITY
    @quest_bg_blend_type = QuestData::BG_BLEND_TYPE
    @quest_windowskin = QuestData::WINDOWSKIN
    @quest_window_tone = QuestData::WINDOW_TONE
    @quest_window_opacity = QuestData::WINDOW_OPACITY
    @quest_access_disabled = false
    @quest_categories = QuestData::CATEGORIES
    @quest_scene_label = QuestData::VOCAB[:scene_label]
    @last_quest_cat = @quest_categories[0]
    @last_quest_id = 0
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Set Quest Menu Access
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def quest_menu_access=(boolean)
    @quest_menu_access = boolean
    maic_inserted_menu_commands.delete(:quest_journal)
    maic_inserted_menu_commands.push(:quest_journal) if @quest_menu_access
    maic_inserted_menu_commands.sort!
  end
end

#==============================================================================
# ** Game_Party
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  Summary of Changes:
#    new attr_reader - quests
#    aliased method - initialize
#    new method - init_maqj_data
#==============================================================================

class Game_Party
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Public Instance Variables
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  attr_reader :quests
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Object Initialization
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  alias maqj_intiaze_2si9 initialize
  def initialize(*args, &block)
    maqj_intiaze_2si9(*args, &block) # Call Original Method
    init_maqj_data
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Initialize Quests
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def init_maqj_data
    @quests = Game_Quests.new # Initialize @quests
  end
end

#==============================================================================
# ** Game_Interpreter
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  Summary of Changes:
#    new methods - change_quest_access; change_quest_background;
#      change_quest_windows; setup_quest; delete_quest; reset_quest; quest; 
#      reveal_quest; conceal_quest; manually_complete_quest;
#      manually_fail_quest; reveal_objective; conceal_objective; 
#      complete_objective; uncomplete_objective; fail_objective; 
#      unfail_objective; quest_revealed?; quest_complete?; quest_active?; 
#      quest_failed?; objective_complete?; objective_active?; 
#      objective_failed?; distribute_quest_rewards; distribute_quest_reward;
#      call_quest_journal
#==============================================================================

class Game_Interpreter
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Change Quest Access
  #    sym : symbol representing what aspect of access is being changed
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def change_quest_access(sym)
    case sym
    when :enable then $game_system.quest_access_disabled = false
    when :disable then $game_system.quest_access_disabled = true
    when :enable_menu then $game_system.quest_menu_access = true 
    when :disable_menu then $game_system.quest_menu_access = false 
    when :enable_map then $game_system.quest_map_access = true 
    when :disable_map then $game_system.quest_map_access = false 
    end
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Change Quest Background
  #    picture : picture to show in the scene's background
  #    opacity : opacity of the picture shown in the scene's background
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def change_quest_background(picture, opacity = $game_system.quest_bg_opacity,
      blend_type = $game_system.quest_bg_blend_type)
    $game_system.quest_bg_picture = picture
    $game_system.quest_bg_opacity = opacity
    $game_system.quest_bg_blend_type = blend_type
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Change Quest Windows
  #    skin    : windowskin name to use in the scene
  #    tone    : tone for the windowskin
  #    opacity : opacity of windows in the scene
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def change_quest_windows(skin, tone = $game_system.quest_window_tone, 
      opacity = $game_system.quest_window_opacity)
    $game_system.quest_windowskin = skin
    $game_system.quest_window_tone = tone
    $game_system.quest_window_opacity = opacity
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Setup/Delete/Reset Quest
  #    quest_id : 설정 또는 삭제 또는 재설정할 퀘스트의 ID
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  [:setup_quest, :delete_quest, :reset_quest].each { |method|
    define_method(:"quest_#{method}") do |quest_id| 
      $game_party.quests.send(method, quest_id)
    end
  }
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Retrieve Quest
  #    quest_id : 검색할 퀘스트의 ID
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def quest(quest_id);         $game_party.quests[quest_id];      end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Reveal/Conceal Quest 
  #    quest_id : ID of the quest to be revealed or concealed
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def reveal_quest(quest_id);  quest(quest_id).concealed = false; end
  def conceal_quest(quest_id); quest(quest_id).concealed = true;  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Manually Complete/Fail Quest 
  #    quest_id : ID of the quest to be revealed or concealed
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def manually_complete_quest(quest_id)
    quest(quest_id).prime_objectives.clear
    quest(quest_id).manual_status = :complete
  end
  def manually_fail_quest(quest_id)
    quest(quest_id).prime_objectives.clear
    quest(quest_id).manual_status = :failed
  end
  def manually_activate_quest(quest_id)
    quest(quest_id).manual_status = :active
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Reveal/Complete/Fail/Conceal/Uncomplete/Unfail Objective
  #    quest_id : ID of the quest whose objectives will be modified
  #    *obj     : IDs of objectives to reveal or complete or fail (or opposite)
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  [:reveal_objective, :complete_objective, :fail_objective, :conceal_objective,
  :uncomplete_objective, :unfail_objective].each { |method|
    define_method(method) do |quest_id, *obj| 
      quest(quest_id).send(method, *obj)
    end
  }
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Quest Revealed?
  #    quest_id : ID of the quest you are checking is revealed
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def quest_revealed?(quest_id)
    $game_party.quests.revealed?(quest_id)
  end
  [:complete, :failed, :active].each { |method|
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # * Quest Complete/Failed/Active?
    #    quest_id : ID of the quest whose completion status is being checked
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    define_method(:"quest_#{method}?") do |quest_id| 
      quest_revealed?(quest_id) && quest(quest_id).status?(method) 
    end
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # * Objective Complete/Failed/Active?
    #    quest_id : ID of the quest whose objectives are being checked
    #    *obj     : IDs of objectives to check completion status
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    define_method(:"objective_#{method}?") do |quest_id, *obj| 
      quest_revealed?(quest_id) && quest(quest_id).objective_status?(method, *obj) 
    end
  }
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * 목표 공개?
  #    quest_id : ID of the quest you are checking is revealed
  #    *obj     : IDs of objectives to check completion status
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def objective_revealed?(quest_id, *obj)
    quest_revealed?(quest_id) && quest(quest_id).objective_status?(:revealed, *obj) 
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * 퀘스트 보상?
  #    quest_id : ID of the quest you are checking is revealed
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def quest_rewarded?(quest_id)
    quest_revealed?(quest_id) && quest(quest_id).status?(:reward)
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * 보상 상태 변경
  #    quest_id : ID of the quest you are checking is revealed
  #    value    : true or false
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def change_reward_status(quest_id, value = true)
    quest(quest_id).reward_given = value
  end
  def change_reward_status2(quest_id, value = false)
    quest(quest_id).reward_given = value
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * 보상 분배
  #    quest_id : ID of the quest whose rewards are to be distributed
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def distribute_quest_rewards(quest_id)
    if quest_revealed?(quest_id) && !quest_rewarded?(quest_id)
      params = @params.dup
      change_reward_status(quest_id, true)
      quest(quest_id).rewards.each { |reward| distribute_quest_reward(reward) }
      @params = params
      true
    else
      false
    end
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Distribute Reward
  #    reward : an array identifying the reward
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def distribute_quest_reward(reward)
    @params = [reward[1], 0, 0, (reward[2] ? reward[2] : 1)]
    case reward[0]
    when :item, 0 then   command_126 # Item
    when :weapon, 1 then command_127 # Weapon
    when :armor, 2 then  command_128 # Armor
    when :gold, 3   # Gold
      @params = [0, 0, reward[1] ? reward[1] : 0]
      command_125
    when :exp, 4    # Exp
      @params = [0, 0, 0, 0, reward[1] ? reward[1] : 0, true]
      command_315
    end
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Call Quest Journal
  #    quest_id : ID of the quest to open the journal to
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def call_quest_journal(quest_id = nil)
    return if $game_party.in_battle
    $game_system.last_quest_id = quest_id if quest_id
    SceneManager.call(Scene_Quest)
    Fiber.yield
  end
end

unless $imported[:"MA_ParagraphFormat_1.0"]
#==============================================================================
# ** MA_Window_ParagraphFormat
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  This module inserts into Window_Base and provides a method to format the
# strings so as to go to the next line if it exceeds a set limit. This is 
# designed to work with draw_text_ex, and a string formatted by this method 
# should go through that, not draw_text.
#==============================================================================

module MA_Window_ParagraphFormat
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Calc Line Width
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def mapf_calc_line_width(line, tw = 0, contents_dummy = false)
    return tw if line.nil?
    line = line.clone
    unless contents_dummy
      real_contents = contents # Preserve Real Contents
      # Create a dummy contents
      self.contents = Bitmap.new(contents_width, 24)
      reset_font_settings
    end
    pos = {x: 0, y: 0, new_x: 0, height: calc_line_height(line)}
    while line[/^(.*?)\e(.*)/]
      tw += text_size($1).width
      line = $2
      # Remove all ancillaries to the code, like parameters
      code = obtain_escape_code(line)
      # If direct setting of x, reset tw.
      tw = 0 if ($imported[:ATS_SpecialMessageCodes] && code.upcase == 'X') ||
        ($imported["YEA-MessageSystem"] && code.upcase == 'PX')
      #  If I need to do something special on the basis that it is testing, 
      # alias process_escape_character and differentiate using @atsf_testing
      process_escape_character(code, line, pos)
    end
    #  Add width of remaining text, as well as the value of pos[:x] under the 
    # assumption that any additions to it are because the special code is 
    # replaced by something which requires space (like icons)
    tw += text_size(line).width + pos[:x]
    unless contents_dummy
      contents.dispose # Dispose dummy contents
      self.contents = real_contents # Restore real contents
    end
    return tw
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Format Paragraph
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def mapf_format_paragraph(text, max_width = contents_width)
    text = text.clone
    #  Create a Dummy Contents - I wanted to boost compatibility by using the 
    # default process method for escape codes. It may have the opposite effect, 
    # for some :( 
    real_contents = contents # Preserve Real Contents
    self.contents = Bitmap.new(contents_width, 24)
    reset_font_settings
    paragraph = ""
    while !text.empty?
      text.lstrip!
      oline, nline, tw = mapf_format_by_line(text.clone, max_width)
      # Replace old line with the new one
      text.sub!(/#{Regexp.escape(oline)}/m, nline)
      paragraph += text.slice!(/.*?(\n|$)/)
    end
    contents.dispose # Dispose dummy contents
    self.contents = real_contents # Restore real contents
    return paragraph
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Format By Line
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def mapf_format_by_line(text, max_width = contents_width)
    oline, nline, tw = "", "", 0
    loop do
      #  Format each word until reach the width limit
      oline, nline, tw, done = mapf_format_by_word(text, nline, tw, max_width)
      return oline, nline, tw if done
    end
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Format By Word
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def mapf_format_by_word(text, line, tw, max_width)
    return line, line, tw, true if text.nil? || text.empty?
    # Extract next word
    if text.sub!(/(\s*)([^\s\n\f]*)([\n\f]?)/, "") != nil
      prespace, word, line_end = $1, $2, $3
      ntw = mapf_calc_line_width(word, tw, true)
      pw = contents.text_size(prespace).width
      if (pw + ntw >= max_width)
        # Insert
        if line.empty?
          # If one word takes entire line
          return prespace + word, word + "\n", ntw, true 
        else
          return line + prespace + word, line + "\n" + word, tw, true
        end
      else
        line += prespace + word
        tw = pw + ntw
        # If the line is force ended, then end 
        return line, line, tw, true if !line_end.empty?
      end
    else
      return line, line, tw, true
    end
    return line, line, tw, false
  end
end

class Window_Base
  include MA_Window_ParagraphFormat
end

$imported[:"MA_ParagraphFormat_1.0"] = true
end

#==============================================================================
# *** MAQJ Window_QuestBase
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  This module mixes in with all quest windows
#==============================================================================

module MAQJ_Window_QuestBase
  attr_reader :maqj_objective_color
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Object Initialization
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def initialize(*args, &block)
    super(*args, &block)
    reset_font_settings
    set_data_font(:normal)
    @maqj_default_font = contents.font.dup
    # Change the windowskin, tone if they are set to be changed
    self.windowskin = Cache.system($game_system.quest_windowskin) if $game_system.quest_windowskin
    self.opacity = $game_system.quest_window_opacity if $game_system.quest_window_opacity
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Reset Font Settings
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def reset_font_settings(*args, &block)
    super(*args, &block)
    set_data_font(@maqj_font_data_type) if @maqj_font_data_type
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Set Data Font
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def set_data_font(data_type)
    @maqj_default_font = contents.font.dup unless @maqj_default_font
    contents.font.name = QuestData::FONTNAMES[data_type] ? 
      QuestData::FONTNAMES[data_type] : @maqj_default_font.name
    contents.font.size = QuestData::FONTSIZES[data_type] ? 
      QuestData::FONTSIZES[data_type] : @maqj_default_font.size
    contents.font.bold = QuestData::FONTBOLDS.keys.include?(data_type) ? 
      QuestData::FONTBOLDS[data_type] : @maqj_default_font.bold
    contents.font.italic = QuestData::FONTITALICS.keys.include?(data_type) ?
      QuestData::FONTITALICS[data_type] : @maqj_default_font.italic
    case data_type
    when :objectives then change_color(@maqj_objective_color) if @maqj_objective_color
    when :name then change_color(quest_name_colour(@quest)) if @quest
    else
      change_color(text_color(QuestData::COLOURS[data_type])) if QuestData::COLOURS.keys.include?(data_type)
    end
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Draw Horizontal Line
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def draw_horizontal_line(y, h = 2)
    contents.fill_rect(0, y, contents_width, h, text_color(QuestData::COLOURS[:line]))
    contents.fill_rect(0, y + h, contents_width, [h / 2, 1].max, text_color(QuestData::COLOURS[:line_shadow]))
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * MA Text Color
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def text_color(param)
    begin 
      colour = case param
      when Integer then super(param) rescue normal_color
      when Symbol then send(param) rescue normal_color
      when Array then Color.new(*param) rescue normal_color
      else
        normal_color
      end
    end
    colour.is_a?(Color) ? colour : normal_color
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Quest Name Colour
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def quest_name_colour(quest = @quest)
    return if !quest
    quest = $game_party.quests[quest] if quest.is_a?(Integer)
    s = [:failed, :complete, :active].find { |status| quest.status?(status) }
    text_color(QuestData::COLOURS[s])
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Quest Objective Colour
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def quest_objective_colour(quest, obj_id)
    return if !quest
    quest = $game_party.quests[quest] if quest.is_a?(Integer)
    s = [:failed, :complete, :active].find { |status| quest.objective_status?(status, obj_id) }
    text_color(QuestData::COLOURS[s])
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Update Tone
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def update_tone
    $game_system.quest_window_tone ? 
      self.tone.set(*$game_system.quest_window_tone) : super
  end
end

unless $imported[:"MA_IconHorzCommand_1.0"]
#==============================================================================
# ** Window_MA_IconHorzCommand
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  This window is a base window to show a horizontal command window populated
# with icons.
#==============================================================================

class Window_MA_IconHorzCommand < Window_HorzCommand
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Public Instance Variable
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  attr_reader   :observing_procs
  attr_accessor :cursor_hide
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Object Initialization
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def initialize(*args, &block)
    @observing_procs = {}
    super(*args, &block)
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Column Max
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def col_max; [(width - standard_padding) / (24 + spacing), item_max].min; end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Item
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def item
    @list[index] ? @list[index][:symbol] : nil
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Enabled? / Current Item Enabled?
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def enable?(index); self.index == index; end
  def current_item_enabled?; !current_data.nil?; end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Draw Item
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def draw_item(index)
    rect = item_rect(index)
    contents.clear_rect(rect)
    draw_icon(@list[index][:ext], rect.x + ((rect.width - 24) / 2), rect.y, enable?(index))
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Set Index
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def index=(index)
    old_index = self.index
    super(index)
    draw_item(old_index)
    draw_item(self.index)
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Frame Update
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def update
    super
    @observing_procs.values.each { |block| block.call(item) }
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Add/Remove Observing Window
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def add_observing_proc(id, &block)
    @observing_procs[id] = block
    update
  end
  def remove_observing_proc(id)     ; @observing_procs.delete(id) ; end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Update Cursor
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def update_cursor
    super
    cursor_rect.empty if @cursor_hide
  end
end
$imported[:"MA_IconHorzCommand_1.0"] = true
end

#==============================================================================
# ** Window_QuestCategory
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  This window allows the player to switch between quest categories.
#==============================================================================

class Window_QuestCategory < Window_MA_IconHorzCommand
  include MAQJ_Window_QuestBase
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Object Initialization
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def initialize(x, y, categories = $game_system.quest_categories)
    @cursor_hide = QuestData::HIDE_CATEGORY_CURSOR
    @categories = categories
    super(x, y)
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Window Width
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def window_width; QuestData::LIST_WINDOW_WIDTH; end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Category=
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def category=(category)
    self.index = @categories.index(category) if @categories.include?(category)
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Make Command List
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def make_command_list
    @categories.each { |cat| 
      add_command("", cat, false, QuestData::ICONS[cat]) }
  end
end

#==============================================================================
# ** Window QuestLabel
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  This window simply shows a label for the Quests scene
#==============================================================================

class Window_QuestLabel < Window_Base
  include MAQJ_Window_QuestBase
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Object Initialization
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def initialize(x, y, label = "")
    super(x, y, window_width, window_height)
    refresh(label)
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Reset Font Settings
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def reset_font_settings; set_data_font(:scene_label); end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Window Attributes
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def window_width
    w = ($game_system.quest_categories.size > 1 || QuestData::SHOW_CATEGORY_LABEL) ? 
      Graphics.width - QuestData::LIST_WINDOW_WIDTH : QuestData::LIST_WINDOW_WIDTH
  end
  def window_height; line_height + (standard_padding*2); end
  def line_height(*args)
    line_h = super(*args)
    QuestData::FONTSIZES[:scene_label] ? 
      [QuestData::FONTSIZES[:scene_label], line_h].max : line_h
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Refresh
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def refresh(label = @label)
    #print("059.퀘스트 창, 단축키 - refresh \n");
    @label = label.is_a?(String) ? convert_escape_characters(label) : ""
    contents.clear
    reset_font_settings
    tw = mapf_calc_line_width(@label)
    draw_text_ex((contents_width - tw) / 2, 0, @label)
  end
end

#==============================================================================
# ** Window QuestLabel
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  This window simply shows a label for category currently selected
#==============================================================================

class Window_QuestCategoryLabel < Window_QuestLabel
  include MAQJ_Window_QuestBase
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Reset Font Settings
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def reset_font_settings; set_data_font(:category_label); end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Window Attributes
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def window_width; QuestData::LIST_WINDOW_WIDTH; end
  def line_height(*args)
    line_h = super(*args)
    QuestData::FONTSIZES[:category_label] ? 
      [QuestData::FONTSIZES[:category_label], line_h].max : line_h
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Set Category
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def category=(category)
    return if @category == category
    @category = category
    refresh(QuestData::CATEGORY_VOCAB[category])
  end
end

#==============================================================================
# ** Window_QuestCategoryDummy
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  This window shows up behind the category and category label window 
#==============================================================================

class Window_QuestCategoryDummy < Window_Base
  include MAQJ_Window_QuestBase
end

#==============================================================================
# ** Window_QuestList
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  This window shows all quests in a selected category.
#==============================================================================

class Window_QuestList < Window_Selectable
  include MAQJ_Window_QuestBase
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Object Initialization
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def initialize(x, y, width, height)
    super
    @data = []
    self.index = 0
    activate
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Set Category
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def category=(category)
    return if @category == category
    @category = category
    refresh
    self.index = 0
    update_help if @help_window
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Get Quest
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def item; @data && index >= 0 ? @data[index] : nil; end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Column/Item Max
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def col_max; 1; end
  def item_max; @data ? @data.size : 1; end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Whether it should be drawn enabled
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def enable?(item); true; end
  def current_item_enabled?
    (@help_window && @help_window.maqj_visible_height < @help_window.contents_height)
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Make Item List
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def make_item_list
    @data = @category ? $game_party.quests.list(@category) : []
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Draw Item
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def draw_item(index)
    quest = @data[index]
    if quest
      rect = item_rect_for_text(index)
      if QuestData::SHOW_QUEST_ICONS
        draw_icon(quest.icon_index, rect.x, rect.y, enable?(quest))
        rect.x += 24
        rect.width -= 24
      end
      change_color(quest_name_colour(quest), enable?(quest))
      draw_text(rect, quest.name)
    end
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Refresh
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def refresh
    make_item_list
    create_contents
    set_data_font(:list)
    draw_all_items
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Update Help
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def update_help
    @help_window.quest = item
  end
end

#==============================================================================
# ** Window_QuestData 
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  This window shows all quest data
#==============================================================================

class Window_QuestData < Window_Selectable
  include MAQJ_Window_QuestBase
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Object Initialization
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def initialize(x, y, w, h, layout = QuestData::DATA_LAYOUT)
    @dest_scroll_oy = 0
    # 소지금 보다 큰 경우 초록색으로 표시 적용
    $game_switches[141] = true if $game_switches[141] == false
    super(x, y, w, h)
    @dest_scroll_oy = self.oy
    self.layout = layout
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Contents Height
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  alias maqj_visible_height contents_height
  def contents_height
    @q_contents_height ? [@q_contents_height, maqj_visible_height].max : maqj_visible_height
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Calculate Contents Height
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def calc_contents_height
    @q_contents_height = 0
    @layout.each { |dt| @q_contents_height += data_height(dt) } if @quest
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Draw Data?
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def draw_data?(data_type)
    case data_type
    when :line then true
    when :level then @quest.level > 0 
    when :objectives then !@quest.revealed_objectives.empty?
    when Array then (data_type - [:line]).any? { |dt| draw_data?(dt) }
    else !@quest.send(data_type).empty? # :description, :name, etc...
    end
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Get Data Height
  #    This method calculates the height required for a specified element of
  #   the current quest. This is to calculate the needed space in contents,
  #   as well as advance the @draw_y variable.
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def data_height(data_type)
    return 0 unless draw_data?(data_type)
    return line_height if QuestData::BASIC_DATA_TYPES.include?(data_type)
    @maqj_font_data_type = data_type
    reset_font_settings
    return case data_type
    when :line, :level, :name then line_height
    when :banner
      bmp = Cache.picture(@quest.banner)
      hght = bmp.rect.height
      bmp.dispose
      hght
    when :description
      buff = description_x*2
      paragraph = mapf_format_paragraph(@quest.description, contents_width - buff)
      line_num = paragraph.scan(/\n/).size + 1
      line_num += (QuestData::DESCRIPTION_IN_BOX ? 2 : 
        !QuestData::VOCAB[:description].empty? ? 1 : 0)
      line_num*line_height
    when :objectives
      objectives = @quest.revealed_objectives.collect { |obj_id| 
        @quest.objectives[obj_id] } 
      line_num = QuestData::VOCAB[:objectives].empty? ? 0 : 1
      buff = (objective_x*2) + text_size(QuestData::VOCAB[:objective_bullet]).width
      objectives.each { |obj|
        paragraph = mapf_format_paragraph(obj, contents_width - buff)
        line_num += paragraph.scan(/\n/).size + 1 }
      line_num*line_height
    when :rewards
      line_num = QuestData::VOCAB[:rewards].empty? ? 0 : 1
      (line_num + @quest.rewards.size)*line_height
    when Array then data_height(data_type.max_by { |dt| data_height(dt) })
    else 0
    end
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Set Quest
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def quest=(value)
    return if @quest == value
    @quest = value
    @layout = (@quest && @quest.layout) ? @quest.layout : @default_layout
    refresh
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Set Layout
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def layout=(value)
    return if @default_layout == value && @layout == value
    @default_layout = value
    @layout = value
    refresh
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Refresh
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def refresh
    contents.clear
    calc_contents_height
    create_contents
    return unless @quest && @layout
    self.oy = 0
    @dest_scroll_oy = 0
    #  The basic idea here is that each draw_ method will rely on and advance 
    # the @draw_y variable. Where they are an array, the elements will be 
    # drawn at the same @draw_y.
    @draw_y = 0
    @layout.each {|dt|
      next unless draw_data?(dt)
      dt.is_a?(Array) ? draw_data_array(dt) : draw_data(dt) 
    }
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Draw Data
  #    data_type : the data block to draw next
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def draw_data(data_type)
    @maqj_font_data_type = data_type
    reset_font_settings
    send(:"draw_#{data_type}") if self.class.method_defined?(:"draw_#{data_type}")
    @draw_y += data_height(data_type)
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Draw Data Array
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def draw_data_array(layout_array)
    y, max_y = @draw_y, @draw_y
    # Draw each data aspect at the same starting @draw_y
    layout_array.each { |dt|
      @draw_y = y
      draw_data(dt)
      max_y = @draw_y if @draw_y > max_y
    }
    @draw_y = max_y
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Draw Line
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def draw_line; draw_horizontal_line(@draw_y + (line_height / 2) - 1, 2); end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Draw Name
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def draw_name
    set_data_font(:name)
    clear_and_draw_text(0, @draw_y, contents_width, line_height, @quest.name, 1)
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Draw Level
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def draw_level
    case QuestData::LEVEL_ICON
    when Array then QuestData::LEVEL_ICON.empty? ? draw_level_text : draw_level_array
    when 0 then draw_level_text
    else
      draw_level_stacked
    end
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Draw Stacked Level
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def draw_level_stacked(icon_index = QuestData::LEVEL_ICON)
    align = QuestData::HEADING_ALIGN[:level]
    es = QuestData::LEVEL_ICONS_SPACE*(@quest.level - 1)
    x = align == 2 ? contents_width - 24 : align == 1 ? 
      (contents_width - 24 - (es)) / 2 : es
    @quest.level.times do
      draw_icon(icon_index, x, @draw_y)
      x -= QuestData::LEVEL_ICONS_SPACE
    end
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Draw Array Level
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def draw_level_array(icon_index = QuestData::LEVEL_ICON)
    return if icon_index.empty?
    icon_index = icon_index[@quest.level - 1] ? icon_index[@quest.level - 1] : icon_index[-1]
    align = QuestData::HEADING_ALIGN[:level]
    x = align == 2 ? contents_width - 24 : align == 1 ? (contents_width-24)/2 : 0
    draw_icon(icon_index, x, @draw_y)
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Draw Text Level
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def draw_level_text
    reset_font_settings
    level = QuestData::LEVEL_SIGNALS && QuestData::LEVEL_SIGNALS[@quest.level - 1] ? 
      QuestData::LEVEL_SIGNALS[@quest.level - 1] : @quest.level.to_s
    align = QuestData::HEADING_ALIGN[:level]
    tw = text_size(QuestData::VOCAB[:level]).width + 4
    tw2 = text_size(level).width + 2
    space = contents_width - tw - tw2
    x = align == 2 ? space : align == 1 ? space / 2 : 0
    clear_and_draw_text(x, @draw_y, tw, line_height, QuestData::VOCAB[:level])
    set_data_font(:level_signal)
    clear_and_draw_text(x + tw, @draw_y, tw2, line_height, level, 2)
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Draw Banner
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def draw_banner
    bmp = Cache.picture(@quest.banner) # Get Picture
    # Shift the hue if requested
    bmp.hue_change(@quest.banner_hue) unless @quest.banner_hue == 0
    x = (contents_width - bmp.rect.width) / 2
    if x < 0 # Stretch horizontally if the banner is too wide
      dest_rect = bmp.rect.dup
      dest_rect.width = contents_width
      contents.stretch_blt(dest_rect, bmp, bmp.rect)
    else
      contents.blt(x, @draw_y, bmp, bmp.rect)
    end
    bmp.dispose
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Draw Description
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~   def draw_description
#~     buff = description_x*2
#~     paragraph = mapf_format_paragraph(@quest.description, contents_width - buff)
#~     y = @draw_y
#~     # Draw Rect
#~     draw_box(paragraph.scan(/\n/).size + 1) if QuestData::DESCRIPTION_IN_BOX
#~     # Draw Description Label
#~     draw_heading(:description, y) unless QuestData::VOCAB[:description].empty?
#~     # Draw Description
#~     y += line_height if !QuestData::VOCAB[:description].empty? || QuestData::DESCRIPTION_IN_BOX
#~     draw_text_ex(description_x, y, paragraph)
#~   end
  def draw_description
    buff = description_x * 2
    paragraph = mapf_format_paragraph(@quest.description, contents_width - buff)
    y = @draw_y
    # Calculate the number of lines in the formatted paragraph
    num_lines = paragraph.count("\n") + 1
    # Calculate total height needed
    total_height = num_lines * line_height
    total_height += line_height if !QuestData::VOCAB[:description].empty? # Add space for label
    # Draw Rect
    if QuestData::DESCRIPTION_IN_BOX
      draw_box(total_height / line_height)
      y += line_height / 2 # Add some padding at the top of the box
    end
    # Draw Description Label
    unless QuestData::VOCAB[:description].empty?
      draw_heading(:description, y)
      y += line_height
    end
    # Draw Description
    draw_text_ex(description_x, y, paragraph)
    # Update @draw_y for the next section
    @draw_y = y + total_height + (QuestData::DESCRIPTION_IN_BOX ? line_height / 2 : 0)
  end

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Draw Objectives
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def draw_objectives
    y = @draw_y
    unless QuestData::VOCAB[:objectives].empty?
      draw_heading(:objectives, y)
      y += line_height
    end
    @quest.revealed_objectives.each do |obj_id|
      new_y = draw_objective(obj_id, y)
      # Check if we've exceeded the window height
      if new_y > contents_height
        break  # Stop drawing if we've exceeded the height
      end
      y = new_y
    end
    @draw_y = y
  end
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Draw Objective
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def draw_objective(obj_id, y)
    bullet = QuestData::VOCAB[:objective_bullet]
    bullet_tw = text_size(bullet).width + 2
    buff = (objective_x*2) + bullet_tw
    paragraph = mapf_format_paragraph(@quest.objectives[obj_id], contents_width - buff)
    line_num = 1 + paragraph.scan(/\n/).size
    # Since draw_text_ex resets the font, set colour here
    @maqj_objective_color = quest_objective_colour(@quest, obj_id)
    change_color(text_color(QuestData::COLOURS[:objective_bullet]))
    draw_text(objective_x, y, bullet_tw, line_height, sprintf(bullet, obj_id + 1))
    draw_text_ex(objective_x + bullet_tw, y, paragraph)
    @maqj_objective_color = false
    y += (line_num*line_height)
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Draw Rewards
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def draw_rewards
    y = @draw_y
    unless QuestData::VOCAB[:rewards].empty?
      draw_heading(:rewards, y)
      y += line_height
    end
    for i in 0...@quest.rewards.size do draw_reward(i, y + i*line_height) end
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Draw Reward
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def draw_reward(r_id, y)
    reward = @quest.rewards[r_id]
    case reward[0]
    when :item, 0   # Item
      draw_item_reward(y, $data_items[reward[1]], reward[2] ? reward[2] : 1)
    when :weapon, 1 # Weapon
      draw_item_reward(y, $data_weapons[reward[1]], reward[2] ? reward[2] : 1)
    when :armor, 2  # Armor
      draw_item_reward(y, $data_armors[reward[1]], reward[2] ? reward[2] : 1)
    when :gold, 3   # Gold
      draw_basic_data(y, QuestData::ICONS[:reward_gold], 
        QuestData::VOCAB[:reward_gold], "")
      draw_currency_value(reward[1], "", 0, y, contents.width-10, 0)
    when :exp, 4    # Exp
      draw_basic_data(y, QuestData::ICONS[:reward_exp], 
        QuestData::VOCAB[:reward_exp], (reward[1] ? reward[1] : 0).to_s)
    when :string, 5 # String
      draw_basic_data(y, reward[1] ? reward[1] : 0, reward[3] ? reward[3].to_s : "", 
        reward[2] ? reward[2].to_s : "")
    end
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Draw Item Reward
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def draw_item_reward(y, item, amount = 1)
    w = contents_width
    w = QuestData::BASIC_DATA_WIDTH if QuestData::BASIC_DATA_WIDTH.between?(1, w)
    x = (contents_width - w) / 2
    draw_item_name(item, x, y, true, w - 40)
    # 보상 아이템이 1개면 그냥 수치 1 표기
    if amount >= 1
      change_color(text_color(QuestData::COLOURS[:reward_amount]))
      draw_text(0, y, contents.width-10, line_height, sprintf(QuestData::VOCAB[:reward_amount], amount), 2)
      #draw_text(x + w - 40, y, 40, line_height, sprintf(QuestData::VOCAB[:reward_amount], amount), 0)
    end
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Draw Basic Data Methods
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  QuestData::BASIC_DATA_TYPES.each { |data_type|
    define_method(:"draw_#{data_type}") {
      draw_basic_data(@draw_y, QuestData::ICONS[data_type], 
        QuestData::VOCAB[data_type], @quest.send(data_type))
    }
  }
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Draw Basic Data
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def draw_basic_data(y, icon_index, vocab, value)
    w = contents_width
    w = QuestData::BASIC_DATA_WIDTH if QuestData::BASIC_DATA_WIDTH.between?(1, w)
    x = (contents_width - w) / 2
    unless icon_index == 0
      draw_icon(icon_index, x, y)
      x += 24
      w -= 24
    end
    tw = text_size(vocab).width + 5
    change_color(text_color(QuestData::COLOURS[:basic_label]))
    draw_text(x, y, tw, line_height, vocab)
    change_color(text_color(QuestData::COLOURS[:basic_value]))
    draw_text(x + tw, y, w - tw, line_height, value, 0)
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Draw Heading
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def draw_heading(data_type, y)
    set_data_font(:heading)
    clear_and_draw_text(40, y, contents_width - 80, line_height, 
      QuestData::VOCAB[data_type], QuestData::HEADING_ALIGN[data_type])
    reset_font_settings
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Clear and Draw Text
  #    Clear the field before drawing the text
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def clear_and_draw_text(*args)
    rect = []
    while !args[0].is_a?(String) do rect.push(args.shift) end
    rect[0].is_a?(Rect) ? rect = rect[0] : rect = Rect.new(*rect)
    align = args[1] ? args[1] : 0
    ts = text_size(args[0])
    ts.width = [ts.width + 4, rect.width].min
    align == 1 ? ts.x = rect.x + ((rect.width - ts.width) / 2) : 
      align == 2 ? ts.x = rect.x + rect.width - ts.width : ts.x = rect.x
    ts.y = rect.y
    contents.clear_rect(ts)
    ts.x += 2
    draw_text(ts, args[0], align)
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Draw Description Box
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def draw_box(line_num)
    return if line_num < 1
    x = (line_height / 2) - 1
    y = @draw_y + (line_height / 2) - 1
    w = contents_width - 2*x
    h = (1 + line_num)*line_height
    draw_rect_outline_with_shadow(x, y, w, h) 
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Draw Rect Outline
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def draw_rect_outline(x, y, w, h, colour)
    # Horizontal Lines
    contents.fill_rect(x, y, w, 2, colour)
    contents.fill_rect(x, y + h - 2, w, 2, colour)
    # Vertical Lines
    contents.fill_rect(x, y, 2, h, colour)
    contents.fill_rect(x + w - 2, y, 2, h, colour)
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Draw Rect Outline with Shadow
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def draw_rect_outline_with_shadow(x, y, w, h)
    draw_rect_outline(x + 1, y + 1, w, h, text_color(QuestData::COLOURS[:line_shadow]))
    draw_rect_outline(x, y, w, h, text_color(QuestData::COLOURS[:line]))
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Objective/Description X
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def objective_x; line_height / 2; end
  def description_x; QuestData::DESCRIPTION_IN_BOX ? line_height : (line_height/2); end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Update
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def update(*args, &block)
    super(*args, &block)
    if open? && active && @dest_scroll_oy == self.oy
      scroll_down if Input.press?(:DOWN)
      scroll_up if Input.press?(:UP)
    end
    if self.oy != @dest_scroll_oy
      mod = (@dest_scroll_oy <=> self.oy)
      self.oy += 3*mod
      self.oy = @dest_scroll_oy if (@dest_scroll_oy <=> self.oy) != mod
    end
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Scroll Down
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def scroll_down(*args, &block)
    max_oy = contents_height - maqj_visible_height
    dest = ((@dest_scroll_oy / line_height) + 1)*line_height
    @dest_scroll_oy = [dest, max_oy].min
  end
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Scroll Up
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def scroll_up(*args, &block)
    dest = ((@dest_scroll_oy / line_height) - 1)*line_height
    @dest_scroll_oy = [dest, 0].max 
  end
end

# Menu Access
if !$imported[:MA_InsertCommand]
  
MA_COMMAND_INSERTS = {}
MA_InsertableMenuCommand = Struct.new(:name, :index, :enable, :scene, :other)

class Game_System
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # * Inserted Menu Commands
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  def maic_inserted_menu_commands
    # Lazy Instantiation so that old save files are not corrupted
    if !@maic_inserted_menu_commands
      @maic_inserted_menu_commands = MA_COMMAND_INSERTS.keys
      # Sort by index
      @maic_inserted_menu_commands.sort! { |a, b| MA_COMMAND_INSERTS[a].index <=> MA_COMMAND_INSERTS[b].index }
    end
    @maic_inserted_menu_commands
  end
end

$imported[:MA_InsertCommand] = true
end

MA_COMMAND_INSERTS[:quest_journal] = 
  MA_InsertableMenuCommand.new(QuestData::VOCAB[:menu_label], QuestData::MENU_INDEX, 
  "!$game_system.quest_access_disabled && !$game_party.quests.list.empty?", 
  :Scene_Quest, false)