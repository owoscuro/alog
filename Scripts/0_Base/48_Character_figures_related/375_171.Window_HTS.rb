# encoding: utf-8
# Name: 171.Window_HTS
# Size: 657
class Window_HTS < Window_Base
  def initialize(x, y)
    super(0, Graphics.height - 40, 300, 70)
    self.z = 999
    self.opacity = 0
    refresh
  end
  
  def refresh
    if $game_switches[281] == true
      #print("생존 관련 + Window_Base - Window_HTS refresh \n");
      contents.clear
      actor = $game_party.leader
      #print("171.Window_HTS - refresh[%s] \n" % [actor]);
      draw_actor_hunger(actor, -14, 0)
      draw_actor_thirst(actor, 37, 0)
      draw_actor_sleep(actor, 88, 0)
      # 휴식중일때 3대 욕구 변화 적용
      $game_switches[226] = false if $game_switches[226] == true
    end
  end
end