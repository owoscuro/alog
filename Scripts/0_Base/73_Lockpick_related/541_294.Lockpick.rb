# encoding: utf-8
# Name: 294.Lockpick
# Size: 11756
$imported ||= {}
$imported["CP_LOCKPICK"] = 1.1

module CP
  module LOCKPICK
    module SETTINGS
      # 데이터베이스에 있는 선택의 ID 번호입니다.
      PICK_ITEM = 16

      # 황금 자물쇠 따기 설정입니다.
      # 황금 자물쇠 따개는 깨지지 않고 인벤토리에 있으면 기본적으로 사용됩니다.
      USE_G_PICK = false
      G_PICK_ITEM = 55

      # 락픽 성공 결과를 반환하는 변수.
      VARIABLE = 95

      # 자물쇠를 따기 시작할 때 재생되는 음향 효과, 볼륨 및 피치.
      LOCK_SOUND = "Switch2"
      LOCK_VOLUME = 60
      LOCK_PITCH = 110

      # 잠금을 해제할 때 재생되는 음향 효과, 볼륨 및 피치.
      UNLOCK_SOUND = "Key"
      UNLOCK_VOLUME = 80
      UNLOCK_PITCH = 100

      # 피크를 깰 때 재생되는 음향 효과, 볼륨 및 피치.
      BREAK_SOUND = "Sword2"
      BREAK_VOLUME = 60
      BREAK_PITCH = 130

      # 부수는 픽의 스위치와 락픽의 내구성을 결정합니다.
      # 내구도 값이 높을수록 깨지는 데 시간이 더 걸립니다.
      # "BREAK_PICKS"가 true로 설정된 경우 픽이 깨질 수 있습니다.
      BREAK_PICK_SWITCH = 231
      BREAK_PICKS = true
      LOCK_DURABILITY = 120
      PICK_DURABILITY = 90
      BROKEN = "This lock is broken"

      # 이것을 false로 설정하면 해당 상자가 표시되지 않습니다.
      # 상자에 표시할 텍스트도 설정합니다.
      SHOW_REMAINING = true
      ITEM_NAME = "도구"
    end

    # 그래픽 설정은 아래와 같습니다.
    # 화면 중앙에서 X 및 Y 오프셋을 사용합니다.
    module LOCK
      X_OFFSET = 0
      Y_OFFSET = -130
      GRAPHIC = "Lock"
    end

    module PICK
      X_OFFSET = 0
      Y_OFFSET = -120
      GRAPHIC = "Pick"
    end

    module KEY
      X_OFFSET = -1
      Y_OFFSET = -153
      GRAPHIC = "Key"
    end
  end
end

class Window_Picks < Window_Base
  def initialize
    super(0, Graphics.height - fitting_height(1), Graphics.width, fitting_height(1))
    refresh
  end

  def draw_picks(value, x, y, width)
    pick_item_key = $data_items[$game_variables[96]]
    draw_item_name(pick_item_key, x, y, enabled = true, self.contents.width)
    draw_text(x, y, contents.width / 3, 24, sprintf("×%s",$game_party.item_number(pick_item_key)), 2)
    if $game_variables[205] >= 1
      draw_text(x, y, contents.width - 25, 24, sprintf("Total de usos %s, Éxitos %s, Tasa de éxito %s%",$game_variables[205],$game_variables[204],($game_variables[204].to_f/$game_variables[205].to_f*100).round), 2)
    end
  end

  def refresh
    self.contents.clear
    itemnum = $game_variables[96]
    draw_picks($game_party.item_number($data_items[itemnum]), 4, 0,
               contents.width - 8)
  end
end

