# encoding: utf-8
# Name: 293.Window_Message
# Size: 204
class Window_Message < Window_Base
  alias window_message_clear_flags_so clear_flags
  def clear_flags
    window_message_clear_flags_so
    @show_fast = true if $game_system.instantmsg?
  end
end