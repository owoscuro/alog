# encoding: utf-8
# Name: 078.RPG_Actor
# Size: 2868
class RPG::Actor < RPG::BaseItem
  attr_accessor :age
  attr_accessor :gender
  attr_accessor :birthplace
  attr_accessor :height
  attr_accessor :custom_bio
  
  def hunger_max; if @note =~ /<hungermax: (.*)>/i; return $1.to_i; else; return BRAVO_HTS::HTS_MAX[0]; end; end
  def thirst_max; if @note =~ /<thirstmax: (.*)>/i; return $1.to_i; else; return BRAVO_HTS::HTS_MAX[1]; end; end
  def sleep_max; if @note =~ /<sleepmax: (.*)>/i; return $1.to_i; else; return BRAVO_HTS::HTS_MAX[2]; end; end
  def repute_max; if @note =~ /<reputemax: (.*)>/i; return $1.to_i; else; return BRAVO_HTS::HTS_MAX[3]; end; end
  def sexual_max; if @note =~ /<sexual: (.*)>/i; return $1.to_i; else; return BRAVO_HTS::HTS_MAX[4]; end; end
  def piety_max; if @note =~ /<piety: (.*)>/i; return $1.to_i; else; return BRAVO_HTS::HTS_MAX[5]; end; end
  def hygiene_max; if @note =~ /<hygiene: (.*)>/i; return $1.to_i; else; return BRAVO_HTS::HTS_MAX[6]; end; end
  def temper_max; if @note =~ /<temper: (.*)>/i; return $1.to_i; else; return BRAVO_HTS::HTS_MAX[7]; end; end
  def stress_max; if @note =~ /<stress: (.*)>/i; return $1.to_i; else; return BRAVO_HTS::HTS_MAX[8]; end; end
  def cold_max; if @note =~ /<cold: (.*)>/i; return $1.to_i; else; return BRAVO_HTS::HTS_MAX[9]; end; end
  def drunk_max; if @note =~ /<drunk: (.*)>/i; return $1.to_i; else; return BRAVO_HTS::HTS_MAX[10]; end; end
  
  def in_roster?
    self.note =~ /<NO ROSTER>/
  end
  
  def roster_number
    self.note =~ /<ROSTER (\d+)>/ ? $1.to_i : 999
  end
  
  def load_notetags_bm_status
    @custom_bio = {}
    #print("078.RPG::Actor - 이력 초기값 대입 \n");
    # 커스텀 바이오 정보 최대 수치 수정
    for i in 1..30
      #@custom_bio[i] = (BM::STATUS::EMPTY_BIO).to_i
      @custom_bio[i] = 0.to_i
    end
    @age = (BM::STATUS::EMPTY_BIO).to_i
    @birthplace = BM::STATUS::EMPTY_BIO
    @height = (BM::STATUS::EMPTY_BIO).to_i
    @gender = BM::STATUS::EMPTY_BIO
    self.note.split(/[\r\n]+/).each { |line|
      case line
      when BM::REGEXP::ACTOR::AGE
        @age = $1.to_i
      when BM::REGEXP::ACTOR::BIRTHPLACE
        @birthplace = $1
      when BM::REGEXP::ACTOR::HEIGHT
        @height = $1
      when BM::REGEXP::ACTOR::CUSTOMBIO
        if $1.to_i == 1 or $1.to_i == 3 or $1.to_i == 23
          @custom_bio[$1.to_i] = $2
          #print("078.RPG::Actor - 이력 초기값 문자 대입, %s, %s \n" % [$1.to_i, $2]);
        else
          @custom_bio[$1.to_i] = $2.to_i
          #print("078.RPG::Actor - 이력 초기값 숫자 대입, %s, %s \n" % [$1.to_i, $2]);
        end
      end
    }
  end
  
  def weight_limit
    @note =~ /<무게제한 (\d+)>/i ? $1.to_i : nil
  end
  
  def sexy_limit
    @note =~ /<허용노출도 (\d+)>/i ? $1.to_i : CRYSTAL::EQUIP::DEFAULT_SEXY_LIMIT
  end
end