# encoding: utf-8
# Name: 141.StateBuffIcons
# Size: 3429
class StateBuffIcons < Sprite
  def initialize(viewport, mode)
    super(viewport)
    @mode = mode
    # 상태이상 아이콘 최대 수량 증가 실험
    self.bitmap = Bitmap.new(140, 480)
    # 상태버프 좌표 실험
    if @mode == "상태"
      self.x = Graphics.width - 150
      self.y = 6
    else
      self.x = Graphics.width - 150
      self.y = 230
    end
    @actor = $game_player.actor
    @old_switches = $game_switches[36]
    refresh_icons
    update
  end
  
  def icons
    return @actor.state_icons if @mode == '상태'
  end
  
  def update
    # --------------------------------------------------------------------------
    # 아래는 시간 가속중이 아닌 경우에만 적용
    # --------------------------------------------------------------------------
    if $game_map.map_id == 35 # 퀘스트 보드
      self.opacity = 0
    elsif !HM_SEL::time_stop? and $game_switches[283] == false
      if $sel_time_frame_30 == 5
        refresh_icons
      elsif @old_switches != $game_switches[36]
        refresh_icons
      end
    end
  end

  def dispose
    self.bitmap.dispose
    super
  end

  def get_data(index)
    item = @data[index]
    icon_index, name, id = 0, "", 0
    if item.is_a?(RPG::State)
      id, icon_index, name = item.id, item.icon_index, item.name
    elsif item.is_a?(Array)
      icon_index = @dummy_battler.buff_icon_index(item[1], item[0])
      name = MASV_BUFFS[item[0]][item[1]][0] rescue ""
      id = MASV_BUFFS[item[0]][item[1]][1] rescue ""
    end
    icon_index = 0 if icon_index.nil?
    return icon_index, name, id
  end
  
  def refresh_icons
    # 진행 가능 여부
    if !HM_SEL::time_stop?
      @old_switches = $game_switches[36]
      self.bitmap.clear
      self.bitmap.font.name = "한컴 윤체 L"
      self.bitmap.font.size = 15
      self.opacity = 255
      x = 30
      y = 12; count = 0
      
      @data = $game_actors[7].states
      for i in 0...@data.size
        icon_index, name, id = get_data(i)
        draw_icon(x + 83, y, icon_index)
        if $game_switches[36] == false
          draw_state_name(x, y, name)
        else
          draw_state_steps(x, y, id)
        end
        y += 24; count += 1
        break if count >= 15
      end
    end
  end

  def draw_icon(x, y, index)
    index += 1
    bit = Cache.system("icon/"+"#{index}")
    rect = Rect.new(0, 0, 24, 24)
    self.bitmap.blt(x, y+4, bit, rect)
  end

  def draw_state_name(x, y, index)
    self.bitmap.font.color.set(255,255,255)
    self.bitmap.draw_text(x, y+6, 80, 24, index, 2)
  end

  # 상태이상 유지 시간 표기 실험
  def draw_state_steps(x, y, index)
    @state_ro_steps = $game_actors[7].state_steps[index].to_i
    @state_ro_steps_m = (@state_ro_steps / 60).to_i
    @state_ro_steps_s = @state_ro_steps % 60
    if @state_ro_steps >= 60 and @state_ro_steps != nil
      self.bitmap.font.color.set(255,255,255)
      self.bitmap.draw_text(x, y+6, 80, 24, "#{@state_ro_steps_m}"+"m "+"#{@state_ro_steps_s}"+"s", 2)
    elsif @state_ro_steps >= 1 and @state_ro_steps != nil
      self.bitmap.font.color.set(255,0,0)
      self.bitmap.draw_text(x, y+6, 80, 24, "#{@state_ro_steps_s}"+"s", 2)
    else
      self.bitmap.font.color.set(255,255,255)
      self.bitmap.draw_text(x, y+6, 80, 24, "", 2)
    end
  end
end