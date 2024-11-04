# encoding: utf-8
# Name: 130.Game_Screen
# Size: 485
class Game_Screen
  attr_reader   :lights
  attr_reader   :shade
  attr_accessor :remove_light
  
  alias :clear_ve_light_effects :clear
  def clear
    clear_ve_light_effects
    clear_lights
  end
  
  def clear_lights
    @lights = {}
    @remove_light = []
    @shade = Game_ShadeEffect.new
  end
  
  def lights
    @lights ||= {}
  end
  
  def remove_light
    @remove_light ||= []
  end
  
  def shade
    @shade ||= Game_ShadeEffect.new
  end
end