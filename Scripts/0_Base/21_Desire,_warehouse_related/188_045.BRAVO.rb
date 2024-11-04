# encoding: utf-8
# Name: 045.BRAVO
# Size: 6414
# encoding: utf-8
# Name: 045.BRAVO
# Size: 6637
#-------------------------------------------------------------------------------
# 상자 및 보관함, 창고 모듈
#-------------------------------------------------------------------------------
module BRAVO_STORAGE
  # 보관할 수 있는 항목의 기본 최대값입니다.
  ITEM_MAX = 20000
  # 저장할 수 있는 골드의 최대량입니다.
  GOLD_MAX = 99999999
  # 저장소에서 항목을 제거하기 위한 명령 이름입니다.
  WITHDRAW_TEXT = "Retirar ítems"
  # 항목을 저장소에 저장하기 위한 명령 이름입니다.
  STORE_TEXT = "Guardar ítems"
  # 저장 장면을 떠나기 위한 명령 이름입니다.
  CANCEL_TEXT = "Salir"
  # 스토리지 이름 창 너비
  NAME_WIDTH = 160
end

#-------------------------------------------------------------------------------
# 아이템 거래 상점 모듈
#-------------------------------------------------------------------------------
module BRAVO_STORAGE_2
  # 보관할 수 있는 항목의 기본 최대값입니다.
  ITEM_MAX = 20000
  # 저장할 수 있는 골드의 최대량입니다.
  GOLD_MAX = 99999999
  # 저장소에서 항목을 제거하기 위한 명령 이름입니다.
  WITHDRAW_TEXT = "Comprar"
  # 항목을 저장소에 저장하기 위한 명령 이름입니다.
  STORE_TEXT = "Vender"
  # 저장 장면을 떠나기 위한 명령 이름입니다.
  CANCEL_TEXT = "Salir"
  # 스토리지 이름 창 너비
  NAME_WIDTH = 160
  # 헬프창 메세지
  HELP_TEXT_01 = "Cada comerciante tiene diferentes ítems para comprar y vender, y hay cantidades de stock.\nEl stock cambia según el tiempo y las circunstancias, y a veces aparecen ítems raros."
  HELP_TEXT_02 = "Con el botón \\C[1]Z\\C[0] puedes usar ítems, el botón \\C[1]A\\C[0] muestra datos detallados del ítem, y el botón \\C[1]C\\C[0] te permite desechar ítems.\nSi excedes el límite de peso, obtendrás un debuff, y el peso actual se muestra para el ítem seleccionado."
  HELP_TEXT_03 = "Las habilidades con una E indican que se pueden usar con el arma equipada, y SP son los puntos necesarios para aprender esa habilidad.\nHabilidades ya aprendidas se muestran en \\C[1]azul\\C[0]."
  HELP_TEXT_04 = "Las habilidades aprendidas se muestran, los números en \\C[1]azul\\C[0] indican el MP necesario y los números en \\C[2]naranja\\C[0] indican el TP necesario para usar la habilidad.\nAlgunas habilidades se pueden usar solo en el menú o mapa, mientras que otras no tienen restricciones."
end

module TMPRICE
  SW_USE = 135            # 변수 가격 보정을 이용, 스위치 번호
  VN_SELLING_RATE = 285   # 매각 가격 보정 율로 이용, 게임 변수 번호
  VN_BUYING_RATE = 284    # 구매 가격 보정 율로 이용, 게임 변수 번호
end

#-------------------------------------------------------------------------------
# 각 아이템의 최대 휴대 가능량을 설정
# <itemmax: X> were X = the max.
#-------------------------------------------------------------------------------

module BRAVO
  # 플레이어가 휴대할 수 있는 한 항목의 기본 양입니다.
  ITEM_MAX = 10000
end

#-------------------------------------------------------------------------------
#   change_hunger(actor, amount)
#
# 각 캐릭터에 대한 기아 최대치를 설정하려면 배우 메모장에서 이 메모 태그를 사용하세요.
#   <hungermax: x>
#
# 항목 또는 기술 사용에 대한 배고픔 통계를 높이거나 낮추려면 이 메모 태그를 사용하십시오.
# 아이템 또는 스킬 메모장에 있습니다.
#   <hunger: x>
#
# 아이템 또는 스킬 사용 사용자의 배고픔 스탯을 높이거나 낮추려면
# 아이템이나 스킬 메모장에 있는 이 메모장.
#   <user-hunger: x>
#
#-------------------------------------------------------------------------------

module BRAVO_HTS
  HTS_NAMES = ["Hambre", "Sed", "Fatiga", "Reputación", "Deseo", "Devoción", "Higiene", "Temperatura", "Psique&Cuerpo", "Resfriado", "Embriaguez"]
  HTS_USE = [true, true, true, true, true, true, true, true, true, true, true]
  
  # 배고픔, 갈증, 수면 스탯이 최대치에 도달하면 배우는 사망합니다.
  HTS_DIE_MAX = [true, true, true, true, true, true, true, true, true, true, true]
  
  # 배고픔, 갈증, 수면 통계의 최대량.
  HTS_MAX = [1300, 1100, 900, 1000, 100, 100, 100, 100, 100, 100, 100]
  
  # 단계당 배고픔, 갈증, 수면 스탯을 증가시키는 양입니다.
  HTS_INCREASE = [0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1]
  
  # 배고픔, 갈증, 수면 스탯이 이 수치에 도달하면 돌진이 비활성화됩니다.
  DISABLE_DASH = [800, 700, 800, 100, 100, 100, 100, 80, 80, 80, 80]
  
  # 파티장의 배고픔/갈증/수면 스탯인 경우에 대시를 비활성화해야 합니다.
  # 특정 지점에 도달합니다, 값은 ":leader" 또는 ":party"입니다.
  DIASBLE_DASH_METHOD = :leader

  # 이 스위치가 켜져 있으면 HUD가 표시됩니다.
  HTS_HUD_SWITCH = 83
  
  # 지도에 나타날 HUD의 X 위치입니다.
  HTS_HUD_X = 0
  
  # 지도에 나타날 HUD의 Y 위치입니다.
  HTS_HUD_Y = 442
  
  # 이미지를 사용하지 않으려면 HUD용 이미지 이름을 비워 두십시오.
  HTS_HUD_BACK = ""
  
  # HUD 창의 불투명도입니다.
  HTS_HUD_OPACITY = 0
end

#-------------------------------------------------------------------------------
# 체크포인트를 설정하려면 이벤트 스크립트 호출에서 이것을 사용하십시오.
# set_checkpoint
# add_life(amount)
#-------------------------------------------------------------------------------

module BRAVO_CHECKPOINT
  # 사망 시 체크포인트 재생성을 활성화/비활성화하도록 전환합니다.
  CHECKPOINT_SWITCH = 194
  
  # 생명 시스템을 활성화/비활성화하는 스위치입니다.
  LIFE_SWITCH = 193
  
  # 리스폰시 체력 회복 방법, 값은 1, 2 또는 3 입니다.
  # 액터가 1인 경우 hp가 1로 설정되고, 2인 경우 액터의 hp가 max로 설정됩니다.
  # 액터가 3명일 때 %만큼 hp가 회복됩니다.
  HP_RESTORE = 3
  
  # 위의 값을 3으로 설정하면 백분율이 복원됩니다.
  HP_PERCENT = 40
  
  # 리스폰 시 경험치 손실 비율입니다.
  EXP_LOSS = 30
  
  # 리스폰 시 손실되는 골드 비율입니다.
  GOLD_LOSS = 30
end