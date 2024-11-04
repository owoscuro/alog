# encoding: utf-8
# Name: 170.Window_Help_Q35
# Size: 6408
class Window_Help_Q35 < Window_Base
  def initialize
    super(0, 10, Graphics.width, Graphics.height)
    self.opacity = 0
    refresh(nil)
  end
  
#~   def refresh(index)
#~     print("의뢰 게시판 관련 - Window_Help_Q35 - refresh \n");
#~     unless index == nil
#~       #print("099_2.신규 이름 팝업 - Window_Help_Q35 \n")
#~       self.contents.clear
#~       colour = Color.new(0, 0, 0, translucent_alpha/2)
#~       
#~       @quests = Game_Party.new
#~       
#~       text_lin = 0
#~       text_lin = @quests.quests[index].description.scan(/\n/).size
#~       if @quests.quests[index].objectives.count >= 1
#~         text_lin += 2
#~       end
#~       
#~       rect = Rect.new(0, - 15, Graphics.width, fitting_height(2 + text_lin) + 5)
#~       contents.fill_rect(rect, colour)

#~       #rect = Rect.new(0, 15, Graphics.width, fitting_height(1+text_lin))
#~       #contents.fill_rect(rect, colour)

#~       contents.font.name = "한컴 윤체 L"
#~       contents.font.size = 26
#~       contents.font.bold = true
#~       contents.font.color = (text_color(3))
#~       draw_text(10, - 7, Graphics.width, fitting_height(1), @quests.quests[index].name, 0)
#~       #draw_text_ex(10, 33, @quests.quests[index].description)
#~       
#~       text = @quests.quests[index].description
#~       text += "\n\n목Objetivo : "
#~       
#~       @quests.quests[index].objectives.count.times {|i|
#~       text += @quests.quests[index].objectives[i]
#~       text += ", " if @quests.quests[index].objectives.count > i + 1
#~       }
#~       
#~       #print("170.Window_Help_Q35 - %s \n" % [@quests.quests[index].status?(:complete)]);
#~       
#~       draw_text_ex(10, 33, text)
#~       
#~       rect = Rect.new(0, fitting_height(2 + text_lin) - 5, Graphics.width / 3, fitting_height(@quests.quests[index].rewards.count) - 15)
#~       contents.fill_rect(rect, colour)
#~       
#~       @quests.quests[index].rewards.count.times {|i|
#~         draw_reward(index, i, fitting_height(2 + text_lin) + i * line_height)
#~       }
#~     end
#~   end
  def refresh(index)
    print("의뢰 게시판 관련 - Window_Help_Q35 - refresh \n")
    unless index.nil?
      self.contents.clear
      colour = Color.new(0, 0, 0, translucent_alpha/2)
      
      @quests = Game_Party.new
      
      # Format the description with word wrap
      formatted_description = format_text(@quests.quests[index].description, Graphics.width - 20)
      text_lines = formatted_description.count("\n") + 1
      
      # Format objectives
      formatted_objectives = format_objectives(@quests.quests[index].objectives, Graphics.width - 20)
      text_lines += formatted_objectives.count("\n") + 2 # +2 for the "목Objetivo : " line and an extra newline
      
      rect = Rect.new(0, -15, Graphics.width, fitting_height(2 + text_lines) + 5)
      contents.fill_rect(rect, colour)
      
      contents.font.name = "한컴 윤체 L"
      contents.font.size = 26
      contents.font.bold = true
      contents.font.color = text_color(3)
      draw_text(10, -7, Graphics.width, fitting_height(1), @quests.quests[index].name, 0)
      
      text = formatted_description
      text += "\n\n목Objetivo : \n"
      text += formatted_objectives
      
      draw_text_ex(10, 33, text)
      
      rect = Rect.new(0, fitting_height(2 + text_lines) - 5, Graphics.width / 3, fitting_height(@quests.quests[index].rewards.count) - 15)
      contents.fill_rect(rect, colour)
      
      @quests.quests[index].rewards.count.times do |i|
        draw_reward(index, i, fitting_height(2 + text_lines) + i * line_height)
      end
    end
  end

  def format_text(text, max_width)
    words = text.split
    lines = []
    current_line = ""

    words.each do |word|
      if text_size(current_line + word).width <= max_width
        current_line += (current_line.empty? ? "" : " ") + word
      else
        lines << current_line
        current_line = word
      end
    end
    lines << current_line if current_line

    lines.join("\n")
  end
  
  def format_objectives(objectives, max_width)
    formatted = objectives.map do |objective|
      format_text(objective, max_width - 20)
    end
    formatted.join(",\n")
  end
  
  def draw_reward(index, r_id, y)
    reward = @quests.quests[index].rewards[r_id]
    case reward[0]
    when :item, 0   # Item
      draw_item_reward(y, $data_items[reward[1]], reward[2] ? reward[2] : 1)
    when :weapon, 1 # Weapon
      draw_item_reward(y, $data_weapons[reward[1]], reward[2] ? reward[2] : 1)
    when :armor, 2  # Armor
      draw_item_reward(y, $data_armors[reward[1]], reward[2] ? reward[2] : 1)
    when :gold, 3   # Gold
      draw_basic_data(y, QuestData::ICONS[:reward_gold], 
        QuestData::VOCAB[:reward_gold], "")
      #draw_currency_value(reward[1], "", 0, y, contents.width - 10, 0)
      draw_currency_value(reward[1], "", 0, y, contents.width / 3, 0)
    when :exp, 4    # Exp
      draw_basic_data(y, QuestData::ICONS[:reward_exp], 
        QuestData::VOCAB[:reward_exp], (reward[1] ? reward[1] : 0).to_s)
    when :string, 5 # String
      draw_basic_data(y, reward[1] ? reward[1] : 0, reward[3] ? reward[3].to_s : "", 
        reward[2] ? reward[2].to_s : "")
    end
  end
  
  def draw_item_reward(y, item, amount = 1)
    w = contents_width
    w = QuestData::BASIC_DATA_WIDTH if QuestData::BASIC_DATA_WIDTH.between?(1, w)
    #x = (contents_width - w) / 2
    x = 10
    draw_item_name(item, x, y, true, w - 40)
    # 보상 아이템이 1개면 그냥 수치 1 표기
    if amount >= 1
      #draw_text(0, y, contents.width - 10, line_height, sprintf(QuestData::VOCAB[:reward_amount], amount), 2)
      draw_text(0, y, contents.width / 3, line_height, sprintf(QuestData::VOCAB[:reward_amount], amount), 2)
    end
  end
  
  def draw_basic_data(y, icon_index, vocab, value)
    w = contents_width
    w = QuestData::BASIC_DATA_WIDTH if QuestData::BASIC_DATA_WIDTH.between?(1, w)
    #x = (contents_width - w) / 2
    x = 10
    unless icon_index == 0
      draw_icon(icon_index, x, y)
      x += 24
      w -= 24
    end
    tw = text_size(vocab).width + 5
    draw_text(x, y, tw, line_height, vocab)
    draw_text(x + tw, y, w - tw, line_height, value, 0)
  end
end