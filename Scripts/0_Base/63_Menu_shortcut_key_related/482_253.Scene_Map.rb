# encoding: utf-8
# Name: 253.Scene_Map
# Size: 10202
# encoding: utf-8
# Name: 253.Scene_Map
# Size: 10147
class Scene_Map < Scene_Base
  attr_accessor :spriteset
  
  alias :hm_sel_update :update
  def update
    hm_sel_update
    HM_SEL::time_manager
  end
  
  alias scene_map_create_all_windows_event_window create_all_windows
  def create_all_windows
    scene_map_create_all_windows_event_window
    create_event_window
    @hm_sel_gametimeclock = HM_SEL::Window_Clock.new
    @hm_sel_sex_clock = HM_SEL::Window_Sex_Clock.new
  end
  
  def create_event_window
    @event_window = Window_EventWindow.new
  end
  
  def event_window_add_text(text = nil)
    @event_window.add_text(text) if text != nil
  end
  
  alias scene_map_post_transfer_ew post_transfer
  def post_transfer
    #print("230.Scene_Map - post_transfer \n");
    $game_temp.clear_event_window_data  if YEA::EVENT_WINDOW::NEW_MAP_CLEAR
    @event_window.instant_hide          if @event_window != nil
    @spriteset.update_viewport_sizes    if @spriteset != nil
    scene_map_post_transfer_ew
  end
end

class Scene_Map
=begin
  # 자원 관련 배열 변수 추가 실험
  def initialize
    @e_rx = []
    @e_ry = []
  end
=end

  alias :pre_transfer_ve_light_effects :pre_transfer
  def pre_transfer
    pre_transfer_ve_light_effects
    # 맵 이동시 화면 깜빡여서 일단 주석 처리, 실험
    @spriteset.dispose_light
    # 동굴 내부 조명 초기화
    $game_variables[155] = 0
  end
  
  alias :post_transfer_ve_light_effects :post_transfer
  def post_transfer
    # 캐릭터의 그림자 갱신 처리 추가
    #print("253.Scene_Map - post_transfer \n");
    SceneManager.scene.spriteset.refresh_effects
    post_transfer_ve_light_effects
  end
  
  alias maqj_updascne_9kh4 update_scene
  def update_scene(*args, &block)
    maqj_updascne_9kh4(*args, &block)
    if $game_system.quest_map_access && !scene_changing?
      update_call_quest_journal
    end
  end
  
  def update_call_quest_journal
    #print("059.퀘스트 창, 단축키 - %s \n" % [$game_system.menu_disabled]);
    #if !$game_system.menu_disabled and !$game_map.interpreter.running? and !HM_SEL::time_stop? and $game_switches[283] == false and SceneManager.scene_is?(Scene_Map)
    if !$game_system.menu_disabled and !$game_map.interpreter.running? and !$game_temp.common_event_reserved? and !HM_SEL::time_stop? and $game_switches[283] == false and SceneManager.scene_is?(Scene_Map)
      # 풀, 나무등 조사하기 버튼
      #if Input.trigger?(:C) and $game_switches[52] == false and !$game_temp.common_event_reserved?
      if Input.trigger?(:C) and $game_switches[52] == false
        rx = $game_player.x;        ry = $game_player.y
        case $game_player.direction
          when 2; ry += 1;          when 8; ry -= 1
          when 4; rx -= 1;          when 6; rx += 1
        end
        # 앞에 npc 없을 경우 npc 실행
        if $game_map.event_id_xy(rx, ry) == 0 or $game_map.region_id(rx, ry) == 50
=begin
          @e_rx = [] if @e_rx == nil
          @e_ry = [] if @e_ry == nil
          @e_rx2 = rx
          @e_ry2 = ry
          for i in 0..10
            if @e_rx[i] == @e_rx2 and @e_ry[i] == @e_ry2
              $game_variables[148] += 1
            else
              @e_rx[i] = @e_rx2
              @e_ry[i] = @e_ry2
              $game_variables[148] = $game_variables[148] / 2
              break
            end
          end
