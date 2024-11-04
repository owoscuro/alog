# encoding: utf-8
# Name: 057.ve_basic_module
# Size: 6867
#-------------------------------------------------------------------------------
#   class << Cache
#     def self.character(filename)
#
#   class Sprite_Character < Sprite_Base
#     def set_character_bitmap
#
#   class Game_Battler < Game_BattlerBase
#     def item_effect_recover_hp(user, item, effect)
#     def item_effect_recover_mp(user, item, effect)
#     def item_effect_gain_tp
#
# * Alias methods
#   class Game_Interpreter
#     def command_108
#
#   class Window_Base < Window
#     def convert_escape_characters(text)
#-------------------------------------------------------------------------------
# * Random number between two vales
#   rand_between(min, max)
#    min : min value
#    max : max value
#   모든 클래스에서 호출할 수 있으며 이 메서드는 사이의 임의의 값을 반환합니다.
#   두 개의 특정 숫자
#
# * Random array value
#   <Array>.random
#   <Array>.random!
#   배열에서 무작위 객체인 .random! 메서드를 반환합니다.
#   파괴적이며, 배열에서 반환된 값을 제거합니다.
#
# * Sum of the numeric values of a array
#   <Array>.sum
#   Returns the sum of all numeric values
#
# * Average of all numeric values from the array
#   <Array>.average(float = false)
#    float : float flag
#   Returns the average of all numeric values, if floa is true, the value
#   returned is a float, otherwise it's a integer.
#
# * Note for events
#   <Event>.note
#   기본적으로 이벤트에는 메모 상자가 없습니다.
#   이 명령을 사용하면 메모 상자와 같은 주석, 위에 있는 것과 동일한 형식을 따릅니다.
#   이벤트의 활성 페이지에 대한 모든 댓글을 반환합니다.
#
# * Comment calls
#   <Event>.comment_call
#   댓글 상자의 또 다른 기능은 기본적으로 호출 시 게임 내 효과. 
#   그러나 이 방법을 사용하면 주석을 달 수 있습니다.
#   상자는 스크립트 호출처럼 동작하지만 메모 상자.
#   명령은 다음이 있는 경우에만 적용됩니다.
#   주석 코드에 응답하는 스크립트입니다.
#-------------------------------------------------------------------------------

$imported ||= {}
$imported[:ve_basic_module] = 1.35

class Object
  #include Victor_Engine
  def rand_between(min, max)
    min + rand(max - min + 1)
  end
  
  def numeric?
    return false
  end
  
  def string?
    return false
  end
  
  def array?
    return false
  end
  
  def float?
    return false
  end
  
  def symbol?
    return false
  end
  
  def item?
    return false
  end
  
  def skill?
    return false
  end
  
  def file_exist?(path, filename)
    $file_list ||= {}
    $file_list[path + filename] ||= file_test(path, filename)
    $file_list[path + filename]
  end
  
  def file_test(path, filename)
    bitmap = Cache.load_bitmap(path, filename) rescue nil
    bitmap ? true : false
  end
  
  def character_exist?(filename)
    file_exist?("Graphics/Characters/", filename)
  end
  
=begin
  def battler_exist?(filename)
    file_exist?("Graphics/Battlers/", filename)
  end
