# encoding: utf-8
# Name: 106.Game_Action
# Size: 1256
class Game_Action
  def targets_for_friends
    print("106.Game_Action - ");
    print("팔로워 대상 타겟 \n");
    if item.for_user?
      [subject]
    elsif item.for_dead_friend?
      if item.for_one?
        [friends_unit.smooth_dead_target(@target_index)]
      else
        friends_unit.dead_members
      end
    elsif item.for_friend?
      if item.for_one?
        if @target_index < 0
          [friends_unit.random_target]
        else
          [friends_unit.smooth_target(@target_index)]
        end
      else
        friends_unit.alive_members
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # ● 행동 속도 계산
  #--------------------------------------------------------------------------
  alias speed_KMS_DistributeParameter speed
  def speed
    speed = speed_KMS_DistributeParameter
    return speed if attack?
    if item.is_a?(RPG::Skill) && item.speed < 0
      n = [subject.distributed_param(:skill_speed), item.speed.abs].min
      speed += n
    elsif item.is_a?(RPG::Item) && item.speed < 0
      n = [subject.distributed_param(:item_speed), item.speed.abs].min
      speed += n
    end
    return speed
  end
end