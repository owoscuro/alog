# encoding: utf-8
# Name: 011.rand prefix, suffix
# Size: 2859
=begin

<rand prefix: x> ||| <rand prefix: x,y,z>
항목 생성 시 임의의 접두사를 허용하려면 이것을 사용하십시오.
접두사 ID를 사용하고 "접두사 없음" 인스턴스에 숫자 0을 사용할 수 있습니다.

<rand suffix: x> ||| <rand suffix: x,y,z>
항목 생성 시 임의의 접미사를 허용하려면 이것을 사용하십시오.
접미사 ID가 있고 "접미사 없음" 인스턴스에 숫자 0을 사용할 수 있습니다.

=end

module TH_Instance
  module Equip
    Random_Affix_Allowed = {
      # Scene => Condition - 조건이 평가되었으므로 다음을 사용할 수 있습니다.
      # $game_switches[1] 스위치로 결정합니다.

      'Scene_Title' =>  'false',  #게임 시작 시 초기 장비.
      'Scene_Map' =>    'true',
      'Scene_Battle' => 'false',  #아이템 획득 창에 접사를 표시하지 않습니다.
      'Scene_Shop' =>   'false',  #랜덤구매시 선택이 불가합니다.
    }
  end
end

$imported = {} if $imported.nil?
$imported[:Sel_Random_Affixes] = true

unless $imported["TH_InstanceItems"]
  msgbox("Tsukihime's Instance not detected, exiting")
  exit
end

unless $imported[:TH_ItemAffixes]
  msgbox("Tsukihime's Item Affixes not detected, exiting")
  exit
end

class RPG::EquipItem
  def random_prefix
    # 자동 접미 실험
    if @random_prefix.nil?
      @random_prefix = [201,202,203,204,205,207,208,209,210,211,213,214,215,217,
      218,219,221,222,223,225,226,227,228,251,252,253,254,255,256,257,258,259,
      260,261,262,263,264,265,267,268,269,271,272,273,274,276,277,278,280,281,
      282]
      return @random_prefix[rand(@random_prefix.size)]
    end
  end
  
  def random_suffix
    if @random_suffix.nil?
      @random_suffix = [
      230,231,239,230,231,239,230,231,239,230,231,239,230,231,239,
      230,231,239,230,231,239,230,231,239,230,231,239,230,231,239,
      230,231,231,231,231,231,231,231,230,231,230,231,230,231,
      230,231,230,231,230,231,230,231,232,230,231,231,231,231,231,231,231,230,
      231,230,231,230,231,230,231,230,231,230,231,230,231,232,233,234,235,236,
      237,238,239,240,241,242,243,244,245,246,247,248,249,284,285,286,287,288,
      289,290,291,292,293,294,295,292,293,294,295,296,297,298,299,300,301]
      return @random_suffix[rand(@random_suffix.size)]
    end
  end
end

module InstanceManager
  class << self
    alias :random_affix_equip_setup :setup_equip_instance
  end

  def self.setup_equip_instance(obj)
    random_affix_equip_setup(obj)
    return if rand(10) >= 2
    return if $game_switches[281] == false
    return if TH_Instance::Equip::Random_Affix_Allowed[SceneManager.scene.class.to_s].nil?
    if eval(TH_Instance::Equip::Random_Affix_Allowed[SceneManager.scene.class.to_s])
      obj.prefix_id = obj.random_prefix
      obj.suffix_id = obj.random_suffix
    end
  end
end