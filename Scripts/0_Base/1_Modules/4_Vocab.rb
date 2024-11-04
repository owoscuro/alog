# encoding: utf-8
# Name: Vocab
# Size: 8217

#==============================================================================
# ■ Vocab
#==============================================================================

module Vocab

  # 숍 화면
  ShopBuy         = "구입"
  ShopSell        = "판매"
  ShopCancel      = "취소"
  Possession      = "소지량"

  # 스테이터스 화면
  ExpTotal        = "현재의 경험치"
  ExpNext         = "다음의 %s까지"

  # 세이브/로드 화면
  SaveMessage     = "어느 파일에 세이브합니까?"
  LoadMessage     = "어느 파일을 로드합니까?"
  File            = "파일"

  # 복수 멤버의 경우의 표시
  PartyName       = "%s & 동료들"

  # 전투 기본 메세지
  Emerge          = "%s가 출현!"
  Preemptive      = "%s은 선수를 취했다!"
  Surprise        = "%s은 기습을 당했다!"
  EscapeStart     = "%s은 도망갔다!"
  EscapeFailure   = "그러나 도망칠 수 없었다!"

  # 전투 종료 메세지
  Victory         = "승리!"
  Defeat          = "싸움에 졌다."
  ObtainExp       = "%s 의 경험치를 획득!"
  ObtainGold      = "돈 %s\\G를 손에 넣었다!"
  ObtainItem      = "%s를 손에 넣었다!"
  LevelUp         = "%s은(는) %s %s 에 올랐다!"
  ObtainSkill     = "%s를 기억했다!"

  # 아이템 사용
  UseItem         = "%s은(는) %s을(를) 사용했다."

  # 위기 히트
  CriticalToEnemy = "회심의 일격!"
  CriticalToActor = "통한의 일격!"

  # 액터 대상의 행동 결과
  ActorDamage     = "%s은(는) %s의 대미지를 받았다!"
  ActorRecovery   = "%s의 %s가 %s 회복했다!"
  ActorGain       = "%s의 %s가 %s 증가했다!"
  ActorLoss       = "%s의 %s가 %s 줄어 들었다!"
  ActorDrain      = "%s은(는) %s를 %s 빼앗겼다!"
  ActorNoDamage   = "%s은(는) 대미지를 받지 않았다!"
  ActorNoHit      = "%s는 대미지를 받지 않았다!"

  # 적캐릭터 대상의 행동 결과
  EnemyDamage     = "%s에 %s의 대미지를 주었다!"
  EnemyRecovery   = "%s의 %s가 %s 회복했다!"
  EnemyGain       = "%s의 %s가 %s 증가했다!"
  EnemyLoss       = "%s의 %s가 %s 줄어 들었다!"
  EnemyDrain      = "%s의 %s를 %s 빼앗았다!"
  EnemyNoDamage   = "%s에 대미지가 주어지지 않는다!"
  EnemyNoHit      = "%s에 대미지가 주어지지 않는다!"

  # 회피/반사
  Evasion         = "%s은(는) 공격을 주고 받았다!"
  MagicEvasion    = "%s은(는) 마법을 지웠다!"
  MagicReflection = "%s은(는) 마법을 뒤집었다!"
  CounterAttack   = "%s의 반격!"
  Substitute      = "%s가 %s를 감쌌다!"

  # 능력 강화/약체
  BuffAdd         = "%s의 %s가 올랐다!"
  DebuffAdd       = "%s의 %s가 내렸다!"
  BuffRemove      = "%s의 %s가 원래대로 돌아갔다!"

  # 스킬, 아이템의 효과가 없었다
  ActionFailure   = "%s에는 효과가 없었다!"

  # 에러 메세지
  PlayerPosError  = "플레이어의 초기 위치가 설정되어 있지 않습니다."
  EventOverflow   = "코먼 이벤트의 호출이 상한을 넘었습니다."

  # 基本ステータス
  def self.basic(basic_id)
    $data_system.terms.basic[basic_id]
  end

  # 能力値
  def self.param(param_id)
    $data_system.terms.params[param_id]
  end

  # 装備タイプ
  def self.etype(etype_id)
    $data_system.terms.etypes[etype_id]
  end
  
  # コマンド
  def self.command(command_id)
    $data_system.terms.commands[command_id]
  end

  # 通貨単位
  def self.currency_unit
    $data_system.currency_unit
  end

  #--------------------------------------------------------------------------
