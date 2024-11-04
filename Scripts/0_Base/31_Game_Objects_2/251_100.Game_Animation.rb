# encoding: utf-8
# Name: 100.Game_Animation
# Size: 1615
class Game_Animation
  attr_accessor :ox
  attr_accessor :oy
  attr_accessor :rate
  attr_accessor :zoom
  attr_accessor :loop
  attr_accessor :type
  attr_accessor :map_x
  attr_accessor :map_y
  attr_accessor :mirror
  attr_accessor :follow
  attr_accessor :height
  attr_accessor :bitmap1
  attr_accessor :bitmap2
  attr_accessor :sprites
  attr_accessor :duration
  attr_accessor :direction
  attr_accessor :duplicated
  
  def initialize(animation, mirror, user = nil)
    @animation = animation
    @rate      = animation.name =~ /<RATE: ([+-]?\d+)>/i ? [$1.to_i, 1].max : 4
    @zoom      = animation.name =~ /<ZOOM: (\d+)%?>/i ? $1.to_i / 100.0 : 1.0
    @follow    = animation.name =~ /<FOLLOW>/i ? true : false
    @mirror    = mirror
    @duration  = frame_max * @rate
    @direction = user.anim_direction if user
    @sprites   = []
    bellow     = animation.name =~ /<BELLOW>/i
    above      = animation.name =~ /<ABOVE>/i
    @height    = bellow ? -1 : above ? 300 : 1
  end
  
  def data
    @animation
  end
  
  def id
    @animation.id
  end
  
  def name
    @animation.name
  end
  
  def frame_max
    @animation.frame_max
  end
  
  def position
    @animation.position
  end
  
  def animation1_name
    @animation.animation1_name
  end
  
  def animation2_name
    @animation.animation2_name
  end
  
  def animation1_hue
    @animation.animation1_hue
  end
  
  def animation2_hue
    @animation.animation2_hue
  end
  
  def frames
    @animation.frames
  end
  
  def timings
    @animation.timings
  end
end