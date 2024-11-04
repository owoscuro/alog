# encoding: utf-8
# Name: ◆ Cool time reduction in progress
# Size: 12827
=begin
#==============================================================================#
 스킬, 아이템 설정
#==============================================================================#
Exclude From Tool Menu = true   - 도구 선택 메뉴에서 항목 제외
--------------------------------------------------------------------------------

User Iconset = animated       - 다음 3가지 옵션을 사용할 수 있습니다.
                                animated, static, shielding
                                애니메이션, 정적, 방어

Projectile Iconset = animated - 2가지 옵션이 있습니다
                                animated, static
                                애니메이션, 정적
#==============================================================================#
 엑터 데이터베이트 설정 방법
#==============================================================================#       
Knockdown Graphic = Damage3        - 녹다운 그래픽
Knockdown Index = 6                - 그래픽 인덱스
Knockdown pattern = 0              - 그래픽 패턴
Knockdown Direction = 2            - 그래픽 방향
Battler Voices = se, se, se        - 공격할 때 목소리를 재생하고 싶다면,
                                     se 파일 이름을 쉼표로 구분하여 넣습니다.
Hit Voices = se, se, se            - 맞았을 때 목소리를 재생하고 싶다면,
                                     se 파일 이름을 쉼표로 구분하여 넣습니다.
#==============================================================================#
 몬스터 캐릭터 설정 방법
#==============================================================================#
<enemy: x>       - 데이터베이스의 적 ID 에 대해 x 를 변경하십시오.

use_weapon(x)
use_armor(x)
use_item(x)
use_skill(x)

rand_skill(x,x,x)        ramdom 스킬은 적이 사용할 id입니다.
rand_item(x,x,x)         ramdom 아이템 id는 적이 사용할 것입니다.
rand_weapon(x,x,x)       ramdom 무기는 적이 사용할 아이디
rand_armor(x,x,x)        ramdom 갑옷은 적군이 사용할 아이디

#==============================================================================#
 몬스터 데이터베이트 설정 방법
#==============================================================================#
Enemy Respawn Seconds = x       - 적이 부활할 수 있는 시간(초)
Enemy Respawn Animation = x     - 리스폰 애니메이션 ID
Enemy Knockback Disable = true  - 적을 밀쳐내지 못하게 한다
Enemy Lowhp 75% Switch = x      - 적 HP가 75% 미만일 때 스위치 id x 켜기
Enemy Lowhp 50% Switch = x      - 적 HP가 50% 미만일 때 스위치 id x 켜기
Enemy Lowhp 25% Switch = x      - 적 HP가 25% 미만일 때 스위치 id x 켜기
Enemy Lowhp 10% Switch = x      - 적의 HP가 10% 미만일 때 스위치 id x 켜기
Enemy Touch Damage Range = x    - 적의 접촉으로 액터에게 피해를 입히고 싶다면
                                  이 태그를 사용하여 타일의 거리에 대해 x를 변경합니다.
Enemy Sensor = x                - 적이 플레이어를 볼 수 있는 타일의 거리,
                                  기본값은 6입니다.
Enemy Object = true             - 적이 오브젝트가 되고 데미지 팝을 제거 한다.
                                  이것은 함정과 같은 적을 만드는 데 사용되거나,
                                  드롭을 얻을 수 있는 잔디와 같은 물체
Enemy Boss Bar = true           - 이것은 적에게 큰 보스 HP 막대를 표시하게 만듭니다.
Enemy Battler = true            - 적에게 배틀러 그래픽을 보여주길 원하십니까?
Enemy Breath = true             - 적이 숨쉬기를 원하십니까?
Enemy Die Animation = x         - 적이 죽을때 재생 애니메이션 ID 의 x 변경
Enemy Kill With Weapon = a,b,c  - 적이 모든 도구에 대해 무적 상태가 됩니다.
                                  주어진 도구 ID로만 죽일 수 있습니다.
                                  원하는 모든 ID를 쉼표로 구분하여 넣을 수 있습니다.
Enemy Kill With Armor = a,b,c   - 무기랑 똑같음
Enemy Kill With Item = a,b,c    - 무기랑 똑같음
Enemy Kill With Skill = a,b,c   - 무기랑 똑같음
Enemy Collapse Type = x         - 사용 가능한 이 4가지 옵션 중 하나에 대해 x를 변경
                                  줌_수직
                                  줌_수평
                                  줌_최대화
                                  줌_최소화
