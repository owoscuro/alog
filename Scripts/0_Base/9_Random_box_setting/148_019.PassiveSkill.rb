# encoding: utf-8
# Name: 019.PassiveSkill
# Size: 3484
# encoding: utf-8
# Name: 019.PassiveSkill
# Size: 3314
class RPG::Skill
  def weapon_durability_cost
    @note =~ /<durability[-_ ]?cost:\s*(.*)\s*>/i ? @durability_cost = $1.to_i : @durability_cost = TH_Instance::Weapon::Default_Durability_Cost if @durability_cost.nil?
    @durability_cost
  end
  
  def armor_durability_damage
    @note =~ /<durability[-_ ]?damage:\s*(.*)\s*>/i ? @durability_damage = $1.to_i : @durability_damage = TH_Instance::Armor::Default_Durability_Damage if @durability_damage.nil?
    @durability_damage
  end
end

module NOTES 
  def field(note)
    notes = ''+note
    eval("{#{notes.split(/[,]*[\r\n]+/).delete_if{|line|(line =~ /^:.*=>.*/).nil?}.join(',')}}")
  end
end

BATTLE_IGNORE = ['Passive']
$imported = {} if $imported == nil
$imported["Passive Skills"] = true

class RPG::Skill < RPG::UsableItem
  include NOTES
  def passive?
    return note_field.include?(:passive)
  end  
end

module PassiveSkill
  # Lista de parámetros para habilidades pasivas
  PARAMS = {
    :mhp => "MHP|Máximo HP",
    :mmp => "MMP|Máximo MP",
    :atk => "ATK|Ataque",
    :def => "DEF|Defensa",
    :mat => "MAT|Poder Mágico",
    :mdf => "MDF|Defensa Mágica",
    :agi => "AGI|Agilidad",
    :luk => "LUK|Suerte",
  }
  
  XPARAMS = {
    :hit => "HIT|Precisión",
    :eva => "EVA|Evasión",
    :cri => "CRI|Tasa de Crítico",
    :cev => "CEV|Evasión de Crítico",
    :mev => "MEV|Evasión Mágica",
    :mrf => "MRF|Reflejo Mágico",
    :cnt => "CNT|Tasa de Contraataque",
    :hrg => "HRG|Regeneración de HP",
    :mrg => "MRG|Regeneración de MP",
    :trg => "TRG|Regeneración de TP",
  }
  
  SPARAMS = {
    :tgr => "TGR|Tasa de Objetivo",
    :grd => "GRD|Efecto de Guardia",
    :rec => "REC|Efecto de Recuperación",
    :pha => "PHA|Conocimiento de Poción",
    :mcr => "MCR|Coste de MP",
    :tcr => "TCR|Coste de TP",
    :pdr => "PDR|Daño Físico",
    :mdr => "MDR|Daño Mágico",
    :fdr => "FDR|Daño de Trampa",
    :exr => "EXR|Ganancia de Experiencia",
  }
  
  RESIST = {
    :elre => "ELRE|Resistencia a Elementos",
    :bfre => "BFRE|Resistencia a Debuffs",
    :stre => "STRE|Resistencia a Estados",
    :stno => "STNO|Inmunidad a Estados",
    :atel => "ATEL|Elemento de Ataque",
    :atst => "ATST|Estado de Ataque",
    :atsp => "ATSP|Velocidad de Ataque",
    :atnu => "ATNU|Número de Ataques",
  }
  
  OPTION = {
    :skty => "SKTY|Tipo de Habilidad",  
    :skts => "SKTS|Sellar Tipo de Habilidad",
    :skpl => "SKPL|Habilidad Adicional",
    :skse => "SKSE|Sellar Habilidad",
    :wety => "WETY|Tipo de Arma", 
    :arty => "ARTY|Tipo de Armadura",
    :eqfx => "EQFX|Equipamiento Fijo",
    :eqse => "EQSE|Sellar Equipamiento",
    :dbwp => "DBWP|Doble Empuñadura",
    :wpm  => "WPM|Maestría en Armas",
    :arm  => "ARM|Maestría en Armaduras",
  }
  
  # 정규 표현
  module Regexp
    # 스킬
    module Skill
      # 패시브 스킬 개시
      BEGIN_PASSIVE = /<(?:PASSIVE|패시브)>/i
      # 패시브 스킬 종료
      END_PASSIVE = /<\/(?:PASSIVE|패시브)>/i

      # 파라미터 수정 'Str +Dec' + '%' 형태, exa) MHP +20% 등
      PASSIVE_PARAMS = /^\s*([^:\+\-\d\s]+)\s*([\+\-]\d+)([%%])?\s*$/
      # 내성/공격 수정 'Str Dec +Dec'   형태, exa) ELRE 1 +20
      PASSIVE_RESIST = /^\s*([^:\+\-\d\s]+)\s*(\d+)\s*([\+\-]\d+)\s*$/
      # 스킬/장비/그외 수정 'Str +Dec' 형태, exa) SKPL 20 등
      PASSIVE_OPTION = /^\s*([^:\+\-\d\s]+)\s*(\d+)\s*$/
    end
  end
end