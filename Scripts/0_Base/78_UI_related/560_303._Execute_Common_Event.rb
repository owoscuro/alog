# encoding: utf-8
# Name: 303. Execute Common Event
# Size: 1737
#======================================================================#
# ForceComEvent
#-----------------------------------------------------------------------
# 커먼 이벤트 강제 실행
# LuD::ForceComEvent.start(common_event_id)
#======================================================================#
module LuD::ForceComEvent
  def self.start(id)
    common_event = $data_common_events[id]
    if common_event && common_event.list && !common_event.list.empty?
      if SceneManager.scene.is_a?(Scene_Map)
        interpreter = $game_map.interpreter
      elsif SceneManager.scene.is_a?(Scene_Battle)
        interpreter = $game_troop.interpreter
      else
        interpreter = Game_Interpreter.new
      end
      interpreter.setup(common_event.list)
      while interpreter.running?
        SceneManager.scene.update_basic
        if SceneManager.scene.is_a?(Scene_Map)
          $game_map.update(true)
          SceneManager.scene.instance_variable_get("@spriteset").update
        end
        interpreter.update
      end
    end
  end
end
#======================================================================#
# ForceComEvent 
#======================================================================#
module LuD::ForceComEvent
  def self.call_LuDCore_error
    raise LoadError, "LuDCore 스크립트가 필요합니다."
  end
  # 필요한 스크립트들 리스트에 적기 - 없으면 빈 배열
  require_list = []
  # 추가되는 스크립트의 이름
  script_name = :ForceComEvent
  LuD.add_script(script_name, *require_list) rescue call_LuDCore_error
end
#======================================================================#
# LuD
#======================================================================#