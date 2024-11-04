# encoding: utf-8
# Name: 082.RPG_Map
# Size: 1540
class RPG::Map
  def stop_time
    @stop_time = (@note =~ /<stop[ _-]?time>/i ? true : false) if @stop_time.nil?
    @stop_time
  end
  
  def no_tone
    @no_tone = (@note =~ /<no[ _-]?tone>/i ? true : false) if @no_tone.nil?
    @no_tone
  end
  
  def def_tone
    @def_tone = (@note =~ /<def[ _-]?tone>/i ? true : false) if @def_tone.nil?
    @def_tone
  end
  
  def inside_map
    @inside_map = (@note =~ /<inside[ _-]?map>/i ? true : false) if @inside_map.nil?
    @inside_map
  end
  
  def no_weather
    @no_weather = (@note =~ /<no[ _-]?weather>/i ? true : false) if @no_weather.nil?
    @no_weather
  end
  
  def is_forest?
    @is_forest = (@note =~ /<forest>/i ? true : false) if @is_forest.nil?
    @is_forest
  end
end

class RPG::Tileset
  def stop_time
    @stop_time = (@note =~ /<stop[ _-]?time>/i ? true : false) if @stop_time.nil?
    @stop_time
  end
  
  def no_tone
    @no_tone = (@note =~ /<no[ _-]?tone>/i ? true : false) if @no_tone.nil?
    @no_tone
  end
  
  def def_tone
    @def_tone = (@note =~ /<def[ _-]?tone>/i ? true : false) if @def_tone.nil?
    @def_tone
  end
  
  def inside_map
    @inside_map = (@note =~ /<inside[ _-]?map>/i ? true : false) if @inside_map.nil?
    @inside_map
  end
  
  def no_weather
    @no_weather = (@note =~ /<no[ _-]?weather>/i ? true : false) if @no_weather.nil?
    @no_weather
  end
  
  def is_forest?
    @is_forest = (@note =~ /<forest>/i ? true : false) if @is_forest.nil?
    @is_forest
  end
end