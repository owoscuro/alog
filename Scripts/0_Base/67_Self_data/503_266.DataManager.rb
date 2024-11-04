# encoding: utf-8
# Name: 266.DataManager
# Size: 1424
class << DataManager
  unless self.method_defined?(:pk8_selfdata_create_game_objects)
    alias_method(:pk8_selfdata_create_game_objects, :create_game_objects)
  end
  
  unless self.method_defined?(:pk8_selfdata_make_save_contents)
    alias_method(:pk8_selfdata_make_save_contents, :make_save_contents)
  end
  
  unless self.method_defined?(:pk8_selfdata_extract_save_contents)
    alias_method(:pk8_selfdata_extract_save_contents, :extract_save_contents)
  end
  
  def create_game_objects
    pk8_selfdata_create_game_objects
    $game_self_variables = Game_SelfVariables.new
    $game_self_metadata = Game_SelfMetadata.new
  end
  
  def make_save_contents
    contents = pk8_selfdata_make_save_contents
    contents[:self_variables] = $game_self_variables
    contents[:self_metadata] = $game_self_metadata
    contents
  end
  
  def extract_save_contents(contents)
    pk8_selfdata_extract_save_contents(contents)
    $game_self_variables = contents[:self_variables]
    $game_self_metadata = contents[:self_metadata]
  end
  
  alias theo_limited_item_load_db load_database
  def load_database
    theo_limited_item_load_db
    load_limited_slot
  end
  
  def load_limited_slot
    database = $data_actors + $data_classes + $data_weapons + $data_armors + 
      $data_states + $data_items
    database.compact.each do |db|
      db.load_limited_inv
    end
  end
end