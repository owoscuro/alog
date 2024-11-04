# encoding: utf-8
# Name: 214.Window_ShowMap
# Size: 2202
class Window_ShowMap < Window_Base
  include Lune_Map
  def initialize
    super(-32, -32, Graphics.width + 64, Graphics.height + 64)
    self.windowskin = nil

    # 마차 이용 시작 지역 대입 실험
    $game_variables[191] = $game_variables[185]
    print("057.월드 맵 빠른 이동 1 - %s, %s \n" % [$game_variables[191], $game_variables[185]]);
    
    @x = ($lune_map_info[$game_variables[185]]['Position'][0] * 0.3) - window_width / 2
    @y = ($lune_map_info[$game_variables[185]]['Position'][1] * 0.3) - window_height / 2

    @nx = 0
    @ny = 0
    @icon = Sprite.new
    @icon.z = 201
    @bitmap = Cache.world_map(Map_Name)
    refresh($game_variables[185]) unless $lune_map_info == []
  end
  
  def window_width
    Graphics.width  # - 126
  end
  
  def window_height
    Graphics.height # - fitting_height(2) + 24
  end
  
  def line_color
    color = normal_color
    color.alpha = 48
    color
  end
  
  def refresh(index)
    self.contents.clear
    @x += 32 if @x <= ($lune_map_info[index]['Position'][0] * 0.3) - window_width / 2
    @x -= 32 if @x >= ($lune_map_info[index]['Position'][0] * 0.3) - window_width / 2
    @y += 32 if @y <= ($lune_map_info[index]['Position'][1] * 0.3) - window_height / 2
    @y -= 32 if @y >= ($lune_map_info[index]['Position'][1] * 0.3) - window_height / 2
    unless @index == index
      @index = index 
      @icon.bitmap = Cache.world_map($lune_map_info[index]['Icon']) 
    end
      @icon.x = ($lune_map_info[index]['Position'][0] * 0.3) + 160 - @nx - 166
      @icon.y = ($lune_map_info[index]['Position'][1] * 0.3) + 80 - @ny - 86
    if @x > @bitmap.width + 24 - window_width - 166
      @nx = @bitmap.width + 24 - window_width - 166
    elsif @x < 0
      @nx = 0
    else
      @nx = @x
    end
    if @y > @bitmap.height + 24 - window_height - 128
      @ny = @bitmap.height + 24 - window_height - 128
    elsif @y < 0
      @ny = 0
    else
      @ny = @y
    end
    rect = Rect.new(@nx-12, @ny-12, self.width , self.height)
    contents.blt(0, 0, @bitmap, rect)
  end
  
  def dispose
    super
    @icon.bitmap.dispose
    @icon.dispose
  end
end