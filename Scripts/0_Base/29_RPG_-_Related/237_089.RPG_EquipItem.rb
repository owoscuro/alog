# encoding: utf-8
# Name: 089.RPG_EquipItem
# Size: 2416
class RPG::Item < RPG::UsableItem
  def item?
    return true
  end 
  
  def skill?
    return false
  end
  
  def type_set
    [itype_id]
  end
  
  def weight
    @note =~ /<무게 (\d+)>/i ? $1.to_i : CRYSTAL::EQUIP::DEFAULT_WEIGHT
  end
end

class RPG::EquipItem < RPG::BaseItem
  def weight
    @note =~ /<무게 (\d+)>/i ? $1.to_i : CRYSTAL::EQUIP::DEFAULT_WEIGHT
  end
  
  def equip_number
    @note =~ /<번호\s+(.+)>/ ? $1 : nil
  end
  
  def equip_temper
    @note =~ /<방한력\s+(.+)>/ ? $1.to_i : 0
  end
  
  def equip_sexy
    @note =~ /<노출도 (\d+)>/i ? $1.to_i : 0
  end
  
  def bg_equip_sexy
    @note =~ /<성인용품 (\d+)>/i ? $1.to_i : 0
  end
end

class RPG::BGM < RPG::AudioFile
  def play(pos = 0)
    if @name.empty?
      Audio.bgm_stop
      @@last = RPG::BGM.new
    else
      volume = @volume
      volume *= $game_system.volume(:bgm) * 0.01 unless $game_system.nil?
      
      # 외부, 날씨가 안좋으면 배경음 볼륨 감소
      if $game_variables[12] != 0 and $game_switches[94] == true
        Audio.bgm_play('Audio/BGM/' + @name, volume - 30, @pitch, pos)
      else
        Audio.bgm_play('Audio/BGM/' + @name, volume, @pitch, pos)
      end
      
      @@last = self.clone
    end
  end
end

class RPG::ME < RPG::AudioFile
  def play
    if @name.empty?
      Audio.me_stop
    else
      volume = @volume
      volume *= $game_system.volume(:bgm) * 0.01 unless $game_system.nil?
      Audio.me_play('Audio/ME/' + @name, volume, @pitch)
    end
  end
end

class RPG::BGS < RPG::AudioFile
  def play(pos = 0)
    if @name.empty?
      Audio.bgs_stop
      @@last = RPG::BGS.new
    else
      volume = @volume
      volume *= $game_system.volume(:bgs) * 0.01 unless $game_system.nil?
      # 내부, 날씨가 안좋으면 배경음 볼륨 감소
      if $game_variables[12] != 0 and $game_switches[86] == true
        Audio.bgs_play('Audio/BGS/' + @name, volume - 30, @pitch, pos)
      else
        Audio.bgs_play('Audio/BGS/' + @name, volume, @pitch, pos)
      end
      @@last = self.clone
    end
  end
end

class RPG::SE < RPG::AudioFile
  def play
    unless @name.empty?
      volume = @volume
      volume *= $game_system.volume(:sfx) * 0.01 unless $game_system.nil?
      Audio.se_play('Audio/SE/' + @name, volume, @pitch)
    end
  end
end