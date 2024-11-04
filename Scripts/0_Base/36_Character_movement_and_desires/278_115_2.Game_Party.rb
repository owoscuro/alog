# encoding: utf-8
# Name: 115_2.Game_Party
# Size: 7026
class Game_Party < Game_Unit
  alias :th_instance_items_init_all_items :init_all_items
  def init_all_items
    th_instance_items_init_all_items
    @item_list = []
    @weapon_list = []
    @armor_list = []
  end
  
  #-----------------------------------------------------------------------------
  # 덮어쓰기 우리는 이미 무기 목록을 유지합니다
  #-----------------------------------------------------------------------------
  alias :th_instance_items_weapons :weapons
  def weapons
    TH::Instance_Items::Enable_Weapons ? @weapon_list.clone : th_instance_items_weapons
  end
  
  #-----------------------------------------------------------------------------
  # Overwrite.
  #-----------------------------------------------------------------------------
  alias :th_instance_items_items :items
  def items
    TH::Instance_Items::Enable_Items ? @item_list.clone : th_instance_items_items
  end
  
  #-----------------------------------------------------------------------------
  # Overwrite.
  #-----------------------------------------------------------------------------
  alias :th_instance_items_armors :armors
  def armors
    TH::Instance_Items::Enable_Armors ? @armor_list.clone : th_instance_items_armors
  end
  
  #-----------------------------------------------------------------------------
  # 항목 유형이 인스턴스를 지원하는 경우 true를 반환합니다.
  #-----------------------------------------------------------------------------
  def instance_enabled?(item)
    return InstanceManager.instance_enabled?(item)
  end
  
  #-----------------------------------------------------------------------------
  # 주어진 항목의 인스턴스를 반환합니다. 이미 인스턴스인 경우
  # 그냥 반환합니다. 템플릿인 경우 새 인스턴스를 만듭니다.
  #-----------------------------------------------------------------------------
  def get_instance(item)
    return InstanceManager.get_instance(item)
  end
  
  #-----------------------------------------------------------------------------
  # Returns the template for the given item
  #-----------------------------------------------------------------------------
  def get_template(item)
    return InstanceManager.get_template(item)
  end
  
  #-----------------------------------------------------------------------------
  # 게인 아이템 방식은 원하는 아이템에 대해 다양한 검사를 수행합니다.
  # 인벤토리에 추가합니다. 즉, 템플릿 항목인지 확인합니다.
  # 인스턴스 항목, 항목 수 업데이트 등.
  #-----------------------------------------------------------------------------
  alias :th_instance_items_gain_item :gain_item
  def gain_item(item, amount, include_equip = false)
    # 일반 품목에 대한 특별 점검
    if !instance_enabled?(item)
      th_instance_items_gain_item(item, amount, include_equip)
    else
      if item
        if amount > 0
          amount.times do |i|
            new_item = get_instance(item)
            add_instance_item(new_item)
          end
        else
          amount.abs.times do |i|
            item_template = get_template(item)
            if item.is_template?
              # 템플릿 규칙을 사용하여 제거합니다. 항목이 손실된 경우 감소
              # 템플릿 개수는 1입니다.
              lose_template_item(item, include_equip)
            else
              # 인스턴스 항목을 제거하고 템플릿 수를 1로 줄입니다.
              lose_instance_item(item)
            end
          end
        end
      else
        th_instance_items_gain_item(item, amount, include_equip)
      end
    end
  end
  
  #-----------------------------------------------------------------------------
  # New. Returns the appropriate container list
  #-----------------------------------------------------------------------------
  def item_container_list(item)
    return @item_list if item.is_a?(RPG::Item)
    return @weapon_list if item.is_a?(RPG::Weapon)
    return @armor_list if item.is_a?(RPG::Armor)
  end
  
  #-----------------------------------------------------------------------------
  # New. Adds the instance item to the appropriate list
  #-----------------------------------------------------------------------------
  def add_instance_item(item)
    container = item_container(item.class)
    container[item.template_id] ||= 0
    container[item.template_id] += 1
    container[item.id] = 1
    container_list = item_container_list(item)
    container_list.push(item)
  end
  
  #-----------------------------------------------------------------------------
  # 새로운. 템플릿과 일치하는 인스턴스 항목을 반환합니다. 그렇지 않으면
  # 존재하면 nil을 반환
  #-----------------------------------------------------------------------------
  def find_instance_item(template_item)
    container_list = item_container_list(template_item)
    return container_list.find {|obj| obj.template_id == template_item.template_id }
  end
  
  #-----------------------------------------------------------------------------
  # 새로운. 인스턴스 아이템을 잃습니다. 적절한 컨테이너에서 삭제하기만 하면 됩니다.
  # 목록
  #-----------------------------------------------------------------------------
  def lose_instance_item(item)
    container = item_container(item.class)
    container[item.template_id] ||= 0
    container[item.template_id] -= 1
    container[item.id] = 0
    container_list = item_container_list(item)
    container_list.delete(item)
  end
  
  #-----------------------------------------------------------------------------
  # 새로운. 템플릿 항목을 잃습니다. 이것은 찾는
  #-----------------------------------------------------------------------------
  def lose_template_item(item, include_equip)
    container_list = item_container_list(item)
    item_lost = container_list.find {|obj| obj.template_id == item.template_id }
    if item_lost
      container = item_container(item.class)
      container[item.template_id] ||= 0
      container[item.template_id] -= 1
      container_list.delete(item_lost)
    elsif include_equip
      discard_members_template_equip(item, 1)
    end
    return item_lost
  end

  #-----------------------------------------------------------------------------
  # 새로운. 템플릿 폐기 규칙을 따른다는 점을 제외하고는 장비 폐기와 동일합니다.
  #-----------------------------------------------------------------------------
  def discard_members_template_equip(item, amount)
    n = amount
    members.each do |actor|
      item = actor.equips.find {|obj| obj && obj.template_id == item.template_id }
      while n > 0 && item
        actor.discard_equip(item)
        n -= 1
      end
    end
  end
end