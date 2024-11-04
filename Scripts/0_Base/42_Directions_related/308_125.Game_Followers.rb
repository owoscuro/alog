# encoding: utf-8
# Name: 125.Game_Followers
# Size: 646
class Game_Followers
  def get_actor(id)
    list = [$game_player] + visible_followers
    list.select {|follower| follower.actor && follower.actor.id == id }.first
  end
  
  unless method_defined?(:visible_followers)
    def visible_followers
      visible_folloers
    end
  end

  def synchronize(x, y, d)
    each do |follower|
      next if follower.visible? and follower.battler.deadposing != nil
      follower.moveto(x, y)
      follower.set_direction(d)
    end
  end
  
  # 팔로어와 겹치는지 확인
  def follower_passable?(x, y)
    visible_folloers.any? {|follower| follower.pos_nt?(x, y)}
  end
end