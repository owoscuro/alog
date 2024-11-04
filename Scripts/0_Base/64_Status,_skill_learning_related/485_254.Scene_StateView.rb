# encoding: utf-8
# Name: 254.Scene_StateView
# Size: 1823
class Scene_StateView < Scene_MenuBase
  def start
    super
    create_location_window
    create_actor_window
  end
  
  #--------------------------------------------------------------------------
  # ● 액터 결정 추가
  #--------------------------------------------------------------------------
  def create_location_window
    @location_window = Window_location.new(0, 0)
  end
  
  def create_actor_window
    @actor_window = Window_MenuStatus.new(0,72)
    @actor_window.viewport = @viewport
    @actor_window.set_handler(:ok,     method(:on_actor_ok))
    @actor_window.set_handler(:cancel, method(:return_scene))
    @actor_window.index = 0
    @actor_window.activate
  end
  
  def on_actor_ok
    @actor = $game_party.members[@actor_window.index]
    @actor_window.hide.deactivate
    @location_window.hide.deactivate
    create_face_window
    create_states_window
  end
  #--------------------------------------------------------------------------
  # ● 액터 결정 추가 종료
  #--------------------------------------------------------------------------
  
  def on_actor_change
    @states_window.actor = @actor
    @states_window.refresh
    @face_window.actor = @actor
    @face_window.refresh
    @states_window.activate
    Graphics.frame_reset
  end
  
  def create_states_window
    @states_window = Window_StateView.new(@actor)
    @states_window.set_handler(:ok,     method(:return_scene))
    @states_window.set_handler(:cancel, method(:return_scene))
    @states_window.set_handler(:pagedown, method(:next_actor))
    @states_window.set_handler(:pageup,   method(:prev_actor))
  end
  
  def create_face_window
    @face_window = Window_DistributeParameterActor.new(0, 0, @actor)
    @face_window.viewport = @viewport
  end
end