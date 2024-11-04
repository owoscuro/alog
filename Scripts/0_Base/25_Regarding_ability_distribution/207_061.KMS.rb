# encoding: utf-8
# Name: 061.KMS
# Size: 7545
# encoding: utf-8
# Name: 061.KMS
# Size: 8517
module KMS_DistributeParameter
  
  #-----------------------------------------------------------------------------
  # ◆ 파라미터 배분
  # :key => 키,
  # :name => "이름",
  # :limit => 횟수 상한,
  # :cost => [소비 RP, 소비 RP 보정],
  # :파라미터 => [상승량, 상승량 보정],
  #-----------------------------------------------------------------------------
  
  GAIN_PARAMETER = [
    {
      :key => :health, :name => Lang::TEXTS[:interface][:gain_parameter][0], :limit => 0,
      :cost => [1, 0.4],
      :mhp => [130, 20],
      :def => [1],
    },
    {
      :key => :magic, :name => Lang::TEXTS[:interface][:gain_parameter][1], :limit => 0,
      :cost => [1, 0.4],
      :mmp => [5, 1],
      :mat => [2],
    },
    {
      :key => :pow, :name => Lang::TEXTS[:interface][:gain_parameter][2], :limit => 0,
      :cost => [1, 0.4],
      :atk => [2],
      :def => [1],
      :weight_limit => [0.3],
    },
    {
      :key => :dex, :name => Lang::TEXTS[:interface][:gain_parameter][3], :limit => 0,
      :cost => [1, 0.4],
      :agi => [2],
      :hit => [0.005],
      :eva => [0.005],
      :atk_times_add => [0.001],
    },
    {
      :key => :luk, :name => Lang::TEXTS[:interface][:gain_parameter][4], :limit => 0,
      :cost => [1, 0.5],
      :luk => [1],
      :atk_lk => [0.001],
    },
    {
      :key => :hit, :name => Lang::TEXTS[:interface][:gain_parameter][5], :limit => 0,
      :cost => [1, 0.5],
      :hit => [0.01],
    },
    {
      :key => :eva, :name => Lang::TEXTS[:interface][:gain_parameter][6], :limit => 0,
      :cost => [1, 0.5],
      :eva => [0.01],
    },
    {
      :key => :crt, :name => Lang::TEXTS[:interface][:gain_parameter][7], :limit => 0,
      :cost => [1, 0.7],
      :cri => [0.01],
    },
    {
      :key => :cev, :name => Lang::TEXTS[:interface][:gain_parameter][8], :limit => 0,
      :cost => [1, 0.5],
      :cev => [0.01],
    },
    {
      :key => :exr, :name => Lang::TEXTS[:interface][:gain_parameter][9], :limit => 0,
      :cost => [1, 0.5],
      :exr => [0.01],
      :cri => [0.002],
      :cev => [0.001],
      :atk_lk => [0.001],
    },
    {
      :key => :atk_times_add, :name => Lang::TEXTS[:interface][:gain_parameter][10], :limit => 0,
      :cost => [5, 3],
      :atk_times_add => [0.1],
      :pha => [0.003],
    },
    {
      :key => :m_dex, :name => Lang::TEXTS[:interface][:gain_parameter][11], :limit => 0,
      :cost => [3, 2],
      :mdf => [1],
      :pha => [0.01],
    },
    {
      :key => :tgr, :name => Lang::TEXTS[:interface][:gain_parameter][12], :limit => 0,
      :cost => [1],
      :tgr => [0.1],
    }
  ]
  # ◆ 액터별 파라미터 증가량
  PERSONAL_GAIN_PARAMETER = []
  # 액터 1의 "체력" 을 개별적으로 지정.
=begin
  PERSONAL_GAIN_PARAMETER[1] = [
    {
      :key => :health,
      :name => "체력",
      :limit => 0,
      :cost => [ 1, 0.4],
      :mhp => [50, 3],
      :def => [ 1, 0.3],
    },
  ]
=end

	CLASS_GAIN_PARAMETER = []
  VOCAB_RP   = Lang::TEXTS[:interface][:vocab_rp]
  VOCAB_RP_A = Lang::TEXTS[:interface][:vocab_rp_a]


	MAXRP_EXP = "(level ** 0.25 + 2.0) * level"

	VOCAB_PARAM = Lang::TEXTS[:interface][:vocab_param]
  # ◆ 분배 횟수
  # true : 횟수 표시
  # false : --- 표시
  HIDE_MAX_COUNT_INFINITE  = true

  # ◆ 배분 게이지 색상
  GAUGE_START_COLOR = 28
  GAUGE_END_COLOR   = 29

  # ◆ 분배 게이지에 범용 게이지 사용
  ENABLE_GENERIC_GAUGE = false
  
  # ◆ 배분 범용 게이지 설정
  # 이미지는 "Graphics/System" 에서 읽습니다.
  GAUGE_IMAGE  = "GaugeDist"
  GAUGE_OFFSET = [-23, -2]
  GAUGE_LENGTH = -4
  GAUGE_SLOPE  = 30

	CONFIRM_COMMANDS = Lang::TEXTS[:interface][:confirm_commands]
	CONFIRM_COMMAND_HELP = Lang::TEXTS[:interface][:confirm_command_help]
  
  
  # ◆ 배분 종료시의 확인 커맨드의 폭
  CONFIRM_WIDTH = 330

  # ◆ 메뉴 화면에 '파라미터 배분' 명령 추가
  USE_MENU_DISTRIBUTE_PARAMETER_COMMAND = true
  
  # ◆ 메뉴 화면의 「파라미터 분배」명령의 명칭
