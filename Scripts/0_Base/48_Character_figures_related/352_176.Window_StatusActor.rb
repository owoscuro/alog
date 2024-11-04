# encoding: utf-8
# Name: 176.Window_StatusActor
# Size: 469
class Window_StatusActor < Window_Base
  def initialize(dx, dy)
    super(dx, dy, window_width, fitting_height(4))
    @actor = nil
  end
  
  def window_width; return Graphics.width - 160; end
  
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
  end
  
  def refresh
    contents.clear
    return unless @actor
    draw_actor_face(@actor, 0, 0)
    draw_actor_simple_status(@actor, 108, line_height / 2)
  end
end