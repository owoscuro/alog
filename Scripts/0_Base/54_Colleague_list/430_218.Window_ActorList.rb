# encoding: utf-8
# Name: 218.Window_ActorList
# Size: 1384
class Window_ActorList < Window_Selectable
  def initialize
    super(0,0,176,Graphics.height)
    activate
    select(0)
    refresh
  end
  
  def make_item_list
    @data = $data_actors.select {|actor| 
    actor.nil? ? false : actor.name != nil and actor.name != "" and actor.id != 7 and 14 >= actor.id
    #actor.nil? ? false : $game_actors[actor.id].name != nil and $game_actors[actor.id].name != "" and actor.id != 7 and 14 >= actor.id
    }
    #@data.sort! {|a, b| a.roster_number - b.roster_number }

    if $game_variables[160] != nil and $game_variables[160] != 0
      i = 0
      print("218.Window_ActorList - %s \n" % [@data.length]);
      for actor in @data
        if actor.id == $game_variables[160]
          select(i)
          break
        end
        i += 1
      end
    end
  end
  
  def draw_item(index)
    actor = @data[index]
    if actor
      rect = item_rect(index)
      rect.x += 4
      if $game_actors[actor.id].discovered
        change_color(normal_color)
        draw_text(rect, actor.name, 1)
      else
        change_color(normal_color, false)
        draw_text(rect, "?????", 1)
      end
    end
  end
  
  def refresh
    make_item_list
    draw_all_items
  end
  
  def item_max
    @data ? @data.size : 0
  end
  
  def current_actor
    $game_actors[@data[@index].id]
  end
end