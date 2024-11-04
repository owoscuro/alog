# # encoding: utf-8
# # Name: 093.Plane_FOG
# # Size: 2640
# class Plane_FOG < Plane 
#   def initialize(fog_id = "", fog_type)
#     return unless fog_id != ""
#     return if $BTEST
#     super
#     if $game_switches[30] == false
#       if fog_id == "cloud>"
#         if $game_variables[12] != 0
#           @fog_a_name = "cloud_w"
#         else
#           @fog_a_name = "cloud"
#         end
#       elsif fog_id == "cloud_w>"
#         if $game_variables[12] == 0
#           @fog_a_name = "cloud"
#         else
#           @fog_a_name = "cloud_w"
#         end
#       elsif fog_id == "cloud_2>"
#         if $game_variables[12] != 0
#           @fog_a_name = "cloud_2_w"
#         else
#           @fog_a_name = "cloud_2"
#         end
#       elsif fog_id == "cloud_2_w>"
#         if $game_variables[12] == 0
#           @fog_a_name = "cloud_2"
#         else
#           @fog_a_name = "cloud_2_w"
#         end
#       elsif fog_id == "Fog_B>"
#         @fog_a_name = "Fog_B"
#       elsif fog_id == "Fog_C>"
#         @fog_a_name = "Fog_C"
#       end
#       self.bitmap = Cache.parallax(@fog_a_name)
#       @fog_type = fog_type
#       initialize_values
#       update
#     end
#   end

#   def initialize_values
#     case @fog_type
#     when :type_a
#       self.z = 1
#       self.opacity = $game_map.fog_a_opacity   
#       self.color = $game_map.fog_a_color if $game_map.fog_a_color != nil
#     when :type_b
#       self.z = 1
#       self.opacity = $game_map.fog_b_opacity
#       self.color = $game_map.fog_b_color if $game_map.fog_b_color != nil
#     when :type_c
#       self.z = 1
#       self.opacity = $game_map.fog_c_opacity      
#       self.color = $game_map.fog_c_color if $game_map.fog_c_color != nil
#     end
#   end

#   def get_position_update
#     case @fog_type
#     when :type_a
#       self.ox = $game_map.fog_a_x * 32 + $game_map.fog_a_move[0]
#       self.oy = $game_map.fog_a_y * 32 + $game_map.fog_a_move[1]
#     when :type_b
#       self.ox = $game_map.fog_b_x * 32 + $game_map.fog_b_move[0]
#       self.oy = $game_map.fog_b_y * 32 + $game_map.fog_b_move[1]
#     when :type_c
#       self.ox = $game_map.fog_c_x * 32 + $game_map.fog_c_move[0]
#       self.oy = $game_map.fog_c_y * 32 + $game_map.fog_c_move[1]
#     end
#   end  
  
#   def update
#     return if self.disposed?
#     get_position_update
#     case @fog_type
#     when :type_a
#       self.opacity = $game_map.fog_a_opacity if self.opacity != $game_map.fog_a_opacity
#     when :type_b
#       self.opacity = $game_map.fog_b_opacity if self.opacity != $game_map.fog_b_opacity
#     when :type_c
#       self.opacity = $game_map.fog_c_opacity if self.opacity != $game_map.fog_c_opacity
#     end
#   end  

#   def dispose
#     super
#   end
# end