#~   VOCAB_MENU_DISTRIBUTE_PARAMETER = "Pts Nivel"
  VOCAB_MENU_DISTRIBUTE_PARAMETER = Lang::TEXTS[:interface][:vocab_menu_distribute_parameter]

  # ◆ 배분 해제 허용
  # true : 분배 확정 후에도 파라미터를 내리고 RP를 되찾을 수 있다.
  # false : 한 번 확정하면 낮출 수 없다.
  ENABLE_REVERSE_DISTRIBUTE = false
end

$kms_imported = {} if $kms_imported == nil
$kms_imported["DistributeParameter"] = true

module KMS_DistributeParameter
  # 배분 대상 파라미터
  #PARAMS = [:mhp, :mmp, :atk, :def, :mat, :mdf, :agi, :luk,
  #  :hit, :eva, :cri, :skill_speed, :item_speed, :tgr]
  #PARAMS |= [:hit, :eva, :cri, :cev, :mev, :mrf, :cnt, :hrg, :mrg, :trg]
  #PARAMS |= [:tgr, :grd, :rec, :pha, :mcr, :tcr, :pdr, :mdr, :fdr, :exr]
  PARAMS = [ :mhp, :mmp, :atk, :mat, :def, :mdf, :agi, :luk,
              :hit, :eva, :cri, :cev, :mev, :hrg, :mrg, :mrf,
              :grd, :rec, :pha, :mcr, :tcr, :trg, :tgr, :pdr, :mdr, :atk_lk, :weight_limit, :exr, 
              :el_3, :el_4, :el_5, :el_6, :el_7, :el_8, :el_9, :el_10, :el_12,
              :atk_times_add, :aps
              ]
                    
  # 파라미터 증가량 구조체
  GainInfo  = Struct.new(:key, :name, :limit, :cost, :cost_rev, :params)
  ParamInfo = Struct.new(:value, :value_rev)

  # 분류 정보 구조
  DistInfo = Struct.new(:count, :hp, :mp)

  #--------------------------------------------------------------------------
  # ○ 파라미터 증가량을 구조화
  #--------------------------------------------------------------------------
  def self.create_gain_param_structs(target)
    result = []
    target.each { |v|
      info = GainInfo.new
      info.key      = v[:key]
      info.name     = v[:name]
      info.limit    = v[:limit]
      info.cost     = v[:cost][0]
      info.cost_rev = (v[:cost][1] == nil ? 0 : v[:cost][1])
      info.params   = {}

      PARAMS.each { |param|
        next unless v.has_key?(param)
        pinfo = ParamInfo.new
        pinfo.value     = v[param][0]
        pinfo.value_rev = (v[param][1] == nil ? 0 : v[param][1])
        info.params[param] = pinfo
      }
      result << info
    }
    return result
  end
  
  #--------------------------------------------------------------------------
  # ○ 파라미터 증가량을 구조화(고유 증가량용)
  #--------------------------------------------------------------------------
  def self.create_gain_param_structs_for_personal(target)
    result = []
    target.each { |list|
      next if list == nil
      result << create_gain_param_structs(list)
    }
    return result
  end
  
  #--------------------------------------------------------------------------
  # ○ 파라미터 증가량을 병합
  #--------------------------------------------------------------------------
  def self.merge(list1, list2)
    result = list1.clone
    list2.each { |info2|
      overwrite = false
      list1.each_with_index { |info1, i|
        if info1.key == info2.key
          result[i] = info2
          overwrite = true
          break
        end
      }
      result << info2 unless overwrite
    }
    return result
  end

  # 파라미터 증가량을 구조화
  GAIN_PARAMS = create_gain_param_structs(GAIN_PARAMETER)
  PERSONAL_GAIN_PARAMS =
    create_gain_param_structs_for_personal(PERSONAL_GAIN_PARAMETER)
  CLASS_GAIN_PARAMS =
    create_gain_param_structs_for_personal(CLASS_GAIN_PARAMETER)
end