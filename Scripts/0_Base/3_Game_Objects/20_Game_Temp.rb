# encoding: utf-8
# Name: Game_Temp
# Size: 2531
#==============================================================================
# ** Game_Temp
#------------------------------------------------------------------------------
# 이 클래스는 저장 데이터에 포함되지 않은 임시 데이터를 처리합니다.
# 이 클래스의 인스턴스는 $game_temp에 의해 참조됩니다.
#==============================================================================

class Game_Temp
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :common_event_id          # Common Event ID
  attr_accessor :fade_type                # Fade Type at Player Transfer
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    @common_event_id = 0
    @fade_type = 0
  end
  #--------------------------------------------------------------------------
  # * 공통 이벤트 콜 예약
  #--------------------------------------------------------------------------
  def reserve_common_event(common_event_id)
    #print("Game_Temp 1 : %s 실행 \n" % [common_event_id]);
    @common_event_id = common_event_id
  end
  #--------------------------------------------------------------------------
  # * 명확한 공동 이벤트 콜 예약
  #--------------------------------------------------------------------------
  def clear_common_event
    #print("Game_Temp 4 : %s 확인 \n" % [@common_event_id]) if @common_event_id != 0
    @common_event_id = 0
  end
  #--------------------------------------------------------------------------
  # * 공통 이벤트 호출의 예약 결정
  #--------------------------------------------------------------------------
  def common_event_reserved?
    #print("Game_Temp - %s \n" % [@common_event_id > 0]);
    @common_event_id > 0
  end
  #--------------------------------------------------------------------------
  # * 예약 공통 이벤트 받기
  #--------------------------------------------------------------------------
  def reserved_common_event
    #return if @common_event_id == nil or @common_event_id == 0
    #@interpreter = Game_Interpreter.new if @interpreter == nil
    #print("Game_Temp 3 : %s 실행 \n" % [@common_event_id]);
    $data_common_events[@common_event_id]
  end
end