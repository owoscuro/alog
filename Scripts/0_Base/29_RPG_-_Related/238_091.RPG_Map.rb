# encoding: utf-8
# Name: 091.RPG_Map
# Size: 2074
$imported = {} if $imported.nil?
$imported[:Dekita_FOG] = true

class RPG::Map
  attr_reader(:can_fog)
  attr_reader(:fog_a_name)
  attr_reader(:fog_a_move)
  attr_reader(:fog_a_opac)
  attr_reader(:fog_a_z)
  attr_reader(:fog_a_color)
  attr_reader(:fog_b_name)
  attr_reader(:fog_b_move)
  attr_reader(:fog_b_opac)
  attr_reader(:fog_b_z)
  attr_reader(:fog_b_color)
  attr_reader(:fog_c_name)
  attr_reader(:fog_c_move)
  attr_reader(:fog_c_opac)
  attr_reader(:fog_c_z)
  attr_reader(:fog_c_color)
  
  def get_fog_info
    print("091.RPG::Map - ");
    print("포그를 정보를 획득한다. \n");
    
    @can_fog = false;
    
    @fog_a_name = ""; @fog_a_move = [0, 0]
    @fog_a_opac = 255; @fog_a_z = 1; @fog_a_color = nil
    
    @fog_b_name = ""; @fog_b_move = [0, 0]
    @fog_b_opac = 255; @fog_b_z = 1; @fog_b_color = nil
    
    @fog_c_name = ""; @fog_c_move = [0, 0]
    @fog_c_opac = 255; @fog_c_z = 1; @fog_c_color = nil
    
    self.note.split(/[\r\n]+/).each { |line| case line
    when /<fog a: (.*)/i ; @can_fog = true ; @fog_a_name = $1.to_s
    when /<a move: (.*), (.*)>/i ; @fog_a_move = [$1.to_i, $2.to_i]
    when /<a opac: (.*)/i ; @fog_a_opac = $1.to_i
    when /<a z: (.*)/i ; @fog_a_z = 1
    when /<a col: (.*),(.*),(.*),(.*)>/im
      @fog_a_color = Color.new($1.to_i,$2.to_i,$3.to_i,$4.to_i)
    when /<fog b: (.*)/i ; @can_fog = true ; @fog_b_name = $1.to_s
    when /<b move: (.*), (.*)>/i ; @fog_b_move = [$1.to_i, $2.to_i]
    when /<b opac: (.*)/i ; @fog_b_opac = $1.to_i
    when /<b z: (.*)/i ; @fog_b_z = 1
    when /<b col: (.*),(.*),(.*),(.*)>/im
      @fog_b_color = Color.new($1.to_i,$2.to_i,$3.to_i,$4.to_i)
    when /<fog c: (.*)/i ; @can_fog = true ; @fog_c_name = $1.to_s
    when /<c move: (.*), (.*)>/i ; @fog_c_move = [$1.to_i, $2.to_i]
    when /<c opac: (.*)/i ; @fog_c_opac = $1.to_i
    when /<c z: (.*)/i ; @fog_c_z = 1
    when /<c col: (.*),(.*),(.*),(.*)>/im
      @fog_c_color = Color.new($1.to_i,$2.to_i,$3.to_i,$4.to_i)
    end ; }
  end   
end