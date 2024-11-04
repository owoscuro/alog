# encoding: utf-8
# Name: 143.Sprite_DamagePop
# Size: 5491
class DamagePop_Obj < Game_Character
  attr_accessor :draw_it, :destroy_it, :target, :dmgcustom, :timingg, :plus_time
  attr_accessor :plus_time
  
  def initialize(target, custom=nil)
    super()
    if target != nil
      @draw_it = false
      @destroy_it = false
      @target = target
      @timingg = 70
      @plus_time = 0.0
      @dmgcustom = custom
      moveto(@target.x, @target.y)
    end
  end
end

class Sprite_DamagePop < Sprite
  attr_reader   :target
  
  def initialize(viewport, target)
    super(viewport)
    @target = target
    self.bitmap = Bitmap.new(200, 50)
    self.bitmap.font.name = "한컴 윤체 L"
    self.bitmap.font.size = 20
    self.z = 501
    case rand(4)
      when 0 then @resto_plus = 0.5
      when 1 then @resto_plus = 0.6
      when 2 then @resto_plus = 0.7
      when 3 then @resto_plus = 0.8
    end
    create_text_for_display
    set_text
    update
  end

  def create_text_for_display
    battler = @target.target.battler
    return if battler == nil or battler.result == nil
    value   = battler.result.hp_damage.round
    value2  = battler.result.mp_damage.round
    value3  = battler.result.tp_damage.round

    # 데미지 속성 비율 값 대입
    value_el = battler.result.damage_el.round
    
    self.bitmap.font.name = "한컴 윤체 L"
    self.bitmap.font.bold = false
    self.bitmap.font.size = 20
    self.z = 501

    if value >= 1
      # 치명타 데미지 빨간색
      if battler.result.critical == true
        self.bitmap.font.color = Color.new(255,255,0)
        self.bitmap.font.bold = true
        self.bitmap.font.name = "Old English Text MT"
        self.bitmap.font.size = 26
        @text = value.to_s
      else
        # 속성 효율이 좋으면 폰트, 굵기 수정
        if value_el.to_i > 1
          self.bitmap.font.color = Color.new(255,0,255)
          self.bitmap.font.bold = true
          self.bitmap.font.name = "Old English Text MT"
          self.bitmap.font.size = 23
        elsif 1 > value_el.to_i
          self.bitmap.font.color = Color.new(255,81,81)
          self.bitmap.font.size = 18
        else
          self.bitmap.font.color = Color.new(255,0,0)
          self.bitmap.font.size = 20
        end
        @text = value.to_s
      end
    elsif value < 0
      self.bitmap.font.color = Color.new(10,220,45)
      @text = value.to_s.sub("-","")
    elsif battler.result.missed
      @text = '빗나감'
    elsif battler.result.evaded
      @text = '회피'
    elsif battler.result.success
      # 데미지 0인 경우 데미지 생략
      if value != 0
        @text = value.to_s
      end
    end

    if value == nil
      if value2 < 0
        self.bitmap.font.color = Color.new(0,255,255)
        @text = value2.to_s.sub("-","")
      elsif value2 > 0
        self.bitmap.font.color = Color.new(0,255,255)
        @text = value2.to_i
      end

      if value3 < 0
        self.bitmap.font.color = Color.new(225,255,255)
        @text = value3.to_s.sub("-","")
      elsif value3 > 0
        self.bitmap.font.color = Color.new(225,255,255)
        @text = 'TP ' + value3.to_i
      end
    end
  
    # 상태 및 버프 표시
    #if battler.result.status_affected?
    #  display_changed_states(battler)
    #end

    # 사용자 정의 텍스트, 가장 높은 우선순위를 가짐
    if !@target.dmgcustom.nil?
      if @target.dmgcustom == 1
        if value != 0
        @text = '방어 무시 ' + value.to_s
        end
      elsif @target.dmgcustom == 2
        @text = '방어!'
      elsif @target.dmgcustom.is_a?(String)   
        @text = @target.dmgcustom
      elsif @target.dmgcustom.is_a?(Array)
        self.bitmap.font.color = @target.dmgcustom[1]
        @text = @target.dmgcustom[0]
      end
    end
    
    battler.result.clear
  end

  # 텍스트 세트 및 위치
  def set_text
    return if @target == nil or @target.target.battler == nil
    item = @target.target.battler.used_item
    return if item != nil and !item.scope.between?(1, 6) and item.tool_data("User Graphic = ", false).nil?
    @target.target.battler.used_item = nil
    return if @text == nil or @text == "" # 추가
    self.x = @target.screen_x - 98
    self.y = @target.screen_y - 54
    self.z = 3 * 100
    self.opacity = @target.opacity
    self.bitmap.font.name = "한컴 윤체 L"
    self.bitmap.font.shadow = true
    self.bitmap.draw_text(0, 0, 200, 32, @text, 1)
  end

=begin
  def display_changed_states(target)
    display_added_states(target)
    display_removed_states(target)
  end
  
  def display_added_states(target)
    target.result.added_state_objects.each do |state|
      state_msg = target.actor? ? state.message1 : state.message2
      next if state_msg.empty?
      @text = state_msg
    end
  end
  
  def display_removed_states(target)
    target.result.removed_state_objects.each do |state|
      next if state.message4.empty?
      @text = state.message4
    end
  end
=end

  def update
    @target.timingg -= 1 if @target.timingg > 0
    @target.plus_time += @resto_plus
    self.opacity -= 5 if @target.timingg <= 25
    @target.destroy_it = true if @target.timingg == 0
    self.x = @target.target.screen_x - 98
    self.y = @target.target.screen_y - 54 - @target.plus_time
  end
  
  def dispose
    self.bitmap.dispose
    super
  end
end