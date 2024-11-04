# encoding: utf-8
# Name: Scene_Menu
# Size: 9520
#==============================================================================
# ** Scene_Menu
#------------------------------------------------------------------------------
#  This class performs the menu screen processing.
#==============================================================================

class Scene_Menu < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    create_command_window
    create_status_window
    create_location_window
  end
  #--------------------------------------------------------------------------
  # * 상단 지역 및 기타 시간 메뉴 추가
  #--------------------------------------------------------------------------
  def create_location_window
    @location_window = Window_location.new(0, 0)
  end
  #--------------------------------------------------------------------------
  # * Create Command Window
  #--------------------------------------------------------------------------
  def create_command_window
    @command_window = Window_MenuCommand.new
    @command_window.y = 72
    @command_window.set_handler(:item, method(:command_item))
    @command_window.set_handler(:skill, method(:command_skill))
    @command_window.set_handler(:equip, method(:command_personal))
    @command_window.set_handler(:status, method(:command_personal))
    @command_window.set_handler(:roster, method(:command_roster))
    @command_window.set_handler(:stateview, method(:command_StateView))
    @command_window.set_handler(:distribute_parameter, method(:command_parameter))
    @command_window.set_handler(:skill_learn, method(:command_skill_learn))
    @command_window.set_handler(:recipes, method(:command_recipes))
    @command_window.set_handler(:quest_journal, method(:command_quest))
    @command_window.set_handler(:medal, method(:command_medal))
    @command_window.set_handler(:factions, method(:command_factions))
    @command_window.set_handler(:save, method(:command_save))
    @command_window.set_handler(:rotools, method(:command_roster2))
    @command_window.set_handler(:rotools2, method(:command_roster3))
    @command_window.set_handler(:bestiary,  method(:command_bestiary))
    @command_window.set_handler(:game_end2, method(:command_game_end2))
    @command_window.set_handler(:game_end, method(:command_game_end))
    @command_window.set_handler(:cancel, method(:return_scene))
    #@command_window.set_handler(:cancel, method(:return_scene_ro))
  end
  
  #--------------------------------------------------------------------------
  # * 메뉴에서 나갈때를 아예 맵으로 지정한다.
  #--------------------------------------------------------------------------
=begin
  def return_scene_ro       # 메뉴 닫기
    print("Scene_Menu : 원본 - 맵으로 이동 \n");
    $game_temp.call_menu = true
    #SceneManager.clear
    SceneManager.call(Scene_Map)
    #Window_MenuCommand::init_command_position
  end
