# encoding: utf-8
# Name: Window_Help
# Size: 2918
class Window_Help < Window_Base
  def initialize(line_number = 3)
    super(0, 0, Graphics.width, fitting_height(line_number))
  end

  def set_text(text, item)
    if text != @text
      @text = text
      @item_n = item if @item_n != item
      refresh
    end
  end

  def clear
    set_text("", nil)
    if SceneManager.scene_is?(Scene_Item)
      set_text(BRAVO_STORAGE_2::HELP_TEXT_02, nil)
    elsif SceneManager.scene_is?(Scene_Storage_2)
      set_text(BRAVO_STORAGE_2::HELP_TEXT_01, nil)
    end
  end

  def set_item(item)
    set_text(item ? item.description : "", item)
  end

  def refresh
    contents.clear
    if @item_n != nil
      if @item_n.is_a?(RPG::Weapon) or @item_n.is_a?(RPG::Armor)
        draw_item_info
      elsif @text != nil
        draw_wrapped_text(4, 0, @text)
      end
    elsif @text != nil
      draw_wrapped_text(4, 0, @text)
    end
  end

  def draw_item_info
    x = 4
    y = 0
    enabled = true
    draw_icon(@item_n.icon_index, x, y, enabled)
    change_color(@item_n.rarity_colour, enabled)
    x += 29
    draw_text(x, y, width, line_height, @item_n.name)
    x += text_size(@item_n.name).width + 6
    change_color(normal_color, enabled)
    
    item_n_lin = @item_n.description.split("\n")
    
    draw_wrapped_text(x, y, ': ' + item_n_lin[0].to_s)
    draw_wrapped_text(4, y + line_height, item_n_lin[1].to_s) if item_n_lin[1] != nil
  end

  def draw_wrapped_text(x, y, text)
    words = text.split(' ')
    line = ''
    height = 0
    words.each do |word|
      test_line = line + word + ' '
      if text_size(test_line).width > (contents_width - x - 4)
        draw_text_ex(x, y + height, line)
        height += line_height
        line = word + ' '
      else
        line = test_line
      end
    end
    draw_text_ex(x, y + height, line) unless line.empty?
  end

  def rarity_colour
    TH::Item_Rarity.rarity_colour_map[self.rarity]
  end
  
  def moveto(y)
    self.y = y
  end
end

class Window_Help2 < Window_Base
  def initialize(line_number = 3)
    super(0, 0, Graphics.width/2, fitting_height(line_number))
  end

  def set_text(text)
    if text != @text
      @text = text
      refresh
    end
  end

  def clear
    set_text("")
  end

  def set_item(item)
    set_text(item ? item.description : "")
  end

  def refresh
    contents.clear
    draw_wrapped_text(4, 0, @text)
  end

  def draw_wrapped_text(x, y, text)
    words = text.split(' ')
    line = ''
    height = 0
    words.each do |word|
      test_line = line + word + ' '
      if text_size(test_line).width > (contents_width - x - 4)
        draw_text_ex(x, y + height, line)
        height += line_height
        line = word + ' '
      else
        line = test_line
      end
    end
    draw_text_ex(x, y + height, line) unless line.empty?
  end
end