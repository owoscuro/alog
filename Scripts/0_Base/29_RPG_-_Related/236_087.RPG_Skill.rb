# encoding: utf-8
# Name: 087.RPG_Skill
# Size: 16388
class RPG::Skill < RPG::UsableItem
  def item?
    return false
  end
  
  def skill?
    return true
  end
  
  def type_set
    [stype_id]
  end
  
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 캐쉬를 생성
  #--------------------------------------------------------------------------
  def create_passive_skill_cache
    @_passive = false
    @_passive_params = {}
    @_passive_params_rate = {}
    @_passive_xparams = {}
    @_passive_sparams = {}
    @_passive_elre = {}
    @_passive_bfre = {}
    @_passive_stre = {}
    @_passive_stno = {}
    @_passive_atel = {}
    @_passive_atst = {}
    @_passive_atsp = 0
    @_passive_atnu = 0
    @_passive_skty = {}
    @_passive_skts = {}
    @_passive_skpl = {}
    @_passive_skse = {}
    @_passive_wety = {}
    @_passive_arty = {}
    @_passive_eqfx = {}
    @_passive_eqse = {}
    @_passive_dbwp = 0
    @_passive_wpm = false
    @_passive_wpm_set = {}
    @_passive_arm = false
    @_passive_arm_set = {}
    set_up_cache
  end
  
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 캐쉬를 셋팅
  #--------------------------------------------------------------------------
  def set_up_cache
    passive_flag = false
    self.note.each_line { |line|
      case line
      when PassiveSkill::Regexp::Skill::BEGIN_PASSIVE
        # 패시브 스킬 정의 개시
        passive_flag = true
        @_passive = true
      when PassiveSkill::Regexp::Skill::END_PASSIVE
        # 패시브 스킬 정의 종료
        passive_flag = false
      when PassiveSkill::Regexp::Skill::PASSIVE_PARAMS
        # param 수정
        if passive_flag
          apply_passive_params($1, $2.to_i, $3 != nil)
          apply_passive_xparams($1, $2.to_i, $3 != nil)
          apply_passive_sparams($1, $2.to_i, $3 != nil)
        end
      when PassiveSkill::Regexp::Skill::PASSIVE_RESIST
        # 내성 수정
        if passive_flag
          apply_passive_resist($1, $2.to_i, $3.to_i)
        end
      when PassiveSkill::Regexp::Skill::PASSIVE_OPTION
        if passive_flag
          apply_passive_option($1, $2.to_i)
        end
      else
        break
      end
    }
  end
  
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 param 수정을 적용
  #     param : 대상 파라미터
  #     value : 수정치
  #     rate  : true (이)라면 % 지정
  #--------------------------------------------------------------------------
  def apply_passive_params(param, value, rate)
    PassiveSkill::PARAMS.each { |k, v|
      if param =~ /(?:#{v})/i
        if rate
          @_passive_params_rate[k] = 0 if @_passive_params_rate[k] == nil
          @_passive_params_rate[k] += value
        else
          @_passive_params[k] = 0 if @_passive_params[k] == nil
          @_passive_params[k] += value
        end
        break
      end
    }
  end
  
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 xparam 수정을 적용
  #     param : 대상 파라미터
  #     value : 수정치
  #     rate  : true (이)라면 % 지정
  #--------------------------------------------------------------------------
  def apply_passive_xparams(param, value, rate)
    PassiveSkill::XPARAMS.each { |k, v|
      if param =~ /(?:#{v})/i
        @_passive_xparams[k] = 0 if @_passive_xparams[k] == nil
        @_passive_xparams[k] += value
        break
      end
    }
  end
  
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 sparam 수정을 적용
  #     param : 대상 파라미터
  #     value : 수정치
  #     rate  : true (이)라면 % 지정
  #--------------------------------------------------------------------------
  def apply_passive_sparams(param, value, rate)
    PassiveSkill::SPARAMS.each { |k, v|
      if param =~ /(?:#{v})/i
        @_passive_sparams[k] = 0 if @_passive_sparams[k] == nil
        @_passive_sparams[k] += value
        break
      end
    }
  end
  
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 내성 수정을 적용
  #     resist : 대상 내성
  #     obj    : 목표 id exa) :elre 속성id, :bfre param_id, 
  #     value  : 수정치       :stre, :stno 상태id
  #     :atel 속성id , :atst 상태id :atsp 공격속도 :atnu 공격횟수
  #--------------------------------------------------------------------------
  def apply_passive_resist(resist, obj, value)
    PassiveSkill::RESIST.each { |k, v|
      if resist =~ /(?:#{v})/i
        case k
        when :elre
          @_passive_elre[obj] = 0 if @_passive_elre[obj] == nil
          @_passive_elre[obj] += value
        when :bfre
          @_passive_bfre[obj] = 0 if @_passive_bfre[obj] == nil
          @_passive_bfre[obj] += value
        when :stre
          @_passive_stre[obj] = 0 if @_passive_stre[obj] == nil
          @_passive_stre[obj] += value
        when :stno
          @_passive_stno[obj] = 0 if @_passive_stno[obj] == nil
          @_passive_stno[obj] += 1
        when :atel
          @_passive_atel[obj] = 0 if @_passive_atel[obj] == nil
          @_passive_atel[obj] += 1
        when :atst
          @_passive_atst[obj] = 0 if @_passive_atst[obj] == nil
          @_passive_atst[obj] += value
        when :atsp
          @_passive_atsp = 0 if @_passive_atsp == nil
          @_passive_atsp += value
        when :atnu
          @_passive_atnu = 0 if @_passive_atnu == nil
          @_passive_atnu += value
        end
        break
      end
    }
  end
  
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 스킬옵션 수정을 적용
  #     aim : 대상 문구     :skty 스킬타입 :skts 스킬타입봉인
  #     value  : 수정치     :skpl 스킬추가 :skse 스킬봉인    
  #    :wety 무기타입 :arty 방어구타입   :eqfx 장비고정   :eqse 장비봉인
  #    :dbwp 이도류   :copl 행동추가확률 :spfl 특수플래그 :paab 파티능력
  #    :wpm 웨폰마스터리    :arm 아머마스터리
  #--------------------------------------------------------------------------
  def apply_passive_option(aim, value)
    PassiveSkill::OPTION.each { |k, v|
      if aim =~ /(?:#{v})/i
        case k
        when :skty
          @_passive_skty[value] = 0 if @_passive_skty[value] == nil
          @_passive_skty[value] += 1
        when :skts
          @_passive_skts[value] = 0 if @_passive_skty[value] == nil
          @_passive_skts[value] += 1
        when :skpl
          @_passive_skpl[value] = 0 if @_passive_skpl[value] == nil
          @_passive_skpl[value] += 1
        when :skse
          @_passive_skse[value] = 0 if @_passive_skse[value] == nil
          @_passive_skse[value] += 1
        when :wety
          @_passive_wety[value] = 0 if @_passive_wety[value] == nil
          @_passive_wety[value] += 1
        when :arty
          @_passive_arty[value] = 0 if @_passive_arty[value] == nil
          @_passive_arty[value] += 1
        when :eqfx
          @_passive_eqfx[value] = 0 if @_passive_eqfx[value] == nil
          @_passive_eqfx[value] += 1
        when :eqse
          @_passive_eqse[value] = 0 if @_passive_eqse[value] == nil
          @_passive_eqse[value] += 1
        when :dbwp
          @_passive_dbwp = 0 if @_passive_dbwp == nil
          @_passive_dbwp += 1
        when :wpm
          @_passive_wpm_set[value] = 0 if @_passive_wpm_set[value] == nil
          @_passive_wpm_set[value] += 1
          @_passive_wpm = true
        when :arm
          @_passive_arm_set[value] = 0 if @_passive_arm_set[value] == nil
          @_passive_arm_set[value] += 1
          @_passive_arm = true
        end
        break
      end
    }
  end
  
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬일까
  #--------------------------------------------------------------------------
  def passive
    create_passive_skill_cache if @_passive == nil
    return @_passive
  end
  
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 param 수정 (즉치)
  #--------------------------------------------------------------------------
  def passive_params
    create_passive_skill_cache if @_passive_params == nil
    return @_passive_params
  end
  
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 param 수정 (비율)
  #--------------------------------------------------------------------------
  def passive_params_rate
    create_passive_skill_cache if @_passive_params_rate == nil
    return @_passive_params_rate
  end
  
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 xparam 수정
  #--------------------------------------------------------------------------
  def passive_xparams
    create_passive_skill_cache if @_passive_xparams == nil
    return @_passive_xparams
  end
  
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 sparam 수정 
  #--------------------------------------------------------------------------
  def passive_sparams
    create_passive_skill_cache if @_passive_sparams == nil
    return @_passive_sparams
  end
  
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 속성내성
  #--------------------------------------------------------------------------
  def passive_elre
    create_passive_skill_cache if @_passive_elre == nil
    return @_passive_elre
  end
  
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 약화내성
  #--------------------------------------------------------------------------
  def passive_bfre
    create_passive_skill_cache if @_passive_bfre == nil
    return @_passive_bfre
  end
  
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 상태내성
  #--------------------------------------------------------------------------
  def passive_stre
    create_passive_skill_cache if @_passive_stre == nil
    return @_passive_stre
  end
  
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 상태무효
  #--------------------------------------------------------------------------
  def passive_stno
    create_passive_skill_cache if @_passive_stno == nil
    return @_passive_stno
  end
  
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 공격속성
  #--------------------------------------------------------------------------
  def passive_atel
    create_passive_skill_cache if @_passive_atel == nil
    return @_passive_atel
  end
  
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 공격상태
  #--------------------------------------------------------------------------
  def passive_atst
    create_passive_skill_cache if @_passive_atst == nil
    return @_passive_atst
  end
  
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 공격속도
  #--------------------------------------------------------------------------
  def passive_atsp
    create_passive_skill_cache if @_passive_atsp == nil
    return @_passive_atsp
  end
  
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 공격횟수
  #--------------------------------------------------------------------------
  def passive_atnu
    create_passive_skill_cache if @_passive_atnu == nil
    return @_passive_atnu
  end
  
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 스킬타입 추가
  #--------------------------------------------------------------------------
  def passive_skty
    create_passive_skill_cache if @_passive_skty == nil
    return @_passive_skty
  end
  
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 스킬타입 봉인
  #--------------------------------------------------------------------------
  def passive_skts
    create_passive_skill_cache if @_passive_skts == nil
    return @_passive_skts
  end
  
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 스킬추가
  #--------------------------------------------------------------------------
  def passive_skpl
    create_passive_skill_cache if @_passive_skpl == nil
    return @_passive_skpl
  end
  
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 스킬봉인
  #--------------------------------------------------------------------------
  def passive_skse
    create_passive_skill_cache if @_passive_skse == nil
    return @_passive_skse
  end
  
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 무기타입
  #--------------------------------------------------------------------------
  def passive_wety
    create_passive_skill_cache if @_passive_wety == nil
    return @_passive_wety
  end
  
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 방어구타입
  #--------------------------------------------------------------------------
  def passive_arty 
    create_passive_skill_cache if @_passive_arty == nil
    return @_passive_arty 
  end
  
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 장비고정
  #--------------------------------------------------------------------------
  def passive_eqfx
    create_passive_skill_cache if @_passive_eqfx == nil
    return @_passive_eqfx
  end
  
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 장비봉인
  #--------------------------------------------------------------------------
  def passive_eqse
    create_passive_skill_cache if @_passive_eqse == nil
    return @_passive_eqse
  end
  
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 이도류
  #--------------------------------------------------------------------------
  def passive_dbwp
    create_passive_skill_cache if @_passive_dbwp == nil
    return @_passive_dbwp
  end
  
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 웨폰마스터리
  #--------------------------------------------------------------------------
  def passive_wpm
    create_passive_skill_cache if @_passive_wpm == nil
    return @_passive_wpm
  end
  
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 아머마스터리
  #--------------------------------------------------------------------------
  def passive_arm
    create_passive_skill_cache if @_passive_arm == nil
    return @_passive_arm
  end
  
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 웨폰마스터리
  #--------------------------------------------------------------------------
  def passive_wpm_set
    create_passive_skill_cache if @_passive_wpm_set == nil
    return @_passive_wpm_set
  end
  
  #--------------------------------------------------------------------------
  # ○ 패시브 스킬의 아머마스터리
  #--------------------------------------------------------------------------
  def passive_arm_set
    create_passive_skill_cache if @_passive_arm_set == nil
    return @_passive_arm_set
  end
end