# encoding: utf-8
# Name: Scene_ItemBase
# Size: 7211
#==============================================================================
# ** Scene_ItemBase
#------------------------------------------------------------------------------
#  아이템 화면과 스킬 화면의 공통 처리를 수행하는 클래스입니다.
#==============================================================================

class Scene_ItemBase < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    create_actor_window
  end
  #--------------------------------------------------------------------------
  # * Create Actor Window
  #--------------------------------------------------------------------------
  def create_actor_window
    @actor_window = Window_MenuActor.new
    #@actor_window = Window_MenuActor2.new
    @actor_window.y = 72
    @actor_window.set_handler(:ok,     method(:on_actor_ok))
    @actor_window.set_handler(:cancel, method(:on_actor_cancel))
  end
  #--------------------------------------------------------------------------
  # * 현재 선택한 항목을 가져 오기
  #--------------------------------------------------------------------------
  def item
    @item_window.item
  end
  #--------------------------------------------------------------------------
  # * 항목의 사용자 가져오기
  #--------------------------------------------------------------------------
  def user
    $game_party.movable_members.max_by {|member| member.pha }
  end
  #--------------------------------------------------------------------------
  # * 커서 왼쪽 칼럼에 있는지 확인
  #--------------------------------------------------------------------------
  def cursor_left?
    @item_window.index % 2 == 0
  end
  #--------------------------------------------------------------------------
  # * 하위 창보기
  #--------------------------------------------------------------------------
  def show_sub_window(window)
    width_remain = Graphics.width - window.width
    window.x = cursor_left? ? width_remain : 0
    @viewport.rect.x = @viewport.ox = cursor_left? ? 0 : window.width
    @viewport.rect.width = width_remain
    window.show.activate
  end
  #--------------------------------------------------------------------------
  # * Hide Subwindow
  #--------------------------------------------------------------------------
  def hide_sub_window(window)
    @viewport.rect.x = @viewport.ox = 0
    @viewport.rect.width = Graphics.width
    window.hide.deactivate
    activate_item_window
  end
  #--------------------------------------------------------------------------
  # * Actor [OK]
  #--------------------------------------------------------------------------
  def on_actor_ok
    if item_usable?
      use_item
    else
      Sound.play_buzzer
    end
  end
  #--------------------------------------------------------------------------
  # * Actor [Cancel]
  #--------------------------------------------------------------------------
  def on_actor_cancel
    hide_sub_window(@actor_window)
    @help_window.hide
  end
  #--------------------------------------------------------------------------
  # * 항목 확인
  #--------------------------------------------------------------------------
  def determine_item
    # 수정 추가
    @help_window = Window_Help.new
    @help_window.set_item(item)
    if !item.is_a?(RPG::Weapon) and !item.is_a?(RPG::Armor)
      if item.for_friend?
        #print("Scene_ItemBase - 1 \n");
        show_sub_window(@actor_window)
        @actor_window.select_for_item(item)
      else
        use_item if item_usable?  # 메뉴에서 사용 오류 수정 추가
        #print("Scene_ItemBase - 2 \n");
        @help_window.hide.deactivate
        activate_item_window
      end
    else
      @help_window.hide.deactivate
      activate_item_window
    end
  end
  #--------------------------------------------------------------------------
  # * 아이템 창을 활성화
  #--------------------------------------------------------------------------
  def activate_item_window
    @item_window.refresh
    @item_window.activate
  end
  #--------------------------------------------------------------------------
  # * 배우의 배열 항목 사용에 의해 표적으로하기
  #--------------------------------------------------------------------------
  def item_target_actors
    if !item.for_friend?
      []
    elsif item.for_all?
      $game_party.members
    else
      [$game_party.members[@actor_window.index]]
    end
  end
  #--------------------------------------------------------------------------
  # * 항목을 사용할 수 있는지 확인
  #--------------------------------------------------------------------------
  def item_usable?
    user and user.usable?(item) and item_effects_valid?
  end
  #--------------------------------------------------------------------------
  # * 항목이 효과적인지 확인
  #--------------------------------------------------------------------------
  def item_effects_valid?
    #print("Scene_ItemBase - 효과적인지 확인 %s, %s \n" % [user.name, item.name]);
    item_target_actors.any? do |target|
      target.item_test(user, item)
    end
  end
  #--------------------------------------------------------------------------
  # * 액터에 아이템 사용
  #--------------------------------------------------------------------------
  def use_item_to_actors
    item_target_actors.each do |target|
      # 누구에게 아이템 사용했는지 액터 아이디 저장
      $game_variables[126] = target.id
      item.repeats.times { target.item_apply(user, item) }
    end
  end
  #--------------------------------------------------------------------------
  # * Use Item
  #--------------------------------------------------------------------------
  def use_item
    # 누구에게 아이템 사용했는지 액터 아이디 저장
    $game_variables[126] = user.id
    play_se_for_item
    user.use_item(item)
    use_item_to_actors
    # 메뉴창에서 사용시 아이템 제거
    if !SceneManager.scene_is?(Scene_Map)
      #print("Scene_ItemBase - 메뉴, 아이템 제거, %s \n" % [item.name]);
      $game_party.consume_item(item) if item.is_a?(RPG::Item)
      user.pay_skill_cost(item) if item.is_a?(RPG::Skill)
    end
    # Game_Battler 에서 커먼 이벤트를 바로 실행하게 만들어서 아래는 주석 처리한다.
    #check_common_event
    check_gameover
    @actor_window.refresh
  end
  #--------------------------------------------------------------------------
  # * 공통 이벤트가 예약되었는지 확인
  # 이벤트 호출이 예약된 경우 지도 화면으로 전환됩니다.
  #--------------------------------------------------------------------------
  def check_common_event
    #if $game_temp.common_event_reserved?
      #SceneManager.clear
      #fadeout_all(0)
      #SceneManager.goto(Scene_Map)
      #SceneManager.goto(Scene_Map)
    #end
    print("Scene_ItemBase - check_common_event \n");
    SceneManager.goto(Scene_Map) if $game_temp.common_event_reserved?
  end
end