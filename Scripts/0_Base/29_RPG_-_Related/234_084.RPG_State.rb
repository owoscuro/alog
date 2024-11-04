# encoding: utf-8
# Name: 084.RPG_State
# Size: 2441
#-------------------------------------------------------------------------------
# reveal_state_description(state_id)
# state_id : the ID of the state, as listed in the database.
#
# reveal_buff_description(buff_id)
# reveal_buff_description(buff_id, level)
# buff_id  : ID of the buff, where 0 = MaxHP; 1 = MaxMP; 2 = Attack;
#            3 = Defence; 4 = Magic; 5 = Magic Defence; 6 = Agility;
#            7 = Luck
# level    : level of the buff, where -1 = Debuff 1; -2 = Debuff 2;
#            1 = Buff 1; 2 = Buff 2. If you exclude level, then all 
#            levels of the buff will be revealed.
#
# EXAMPLES:
#
# reveal_state_description(2)
# State 2 (Poison) will now be described in the State View scene.
#
# reveal_buff_description(5, 2)
# Level 2 of the Magic Defence Buff will now be described in State View
#
# reveal_buff_description(2)
# All levels of the Attack Buff will be described in State View
#
# I reiterate: the above commands are only relevant if you set the option at
# line 112, MASV_SHOW_ALL_STATES, to false. If you do not and that is true, 
# then all states (and buffs, if included) will be shown right off the bat.
#-------------------------------------------------------------------------------

  MASV_STATUS_ACCESS = false
  
  # 메뉴의 명령을 통해 장면에 액세스해야 하는지 여부
  MASV_MENU_ACCESS = true
  
  # 메뉴를 통해 액세스할 수 있는 경우 명령 목록에 있는 인덱스는 무엇입니까?
  MASV_MENU_INDEX = 4
  MASV_SCENE_LABEL = "상태 목록"
  # MASV_SCENE_LABEL = "Lista de estados"

  # 상태 이름을 그릴 수평 공간의 양(픽셀)입니다.
  MASV_NAME_FIELD_WIDTH = 124
  MASV_LABEL_WINDOW = {
  show:     false,
  fontname: Font.default_name,
  fontsize: 24,
  colour:   0,
  align:    1
  } 
  
  # 숨겨진 모든 상태를 즉시 표시할지 여부
  MASV_SHOW_ALL_STATES = true
  MASV_AUTOREVEAL_STATES = false
  MASV_INCLUDE_BUFFS = false

class RPG::State
  def description
    if !@masv_description
      @masv_description = self.note[/\\DESC\{(.+?)\}/im].nil? ? "" : $1
      @masv_description.gsub!(/\n/, "")
      @masv_description.gsub!(/\\LB/i, "\n")
    end
    @masv_description
  end
  
  def desc_hide?
    if !@desc_hide
      @desc_hide = !self.note[/\\DESC_HIDE/i].nil?
      @desc_hide = self.description == ""
    end
    @desc_hide
  end
end