# encoding: utf-8
# Name: 020.IMIR_Commands
# Size: 389
module IMIR_Commands
  module_function
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 수정치를 재설정
  #--------------------------------------------------------------------------
  def restore_passive_rev
    (1...$data_actors.size).each { |i|
      actor = $game_actors[i]
      actor.restore_passive_rev
    }
  end
end