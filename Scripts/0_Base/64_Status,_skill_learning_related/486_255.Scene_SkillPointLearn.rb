# encoding: utf-8
# Name: 255.Scene_SkillPointLearn
# Size: 7567
class Scene_SkillPointLearn < Scene_MenuBase
  #--------------------------------------------------------------------------
  # ● 개시 처리
  #--------------------------------------------------------------------------
  alias :bm_menu_start :start
  def start
    super
    create_location_window
    create_actor_window
  end
  
  #--------------------------------------------------------------------------
  # * 스킬 배우기 설명창 추가
  #--------------------------------------------------------------------------
  def item
    @item_window.item
  end
  
  def show_sub_window(window)
    @viewport.rect.width = 0
    window.show.activate
  end
  
  def hide_sub_window(window)
    @viewport.rect.width = Graphics.width
    window.hide.deactivate
    @item_window.show.activate
  end
  
  #--------------------------------------------------------------------------
  # ● 액터 윈도우의 작성
  #--------------------------------------------------------------------------
  
  def create_location_window
    @location_window = Window_location.new(0, 0)
  end
  
  def create_actor_window
    @actor_window = Window_MenuStatus.new(0,72)
    #@actor_window = Window_MenuStatus2.new(0,@location_window.height)
    @actor_window.viewport = @viewport
    @actor_window.set_handler(:ok,     method(:on_actor_ok))
    @actor_window.set_handler(:cancel, method(:return_scene))
    # 초기 선택 엑터 인덱스
    @actor_window.index = 0
    @actor_window.activate
  end
  
  def create_face_window
    @face_window = Window_DistributeParameterActor.new(0, 0, @actor)
    @face_window.viewport = @viewport
    @face_window.actor = @actor
    @face_window.hide
    @help_window.y = @face_window.height
  end

  #--------------------------------------------------------------------------
  # 가온데 정렬 추가 수정
  #--------------------------------------------------------------------------
  def alignment
    return 1
  end
  
  def create_command_window
    wx = 0
    wy = 72 + @face_window.height
    wh = @actor_window.height / 2
    @command_window = Window_SkillCommand2.new(wx, wy)
    @command_window.viewport = @viewport
    @command_window.help_window = @help_window
    @command_window.actor = @actor
    @command_window.hide
    @command_window.set_handler(:skill,  method(:command_skill))
    @command_window.set_handler(:cancel, method(:return_scene))
    @command_window.set_handler(:pagedown, method(:next_actor))
    @command_window.set_handler(:pageup,   method(:prev_actor))
  end

  
  def command_skill
    @command_window.deactivate
    @item_window.refresh
    @item_window.activate.select(0)
  end
  
  #--------------------------------------------------------------------------
  # ● 구입 윈도우의 작성
  #--------------------------------------------------------------------------
  def create_item_window
    wx = 0
    wy = @command_window.y + @command_window.height
    wh = Graphics.height - wy
    @item_window = Window_SkillLearnList.new(wx, wy, wh)
    @item_window.viewport = @viewport
    @item_window.back_opacity = 192
    @item_window.help_window = @help_window
    @item_window.hide
    @item_window.set_handler(:ok,     method(:on_buy_ok))
    @item_window.set_handler(:cancel, method(:on_command_cancel))
    @item_window.set_handler(:description, method(:on_item_description))
  end
  
  def cursor_re
    @item_window.refresh
  end
  
  def on_actor_change
    # 주인공 변경 버튼
    @actor_window.hide.deactivate
    @item_window.actor = @actor
    @face_window.actor = @actor
    @face_window.show
    @item_window.show.unselect
    @command_window.show.activate
    @help_window.show
    if @help_window
      @help_window.set_text(BRAVO_STORAGE_2::HELP_TEXT_03, nil)
    end
    @location_window.hide.deactivate
    refresh
  end
  
  #--------------------------------------------------------------------------
  # ● 액터［결정］
  #--------------------------------------------------------------------------
  def on_actor_ok
    create_help_window
    @help_window.hide
    create_face_window
    create_command_window
    create_item_window
    # 스킬 배우기 설명창 추가
    create_description_window
    @actor = $game_party.members[@actor_window.index]
    @actor_window.hide.deactivate
    @item_window.actor = @actor
    @face_window.actor = @actor
    @face_window.show
    @item_window.show.unselect
    @command_window.show.activate
    @help_window.show
    if @help_window
      @help_window.set_text(BRAVO_STORAGE_2::HELP_TEXT_03, nil)
    end
    @location_window.hide.deactivate
    refresh
  end
  
  #--------------------------------------------------------------------------
  # ● 구입［결정］
  #--------------------------------------------------------------------------
  def on_buy_ok
    @item = @item_window.item
    @actor.skill_point -= @item_window.needpt(@item.id)
    @actor.skill_point2 += @item_window.needpt(@item.id)
    @actor.learn_skill(@item.id)
    
    # 착용 가능 무게 증가 실험
    if @item.id == 290 or @item.id == 291 or @item.id == 292 or @item.id == 293
      change_weight_limit(@actor.id, 10)
      $game_actors[@actor.id].base_inv += 30
    end
    
    # 흥정 스킬
    if @item.id == 245 or @item.id == 246 or @item.id == 247 or @item.id == 248 or @item.id == 249
      $game_variables[295] += 10
    end
    
    # 고양이 눈
    if @item.id == 325
      $game_variables[30] = 99
    end
    
    @item_window.refresh
    @face_window.refresh
    @help_window.show
    @item_window.show.activate
  end
  
  # 착용 가능 무게 증가 실험
  def change_weight_limit(actor_id, amount)
    $game_actors[actor_id].weight_mod += amount
    if $game_actors[actor_id].available_weight < 0
      if $game_party.in_battle
        Graphics.freeze
        SceneManager.scene.info_viewport.visible = false
        SceneManager.scene.log_window.visible = false
        hide_extra_gauges if $imported["YEA-BattleEngine"]
        SceneManager.snapshot_for_background
        $game_party.menu_actor = $game_actors[actor_id]
        old_scene = SceneManager.scene
        SceneManager.call(Scene_Equip)
        SceneManager.scene.main
        SceneManager.force_recall(old_scene)
        show_extra_gauges if $imported["YEA-BattleEngine"]
        SceneManager.scene.info_viewport.visible = true
        SceneManager.scene.log_window.visible = true
        SceneManager.scene.status_window.refresh
        SceneManager.scene.perform_transition
      else
        $game_party.menu_actor = self
        old_scene = SceneManager.scene
        SceneManager.call(Scene_Equip)
        SceneManager.scene.main
        SceneManager.force_recall(old_scene)
        SceneManager.scene.perform_transition
      end
    end
  end
  
  def on_command_cancel
    # 스킬 목록에서 카테고리 목록으로 나가기
    @item_window.unselect
    @item_window.deactivate
    @command_window.show.activate
    @help_window.show
    if @help_window
      @help_window.set_text(BRAVO_STORAGE_2::HELP_TEXT_03, nil)
    end
  end
  
  def refresh
    @actor_window.refresh
    @face_window.refresh
    @item_window.refresh
    @help_window.refresh
    if @help_window
      @help_window.set_text(BRAVO_STORAGE_2::HELP_TEXT_03, nil)
    end
    @location_window.refresh
  end
end