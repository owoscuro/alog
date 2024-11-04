# encoding: utf-8
# Name: 265.Game_Interpreter
# Size: 27719
class Game_Interpreter
  #--------------------------------------------------------------------------
  # * New Method: 셀프스위치 설정
  #--------------------------------------------------------------------------
  def setSelfSwitch(map, eID, selfSwitch, trueFalse)
    switch = [map, eID, selfSwitch]
    $game_self_switches[switch] = trueFalse
    $game_map.refresh
  end
  
  #--------------------------------------------------------------------------
  # * New Method: SelfSwitch는 참/거짓입니까?
  #--------------------------------------------------------------------------
  def isSelfSwitch?(map, eID, selfSwitch)
    switch = [map, eID, selfSwitch]
    $game_self_switches[switch]
  end
  
  #--------------------------------------------------------------------------
  # * New Method: 모든 SelfSwitch 설정
  #--------------------------------------------------------------------------
  def setAllSelf(map, eID, trueFalse)
    switches = ["A","B","C","D"]
    for i in switches
      setSelfSwitch(map, eID, i, trueFalse)
    end
    $game_map.refresh
  end
  
  #--------------------------------------------------------------------------
  # * New Method: 셀프온
  #--------------------------------------------------------------------------
  def self_on(mapID,eventID,switch)
     $game_self_switches[[mapID, eventID, switch]] = true
     $game_map.refresh
  end
   
  #--------------------------------------------------------------------------
  # * New Method: 셀프 오프
  #--------------------------------------------------------------------------
  def self_off(mapID,eventID,switch)
     $game_self_switches[[mapID, eventID, switch]] = false
     $game_map.refresh    
  end
   
  #--------------------------------------------------------------------------
  # * New Method: A switch on
  #--------------------------------------------------------------------------
  def a_on(mapID,eventID)
     $game_self_switches[[mapID, eventID, "A"]] = true
     $game_map.refresh    
  end
   
  #--------------------------------------------------------------------------
  # * New Method: A switch off
  #--------------------------------------------------------------------------
  def a_off(mapID,eventID)
     $game_self_switches[[mapID, eventID, "A"]] = false
     $game_map.refresh    
  end
  
  #--------------------------------------------------------------------------
  # * New Method: B switch on
  #--------------------------------------------------------------------------
  def b_on(mapID,eventID)
     $game_self_switches[[mapID, eventID, "B"]] = true
     $game_map.refresh
  end
  
  #--------------------------------------------------------------------------
  # * New Method: B switch off
  #--------------------------------------------------------------------------
  def b_off(mapID,eventID)
     $game_self_switches[[mapID, eventID, "B"]] = false
     $game_map.refresh    
  end   
  
  #--------------------------------------------------------------------------
  # * New Method: C switch on
  #--------------------------------------------------------------------------
  def c_on(mapID,eventID)
     $game_self_switches[[mapID, eventID, "C"]] = true
     $game_map.refresh    
  end
  
  #--------------------------------------------------------------------------
  # * New Method: C switch off
  #--------------------------------------------------------------------------
  def c_off(mapID,eventID)
     $game_self_switches[[mapID, eventID, "C"]] = false
     $game_map.refresh    
  end   
  
  #--------------------------------------------------------------------------
  # * New Method: D switch on
  #--------------------------------------------------------------------------
  def d_on(mapID,eventID)
    $game_self_switches[[mapID, eventID, "D"]] = true
    $game_map.refresh    
  end
  
  #--------------------------------------------------------------------------
  # * New Method: D switch off
  #--------------------------------------------------------------------------
  def d_off(mapID,eventID)
     $game_self_switches[[mapID, eventID, "D"]] = false
     $game_map.refresh    
  end 
  
  #--------------------------------------------------------------------------
  # * Alias: 상태 변경
  #--------------------------------------------------------------------------
  alias :bm_base_c313 :command_313
  def command_313
    bm_base_c313
    $game_party.clear_results
  end
  
  def self_variable(id, value = nil, oper = nil)
    id = id[0] if id.is_a?(Array) and id.size == 1
    if !id.is_a?(Array)
      if SelfData::Event::Sensitive_IDs == false and id.is_a?(String)
        id = id.upcase
      end
      if @event_id > 0
        key = [@map_id, @event_id, id]
        if value != nil
          case oper
          when nil, 0, 'equal', 'set', '='                     # Setting
            $game_self_variables[key] = value
          when 1, 'add', '+'                                   # Adding
            $game_self_variables[key] += value
          when 2, 'sub', 'subtract', '-'                       # Subtracting
            $game_self_variables[key] -= value
          when 3, 'mul', 'multiply', 'x', '*'                  # Multiplying
            $game_self_variables[key] *= value
          when 4, 'div', 'divide', '/'                         # Dividing
            $game_self_variables[key] /= value if value != 0
          when 5, 'mod', 'modular', '%'                        # Modulating
            $game_self_variables[key] %= value if value != 0
          end
        else
          return $game_self_variables[key]
        end
      end
    else
      case id.size
      when 3 # Map ID, Event ID, ID
        map_id, event_id, id = id[0], id[1], id[2]
        # If Case Insensitive
        if SelfData::Event::Sensitive_IDs == false and id.is_a?(String)
          id = id.upcase
        end
        # Combine ranges and integers into one array
        # Map IDs
        if map_id.is_a?(Array)
          array1 = []
          for i in 0..map_id.size - 1
            if map_id[i].is_a?(Integer)
              array1.push(map_id[i])
            elsif map_id[i].is_a?(Range)
              array2 = map_id[i].to_a
              array1.concat(array2)
            end
          end
          map_id = array1
        elsif map_id.is_a?(Range)
          map_id = map_id.to_a
        end
        # Event IDs
        if event_id.is_a?(Array)
          array1 = []
          for i in 0..event_id.size - 1
            if event_id[i].is_a?(Integer)
              array1.push(event_id[i])
            elsif event_id[i].is_a?(Range)
              array2 = event_id[i].to_a
              array1.concat(array2)
            end
          end
          event_id = array1
        elsif event_id.is_a?(Range)
          event_id = event_id.to_a
        end
        # Start
        if map_id.is_a?(Integer)
          if event_id.is_a?(Integer)
            key = [map_id, event_id, id]
            if value != nil
              case oper
              when nil, 0, 'equal', 'set', '='                   # Setting
                $game_self_variables[key] = value
              when 1, 'add', '+'                                 # Adding
                $game_self_variables[key] += value
              when 2, 'sub', 'subtract', '-'                     # Subtracting
                $game_self_variables[key] -= value
              when 3, 'mul', 'multiply', 'x', '*'                # Multiplying
                $game_self_variables[key] *= value
              when 4, 'div', 'divide', '/'                       # Dividing
                $game_self_variables[key] /= value if value != 0
              when 5, 'mod', 'modular', '%'                      # Modulating
                $game_self_variables[key] %= value if value != 0
              end
            else
              return $game_self_variables[key]
            end
          elsif event_id.is_a?(Array)
            array = [] if value == nil
            for i in 0..event_id.size - 1
              key = [map_id, event_id[i], id]
              if value != nil
                case oper
                when nil, 0, 'equal', 'set', '='                   # Setting
                  $game_self_variables[key] = value
                when 1, 'add', '+'                                 # Adding
                  $game_self_variables[key] += value
                when 2, 'sub', 'subtract', '-'                     # Subtracting
                  $game_self_variables[key] -= value
                when 3, 'mul', 'multiply', 'x', '*'                # Multiplying
                  $game_self_variables[key] *= value
                when 4, 'div', 'divide', '/'                       # Dividing
                  $game_self_variables[key] /= value if value != 0
                when 5, 'mod', 'modular', '%'                      # Modulating
                  $game_self_variables[key] %= value if value != 0
                end
              else
                array.push($game_self_variables[key])
              end
            end
            return array if value == nil
          elsif event_id == nil
            array = [] if value == nil
            for i in load_data(sprintf("Data/Map%03d.rvdata2", map_id)
                ).events.keys
              key = [map_id, i, id]
              if value != nil
                case oper
                when nil, 0, 'equal', 'set', '='                   # Setting
                  $game_self_variables[key] = value
                when 1, 'add', '+'                                 # Adding
                  $game_self_variables[key] += value
                when 2, 'sub', 'subtract', '-'                     # Subtracting
                  $game_self_variables[key] -= value
                when 3, 'mul', 'multiply', 'x', '*'                # Multiplying
                  $game_self_variables[key] *= value
                when 4, 'div', 'divide', '/'                       # Dividing
                  $game_self_variables[key] /= value if value != 0
                when 5, 'mod', 'modular', '%'                      # Modulating
                  $game_self_variables[key] %= value if value != 0
                end
              else
                array.push($game_self_variables[key])
              end
            end
            return array if value == nil
          end
        elsif map_id.is_a?(Array)
          array = [] if value == nil
          for i in 0..map_id.size - 1
            if event_id.is_a?(Integer)
              key = [map_id[i], event_id, id]
              if value != nil
                case oper
                when nil, 0, 'equal', 'set', '='                   # Setting
                  $game_self_variables[key] = value
                when 1, 'add', '+'                                 # Adding
                  $game_self_variables[key] += value
                when 2, 'sub', 'subtract', '-'                     # Subtracting
                  $game_self_variables[key] -= value
                when 3, 'mul', 'multiply', 'x', '*'                # Multiplying
                  $game_self_variables[key] *= value
                when 4, 'div', 'divide', '/'                       # Dividing
                  $game_self_variables[key] /= value if value != 0
                when 5, 'mod', 'modular', '%'                      # Modulating
                  $game_self_variables[key] %= value if value != 0
                end
              else
                array.push($game_self_variables[key])
              end
            elsif event_id.is_a?(Array)
              array[i] = [] if value == nil
              for i2 in 0..event_id.size - 1
                key = [map_id[i], event_id[i2], id]
                if value != nil
                  case oper
                  when nil, 0, 'equal', 'set', '='                 # Setting
                    $game_self_variables[key] = value
                  when 1, 'add', '+'                               # Adding
                    $game_self_variables[key] += value
                  when 2, 'sub', 'subtract', '-'                   # Subtracting
                    $game_self_variables[key] -= value
                  when 3, 'mul', 'multiply', 'x', '*'              # Multiplying
                    $game_self_variables[key] *= value
                  when 4, 'div', 'divide', '/'                     # Dividing
                    $game_self_variables[key] /= value if value != 0
                  when 5, 'mod', 'modular', '%'                    # Modulating
                    $game_self_variables[key] %= value if value != 0
                  end
                else
                  array[i].push($game_self_variables[key])
                end
              end
            elsif event_id == nil
              array[i] = [] if value == nil
              for i2 in load_data(sprintf("Data/Map%03d.rvdata2", map_id[i])
                  ).events.keys
                key = [map_id[i], i2, id]
                if value != nil
                  case oper
                  when nil, 0, 'equal', 'set', '='                 # Setting
                    $game_self_variables[key] = value
                  when 1, 'add', '+'                               # Adding
                    $game_self_variables[key] += value
                  when 2, 'sub', 'subtract', '-'                   # Subtracting
                    $game_self_variables[key] -= value
                  when 3, 'mul', 'multiply', 'x', '*'              # Multiplying
                    $game_self_variables[key] *= value
                  when 4, 'div', 'divide', '/'                     # Dividing
                    $game_self_variables[key] /= value if value != 0
                  when 5, 'mod', 'modular', '%'                    # Modulating
                    $game_self_variables[key] %= value if value != 0
                  end
                else
                  array[i].push($game_self_variables[key])
                end
              end
            end
          end
          return array if value == nil
        elsif map_id == nil
          array = [] if value == nil
          for i in load_data("Data/Mapinfos.rvdata2").keys
            if event_id.is_a?(Integer)
              key = [i, event_id, id]
              if value != nil
                case oper
                when nil, 0, 'equal', 'set', '='                 # Setting
                  $game_self_variables[key] = value
                when 1, 'add', '+'                               # Adding
                  $game_self_variables[key] += value
                when 2, 'sub', 'subtract', '-'                   # Subtracting
                  $game_self_variables[key] -= value
                when 3, 'mul', 'multiply', 'x', '*'              # Multiplying
                  $game_self_variables[key] *= value
                when 4, 'div', 'divide', '/'                     # Dividing
                  $game_self_variables[key] /= value if value != 0
                when 5, 'mod', 'modular', '%'                    # Modulating
                  $game_self_variables[key] %= value if value != 0
                end
              else
                array.push($game_self_variables[key])
              end
            elsif event_id.is_a?(Array)
              array[i] = [] if value == nil
              for i2 in 0..event_id - 1
                key = [i, event_id[i2], id]
                if value != nil
                  case oper
                  when nil, 0, 'equal', 'set', '='                 # Setting
                    $game_self_variables[key] = value
                  when 1, 'add', '+'                               # Adding
                    $game_self_variables[key] += value
                  when 2, 'sub', 'subtract', '-'                   # Subtracting
                    $game_self_variables[key] -= value
                  when 3, 'mul', 'multiply', 'x', '*'              # Multiplying
                    $game_self_variables[key] *= value
                  when 4, 'div', 'divide', '/'                     # Dividing
                    $game_self_variables[key] /= value if value != 0
                  when 5, 'mod', 'modular', '%'                    # Modulating
                    $game_self_variables[key] %= value if value != 0
                  end
                else
                  array[i].push($game_self_variables[key])
                end
              end
            elsif event_id == nil
              array[i] = [] if value == nil
              for i2 in load_data(sprintf("Data/Map%03d.rvdata2", i)).events.keys
                key = [map_id[i], i2, id]
                if value != nil
                  case oper
                  when nil, 0, 'equal', 'set', '='                 # Setting
                    $game_self_variables[key] = value
                  when 1, 'add', '+'                               # Adding
                    $game_self_variables[key] += value
                  when 2, 'sub', 'subtract', '-'                   # Subtracting
                    $game_self_variables[key] -= value
                  when 3, 'mul', 'multiply', 'x', '*'              # Multiplying
                    $game_self_variables[key] *= value
                  when 4, 'div', 'divide', '/'                     # Dividing
                    $game_self_variables[key] /= value if value != 0
                  when 5, 'mod', 'modular', '%'                    # Modulating
                    $game_self_variables[key] %= value if value != 0
                  end
                else
                  array[i].push($game_self_variables[key])
                end
              end
            end
          end
          return array if value == nil
        end
      when 2 # Event ID, Map ID (Current Map)
        # If Case Insensitive
        if SelfData::Event::Sensitive_IDs == false and id.is_a?(String)
          id = id.upcase
        end
        map_id, event_id, id = @map_id, id[0], id[1]
        if event_id.is_a?(Integer)
          key = [map_id, event_id, id]
          if value != nil
            case oper
            when nil, 0, 'equal', 'set', '='                 # Setting
              $game_self_variables[key] = value
            when 1, 'add', '+'                               # Adding
              $game_self_variables[key] += value
            when 2, 'sub', 'subtract', '-'                   # Subtracting
              $game_self_variables[key] -= value
            when 3, 'mul', 'multiply', 'x', '*'              # Multiplying
              $game_self_variables[key] *= value
            when 4, 'div', 'divide', '/'                     # Dividing
              $game_self_variables[key] /= value if value != 0
            when 5, 'mod', 'modular', '%'                    # Modulating
              $game_self_variables[key] %= value if value != 0
            end
          else
            return $game_self_variables[key]
          end
        elsif event_id.is_a?(Array)
          array = [] if value == nil
          for i in 0..event_id.size - 1
            key = [map_id, event_id[i], id]
            if value != nil
              case oper
              when nil, 0, 'equal', 'set', '='                 # Setting
                $game_self_variables[key] = value
              when 1, 'add', '+'                               # Adding
                $game_self_variables[key] += value
              when 2, 'sub', 'subtract', '-'                   # Subtracting
                $game_self_variables[key] -= value
              when 3, 'mul', 'multiply', 'x', '*'              # Multiplying
                $game_self_variables[key] *= value
              when 4, 'div', 'divide', '/'                     # Dividing
                $game_self_variables[key] /= value if value != 0
              when 5, 'mod', 'modular', '%'                    # Modulating
                $game_self_variables[key] %= value if value != 0
              end
            else
              array.push($game_self_variables[key])
            end
          end
          return array if value == nil
        elsif event_id == nil
          array = [] if value == nil
          for i in load_data(sprintf("Data/Map%03d.rvdata2", map_id)).events.keys
            if value != nil
              $game_self_variables[[map_id, i, id]] = value
            else
              array.push($game_self_variables[[map_id, i, id]])
            end
          end
          return array if value == nil
        end
      end
    end
    $game_map.need_refresh = true
    return true
  end
  
  def self_metadata(id, value = nil)
    id = id[0] if id.is_a?(Array) and id.size == 1
    if !id.is_a?(Array)
      if SelfData::Event::Sensitive_IDs == false and id.is_a?(String)
        id = id.upcase
      end
      value = value.downcase
      if @event_id > 0
        key = [@map_id, @event_id, id]
        if value != nil
          $game_self_metadata[key] = value
        else
          return $game_self_metadata[key]
        end
      end
    else
      case id.size
      when 3 # Map ID, Event ID, ID
        map_id, event_id, id = id[0], id[1], id[2]
        # If Case Insensitive
        if SelfData::Event::Sensitive_IDs == false and id.is_a?(String)
          id = id.upcase
        end
        value = value.downcase
        # Combine ranges and integers into one array
        # Map IDs
        if map_id.is_a?(Array)
          array1 = []
          for i in 0..map_id.size - 1
            if map_id[i].is_a?(Integer)
              array1.push(map_id[i])
            elsif map_id[i].is_a?(Range)
              array2 = map_id[i].to_a
              array1.concat(array2)
            end
          end
          map_id = array1
        elsif map_id.is_a?(Range)
          map_id = map_id.to_a
        end
        # Event IDs
        if event_id.is_a?(Array)
          array1 = []
          for i in 0..event_id.size - 1
            if event_id[i].is_a?(Integer)
              array1.push(event_id[i])
            elsif event_id[i].is_a?(Range)
              array2 = event_id[i].to_a
              array1.concat(array2)
            end
          end
          event_id = array1
        elsif event_id.is_a?(Range)
          event_id = event_id.to_a
        end
        # Start
        if map_id.is_a?(Integer)
          if event_id.is_a?(Integer)
            $game_self_metadata[[map_id, event_id, id]] = value if value != nil
            return $game_self_metadata[[map_id, event_id, id]] if value == nil
          elsif event_id.is_a?(Array)
            array = [] if value == nil
            for i in 0..event_id.size - 1
              if value != nil
                $game_self_metadata[[map_id, event_id[i], id]] = value
              else
                array.push($game_self_metadata[[map_id, event_id[i], id]])
              end
            end
            return array if value == nil
          elsif event_id == nil
            array = [] if value == nil
            for i in load_data(sprintf("Data/Map%03d.rvdata2", map_id)
                ).events.keys
              if value != nil
                $game_self_metadata[[map_id, i, id]] = value
              else
                array.push($game_self_metadata[[map_id, i, id]])
              end
            end
            return array if value == nil
          end
        elsif map_id.is_a?(Array)
          array = [] if value == nil
          for i in 0..map_id.size - 1
            if event_id.is_a?(Integer)
              if value != nil
                $game_self_metadata[[map_id[i], event_id, id]] = value
              else
                array.push($game_self_metadata[[map_id[i], event_id, id]])
              end
            elsif event_id.is_a?(Array)
              array[i] = [] if value == nil
              for i2 in 0..event_id.size - 1
                if value != nil
                  $game_self_metadata[[map_id[i], event_id[i2], id]] = value
                else
                  array[i].push($game_self_metadata[[map_id[i], event_id[i2], 
                    id]])
                end
              end
            elsif event_id == nil
              array[i] = [] if value == nil
              for i2 in load_data(sprintf("Data/Map%03d.rvdata2", map_id[i])
                  ).events.keys
                if value != nil
                  $game_self_metadata[[map_id[i], i2, id]] = value
                else
                  array[i].push($game_self_metadata[[map_id[i], i2, id]])
                end
              end
            end
          end
          return array if value == nil
        elsif map_id == nil
          array = [] if value == nil
          for i in load_data("Data/Mapinfos.rvdata2").keys
            if event_id.is_a?(Integer)
              if value != nil
                $game_self_metadata[[i, event_id, id]] = value
              else
                array.push($game_self_metadata[[i, event_id, id]])
              end
            elsif event_id.is_a?(Array)
              array[i] = [] if value == nil
              for i2 in 0..event_id - 1
                if value != nil
                  $game_self_metadata[[i, event_id[i2], id]] = value
                else
                  array[i].push($game_self_metadata[[i, event_id[i2], id]])
                end
              end
            elsif event_id == nil
              array[i] = [] if value == nil
              for i2 in load_data(sprintf("Data/Map%03d.rvdata2", i)).events.keys
                if value != nil
                  $game_self_metadata[[map_id[i], i2, id]] = value
                else
                  array[i].push($game_self_metadata[[map_id[i], i2, id]])
                end
              end
            end
          end
          return array if value == nil
        end
      when 2 # Event ID, Map ID (Current Map)
        # If Case Insensitive
        if SelfData::Event::Sensitive_IDs == false and id.is_a?(String)
          id = id.upcase
        end
        map_id, event_id, id = @map_id, id[0], id[1]
        if event_id.is_a?(Integer)
          $game_self_metadata[[map_id, event_id, id]] = value if value != nil
          return $game_self_metadata[[map_id, event_id, id]] if value == nil
        elsif event_id.is_a?(Array)
          array = [] if value == nil
          for i in 0..event_id.size - 1
            if value != nil
              $game_self_metadata[[map_id, event_id[i], id]] = value
            else
              array.push($game_self_metadata[[map_id, event_id[i], id]])
            end
          end
          return array if value == nil
        elsif event_id == nil
          array = [] if value == nil
          for i in load_data(sprintf("Data/Map%03d.rvdata2", map_id)).events.keys
            if value != nil
              $game_self_metadata[[map_id, i, id]] = value
            else
              array.push($game_self_metadata[[map_id, i, id]])
            end
          end
          return array if value == nil
        end
      end
    end
    $game_map.need_refresh = true
    return true
  end
end