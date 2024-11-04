# encoding: utf-8
# Name: 124.Projectile
# Size: 329
class Projectile < Game_Character
  alias falcao_lifebars_execute execute_damageto_enemy
  
  def execute_damageto_enemy(event)
    # 프로젝트 타일 데미지
    if @user.is_a?(Game_Player) && !event.battler.object
      $game_system.enemy_lifeobject = event
    end
    falcao_lifebars_execute(event)
  end
end