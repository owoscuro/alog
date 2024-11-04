# encoding: utf-8
# Name: 221.Window_StateLabel
# Size: 514
class Window_StateLabel < Window_Base
  def initialize(*args)
    super(*args)
    refresh
  end
  
  def refresh
    contents.clear
    settings = MASV_LABEL_WINDOW
    contents.font.name = settings[:fontname]
    contents.font.size = settings[:fontsize]
    change_color(text_color(settings[:colour]))
    contents.fill_rect(0, settings[:fontsize] - 1, contents_width, 2, contents.font.color)
    draw_text(0, 0, contents_width, settings[:fontsize], MASV_SCENE_LABEL, settings[:align])
  end
end