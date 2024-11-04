# encoding: utf-8
# Name: 291.Scene_System2
# Size: 293
class Scene_System2 < Scene_MenuBase
  def start
    super
    create_help_window
    create_command_window
  end
  
  def create_command_window
    @command_window = Window_SystemOptions2.new(@help_window)
    @command_window.set_handler(:cancel, method(:return_scene))
  end
end