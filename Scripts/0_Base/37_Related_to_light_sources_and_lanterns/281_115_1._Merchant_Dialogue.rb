# encoding: utf-8
# Name: 115_1. Merchant Dialogue
# Size: 45066
# encoding: utf-8
# Name: 115_1.상인 대사
# Size: 48819
class Game_Map
  def rose_actor_merchant
    text = []
    text2 = []
    
    # 지역을 확인한다.
    rose_Factions
    print("115_1.NPC 대사 - 지역 확인 %s \n" % [$game_variables[157]]);
    
    # 각 마을의 가격 비율
    tax = []
    tax = $game_variables[158]

    # 구매 가격, 판매 가격
    $game_variables[163] = 100 * (100 + $game_variables[TMPRICE::VN_BUYING_RATE] + $game_variables[170] - $game_variables[295]) / (500 - tax[$game_variables[157]][0]).to_i
    $game_variables[161] = 100 * (100 + $game_variables[TMPRICE::VN_SELLING_RATE] + $game_variables[171] + $game_variables[295]) / (500 - tax[$game_variables[157]][1]).to_i

    print("구매 가격, 판매 가격 %s, %s \n" % [$game_variables[163], $game_variables[161]]);
    
    # 가장 저렴한 지역 확인
    i = 0
    a = 1000
    ai = 0
    b = 1000
    bi = 0
    SZS_Factions::Factions.size.times.each {
      if tax[i] != nil
        if a == 1000 or a > tax[i][0].to_i
          a = tax[i][0].to_i
          ai = i
        end
        if b == 1000 or b > tax[i][1].to_i
          b = tax[i][1].to_i
          bi = i
        end
      end
      i += 1
    }
    
    # 구매시 가장 이득인 지역
    $game_variables[279] = nil
    $game_variables[279] = SZS_Factions::Factions[ai - 1][:name]
    
    # 판매시 가장 이득인 지역
    $game_variables[280] = nil
    $game_variables[280] = SZS_Factions::Factions[bi - 1][:name]

    # 몬스터 비율 증가
    $game_variables[270] = nil
    $game_variables[270] = SZS_Factions::Factions[$game_variables[271] - 1][:name]
    print("115_1.상인 대사 - 몬스터 증가 지역 %s \n" % [$game_variables[270]]);

    # 도둑질 여부
    if $game_variables[101] >= 2
      text.push(
      [sprintf("요즘 좀도둑이 기승을 부린다더군…."), 1], 
      )
    end
    if $game_variables[101] >= 10
      text.push(
      [sprintf("Hace poco escuché que los ladrones están muy activos últimamente…"), 1], 
      [sprintf("Hace poco escuché que los ladrones están muy activos últimamente… \nY se dice que uno de ellos se parece mucho a ti..."), 1], 
      )
    end
    if $game_variables[101] >= 30
      text.push(
      [sprintf("\e{\e{¿Eh? ¡Oh! \nSe dice que hay muchos ladrones últimamente, ¿eres uno de ellos?"), 5], 
      )
    end
    
    # 에르니 피로한 상태
    if $game_actors[7].sleep_rate >= 85
      if $game_variables[219] == 1 # 남성
        text.push(
        [sprintf("Pareces muy cansado, ¿estás bien?"), 1], 
        )
      elsif $game_variables[219] == 2 # 여성
        text.push(
        [sprintf("Pareces un poco cansada… ¿Estás bien?"), 1], 
        )
      elsif $game_variables[219] == 3 # 할아버지
        text.push(
        [sprintf("Señorita, ¿estás bien? Pareces muy cansada."), 1], 
        )
      elsif $game_variables[219] == 4 # 할머니
        text.push(
        [sprintf("Ay… joven, ¿has estado durmiendo bien?"), 1], 
        )
      end
    end
    
    # 특정 상태 이상인 경우
    # 출혈, 상처
    if $game_actors[7].state?(13) or $game_actors[7].state?(120) or $game_actors[7].state?(135) or $game_actors[7].state?(136)
      if $game_variables[219] == 1 # 남성
        text.push(
        [sprintf("¡Hey, estás sangrando! Debes tratarte rápido."), 1], 
        [sprintf("Viendo tu estado, necesitas invertir en mejor equipo."), 1], 
        )
      elsif $game_variables[219] == 2 # 여성
        text.push(
        [sprintf("Oye, estás sangrando. Deberías tratarte rápido…"), 1], 
        [sprintf("La herida parece profunda, deberías tratarte primero."), 1], 
        )
      elsif $game_variables[219] == 3 # 할아버지
        text.push(
        [sprintf("Jeje… deberías tratarte primero, ¿no crees?"), 1], 
        )
      elsif $game_variables[219] == 4 # 할머니
        text.push(
        [sprintf("Ay… jovencita, no deberías dejar esa herida sin tratar, ve a tratarte primero."), 1], 
        )
      end
    end
    # 악취
    if $game_actors[7].state?(134)
      if $game_variables[219] == 1 or $game_variables[219] == 2 # 남성, 여성
        text.push(
        [sprintf("\e{Ugh... ¿qué es ese olor?"), 1], 
        [sprintf("¡Deberías lavarte!"), 1], 
        [sprintf("Ugh… ese olor…"), 1], 
        [sprintf("Ugh… ¿de dónde viene ese olor a podrido?"), 1], 
        [sprintf("\e{Ugh… ¿qué es ese olor?!"), 1], 
        [sprintf("Ugh… ¿qué es ese olor?"), 1], 
        [sprintf("\e{\e{Ugh… ¡mi nariz!"), 1], 
        [sprintf("\e{Ugh, ¡me dan ganas de vomitar!"), 1], 
        [sprintf("Ugh, ¡apártate!"), 4], 
        )
      elsif $game_variables[219] == 3 or $game_variables[219] == 4 # 할아버지, 할머니
        text.push(
        [sprintf("\e{Ugh... ¿qué es ese olor? ¿Quieres matar a este viejo?"), 1], 
        [sprintf("Una persona tan decente, ¡ugh! ¡Deberías lavarte!"), 1], 
        [sprintf("Ugh… ¿de dónde viene ese olor a cadáver?"), 1], 
        [sprintf("Ugh… ¿de dónde viene ese olor a podrido?"), 1], 
        [sprintf("\e{Ugh… jovencita, ¿qué es ese olor tan asqueroso?"), 1], 
        [sprintf("Ugh… ¿qué es ese olor?"), 1], 
        [sprintf("\e{\e{Ugh… ¡mi nariz! ¡Se va a pudrir!"), 1], 
        [sprintf("\e{Ugh, ¡me dan ganas de vomitar!"), 1], 
        [sprintf("Ugh, ¡aléjate!"), 4], 
        )
      end
    end
    # NPC 종류
    if $game_variables[220] == 1 # 일반
      # 물가가 비싸다.
      if $game_variables[163] >= 80
        if $game_variables[219] == 1 # 남성
          text.push(
          [sprintf("Hoy los precios están muy altos…"), 1], 
          [sprintf("No sé por qué los precios están tan altos hoy…"), 1], 
          )
          # 가장 저렴한 지역이 지금 지역이 아닌 경우 출력
          if ai != $game_variables[157] and $game_variables[279] != nil
            text.push(
            [sprintf("Dicen que los precios son bajos en \eC[1]\eV[279]\eC[0]… ¿Debería ir?"), 1], 
            [sprintf("Hmm, los precios aquí son mucho más caros que en \eC[1]\eV[279]\eC[0]…"), 1], 
            )
          end
          if bi != $game_variables[157] and $game_variables[280] != nil
            text.push(
            [sprintf("Dicen que los precios son más justos en \eC[1]\eV[280]\eC[0] últimamente, debería echar un vistazo."), 1], 
            [sprintf("Aquí los precios son mucho peores que en \eC[1]\eV[280]\eC[0]…"), 1], 
            )
          end
        elsif $game_variables[219] == 2 # 여성
          text.push(
          [sprintf("Ugh, los precios están muy altos hoy."), 1], 
          [sprintf("Necesitaba algo, pero es demasiado caro…"), 1], 
          )
          # 가장 저렴한 지역이 지금 지역이 아닌 경우 출력
          if ai != $game_variables[157] and $game_variables[279] != nil
            text.push(
            [sprintf("Los precios aquí son muy altos… debería buscar en \eC[1]\eV[279]\eC[0]."), 1], 
            [sprintf("Debería ir a \eC[1]\eV[279]\eC[0]… los precios aquí son muy altos…"), 1], 
            )
          end
          if bi != $game_variables[157] and $game_variables[280] != nil
            text.push(
            [sprintf("Aquí, los precios son mucho peores que en \eC[1]\eV[280]\eC[0]."), 1], 
            [sprintf("Debería comerciar en \eC[1]\eV[280]\eC[0], los precios aquí son demasiado malos."), 1], 
            )
          end
        elsif $game_variables[219] == 3 # 할아버지
          text.push(
          [sprintf("Jeje, es difícil sobrevivir estos días…"), 1], 
          )
        elsif $game_variables[219] == 4 # 할머니
          text.push(
          [sprintf("Hoy tendré que saltarme la comida, los precios están muy altos…"), 1], 
          )
        end
      end
      if $game_variables[219] == 1 # 남성
        text.push(
        [sprintf("Uff, estoy cansado…"), 1], 
        [sprintf("¿Qué está pasando conmigo?"), 1], 
        [sprintf("¿Debería mudarme…?"), 1], 
        [sprintf("Ah, hoy fue un desastre..."), 1], 
        [sprintf("Haaaaam..."), 1], 
        [sprintf("\e{Si tienes hambre, ¡come carne!"), 1], 
        [sprintf("\e{\e{¿Qué?"), 1], 
        [sprintf("¿Bebí demasiado anoche...?"), 1], 
        [sprintf("Oh, ¿qué pechos tan bonitos tienes?"), 1], 
        )
        if $game_variables[270] != nil and $game_variables[271] != $game_variables[157]
          text.push(
          [sprintf("Dicen que últimamente hay muchos monstruos en \eC[1]\eV[270]\eC[0], lo cual es preocupante."), 1], 
          [sprintf("Si te sientes bien, ¿por qué no vas a \eC[1]\eV[270]\eC[0]? Dicen que hay muchos monstruos últimamente, podrías ganar algo de dinero."), 1], 
          )
        end
        if $game_variables[12] >= 1 # 날씨가 안좋다.
          text.push(
          [sprintf("A veces, este clima también está bien."), 1], 
          )
        else
          text.push(
          [sprintf("Es un buen clima para cazar."), 1], 
          )
        end
      elsif $game_variables[219] == 2 # 여성
        text.push(
        [sprintf("¡Ánimo!"), 1], 
        [sprintf("¿Qué le pasa?"), 1], 
        [sprintf("Creo que debería buscar otro trabajo, uff…"), 1], 
        [sprintf("Las cosas no van bien…"), 1], 
        [sprintf("¿Estás comiendo bien?"), 1], 
        [sprintf("¿Qué pasa?"), 1], 
        [sprintf("Últimamente, me canso con solo moverme un poco…"), 1], 
        )
        if $game_variables[270] != nil and $game_variables[271] != $game_variables[157]
          text.push(
          [sprintf("Dicen que hay muchos monstruos en \eC[1]\eV[270]\eC[0], así que ten cuidado si vas por allá."), 1], 
          [sprintf("Es mejor no ir a \eC[1]\eV[270]\eC[0] por un tiempo, dicen que hay muchos monstruos."), 1], 
          )
        end
        if $game_variables[12] >= 1 # 날씨가 안좋다.
          text.push(
          [sprintf("El clima está bastante mal hoy."), 1], 
          )
        else
          text.push(
          [sprintf("¡Hoy el clima está genial!"), 1], 
          )
        end
      elsif $game_variables[219] == 3 # 할아버지
        text.push(
        [sprintf("Hoy me duele la espalda de manera extraña…"), 1], 
        [sprintf("¿Qué le pasa a este viejo?"), 1], 
        [sprintf("Jeje, ¡qué bonitos pechos tienes!"), 1], 
        [sprintf("¡Tienes un buen trasero, eres una buena mercenaria!"), 1], 
        [sprintf("¿Hm? ¿Qué dijiste? No puedo oír bien últimamente…"), 1], 
        )
        if $game_variables[12] >= 1 # 날씨가 안좋다.
          text.push(
          [sprintf("Me recuerda a mi esposa, que se fue de casa…"), 1], 
          )
        else
          text.push(
          [sprintf("Es un buen día para morir…"), 1], 
          [sprintf("El clima se mantendrá despejado por un tiempo…"), 1], 
          [sprintf("¿Será que va a llover…? Me duelen las rodillas…"), 1], 
          )
        end
      elsif $game_variables[219] == 4 # 할머니
        text.push(
        [sprintf("Ay, me duele todo…"), 1], 
        [sprintf("Bueno, jovencita, ¿qué te trae por aquí?"), 1], 
        [sprintf("Tienes buenas caderas, podrías tener hijos fácilmente, ¡cuida a tu madre!"), 1], 
        [sprintf("¿Eh? ¿Qué dijiste? No puedo oír bien últimamente…"), 1], 
        )
        if $game_variables[12] >= 1 # 날씨가 안좋다.
          text.push(
          [sprintf("Maldito viejo… pero era guapo."), 1], 
          )
        else
          text.push(
          [sprintf("El clima… me recuerda a mi esposo…"), 1], 
          [sprintf("El clima se mantendrá despejado por un tiempo…"), 1], 
          [sprintf("¿Será que va a llover…? Me duelen las rodillas…"), 1], 
          )
        end
      end
      text2.push(
      [sprintf(" \n\efr(Parece que está curioso sobre qué pasa.)"), 1], 
      [sprintf(" \n\efr(Parece que está un poco molesto.)"), 1], 
      )
    # 일반, 무기점, 마법 상점 공통
    elsif $game_variables[220] == 2 or $game_variables[220] == 4 or $game_variables[220] == 6
      # 친밀도에 따른 추가
      if $game_variables[219] == 1 # 남성
        case $game_variables[296]
        when 0..50
          text.push(
          [sprintf("Echa un vistazo, vendo una variedad de cosas!"), 1], 
          )
        when 51..100
          text.push(
          [sprintf("Mercenario, ¿qué te trae por aquí?"), 1], 
          )
        when 101..150
          text.push(
          [sprintf("Oh, \eC[1]\eN[7]\eC[0], ¡bienvenida! ¿Qué necesitas?"), 1], 
          )
        when 151..200
          text.push(
          [sprintf("Oh, \eC[1]\eN[7]\eC[0], ¿de qué pueblo vienes esta vez?"), 1], 
          )
        when 251..300
          text.push(
          [sprintf("¡\eC[1]\eN[7]\eC[0], bienvenida! ¿Qué estás buscando?!"), 1], 
          )
        end
      end
      # NPC와 섹스 횟수
      if $game_variables[237] >= 10
        text.push(
        [sprintf("\e{Solo vendo productos certificados!"), 1], 
        [sprintf("Oh, ¿no es nuestra \eC[1]\eN[7]\eC[0]?"), 1], 
        [sprintf("Jeje, ¿no es nuestra \eC[1]\eN[7]\eC[0]?"), 1], 
        [sprintf("¿Hoy eres la mercenaria \eC[1]\eN[7]\eC[0]? Jaja, ¿qué necesitas?"), 1], 
        [sprintf("Bienvenida, nuestra \eC[1]\eN[7]\eC[0]."), 1], 
        [sprintf("Oh, \eC[1]\eN[7]\eC[0]! ¿Cómo has estado?"), 1], 
        [sprintf("¿Necesitas mi parte inferior nuevamente? Jajaja."), 1], 
        )
        text2.push(
        [sprintf(" \nYa que somos cercanos, te daré un descuento."), 1], 
        [sprintf(" \nAsí que, ¿necesitas algo? Te haré un descuento."), 1], 
        [sprintf(" \n¿No necesitas dinero hoy? Qué pena, jaja."), 1], 
        [sprintf(" \n¿Qué necesitas? Te haré un descuento."), 1], 
        [sprintf(" \nTe haré un descuento, así que juguemos juntos la próxima vez, ¿sí?"), 1], 
        )
      end
      # 물가가 싸다.
      if 80 > $game_variables[163] and $game_variables[163] >= 50
        if $game_variables[219] == 1 # 남성
          text.push(
          [sprintf("Elige, te haré un descuento pequeño."), 1], 
          [sprintf("¿Quieres un descuento? Hm... está bien, pero solo un poco."), 1], 
          [sprintf("Te venderé un poco más barato, así que ven más seguido!"), 1], 
          )
        elsif $game_variables[219] == 2 # 여성
          text.push(
          [sprintf("¡Eres una clienta bonita! Elige, te haré un pequeño descuento."), 1], 
          [sprintf("¿Quieres un descuento? Hm... está bien, pero solo un poco."), 1], 
          [sprintf("Te venderé un poco más barato, así que ven más seguido!"), 1], 
          )
        elsif $game_variables[219] == 3 # 할아버지
          text.push(
          [sprintf("Jeje, es difícil sobrevivir estos días, te haré un pequeño descuento."), 1], 
          )
        elsif $game_variables[219] == 4 # 할머니
          text.push(
          [sprintf("Jovencita, estás haciendo un buen trabajo, te haré un descuento especial!"), 1], 
          )
        end
      end      # 물가가 매우 싸다.
      if 50 > $game_variables[163]
        if $game_variables[219] == 1 # 남성
          text.push(
          [sprintf("Has venido en buen momento, estamos liquidando el inventario. \nTe lo dejaré barato, ¿quieres uno?"), 1], 
          [sprintf("Ahora mismo estamos en una venta especial. Cometimos un error en los pedidos."), 1], 
          [sprintf("Estamos en una venta especial, así que aprovecha y compra algo."), 1], 
          [sprintf("\e{¡Estamos en una venta especial ahora mismo!"), 1], 
          [sprintf("\e{¡Bienvenido! ¡Estamos en una venta especial ahora mismo!"), 1], 
          )
        elsif $game_variables[219] == 2 # 여성
          text.push(
          [sprintf("¡Has llegado en buen momento! Estamos liquidando el inventario. \nTe lo dejaré barato, ¿quieres uno?"), 1], 
          [sprintf("Ahora mismo estamos en una venta especial. Cometimos un error en los pedidos."), 1], 
          [sprintf("Estamos en una venta especial, así que aprovecha y compra algo."), 1], 
          [sprintf("\e{¡Estamos en una venta especial ahora mismo!"), 1], 
          [sprintf("\e{¡Bienvenida! ¡Estamos en una venta especial ahora mismo!"), 1], 
          )
        elsif $game_variables[219] == 3 # 할아버지
          text.push(
          [sprintf("Jeje, es difícil sobrevivir estos días, te haré un pequeño descuento."), 1], 
          )
        elsif $game_variables[219] == 4 # 할머니
          text.push(
          [sprintf("Jovencita, estás haciendo un buen trabajo, te haré un descuento especial!"), 1], 
          )
        end
      end
      # NPC와 상호작용 횟수
      if $game_variables[208] >= 10
        if $game_variables[219] == 1 # 남성
          text.push(
          [sprintf("Hey, ¿cómo va tu trabajo?"), 1], 
          [sprintf("\eC[1]\eN[7]\eC[0], ¿qué necesitas esta vez?"), 1], 
          [sprintf("\eC[1]\eN[7]\eC[0], ¿qué necesitas esta vez?"), 1], 
          [sprintf("\eC[1]\eN[7]\eC[0]? ¿Qué pasa?"), 1], 
          [sprintf("\eC[1]\eN[7]\eC[0], ¿verdad? ¡Recuerdo bien las caras!"), 1], 
          )
          # 가장 저렴한 지역이 지금 지역이 아닌 경우 출력
          if ai != $game_variables[157] and $game_variables[279] != nil
            text.push(
            [sprintf("Dicen que en \eC[1]\eV[279]\eC[0] los precios son bastante baratos últimamente."), 1], 
            )
          end
          if bi != $game_variables[157] and $game_variables[280] != nil
            text.push(
            [sprintf("Dicen que en \eC[1]\eV[280]\eC[0] están pagando bien últimamente."), 1], 
            )
          end
        elsif $game_variables[219] == 2 # 여성
          text.push(
          [sprintf("Oh, \eC[1]\eN[7]\eC[0]! ¡Bienvenida!"), 1], 
          [sprintf("¡Gracias por venir! ¿Qué necesitas hoy?"), 1], 
          [sprintf("\eC[1]\eN[7]\eC[0]? ¿Qué pasa?"), 1], 
          [sprintf("¿Cómo te va en el trabajo?"), 1], 
          [sprintf("\eC[1]\eN[7]\eC[0], ¿verdad? Soy buena recordando caras."), 1], 
          )
          # 가장 저렴한 지역이 지금 지역이 아닌 경우 출력
          if ai != $game_variables[157] and $game_variables[279] != nil
            text.push(
            [sprintf("Dicen que en \eC[1]\eV[279]\eC[0] están vendiendo barato porque no se venden bien…"), 1], 
            )
          end
          if bi != $game_variables[157] and $game_variables[280] != nil
            text.push(
            [sprintf("Dicen que en \eC[1]\eV[280]\eC[0] están comprando muchas cosas a buen precio últimamente."), 1], 
            )
          end
        elsif $game_variables[219] == 3 # 할아버지
          text.push(
          [sprintf("Oh, ¿no es la famosa \eC[1]\eN[7]\eC[0]? ¿Necesitas algo?"), 1], 
          [sprintf("Te veo seguido, jeje."), 1], 
          [sprintf("Eres una joven impresionante… Si tuviera 10 años menos, jeje."), 1], 
          [sprintf("¿Cómo te llamabas… \eC[1]\eN[7]\eC[0], cierto?"), 1], 
          [sprintf("La edad afecta la memoria, eso seguro…"), 1], 
          )
        elsif $game_variables[219] == 4 # 할머니
          text.push(
          [sprintf("He estado esperando para vender a nuestra \eC[1]\eN[7]\eC[0]!"), 1], 
          [sprintf("Parece que te gusto, jejeje."), 1], 
          [sprintf("Te veo seguido, jovencita."), 1], 
          [sprintf("\eC[1]\eN[7]\eC[0], hace tiempo que no te veía, ¿cómo estás?"), 1], 
          )
        end
      end
      # NPC 성별
      if $game_variables[219] == 1 # 남성
        text.push(
        [sprintf("Echa un vistazo, vendo una variedad de cosas."), 1], 
        [sprintf("No te preocupes, tómate tu tiempo para mirar."), 1], 
        [sprintf("¡Bienvenido! ¡Mira todo lo que tenemos!"), 1], 
        [sprintf("Echa un vistazo, vendo una variedad de cosas!"), 1], 
        [sprintf("¿Necesitas algo? Dímelo cuando quieras."), 1], 
        [sprintf("Bienvenido, ¿buscas algo en especial?"), 1], 
        [sprintf("El negocio no va bien últimamente, hmm…"), 1], 
        [sprintf("Mercenario, ¿buscas algo?"), 1], 
        [sprintf("Bienvenida, linda mercenaria."), 1], 
        [sprintf("Bienvenida, mercenaria."), 1], 
        [sprintf("¡Oh! ¿Buscas algo? Echa un vistazo."), 1], 
        [sprintf("Vendo productos de buena calidad, ¿buscas algo específico?"), 1], 
        [sprintf("\e{Hoy los productos están en muy buen estado!"), 1], 
        [sprintf("Vendo artículos necesarios para aventureros y mercenarios."), 1], 
        [sprintf("Si no compras ahora, ¡te arrepentirás!"), 1], 
        [sprintf("¡Oh, un cliente!"), 1], 
        [sprintf("\e{¡Todavía tengo muchos productos! ¡Echa un vistazo!"), 1], 
        [sprintf("\e{Oh, una chica bonita, ¿quieres vender algo?"), 1], 
        )
      elsif $game_variables[219] == 2 # 여성
        text.push(
        [sprintf("\eC[1]\eN[7]\eC[0], ¿qué necesitas esta vez?"), 1], 
        [sprintf("¿Necesitas algo? ¡Dímelo!"), 1], 
        [sprintf("Si necesitas algo, dímelo."), 1], 
        [sprintf("Oh, bienvenida! ¿Buscas algo en especial?"), 1], 
        [sprintf("Bienvenida! Si ves algo que te guste, dímelo."), 1], 
        [sprintf("Hermana mercenaria, ¡vendo lo que necesitas! Echa un vistazo!"), 1], 
        [sprintf("Hermana mercenaria, ¿buscas algo?"), 1], 
        [sprintf("Bienvenida, linda hermana mercenaria!"), 1], 
        [sprintf("Bienvenida, hermana mercenaria!"), 1], 
        )
      elsif $game_variables[219] == 3 # 할아버지
        text.push(
        [sprintf("Oh… una joven bastante decente! ¿Necesitas algo?"), 1], 
        [sprintf("¡Tienes un buen trasero! ¿Qué necesitas?"), 1], 
        [sprintf("Buena joven… ¿no necesitas esto?"), 1], 
        [sprintf("Ay, envejecer hace que el negocio sea difícil…"), 1], 
        [sprintf("¿Qué estás buscando?"), 1], 
        [sprintf("Mira esto, joven! Hoy los productos están en muy buen estado!"), 1], 
        [sprintf("Jeje, eres una joven bonita."), 1], 
        [sprintf("¡No te arrepientas, toma lo que necesites rápidamente!"), 1], 
        [sprintf("\e{¡Productos frescos! Cof cof… solo vendo buenos productos."), 1], 
        [sprintf("Pareces alguien que sería buena para tener hijos…"), 1], 
        )
      elsif $game_variables[219] == 4 # 할머니
        text.push(
        [sprintf("¡Vendo cosas bastante buenas!"), 1], 
        [sprintf("Ay, linda joven… bueno, ¿necesitas algo?"), 1], 
        [sprintf("\e{¡Productos frescos! Cof cof… solo vendo buenos productos."), 1], 
        [sprintf("Pareces alguien que sería buena para tener hijos…"), 1], 
        [sprintf("Ay, envejecer hace que el negocio sea difícil…"), 1], 
        )
      end
      text2.push(
      [sprintf(" \n\efr(Está ordenando las cosas mientras te mira.)"), 1], 
      [sprintf(" \n\efr(Parece estar curioso sobre qué pasa.)"), 1], 
      [sprintf(" \n\efr(Parece estar un poco molesto.)"), 1], 
      [sprintf(" \n\efr(Señala los productos en exhibición mientras habla.)"), 1], 
      )    
    elsif $game_variables[220] == 3 # 여관 상점
      # NPC 성별
      if $game_variables[219] == 1 # 남성
        text.push(
        [sprintf("Uff, estoy cansado…"), 1], 
        [sprintf("Parece que tú también estás cansado, ¿por qué no descansas un rato?"), 1], 
        [sprintf("¿Necesitas una habitación? Tenemos camas cómodas listas."), 1], 
        [sprintf("Bienvenido al mejor hostal, ¿quieres quedarte una noche?"), 1], 
        [sprintf("Hey, ¿cómo va tu trabajo? ¿Vienes a quedarte otra noche?"), 1], 
        [sprintf("No te he visto por aquí antes… Debes ser un mercenario, ¿necesitas una habitación?"), 1], 
        [sprintf("¡Bienvenido a nuestra posada!"), 1], 
        [sprintf("Hoy también tenemos habitaciones limpias y cómodas listas."), 1], 
        )
        if $game_variables[12] >= 1 # 날씨가 안좋다.
          text.push(
          [sprintf("El clima está mal, ¿por qué no te quedas una noche?"), 1], 
          [sprintf("En días como hoy, lo mejor es acostarse y tomar una copa de \eC[1]hidromiel\eC[0]."), 1], 
          )
        end
      elsif $game_variables[219] == 2 # 여성
        text.push(
        [sprintf("Tenemos habitaciones limpias y cómodas listas!"), 1], 
        [sprintf("¿Necesitas una habitación? Puedes disfrutar de un descanso cómodo."), 1], 
        [sprintf("¡Gracias por elegir nuestra posada!"), 1], 
        [sprintf("\eC[1]\eN[7]\eC[0], ¡bienvenida! ¿Te quedarás una noche?"), 1], 
        [sprintf("¿Eres una mercenaria? ¿Te quedarás una noche?"), 1], 
        [sprintf("¿Cómo te va en tu trabajo?"), 1], 
        [sprintf("No te he visto por aquí antes… Debes ser una mercenaria, ¿necesitas una cama cómoda?"), 1], 
        [sprintf("¡Bienvenida a nuestra posada!"), 1], 
        [sprintf("Hoy también tenemos habitaciones limpias y cómodas listas."), 1], 
        )
        if $game_variables[12] >= 1 # 날씨가 안좋다.
          text.push(
          [sprintf("El clima está bastante mal hoy, ¿por qué no descansas en una habitación cómoda?"), 1], 
          [sprintf("En días como hoy, lo mejor es acostarse y tomar una copa de \eC[1]hidromiel\eC[0]."), 1], 
          )
        end
      elsif $game_variables[219] == 3 # 할아버지
        text.push(
        [sprintf("Hoy me duele la espalda de manera extraña…"), 1], 
        [sprintf("¿Qué le pasa a este viejo? ¿Necesitas una habitación?"), 1], 
        [sprintf("Eres una joven impresionante… Si tuviera 10 años menos, jeje."), 1], 
        [sprintf("Jeje, si tuviera 10 años menos…"), 1], 
        )
        if $game_variables[12] >= 1 # 날씨가 안좋다.
          text.push(
          [sprintf("El clima está mal, me duele todo…"), 1], 
          [sprintf("Ay, el clima está mal…"), 1], 
          [sprintf("Has venido bien, en días así lo mejor es acostarse y tomar una copa de \eC[1]hidromiel\eC[0], jeje."), 1], 
          )
        end
      elsif $game_variables[219] == 4 # 할머니
        text.push(
        [sprintf("Ay, me duele todo…"), 1], 
        [sprintf("Bueno, jovencita, ¿qué te trae por aquí?"), 1], 
        [sprintf("Te veo seguido, jovencita."), 1], 
        [sprintf("Me recuerdas a mi juventud…"), 1], 
        )
        if $game_variables[12] >= 1 # 날씨가 안좋다.
          text.push(
          [sprintf("El clima está mal, me duele todo…"), 1], 
          [sprintf("Ay, el clima está mal…"), 1], 
          [sprintf("En este clima, es mejor descansar, buen pensamiento, jovencita."), 1], 
          )
        end
      end
    elsif $game_variables[220] == 4 # 무기점 상점
      # NPC 성별
      if $game_variables[219] == 1 # 남성
        text.push(
        [sprintf("\e{¿Buscas armas? ¿O necesitas armaduras?"), 1], 
        [sprintf("¿Buscas algún equipo en particular? Tratamos casi todo lo que se hace con metal, échale un vistazo."), 1], 
        [sprintf("Vendo buenos artículos, ¿necesitas algún equipo o artículo en particular?"), 1], 
        [sprintf("Mercenario, ¿buscas algo? ¿Armas? ¿O armaduras?"), 1], 
        [sprintf("El negocio no va bien últimamente, mejor afilo algunas espadas…"), 1], 
        )
        text2.push(
        [sprintf(" \n\efr(Te muestra varios equipos mientras habla.)"), 1], 
        )
      elsif $game_variables[219] == 2 # 여성
        text.push(
        [sprintf("Vendo buenos artículos, ¿necesitas algún equipo o artículo en particular?"), 1], 
        [sprintf("Hermana mercenaria, ¿buscas algo?"), 1], 
        [sprintf("No tengo armas inusuales, pero tengo lo esencial, échale un vistazo."), 1], 
        [sprintf("Hermana mercenaria, vendo lo que necesitas! Echa un vistazo!"), 1], 
        )
        text2.push(
        [sprintf(" \n\efr(Te muestra varios equipos mientras habla.)"), 1], 
        )
      elsif $game_variables[219] == 3 # 할아버지
        text.push(
        [sprintf("¿Buscas algún equipo en particular? Tratamos casi todo lo que se hace con metal, échale un vistazo."), 1], 
        )
      elsif $game_variables[219] == 4 # 할머니
        text.push(
        [sprintf("¿Buscas algún equipo en particular? Tratamos casi todo lo que se hace con metal, échale un vistazo."), 1], 
        )
      end
    elsif $game_variables[220] == 5 # 음유시인
      # 기부금에 따른 대사
      case $game_variables[274]
      when 0..500000
        text.push(
        [sprintf("Necesito afinar mi laúd…"), 1], 
        [sprintf("Hmm… ¿qué canción debería tocar?"), 1], 
        [sprintf("¿Te gustaría escuchar una canción?"), 1], 
        )
      else
        text.push(
        [sprintf("Estoy realmente agradecido por la donación que \eC[1]\eN[7]\eC[0] hizo la última vez."), 1], 
        [sprintf("Gracias a ti, pude tener una comida decente."), 1], 
        [sprintf("Me alegra verte con buena salud hoy también."), 1], 
        [sprintf("\eC[1]\eN[7]\eC[0] es una celebridad entre nosotros!"), 1], 
        [sprintf("Tengo suerte de verte hoy, \eC[1]\eN[7]\eC[0]."), 1], 
        [sprintf("Siempre apoyo a \eC[1]\eN[7]\eC[0]."), 1], 
        [sprintf("Algún día, quiero escribir una canción para \eC[1]\eN[7]\eC[0]."), 1], 
        )
      end
      if $game_variables[12] >= 1 # 날씨가 안좋다.
        text.push(
        [sprintf("En días como estos, es bueno tomarse un descanso."), 1], 
        [sprintf("El clima no está muy bien."), 1], 
        )
      end
      if $game_variables[13] >= 1 # 잠시 후 날씨가 안좋다.
        text.push(
        [sprintf("Parece que lloverá en cualquier momento."), 1], 
        [sprintf("Hoy es mejor que te tomes un descanso."), 1], 
        )
      end
    elsif $game_variables[220] == 6 # 마법 상점
      # NPC 성별
      if $game_variables[219] == 1 # 남성
        text.push(
        [sprintf("Bienvenido, has venido al lugar correcto si buscas herramientas mágicas."), 1], 
        [sprintf("\e{¡Todavía tenemos muchas herramientas mágicas! ¡Echa un vistazo!"), 1], 
        [sprintf("¿Necesitas herramientas mágicas? Te haré un buen precio."), 1], 
        [sprintf("Vendo buenas herramientas mágicas, ¿buscas algo en particular?"), 1], 
        [sprintf("Mercenario, ¿buscas alguna herramienta mágica en particular?"), 1], 
        [sprintf("Oh, ¿no eres la famosa \eC[1]\eN[7]\eC[0]? ¿Necesitas herramientas mágicas?"), 1], 
        [sprintf("¡Oh! ¿Buscas herramientas mágicas? Echa un vistazo."), 1], 
        [sprintf("Bienvenido, ¿buscas alguna herramienta mágica en particular?"), 1], 
        [sprintf("\eC[1]\eN[7]\eC[0], ¿qué herramientas mágicas necesitas esta vez?"), 1], 
        [sprintf("Echa un vistazo, vendo varias herramientas mágicas!"), 1], 
        )
      elsif $game_variables[219] == 2 # 여성
        text.push(
        [sprintf("Bienvenida, has venido al lugar correcto si buscas herramientas mágicas!"), 1], 
        [sprintf("\e{¡Todavía tenemos muchas herramientas mágicas! ¡Echa un vistazo!"), 1], 
        [sprintf("\e{Vendemos artículos mágicos para la vida diaria!"), 1], 
        [sprintf("\e{Hoy las herramientas mágicas están en muy buen estado!"), 1], 
        [sprintf("Vendo buenas herramientas mágicas, ¿buscas algo en particular?"), 1], 
        [sprintf("Hermana mercenaria, ¿buscas alguna herramienta mágica en particular?"), 1], 
        [sprintf("Hermana mercenaria, vendo lo que necesitas! Echa un vistazo!"), 1], 
        [sprintf("Bienvenida! Dímelo si ves alguna herramienta mágica que te guste."), 1], 
        [sprintf("Oh, bienvenida! ¿Buscas alguna herramienta mágica en particular?"), 1], 
        [sprintf("¡Oh! ¿Buscas herramientas mágicas? Echa un vistazo."), 1], 
        [sprintf("Bienvenida, ¿buscas alguna herramienta mágica en particular?"), 1], 
        [sprintf("Echa un vistazo, vendo varias herramientas mágicas."), 1], 
        [sprintf("\eC[1]\eN[7]\eC[0], ¿qué herramientas mágicas necesitas esta vez?"), 1], 
        )
      elsif $game_variables[219] == 3 # 할아버지
        text.push(
        [sprintf("Jeje, ¿buscas herramientas mágicas?"), 1], 
        [sprintf("Mira esto, joven! Hoy las herramientas mágicas están en muy buen estado!"), 1], 
        [sprintf("¿Buscas alguna herramienta mágica en particular?"), 1], 
        [sprintf("Buena joven… ¿no necesitas estas herramientas mágicas?"), 1], 
        )
      elsif $game_variables[219] == 4 # 할머니
        text.push(
        [sprintf("Jeje, ¿buscas herramientas mágicas?"), 1], 
        [sprintf("Mira esto, joven! Hoy las herramientas mágicas están en muy buen estado!"), 1], 
        [sprintf("Ay, linda joven… bueno, ¿necesitas alguna herramienta mágica?"), 1], 
        [sprintf("Vendo herramientas mágicas bastante buenas!"), 1], 
        )
      end
    elsif $game_variables[220] == 7 # 길드 상점
      # NPC 성별
      if $game_variables[219] == 1 # 남성
        text.push(
        [sprintf("Bienvenido al gremio, ¿cómo puedo ayudarte?"), 1], 
        [sprintf("¿Para qué has venido?"), 1], 
        [sprintf("\e{Ugh, me molesta tener que llenar formularios!"), 1], 
        [sprintf("Ugh, organizar materiales de monstruos… es molesto…"), 1], 
        [sprintf("¿Qué le trae a una chica tan linda?"), 1], 
        [sprintf("¡Qué buen cuerpo tienes!"), 1], 
        )
      elsif $game_variables[219] == 2 # 여성
        text.push(
        [sprintf("Bienvenida al gremio, ¿necesitas ayuda?"), 1], 
        [sprintf("¿Para qué has venido?"), 1], 
        [sprintf("El tablero de misiones está afuera."), 1], 
        [sprintf("Si tienes alguna pregunta, estaré encantada de responder."), 1], 
        [sprintf("¿En qué puedo ayudarte?"), 1], 
        )
      elsif $game_variables[219] == 3 # 할아버지
        text.push(
        [sprintf("Hoy me duele la espalda de manera extraña…"), 1], 
        [sprintf("Ay, me duele todo…"), 1], 
        [sprintf("¿Qué le pasa a este viejo?"), 1], 
        )
      elsif $game_variables[219] == 4 # 할머니
        text.push(
        [sprintf("Hoy me duele la espalda de manera extraña…"), 1], 
        [sprintf("Ay, me duele todo…"), 1], 
        [sprintf("Bueno, jovencita, ¿qué te trae por aquí?"), 1], 
        )
      end
      text2.push(
      [sprintf(" \n\efr(Habla mientras mira una gran pila de documentos.)"), 1], 
      [sprintf(" \n\efr(Parece ocupado con los documentos mientras habla.)"), 1], 
      )    
    elsif $game_variables[220] == 8 # 마부
      # NPC와 상호작용 횟수
      if $game_variables[208] >= 10
        text.push(
        [sprintf("\eC[1]\eN[7]\eC[0], ¡cuánto tiempo! ¿A dónde te diriges hoy?"), 1], 
        [sprintf("¡Es bueno verte con buena salud! Entonces, ¿a dónde vas hoy?"), 1], 
        [sprintf("Parece que hasta los caballos te reconocen ahora, jaja."), 1], 
        [sprintf("Cuando los caballos están en celo, es difícil usarlos, recuérdalo."), 1], 
        [sprintf("Transportamos algunas cargas también, por lo que es más económico."), 1], 
        [sprintf("\eC[1]\eN[7]\eC[0], siempre eres bienvenida. \n¡Incluso si encontramos \eC[1]ladrones\eC[0] o \eC[1]bandidos\eC[0], no hay de qué preocuparse!"), 1], 
        )
      else
        text.push(
        [sprintf("\e{¡Has venido al lugar correcto si quieres viajar rápido a otra aldea!"), 1], 
        [sprintf("\e{¡Puedes viajar a cualquier aldea pagando la tarifa!"), 1], 
        [sprintf("Hoy los caballos están en buen estado, no hay de qué preocuparse!"), 1], 
        [sprintf("Cuando los caballos están en celo, es difícil usarlos, recuérdalo."), 1], 
        [sprintf("Transportamos algunas cargas también, por lo que es más económico."), 1], 
        [sprintf("Mercenarios o aventureros siempre son bienvenidos. \n¡Incluso si encontramos \eC[1]ladrones\eC[0] o \eC[1]bandidos\eC[0], no hay de qué preocuparse!"), 1], 
        )
      end
      text2.push(
      [sprintf(" \n\efr(Te mira mientras acaricia a un caballo.)"), 1], 
      [sprintf(" \n\efr(Te mira mientras alimenta a un caballo.)"), 1], 
      )
    elsif $game_variables[220] == 9 # 경비병
      # NPC와 상호작용 횟수
      if $game_variables[208] >= 10
        text.push(
        [sprintf("Es bueno verte con buena salud hoy también."), 1], 
        [sprintf("No sé a dónde vas hoy, pero siempre ten cuidado."), 1], 
        [sprintf("\eC[1]\eN[7]\eC[0], ¡cuánto tiempo! \n¿Qué te trae por aquí hoy?"), 1], 
        [sprintf("Oh, \eC[1]\eN[7]\eC[0], pareces haber crecido más desde la última vez que te vi."), 1], 
        [sprintf("\eC[1]\eN[7]\eC[0], ¿vas a cazar también hoy?"), 1], 
        [sprintf("Siempre ten cuidado, especialmente en lugares estrechos."), 1], 
        [sprintf("Espero seguir viéndote por aquí, \eC[1]\eN[7]\eC[0]."), 1], 
        [sprintf("Siempre ten cuidado con \eC[1]ladrones\eC[0] y \eC[1]bandidos\eC[0], últimamente hay malas noticias."), 1], 
        )
        if $game_variables[12] >= 1 # 날씨가 안좋다.
          text.push(
          [sprintf("Ugh, en días como estos me gustaría tomar una copa de \eC[1]hidromiel\eC[0] contigo en la taberna, \eC[1]\eN[7]\eC[0]. \nPero no puedo moverme por el trabajo, jaja."), 1], 
          [sprintf("\eC[1]\eN[7]\eC[0], ¿también vas a cazar en este clima? Eres increíble."), 1], 
          [sprintf("Bueno, aunque el clima esté mal, hay que seguir trabajando para ganarse la vida."), 1], 
          [sprintf("En días como estos realmente quiero dejar todo. \nPero bueno, ¿qué puedo hacer… este es mi trabajo."), 1], 
          [sprintf("\eC[1]Los guardias\eC[0] tienen el trabajo más duro en días como estos. \nPero verte a ti, \eC[1]\eN[7]\eC[0], me da fuerzas, jaja!"), 1], 
          )
        end
      else
        text.push(
        [sprintf("Será mejor que no hagas nada sospechoso."), 1], 
        [sprintf("Informa de cualquier persona sospechosa que veas."), 1], 
        [sprintf("No te preocupes por la seguridad aquí. \nAunque, claro, eso depende de tu comportamiento…"), 1], 
        [sprintf("Ignorar a un guardia te traerá problemas."), 1], 
        [sprintf("Hmm, ¿eres un mercenario? \n¿Qué te trae por aquí?"), 1], 
        [sprintf("Siempre ten cuidado con \eC[1]ladrones\eC[0] y \eC[1]bandidos\eC[0], últimamente hay malas noticias."), 1], 
        )
        if $game_variables[12] >= 1 # 날씨가 안좋다.
          text.push(
          [sprintf("En días como estos, lo mejor es tomar una copa de \eC[1]hidromiel\eC[0] en la taberna."), 1], 
          [sprintf("El clima no está bien…"), 1], 
          [sprintf("En días como estos, envidio la libertad de los mercenarios y aventureros."), 1], 
          [sprintf("En días como estos realmente quiero dejar todo. \nPero bueno, ¿qué puedo hacer… este es mi trabajo."), 1], 
          [sprintf("\eC[1]Los guardias\eC[0] tienen el trabajo más duro en días como estos."), 1], 
          )
        end
      end
      text2.push(
      [sprintf(" \n\efr(Sientes que te está mirando de arriba abajo.)"), 1], 
      )
    elsif $game_variables[220] == 10 # 수녀
      text.push(
      [sprintf("Que la bendición de la diosa El Zairen esté contigo."), 1], 
      [sprintf("Todo comienza con una oración."), 1], 
      [sprintf("Agradecemos a la diosa El Zairen por permitirnos vivir un día más."), 1], 
      [sprintf("Bienvenida, hermana. \nMe alegra verte aquí, ¿has ofrecido tu oración hoy?"), 1], 
      [sprintf("Que siempre puedas tener paz en tu corazón…"), 1], 
      [sprintf("Que la diosa El Zairen esté contigo…"), 1], 
      [sprintf("Que la bendición de la diosa El Zairen te acompañe…"), 1], 
      [sprintf("Si buscas absolución o confesión, dímelo."), 1], 
      [sprintf("La diosa El Zairen está guiando tu alma."), 1], 
      )
      if $game_variables[13] >= 1 # 잠시 후 날씨가 안좋다.
        text.push(
        [sprintf("Parece que lloverá en cualquier momento."), 1], 
        [sprintf("Hoy es mejor que te tomes un descanso, hermana."), 1], 
        )
      end
    end    
    # 에르니 발정, 알몸, 성욕, 노출도가 높은 상태
    if $game_actors[7].state?(23) or $game_actors[7].state?(22) or $game_actors[7].sexual_rate >= 85 or 50 >= $game_variables[118]
     # NPC 성별
      if $game_variables[219] == 1 or $game_variables[219] == 3 # 남성, 할아버지
        # 해당 NPC랑 성관계가 처음이 아니다.
        if $game_variables[237] >= 1
          text.push(
          [sprintf("Jaja, ¿viniste porque recuerdas mi 'herramienta'?"), 2], 
          [sprintf("¿Te pica de nuevo ahí abajo por la noche?"), 2], 
          [sprintf("\e{\e{¡Mi parte baja es especial! Jajaja."), 2], 
          [sprintf("¿Qué pasa, pensabas en mi 'herramienta'?"), 2], 
          [sprintf("Siempre eres un buen producto, es una lástima desperdiciarte como mercenaria."), 2], 
          [sprintf("¿Ya estás mojada?"), 2], 
          [sprintf("¿Oh? ¿Ya estás húmeda?"), 2], 
          [sprintf("\e{Siempre pienso en lo lascivo de tu cuerpo."), 2], 
          [sprintf("¿Tu parte baja también tiene hambre?"), 2], 
          [sprintf("\e{¡Tienes la cara de una perra en celo!"), 2], 
          [sprintf("¿Tu 'agüita' está fluyendo?"), 2], 
          [sprintf("Necesitamos conocernos mejor, ¿no?"), 2], 
          )
        else
          # 해당 NPC랑 성관계가 처음이다.
          text.push(
          [sprintf("Oh… estás bastante bien, ¿cuánto cobras?"), 2], 
          [sprintf("¿Qué pasa, me estás tentando?"), 2], 
          [sprintf("Siempre eres un buen producto, es una lástima desperdiciarte como mercenaria."), 2], 
          [sprintf("¿Ya estás mojada?"), 2], 
          [sprintf("¿Oh? ¿Ya estás húmeda?"), 2], 
          [sprintf("Jeje, ¿aquí también hay buenos productos?"), 2], 
          [sprintf("¿Tu parte baja también tiene hambre?"), 2], 
          [sprintf("\e{¡Tienes la cara de una perra en celo!"), 2], 
          [sprintf("¿Tu 'agüita' está fluyendo?"), 2], 
          [sprintf("Oh… tienes bonitos pechos, ¿no?"), 2], 
          [sprintf("¿Qué pasa, mujer mercenaria? ¿Vas a vender tu cuerpo?"), 2], 
          [sprintf("Oh… estás bastante bien, ¿cuánto cobras?"), 2], 
          [sprintf("Oh, ¿bonitos pechos, verdad?"), 2], 
          [sprintf("\e{¿Qué tal si chupas mi 'herramienta'? Te pagaré por la limpieza."), 2], 
          [sprintf("Bastante atractiva, ¿no?"), 2], 
          [sprintf("Tierna y jugosa, ¿cuánto cobras?"), 2], 
          [sprintf("Mercenaria, parece que necesitas arreglar tus 'agujeros'…"), 2], 
          [sprintf("Hmm, ¿puede que sea buena?"), 2], 
          [sprintf("Tu estado no es bueno… ¿estás bien?"), 2], 
          [sprintf("¿Sin dinero? Parece que necesitas ropa nueva."), 2], 
          [sprintf("Ahem, parece que necesitas reparar tu ropa…"), 1], 
          [sprintf("No puedes andar así, deberías reparar tu ropa o comprar ropa nueva."), 1], 
          )
        end
        text2.push(
        [sprintf(" \n\efr(Te mira de manera incómoda y desagradable.)"), 2], 
        )
      elsif $game_variables[219] == 2 # 여성
        text.push(
        [sprintf("\e{¡Es peligroso andar así!"), 1], 
        [sprintf("¿Estás en celo…?"), 1], 
        [sprintf("\e{¿No sabes que es inapropiado andar así?"), 1], 
        [sprintf("¡Eres la razón por la cual los derechos de las mujeres son bajos!"), 1], 
        [sprintf("\e{¡Contrólate!"), 1], 
        [sprintf("\e{¡Deberías valorar más tu cuerpo!"), 1], 
        )
        text2 = []
        text2.push(
        [sprintf(" \n\efr(Te mira de arriba abajo con una expresión de sorpresa.)"), 1], 
        [sprintf(" \n\efr(Te mira de manera incómoda y desagradable.)"), 1], 
        )
      end
    end
    
    # 촉수 의상인 경우
    if $game_variables[114] == "I"
      text = []
      text2 = []
      text.push(
      [sprintf("Ugh… ¿qué es eso? ¿Esas cosas?"), 4], 
      [sprintf("Ugh… ¡huele a podrido! ¿Qué llevas puesto?"), 4], 
      [sprintf("\e{¡Ugh!"), 4], 
      [sprintf("\e{¿Qué es eso? ¿Estás criando tentáculos? ¡Ugh!"), 4], 
      [sprintf("Ugh, ¡qué asco! ¡Me dan ganas de vomitar!"), 4], 
      )
    end
    
    # 대화 종료 후 이동 분류
    if !text.empty?
      i = rand(text.size)
      $game_variables[421] = text[i][0]
      $game_variables[89] = 1
      $game_variables[89] = text[i][1]
    end
    if !text2.empty?
      a = rand(text2.size)
      $game_variables[421] += text2[a][0]
      $game_variables[89] = text2[a][1] if text2[a][1] > $game_variables[89]
    end
  end
end