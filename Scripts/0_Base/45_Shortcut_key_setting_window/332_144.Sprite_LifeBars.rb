# encoding: utf-8
# Name: 144.Sprite_LifeBars
# Size: 4929
class Sprite_LifeBars < Sprite
  include PearlBars
  def initialize(viewport, character)
    super(viewport)
    @character = character
    self.bitmap = Bitmap.new(boss? ? 640 : 300, 120)
    if !@character.nil?
      @old_hp = battler.hp
      @old_mp = battler.mp
      @erasetimer = 60
      @state_checker = []
      @buff_checker = []
      refresh_contents
    end
    @view = viewport
    @view.z = 1000
    # 오류 방지하기 위해 조건분기 추가
    update if !@character.nil?
  end
  
  def boss?
    return true if battler.is_a?(Game_Enemy) && battler.boss_hud
    return false
  end
  
  def battler
    return @character.battler if !@character.nil?
  end
  
  def refresh_contents
    self.bitmap.clear
    self.bitmap.font.name = "한컴 윤체 L"
    self.bitmap.font.size = 16
    @erasetimer = 60
    self.opacity = 255
    if battler.is_a?(Game_Actor)
      @old_exp = battler.exp
      @old_tp = battler.tp
      self.x = ScreenPos_X
      self.y = ScreenPos_Y
      self.z = 100
      h  = HP_BarDimentions ; m = MP_BarDimentions ; e = EX_BarDimentions
      hc = HP_Color ; mc = MP_Color ; ec = EX_Color
      PearlKernel.draw_hp(self.bitmap,battler, h[0], h[1], h[2], h[3], hc)
      PearlKernel.draw_mp(self.bitmap,battler, m[0], m[1], m[2], m[3], mc)
      PearlKernel.draw_exp(self.bitmap,battler, e[0], e[1], e[2], e[3], ec)
      PearlKernel.draw_tp(self.bitmap, TP_Info[0], TP_Info[1], battler)
    elsif battler.is_a?(Game_Enemy)
      if boss?
        self.x = BeScreenPos_X
        self.y = BeScreenPos_Y
        self.z = 100
        h  = BHP_BarDimentions ; hc = BHP_Color
        PearlKernel.draw_hp(self.bitmap,battler, h[0], h[1]+5, h[2], h[3],hc,true)
      else
        # 몬스터 게이지바 위치 조정 실험
        self.x = NeScreenPos_X
        self.y = NeScreenPos_Y
        self.z = 100
        h  = EHP_BarDimentions ; hc = EHP_Color
        PearlKernel.draw_hp(self.bitmap,battler,h[0], h[1]+5, h[2], h[3], hc,true)
      end
    end
  end
  
  def update
    super
    if @character.nil? or battler.nil?
      dispose if self.bitmap != nil
      return
    end
    # 프레임 조작
    if $sel_time_frame_10 == 5
      if @old_hp != battler.hp
        refresh_contents
        @old_hp = battler.hp
      end
      if @old_mp != battler.mp
        refresh_contents
        @old_mp = battler.mp
      end
      if battler.is_a?(Game_Actor)
        if @old_exp != battler.exp
          @old_exp = battler.exp
          refresh_contents
        end
        if @old_tp != battler.tp
          @old_tp = battler.tp
          @character.actor.apply_usability if @character.is_a?(Game_Player)
          refresh_contents
        end
      elsif battler.is_a?(Game_Enemy)
        if battler.dead?
          dispose
        else
          update_enemy_status_icons
        end
      end
    end
    if $sel_time_frame_10 == 7 and battler.is_a?(Game_Enemy) and @erasetimer > 0
      @erasetimer -= 1
      self.opacity -= 10 if @erasetimer <= 25
      @states.opacity = self.opacity if !@states.nil?
      dispose if 0 >= @erasetimer
    end
  end
  
  def update_enemy_status_icons
    display_status? ? create_states_icons : dispose_state_icons
    # 몬스터 상태이상 표기 증가
    8.times.each {|i| refresh_states_icons if @state_checker[i] != battler.state_icons[i]}
  end
  
  def display_status?
    return true if !battler.state_icons.empty?
    return false
  end
  
  def create_states_icons
    return if disposed?
    return if !@states.nil?
    @states = ::Sprite.new(@view)
    @states.bitmap = Bitmap.new(144, 24)
    @n_back.nil? ? y_plus = BHP_BarDimentions[3] : y_plus = @n_back.height
    pos = [BeScreenPos_X, BeScreenPos_Y, y_plus] if  boss?
    pos = [NeScreenPos_X, NeScreenPos_Y, y_plus] if !boss?
    @states.x = pos[0] + 10
    if boss?
      @states.y = pos[1] + pos[2] + 34
    else
      @states.y = pos[1] + pos[2] + 24
    end
    @states.z = 100
    @states.zoom_x = 1
    @states.zoom_y = 1
    refresh_states_icons
  end
  
  def dispose_state_icons
    return if @states.nil?
    @states.bitmap.dispose
    @states.dispose
    @states = nil
  end
  
  def refresh_states_icons
    # 몬스터 상태이상 표기 증가
    8.times.each {|i| @state_checker[i] = battler.state_icons[i]}
    return if @states.nil?
    @states.bitmap.clear
    x = 0
    battler.state_icons.each {|icon| draw_icon(icon, x, 0) ; x += 24
    break if x == 96}
    count = 0
  end
  
  def draw_icon(icon_index, x, y, enabled = true)
    icon_index += 1
    bit = Cache.system("icon/"+"#{icon_index}")
    rect = Rect.new(0, 0, 24, 24)
    @states.bitmap.blt(x, y, bit, rect, enabled ? 255 : 150)
  end

  def dispose
    self.bitmap.dispose
    dispose_state_icons
    super
  end
end