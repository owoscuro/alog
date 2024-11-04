# encoding: utf-8
# Name: 103.Game_Picture
# Size: 440
class Game_Picture
  attr_accessor :effect_ex
  attr_accessor :anime_frames
  attr_accessor :position
  
  alias mog_picture_ex_init_basic init_basic
  def init_basic
    init_effect_ex
    mog_picture_ex_init_basic
  end

  alias mog_picture_ex_erase erase
  def erase
    init_effect_ex
    mog_picture_ex_erase
  end

  def init_effect_ex
    @effect_ex = [] ; @anime_frames = [] ; @position = [0,nil,0,0]
  end
end