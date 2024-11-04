# encoding: utf-8
# Name: 134.Game_Event
# Size: 1733
class Game_Event
  alias tmmrbt_game_event_clear_page_settings clear_page_settings
  def clear_page_settings
    tmmrbt_game_event_clear_page_settings
    @mrbt_type = nil
    @mrbt = nil
  end
  
  alias tmmrbt_game_event_setup_page_settings setup_page_settings
  def setup_page_settings
    tmmrbt_game_event_setup_page_settings
    set_next_mrbt_count
    @mrbt_type = /<mrbt\s+(\S+?)>/i =~ @event.name ? $1 : nil
    @mrbt = nil
    if @list
      @list.each do |list|
        if list.code == 108 || list.code == 408
          @mrbt_type = $1 if /<mrbt\s+(\S+?)>/i =~ list.parameters[0]
        else
          break
        end
      end
    end
  end
  
  alias tmmrbt_game_event_update update
  def update
    tmmrbt_game_event_update
    # --------------------------------------------------------------------------
    # 아래는 시간 가속중이 아닌 경우에만 적용
    # --------------------------------------------------------------------------
    # 프레임 조작 실험
    if $sel_time_frame_30 == 4 and $game_switches[283] == false
      #print("기타 관련 - 087.미니 대화창 - update \n");
      update_mrbt
    end
  end
  
  def update_mrbt
    if @mrbt_count && @mrbt_count > 0
      @mrbt_count -= 1
      if @mrbt_count == 0
        @mrbt = get_random_mrbt
        set_next_mrbt_count
      end
    end
  end
  
  def get_random_mrbt
    return nil unless @mrbt_type && TMMRBT::DATABASE[@mrbt_type]
    TMMRBT::DATABASE[@mrbt_type][rand(TMMRBT::DATABASE[@mrbt_type].size)].clone
  end
  
  def set_next_mrbt_count
    n = rand([TMMRBT::MAX_INTERVAL - TMMRBT::MIN_INTERVAL, 1].max)
    @mrbt_count = TMMRBT::MIN_INTERVAL + n
  end
end