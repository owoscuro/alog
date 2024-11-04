# encoding: utf-8
# Name: 200.DistributeParameterActor
# Size: 786
class Window_DistributeParameterActor < Window_Base
  attr_accessor :actor
  def initialize(x, y, actor)
    super(x, y, Graphics.width, line_height + 48)
    @actor = actor
    refresh
  end
  
  def refresh
    contents.clear
    # "ro_test" 는 Cache.picture("Actor_Face3") 을 불러온다.
    draw_face2(@actor, @actor.face_index, 4, -10, "ro_test")
    draw_actor_name(@actor, 124, 26)

    xx = 180
    
    draw_actor_level(@actor, Graphics.width - (xx * 3), 26)
    draw_actor_rp(@actor, Graphics.width - xx * 2 - 50, 11, 170)
    draw_actor_rp2(@actor, Graphics.width - xx - 40, 11, 170)
    
    #draw_actor_level(@actor, contents.width / 2, 26)
    #draw_actor_rp(@actor, contents.width - (contents.width / 3) - 7, 11, contents.width / 3)
  end
end