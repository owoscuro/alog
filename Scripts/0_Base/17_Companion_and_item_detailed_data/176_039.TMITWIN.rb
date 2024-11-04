# encoding: utf-8
# Name: 039.TMITWIN
# Size: 2039
#-------------------------------------------------------------------------------
# SceneManager.call(Scene_Roster)          - 현장을 부른다
# $game_actors[id].discovered = true/false - 발견하거나 발견하지 못하다
# $game_actors[actor_id].in_roster = true/false
#
# <NO ROSTER> - 배우를 명단에서 제외
# <ROSTER ##> - 액터를 수동으로 정렬하는 데 사용
#-------------------------------------------------------------------------------

module ROSTER
  # 알려지지 않은 배우의 얼굴이 표시됩니다. 비활성화하려면 false로 설정합니다.
  UNDISCOVERED_FACE = ["People",0]
  
  # 알 수 없는 액터에 대한 설명 텍스트 표시
  UNDISCOVERED_DESC = "Aún no hay información sobre este compañero."
  
  # Use basic status: (상태 표시를 변경하는 스크립트와의 호환성을 위해)
  USE_BASIC = true
  
  # 장비 배열의 빈 슬롯 표시
  SHOW_EMPTY_SLOTS = true
  EMPTY_SLOT_ICON = 0
  EMPTY_SLOT_TEXT = "-"
end

$tmscripts = {} unless $tmscripts
$tmscripts["itwin"] = true

module TMITWIN
  SW_NOUSE_ITEM_INFO  = 136   # 상품 상세 기능의 사용 금지 플래그 스위치 번호
  SW_NOUSE_SKILL_INFO = 137   # 기술 고급 기능 사용 금지 플래그 스위치 번호

  FEATURE_X   = 256           # 특징을 그릴 X 좌표
  
  RO_WI_01X = 8                                # 1번째 설명 좌표
  RO_WI_02X = Graphics.width / 3 + RO_WI_01X   # 2번째 설명 좌표
  RO_WI_03X = Graphics.width / 3 + RO_WI_02X   # 3번째 설명 좌표
  
  if Graphics.height == 640
    RO_WI_FS = 26
  elsif Graphics.height == 704
    RO_WI_FS = 24
  else
    RO_WI_FS = 20
  end
  
  RO_HELP = Graphics.height - 24  #(24*1)     # 아이템 설명 구분 선
  RO_HELP_Y = Graphics.height     # - (24*1)  # 아이템 설명
  
  PARAM_WIDTH = Graphics.width / 3 - 25
  
  # 특징 "공격시 속성" 표시에서 제외 할 속성
  EXCLUDE_ELEMENTS = [1]
  
  KEY_SYMBOL = :X                 # 자세한 표시에 사용하는 버튼의 설정
end