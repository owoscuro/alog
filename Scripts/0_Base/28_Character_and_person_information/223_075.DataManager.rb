# encoding: utf-8
# Name: 075.DataManager
# Size: 674
module DataManager  
  class << self
    alias :bm_status_ld :load_database
  end
  
  def self.load_database
    bm_status_ld
    load_notetags_bm_status
    load_notetags_bm_equip
  end  
  
  def self.load_notetags_bm_status
    groups = [$data_actors]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_bm_status
      end
    end
  end
  
  def self.load_notetags_bm_equip
    groups = [$data_actors,$data_classes,$data_items, $data_weapons, $data_armors]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_bm_equip
      end
    end
  end
end