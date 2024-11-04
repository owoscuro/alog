# encoding: utf-8
# Name: 220.Window_StateView
# Size: 4272
class Window_StateView < Window_Selectable
  attr_accessor :actor
  
  def initialize(actor)
  #def initialize(*args)
    @item_max = 1
    @top_col = 0
    #super(*args)
    super(0, line_height + 48, Graphics.width, Graphics.height - line_height - 48)
    @actor = actor
    refresh
    activate
  end
  
  def item_max
    @item_max
  end
  
  def state_include?(state)
    return false unless state
    return false if state.desc_hide?
    # 튜토리얼 에크티 표식 상태 제외
    return false if state.id == 161
    # 해당 캐릭터가 걸린 상태이상 확인
    #print("220.Window_StateView - %s \n" % [@actor.states]);
    #return false if !@actor.states.include?(state.id)
    return true if MASV_SHOW_ALL_STATES 
    return $game_system.masv_states_afflicted.include?(state.id)
  end
  
  def buff_include?(param_id, lvl)
    return false unless MASV_BUFFS[param_id] && MASV_BUFFS[param_id][lvl].is_a?(Array)
    return false unless MASV_BUFFS[param_id][lvl][0].is_a?(String) && MASV_BUFFS[param_id][lvl][1].is_a?(String)
    return true
  end
  
  def make_state_list
    @data = @actor.states
    #@data = $data_states.compact.select { |state| state_include?(state)}
    @item_max = @data.inject(0) { |r, state| r += state.description.scan(/\n/).size + 1 }
    if MASV_INCLUDE_BUFFS
      for i in 0...MASV_BUFFS.size
        ary = MASV_SHOW_ALL_STATES ? MASV_BUFFS[i].keys : $game_system.masv_buffs_added[i]
        ary.each { |lvl| 
          if buff_include?(i, lvl)
            @data.push([i, lvl])
            @item_max += MASV_BUFFS[i][lvl][1].scan(/\n/).size + 1
          end
        }
      end
    end
    @item_max = 1 if @item_max < 1
  end
  
  def refresh
    make_state_list
    create_contents
    y = 0
    @dummy_battler = Game_BattlerBase.new
    for i in 0...@data.size
      y = draw_item(y, i)
    end
    @dummy_battler = nil
  end
  
  def draw_item(y, index)
    reset_font_settings
    contents.font.name = Font.default_name
    icon_index, icon_hue, name, description = get_data(index)
    # Draw Icon
    $imported[:MAIcon_Hue] ? draw_icon_with_hue(icon_index, icon_hue, x, y) : draw_icon(icon_index, 0, y)
    # Draw Name
    change_color(system_color)
    draw_text(28, y, MASV_NAME_FIELD_WIDTH, 24, name)
    # 상태이상 걸음 표시 실험 @state_steps[@state.id]
    # Draw Description
    change_color(normal_color)
    # 실험중
    #text = "#{description}"
    #text_x = 34 + MASV_NAME_FIELD_WIDTH - @top_col
    #text_w = contents.width - MASV_NAME_FIELD_WIDTH + @top_col
    #draw_text(text_x, y, text_w, 24, text)
    #draw_text_ex(34 + MASV_NAME_FIELD_WIDTH + @top_col, y, ' ' + "#{description}")
    draw_text_ex(34 + MASV_NAME_FIELD_WIDTH, y, ' ' + "#{description}")
    return y + (description.scan(/\n/).size + 1)*line_height
  end
  
  def get_data(index)
    item = @data[index]
    icon_index, icon_hue, name, description = 0, 0, "", ""
    if item.is_a?(RPG::State)
      icon_index, name, description = item.icon_index, item.name, item.description
      icon_hue = $imported[:MAIcon_Hue] ? item.icon_hue : 0
    elsif item.is_a?(Array)
      icon_index = @dummy_battler.buff_icon_index(item[1], item[0]) if @dummy_battler
      name = MASV_BUFFS[item[0]][item[1]][0] rescue ""
      description = MASV_BUFFS[item[0]][item[1]][1] rescue ""
    end
    icon_index = 0 if icon_index.nil?
    return icon_index, icon_hue, name, description
  end
  
  def cursor_down(*args)
    tr = self.top_row
    self.top_row += 1 unless self.bottom_row >= item_max - 1
    Sound.play_cursor if tr != self.top_row
    #@label_window.unselect # 추가
  end
  
  def cursor_up(*args)
    tr = self.top_row
    self.top_row -= 1
    Sound.play_cursor if tr != self.top_row
    #@label_window.unselect # 추가
  end
  
  def cursor_pagedown
    if top_row + page_row_max < row_max
      self.top_row += page_row_max
      Sound.play_cursor
      #select([@index + page_item_max, item_max - 1].min)
    end
  end
  
  def cursor_pageup
    if top_row > 0
      self.top_row -= page_row_max
      Sound.play_cursor
      #select([@index - page_item_max, 0].max)
    end
  end
end