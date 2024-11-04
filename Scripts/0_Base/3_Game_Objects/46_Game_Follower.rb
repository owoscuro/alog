# encoding: utf-8
# Name: Game_Follower
# Size: 4471
#==============================================================================
# ** Game_Follower
#------------------------------------------------------------------------------
#  This class handles followers. A follower is an allied character, other than
# the front character, displayed in the party. It is referenced within the
# Game_Followers class.
#==============================================================================

class Game_Follower < Game_Character
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(member_index, preceding_character)
    super()
    @member_index = member_index
    @preceding_character = preceding_character
    @transparent = $data_system.opt_transparent
    @through = true
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    @character_name = visible? ? actor.character_name : ""
    @character_index = visible? ? actor.character_index : 0
  end
  #--------------------------------------------------------------------------
  # * Get Corresponding Actor
  #--------------------------------------------------------------------------
  def actor
    $game_party.battle_members[@member_index]
  end
  #--------------------------------------------------------------------------
  # * 가시성 결정
  #--------------------------------------------------------------------------
  def visible?
    actor && $game_player.followers.visible
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    unless !actor
      @ro_at = actor.id
      # 이동속도 기본값
      @event_speed = 4
      
      # 달리기 이동속도 추가
      dash_plus = 1 + ($game_variables[MOVE_CONTROL::DASH_PLUS] * 0.1)
      @event_speed += ($game_player.dash? ? dash_plus : 0)
      
      # 절제, 식탐에 의한 이동속도 조절 실험
      #@event_speed += 0.5 if $game_actors[@ro_at].skill_learn?($data_skills[331])
      #@event_speed -= 0.5 if $game_actors[@ro_at].skill_learn?($data_skills[332])
      # 허기, 갈증, 피로에 의한 이동속도 조절
      @event_speed -= 0.1 if ($game_actors[@ro_at].hunger_rate).to_i >= 80
      @event_speed -= 0.1 if ($game_actors[@ro_at].thirst_rate).to_i >= 80
      @event_speed -= 0.1 if ($game_actors[@ro_at].sleep_rate).to_i >= 80
      # 체온에 따른 이동속도 조절
      @event_speed -= 0.1 if $game_actors[@ro_at].temper.to_i < 40
      @event_speed -= 0.2 if $game_actors[@ro_at].temper.to_i < 30
      @event_speed -= 0.3 if $game_actors[@ro_at].temper.to_i < 20
      # 무게가 많이 오버한 경우 이속 추가 감소
      if $game_party.total_inv_size >= $game_party.inv_max * 2
        @event_speed -= 1
      end
      # 최종 이동속도 값 적용
      @event_speed += $game_actors[@ro_at].atk_times_add * 0.4
      @move_speed = @event_speed
    end
    @transparent    = $game_player.transparent
    @walk_anime     = $game_player.walk_anime
    @step_anime     = $game_player.step_anime
    @direction_fix  = $game_player.direction_fix
    @opacity        = $game_player.opacity
    @blend_type     = $game_player.blend_type
    super
  end
  #--------------------------------------------------------------------------
  # * 앞의 문자를 추구
  #--------------------------------------------------------------------------
  def chase_preceding_character
    unless moving?
      sx = distance_x_from(@preceding_character.x)
      sy = distance_y_from(@preceding_character.y)
      if sx != 0 && sy != 0
        move_diagonal(sx > 0 ? 4 : 6, sy > 0 ? 8 : 2)
      elsif sx != 0
        move_straight(sx > 0 ? 4 : 6)
      elsif sy != 0
        move_straight(sy > 0 ? 8 : 2)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Determine if at Same Position as Preceding Character
  #--------------------------------------------------------------------------
  def gather?
    !moving? && pos?(@preceding_character.x, @preceding_character.y)
  end
end