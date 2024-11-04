# encoding: utf-8
# Name: 115_2. Personal Dialogue
# Size: 9362
# encoding: utf-8
# Name: 115_2.본인 대화
# Size: 9651
class Game_Map
  def rose_actor_insp(battler)
    text = []
    
    # 내부인 경우
    #if $game_switches[86] == true
      $game_map.events.values.each do |event|
        if $game_player.obj_size?(event, 7)
          if event.name =~ /비밀통로/i
            if $game_player.obj_size?(event, 3)
              text.push('Se oye el sonido del viento a tu alrededor, parece que hay un camino cerca…')
            elsif $game_player.obj_size?(event, 5)
              text.push('Escuchas el sonido del viento desde algún lugar…')
            else
              text.push('El sonido del viento se escucha débilmente…')
            end
          end
        end
      end
    #end
    
    # 입력된 대사가 없는 경우
    if text.empty?
      $game_map.events.values.each do |event|
        if $game_player.obj_size?(event, 7)
          if event.name =~ /<enemy: 10>/i
            text.push('Podría haber una trampa cerca, movámonos con cuidado…')
          elsif event.name =~ /<enemy: 28>/i
            text.push('Es cálido por el fuego.')
          elsif event.name =~ /<enemy: 110>/i
            text.push('Ugh, esto huele a cadáver… Movámonos con cuidado…')
          elsif event.name =~ /빛/i
            text.push('Luz cálida…')
          elsif event.name =~ /삶의 저울/i
            text.push('Se siente una energía extraña…')
          elsif event.name =~ /<enemy: 88>/i or event.name =~ /<enemy: 89>/i or event.name =~ /<enemy: 90>/i
            text.push('Ugh, esto huele a cadáver… Movámonos con cuidado…')
          elsif event.name =~ /<enemy: 135>/i
            text.push('Una puerta de metal… No sé por qué está aquí, pero no la abras sin permiso.')
          elsif event.name =~ /<enemy:/i
            text.push('¿Un monstruo cerca? De cualquier manera… hay algo, tengamos cuidado…')
          end
        end
      end
    end
    
    # 위 진행해도 아무 대사도 없는 경우
    text.push('No hay nada en particular que me llame la atención…')  if text.empty?
      
    $game_variables[421] = text[rand(text.size)].to_s if !text.empty?
  end
  
  def rose_actor_s7(battler)
    text = []
    
    # 기본 대사
    text.push('Huu….')

    if $game_actors[battler.id].skill_learn?($data_skills[203]) # 착유
      text.push('Me pica el pecho…')
    end
    
    # 날씨
    if $game_variables[12] == 1
      text.push('Un día con lluvia no está tan mal…', 'Con la lluvia, el aire se siente húmedo…')
    elsif $game_variables[12] == 2
      text.push('Está lloviendo bastante…', 'Cazar en un día así es complicado…')
    elsif $game_variables[12] == 3
      if $game_switches[86] == true
        text.push('Saldré cuando mejore el clima…', 'Está lloviendo bastante…', 'Cazar en un día así es complicado…')
      else
        text.push('Debería buscar un refugio para la lluvia…', 'Está lloviendo bastante…', 'Cazar en un día así es complicado…')
      end
    elsif $game_variables[12] == 4
      text.push('Hace frío y encima neva…', 'Cazar en un día así es complicado…')
    end
    
    # 침묵
    if battler.state?(4)
      text.push('Mm! Mmm!', 'Mmm?!')
    end
    # 수면
    if battler.state?(6)
      text.push('Tengo mucho sueño ahora…', 'Mmm, mmm…')
    end
    # 취기
    if battler.state?(149)
      text.push('Ah, ¡aún no estoy borracha! ¡Puedo tomar más!', 'Creo que puedo tomar una copa más.', 'Estoy… borracha...', '¡Hmmm, qué bien se siente!', 'Ugh, me siento mareada…')
    end
    # 스턴
    if battler.state?(8)
      text.push('Ugh… todo da vueltas…', 'Estoy mareada…')
    end
    # 심신미약
    if battler.state?(30)
      text.push('¿Podré hacerlo…?', 'Si hubiera sabido esto...', 'Debería haber pedido más dinero...', '¿Qué estoy haciendo aquí…?', 'Esto es demasiado difícil…')
    end
    # 공포
    if battler.state?(138)
      text.push('¡No quiero morir aún!', '¡Ayúdame!', '¡Poción!', '¡Sáname! ¡Cúrame!', '¡Sálvame!', '¡Por favor!', '¡Sólo una vez, sálvame!')
    end
    # 빙결
    if battler.state?(133)
      text.push('¡Estoy congelada!', '¡No puedo moverme!', '¡Mi cuerpo…!', '¡Achú!', 'Hace frío…', 'Está muy frío...', '¡Hace frío!')
    end
    # 석화
    if battler.state?(11)
      text.push('¡Estoy petrificada!', '¡No puedo moverme!', '¡Mi cuerpo…!', '¡Petrificación!')
    end
    # 화상
    if battler.state?(132)
      text.push('¡Está caliente!', '¡No mi cabello!', 'Debería haber pedido más dinero!', '¡Estoy en llamas!', '¡Agua!')
    end
    # 진정
    if battler.state?(18)
      text.push('Hoy me siento bien.', '¿Qué comeré hoy?', 'Este estilo de vida errante no es tan malo.')
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
      if $game_actors[battler.id].set_custom_bio[4].to_i + $game_actors[battler.id].set_custom_bio[5].to_i + $game_actors[battler.id].set_custom_bio[6].to_i >= 1
        if $game_variables[275] == 0 and $game_variables[276] == 0
          text.push('Quiero que lo metan dentro…', 'Mi corazón late muy rápido…', 'Quiero hacerlo…', 'La comezón me está volviendo loca…')
          if $game_actors[battler.id].skill_learn?($data_skills[202]) # 자위
            text.push('Quizás debería masturbarme un poco después...')
          end
        elsif $game_variables[275] != 0
          # 사냥터
          text.push('Al menos debería ser una persona…', 'No, debo aguantarme…', 'Quiero que lo metan dentro…', 'Mi corazón late muy rápido…', 'Quiero hacerlo…', 'La comezón me está volviendo loca…')
        elsif $game_variables[276] != 0
          # 주변에 npc가 있다.
          text.push('Se ve bastante grande…', '¿Será adecuado para mí?', 'Vi a un chico guapo...', 'Quiero que lo metan dentro…', 'Mi corazón late muy rápido…', 'Quiero hacerlo…', 'La comezón me está volviendo loca…')
        end
      else
        if $game_actors[battler.id].skill_learn?($data_skills[202]) # 자위
          text.push('Quiero aliviarme un poco…', 'Masturbarse demasiado no es bueno…', 'Quizás debería masturbarme un poco después…', '¡Esta libido! ¡Tengo que masturbarme…!')
        else
          text.push('Me siento caliente…', 'Mi corazón late muy rápido…', '¿Qué me pasa?', '¿Estaré enferma?')
        end
      end
    end
    # 배고픔
    if ($game_actors[battler.id].hunger_rate).to_i >= 70 or battler.state?(26)
      text.push('Tengo hambre, necesito comer algo…', '¿No había comida?', 'Creo que necesito comer algo…', 'Tengo hambre…', 'Necesito comer algo…', 'Me muero de hambre…')
    end
    # 피로함
    if ($game_actors[battler.id].sleep_rate).to_i >= 70 or battler.state?(28)
      text.push('Necesito descansar un poco…', 'Vamos a descansar un poco…', 'Estoy muy cansada…', 'Quiero descansar…', 'Estoy cansada…')
    end
    # 덥다
    if $game_actors[battler.id].temper.to_i >= 60
      text.push('Hace calor… ¿no hay agua fría?', 'Hace mucho calor, ¿hay agua?', '¡Hace calor! Pero no puedo quitarme la ropa…')
    end
    # 춥다
    if 45 >= $game_actors[battler.id].temper.to_i
      text.push('Brr, hace frío…', 'Hace mucho frío…', 'Hace frío…', 'Creo que me voy a enfermar…')
    end
    # 악취
    if battler.state?(134)
      text.push('Necesito una ducha, creo que huelo mal…', 'Ugh, debería lavarme un poco…')
    end
    # 감기
    if battler.state?(79)
      text.push('¡Achú!', 'Ugh, un resfriado… ¿Había medicina para el resfriado?')
    end
    # 실명
    if battler.state?(3)
      text.push('¡No veo nada!')
    end
    # 혼란
    if battler.state?(5)
      text.push('¿?!', 'Estoy mareada...', '¡No puedo concentrarme!')
    end
    # 분노
    if battler.state?(12)
      text.push('¡Voy a matar a esos bastardos!', 'Maldita sea…')
    end
    # 출혈
    if battler.state?(13)
      text.push('Estoy sangrando mucho, ¿hay vendajes?', '¡Vendajes! ¿No hay vendajes?', '¡Necesito vendajes!')
    end
    # 젖음
    if battler.state?(24)
      text.push('Estoy mojada, qué incómodo…', 'Ugh, estoy empapada…', 'Mi ropa interior está completamente mojada…')
    end
    # 목마름
    if battler.state?(27)
      text.push('Necesito beber agua…', 'Estoy sedienta…', '¿Había agua?', 'Necesito algo para beber…')
    end
    # 복합적으로 피곤하다.
    if ($game_actors[battler.id].hunger_rate).to_i >= 70 and ($game_actors[battler.id].sleep_rate).to_i >= 70
      text.push('Tengo hambre y estoy cansada…', 'No tengo energía…', 'Creo que me voy a desmayar…', 'Necesito descansar un poco…')
    end
    
    $game_variables[421] = text[rand(text.size)].to_s if !text.empty?
  end
end