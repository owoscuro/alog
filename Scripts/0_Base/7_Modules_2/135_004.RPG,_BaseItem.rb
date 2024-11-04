# encoding: utf-8
# Name: 004.RPG, BaseItem
# Size: 3340
module RPG
  class SE < AudioFile
    def play
      unless @name.empty?
        pitch = @pitch
        pitch += rand(7)-3 if BM::RAND_PITCH
        Audio.se_play("Audio/SE/" + @name, @volume, pitch)
      end
    end
  end

  class BaseItem
    # 공유 인스턴스 변수인 모든 속성 목록
    _instance_attr = [:name, :params, :price, :features, :note, :icon_index,
                      :description]

    #---------------------------------------------------------------------------
    # 모든 공유 변수에 대한 메서드 정의
    #---------------------------------------------------------------------------
    _instance_refresh = "def refresh"
    _instance_attr.each do |ivar|
      _instance_refresh << ";refresh_#{ivar}"
      
      eval(
        "def refresh_#{ivar}
          var = InstanceManager.get_template(self).#{ivar}
          @#{ivar} = make_#{ivar}(InstanceManager.make_full_copy(var))
        end
        
        def make_#{ivar}(#{ivar})
          #{ivar}
        end
        "
      )
    end
    _instance_refresh << ";end"
    eval(_instance_refresh)
  end
  
  class Item < UsableItem
    attr_accessor :template_id
    
    def is_template?
      return self.template_id == self.id
    end
    
    def template_id
      @template_id = @id unless @template_id
      return @template_id
    end
  end
  
  class EquipItem < BaseItem    
    attr_accessor :template_id
    
    def is_template?
      self.template_id == self.id
    end
    
    def template_id
      @template_id = @id unless @template_id
      return @template_id
    end
  end
end

module RPG
  class BaseItem
    def param_bonuses
      load_notetag_param_bonuses unless @param_bonuses
      return @param_bonuses
    end
    
    def load_notetag_param_bonuses
      @param_bonuses = []
      results = self.note.scan(TH::Parameter_Bonuses::Regex)
      results.each do |res|
        param = res[0].downcase.to_sym
        formula = res[1].strip
        id = TH::Parameter_Bonuses::Table[param]
        data = Data_ParamBonus.new(id, formula, self)
        @param_bonuses << data
      end
    end
  end

  class Event::Page
    def random_position?
      return @is_random_position unless @is_random_position.nil?
      load_notetag_random_event_positions
      return @is_random_position
    end
    
    def random_position_type
      return @random_position_type unless @random_position_type.nil?
      load_notetag_random_event_positions
      return @random_position_type
    end
    
    def random_position_region
      return eval_random_position_region unless @random_position_region.nil?
      load_notetag_random_event_positions
      return eval_random_position_region
    end
    def eval_random_position_region(v=$game_variables, s=$game_switches)
      eval(@random_position_region)
    end
    
    def load_notetag_random_event_positions
      @is_random_position = false
      @random_position_region = "0"
      @random_position_type = TH::Random_Event_Positions::Default_Type
      @list.each do |cmd|
        if cmd.code == 108 && cmd.parameters[0] =~ TH::Random_Event_Positions::Regex
          @random_position_region = $1
          @random_position_type = $2.to_sym unless $2.nil?
          @is_random_position = @random_position_region != 0
          break
        end
      end
    end
  end
end