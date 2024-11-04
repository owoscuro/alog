# encoding: utf-8
# Name: 203.DistributeParameterConfirm
# Size: 1000
class Window_DistributeParameterConfirm < Window_Command
  def window_width
    return KMS_DistributeParameter::CONFIRM_WIDTH
  end
  
  #--------------------------------------------------------------------------
  # 가온데 정렬 추가 수정
  #--------------------------------------------------------------------------
  def alignment
    return 1
  end
  
  def make_command_list
    super
    add_command(KMS_DistributeParameter::CONFIRM_COMMANDS[0], :decide)
    add_command(KMS_DistributeParameter::CONFIRM_COMMANDS[1], :stop)
    add_command(KMS_DistributeParameter::CONFIRM_COMMANDS[2], :cancel)
  end
  
  #--------------------------------------------------------------------------
  # ● 도움말 텍스트 업데이트
  #--------------------------------------------------------------------------
  def update_help
    text = index.to_i >= 0 ? KMS_DistributeParameter::CONFIRM_COMMAND_HELP[index.to_i] : nil
    @help_window.set_text(text, nil)
  end
end