# encoding: utf-8
# Name: 005.DataManager
# Size: 4541
module DataManager
  class << self
    alias shaz_clone_events_load_normal_database load_normal_database
    alias load_database_aee load_database
    alias :th_instance_items_load_game_without_rescue :load_game_without_rescue
    alias :th_instance_items_create_game_objects :create_game_objects
    alias :th_instance_items_make_save_contents :make_save_contents
    alias :th_instance_items_extract_save_contents :extract_save_contents
    
    alias masv_extrctsvcon_5gh6 extract_save_contents
    def extract_save_contents(contents, *args, &block)
      masv_extrctsvcon_5gh6(contents, *args, &block)
      $game_system.masv_initialize_statebuff_counters if !$game_system.masv_states_afflicted
    end
  end
  
  def self.create_game_objects
    th_instance_items_create_game_objects
    InstanceManager.create_game_objects
    load_instance_database
  end
  
  def self.make_save_contents
    contents = th_instance_items_make_save_contents
    contents[:instance_weapons] = InstanceManager.weapons
    contents[:instance_armors] = InstanceManager.armors
    contents[:instance_items] = InstanceManager.items
    contents
  end
  
  def self.extract_save_contents(contents)
    th_instance_items_extract_save_contents(contents)
    InstanceManager.weapons = contents[:instance_weapons] || []
    InstanceManager.armors = contents[:instance_armors] || []
    InstanceManager.items = contents[:instance_items] || []
  end
  
  def self.load_game_without_rescue(index)
    res = th_instance_items_load_game_without_rescue(index)
    reload_instance_database
    return res
  end
  
  #-----------------------------------------------------------------------------
  # 인스턴스 항목을 데이터베이스에 병합합니다.
  #-----------------------------------------------------------------------------
  def self.load_instance_database
    InstanceManager.setup
    merge_array_data($data_weapons, InstanceManager.weapons)
    merge_array_data($data_armors, InstanceManager.armors)
    merge_array_data($data_items, InstanceManager.items)
  end
  
  def self.reload_instance_database
    $data_weapons = $data_weapons[0..InstanceManager.template_counts[:weapon]]
    $data_armors = $data_armors[0..InstanceManager.template_counts[:armor]]
    $data_items = $data_items[0..InstanceManager.template_counts[:item]]
    load_instance_database
  end
  
  def self.merge_array_data(arr, hash)
    hash.each {|i, val|
      arr[i] = val
    }
  end
  
  def self.savefile_max
    return YEA::SAVE::MAX_FILES
  end
  
  def self.make_save_header
    header = {}
    header[:characters]    = $game_party.characters_for_savefile
    header[:playtime_s]    = $game_system.playtime_s
    header[:system]        = Marshal.load(Marshal.dump($game_system))
    header[:timer]         = Marshal.load(Marshal.dump($game_timer))
    header[:message]       = Marshal.load(Marshal.dump($game_message))
    header[:switches]      = Marshal.load(Marshal.dump($game_switches))
    header[:variables]     = Marshal.load(Marshal.dump($game_variables))
    header[:self_switches] = Marshal.load(Marshal.dump($game_self_switches))
    header[:actors]        = Marshal.load(Marshal.dump($game_actors))
    header[:actors_equips] = Marshal.load(Marshal.dump($game_actors[7].equips))
    header[:party]         = Marshal.load(Marshal.dump($game_party))
    header[:troop]         = Marshal.load(Marshal.dump($game_troop))
    header[:map]           = Marshal.load(Marshal.dump($game_map))
    header[:player]        = Marshal.load(Marshal.dump($game_player))
    header
  end
  
  def self.load_database
    load_database_aee
    load_notetags_aee
  end
  
  def self.load_notetags_aee
    groups = [$data_actors, $data_classes, $data_weapons, $data_armors, $data_states]
    for group in groups
      for obj in group
        next if obj.nil?
        obj.load_notetags_aee
      end
    end
  end
  
  def self.load_normal_database
    shaz_clone_events_load_normal_database
    $data_spawn_map = load_data(sprintf("Data/Map%03d.rvdata2", Region_Effects::SPAWN_MAP_ID))
    load_cloned_events
  end
  
  def self.load_cloned_events
    $data_clones = {}
    if !CloneEvents::CLONE_MAP.nil?
      clone_map_events(CloneEvents::CLONE_MAP)
    end
  end
  
  def self.clone_map_events(map_id)
    $data_clones[map_id] = {}
    events = load_data(sprintf('Data/Map%03d.rvdata2', map_id)).events
    events.each do |i, event|
      name = CloneEvents::USE_NAME ? event.name.downcase : event.id.to_s
      $data_clones[map_id][name] = event.clone
    end
  end
end