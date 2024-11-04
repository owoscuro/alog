# encoding: utf-8
# Name: 077.RPG_BaseItem
# Size: 7029
class RPG::BaseItem
  include NOTES
  
  attr_accessor :inv_size       # 항목 인벤토리 크기
  attr_accessor :inv_mod        # 인벤토리 슬롯 수정자
  attr_accessor :inv_eval       # 인벤토리 평가 수정자
  attr_accessor :inv_item_max2  # 아이템 수량 표기
  attr_accessor :base_equip_slots
  attr_accessor :fixed_equip_type
  attr_accessor :sealed_equip_type
  attr_accessor :extra_starting_equips
  attr_accessor :equip_image
  attr_accessor :base_equip_body_x
  attr_accessor :base_equip_body_y
  attr_accessor :equip_body_default
  attr_accessor :e_image
  
  attr_reader :has_data
  
  InvSizeREGX     = /<무게 (\d+)>/i
  #InvSizeREGX     = /<inv[\s_]+size\s*:\s*(\d+)>/i
  InvPlusREGX     = /<inv[\s_]+plus\s*:\s*(\d+)>/i
  InvMinusREGX    = /<inv[\s_]+minus\s*:\s*(\d+)/i
  InvFormSTART    = /<inv[\s_]+formula>/i
  InvFormEND      = /<\/inv[\s_]+formula>/i
  InvSITEM_MAX    = /<itemmax: (.*)>/i                  # 아이템 수량
  
  def tool_data(comment, sw=true)
    if @note =~ /#{comment}(.*)/i
      @has_data = true
      return sw ? $1.to_i : $1.to_s.sub("\r","")
    end
  end
  
  def note_field
    @field = field(note) if @field.nil?
    return @field
  end
  
  def tool_float(comment)
    return  $1.to_f if @note =~ /#{comment}(.*)/i
  end
  
  # 쿨다운 표시 여부
  def cool_enabled?
    @cd_dis = true
    # 아래는 원본
    #@cd_dis = @note.include?("Tool Cooldown Display = true") if @cd_dis.nil?
    @cd_dis
  end
  
  def itemcost
    if @i_cost.nil?
      @note =~ /Tool Item Cost = (.*)/i ? @i_cost = $1.to_i : @i_cost = 0
    end
    @i_cost
  end

  def load_limited_inv
    load_eval = false
    @inv_size = 1
    @inv_eval = '0'
    @inv_mod = self.is_a?(RPG::Actor) ? Theo::LimInv::Default_FreeSlot : 0
    self.note.split(/[\r\n]+/).each do |line|
      case line
      when InvSizeREGX
        @inv_size = $1.to_i
      when InvPlusREGX
        @inv_mod = $1.to_i
      when InvMinusREGX
        @inv_mod = -$1.to_i
      when InvFormSTART
        load_eval = true
        @inv_eval = ''
      when InvFormEND
        load_eval = false
      # 아이템 수량 표기 실험
      when InvSITEM_MAX
        @inv_item_max2 = $1.to_i
      else
        @inv_eval += line if load_eval
      end
    end
  end
  
  # 매각 금액의 비율을 반환
  def selling_rate
    /<판매가\s+(\d+)\%>/ =~ @note ? $1.to_i : 50
  end
  
  # 거래소 및 창고에 해당 아이템 최대 물품 수량 제한
  def storage_max
    if @note =~ /<storagemax: (.*)>/i
      return $1.to_i
    else
      return BRAVO_STORAGE::ITEM_MAX
    end
  end
  
  # 소지 아이템 최대 수량
  def item_max
    if @note =~ /<itemmax: (.*)>/i
      return $1.to_i
    else
      return BRAVO::ITEM_MAX
    end
  end
  
  def load_notetags_aee
    @base_equip_slots = []
    @equip_slots_on = false
    @fixed_equip_type = []
    @sealed_equip_type = []
    @extra_starting_equips = []
    self.note.split(/[\r\n]+/).each { |line|
      case line
      when YEA::REGEXP::BASEITEM::EQUIP_SLOTS_ON
        next unless self.is_a?(RPG::Actor) ||self.is_a?(RPG::Class)
        @equip_slots_on = true
      when YEA::REGEXP::BASEITEM::EQUIP_SLOTS_OFF
        next unless self.is_a?(RPG::Actor) ||self.is_a?(RPG::Class)
        @equip_slots_on = false
      when YEA::REGEXP::BASEITEM::STARTING_GEAR
        next unless self.is_a?(RPG::Actor)
        $1.scan(/\d+/).each { |num| 
        @extra_starting_equips.push(num.to_i) if num.to_i > 0 }
      when YEA::REGEXP::BASEITEM::FIXED_EQUIP
        $1.scan(/\d+/).each { |num| 
        @fixed_equip_type.push(num.to_i) if num.to_i > 0 }
      when YEA::REGEXP::BASEITEM::SEALED_EQUIP
        $1.scan(/\d+/).each { |num| 
        @sealed_equip_type.push(num.to_i) if num.to_i > 0 }
      when YEA::REGEXP::BASEITEM::EQUIP_TYPE_INT
        next unless self.is_a?(RPG::Armor)
        @etype_id = [1, $1.to_i].max
      when YEA::REGEXP::BASEITEM::EQUIP_TYPE_STR
        next unless self.is_a?(RPG::Armor)
        for key in YEA::EQUIP::TYPES
          id = key[0]
          next if YEA::EQUIP::TYPES[id][0].upcase != $1.to_s.upcase
          @etype_id = [1, id].max
          break
        end
      else
        if @equip_slots_on
          case line.upcase
          when /EQUIP TYPE[ ](\d+)/i, /EQUIP TYPE:[ ](\d+)/i
            id = $1.to_i
            @base_equip_slots.push(id) if [0,1,2,3,4].include?(id)
            @base_equip_slots.push(id) if YEA::EQUIP::TYPES.include?(id)
          when /WEAPON/i
            @base_equip_slots.push(0)
          when /SHIELD/i
            @base_equip_slots.push(1)
          when /HEAD/i
            @base_equip_slots.push(2)
          when /BODY/i, /ARMOR/i, /ARMOUR/i
            @base_equip_slots.push(3)
          when /ETC/i, /OTHER/i, /ACCESSOR/i
            @base_equip_slots.push(4)
          else
            text = line.upcase.delete(" ")
            for key in YEA::EQUIP::TYPES
              id = key[0]
              next if YEA::EQUIP::TYPES[id][0].upcase.delete(" ")!= text
              @base_equip_slots.push(id)
              break
            end
          end
        end
      end
    }
    return unless self.is_a?(RPG::Class)
    if @base_equip_slots.empty?
      @base_equip_slots = YEA::EQUIP::DEFAULT_BASE_SLOTS.clone
    end
  end
  
  def load_notetags_bm_equip
    @equip_image = nil
    @equip_body_on = false
    @equip_body_default = true
    @base_equip_body_x = []
    @base_equip_body_y = []
    if $imported["YEA-AceEquipEngine"]
      item_max = YEA::EQUIP::DEFAULT_BASE_SLOTS.size
    else
      item_max = BM::EQUIP::BODY_ICON_LOCATIONS.size
    end
    item_max.times {|i| 
      next unless BM::EQUIP::BODY_ICON_LOCATIONS.include?(i)
      y = BM::EQUIP::BODY_ICON_LOCATIONS[i][1] - 6
      x = BM::EQUIP::BODY_ICON_LOCATIONS[i][0]
      @base_equip_body_y.push(y) 
      @base_equip_body_x.push(x) 
    }
    self.note.split(/[\r\n]+/).each { |line|
      case line
      when BM::REGEXP::E_IMAGE
        @e_image = $1.to_s
      when BM::REGEXP::EQUIP_BODY_ON
        next unless self.is_a?(RPG::Actor) ||self.is_a?(RPG::Class)
        @equip_body_on = true
      when BM::REGEXP::EQUIP_BODY_OFF
        next unless self.is_a?(RPG::Actor) ||self.is_a?(RPG::Class)
        @equip_body_on = false
      when BM::REGEXP::EQUIP_IMAGE
        next unless self.is_a?(RPG::Actor) ||self.is_a?(RPG::Class)
        @equip_image = $1
      else
        if @equip_body_on
          case line.upcase
          when /EQUIP SLOTX[ ](\d+):[ ](\d+)/i
            @base_equip_body_x[$1.to_i] = $2.to_i
            @equip_body_default = false
          when /EQUIP SLOTY[ ](\d+):[ ](\d+)/i
            @base_equip_body_y[$1.to_i] = $2.to_i
            @equip_body_default = false
          end
        end
      end
    }
  end
end