# encoding: utf-8
# Name: 012.TH_Instance
# Size: 4054
# encoding: utf-8
# Name: 012.TH_Instance
# Size: 4135
=begin

  <set durability>
  내구도를 사용하도록 무기를 설정합니다.

  <max durability: x>
  x는 무기의 시작 내구도이며 기본값은 아래 설정입니다.

  <broken weapon change: x>
  <broken armor change: x>
  x는 사용할 때 얻는 새로운 "무기"의 ID입니다.
  예를 들어 "0/100 검" 대신 "부러진 검"을 원했습니다.

  <elem dura rate element_name: x>
  element_name 은 데이터베이스에서 생성하는 요소의 이름입니다.
  x는 0.5 또는 -0.5 와 같은 부동 소수점 수입니다, 음수는 기회를 줄입니다
  내구도는 감소하고 양수는 확률을 증가시킵니다.

  <skill durability mod x: y>
  x는 수정하고자 하는 내구도 비용이 있는 스킬의 id이고 y는 수정하고자 하는 정도입니다. 
  y는 양수이거나 음수, 무기 내구도는 이를 통해 "수리"할 수 없습니다.

  <durability cost: x>
  x는 무기의 내구도가 얼마나 사용되는지, 기본값은 상수입니다.

  <durability damage: x>
  x는 액터가 명중할 때 갑옷의 내구도가 얼마나 감소하는지입니다.
  
=end

module TH_Instance
  module Weapon
    # 최대 내구도일 때 무기 내구도 지정으로 설정
    Default_Durability = 100
    
    # 스킬을 성공적으로 사용하기 위한 기본 비용으로 설정합니다.
    # 내구력이 장착된 상태에서 장비가 가능합니다.
    Default_Durability_Cost = 1
    
    # 무기가 파괴될 때 어떤 일이 일어날지 결정합니다.
    # true, 그러면 인벤토리에서 완전히 사라집니다.
    # 거짓이라면, 내구도가 0인 버전을 유지하거나 새 버전으로 변경합니다.
    # "무기" 부서진 무기 메모 태그를 통해 선택
    Destroy_Broken_Weapon = false
    
    # 이것은 장비의 기본 동작과 장비의 동작을 결정합니다.
    # <set Durability> 태그는 항상 반대입니다.
    Durability_Setting = false
    
    # 내구성 접미사의 형식
    Dur_Suf = '(%s/%s)'
  end
  
  module Armor
    # 최대 내구도일 때 무기 내구도 지정으로 설정
    Default_Durability = 100
    
    # 스킬을 성공적으로 사용하기 위한 기본 비용으로 설정합니다.
    # 내구력이 장착된 상태에서 장비가 가능합니다.
    Default_Durability_Damage = 1
    
    # 방어구의 내구도가 외부 없이 감소하는 비율
    Durability_Reduce_Rate = 0.5
    
    # 무기가 파괴될 때 어떤 일이 일어날지 결정합니다.
    Destroy_Broken_Armor = false
    
    # 이것은 장비의 기본 동작과 장비의 동작을 결정합니다.
    # <set Durability> 태그는 항상 반대입니다.
    Durability_Setting = false

    # 내구성 접미사의 형식
    Dur_Suf = '(%s/%s)'

    def self.elem_dura_rate(element_id)
      /<elem[-_ ]?dura[-_ ]?rate[-_ ]?#{$data_system.elements[element_id]}:\s*(.*)\s*>/i
    end
  end
  
  module Scene_Repair
    # Mostrar un vocabulario similar a la compra/venta para seleccionar una ventana de elementos
    Vocab = "Reparar"
    
    # No hay equipo.
    No_Selected_Item = "No hay equipo que necesite reparación."
    
    # Mensaje de ayuda que se muestra en el equipo reparable.
    Selected_Item = "Este equipo necesita reparación."
    
    # Mensaje de ayuda que se muestra en los elementos que ya tienen durabilidad máxima.
    Can_Not_Repair = "La durabilidad ya está al máximo."
    
    # 장비 수리 성공 시 효과음이 재생되었습니다.
    # SE_Name, Volume, Pitch
    SE = ['Bell2',100,100]
    
    # 수리 가격 = (current_durability / max_durability) * Purchase_Price
    Price_Mod = 5.0
  end
end

$imported = {} if $imported.nil?
$imported[:Sel_Weapon_Durability] = true
$imported[:Sel_Armor_Durability] = true
$imported[:Sel_Equip_Dura_Repair] = true

unless $imported["TH_InstanceItems"]
  msgbox("인스턴스 스크립트가 감지되지 않아 종료합니다.")
  exit
end