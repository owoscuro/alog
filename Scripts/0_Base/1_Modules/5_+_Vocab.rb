# encoding: utf-8
# Name: + Vocab
# Size: 3254
module Vocab
  def self.scope(param_id)
    case param_id
      when 0; "Ninguno"
      when 1; "Un enemigo"
      when 2; "Todos los enemigos"
      when 3; "Un enemigo al azar"; when 4; "Dos enemigos al azar"
      when 5; "Tres enemigos al azar"; when 6; "Cuatro enemigos al azar"
      when 7; "Un aliado"
      when 8; "Todos los aliados"
      when 9; "Un aliado (incapacitado)"
      when 10; "Todos los aliados (incapacitados)"
      when 11; "El usuario"
    end
  end

  def self.damage_type(param_id)
    case param_id
      when 1; "Daño a HP"; when 2; "Daño a MP"
      when 3; "Recuperación de HP"; when 4; "Recuperación de MP"
      when 5; "Absorción de HP"; when 6; "Absorción de MP"
    end
  end

  def self.ex_param(param_id)
    case param_id
      when 0; "Precisión"; when 1; "Evasión"; when 2; "Probabilidad de crítico"
      when 3; "Evasión de crítico"
      when 4; "Evasión mágica"
      when 5; "Reflejo mágico"; when 6; "Probabilidad de contraataque"
      when 7; "Tasa de recuperación de HP"; when 8; "Tasa de recuperación de MP"; when 9; "Tasa de recuperación de TP"
    end
  end

  def self.special_param(param_id)
    case param_id
      when 0; "Probabilidad de golpear"; when 1; "Efecto de defensa"; when 2; "Efecto de recuperación"
      when 3; "Efecto de consumo"; when 4; "Tasa de consumo de MP"; when 5; "Tasa de carga de TP"
      when 6; "Daño físico"; when 7; "Daño mágico"
      when 8; "Daño por terreno"; when 9; "Experiencia obtenida"
    end
  end

  def self.special_flag(param_id)
    case param_id
      when 0; "Combate automático"; when 1; "Defensa"
      when 2; "Protección de aliados"; when 3; "Transferencia de TP"
    end
  end
  
  # 적중률
  def self.hit
    return KMS_DistributeParameter::VOCAB_PARAM[:hit]
  end
  # 회피율
  def self.eva
    return KMS_DistributeParameter::VOCAB_PARAM[:eva]
  end
  # 치명타율
  def self.cri
    return KMS_DistributeParameter::VOCAB_PARAM[:cri]
  end
  # 치명타 회피율
  def self.cev
    return KMS_DistributeParameter::VOCAB_PARAM[:cev]
  end
  # 치명타 공격 비율
  def self.atk_lk
    return KMS_DistributeParameter::VOCAB_PARAM[:atk_lk]
  end
  # 착용 무게 제한
  def self.weight_limit
    return KMS_DistributeParameter::VOCAB_PARAM[:weight_limit]
  end
  # 스킬 속도 보정
  def self.skill_speed
    return KMS_DistributeParameter::VOCAB_PARAM[:skill_speed]
  end
  # 이동 속도 보정
  def self.atk_times_add
    return KMS_DistributeParameter::VOCAB_PARAM[:atk_times_add]
  end
  # 마력 친화력
  def self.m_dex
    return KMS_DistributeParameter::VOCAB_PARAM[:m_dex]
  end
  # 아이템 속도 보정
  def self.item_speed
    return KMS_DistributeParameter::VOCAB_PARAM[:item_speed]
  end
  # 노리는 편의성
  def self.tgr
    return KMS_DistributeParameter::VOCAB_PARAM[:tgr]
  end
  # RP
  def self.rp
    return KMS_DistributeParameter::VOCAB_RP
  end
  # RP
  def self.rp_a
    return KMS_DistributeParameter::VOCAB_RP_A
  end
  # 파라미터 분배
  def self.distribute_parameter
    return KMS_DistributeParameter::VOCAB_MENU_DISTRIBUTE_PARAMETER
  end
end