Enemy Body Increase x           - 기본적으로 모든 적의 크기는 1타일
                                  x 를 1 또는 2 로 변경합니다.
Enemy Die Switch = x            - 적이 죽을 때 스위치 ID 가 활성화
Enemy Die Variable = x          - 적이 죽을 때 변수 ID 가 + 1
Enemy Die Self Switch = x       - 자체 스위치 대문자의 x 가 활성화
Hit Jump = false                - 적중 시 적 점프 비활성화
Battler Voices = se, se, se     - 공격 시 적의 목소리를 재생
                                  se 파일 이름을 쉼표로 구분하여 넣습니다.
Hit Voices = se, se, se         - 맞았을 때 적의 목소리를 재생
                                  se 파일 이름을 쉼표로 구분하여 넣습니다.
Enemy Dead Pose = true          - 죽은 적의 그래픽 변경 허용
Enemy Die Transform = x         - 죽을 때 적의 그래픽 변경
                                  적 id 의 x를 변경하십시오.
#==============================================================================#
 상태이상 데이터베이트 설정 방법
#==============================================================================#
State Animation = x            - 상태 애니메이션 ID
State Effect Rand Rate = x     - HP, MP 및 TP 재생 적용 주기
#==============================================================================#
 이벤트 주석 설정 방법
#==============================================================================#
<start_with_weapon: a,b,c>
<start_with_armor: a,b,c>       - 이벤트를 시작할 도구 ID를 입력합니다.
<start_with_item: a,b,c>          당신은 필요한 만큼의 ID를 넣을 수 있습니다.
<start_with_skill: a,b,c>

<hook_grab: true>         - 후크는 이 이벤트를 잡을 수 있습니다.       
<hook_pull: true>         - 후크는 사용자를 x 에서 이벤트 위치로 끌어옵니다.

<boom_grab: true>         - 이벤트는 부메랑으로 잡을 수 있습니다.
<boomed_start: true>      - 이벤트를 성공하면 이벤트가 시작됩니다.
#==============================================================================#
 스킬 단축키 관련 스크립트 명령어
#==============================================================================#
- $game_party.set_item(actor, item, slot)
  항목을 스킬바에 자동으로 설정하려면 이 명령을 사용하십시오.
  액터 ID의 액터 변경, 항목 ID의 항목, 슬롯 이름 기호의 슬롯
  경험치: $game_party.set_item(1, 20, :H)
  
- $game_party.set_skill(actor, skill, slot) - 아이템과 동일

- SceneManager.call(Scene_QuickTool)        - 빠른 도구 창을 수동으로 호출
- SceneManager.call(Scene_CharacterSet)     - 플레이어 선택을 수동으로 호출

- $game_player.pop_damage('something')      - 플레이어 위에 팝 텍스트 표시
- $game_map.events[id].pop_damage('')       - 이벤트 ID 위에 팝 텍스트 표시
#==============================================================================#
 아이템, 스킬등 데이터베이트 설정 방법
#==============================================================================#
User Graphic = $Axe
User Anime Speed = 30
Tool Cooldown = 30
Tool Graphic = nil
Tool Index = 0
Tool Size = 1
Tool Distance = 1
Tool Effect Delay = 10
Tool Destroy Delay = 20
Tool Speed = 5
Tool Cast Time = 0
Tool Cast Animation = 0
Tool Blow Power = 1
Tool Piercing = true
Tool Animation When = end
Tool Animation Repeat = false
Tool Special = nil
Tool Target = false
Tool Invoke Skill = 0
Tool Guard Rate = 0
Tool Knockdown Rate = 70
Tool Sound Se = nil
Tool Cooldown Display = false
Tool Item Cost = 0
Tool Short Jump = false
Tool Through = true
Tool Priority = 1
Tool Hit Shake = false
Tool Self Damage = false
Tool Combo Tool = nil

User Graphic = $Axe
- 도구 그래픽, 그래픽을 표시하지 않으려면 nil 을 넣습니다.

User Anime Speed = 30
- 사용할 때 사용자 그래픽 애니메이션 속도

Tool Cooldown = 30
- 재사용 대기시간