class Lockpick < Scene_MenuBase
  def self.start(diffi, door_var = nil)
    SceneManager.call(Lockpick)
    SceneManager.scene.prepare(diffi, door_var)
    Fiber.yield
  end

  def prepare(diffi, door_var)
    @diffi = diffi
    @door = $game_variables[door_var] unless door_var.nil?
    @doorvar = door_var
    @door = CP::LOCKPICK::SETTINGS::LOCK_DURABILITY if @door == nil
    if @door == -1
      lock_broke
    end
    @key_rotation = 0
    @pick_rotation = 90
    @zone = rand(90) * 2
    @wobble = 0
    @durability = CP::LOCKPICK::SETTINGS::PICK_DURABILITY
    @did_turn = false
    picksnum = $game_variables[96]
    gpicknum = CP::LOCKPICK::SETTINGS::G_PICK_ITEM
    usegp = CP::LOCKPICK::SETTINGS::USE_G_PICK
    @haspicks = true if $game_party.has_item?($data_items[picksnum])
    @haspicks = true if $game_party.has_item?($data_items[gpicknum]) and usegp
    @haspicks = false if @door == -1
  end

  def start
    super
    @picks_window = Window_Picks.new if CP::LOCKPICK::SETTINGS::SHOW_REMAINING
    @picks_window.z = 4 if @picks_window
    create_lock
    create_key
    create_pick if @haspicks
    key_math
  end

  def terminate
    super
    @lock_sprite.dispose
    @key_sprite.dispose
    @pick_sprite.dispose if @pick_sprite
  end

  def update
    super
    update_pick_command
    update_key_position
    update_pick_position if @haspicks
  end

  def create_lock
    @lock_sprite = Sprite.new
    @lock_sprite.bitmap = Cache.picture(CP::LOCKPICK::LOCK::GRAPHIC)
    @lock_sprite.ox = @lock_sprite.width/2
    @lock_sprite.oy = @lock_sprite.height/2
    @lock_sprite.x = Graphics.width/2 + CP::LOCKPICK::LOCK::X_OFFSET
    @lock_sprite.y = Graphics.height/2 + CP::LOCKPICK::LOCK::Y_OFFSET
    @lock_sprite.z = 1
  end

  def create_key
    @key_sprite = Sprite.new
    @key_sprite.bitmap = Cache.picture(CP::LOCKPICK::KEY::GRAPHIC)
    @key_sprite.ox = @key_sprite.width/2
    @key_sprite.oy = @key_sprite.height/2
    @key_sprite.x = Graphics.width/2 + CP::LOCKPICK::KEY::X_OFFSET
    @key_sprite.y = Graphics.height/2 + CP::LOCKPICK::KEY::Y_OFFSET
    @key_sprite.z = 3
    @k_rotate = @key_rotation
    @key_sprite.angle = @k_rotate * -1
  end

  def update_key_position
    return if @key_rotation == @k_rotate
    @k_rotate = @key_rotation
    @key_sprite.angle = @k_rotate * -1
  end

  def create_pick
    @pick_sprite = Sprite.new
    @pick_sprite.bitmap = Cache.picture(CP::LOCKPICK::PICK::GRAPHIC)
    @pick_sprite.ox = @pick_sprite.width/2
    @pick_sprite.oy = @pick_sprite.width/2
    @pick_sprite.x = Graphics.width/2 + CP::LOCKPICK::PICK::X_OFFSET
    @pick_sprite.y = Graphics.height/2 + CP::LOCKPICK::PICK::Y_OFFSET
    @pick_sprite.z = 2
    @p_rotate = @pick_rotation
    @pick_sprite.angle = @p_rotate - 90
  end

  def update_pick_position
    return if @pick_rotation == @p_rotate and @wobble == @shake
    @p_rotate = @pick_rotation
    @shake = @wobble
    @pick_sprite.angle = @p_rotate - 90 + @shake
  end
 
  def wait(dur)
    for i in 0...dur
      update_basic
    end
  end

  def lock_picked
    variable = CP::LOCKPICK::SETTINGS::VARIABLE
    $game_variables[@doorvar] = @door unless @doorvar == nil
    $game_variables[variable] = 1
    $game_variables[204] += 1
    update_key_position
    wait(20)
    # 오류 메세지 표시 실험 -----------------------
    $game_temp.pop_w(180, 'SYSTEM', "  ¡Has abierto la cerradura!  ")
    # -------------------------------------------
    picking_end
  end

  def lock_stopped
    Sound.play_cancel
    variable = CP::LOCKPICK::SETTINGS::VARIABLE
    $game_variables[@doorvar] = @door unless @doorvar == nil
    $game_variables[variable] = 2
    picking_end
  end

  def no_picks
    variable = CP::LOCKPICK::SETTINGS::VARIABLE
    $game_variables[@doorvar] = @door unless @doorvar == nil
    $game_variables[variable] = 3
    Sound.play_buzzer
    # 오류 메세지 표시 실험 -----------------------
    $game_temp.pop_w(180, 'SYSTEM', "  Ya no tienes el ítem '%s'.  " % [$data_items[$game_variables[96]].name])
    # -------------------------------------------
    picking_end
  end

  def lock_broke
    variable = CP::LOCKPICK::SETTINGS::VARIABLE
    $game_variables[@doorvar] = @door unless @doorvar == nil
    $game_variables[variable] = 4
    Sound.play_buzzer
    # 오류 메세지 표시 실험 -----------------------
    $game_temp.pop_w(180, 'SYSTEM', "  No se abre.  ")
    # -------------------------------------------
    picking_end
  end

  def picking_end
    SceneManager.return
  end

  def update_pick_command
    if Input.trigger?(:B)
      lock_stopped
    elsif Input.trigger?(:C)
      @did_turn = true
      if @haspicks == true && @door == -1
        lock_broke
      elsif @haspicks == true
        lsnd = CP::LOCKPICK::SETTINGS::LOCK_SOUND
        lvol = CP::LOCKPICK::SETTINGS::LOCK_VOLUME
        lpit = CP::LOCKPICK::SETTINGS::LOCK_PITCH
        Audio.se_play("Audio/SE/" + lsnd, lvol, lpit)
      else
        no_picks
      end
    elsif Input.press?(:C) and @did_turn
      unless @key_rotation > @max_turn - 2
        @key_rotation += 2
      else
        # 루나틱 열쇠가 아닌 경우에만 열쇠 내구도 차감
        pick_dura if $game_variables[96] != 55
      end
      if @key_rotation == 90
        lsnd = CP::LOCKPICK::SETTINGS::UNLOCK_SOUND
        lvol = CP::LOCKPICK::SETTINGS::UNLOCK_VOLUME
        lpit = CP::LOCKPICK::SETTINGS::UNLOCK_PITCH
        Audio.se_play("Audio/SE/" + lsnd, lvol, lpit)
        lock_picked
      end
    else
      @wobble = 0 unless @wobble == 0
      @key_rotation -= 2 unless @key_rotation == 0
      @key_rotation = 0 if @key_rotation < 0
      if Input.press?(:RIGHT)
        @pick_rotation += 2 unless @pick_rotation == 180
        key_math
      elsif Input.press?(:LEFT)
        @pick_rotation -= 2 unless @pick_rotation == 0
        key_math
      end
    end
  end

  def key_math
    if ((@zone-4)..(@zone+4)) === @pick_rotation
      @max_turn = 90
    else
      check_spot = @pick_rotation - @zone
      check_spot *= -1 if check_spot < 0
      check_spot -= 4
      check_spot *= @diffi
      @max_turn = 90 - check_spot
      @max_turn = 0 if @max_turn < 0
    end
  end

  def pick_dura
    @wobble = rand(5) - 2
    if @door != nil
      @durability -= @diffi
      snap_pick if @durability < 1 and @durability > -100
    elsif $game_switches[CP::LOCKPICK::SETTINGS::BREAK_PICK_SWITCH]
      gpicknum = CP::LOCKPICK::SETTINGS::G_PICK_ITEM
      usegp = CP::LOCKPICK::SETTINGS::USE_G_PICK
      unless $game_party.has_item?($data_items[gpicknum]) and usegp
        @durability -= @diffi
        snap_pick if @durability < 1
      end
    end
  end

  def snap_pick
    lsnd = CP::LOCKPICK::SETTINGS::BREAK_SOUND
    lvol = CP::LOCKPICK::SETTINGS::BREAK_VOLUME
    lpit = CP::LOCKPICK::SETTINGS::BREAK_PITCH
    Audio.se_play("Audio/SE/" + lsnd, lvol, lpit)
    for i in 0...5
      @pick_sprite.y += 3
      update_basic
    end
    wait(10)
    if @door != nil && @haspicks == true
      @door -= @diffi * 3
      @door = -1 if @door < 1
      $game_variables[@doorvar] = -1 if @door == -1 unless @doorvar == nil
      if @door == -1
        lock_broke
      else
        change_pick
      end
    elsif @door != nil && @haspicks == false
      @door -= @diffi * 3
      @door = -1 if @door < 1
      $game_variables[@doorvar] = -1 if @door == -1 unless @doorvar == nil
      picksnum = $game_variables[96]
      gpicknum = CP::LOCKPICK::SETTINGS::G_PICK_ITEM
      usegp = CP::LOCKPICK::SETTINGS::USE_G_PICK
      return no_picks unless $game_party.has_item?($data_items[picksnum]) ||
      $game_party.has_item?($data_items[gpicknum]) and usegp
    else
      change_pick
    end
  end

  def change_pick
    itemnum = $game_variables[96]
    $game_party.lose_item($data_items[itemnum], 1)
    $game_variables[205] += 1
    @picks_window.refresh if CP::LOCKPICK::SETTINGS::SHOW_REMAINING
    if $game_party.has_item?($data_items[itemnum]) and @door != -1
      new_pick
    elsif !$game_party.has_item?($data_items[itemnum])
      no_picks
    end
  end

  def new_pick
    @key_rotation = 0
    @pick_rotation = 90
    @wobble = 0
    @durability = CP::LOCKPICK::SETTINGS::PICK_DURABILITY
    @pick_sprite.dispose
    create_pick
    update_key_position
    wait(10)
  end
end

module DataManager
  class << self
    alias :cp_lockpick_cgo :create_game_objects
  end

  def self.create_game_objects
    cp_lockpick_cgo
    onoroff = CP::LOCKPICK::SETTINGS::BREAK_PICKS
    $game_switches[CP::LOCKPICK::SETTINGS::BREAK_PICK_SWITCH] = onoroff
  end
end