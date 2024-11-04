# encoding: utf-8
# Name: 092.Numeric, Node
# Size: 2667
Font.default_name = YEA::CORE::FONT_NAME
Font.default_size = YEA::CORE::FONT_SIZE
Font.default_bold = YEA::CORE::FONT_BOLD
Font.default_italic = YEA::CORE::FONT_ITALIC
Font.default_shadow = YEA::CORE::FONT_SHADOW
Font.default_outline = YEA::CORE::FONT_OUTLINE
Font.default_color = YEA::CORE::FONT_COLOUR
Font.default_out_color = YEA::CORE::FONT_OUTLINE_COLOUR

# 숫자 표기 설정
class Numeric  
  def group
    return self.to_s unless YEA::CORE::GROUP_DIGITS
    self.to_s.gsub(/(\d)(?=\d{3}+(?:\.|$))(\d{3}\..*)?/,'\1,\2')
  end
end

=begin

find_path(x, y, ev = 0, wait = false, distance = 0)

x is the target x
y is the targey y

ev 는 기본적으로 0 으로 설정되며 다음과 같이 생략할 수 있습니다. find_path(9, 0)
ev 는 이동할 문자를 나타냅니다. -1 은 플레이어,
0은 이벤트를 호출하고 위의 모든 것은 ID 가 ev 인 맵의 이벤트입니다.

false 로 설정된 경우 기다리며 다음과 같이 생략할 수 있습니다.
find_path(9, 0) 또는 find_path(9, 0, -1)

wait 는 플레이어가 이동 경로가 완료될 때까지 기다려야 하는지 여부를 지정합니다.
다시 움직이기 시작합니다.

distance 는 기본적으로 0으로 설정되어 있으며 위와 같은 방법으로 생략할 수 있습니다.
x 와 y 는 대상 위치를 나타내지만 이벤트는 이동만 됩니다.

이벤트 사용자 지정 이동 경로 (on repeat): 
  find_path($game_player.x, $game_player.y, 3)
  
또는 루프에서 이동 경로 명령을 설정합니다.
  find_path($game_player.x, $game_player.y, 0, true, 3)

=end

class Node
  include Comparable
  attr_accessor :point, :parent, :cost, :cost_estimated

  def initialize(point)
    @point = point
    @cost = 0
    @cost_estimated = 0
    @on_path = false
    @parent = nil
  end

  def mark_path
    @on_path = true
    @parent.mark_path if @parent
  end
   
  def total_cost
    cost + cost_estimated
  end

  def <=>(other)
    total_cost <=> other.total_cost
  end
   
  def ==(other)
    point == other.point
  end
end

class Point
  attr_accessor :x, :y
  
  def initialize(x, y)
    @x, @y = x, y
  end

  def ==(other)
    return false unless Point === other
    @x == other.x && @y == other.y
  end

  def distance(other)
    (@x - other.x).abs + (@y - other.y).abs
  end

  def relative(xr, yr)
    Point.new(x + xr, y + yr)
  end
end

class MTable
  def initialize(xsize)
    @data = Array.new(xsize,Hash.new)
  end

  def []=(x,y,z)
    @data[x][y] = z
  end

  def [](x,y)
    @data[x][y] || 0
  end
end