Tool Graphic = nil
- 도구 발사체 그래픽, 그래픽을 표시하지 않으려면 nil 을 넣습니다.

Tool Index = 0
- 도구 그래픽의 인덱스

Tool Size = 1
- 도구 크기

Tool Distance = 1
- 발사체가 이동할 거리

Tool Effect Delay = 10
- 도구(발사체)가 대상에 적용되는 시간, 폭탄 같은 도구는 수치가 높다.

Tool Destroy Delay = 20
- 도구(발사체)가 파괴 및 제거되는 시간

Tool Speed = 5
- 도구(발사체) 이동 속도
  
Tool Cast Time = 0
- 도구 캐스팅 시간

Tool Cast Animation = 0
- 도구 캐스팅 애니메이션

Tool Blow Power = 1
- 해당 도구(발사체)에 맞았을 때 넉백 시키는 힘

Tool Piercing = true
- 도구(발사체)가 적을 관통하는지 여부

Tool Animation When = end
- 이것은 애니메이션이 재생될 시기를 정의하며 4가지 옵션이 있습니다.
       end      - 애니메이션은 파괴되기 직전에 재생됩니다.
       acting   - 도구를 사용할 때 애니메이션이 재생됩니다.
       hit      - 대상을 명중하면 애니메이션이 재생됩니다.
       delay x  - 도구 파괴 지연이 도달하면 애니메이션이 재생됩니다.
                  x 정수, 예를 들어 폭탄은 다음에 애니메이션을 표시합니다.
                  도구가 파괴되기 전에 약간의 지연이 있습니다.

Tool Animation Repeat = false
- 애니메이션 재생을 반복할지 여부

Tool Special = nil
- 이 도구는 사전 정의된 특별한 동작을 정의하며 11가지 옵션을 사용할 수 있습니다.

  shield         - 이 도구는 방패 처럼 작동
  hook           - 후크샷 모드, 후크 캔, 잡기, 당기기등을 설정합니다.
  area           - 시전자 또는 대상 주변의 영역 공격이 됩니다.
  spiral         - 나선형 공격이 되며 사용자는 일부를 만들 것입니다.
  boomerang      - 부메랑이 되고 부메랑은 방울을 잡을 수 있고 태그가 지정됩니다.
                   이벤트 및 입력 키로 리디렉션할 수 있습니다.
  triple         - 동시에 3개의 발사체
  quintuple      - 동시에 5개의 발사체
  octuple        - 대각선을 포함하여 모든 방향으로 8개의 발사체를 로드합니다.
  autotarget     - 도구가 직선으로 이동하여 임의의 대상을 찾습니다.
  random         - 도구가 2단계 앞으로 이동하고 무작위로 이동합니다.
  common_event x - 공통 이벤트 ID에 대해 x 변경

Tool Target = false
- 타겟 지정 여부
  
Tool Invoke Skill = 0
- 무기 스킬 1의 기본 전투 시스템, 호출 스킬 2 방어용

Tool Guard Rate = 0
- 방패의 방어 성공 비율, 1~100 사이의 숫자를 입력

Tool Knockdown Rate = 70
- 넉다운 확률

Tool Sound Se = nil
- 도구를 사용할 때 재생되는 사운드 SE, 사운드를 원하지 않으면 nil을 넣습니다.

Tool Cooldown Display = false
- 도구 사용 시 스킬바에 쿨타임이 표시됩니다.

Tool Item Cost = 0
- 탄약, 화살, 폭탄 등을 소모하는 아이템 id
  
Tool Short Jump = false
- 도구 사용시 짧은 점프 여부

Tool Through = true
- 벽, 나무, 바위 등을 통과 여부

Tool Priority = 1
- 도구 표시 우선 순위 0 = 캐릭터 아래, 1 = 캐릭터 동일, 2 = 캐릭터 위

Tool Hit Shake = false
- 맞았을 때 화면이 흔들리기 여부

Tool Self Damage = false
- 사용자에게도 피해를 주는지 여부

Tool Combo Tool = nil
- 스킬 사용 후 적용되는 추가 콤보 스킬 여부

<ignore_voices>
- 도구를 사용할 때 전투원 음성이 재생되지 않습니다.

<ignore_followers>
- 이 도구는 동료에게 주는 피해를 무시합니다.

#==============================================================================#
=end