# encoding: utf-8
# Name: 054.Galv_CEffects
# Size: 5385
#-------------------------------------------------------------------------------
#  <icon:id,x,y>      # 아이콘을 표시하는 이벤트를 설정의 (X, Y 위치 오프셋)
#  <shadow>           # 그림자를 표시하는 이벤트를 설정할
#  <reflect>          # 반사를 표시하는 이벤트를 설정
#-------------------------------------------------------------------------------
#  <icon:1,0,0><shadow><reflect>    # 반영 이벤트에 그림자와 아이콘 1 보여
#  char_effects(x,x,x,status)
#-------------------------------------------------------------------------------
#  당신은 X는 효과 수있는, 한 번에 효과의 배수를 변경할 수 있습니다
#  0 = reflect    1 = shadows    2 = mirror    3 = icons
#-------------------------------------------------------------------------------
#  char_effects(0,true)              # 반사를 설정
#  char_effects(0,2,true)            # 반사를 켜고 거울
#  char_effects(1,3,false)           # 오프 그림자와 아이콘을 설정
#-------------------------------------------------------------------------------
#  reflect_sprite(actor_id,filename,pos)    # 변경 배우의 반영 캐릭터 세트
#  reflect_esprite(event_id,filename,pos)   # 변경 이벤트의 반영 캐릭터 세트
#  reflect_vsprite(vehicle_id,filename,pos) # 변경 차량의 반영 캐릭터 세트
#-------------------------------------------------------------------------------
#  reflect_sprite(1,"Actor2",2)      # 1의 캐릭터 세트 "Actor2"캐릭터의 위치 2
#  reflect_esprite(3,"Actor4",5)     # 이벤트 3은 위치 5에서 스프라이트를 사용합니다.
#  reflect_vsprite(1,"Vehicle",5)    # 선박 위치 5에서 스프라이트를 사용합니다.
#-------------------------------------------------------------------------------
#  SCRIPT CALLS to turn effects ON or OFF for chosen EVENTS
#-------------------------------------------------------------------------------
#  reflect(x,x,x,status)   # 상태 또는 해제 참 또는 거짓 일 수있다.
#                          # 거울에 지정하고 반영하기 위해 사용합니다.
#  shadow(x,x,x,status)    # x는 변경하고자하는 이벤트 ID
#                          # 변경하는 모든 이벤트는 사용 :all
#  icon(x,x,x,icon_id)     # 문자 위에 표시되는 아이콘 ID 를 설정합니다.
#-------------------------------------------------------------------------------
#  reflect(14,17,3,1,true) # 돌려서 이벤트 14, 17, 3 및 1 반사 ON
#  shadow(1,false)         # 이벤트 1 그림자을 끄고
#  reflect(:all,true)      # 모든 이벤트 반사를 돌려
#  icon(1,2,3,4,38)        # 이벤트 1, 2, 3 및 4 (38)가 표시 아이콘이됩니다.
#-------------------------------------------------------------------------------
#  SCRIPT CALLS to turn effects ON or OFF for ACTORS and VEHICLES
#-------------------------------------------------------------------------------
#  actor_reflect(actor_id,status)  # 반사와 그림자은 기본적으로 있습니다
#  actor_shadow(actor_id,status)   # 배우와 차량. 그들 끄기
#  actor_icon(actor_id,icon_id)    # 나에 영구적으로 변경됩니다.
#
#  v_reflect(x,x,x,status)    # use these v_ calls for changing vehicle effects
#  v_shadow(x,x,x,status)     # on and off for vehicles.
#  v_icon(x,x,x,icon_id)
#-------------------------------------------------------------------------------
#  SCRIPT CALLS for shadow options
#-------------------------------------------------------------------------------
#  shadow_source(x,y,id)       # 빛의 X, Y 위치를 설정합니다.
#  shadow_source(event_id,id)  # 빛에 대한 이벤트의 X, Y 위치를 사용합니다.
#  shadow_options(intensity,fade,flicker)
#    # intensity = 광원 옆에 서있는 경우 불투명도 (255 검은 색)
#    # fade = 양 그림자는 더 멀리 당신이 더 투명 해집니다.
#    # flicker = 진실 혹은 거짓, 그림자는 화재에 의해 캐스팅되는 것처럼 깜박입니다.
#-------------------------------------------------------------------------------
#  shadow_options(80,10,false)
#    # This is the default setting.
#-------------------------------------------------------------------------------
#  SCRIPT CALLS for reflect options
#-------------------------------------------------------------------------------
#  reflect_options(wave_pwr)
#    # wave_pwr = how strong the wave movement is. 0 is off
#-------------------------------------------------------------------------------
#  reflect_options(1)
#    # Turn wave power to 1
#-------------------------------------------------------------------------------
#  NOTETAG for ACTORS
#-------------------------------------------------------------------------------
#  <no_reflect>                    # 배우 반사가 없습니다.
#  <reflect_sprite: FileName,pos>  # 배우 반사에 대한이 캐릭터 세트를 사용합니다.
#-------------------------------------------------------------------------------
#  <reflect_sprite: Actor2,0>    # Actor2 캐릭터 세트에서 첫 번째 문자
#  <reflect_sprite: Actor3,7>    # Actor2 캐릭터 세트에서 마지막 문자
#-------------------------------------------------------------------------------
($imported ||= {})["Galv_Character_Effects"] = true

module Galv_CEffects
  SHADOW_Z = 0
end