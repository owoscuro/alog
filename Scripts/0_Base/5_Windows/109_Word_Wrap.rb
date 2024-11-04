# encoding: utf-8
# Name: Word_Wrap
# Size: 2032
# https://himeworks.com/2014/12/a-look-at-word-wrapping-your-messages/

class Window_Message
#~   def process_normal_character(c, pos)  
#~     text_width = text_size(c).width    
#~     #---------------------------------------------
#~     if pos[:x] + text_width >= self.contents.width
#~       pos[:new_x] = new_line_x
#~       process_new_line(c, pos)
#~     end    
#~     #---------------------------------------------
#~     draw_text(pos[:x], pos[:y], text_width * 2, pos[:height], c)
#~     pos[:x] += text_width
#~     wait_for_one_character
#~   end
#~ end

#~ class Window_Message
#~   alias :th_message_word_wrap_process_character :process_character
#~   def process_character(c, text, pos)
#~     if pos[:x] + next_word_width(c, text) >= self.contents.width
#~       pos[:new_x] = new_line_x
#~       process_new_line(c, pos)
#~     end    
#~     th_message_word_wrap_process_character(c, text, pos)
#~   end

#~   def next_word_width(c, text)
#~     word_width = text_size(c).width
#~     return word_width if text.empty?
#~     return word_width + text_size(text[0, text.index(/\s/)]).width
#~   end
#~ end
  def process_normal_character(c, pos)  
    text_width = text_size(c).width    
    if pos[:x] + text_width >= self.contents.width
      pos[:new_x] = new_line_x
      process_new_line(c, pos)
    end    
    draw_text(pos[:x], pos[:y], text_width * 2, pos[:height], c)
    pos[:x] += text_width
    wait_for_one_character
  end

  alias :th_message_word_wrap_process_character :process_character
  def process_character(c, text, pos)
    if pos[:x] + next_word_width(c, text) >= self.contents.width
      pos[:new_x] = new_line_x
      process_new_line(c, pos)
    end    
    th_message_word_wrap_process_character(c, text, pos)
  end

  def next_word_width(c, text)
    word_width = text_size(c).width
    return word_width if text.empty?
    next_space = text.index(/\s/)
    return word_width + text_size(text[0, next_space]).width if next_space
    return word_width + text_size(text).width
  end
end