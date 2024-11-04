# encoding: utf-8
# Name: Window_MenuCommand
# Size: 6493
# encoding: utf-8
# Name: Window_MenuCommand
# Size: 4867
#==============================================================================
# ** Window_MenuCommand
#------------------------------------------------------------------------------
#  This command window appears on the menu screen.
#==============================================================================

class Window_MenuCommand < Window_Command
  #--------------------------------------------------------------------------
  # * 명령 선택 위치 초기화(클래스 방법)
  #--------------------------------------------------------------------------
  def self.init_command_position
    @@last_command_symbol = nil
  end
  #--------------------------------------------------------------------------
  # * 단축키 진입 메뉴 설정
  #--------------------------------------------------------------------------
  def self.init_command_position2(current)
    current_symbol = current
    @@last_command_symbol = current
  end
  #--------------------------------------------------------------------------
  # 가온데 정렬 추가 수정
  #--------------------------------------------------------------------------
  def alignment
    return 1
  end
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0)
    # 아래 원본이지만, 기본 메뉴 단축키를 변경하니 오류 발생
    select_last
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    return 160
  end
  #--------------------------------------------------------------------------
  # * Get Number of Lines to Show
  #--------------------------------------------------------------------------
  def visible_line_number
    item_max
  end
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    add_main_commands
  end
  #--------------------------------------------------------------------------
  # * Add Main Commands to List
  #--------------------------------------------------------------------------
#~   def add_main_commands
#~     add_command("Inventario",    :item,   true)
#~     add_command("Habilidades",   :skill,  true)
#~     add_command("Equipo",        :equip,  true)
#~     add_command("Estadísticas",  :status, true)
#~     add_command("Puntos Nivel",  :distribute_parameter, true)
#~     add_command("Aprender Habs.",:skill_learn, true)
#~     add_command("Recetas",       :recipes)
#~     add_command("Estados",       :stateview)
#~     add_command("Misiones",      :quest_journal)
#~     add_command("Logros",        :medal, true)
#~     add_command("Compañeros",    :roster, true)
#~     add_command("Regiones",      :factions)
#~     add_command("Guardar",       :save, save_enabled)
#~     add_command("Config. Atajos",:rotools)
#~     add_command("Historial Pesca", :rotools2)
#~     add_command("Bestiario",     :bestiary)
#~     add_command("Otras Opciones",:game_end2)
#~     add_command("Config. Sistema", :game_end)
#~   end
  def add_main_commands
    add_command(Lang::TEXTS[:interface][:menu_command][:item], :item, true)
    add_command(Lang::TEXTS[:interface][:menu_command][:skill], :skill, true)
    add_command(Lang::TEXTS[:interface][:menu_command][:equip], :equip, true)
    add_command(Lang::TEXTS[:interface][:menu_command][:status], :status, true)
    add_command(Lang::TEXTS[:interface][:menu_command][:distribute_parameter], :distribute_parameter, true)
    add_command(Lang::TEXTS[:interface][:menu_command][:skill_learn], :skill_learn, true)
    add_command(Lang::TEXTS[:interface][:menu_command][:recipes], :recipes)
    add_command(Lang::TEXTS[:interface][:menu_command][:stateview], :stateview)
    add_command(Lang::TEXTS[:interface][:menu_command][:quest_journal], :quest_journal)
    add_command(Lang::TEXTS[:interface][:menu_command][:medal], :medal, true)
    add_command(Lang::TEXTS[:interface][:menu_command][:roster], :roster, true)
    add_command(Lang::TEXTS[:interface][:menu_command][:factions], :factions)
    add_command(Lang::TEXTS[:interface][:menu_command][:save], :save, save_enabled)
    add_command(Lang::TEXTS[:interface][:menu_command][:rotools], :rotools)
    add_command(Lang::TEXTS[:interface][:menu_command][:rotools2], :rotools2)
    add_command(Lang::TEXTS[:interface][:menu_command][:bestiary], :bestiary)
    add_command(Lang::TEXTS[:interface][:menu_command][:game_end], :game_end2)
    add_command(Lang::TEXTS[:interface][:menu_command][:game_end], :game_end)
  end
  #--------------------------------------------------------------------------
  # * 기본 명령의 활성화 상태 가져오기
  #--------------------------------------------------------------------------
  def main_commands_enabled
    $game_party.exists
  end
  #--------------------------------------------------------------------------
  # * 형성의 활성화 상태 가져오기
  #--------------------------------------------------------------------------
  def formation_enabled
    $game_party.members.size >= 2 && !$game_system.formation_disabled
  end
  #--------------------------------------------------------------------------
  # * 저장의 활성화 상태 가져오기
  #--------------------------------------------------------------------------
  def save_enabled
    !$game_system.save_disabled
  end
  #--------------------------------------------------------------------------
  # * OK 버튼을 눌렀을 때 처리
  #--------------------------------------------------------------------------
  def process_ok
    #if current_symbol != nil
      @@last_command_symbol = current_symbol
    #end
    print("Window_MenuCommand - %s, %s \n" % [@@last_command_symbol, current_symbol]);
    super
  end
  #--------------------------------------------------------------------------
  # * 이전 선택 위치 복원
  #--------------------------------------------------------------------------
  def select_last
    select_symbol(@@last_command_symbol)
  end
end