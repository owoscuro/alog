# encoding: utf-8
# Name: 003.InstanceManager
# Size: 4802
=begin

 간단한 스크립트는 먼저 RPG 개체에서 메모 태그를 로드하고 저장합니다.
 템플릿과 함께. 예를 들어 모든 인스턴스에 무기를 제공한다고 가정해 보겠습니다.

 class RPG::Weapon < RPG::EquipItem
   def attack_bonus
     50
   end
 end

 이제 인스턴스 무기가 생성될 때마다 무작위 보너스 공격에 적용됩니다.
 InstanceManager 는 여러 "설정"을 제공합니다.

 setup_equip_instance(obj)  모든 장비(무기 또는 갑옷)에 사용
 setup_weapon_instance(obj) 무기에만 사용
 setup_armor_instance(obj)  갑옷에만 사용
 setup_item_instance(obj)   항목에만 사용

 우리의 예는 인스턴스 무기에 무작위 플랫 보너스를 적용하기 때문에
 무기 설정 방법의 별칭을 지정합니다.

 module InstanceManager
   class << self
     alias :th_random_weapon_bonus_setup_weapon_instance :setup_weapon_instance
   end

   def self.setup_weapon_instance(obj)
     template_obj = get_template(obj)
     th_random_weapon_bonus_setup_weapon_instance(obj)
     obj.params[2] += rand(template_obj.attack_bonus)
   end
 end

 설정에서 `get_template` 메소드를 사용하는 것에 주의하십시오.
 `obj`는 인스턴스입니다.

 예를 들어 개체의 이름을 수정하려면 별칭을 지정해야 합니다.
 이름을 가져와 새 이름을 반환하는 `make_name` 메서드.

 이벤트의 위치가 무작위로 지정되는 이벤트 페이지를 지정하려면 다음을 생성하십시오.

 <random position region: x type>

 start - 게임에서 한 번만: 이벤트가 처음 로드될 때
 init - 이벤트가 생성될 때
 page - 해당 페이지로 변경할 때
 
=end

$imported = {} if $imported.nil?
$imported["TH_InstanceItems"] = true
$imported["TH_RandomEventPositions"] = true
$imported["TH_MapDrops"] = true
$imported[:TH_ItemRarity] = true
$imported[:TH_ItemAffixRarity] = true

module TH
  module Instance_Items
    # 각 개체 유형에 대해 인스턴스 모드를 활성화합니다. 인스턴스 모드가
    # 활성화되면 해당 유형의 모든 객체가 인스턴스로 처리됩니다.
    Enable_Items = false
    Enable_Weapons = true
    Enable_Armors = true
  end
  
  module Item_Affix_Rarity
  end
end

module InstanceManager
  class << self
    attr_accessor :weapons
    attr_accessor :armors
    attr_accessor :items
    attr_reader :template_counts
  end
  
  def self.setup
    @template_counts = {}
    @template_counts[:weapon] = $data_weapons.size
    @template_counts[:armor] = $data_armors.size
    @template_counts[:item] = $data_items.size
  end
  
  def self.create_game_objects
    @weapons = {}
    @armors = {}
    @items = {}
  end
  
  def self.make_full_copy(obj)
    return Marshal.load(Marshal.dump(obj))
  end
  
  def self.instance_enabled?(obj)
    return TH::Instance_Items::Enable_Items if obj.is_a?(RPG::Item)
    return TH::Instance_Items::Enable_Weapons if obj.is_a?(RPG::Weapon)
    return TH::Instance_Items::Enable_Armors if obj.is_a?(RPG::Armor)
    return false
  end
  
  def self.is_template?(obj)
    return obj.id >= @template_counts[:item] if obj.is_a?(RPG::Item)
    return obj.id >= @template_counts[:weapon] if obj.is_a?(RPG::Weapon)
    return obj.id >= @template_counts[:armor] if obj.is_a?(RPG::Armor)
  end
  
  def self.make_instance(obj)
    new_obj = make_full_copy(obj)
    new_obj.template_id = new_obj.id
    return new_obj
  end
  
  def self.get_tables(obj)
    return @items, $data_items if obj.is_a?(RPG::Item)
    return @weapons, $data_weapons if obj.is_a?(RPG::Weapon)
    return @armors, $data_armors if obj.is_a?(RPG::Armor)
  end
  
  def self.get_template(obj)
    return $data_items[obj.template_id] if obj.is_a?(RPG::Item)
    return $data_weapons[obj.template_id] if obj.is_a?(RPG::Weapon)
    return $data_armors[obj.template_id] if obj.is_a?(RPG::Armor)
  end
  
  def self.get_instance(obj)
    return obj if obj.nil? || !instance_enabled?(obj) || !obj.is_template?
    new_obj = make_instance(obj)
    container, table = get_tables(obj)
    id = table.size
    
    new_obj.id = id
    # 필요에 따라 인스턴스 개체 설정
    setup_instance(new_obj)
    
    # 데이터베이스 및 컨테이너에 추가
    container[id] = new_obj
    table[id] = new_obj
    return new_obj
  end
  
  def self.setup_instance(obj)
    setup_equip_instance(obj) if obj.is_a?(RPG::EquipItem)
    setup_item_instance(obj) if obj.is_a?(RPG::Item)
  end

  def self.setup_equip_instance(obj)
    setup_weapon_instance(obj) if obj.is_a?(RPG::Weapon)
    setup_armor_instance(obj) if obj.is_a?(RPG::Armor)
  end
  
  def self.setup_weapon_instance(obj)
  end
  
  def self.setup_armor_instance(obj)
  end
  
  def self.setup_item_instance(obj)
  end
end