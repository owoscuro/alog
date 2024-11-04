# encoding: utf-8
# Name: 117_1.매춘시 대사
# Size: 2194
class Game_Map
  def rose_sex_room(index)
    text = []
    
    # 야외
    if index == 0
      if $game_variables[12] == 1
        text.push('¿Qué tal hacerlo bajo la lluvia? ¿No te excita?')
      elsif $game_variables[12] == 2
        text.push('Está lloviendo mucho, pero no importa, ¿verdad?')
      elsif $game_variables[12] == 3
        text.push('¡Este clima no me afecta en absoluto!')
      elsif $game_variables[12] == 4
        text.push('¿Qué tal bajo la nieve? Podría ser un poco romántico, ¿no? ¡Jajaja!')
      end
    else
      if $game_variables[12] != 0
        text.push('¿No somos animales para hacerlo afuera con este clima, verdad?')
      else
        text.push('Ahora que estamos solos, ¿por qué no empezamos rápido?', 'Quítate la ropa rápido, te lo haré como loca')
      end
    end
    
    # 취기
    if $game_actors[7].state?(149)
      text.push('¿Qué pasa, estás borracha? ¡Jajaja, no está mal!')
    end
    # 심신미약
    if $game_actors[7].state?(30)
      text.push('Ha sido difícil hasta ahora, ¿verdad? Olvida todo lo demás y siente mi calor.')
    end
    # 심신미약
    if $game_actors[7].state?(23)
      text.push('¿Ya estás mojada? Ya estás en celo, confía en mí.')
    end
    # 춥다
    if 45 >= $game_actors[7].temper.to_i
      text.push('¿Tu cuerpo está frío? ¡Te tengo que calentar rápido!')
    end
    # 악취
    if $game_actors[7].state?(134)
      text.push('Huele un poco, pero no te preocupes, no me importa eso. ¡Jajaja!')
    end
    # 감기
    if $game_actors[7].state?(79)
      text.push('¿Tienes un resfriado? Necesitas sudar mucho.')
    end
    # 출혈
    if $game_actors[7].state?(13)
      text.push('¿Estás sangrando mucho? No te preocupes, no te vas a morir, ¿verdad? ¡Jajaja!')
    end
    # 젖음
    if $game_actors[7].state?(24)
      text.push('¿Estás más excitada porque estás mojada? Vamos, empecemos rápido.')
    end
      
    $game_variables[421] = text[rand(text.size)].to_s if !text.empty?
  end
end