=end
          # 앞 타일 ID 를 변수에 저장
          if $game_map.region_id(rx, ry) >= 8 and $game_map.terrain_tag(rx, ry) == 0
            $game_variables[48] = $game_map.region_id(rx, ry)
            $game_variables[50] = $game_map.terrain_tag(rx, ry)
            $game_temp.reserve_common_event(113)
          else
            $game_variables[48] = $game_map.terrain_tag(rx, ry)
            $game_variables[50] = $game_map.region_id(rx, ry)
            $game_temp.reserve_common_event(113)
          end
        # 앞에 npc 있는 경우
        elsif $game_map.event_id_xy(rx, ry) != 0 and !$game_map.interpreter.running?
          if $game_map.map_id != 174
            for event in $game_map.events.values.select{|event| event.pos?(rx, ry) and event.deadposee}
              if $game_map.events[event.id].x != $game_player.x or $game_map.events[event.id].y != $game_player.y
                #print("059.퀘스트 창, 단축키 1 - %s \n" % [event.id]);
                $game_map.events[event.id].start
              end
            end
          else
            for event in $game_map.events.values.select{|event| event.pos?(rx, ry)}
              if $game_map.events[event.id].x != $game_player.x or $game_map.events[event.id].y != $game_player.y
                #print("059.퀘스트 창, 단축키 2 - %s \n" % [event.id]);
                $game_map.events[event.id].start
              end
            end
          end
        end
      # 상태이상 UI 변경
      elsif Keyboard.trigger?(:kT)
        $game_switches[55] = true # 눈 깜빡임
        $game_switches[36] == false ? $game_switches[36] = true : $game_switches[36] = false
      # 화살 오토타겟 설정 단축키
      elsif Keyboard.trigger?(:kTAB)
        $game_switches[82] == false ? $game_switches[82] = true : $game_switches[82] = false
      # 아이템 루팅 자동, 금지 수정
      elsif Keyboard.caps_on? and $game_switches[38] == false
        print("059.퀘스트 창, 단축키 - (%s) \n" % [$game_switches[38]]);
        $game_switches[38] = true
      elsif !Keyboard.caps_on? and $game_switches[38] == true
        print("059.퀘스트 창, 단축키 - (%s) \n" % [$game_switches[38]]);
        $game_switches[38] = false
      # 시프트 이미지 ON / OFF
      elsif Keyboard.trigger?(:kP)
        # 에르니로 선택된 상태인지 확인
        $game_temp.reserve_common_event(9)
      # 지형지물 반투명 효과 적용
      elsif Keyboard.trigger?(:kY)
        if $game_switches[50] == false
          $game_switches[55] = true # 눈 깜빡임
          $game_switches[34] == false ? $game_switches[34] = true : $game_switches[34] = false
        else
          $game_temp.reserve_common_event(135) # 지도
        end
      # 우측 하단 UI 변경
      elsif Keyboard.trigger?(:kU)
        $game_switches[55] = true # 눈 깜빡임
        $game_switches[35] == false ? $game_switches[35] = true : $game_switches[35] = false
      # 퀘스트창 띠우기
      elsif Keyboard.trigger?(:kJ) and $game_map.map_id != 128
        if $game_variables[283] == 1 or $game_variables[283] == 2
          #SceneManager.clear
          SceneManager.call(Scene_Menu)
          SceneManager.call(Scene_Quest)
          Window_MenuCommand::init_command_position2(:quest_journal)
        end
      end
      if $game_variables[283] == 1 and $game_map.map_id != 128 and $game_temp.call_menu
        # 레벨 포인트 단축키
        if Keyboard.trigger?(:kM)
          #$game_temp.call_menu = false
          #SceneManager.clear
          SceneManager.call(Scene_Menu)
          SceneManager.call(Scene_DistributeParameter)
          Window_MenuCommand::init_command_position2(:distribute_parameter)
          #Window_MenuCommand::init_command_position
        # 보유 레시피창 띠우기
        elsif Keyboard.trigger?(:kB)
          #$game_temp.call_menu = false
          #SceneManager.clear
          SceneManager.call(Scene_Menu)
          SceneManager.call(Scene_Recipes)
          Window_MenuCommand::init_command_position2(:recipes)
          #Window_MenuCommand::init_command_position
        # 세이브 화면 단축키 추가 수정
        #elsif Keyboard.trigger?(:kL)
        #  if $game_variables[283] == 1 and $game_map.map_id != 128
        #    SceneManager.clear
        #    SceneManager.call(Scene_Save)
        #  end
        # 스킬 배우기 실험
        elsif Keyboard.trigger?(:kK)
          #$game_temp.call_menu = false
          #SceneManager.clear
          SceneManager.call(Scene_Menu)
          SceneManager.call(Scene_SkillPointLearn)
          Window_MenuCommand::init_command_position2(:skill_learn)
          #Window_MenuCommand::init_command_position
        # 스킬 단축키
        elsif Keyboard.trigger?(:kV)
          #$game_temp.call_menu = false
          #SceneManager.clear
          SceneManager.call(Scene_Menu)
          SceneManager.call(Scene_Skill)
          Window_MenuCommand::init_command_position2(:skill)
          #Window_MenuCommand::init_command_position
        # 레시피 단축키
=begin
        elsif Keyboard.trigger?(:kO)
          $game_temp.call_menu = false
          SceneManager.clear
          SceneManager.call(Scene_Recipes)
          Window_MenuCommand::init_command_position2(:recipes)
          #Window_MenuCommand::init_command_position
=end
        # 상태 목록창
        elsif Keyboard.trigger?(:kO)
          #$game_temp.call_menu = false
          #SceneManager.clear
          SceneManager.call(Scene_Menu)
          SceneManager.call(Scene_StateView)
          Window_MenuCommand::init_command_position2(:stateview)
          #Window_MenuCommand::init_command_position
        # 아이템 창 단축키 추가 수정
        elsif Keyboard.trigger?(:kI)
          #$game_temp.call_menu = false
          #SceneManager.clear
          SceneManager.call(Scene_Menu)
          SceneManager.call(Scene_Item)
          Window_MenuCommand::init_command_position2(:item)
          #Window_MenuCommand::init_command_position
        # 기본 메뉴창 단축키 추가 수정
        elsif Keyboard.trigger?(:kX)
          $game_temp.call_menu = false
          #SceneManager.clear
          SceneManager.call(Scene_Menu)
          Window_MenuCommand::init_command_position
        end
      end
    end
  end

  alias tmmedal_scene_map_create_all_windows create_all_windows
  def create_all_windows
    tmmedal_scene_map_create_all_windows
    create_medal_window
  end
  
  def create_medal_window
    @medal_window = Window_MedalInfo.new
  end
end