# encoding: utf-8
# Name: 115_4. Status Mini Dialogue
# Size: 13690
# encoding: utf-8
# Name: 115_4.상태 미니 대사
# Size: 13454
class Game_Map
  def rose_actor_mrbt(battler)
    text = []
    
    # 자녀인지 확인
    if $game_actors[battler.id].nickname == "아들" or $game_actors[battler.id].nickname == "딸"
      at_typ = 1
    else
      at_typ = 0
    end
    # 성별 확인
    if $game_actors[battler.id].set_custom_bio[1] == "인간, 남성"
      at_sex = 0
    else
      at_sex = 1
    end
    
    # Silencio
    if battler.state?(4)
      text.push('¡Mmm! ¡Mmm!', '¡Mmm!')
    end
    # Sueño
    if battler.state?(6)
      # Si es un niño
      if at_typ == 1
        text.push('Mamá, tengo sueño....', 'Mamá, hmm... tengo sueño....')
      else
        text.push('Tengo sueño....', 'Hmm, hmm....')
      end
    end
    # Embriaguez
    if battler.state?(149)
      text.push('¡No estoy borracho todavía!', '¡Dame otra copa!', 'Me estoy... emborrachando....', '¡Ahh... me siento bien!', 'Ugh, estoy mareado....')
    end
    # Aturdimiento
    if battler.state?(8)
      # Si es un niño
      if at_typ == 1
        text.push('¡Mamá, todo da vueltas!', 'Estoy mareado....', '¡Mamá, estoy mareado!')
      else
        text.push('Ugh... todo da vueltas....', 'Estoy mareado....')
      end
    end
    # Ansiedad
    if battler.state?(30)
      if at_typ == 1
        text.push('Mamá, estoy cansado....', 'No quiero hacerlo....', 'Mamá....', 'Estoy cansado....', '¡Quiero jugar!')
      elsif at_sex == 1
        text.push('¿Podré hacerlo...?', 'Si lo hubiera sabido....', 'Debería haber cobrado más....', '¿Qué estoy haciendo aquí...?', 'Es demasiado difícil....')
      else
        text.push('No puedo hacerlo....', 'Todos vamos a morir....', '¡Quiero rendirme!', '¿Por qué estoy aquí...?', 'Estoy aburrido....', '¡Todos vamos a morir!')
      end
    end
    # Miedo
    if battler.state?(138)
      if at_typ == 1
        text.push('¡Mamá, sálvame!', '¡Sálvame!', '¡Duele!', '¡Mamá, me duele!', '¡Mamá, me duele!', '¡Tengo miedo!', '¡Mamá!', '¡Mamá, mamá!')
      elsif at_sex == 1
        text.push('¡No quiero morir todavía!', '¡Sálvame, por favor!', '¡Poción!', '¡Cúrame!', '¿Vas a matarme?', '¡Sálvame, por favor!', 'Debería haber cobrado más!', '¡Por favor!', '¡Debí cobrar más!')
      else
        text.push('¡No quiero morir todavía!', '¡Sálvame, por favor!', '¡Poción!', '¡Cúrame!', '¿Vas a matarme?', '¡Sálvame, por favor!', '¡Por favor!', '¡Sálvame una vez más!')
      end
    end
    # Congelación
    if battler.state?(133)
      if at_typ == 1
        text.push('¡Estoy congelado!', '¡No puedo moverme!', '¡Mi cuerpo...!', '¡A... Aachoo!', 'Tengo frío....', '¡Hace mucho frío....', '¡Tengo frío!')
      elsif at_sex == 1
        text.push('¡Estoy congelada!', '¡No puedo moverme!', 'Debería haber cobrado más....', '¡Mi hermoso cuerpo....', '¡A... Aachoo!', '¡Hasta mis pantalones están congelados....', 'Hace mucho frío....', 'Tengo frío....')
      else
        text.push('¡Estoy congelado!', '¡No puedo moverme!', '¡Mi cuerpo...!', '¡A... Aachoo!', 'Tengo frío....', '¡Hace mucho frío....', '¡Tengo frío!')
      end
    end
    # Petrificación
    if battler.state?(11)
      if at_typ == 1
        text.push('¡Estoy paralizado!', '¡No puedo moverme!', '¡Mi cuerpo...!', '¡Mamá, sálvame!')
      elsif at_sex == 1
        text.push('¡Estoy paralizada!', '¡No puedo moverme!', 'Debería haber cobrado más....', '¡Mi hermoso cuerpo....', '¡Petrificación!')
      else
        text.push('¡Estoy paralizado!', '¡No puedo moverme!', '¡Mi cuerpo...!', '¡Petrificación!')
      end
    end
    # Quemadura
    if battler.state?(132)
      if at_typ == 1
        text.push('¡Está caliente!', '¡Mamá, estoy en llamas!', '¡Agua!')
      elsif at_sex == 1
        text.push('¡Está caliente!', '¡No mi cabello!', '¡Debería haber cobrado más!', '¡Estoy en llamas!', '¡Agua!')
      else
        text.push('¡Está caliente!', '¡Oye, estoy en llamas!', '¡Agua!')
      end
    end
    # Calma
    if battler.state?(18)
      if at_typ == 1
        text.push('¡La barriga de mamá es suave!', '¡Me gusta estar al lado de mamá!', '¡Hua!')
      elsif at_sex == 1
        text.push('Envidio tu pecho....', 'Mi cabello es más bonito.', 'Me gusta esta vida nómada.')
      else
        text.push('Esta vida no está tan mal....', 'Ahora me siento mejor.', 'Hmm....')
      end    
	end
    # 발정
    if battler.state?(23)
      $game_variables[275] = 0
      $game_variables[276] = 0
      $game_map.events.values.each do |event|
        if $game_player.obj_size?(event, 8)
          if event.name =~ /<enemy: /i
            $game_variables[275] += 1 if !event.battler.object
          elsif event.name =~ /EV/i or event.name =~ /<enemy: 28>/i or event.name =~ /여관/i or event.name =~ /창문/i or event.name =~ /문/i
          else
            $game_variables[276] += 1
          end
        end
      end
      # 성 경험 있다.
      if battler.id == 7
        if $game_actors[battler.id].set_custom_bio[4].to_i + $game_actors[battler.id].set_custom_bio[5].to_i + $game_actors[battler.id].set_custom_bio[6].to_i >= 1
          if $game_variables[275] == 0 and $game_variables[276] == 0
            text.push('Quiero ponerlo dentro....', 'Mi corazón late con fuerza....', 'Quiero hacerlo....', 'Me estoy volviendo loco por las cosquillas....')
          elsif $game_variables[275] != 0
            # Coto de caza
            text.push('Al menos debería ser humano....', 'No, debo aguantar....', 'Quiero ponerlo dentro....', 'Mi corazón late con fuerza....', 'Quiero hacerlo....', 'Me estoy volviendo loco por las cosquillas....')
          elsif $game_variables[276] != 0
            # Hay NPCs alrededor
            text.push('Se ve bastante grande....', '¿Será compatible conmigo?', 'He encontrado a un hombre guapo....', 'Quiero ponerlo dentro....', 'Mi corazón late con fuerza....', 'Quiero hacerlo....', 'Me estoy volviendo loco por las cosquillas....')
          end
        else
          text.push('Mi cuerpo está caliente....', 'Mi corazón late con fuerza....', '¿Qué le pasa a mi cuerpo?', '¿Estoy enfermo?')
        end
      else
        if $game_actors[battler.id].set_custom_bio[4].to_i + $game_actors[battler.id].set_custom_bio[5].to_i + $game_actors[battler.id].set_custom_bio[6].to_i + $game_actors[battler.id].set_custom_bio[20].to_i >= 1
          if at_sex == 1
            if $game_variables[275] == 0 and $game_variables[276] == 0
              text.push('Quiero ponerlo dentro....', 'Mi corazón late con fuerza....', 'Quiero hacerlo....', 'Me estoy volviendo loca por las cosquillas....')
            elsif $game_variables[275] != 0
              # Coto de caza
              text.push('Al menos debería ser humano....', 'No, debo aguantar....', 'Quiero ponerlo dentro....', 'Mi corazón late con fuerza....', 'Quiero hacerlo....', 'Me estoy volviendo loca por las cosquillas....')
            elsif $game_variables[276] != 0
              # Hay NPCs alrededor
              text.push('Se ve bastante grande....', '¿Será compatible conmigo?', 'He encontrado a un hombre guapo....', 'Quiero ponerlo dentro....', 'Mi corazón late con fuerza....', 'Quiero hacerlo....', 'Me estoy volviendo loca por las cosquillas....')
            end
          else
            text.push('¡Quiero tener sexo!', '¿Qué tal si lo hacemos una vez?', 'Descansemos un poco... ¿sí?', '¡Ahh, el olor de una hembra!')
          end
        else
          # Si es un niño
          if at_typ == 1
            # Sin experiencia sexual
            if at_sex == 1
              text.push('¡Mamá, mi cuerpo está caliente!', '¡Mamá, me pica aquí!', 'Quiero tocar....', 'Hmm....', 'Algo, algo está mal....')
            else
              text.push('¡Mamá! ¡Mi pito está duro!', '¡Mamá! ¡Mi pito se ha agrandado!', '¡Se siente raro!', '¡Toca mi pito!', '¡Quiero hacer pis!')
            end
          else
            # Sin experiencia sexual
            if at_sex == 1
              text.push('Mi cuerpo está caliente....', 'Mi corazón late con fuerza....', '¿Qué le pasa a mi cuerpo?', '¿Estoy enferma?')
            else
              text.push('¡Ah, quiero tener sexo!', '¿No me dejarías hacerlo una vez?', 'Descansemos un poco....', 'Ahh....')
            end
          end
        end
      end
    end
    # 배고픔
    if ($game_actors[battler.id].hunger_rate).to_i >= 70 or battler.state?(26)
      if at_typ == 1
        text.push('Mamá, tengo hambre....', 'Mamá, dame comida!', 'Mamá, ¿no hay nada para comer?', '¡Vamos a comer! ¡Comida!', '¡Tengo hambre!')
      elsif at_sex == 1
        text.push('¿No tienes hambre?', '¿No hay nada para comer?', 'Creo que necesito comer algo....', 'Tengo hambre....', 'Necesito comer algo....', 'Estoy tan hambrienta que me voy a desmayar....')
      else
        text.push('¡Vamos a comer!', '¡Tengo hambre!', '¡Necesito carne!', '¡Dame comida!', 'Tengo hambre....', '¿No hay nada para comer?', 'Necesito comer algo....', 'Estoy tan hambriento que me voy a desmayar....', '¡Tengo hambre!')
      end
    end
    # Fatiga
    if ($game_actors[battler.id].sleep_rate).to_i >= 70 or battler.state?(28)
      if at_typ == 1
        text.push('Mamá, tengo sueño....', 'Hmm, tengo sueño....', '¡Mamá! ¡Mamá!')
      elsif at_sex == 1
        text.push('¿Qué tal si descansamos un poco?', 'Descansemos....', 'Estoy muy cansada....', 'Quiero descansar....', 'Estoy cansada....', '¿Podemos descansar un poco?')
      else
        text.push('¡Estoy cansado!', 'Descansemos....', '¿No piensas descansar un poco?', 'Necesito descansar....', 'Estoy cansado....', '¡Estoy cansado!')
      end
    end
    # Calor
    if $game_actors[battler.id].temper.to_i >= 60
      text.push('Hace calor....', 'Hace mucho calor....', '¡Hace calor!')
    end
    # Frío
    if 45 >= $game_actors[battler.id].temper.to_i
      if at_typ == 1
        text.push('Mamá, tengo frío....', 'Hace mucho frío....', '¡Tengo frío....', '¡Hace frío!')
      elsif at_sex == 1
        text.push('Brr, tengo frío....', 'Hace mucho frío....', '¿No tienes frío?', 'Creo que me voy a resfriar.')
      else
        text.push('Brr, tengo frío....', 'Tengo frío....', 'Hace mucho frío....', '¡Hace frío!')
      end
    end
    # Mal olor
    if battler.state?(134)
      # Si es un niño
      if at_typ == 1
        text.push('¡Uf! ¡Qué mal olor!', '¡Huele mal!', '¡Está sucio!', '¡El olor es desagradable!')
      else
        text.push('Debería lavarme en el río....', '¡Está sucio!', 'Uf, necesito lavarme....')
      end
    end
    # Resfriado
    if battler.state?(79)
      text.push('¡A... Aachoo!', 'Ugh, resfriado....')
    end
    # Ceguera
    if battler.state?(3)
      # Si es un niño
      if at_typ == 1
        text.push('¡Mamá! ¡No puedo ver!', '¡Mamá! ¡No puedo ver!')
      else
        text.push('¡Uf!', '¡No, no puedo ver!')
      end
    end
    # Confusión
    if battler.state?(5)
      text.push('¿?!', '¿Quién eres tú?', '¿Eres un enemigo?!')
    end
    # Ira
    if battler.state?(12)
      text.push('¡Voy a matarte!', '¡Maldita sea!', '¡Lárgate!')
    end
    # Hemorragia
    if battler.state?(13)
      # Si es un niño
      if at_typ == 1
        text.push('Mamá, estoy sangrando....', '¡Mamá! ¡Estoy sangrando!')
      else
        text.push('¡Voy a morir por la hemorragia!', '¡Vendaje!', '¡Necesito un vendaje!')
      end
    end
    # Mojado
    if battler.state?(24)
      if at_typ == 1
        text.push('¡Estoy incómodo por estar mojado!', '¡Mamá! ¡Mi ropa está toda mojada!', '¡Estoy todo mojado!')
      elsif at_sex == 1
        text.push('Mi ropa está toda mojada....', 'Estoy incómoda por estar mojada....', 'Es incómodo estar mojada.', 'Uf, estoy empapada....', 'Incluso mis bragas están mojadas....')
      else
        text.push('Mi ropa está toda mojada....', 'Estoy incómodo por estar mojado....', 'Uf, estoy empapado....', '¡Estoy todo mojado!')
      end
    end
    # Sed
    if battler.state?(27)
      if at_typ == 1
        text.push('Mamá, ¡agua!', '¡Tengo sed!', '¿No hay agua, mamá?')
      elsif at_sex == 1
        text.push('Por favor, dame agua....', 'Tengo sed....', '¿Hay agua?', 'Necesito algo para beber....')
      else
        text.push('¿No hay agua?', 'Tengo sed....', '¿No hay agua?', 'Necesito algo para beber....', '¡Agua!')
      end
    end
    # No puede correr
    if battler.state?(29) or battler.state?(118)
      if at_sex == 1
        text.push('No puedo correr ahora....', 'No puedo correr....', 'Mis piernas están pesadas....', 'Mi cuerpo está pesado....', 'No puedo correr....')
      else
        text.push('No puedo correr en este estado....', 'No puedo correr....', 'Mis piernas están pesadas....', 'Mi cuerpo está pesado....', '¡No puedo correr!')
      end
    end
    # Fatiga extrema
    if ($game_actors[battler.id].hunger_rate).to_i >= 70 and ($game_actors[battler.id].sleep_rate).to_i >= 70
      if at_typ == 1
        text.push('¡Mamá....', '¡Mamá, estoy cansado!', '¿Mamá?', '¡Tengo hambre y estoy cansado!')
      elsif at_sex == 1
        text.push('Tengo hambre y estoy cansada....', 'No tengo fuerzas....', 'Creo que me voy a desmayar....', 'Necesitamos descansar....')
      else
        text.push('¡Tengo hambre y estoy cansado!', '¡Comida! ¡Carne!', '¡Estoy cansado!', '¡Estoy cansado y hambriento!')
      end
    end
    
    text = text[rand(text.size)] if !text.empty?
  end
end