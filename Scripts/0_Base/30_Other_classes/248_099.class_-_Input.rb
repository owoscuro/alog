# encoding: utf-8
# Name: 099.class - Input
# Size: 2888
class << Input
  alias falcaopearl_abs_cooldown_update update
  def Input.update
    update_pearl_abs_cooldown
    update_popwindow if !$game_temp.nil? and !$game_temp.pop_windowdata.nil?
    falcaopearl_abs_cooldown_update
  end

  def update_popwindow
    $game_temp.pop_windowdata[0] -= 1 if $game_temp.pop_windowdata[0] > 0
    if @temp_window.nil?
      tag = $game_temp.pop_windowdata[2]
      string = $game_temp.pop_windowdata[1] + tag
      width = Graphics.width
      @temp_window = Window_Base.new(0, 80, width, 64)
      fc = Color.new(225,0,0,128)
      fc2 = Color.new(225,0,0,0)
      @temp_window.contents.gradient_fill_rect(width / 2, 12, width / 2, 48, fc, fc2)
      @temp_window.contents.gradient_fill_rect(0, 12, width / 2, 48, fc2, fc)
      
      @temp_window.contents.font.size = 24
      @temp_window.contents.font.color = Font.default_color
      @temp_window.contents.font.out_color = Font.default_out_color
      @temp_window.contents.font.bold = false
      
      @temp_window.draw_text(0, 0, width, 48, $game_temp.pop_windowdata[1], 1)
      @temp_window.z = 1001
      @temp_window.opacity = 0
      @current_scene = SceneManager.scene.class
    end

    if $game_temp.pop_windowdata[0] == 0 || @current_scene != SceneManager.scene.class 
      @temp_window.dispose
      @temp_window = nil
      $game_temp.pop_windowdata = nil
    end
  end

  def update_pearl_abs_cooldown
    # 진행 중지 -----------------------------------------------------------------
    return if HM_SEL::time_stop? and $game_map.map_id != 21
    # --------------------------------------------------------------------------
    #print("099.class << Input - ");
    #print("쿨다운 업데이트 \n");
    if SceneManager.scene_is?(Scene_Map)
      eval_cooldown($game_party.battle_members) if !$game_party.nil?
      eval_cooldown($game_map.enemies) if !$game_map.nil?
    end
  end

  # 쿨다운 업데이트
  def eval_cooldown(operand)
    for sub in operand
      sub.skill_cooldown.each {|sid, sv| # skill
      if (sub.skill_cooldown[sid]).to_i > 59
        sub.skill_cooldown[sid] -= 1
      else
        sub.skill_cooldown.delete(sid)
      end
      }
      sub.item_cooldown.each {|iid, iv| # item
      if (sub.item_cooldown[iid]).to_i > 59
        sub.item_cooldown[iid] -= 1
      else
        sub.item_cooldown.delete(iid)
      end
      }
      sub.weapon_cooldown.each {|wid, wv| # weapon
      if (sub.weapon_cooldown[wid]).to_i > 59
        sub.weapon_cooldown[wid] -= 1
      else
        sub.weapon_cooldown.delete(wid)
      end
      }
=begin
      sub.armor_cooldown.each {|aid, av| #armor
      if (sub.armor_cooldown[aid]).to_i > 0
        sub.armor_cooldown[aid] -= 30
      else
        sub.armor_cooldown.delete(aid)
      end
      }
=end
    end
  end
end