=end
  def command_bestiary      # 몬스터 도감
    #SceneManager.call(Scene_Menu)
    SceneManager.call(Scene_Bestiary)
  end
  def command_skill         # 스킬창
    SceneManager.call(Scene_Skill)
  end
  def command_quest         # 의뢰 목록
    SceneManager.call(Scene_Quest)
  end
  def command_recipes       # 보유 레시피
    SceneManager.call(Scene_Recipes)
  end
  def command_skill_learn   # 스킬 배우기
    #@command_window.index = 5
    SceneManager.call(Scene_SkillPointLearn)
  end
  def command_parameter   # 레벨 포인트
    SceneManager.call(Scene_DistributeParameter)
  end
  def command_game_end      # 게임 설정
    SceneManager.call(Scene_System)
  end
  def command_game_end2     # 기타 설정
    SceneManager.call(Scene_System2)
  end
  def command_roster2       # 단축키 창
    #SceneManager.exit
    #$game_map.autoplay
    #SceneManager.goto(Scene_Map)
    #$game_player.pearl_menu_call = [:tools, 2]
    #$game_temp.call_menu = true
    print("Scene_Menu : 원본 - 맵으로 이동 \n");
    $game_temp.call_menu = true
    SceneManager.clear
    SceneManager.call(Scene_Map)
    Window_MenuCommand::init_command_position
    $game_player.pearl_menu_call = [:tools, 2]
  end
  def command_roster3       # 낚시 창
    #SceneManager.exit
    #$game_map.autoplay
    #SceneManager.goto(Scene_Map)
    #SceneManager.call(Scene_FishStats)
    #$game_temp.call_menu = true
    print("Scene_Menu : 원본 - 맵으로 이동 \n");
    $game_temp.call_menu = true
    SceneManager.clear
    SceneManager.call(Scene_Map)
    Window_MenuCommand::init_command_position
    SceneManager.call(Scene_FishStats)
  end
  def command_item          # 아이템 창
    SceneManager.call(Scene_Item)
  end
  def command_factions      # 지역 공헌도
    SceneManager.call(Scene_FactionList)
  end
  def command_medal         # 업적 메달
    SceneManager.call(Scene_Medal)
  end
  def command_roster        # 동료 목록
    $game_variables[160] = 0
    SceneManager.call(Scene_Roster)
  end
  def command_StateView     # 상태이상 창
    SceneManager.call(Scene_StateView)
  end
  def command_save          # 세이브 창
    SceneManager.call(Scene_Save)
  end
  
  #--------------------------------------------------------------------------
  # * Create Status Window
  #--------------------------------------------------------------------------
  def create_status_window
    @status_window = Window_MenuStatus.new(@command_window.width, 72)
    @status_window.width = Graphics.width - 160
    @status_window.deactivate
    @status_window.unselect
  end
  #--------------------------------------------------------------------------
  # * [Skill], [Equipment] and [Status] Commands
  #--------------------------------------------------------------------------
  def command_personal
    # 캐릭터창 위치 및 사이즈 변경
    @command_window.hide.deactivate
    @status_window.x = 0
    @status_window.width = Graphics.width
    @status_window.select_last
    @status_window.activate
    @status_window.set_handler(:ok,     method(:on_personal_ok))
    @status_window.set_handler(:cancel, method(:on_personal_cancel))
  end
  #--------------------------------------------------------------------------
  # * [Formation] Command
  #--------------------------------------------------------------------------
  def command_formation
    @status_window.select_last
    @status_window.activate
    @status_window.set_handler(:ok,     method(:on_formation_ok))
    @status_window.set_handler(:cancel, method(:on_formation_cancel))
  end
  #--------------------------------------------------------------------------
  # * [OK] Personal Command
  #--------------------------------------------------------------------------
  def on_personal_ok
    case @command_window.current_symbol
    #when :skill
    #  SceneManager.call(Scene_Skill)
    when :equip
      SceneManager.call(Scene_Equip)
    when :status
      SceneManager.call(Scene_Status)
    #when :distribute_parameter  # 레벨 포인트
    #  SceneManager.call(Scene_DistributeParameter)
    when :roster                # 동료 목록
      SceneManager.call(Scene_Roster)
    #when :stateview             # 상태이상 창
    #  SceneManager.call(Scene_StateView)
    #when :skill_learn           # 스킬 배우기
    #  SceneManager.call(Scene_SkillPointLearn)
    when :recipes               # 보유 레시피
      SceneManager.call(Scene_Recipes)
    when :quest_journal         # 의뢰 목록
      SceneManager.call(Scene_Quest)
    when :medal                 # 업적 메달
      SceneManager.call(Scene_Medal) 
    when :factions              # 지역 공헌도
      SceneManager.call(Scene_FactionList)
    when :save                  # 세이브 창
      SceneManager.call(Scene_Save)
    when :game_end2             # 기타 설정
      SceneManager.call(Scene_System2)
    when :game_end              # 게임 설정
      SceneManager.call(Scene_System)
    end
  end
  #--------------------------------------------------------------------------
  # * [Cancel] Personal Command
  #--------------------------------------------------------------------------
  def on_personal_cancel
    # 캐릭터창 위치 및 사이즈 변경
    @status_window.x = 160
    @status_window.width = Graphics.width - 160
    @status_window.deactivate
    @status_window.unselect
    @command_window.show
    @command_window.activate
  end
  #--------------------------------------------------------------------------
  # * Formation [OK]
  #--------------------------------------------------------------------------
  def on_formation_ok
    if @status_window.pending_index >= 0
      $game_party.swap_order(@status_window.index,
                             @status_window.pending_index)
      @status_window.pending_index = -1
      @status_window.redraw_item(@status_window.index)
    else
      @status_window.pending_index = @status_window.index
    end
    @status_window.activate
  end
  #--------------------------------------------------------------------------
  # * Formation [Cancel]
  #--------------------------------------------------------------------------
  def on_formation_cancel
    if @status_window.pending_index >= 0
      @status_window.pending_index = -1
      @status_window.activate
    else
      @status_window.deactivate
      @status_window.unselect
      @command_window.activate
    end
  end
end