#~   def self.level;       basic(0);     end   # レベル
#~   def self.level_a;     basic(1);     end   # レベル (短)
#~   def self.hp;          basic(2);     end   # HP
#~   def self.hp_a;        basic(3);     end   # HP (短)
#~   def self.mp;          basic(4);     end   # MP
#~   def self.mp_a;        basic(5);     end   # MP (短)
#~   def self.tp;          basic(6);     end   # TP
#~   def self.tp_a;        basic(7);     end   # TP (短)
#~   def self.fight;       command(0);   end   # 戦う
#~   def self.escape;      command(1);   end   # 逃げる
#~   def self.attack;      command(2);   end   # 攻撃
#~   def self.guard;       command(3);   end   # 防御
#~   def self.item;        command(4);   end   # アイテム
#~   def self.skill;       command(5);   end   # スキル
#~   def self.equip;       command(6);   end   # 装備
#~   def self.status;      command(7);   end   # ステータス
#~   def self.formation;   command(8);   end   # 並び替え
#~   def self.save;        command(9);   end   # セーブ
#~   def self.game_end;    command(10);  end   # ゲーム終了
#~   def self.weapon;      command(12);  end   # 武器
#~   def self.armor;       command(13);  end   # 防具
#~   def self.key_item;    command(14);  end   # 大事なもの
#~   def self.equip2;      command(15);  end   # 装備変更
#~   def self.optimize;    command(16);  end   # 최강 장비
#~   def self.clear;       command(17);  end   # 全て外す
#~   def self.new_game;    command(18);  end   # ニューゲーム
#~   def self.continue;    command(19);  end   # コンティニュー
#~   def self.shutdown;    command(20);  end   # シャットダウン
#~   def self.to_title;    command(21);  end   # タイトルへ
#~   def self.cancel;      command(22);  end   # やめる
  def self.level;       Lang::TEXTS[:interface][:vocab][:level];     end   # Level
  def self.level_a;     Lang::TEXTS[:interface][:vocab][:level_a];     end   # Level (short)
  def self.hp;          Lang::TEXTS[:interface][:vocab][:hp];     end   # HP
  def self.hp_a;        Lang::TEXTS[:interface][:vocab][:hp_a];     end   # HP (short)
  def self.mp;          Lang::TEXTS[:interface][:vocab][:mp];     end   # MP
  def self.mp_a;        Lang::TEXTS[:interface][:vocab][:mp_a];     end   # MP (short)
  def self.tp;          Lang::TEXTS[:interface][:vocab][:tp];     end   # TP
  def self.tp_a;        Lang::TEXTS[:interface][:vocab][:tp_a];     end   # TP (short)
  def self.fight;       Lang::TEXTS[:interface][:vocab][:fight];   end   # Fight
  def self.escape;      Lang::TEXTS[:interface][:vocab][:escape];   end   # Escape
  def self.attack;      Lang::TEXTS[:interface][:vocab][:attack];   end   # Attack
  def self.guard;       Lang::TEXTS[:interface][:vocab][:guard];   end   # Guard
  def self.item;        Lang::TEXTS[:interface][:vocab][:item];   end   # Item
  def self.skill;       Lang::TEXTS[:interface][:vocab][:skill];   end   # Skill
  def self.equip;       Lang::TEXTS[:interface][:vocab][:equip];   end   # Equip
  def self.status;      Lang::TEXTS[:interface][:vocab][:status];   end   # Status
  def self.formation;   Lang::TEXTS[:interface][:vocab][:formation];   end   # Formation
  def self.save;        Lang::TEXTS[:interface][:vocab][:save];   end   # Save
  def self.game_end;    Lang::TEXTS[:interface][:vocab][:game_end];  end   # Game End
  def self.weapon;      Lang::TEXTS[:interface][:vocab][:weapon];  end   # Weapon
  def self.armor;       Lang::TEXTS[:interface][:vocab][:armor];  end   # Armor
  def self.key_item;    Lang::TEXTS[:interface][:vocab][:key_item];  end   # Key Item
  def self.equip2;      Lang::TEXTS[:interface][:vocab][:equip2];  end   # Equip Change
  def self.optimize;    Lang::TEXTS[:interface][:vocab][:optimize];  end   # Optimize
  def self.clear;       Lang::TEXTS[:interface][:vocab][:clear];  end   # Clear
  def self.new_game;    Lang::TEXTS[:interface][:vocab][:new_game];  end   # New Game
  def self.continue;    Lang::TEXTS[:interface][:vocab][:continue];  end   # Continue
  def self.shutdown;    Lang::TEXTS[:interface][:vocab][:shutdown];  end   # Shutdown
  def self.to_title;    Lang::TEXTS[:interface][:vocab][:to_title];  end   # To Title
  def self.cancel;      Lang::TEXTS[:interface][:vocab][:cancel];  end   # Cancel

  #--------------------------------------------------------------------------
end