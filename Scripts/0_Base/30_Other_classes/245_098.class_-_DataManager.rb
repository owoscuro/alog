# encoding: utf-8
# Name: 098.class - DataManager
# Size: 1424
class << Graphics
  alias falcaopearl_antilag_g resize_screen
  def resize_screen(w, h)
    falcaopearl_antilag_g(w, h)
    print("098.class << DataManager - ");
    print("스크린 사이즈 갱신 \n");
    $game_map.set_max_screen unless $game_map.nil?
  end
end

class << DataManager
  alias :szs_factions_create_game_objects :create_game_objects
  alias :szs_factions_make_save_contents :make_save_contents
  alias :szs_factions_extract_save_contents :extract_save_contents
  alias :szs_factions_setup_new_game :setup_new_game
  
  def create_game_objects
    szs_factions_create_game_objects
    $game_factions = Game_Factions.new
  end
  
  def make_save_contents
    contents = szs_factions_make_save_contents
    contents[:factions] = $game_factions
    contents
  end
  
  def extract_save_contents(contents)
    szs_factions_extract_save_contents(contents)
    $game_factions = contents[:factions]
  end
  
  def setup_new_game
    print("098.class << DataManager - ");
    print("새로운 게임을 생성한다. \n");
    szs_factions_setup_new_game
    SZS_Factions::Factions.select{|f| f[:discovered]}.each do |f|
      $game_factions[SZS_Factions::Factions.index(f)]
    end
  end
  
  alias falcaopearl_extract extract_save_contents
  def DataManager.extract_save_contents(contents)
    falcaopearl_extract(contents)
    $game_temp.loadingg = true
  end
end