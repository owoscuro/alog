# encoding: utf-8
# Name: Game_CommonEvent
# Size: 1917
#==============================================================================
# ** Game_CommonEvent
#------------------------------------------------------------------------------
#  This class handles common events. It includes functionality for execution of
# parallel process events. It's used within the Game_Map class ($game_map).
#==============================================================================

class Game_CommonEvent
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(common_event_id)
    @event = $data_common_events[common_event_id]
    #print("Game_CommonEvent - %s(%s) 실행 \n" % [@event.name, common_event_id]);
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    if active?
      @interpreter ||= Game_Interpreter.new
    else
      @interpreter = nil
    end
  end
  #--------------------------------------------------------------------------
  # * Determine if Active State
  #--------------------------------------------------------------------------
  def active?
    @event.parallel? && $game_switches[@event.switch_id]
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    # 조건에 !$game_system.menu_disabled 추가
    # 커먼 이벤트로 팅기는 오류 수정
    if @interpreter and !$game_system.menu_disabled
      @interpreter.setup(@event.list) unless @interpreter.running?
      @interpreter.update
    #elsif @interpreter
    #  @interpreter.update
    end
  end
end