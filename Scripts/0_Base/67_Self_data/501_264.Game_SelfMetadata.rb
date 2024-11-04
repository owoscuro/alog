# encoding: utf-8
# Name: 264.Game_SelfMetadata
# Size: 5250
class Game_SelfMetadata
  def initialize
    @data = {}
    SelfData::Event::Metadata.each { |k, v|
      if SelfData::Event::Sensitive_IDs == false and k[2].is_a?(String)
        k[2] = k[2].upcase
      end
      v = v.downcase
      if k[0].is_a?(Integer)    # If Map ID is an Integer
        if k[1].is_a?(Integer)  # If Event ID is an Integer
          @data[k] = v
        elsif k[1].is_a?(Range) # If Event ID is a range
          for i in k[1]
            @data[[k[0], i, k[2]]] = v
          end
        elsif k[1].is_a?(Array) # If Event ID is an array
          for i in 0..k[1].size - 1
            if k[1][i].is_a?(Integer)
              @data[[k[0], k[1][i], k[2]]] = v
            elsif k[1][i].is_a?(Range)
              for ir in k[1][i]
                @data[[k[0], ir, k[2]]] = v
              end
            end
          end
        elsif k[1] == nil       # If Event ID is nil
          for i in load_data(sprintf("Data/Map%03d.rvdata2", k[0])).events.keys
            @data[[k[0], i, k[2]]] = v
          end
        end
      elsif k[0].is_a?(Range)   # If Map ID is a Range
        for ir in k[0]
          if k[1].is_a?(Integer)  # If Event ID is an Integer
            @data[[ir, k[1], k[2]]] = v
          elsif k[1].is_a?(Range) # If Event ID is a Range
            for ir2 in k[1]
              @data[[ir, ir2, k[2]]] = v
            end
          elsif k[1].is_a?(Array) # If Event ID is an array
            for i in 0..k[1].size - 1
              if k[1][i].is_a?(Integer)
                @data[[ir, k[1][i], k[2]]] = v
              elsif k[1][i].is_a?(Range)
                for ir2 in k[1][i]
                  @data[[ir, ir2, k[2]]] = v
                end
              end
            end
          elsif k[1] == nil       # If Event ID is nil
            for i in load_data(sprintf("Data/Map%03d.rvdata2", ir)).events.keys
              @data[[ir, i, k[2]]] = v
            end
          end
        end
      elsif k[0].is_a?(Array)     # If Map ID is an array
        for i in 0..k[0].size - 1
          if k[0][i].is_a?(Integer) # If Map ID contains an integer
            if k[1].is_a?(Integer)  # If Event ID is an Integer
              @data[[k[0][i], k[1], k[2]]] = v
            elsif k[1].is_a?(Range) # If Event ID is a Range
              for ir in k[1]
                @data[[k[0][i], ir, k[2]]] = v
              end
            elsif k[1].is_a?(Array) # If Event ID is an array
              for i2 in 0..k[1].size - 1
                if k[1][i2].is_a?(Integer)
                  @data[[k[0][i], k[1][i2], k[2]]] = v
                elsif k[1][i2].is_a?(Range)
                  for ir in k[1][i2]
                    @data[[k[0][i], ir, k[2]]] = v
                  end
                end
              end
            elsif k[1] == nil       # If Event ID is nil
              for i2 in load_data(sprintf("Data/Map%03d.rvdata2", k[0][i])
                  ).events.keys
                @data[[k[0][i], i2, k[2]]] = v
              end
            end
          elsif k[0][i].is_a?(Range)  # If Map ID contains a Range
            for ir in k[0][i]
              if k[1].is_a?(Integer)  # If Event ID is an Integer
                @data[[ir, k[1], k[2]]] = v
              elsif k[1].is_a?(Range) # If Event ID is a Range
                for ir2 in k[1]
                  @data[[ir, ir2, k[2]]] = v
                end
              elsif k[1].is_a?(Array) # If Event ID is an array
                for i in 0..k[1].size - 1
                  if k[1][i].is_a?(Integer)
                    @data[[ir, k[1][i], k[2]]] = v
                  elsif k[1][i].is_a?(Range)
                    for ir2 in k[1][i]
                      @data[[ir, ir2, k[2]]] = v
                    end
                  end
                end
              elsif k[1] == nil       # If Event ID is nil
                for i2 in load_data(sprintf("Data/Map%03d.rvdata2", ir)
                    ).events.keys
                  @data[[ir, i2, k[2]]] = v
                end
              end
            end
          end
        end
      elsif k[0] == nil           # If Map ID is nil
        for i in load_data("Data/Mapinfos.rvdata2").keys
          if k[1].is_a?(Integer)  # If Event ID is an Integer
            @data[[i, k[1], k[2]]] = v
          elsif k[1].is_a?(Range) # If Event ID is a Range
            for ir in k[1]
              @data[[i, ir, k[2]]] = v
            end
          elsif k[1].is_a?(Array) # If Event ID is an array
            for i in 0..k[1].size - 1
              if k[1][i].is_a?(Integer)
                @data[[i, k[1][i], k[2]]] = v
              elsif k[1][i].is_a?(Range)
                for ir in k[1][i]
                  @data[[i, ir, k[2]]] = v
                end
              end
            end
          elsif k[1] == nil
            for i2 in load_data(sprintf("Data/Map%03d.rvdata2", i)).events.keys
              @data[[i, i2, k[2]]] = v
            end
          end
        end
      end
    }
  end
  
  def [](key)
    return @data[key] if @data[key] != nil
  end
  
  def []=(key, value)
    @data[key] = value
  end
end