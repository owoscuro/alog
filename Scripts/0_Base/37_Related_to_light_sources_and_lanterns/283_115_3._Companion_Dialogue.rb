# encoding: utf-8
# Name: 115_3. Companion Dialogue
# Size: 16112
# encoding: utf-8
# Name: 115_3.동료 대화
# Size: 16459
class Game_Map
  def rose_actor_s326(battler)
    text = []
    
    # 자녀인지 확인
    if $game_actors[battler.id].nickname == "아들" or $game_actors[battler.id].nickname == "딸"
      at_typ = 1
    else
      at_typ = 0
    end
    # 성별 확인
    if $game_actors[battler.id].set_custom_bio[1] != "인간, 남성"
      at_sex = 0
    else
      at_sex = 1
    end
    
    if $game_actors[battler.id].skill_learn?($data_skills[533]) # 독선적인
      text.push('¿Otra vez molestando?', 'Hmm, ¿qué pasa ahora?')
    end
    if $game_actors[battler.id].skill_learn?($data_skills[534]) # 배신자
      text.push('Hmm… ¿qué ocurre?', 'Confía en mí y dime lo que sea, lo resolveré.')
    end
    if $game_actors[battler.id].skill_learn?($data_skills[535]) # 복수심이 강한
      text.push('¿Quieres que mate a ese tipo?')
    end
    if $game_actors[battler.id].skill_learn?($data_skills[536]) # 불안정한
      text.push('¿Q-q-qué pasa?', '¿Qué más tienes que decir?')
    end
    if $game_actors[battler.id].skill_learn?($data_skills[537]) # 음모를 꾸미는
      text.push('Sí, dime si necesitas algo.')
    end
    if $game_actors[battler.id].skill_learn?($data_skills[538]) # 우울한
      text.push('Sí… ¿qué pasa?', 'No me siento muy bien ahora mismo…')
    end
    if $game_actors[battler.id].skill_learn?($data_skills[539]) # 광기어린
      text.push('¿Qué necesitas?', '¡Solo dime! ¡Me encargaré de ello!')
    end
    if $game_actors[battler.id].skill_learn?($data_skills[540]) # 선정적인
      text.push('¿Hmm? (Mira al pecho.)', '¿Qué pasa? (Se acerca.)')
    end
    if $game_actors[battler.id].skill_learn?($data_skills[541]) # 지배적인
      text.push('¿Qué, tienes alguna queja?', '¿Otra vez?')
    end
    if $game_actors[battler.id].skill_learn?($data_skills[542]) # 신념이 강한
      text.push('¿No hay ningún problema, verdad?', 'El esfuerzo nunca traiciona.')
    end
    if $game_actors[battler.id].skill_learn?($data_skills[543]) # 냉철한
      text.push('Seamos breves, ¿qué necesitas?', 'Ahh, qué molesto…')
    end
    if $game_actors[battler.id].skill_learn?($data_skills[544]) # 유혹적인
      text.push('¡Te ves encantadora como siempre!', '¡Hueles bien hoy también!')
    end
    if $game_actors[battler.id].skill_learn?($data_skills[545]) # 미숙한
      text.push('¿Q-qué pasa? ¿Hice algo mal?')
    end
    if $game_actors[battler.id].skill_learn?($data_skills[546]) # 순수한
      text.push('¿Pasa algo?', '¿Necesitas algo?')
    end
    if $game_actors[battler.id].skill_learn?($data_skills[547]) # 적극적인
      text.push('¿Qué, por qué, tienes algo que decir? ¿Extensión de contrato?')
    end
    if $game_actors[battler.id].skill_learn?($data_skills[548]) # 자비로운
      text.push('Dime lo que necesites cuando quieras.')
    end
    if $game_actors[battler.id].skill_learn?($data_skills[549]) # 거만한
      text.push('Bien, ¿qué deseas?', '¿Necesitas mi ayuda de nuevo?')
    end
    if $game_actors[battler.id].skill_learn?($data_skills[550]) # 선한
      text.push('¿Necesitas algo?', '¿Hay algo en lo que pueda ayudarte?')
    end
    if $game_actors[battler.id].skill_learn?($data_skills[551]) # 영리한
      text.push('¿Necesitas algo?', 'Es mejor tener cuidado en lugares estrechos.')
    end
    if $game_actors[battler.id].skill_learn?($data_skills[532]) # 야심적인
      text.push('Si hay algún problema, dímelo, ¡yo lo resolveré!')
    end
  
    # 기본 인사
    if at_typ == 1
      text.push('¿Mamá? ¿Qué pasa?', '¿Eh? ¿Mamá?', '¿Por qué, mamá?')
    elsif at_sex == 0
      text.push('¿Hay algún problema?')
    else
      text.push('¿Qué pasa?')
    end
    
    # 날씨
    if at_typ == 1
      if $game_variables[12] == 1
        text.push('¡No quiero mojarme!', '¡No me gusta estar empapada!')
      elsif $game_variables[12] == 2
        text.push('¡Mamá, hoy solo descansemos! ¿Sí?', '¡Está lloviendo!')
      elsif $game_variables[12] == 3
        text.push('Ugh, mamá, hoy descansemos, ¿sí?', 'El cielo truena y me da miedo…')
      elsif $game_variables[12] == 4
        if $game_switches[86] == true
          text.push('¡Mamá, está nevando!', '¡Quiero tocar la nieve! ¡Vamos afuera, sí?')
        else
          text.push('¡Mamá, está nevando!', 'La nieve es fría, jeje. ¡A-achoo!')
        end
      end
    else
      if $game_variables[12] == 1
        text.push('Los días lluviosos no son tan malos…', 'Con la lluvia, todo está muy húmedo…')
      elsif $game_variables[12] == 2
        text.push('Está lloviendo bastante…', 'Cazar en un día así es complicado…')
      elsif $game_variables[12] == 3
        if $game_switches[86] == true
          text.push('¿Qué tal si nos movemos cuando mejore el tiempo?', 'Está lloviendo bastante…', 'Cazar en un día así es complicado…')
        else
          text.push('Creo que deberíamos encontrar un refugio de la lluvia.', 'Está lloviendo bastante…', 'Cazar en un día así es complicado…')
        end
      elsif $game_variables[12] == 4
        text.push('Hace frío y además nieva…', 'Cazar en un día así es complicado…')
      end
    end
    
    # 침묵
    if battler.state?(4)
      text.push('¡Mm! ¡Mmm!', '¡Mmm!')
    end
    # 수면
    if battler.state?(6)
      text.push('Tengo sueño… ¿qué pasa?', 'Mmm, mmm… ¿qué pasa?')
    end
    # 취기
    if battler.state?(149)
      text.push('¡Aún no estoy borracho!', '¡Dame otra copa!', 'Me estoy… mareando...', '¡Ah, me siento bien!', 'Ugh, estoy mareado...')
    end
    # 스턴
    if battler.state?(8)
      text.push('Ah… todo da vueltas...', 'Estoy mareado...', 'Hablemos más tarde...')
    end
    # 심신미약
    if battler.state?(30)
      if at_typ == 1
        text.push('¡Mamá, estoy cansada!', '¡No quiero hacerlo!', '¡Mamá, descansemos!', 'Estoy cansada…', '¡Quiero jugar!')
      elsif at_sex == 0
        text.push('¿Podré hacerlo…?', 'Si hubiera sabido esto…', 'Debería haber pedido más dinero…', '¿Qué estoy haciendo aquí…?', 'Estoy muy cansado...')
      else
        text.push('No voy a poder hacerlo…', 'Todos vamos a morir…', '¡Quiero renunciar!', '¿Por qué estoy aquí…?', 'Estoy harto…', '¡Todos vamos a morir!')
      end
    end
    # 공포
    if battler.state?(138)
      if at_typ == 1
        text.push('¡Mamá, sálvame!', '¡Sá… sálvame!', '¡Duele!', '¡Mamá! ¡Me duele!', '¡Ma… mamá, me duele!', '¡Tengo miedo!', '¡Aaaah, mamá!', '¡Mamá! ¡Mamá!')
      elsif at_sex == 0
        text.push('¡No quiero morir todavía!', '¡Sá… sálvame!', '¡Poción!', '¡Cúrame! ¡Cúrame!', '¿Estás tratando de matarme?!', '¡Sálvame!', 'Debería haber pedido más dinero…', '¡Por favor!', 'Debería pedir más dinero…')
      else
        text.push('¡No quiero morir todavía!', '¡Sá… sálvame!', '¡Poción!', '¡Cúrame! ¡Cúrame!', '¿Estás tratando de matarme?!', '¡Sálvame!', '¡Por favor!', '¡Sálvame una vez más!')
      end
    end
    # 빙결
    if battler.state?(133)
      if at_typ == 1
        text.push('¡Estoy congelada!', '¡No puedo moverme!', '¡Mi… mi cuerpo!', '¡A-achoo!', 'Hace frío…', 'Hace mucho frío…', '¡Hace frío!')
      elsif at_sex == 0
        text.push('¡Estoy congelada!', '¡No puedo moverme!', 'Debería haber pedido más dinero…', '¡Mi hermoso cuerpo…!', '¡A-achoo!', 'Hasta mis bragas están congeladas…', 'Hace mucho frío…', 'Hace frío…')
      else
        text.push('¡Estoy congelado!', '¡No puedo moverme!', '¡Mi… mi cuerpo!', '¡A-achoo!', 'Hace frío…', 'Hace mucho frío…', '¡Hace frío!')
      end
    end
    # 석화
    if battler.state?(11)
      if at_typ == 1
        text.push('¡Estoy petrificada!', '¡No puedo moverme!', '¡Mi… mi cuerpo!', '¡Mamá, sálvame!')
      elsif at_sex == 0
        text.push('¡Estoy petrificada!', '¡No puedo moverme!', 'Debería haber pedido más dinero…', '¡Mi hermoso cuerpo…!', '¡Pe… petrificada!')
      else
        text.push('¡Estoy petrificado!', '¡No puedo moverme!', '¡Mi… mi cuerpo!', '¡Pe… petrificado!')
      end
    end
    # 화상
    if battler.state?(132)
      if at_typ == 1
        text.push('¡Está caliente!', '¡Mamá! ¡Estoy en llamas!', '¡Agua!')
      elsif at_sex == 0
        text.push('¡Está caliente!', '¡No mi cabello!', 'Debería haber pedido más dinero…', '¡Estoy en llamas!', '¡Agua!')
      else
        text.push('¡Está caliente!', '¡Oye! ¡Estoy en llamas!', '¡Agua!')
      end
    end
    # 진정
    if battler.state?(18)
      if at_typ == 1
        text.push('¡La pancita de mamá es blandita!', '¡Me gusta estar al lado de mamá!', '¡Hua!')
      elsif at_sex == 0
        text.push('Ahora siento que puedo hacer cualquier cosa.', 'Mi cabello es el mejor.', 'Me gusta esta vida de vagabundo.')
      else
        text.push('Esta vida no está tan mal...', 'Ahora me siento bien.', 'Hmm…')
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
      if $game_actors[battler.id].set_custom_bio[4].to_i + $game_actors[battler.id].set_custom_bio[5].to_i + $game_actors[battler.id].set_custom_bio[6].to_i + $game_actors[battler.id].set_custom_bio[20].to_i >= 1
        if at_sex == 0
          if $game_variables[275] == 0 and $game_variables[276] == 0
            text.push('Quiero ponerlo dentro…', 'Mi corazón late con fuerza…', 'Quiero hacerlo…', 'Me pica y me vuelve loca…')
          elsif $game_variables[275] != 0
            # 사냥터
            text.push('Al menos debería ser una persona…', 'No, debo resistir…', 'Quiero ponerlo dentro…', 'Mi corazón late con fuerza…', 'Quiero hacerlo…', 'Me pica y me vuelve loca…')
          elsif $game_variables[276] != 0
            # 주변에 npc가 있다.
            text.push('Parece bastante grande…', '¿Me cabrá?', 'He encontrado un hombre guapo…', 'Quiero ponerlo dentro…', 'Mi corazón late con fuerza…', 'Quiero hacerlo…', 'Me pica y me vuelve loca…')
          end
        else
          text.push('¡Quiero tener sexo!', '¿Qué tal si te doy una descarga?', '¿Descansamos un poco…?', 'Ahh, ¡huele a hembra!')
        end
      else
        # 성 경험 없다.
        if at_sex == 0
          text.push('Mi cuerpo está caliente…', 'Mi corazón late con fuerza…', '¿Qué me pasa?', '¿Estaré enferma?')
        else
          text.push('Ah, quiero probar el sexo.', '¿No podrías dejarme hacerlo una vez?', 'Descansemos un poco…', 'Ahh…')
        end
      end
    end
    # 배고픔
    if ($game_actors[battler.id].hunger_rate).to_i >= 70 or battler.state?(26)
      if at_typ == 1
        text.push('¡Mamá, tengo hambre…!', '¡Mamá, dame de comer!', '¿Mamá, no tienes algo de comer?', '¡Comamos! ¡Comamos!', '¡Tengo hambre!')
      elsif at_sex == 0
        text.push('¿Tú no tienes hambre?', '¿No hay algo de comer?', 'Creo que necesitamos comer algo…', 'Tengo hambre…', 'Necesitamos comer algo…', 'Estoy tan hambrienta que me desmayaré…')
      else
        text.push('¡Comamos ya!', '¡Tengo hambre!', '¡Necesito carne!', '¡Dame comida!', 'Tengo hambre…', '¿No hay nada de comer?', 'Necesitamos comer algo…', 'Estoy tan hambriento que me desmayaré…', '¡Tengo hambre!')
      end
    end
    # 피로함
    if ($game_actors[battler.id].sleep_rate).to_i >= 70 or battler.state?(28)
      if at_typ == 1
        text.push('¡Mamá, tengo sueño…!', '¡Estoy muy cansada…!', '¡Mamá! ¡Mamá!')
      elsif at_sex == 0
        text.push('¿Qué tal si descansamos un poco?', 'Descansemos un poco…', 'Estoy muy cansada…', 'Quiero descansar…', 'Estoy cansada…', '¿Podemos descansar un poco?')
      else
        text.push('¡Estoy cansado!', 'Descansemos un poco…', '¿No podemos descansar un poco?', 'Necesito descansar…', '¡Estoy cansado…!', 'Estoy cansado…')
      end
    end
    # 덥다
    if $game_actors[battler.id].temper.to_i >= 60
      text.push('Hace calor… ¿hay algo de agua?', 'Hace mucho calor, ¿hay agua?', '¡Hace calor! ¡Dame agua!')
    end
    # 춥다
    if 45 >= $game_actors[battler.id].temper.to_i
      if at_typ == 1
        text.push('¡Mamá, tengo frío…!', 'Hace mucho frío…', '¡Fri… frío…!', '¡Hace frío!')
      elsif at_sex == 0
        text.push('Hace frío…', 'Hace mucho frío…', '¿No tienes frío?', 'Parece que voy a resfriarme.')
      else
        text.push('Hace frío…', 'Hace frío…', 'Hace mucho frío…', '¡Hace frío!')
      end
    end
    # 악취
    if battler.state?(134)
      text.push('Debería bañarme, este olor me marea.', '¡Estoy sucio!', 'Ugh, necesito un baño…')
    end
    # 감기
    if battler.state?(79)
      text.push('¡A-achoo! Bueno, ¿qué pasa?', 'Ugh, estoy resfriado… ¿hay medicina?')
    end
    # 실명
    if battler.state?(3)
      text.push('No puedo ver, ¿puedes ayudarme?', '¡No, no puedo ver!')
    end
    # 혼란
    if battler.state?(5)
      text.push('¿?!', '¡¿Quién eres tú?!', '¡¿Eres enemigo?!')
    end
    # 분노
    if battler.state?(12)
      text.push('¿Qué, quieres darme más dinero?', '¡Voy a matar a esos bastardos!', 'Maldita sea… ¿qué pasa ahora?')
    end
    # 출혈
    if battler.state?(13)
      text.push('¡Estoy sangrando! ¿No hay vendas?', '¡Vendas! ¿No hay vendas?', '¡Necesito vendas!')
    end
    # 젖음
    if battler.state?(24)
      if at_typ == 1
        text.push('¡Mamá! ¡Estoy toda mojada!', '¡Estoy empapada!')
      elsif at_sex == 0
        text.push('Me siento pegajosa por estar mojada.', 'Ugh, estoy empapada…', 'Hasta mis bragas están mojadas…')
      else
        text.push('Me siento pegajoso por estar mojado.', 'Ugh, estoy empapado…', '¡Estoy empapado!')
      end
    end
    # 목마름
    if battler.state?(27)
      if at_typ == 1
        text.push('¡Mamá, quiero agua!', '¡Tengo sed!', '¿No hay agua, mamá?')
      elsif at_sex == 0
        text.push('¿Me das un poco de agua…?', 'Tengo sed…', '¿No hay agua?', 'Necesito algo para beber...')
      else
        text.push('¿No hay agua?', 'Tengo sed…', '¿No hay agua?', 'Necesito algo para beber...', '¡Agua!')
      end
    end
    # 달리기 불가
    if battler.state?(29) or battler.state?(118)
      if at_sex == 0
        text.push('No puedo correr ahora mismo…', 'No puedo correr…', 'Mis piernas están pesadas…', 'Mi cuerpo está pesado…', 'No puedo correr…')
      else
        text.push('No puedo correr en este estado…', 'No puedo correr…', 'Mis piernas están pesadas…', 'Mi cuerpo está pesado…', '¡No puedo correr!')
      end
    end
    # 복합적으로 피곤하다.
    if ($game_actors[battler.id].hunger_rate).to_i >= 70 and ($game_actors[battler.id].sleep_rate).to_i >= 70
      if at_typ == 1
        text.push('Mamáaa…', '¡Mamá, estoy cansada!', '¿Eh? ¡Mamáaa?', '¡Tengo hambre! ¡Estoy cansada!')
      elsif at_sex == 0
        text.push('Tengo hambre y estoy cansada…', 'No tengo energía…', 'Siento que me desmayaré…', 'Deberíamos descansar un poco…')
      else
        text.push('¡Tengo hambre! ¡Estoy cansado!', '¡Comida! ¡Carne!', '¡Estoy cansado!', '¡Estoy hambriento y cansado!')
      end
    end
    
    $game_variables[421] = text[rand(text.size)].to_s if !text.empty?
  end
end