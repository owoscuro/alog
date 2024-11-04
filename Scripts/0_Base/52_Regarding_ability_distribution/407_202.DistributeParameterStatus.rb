# encoding: utf-8
# Name: 202.DistributeParameterStatus
# Size: 5129
# encoding: utf-8
# Name: 202.DistributeParameterStatus
# Size: 5134
class Window_DistributeParameterStatus < Window_Base
  attr_accessor :actor
  def initialize(actor)
    dx = 286
    off_h = line_height + 48
    super(dx, off_h, Graphics.width - dx, Graphics.height - off_h)
    @actor = actor
    refresh(actor.gain_parameter_list[0].key)
  end
  
  def refresh(param = nil)
    @distribute_gain = nil
    if param != nil
      @distribute_gain = @actor.distribute_gain(param)
    end
    contents.clear
    dx = 0
    dy = 0
    KMS_DistributeParameter::PARAMS.each { |param|
      if dy + line_height - 3 >= contents.height and dx == 0
        dx += contents.width / 2
        dy = 0
      end
      draw_parameter(dx, dy, param)
      dy += line_height - 3
    }
  end
  
  def draw_parameter(x, y, type)
    is_float = false
    is_float_2 = false
    case type
    when :mhp
      name  = Vocab.hp
      value = @actor.mhp
    when :mmp
      name  = Vocab.mp
      value = @actor.mmp
    when :atk
      name  = Vocab.param(2)
      value = @actor.atk
    when :def
      name  = Vocab.param(3)
      value = @actor.def
    when :mat
      name  = Vocab.param(4)
      value = @actor.mat
    when :mdf
      name  = Vocab.param(5)
      value = @actor.mdf
    when :agi
      name  = Vocab.param(6)
      value = @actor.agi
    when :luk
      name  = Vocab.param(7)
      value = @actor.luk
    when :hit
      name  = Vocab.hit
      value = @actor.hit
      is_float = true
    when :eva
      name  = Vocab.eva
      value = @actor.eva
      is_float = true
    when :cri
      name  = Vocab.cri
      value = @actor.cri
      is_float = true
	when :cev
	  name  = "Evasión Crítica"
	  value = @actor.cev
	  is_float = true
	when :mev
	  name  = "Evasión Mágica"
	  value = @actor.mev
	  is_float = true
    when :mrf, :cnt, :hrg, :mrg, :trg
      name = Vocab::xparam_a(type)
      value = eval("@actor.#{type}")
      is_float = true
    when :tgr, :grd, :rec, :mcr, :tcr, :pdr, :mdr, :fdr, :exr
      name = Vocab::sparam_a(type)
      value = eval("@actor.#{type}")
      is_float = true
    when :el_3
      name = Vocab::sparam_f(type)
      value = 1 - @actor.element_rate(3)
      is_float = true
    when :el_4
      name = Vocab::sparam_f(type)
      value = 1 - @actor.element_rate(4)
      is_float = true
    when :el_5
      name = Vocab::sparam_f(type)
      value = 1 - @actor.element_rate(5)
      is_float = true
    when :el_6
      name = Vocab::sparam_f(type)
      value = 1 - @actor.element_rate(6)
      is_float = true
    when :el_7
      name = Vocab::sparam_f(type)
      value = 1 - @actor.element_rate(7)
      is_float = true
    when :el_8
      name = Vocab::sparam_f(type)
      value = 1 - @actor.element_rate(8)
      is_float = true
    when :el_9
      name = Vocab::sparam_f(type)
      value = 1 - @actor.element_rate(9)
      is_float = true
    when :el_10
      name = Vocab::sparam_f(type)
      value = 1 - @actor.element_rate(10)
      is_float = true
    when :el_12
      name = Vocab::sparam_f(type)
      value = 1 - @actor.element_rate(12)
      is_float = true
	when :atk_times_add
	  name = "Vel Movimiento"
	  value = @actor.atk_times_add + 1
	  is_float = true
	when :aps
	  name = "Prob de Ignorar Knockback"
	  value = @actor.action_plus_set2 * 10
	  is_float = true
	when :pha
	  name = Vocab::sparam_a(type)
	  value = (@actor.atk_speed - @actor.pha) * -0.01
	  is_float = true
	  is_float_2 = true
	when :atk_lk
	  name = "Ratio de Ataque Crítico"
	  value = (@actor.atk_lk + (@actor.luk * 0.001))
	  is_float = true
	when :weight_limit
	  name = "Límite de Peso Equipado"
	  value = @actor.max_weight_limit
	else
	  return
	end
    contents.font.size = BM::EQUIP::MINI_FONT_SIZE
    change_color(system_color)
    draw_text(x + 7, y, contents.width / 2 - 14, line_height, name)
    return if @distribute_gain == nil
    curr = @actor.distributed_param(type)
    gain = @distribute_gain[type]
    change_color(gain > curr ? text_color(3) : gain < curr ? text_color(2) : normal_color)
    draw_text(x, y, contents.width / 2 - 7, line_height, convert_value(value, is_float), 2)
    new_value = value + (gain - curr)
    new_value2 = curr
    text = 0
    if new_value2 != 0 and new_value2 != nil
      if is_float
        if is_float_2
          text = sprintf("%g%%", new_value2)
        else
          text = sprintf("%g%%", new_value2 * +100)
        end
      else
        text = sprintf("%g%%", new_value2)
      end
    end
    # 파라미터 변화
    draw_text(x, y, contents.width / 2 - (contents.width / 6), line_height, "#{text}" + ' +', 2) if text != 0
    change_color(normal_color)
  end
  
  def convert_value(value, is_float)
      if is_float
          return sprintf("%g%%", value * 100)
          # return sprintf("%.0f%%", value * 100)
      else
          return sprintf("%g%%", value)
          # return sprintf("%.0f", value)
      end
  end
end