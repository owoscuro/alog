# encoding: utf-8
# Name: 239.Scene_Status
# Size: 683
class Scene_Status < Scene_MenuBase
  alias :bm_status_s :start
  def start
    bm_status_s
    bm_win_opacity
  end
  
  def bm_win_opacity
    @command_window.opacity = BM::STATUS::BG_OPTIONS[:win_opacity] unless @command_window.nil?
    @help_window.opacity = BM::STATUS::BG_OPTIONS[:win_opacity] unless @help_window.nil?
    @item_window.opacity = BM::STATUS::BG_OPTIONS[:win_opacity] unless @item_window.nil?
    @status_window.opacity = BM::STATUS::BG_OPTIONS[:win_opacity] unless @status_window.nil?
  end
end

if !YEA::STATUS::CUSTOM_STATUS_COMMANDS.include?(:resistances)
  YEA::STATUS::CUSTOM_STATUS_COMMANDS.merge!(BM::STATUS::CHART_STATUS_COMMANDS)
end