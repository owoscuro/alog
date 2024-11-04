# encoding: utf-8
# Name: 132.Game_LightEffect
# Size: 467
class Game_LightEffect
  attr_accessor :id
  attr_accessor :name
  attr_accessor :info
  attr_accessor :opacity
  attr_accessor :x
  attr_accessor :y
  #attr_accessor :variance
  attr_accessor :speed
  attr_accessor :zoom
  attr_accessor :opacity_target
  attr_accessor :opacity_duration
  
  def change_opacity(op, d)
    @opacity_target   = op
    @opacity_duration = [d, 0].max
    @opacity = @opacity_target if @opacity_duration == 0
  end
end