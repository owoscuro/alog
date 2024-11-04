# encoding: utf-8
# Name: 028.RPG, BaseItem
# Size: 1277
module TH
  module Item_Rarity
    Colour_Map = {
      1 => [255, 255, 255],
      2 => [204, 255, 137],
      3 => [197, 122, 255],
      4 => [255, 84, 0],
      5 => [255, 0, 0],
    }

    Regex = /<레어도:\s*(\d+)\s*>/i
    @@rarity_colour_map = nil
    
    def self.rarity_colour_map
      unless @@rarity_colour_map
        @@rarity_colour_map = {}
        Colour_Map.each do |i, arr|
          @@rarity_colour_map[i] = Color.new(*arr)
        end
      end
      return @@rarity_colour_map
    end
  end
end

module RPG
  class BaseItem
    def rarity
      load_notetag_item_rarity unless @rarity
      return @rarity
    end

    def load_notetag_item_rarity
      @rarity = 1
      res = self.note.match(TH::Item_Rarity::Regex)
      if res
        @rarity = res[1].to_i
      else
        @rarity = 1
      end
    end
    
    def rarity_colour
      TH::Item_Rarity.rarity_colour_map[self.rarity]
    end
    
    alias :th_item_rarity_refresh :refresh
    def refresh
      th_item_rarity_refresh
      refresh_item_rarity
    end

    def refresh_item_rarity
      var = InstanceManager.get_template(self).rarity
      @rarity = make_item_rarity(InstanceManager.make_full_copy(var))
    end

    def make_item_rarity(rarity)
      rarity
    end
  end
end