# encoding: utf-8
# Name: 140.Anime_Obj
# Size: 4030
#===============================================================================
# * Falcao Pearl ABS script shelf # 5
#===============================================================================
class Anime_Obj < Game_Character
  attr_accessor :draw_it, :destroy_it, :item, :user, :original_speed
  attr_reader   :custom_graphic
  
  def initialize(user, item)
    super()
    PearlKernel.load_item(item)
    @draw_it = false
    @destroy_it = false
    @item = item
    @user = user
    @custom_graphic = false
    graphic = PearlKernel.user_graphic
    if graphic.split(" ").include?('custom') 
      graphic = graphic.sub("custom ","")
      @custom_graphic = true
      user.transparent = true
      user.using_custom_g = true
    end
    # 휠윈드인 경우 착용한 무기 그래픽을 사용한다.
    # 플레이어의 경우 무기 그래픽을 가져온다.
    # 몬스터의 경우 데이터베이스의 무기 그래픽을 가져온다.
    if item.is_a?(RPG::Skill)
      if @user.battler.is_a?(Game_Actor)
        if @user.battler.skill_learn?($data_skills[85])
          wtype_id1 = item.required_wtype_id1
          wtype_id2 = item.required_wtype_id2
          if @user.battler.equips[0] != nil and @user.battler.equips[1] != nil and @user.battler.equips[1].is_a?(RPG::Weapon)
            if wtype_id1 == @user.battler.equips[0].wtype_id or wtype_id2 == @user.battler.equips[0].wtype_id
              graphic = @user.battler.equips[0].tool_data("User Graphic = ", false)
            elsif wtype_id1 == @user.battler.equips[1].wtype_id or wtype_id2 == @user.battler.equips[1].wtype_id
              graphic = @user.battler.equips[1].tool_data("User Graphic = ", false)
            else
              graphic = @user.battler.equips[0].tool_data("User Graphic = ", false)
            end
          else
            if @user.battler.equips[0] != nil
              graphic = @user.battler.equips[0].tool_data("User Graphic = ", false)
            elsif @user.battler.equips[1] != nil
              graphic = @user.battler.equips[1].tool_data("User Graphic = ", false)
            else
              graphic = "$W_Weapon"
            end
          end
        elsif @user.battler.equips[0] != nil
          graphic = @user.battler.equips[0].tool_data("User Graphic = ", false)
        else
          graphic = "$W_Weapon"
        end
      else
        if @user.battler.is_a?(Game_Enemy)
          @character_name = graphic
        else
          graphic = "$W_Weapon"
        end
      end
    end
    # 무기 그래픽
    @character_name = graphic
    
    moveto(@user.x, @user.y)
    set_direction(@user.direction)
    @original_speed = PearlKernel.user_animespeed
    # 무기 타입 별로 공격속도 낮추기
    if !@user.battler.is_a?(Game_Enemy) and @user.battler.equips[0] != nil
      case @user.battler.equips[0].wtype_id
      when 1; @original_speed += 4 * 60   #도끼
      when 2; @original_speed += 0 * 60   #너클
      when 3; @original_speed += 2 * 60   #창
      when 4; @original_speed += 4 * 60   #검
      when 5; @original_speed += 4 * 60   #도
      when 6; @original_speed += 2 * 60   #활
      when 7; @original_speed += 0 * 60   #단검
      when 8; @original_speed += 2 * 60   #메이스
      when 9; @original_speed += 2 * 60   #지팡이
      else; @original_speed += 2 * 60     #기타
      end
      
      # 쿨타임 감소 스킬
      @original_speed -= 60 if @user.battler.skill_learn?($data_skills[322])
      @original_speed -= 60 if @user.battler.skill_learn?($data_skills[323])
      
      @original_speed = @original_speed - (@original_speed % 60)
      @original_speed = 30 if 60 > @original_speed
    end

    # 아이콘 스프라이트 확인
    PearlKernel.check_iconset(@item, "User Iconset = ", self)
    @character_name = "" if @user_iconset != nil
  end
  
  def self.user_graphic2()
    @item.tool_data("User Graphic = ", false)
  end
end