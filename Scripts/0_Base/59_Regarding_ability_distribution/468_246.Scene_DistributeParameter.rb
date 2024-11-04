# encoding: utf-8
# Name: 246.Scene_DistributeParameter
# Size: 5966
class Scene_DistributeParameter < Scene_MenuBase
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
    @prev_actor = @actor
    @prev_info  = @actor.distribution_info
    create_help_window
    create_face_window
    create_parameter_window
    create_status_window
    create_confirm_window
  end
  #--------------------------------------------------------------------------
  # ● 액터 결정 추가 종료
  #--------------------------------------------------------------------------
  def create_face_window
    @face_window = Window_DistributeParameterActor.new(0, 0, @actor)
    @face_window.viewport = @viewport
  end
  
  def create_parameter_window
    @parameter_window = Window_DistributeParameterList.new(@actor)
    @parameter_window.viewport = @viewport
    @parameter_window.activate
    @parameter_window.set_handler(:ok,       method(:on_parameter_ok))
    @parameter_window.set_handler(:cancel,   method(:on_parameter_cancel))
    @parameter_window.set_handler(:increase, method(:on_parameter_increase))
    @parameter_window.set_handler(:decrease, method(:on_parameter_decrease))
    @parameter_window.set_handler(:down,     method(:update_status))
    @parameter_window.set_handler(:up,       method(:update_status))
    @parameter_window.set_handler(:pagedown, method(:next_actor))
    @parameter_window.set_handler(:pageup,   method(:prev_actor))
  end
  
  #--------------------------------------------------------------------------
  # ○ 배분 상태 창 작성
  #--------------------------------------------------------------------------
  def create_status_window
    @status_window = Window_DistributeParameterStatus.new(@actor)
    @status_window.viewport = @viewport
    @help_window.z = @status_window.z + 100
    @help_window.openness = 0
  end
  
  #--------------------------------------------------------------------------
  # ○ 확인 창 만들기
  #--------------------------------------------------------------------------
  def create_confirm_window
    @confirm_window = Window_DistributeParameterConfirm.new(0, 0)
    @confirm_window.x = (Graphics.width  - @confirm_window.width)  / 2
    @confirm_window.y = (Graphics.height - @confirm_window.height) / 2
    @confirm_window.z = @help_window.z
    @confirm_window.viewport    = @viewport
    @confirm_window.help_window = @help_window
    @confirm_window.openness    = 0
    @confirm_window.deactivate
    @confirm_window.set_handler(:decide, method(:on_confirm_decide))
    @confirm_window.set_handler(:stop,   method(:on_confirm_stop))
    @confirm_window.set_handler(:cancel, method(:on_confirm_cancel))
  end
  
  #--------------------------------------------------------------------------
  # ○ 창 다시 그리기
  #--------------------------------------------------------------------------
  def refresh_window
    @face_window.refresh
    @parameter_window.refresh
    @status_window.refresh(@parameter_window.parameter_key)
    Graphics.frame_reset
  end
  
  def on_parameter_ok
    command_confirm
  end
  
  def on_parameter_cancel
    command_confirm
  end
  
  def on_parameter_increase
    param = @parameter_window.parameter_key
    unless @actor.can_distribute?(param)
      return
    end
    Sound.play_cursor
    @actor.rp_growth_effect(param)
    refresh_window
  end
  
  def on_parameter_decrease
    param = @parameter_window.parameter_key
    unless reversible?(param)
      return
    end
    Sound.play_cursor
    @actor.rp_growth_effect(param, true)
    refresh_window
  end
  
  def update_status
    @status_window.refresh(@parameter_window.parameter_key)
  end
  
  #--------------------------------------------------------------------------
  # ○ 감산 여부 판정
  #--------------------------------------------------------------------------
  def reversible?(param)
    return false if @actor.distributed_count(param) == 0
    return true  if KMS_DistributeParameter::ENABLE_REVERSE_DISTRIBUTE
    # 오류 수정
    if @prev_info.count == nil
      base = 0
    else
      base = @prev_info.count[param]
    end
    base = 0 if base == nil
    return ( base < @actor.distributed_count(param) )
  end
  
  def command_parameter
    @confirm_window.deactivate
    @confirm_window.close
    @help_window.close
    @face_window.open  # 실험
    @parameter_window.activate
  end
  
  def command_confirm
    @confirm_window.index  = 0
    @confirm_window.activate
    @confirm_window.open
    @face_window.close  # 실험
    @help_window.open
    @parameter_window.deactivate
  end
  
  def on_confirm_decide
    return_scene
  end
  
  def on_confirm_stop
    @actor.set_distribution_info(@prev_info)
    return_scene
  end
  
  def on_confirm_cancel
    command_parameter
  end
  
  def on_actor_change
    @prev_actor.set_distribution_info(@prev_info)
    @prev_info  = @actor.distribution_info
    @prev_actor = @actor
    @face_window.actor     = @actor
    @parameter_window.actor = @actor
    @status_window.actor    = @actor
    @parameter_window.activate
    refresh_window
  end
end