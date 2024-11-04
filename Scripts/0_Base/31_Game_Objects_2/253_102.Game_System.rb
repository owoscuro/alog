# encoding: utf-8
# Name: 102.Game_System
# Size: 1229
class Game_System
  attr_accessor :remain_killed
  attr_accessor :skillbar_enable, :pearlbars, :enemy_lifeobject
  attr_accessor :shop_buy_category        # 구매시 카테고리
  attr_accessor :shop_sell_category       # 판매시 카테고리
  attr_accessor :picture_screen_z
  
  attr_reader :masv_states_afflicted
  
  alias molbr_stvw_inze_4rp8 initialize
  def initialize(*args, &block)
    masv_initialize_statebuff_counters
    
    molbr_stvw_inze_4rp8(*args, &block)
    
    print("102.Game_System - ");
    print("생성 \n");
    @picture_screen_z = MOG_PICURE_EFFECTS::DEFAULT_SCREEN_Z
    @random_position_event = {}
    @shop_buy_category = []
    @shop_sell_category = []
    @remain_killed = {}
    # 스킬 단축키창, 스킬바 관련
    unless PearlKernel::StartWithHud
      @skillbar_enable = true
      @pearlbars = true
    end
  end
  
  def masv_initialize_statebuff_counters
    @masv_states_afflicted = []
  end
  
  def reveal_state_description(state_id)
    $game_system.masv_states_afflicted.push(state_id) unless $game_system.masv_states_afflicted.include?(state_id)
  end
  
  def random_position_event
    @random_position_events ||= {}
  end
end