# encoding: utf-8
# Name: 062.KMS_Commands
# Size: 2362
module KMS_Commands
  module_function
  #--------------------------------------------------------------------------
  # * 파라미터 분배에 관한 값을 체크
  #--------------------------------------------------------------------------
  def check_distribution_values
    (1...$data_actors.size).each { |i|
      actor = $game_actors[i]
      actor.check_distribution_values
      actor.restore_distribution_values
    }
  end
  
  #--------------------------------------------------------------------------
  # * RP 증감
  #--------------------------------------------------------------------------
  def gain_rp(actor_id, value)
    actor = $game_actors[actor_id]
    return if actor == nil
    actor.gain_rp(value)
  end
  
  #--------------------------------------------------------------------------
  # * 분배 수행
  #--------------------------------------------------------------------------
  def distribute_param_actor(actor_id, key, num = 1)
    actor = $game_actors[actor_id]
    return if actor == nil
    
    # 역가산 판정
    reverse = false
    if num < 0
      reverse = true
      num = num.abs
    end
      
    # 적용 가능
    num.times { |i| actor.rp_growth_effect(key, reverse) }
  end
  
  #--------------------------------------------------------------------------
  # * 분배 횟수 재설정
  #--------------------------------------------------------------------------
  def reset_distributed_count(actor_id)
    actor = $game_actors[actor_id]
    return if actor == nil
    actor.clear_distribution_values
    actor.restore_distribution_values
  end
  
  #--------------------------------------------------------------------------
  # * 파라미터 분배 화면 호출
  #--------------------------------------------------------------------------
  def call_distribute_parameter(actor_index = 0)
    return if $game_party.in_battle
    $game_temp.call_distribute_parameter = true
    $game_party.menu_actor = $game_party.members[actor_index]
  end
  
  #--------------------------------------------------------------------------
  # * 기본 매뉴 수정 호출 플래그
  #--------------------------------------------------------------------------
  def call_menu
    return if $game_party.in_battle
    $game_temp.call_menu = true
    $game_party.menu_actor = $game_party.members[actor_index]
  end
end