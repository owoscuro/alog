# encoding: utf-8
# Name: 292.Game_System
# Size: 1246
class Game_System
  alias game_system_initialize_so initialize
  def initialize
    game_system_initialize_so
    init_volume_control
    init_autodash
    init_instantmsg
  end
  
  def init_volume_control
    @volume = {}
    @volume[:bgm] = 100
    @volume[:bgs] = 100
    @volume[:sfx] = 100
  end
  
  def volume(type)
    init_volume_control if @volume.nil?
    return [[@volume[type], 0].max, 100].min
  end

  def set_volume(type, value)
    init_volume_control if @volume.nil?
    @volume[type] = [[value, 0].max, 100].min
    case type
    when :bgm
      RPG::BGM::last.play
    when :bgs
      RPG::BGS::last.play
    end
  end
  
  def volume_change(type, increment)
    set_volume(type, @volume[type] + increment)
  end
  
  def init_autodash
    @autodash = YEA::SYSTEM::DEFAULT_AUTODASH
  end
  
  def autodash?
    init_autodash if @autodash.nil?
    return @autodash
  end
  
  def set_autodash(value)
    @autodash = value
  end
  
  def init_instantmsg
    @instantmsg = YEA::SYSTEM::DEFAULT_INSTANTMSG
  end
  
  def instantmsg?
    init_instantmsg if @instantmsg.nil?
    return @instantmsg
  end
  
  def set_instantmsg(value)
    @instantmsg = value
  end
end