=end

  def face_exist?(filename)
    file_exist?("Graphics/Faces/", filename)
  end
  
  def get_filename
    "[\"'“‘]([^\"'”‘”’]+)[\"'”’]"
  end
  
  def get_all_values(value1, value2 = nil)
    value2 = value1 unless value2
    /<#{value1}>((?:[^<]|<[^\/])*)<\/#{value2}>/im
  end
  
  def make_symbol(string)
    string.downcase.gsub(" ", "_").to_sym
  end
  
  def make_string(symbol)
    symbol.to_s.gsub("_", " ").upcase
  end
  
  def returning_value(i, x)
    y = [x * 2, 1].max
    i % y  >= x ? (x * 2) - i % y : i % y 
  end
  
  def in_rect?(w, h, x1, y1, x2, y2, fx = 0)
    aw, ah, ax, ay, bx, by = setup_area(w, h, x1, y1, x2, y2, fx)
    bx > ax - aw && bx < ax + aw && by > ay - ah && by < ay + ah
  end
  
  def in_radius?(w, h, x1, y1, x2, y2, fx = 0)
    aw, ah, ax, ay, bx, by = setup_area(w, h, x1, y1, x2, y2, fx)
    ((bx - ax) ** 2 / aw ** 2) + ((by - ay) ** 2 / ah ** 2) <= 1
  end
  
  def setup_area(w, h, x1, y1, x2, y2, fx)
    aw = w
    ah = h * aw
    ax = x1
    ay = y1
    bx = x2
    by = y2
    bx += fx / 4 if ax > bx
    bx -= fx / 4 if ax < bx
    [aw, ah, ax, ay, bx, by]
  end
  
  def get_param_id(text)
    case text.upcase
    when "MAXHP", "HP" then 0
    when "MAXMP", "MP" then 1
    when "ATK" then 2
    when "DEF" then 3
    when "MAT" then 4
    when "MDF" then 5
    when "AGI" then 6
    when "LUK" then 7
    end
  end
  
  def get_param_text(id)
    case id
    when 0 then "HP" 
    when 1 then "MP"
    when 2 then "ATK"
    when 3 then "DEF"
    when 4 then "MAT"
    when 5 then "MDF"
    when 6 then "AGI"
    when 7 then "LUK"
    end
  end
  
  def get_xparam_id(text)
    case text.upcase
    when "HIT" then 0
    when "EVA" then 1
    when "CRI" then 2
    when "CEV" then 3
    when "MEV" then 4
    when "MRF" then 5
    when "CNT" then 6
    when "HRG" then 7
    when "MRG" then 8
    when "TRG" then 9
    end
  end
  
  def get_xparam_text(id)
    case id
    when 0 then "HIT" 
    when 1 then "EVA"
    when 2 then "CRI"
    when 3 then "CEV"
    when 4 then "MEV"
    when 5 then "MRF"
    when 6 then "CNT"
    when 7 then "HRG"
    when 8 then "MRG"
    when 9 then "TRG"
    end
  end
  
  def get_sparam_id(text)
    case text.upcase
    when "TGR" then 0
    when "GRD" then 1
    when "REC" then 2
    when "PHA" then 3
    when "MCR" then 4
    when "TCR" then 5
    when "PDR" then 6
    when "MDR" then 7
    when "FDR" then 8
    when "EXR" then 9
    end
  end
  
  def get_sparam_text(id)
    case id
    when 0 then "TGR" 
    when 1 then "GRD"
    when 2 then "REC"
    when 3 then "PHA"
    when 4 then "MCR"
    when 5 then "TCR"
    when 6 then "PDR"
    when 7 then "MDR"
    when 8 then "FDR"
    when 9 then "EXR"
    end
  end
  
  def get_cond(text)
    case text.upcase
    when "HIGHER"    then ">"
    when "LOWER"     then "<"
    when "EQUAL"     then "=="
    when "DIFFERENT" then "!="
    else "!="
    end
  end
end

class String
  def string?
    return true
  end
end

class Symbol
  def symbol?
    return true
  end
end

class Numeric
  def numeric?
    return true
  end
  
  def ceil?
    return false
  end
  
  def to_ceil
    self > 0 ? self.abs.ceil : -self.abs.ceil
  end
end

class Float
  def float?
    return true
  end
  
  def ceil?
    self != self.ceil
  end
end

class Array
  def array?
    return true
  end
  
  def random
    self[rand(size)]
  end
  
  def random!
    self.delete_at(rand(size))
  end
  
  def sum
    self.inject(0) {|r, n| r += (n.numeric? ? n : 0)} 
  end
  
  def average(float = false)
    self.sum / [(float ? size.to_f : size.to_i), 1].max
  end
  
  def next_item
    item = self.shift
    self.push(item)
    item
  end
  
  def previous_item
    item = self.pop
    self.unshift(item)
    item
  end
end