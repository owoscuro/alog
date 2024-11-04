# encoding: utf-8
# Name: 044.TMMRBT, TMNPOP
# Size: 10825
# encoding: utf-8
# Name: 044.TMMRBT, TMNPOP
# Size: 10937
=begin

  <mrbt 소년>
  
  mrbt(0, "움직임 이해?")
  
  0 에서 실행중인 이벤트, -1 플레이어, 1 이상에 해당 ID의 이벤트가 대상입니다.

  메시지는 다음 제어 문자를 사용할 수 있습니다, 내용은 문장 표시 명령과 유사합니다.
  \V[1], \N[1], \P, \C[2], \G
  상기 이외에 \L 로 수동으로의 개행이 가능합니다.

=end

module TMNPOP
  FONT_NAME = "Arial"
  FONT_SIZE = 22          # 글꼴의 사이즈
  FONT_OUT_ALPHA = 255    # 글꼴의 테두리 불투명도
end

module TMMRBT
  FONT_SIZE = 17                 # 글꼴 크기
  BACK_OPACITY = 192             # 트윗 창의 불투명도
  MESSAGE_DURATION = 160         # 트윗 표시 시간(프레임)

  MIN_INTERVAL = 50              # 다음 짹짹에서 최소 간격(프레임)
  MAX_INTERVAL = 100             # 다음 짹짹에서의 최대 간격(프레임)

  DATABASE = {}
  
  DATABASE["잡화점"] = ['Mmm….', 'Me faltan algunos materiales.', '¿Debería aumentar un poco el precio…?', 'Ese tipo no se ha visto últimamente…', 'Hmm….', 'Hoy se está tardando….']
  DATABASE["무기점"] = ['Si solo tuviera ese mineral…', 'Últimamente los minerales son…', 'Caro…', 'Todavía falta…', 'Esos inútiles…', '¿Cómo te atreves…?', 'No sabes tu lugar.', '… ….', 'Hmm….', '¿Estará bien?', 'Un arma decente…', 'Déjame ver…', 'Ridículo…']
  DATABASE["할머니"] = ['¿Dónde está ese ratón…?', 'Ay, todo me duele….', 'Me faltan ingredientes….']
  DATABASE["드워프"] = ['Malditos goblins…', 'Esto no sirve!', 'Necesito ese mineral…', '¿Dónde está ese tipo?', 'Ah… necesito una bebida.', '¡Necesito una bebida fuerte!']
  DATABASE["보석상인A"] = ['¿Qué quieres, mendigo?', '¿Tú, atreviéndote a hablarme?', '¡Uf, qué mal olor!', '¿Qué? ¡Lárgate si no tienes dinero!']
  DATABASE["마부A"] = ['¿Por qué las zanahorias son tan caras?', 'Malditos nobles…', '¿Piensan que es fácil cuidar de los caballos?', '¿Quieres un caballo sin dinero…?']

  DATABASE["과일상인A"] = ['¡Manzanas!', '¡Tomates!', '¡Mandarinas!', '¡Manzanas dulces!', '¡Frutas frescas a la venta!']
  DATABASE["과일상인B"] = ['¡Manzanas!', '¡Tomates!', '¡Uvas!', '¡Zanahorias!', '¡Zanahorias! ¡Compren zanahorias!', '¡Frutas frescas a la venta!']
  DATABASE["과일상인C"] = ['¡Patatas y maíz a la venta!', '¡Delicioso maíz!']
  DATABASE["과일상인D"] = ['¡Patatas a la venta!', '¡Compro frutas frescas!', '¡Compro frutas frescas a buen precio!', 'Ah, es difícil ganarse la vida….']

  DATABASE["기타상인A"] = ['….', '¡Si quieres ganar dinero, ve a la mina!', '¿No necesitas un pico?', '¡También vendo sierras!', 'Con este pico…']

  DATABASE["주민"] = ['Maldita sea, no es suficiente.', 'Hmm….', '¡Necesito una mejor bebida!', 'Estoy harto…', 'De verdad…', '¿Qué hacen los guardias?', 'Maldita sea…', 'Malditos ladrones…', 'Es demasiado caro…', '¿Qué hago…?', 'Tengo que dejarlo al gremio…', '¿Cómo resolver esto…?', 'Está muy animado…', '¿No hay algún tonto por aquí…?', 'Maldita sea…', 'Sigh…']
  DATABASE["불량한주민"] = ['Maldita sea, no es suficiente.', 'Hmm….', '¡Necesito una mejor bebida!', 'Estoy harto…', 'De verdad…', '¿Qué hacen los guardias?', 'Maldita sea…', 'Malditos ladrones…', 'Es demasiado caro…', '¿Qué hago…?', 'Tengo que dejarlo al gremio…', '¿Cómo resolver esto…?', 'Está muy animado…', '¿No hay algún tonto por aquí…?', 'Maldita sea…', 'Sigh…']

  DATABASE["페트른"] = ['….']
  DATABASE["케튼"] = ['….', '¿Cuándo podré regresar…?', 'Esta vida es ya…', 'Sigh…', 'Falta mucho mithril…']

  DATABASE["경비병"] = ['Ah, esto es aburrido…', '….', 'Estoy cansado…', 'Ah, esos ladrones…']
  DATABASE["성직자"] = ['Que la diosa te bendiga…', 'Las palabras de la diosa…', '….']

  DATABASE["궁수A"] = ['¿Dices que el arco es débil? Pff.', 'Apunta a las rodillas.', '….', 'Todavía eres un novato.', 'No siempre se necesita una flecha.']
  DATABASE["전사A"] = ['¡Compra cuero!', 'Todos tienen un plan hasta que…', '….', '¿Estás subestimando mi hacha?', 'Hay demasiados idiotas.']

  DATABASE["모험가A"] = ['Sigh, vamos a descansar un poco.', 'Es más difícil de encontrar de lo que pensaba…', '….', 'Esto ya me está cansando…', 'Jajaja.']
  DATABASE["약초꾼A"] = ['Es difícil ganarse la vida…', 'Sigh, vamos a descansar un poco.', 'Es más difícil de encontrar de lo que pensaba…', '….', 'Las hierbas…', 'Debo encontrar una solución…']

  DATABASE["납치당한여성"] = ['Po… por favor….', 'No… no puedo ver…', '… ….', '….', 'Sob….', '¿Dónde estoy…?', 'Ah… ah….', 'Mátame….', 'No puedo soportar más…', 'Así no puedo….', 'Malditos goblins….', 'Por favor, sálvame….', 'Papá, llorando…']
  DATABASE["생존자"] = ['Po… por favor….', 'Por favor, sálvame….', '… ….', '….', 'Sob….', 'Alguien… por favor.', 'Ah… ah….', 'No… no quiero.', 'No puedo soportar más…', 'Por favor, sálvame….']

  DATABASE["아들1"] = ['Quiero salir a jugar…', 'Quería jugar más…', '….', '¿Cuándo viene mamá?', 'Echo de menos a mamá…', 'Quiero salir a jugar.', '¡Que te vaya bien!', '¿Volverás pronto?']
  DATABASE["딸1"] = ['Quiero salir a jugar…', 'Quería jugar más…', '….', '¿Cuándo viene mamá?', 'Echo de menos a mamá…', 'Quiero salir a jugar.', '¡Que te vaya bien!', '¿Volverás pronto?']

  DATABASE["목마른_동굴"] = ['….', 'Agua…', 'Necesito agua…']
  DATABASE["수감자"] = ['….', '….', '….', '….', 'Preferiría morir aquí…', 'Ugh…', 'Ten cuidado…', 'Es un demonio…', 'No es un monstruo…', 'Mi compañero aún…', '¡Maldita sea! Ugh…', 'Traidor…', 'El ogro…', 'Un poco más…', 'Ese tipo…', 'Si te descuidas…', 'No confíes en nadie…']
  DATABASE["꼬마(남)"] = ['….', '….', '….', '….', '… ….', '¡Jejeje!♪', '¡Despeja el camino!', '¡Recibe la espada de la justicia!', '¡Tengo hambre!', '¡Estoy aburrido!', 'Quiero tocar pechos…', '¡Toma esto, ataque sorpresa!']
  DATABASE["꼬마(여)"] = ['….', '….', '….', '….', '… ….', 'No tengo suficiente dinero…', '¿Podré vender algo hoy?', 'Los adultos son mentirosos…', 'Echo de menos a mamá…', 'Es difícil…']

  DATABASE["도적"] = ['….', '….', '….', '….', 'Ah, estoy aburrido.', '¿Qué es ese ruido?', '¡Qué molesto!', '¡Jaja!', '¡Kya-ha!', '¿Qué?', 'Esa vez, esa chica…', 'Sus pechos eran increíbles…']
  DATABASE["도적2"] = ['….', '….', '….', '….', 'Ke-ke…', '¿A dónde vas?', '¡Hace tiempo que no veo una mujer!', '¡Déjame ver tu trasero!', '¿Solo una vez?', '¡Ríndete ahora!', '¡Jaja!', '¡Kya-ha!']
  DATABASE["고블린"] = ['….', '….', '….', '….', '… ….', '¿Keke!?', '¿Kek!?', '¡Humano! ¡Humano!?', '¿Huele a humano!?', '¡Tengo hambre!?', '¿El humano sabe bien!?', '¿Huele delicioso!?', '….']
  DATABASE["고블린2"] = ['….', '….', '….', '….', '… ….', '¿Keke!?', '¿Kek!?', '¡Atrápalo!?', '¡Atrapa al humano!?', '¡Tengo hambre!?', '¡Es un humano delicioso!?', '¡Ese humano es mío!?', '….']
  DATABASE["스켈레톤"] = ['….', '….', '….', '….', '… ….', 'Creak…', 'Creak… creak….']
  DATABASE["스켈레톤2"] = ['….', '….', '….', '….', '… ….', 'Creak…', 'Creak… creak….', 'Huele a sangre…', 'Maldición…', 'Te mataré…', 'Destrozar…', 'Huesos y carne…', 'Sin miedo…', 'Te enviaré…', '¿Cómo te atreves…', 'Este suelo… está manchado…', 'Mereces morir…']

  DATABASE["오크"] = ['….', 'Grr.', 'Estoy aburrido', '¿De dónde viene ese olor…?', '¿Qué es ese ruido?', '¿Hay humanos?', '¡Olor a mujer!', '¡Rrrr!']
  DATABASE["오크2"] = ['….', '¿Mujer humana?', '¿Mujer? ¿Mujer?', '¡Luchemos!', '¡Ven aquí!', '¡Ven!', '¡Olor a genitales!', '¡Ke-ke!', '¡Esto será divertido!', '¡Quiero escuchar gritos!', '¡¿Qué sabor tendrá?!']

  DATABASE["블랙오크"] = ['¡Waaagh!!', 'Necesito carne!', 'Estoy aburrido', '¿De dónde viene ese olor…?', '¿Qué es ese ruido?', '¡Carne de hembra!', '¡Olor a mujer! ¡Carne!', '¡Waaagh!!']
  DATABASE["블랙오크2"] = ['¡Waaagh!!', '¿Mujer humana?', '¿Guerrera hembra? ¡Waaagh!!', '¡Atrapa a esa hembra!', '¡Ven, pedazo de carne!', '¡Se ve suave!', '¡Olor a genitales!', '¡Waaaaagh!!', '¡Carne de hembra!', '¡Quiero escuchar gritos!', '¡Pedazo de carne pequeño!']

  DATABASE["듀라한"] = ['….', 'Vas a morir.', '¿No escuchas esa canción?', 'Corre entonces.']
  DATABASE["오우거"] = ['….', '….', '¡Tengo hambre!', 'Tengo hambre.', '….', '….', 'Ke-ke….', 'Buen olor…', '¡Ke-ke!']
  DATABASE["오우거2"] = ['….', '….', '….', '¡Grr! ¡Humano!', '¡Ja-ja!', 'No… no puedes escapar!', '?!', '¡Buen olor!', '¡Ke-ke!', '¡Te encontré! ¡Humano!', 'Ke-ke….', 'Buen olor…', '¡Ke-ke!']

  DATABASE["모험가"] = ['….', '….', '….', '….', 'Es cuestión de voluntad…', 'Será suficiente…', 'Con esto…', 'Es un final feliz…', 'No había otra manera…', 'Tengo que intentarlo de nuevo…', 'Necesito una nueva armadura.', 'Hmm… y una nueva arma también…', 'Sigh…']
  DATABASE["모험가2"] = ['….', '….', '….', '….', 'Esa cueva subterránea era muy peligrosa.', 'Pensé que iba a morir…', 'De repente quiero una bebida.', 'Voy a quedarme sin dinero…', 'Necesito algo valioso…', 'Estoy cansado…', 'El clima es realmente bueno.', 'Maldita sea…', 'Uf, lentamente…', 'Necesito una mejor arma…']
  DATABASE["모험가3"] = ['….', '….', '….', '….', 'Es muy tarde…', 'Ya es hora…', 'Maldito…', 'Voy a hacerte pagar.', 'Tsk…', '¿Qué pasa…?', 'Sigh…']
  DATABASE["고양이"] = ['….', '….', '….', '….', '… ….', '¡Miau!♪', '¡Miaauu-ñau♬']
  DATABASE["엘리자"] = ['….', '….', '….', '….', '… ….', 'Que la bendición esté contigo….', 'No te exijas demasiado.', 'Hoy también hace buen tiempo.', 'Si llueve….', 'Algún día….', 'Otra vez te exiges tanto….', 'Sid Roa….', 'En la tierra sin nombre….', 'A la misericordiosa Riad…', 'Sobre los demonios…', 'Los monstruos son el mal.', '¿Cuándo vendrá el salvador…?', 'Para los aventureros….']
  DATABASE["나쁜모험가"] = ['….', '….', '….', '….', '… ….', '¿Hola?', '¿Podría hablar con usted un momento?', '¿Tiene un momento?', '¿Hay alguien ahí?', '¿Podría ayudarme?', 'Ugh… algo de comida….', '¡Aquí! ¡Por aquí!', '¡Ayuda!', '¿Aventurero?', 'Un momento….', 'Con permiso….']
end