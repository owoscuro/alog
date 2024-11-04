# encoding: utf-8
# Name: 213.Window_MapList
# Size: 2453
class Window_MapList < Window_Command
  include Lune_Map
  attr_reader   :item_window
  def initialize
    super(0, 0)
  end
  
  def window_width
    0 #150
  end
  
  def window_height
    0 #Graphics.height # - fitting_height(2)
  end
  
  def process_handling
    return unless open? && active
    return process_ok       if Input.trigger?(:C)
    return process_no       if Input.trigger?(:B)
  end
  
  def process_no
    $game_variables[185] = 999
    #print("057.월드 맵 빠른 이동 취소 - %s \n" % [$game_variables[185]]);
    Sound.play_ok
    Input.update
    deactivate
    SceneManager.return
    call_ok_handler
  end
  
  #--------------------------------------------------------------------------
  # * 확인 버튼을 눌러 결과 정의
  #--------------------------------------------------------------------------
  def process_ok
    transf = $lune_map_info[@index]['Map_id']
    # 마지막으로 이동할 맵, 좌표 지정
    $game_variables[184] = transf[0]
    $game_variables[186] = transf[1]
    $game_variables[187] = transf[2]
    # 이동 후 맵 이름 저장
    $game_variables[172] = $lune_map_info[@index]['Name']
    # 최종 이동할 지역 대입 실험
    $game_variables[190] = @index
    if $game_variables[191] > $game_variables[190]
      $game_variables[188] = $game_variables[191] - $game_variables[190]
    else
      $game_variables[188] = $game_variables[190] - $game_variables[191]
    end
    $game_variables[28] = $game_variables[284]            # 구매 가격 변동
    $game_variables[28] += $game_party.members.size       # 인원
    $game_variables[28] = $game_variables[28] * 10        # 10배
    $game_variables[188] = 1 if 1 > $game_variables[188]  # 이동 거리

    $game_variables[28] = $game_variables[28] * $game_variables[188]
    $game_variables[28] = ($game_variables[28] * ($game_variables[163] * 0.01).to_f).to_i
    
    $game_variables[15] = $game_variables[188]
    
    Sound.play_ok
    Input.update
    deactivate
    SceneManager.return
    call_ok_handler
  end
  
  def col_max
    return 1
  end
  
  def update
    super
  end
  
  def make_command_list
    for i in 0...$lune_map_info.length
      command = $lune_map_info[i]['Name']
      add_command(command, nil) 
    end
  end
  
  def item_window=(item_window)
    @item_window = item_window
    update
  end
end