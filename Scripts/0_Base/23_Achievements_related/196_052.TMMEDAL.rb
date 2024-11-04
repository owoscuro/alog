# encoding: utf-8
# Name: 052.TMMEDAL
# Size: 5124
# encoding: utf-8
# Name: 052.TMMEDAL
# Size: 4946
module TMMEDAL
  COMMAND_MEDAL = "Lista de logros"

  # 메달 획득시 효과음
  SE_GAIN_MEDAL = RPG::SE.new("Powerup", 90, 140)
  
  # 메달 이름과 아이콘 ID와 설명 설정
	MEDAL_DATA = {}
	MEDAL_DATA[0] = [" ¡Perdida de virginidad!", 721, "¡Rompiste el himen con \\C[1]\\V[55]\\C[0]! ¿Ya soy adulta?"]
	MEDAL_DATA[1] = [" ¡Receptáculo de semen!", 785, "¡Recibiste una eyaculación vaginal! ¿No es peligroso esto?"]
	MEDAL_DATA[2] = [" ¡Bueno para la piel!", 785, "¡Recibiste una eyaculación externa! ¡Siento que mi piel está mejorando!"]
	MEDAL_DATA[3] = [" ¡Veo Hong Kong!", 1116, "¡Alcanzaste el clímax por primera vez! ¡El mundo es hermoso!"]
	MEDAL_DATA[4] = [" ¡Veo el cosmos!", 1116, "¡Alcanzaste el mega clímax por primera vez! ¡Siento que mi cuerpo va a volar!"]
	MEDAL_DATA[5] = [" ¡Tutorial completado!", 1384, "¡Completaste el tutorial del registro de aventuras! ¡Genial!"]
	MEDAL_DATA[6] = [" ¡Contrataste un mercenario!", 3870, "¡Contrataste un mercenario! ¡Qué confiable!"]
	MEDAL_DATA[7] = [" ¡Comilona!", 1690, "¡No importa cuánto comas, siempre tienes hambre! Adquiriste la habilidad (característica) de 'Glotonería' por no comer adecuadamente.\nSi mantienes una dieta regular, parece que perderás la habilidad de 'Glotonería'."]
	MEDAL_DATA[8] = [" ¡Adquiriste Torbellino!", 3615, "¡Aprendiste la técnica definitiva del guerrero, Torbellino!"]
	MEDAL_DATA[9] = [" ¡Promiscua!", 785, "¡Alcanzaste 1000 relaciones sexuales! ¿No eres una completa promiscua?"]
	MEDAL_DATA[10] = [" ¡Me encanta la masturbación!", 785, "¡Alcanzaste 1000 masturbaciones! ¿No eres adicta a la masturbación?"]
	MEDAL_DATA[11] = [" ¡Estoy embarazada!", 1395, "¡Una nueva vida ha comenzado dentro de ti!"]
	MEDAL_DATA[12] = [" ¡Derrotaste a Mammon!", 911, "¿Mammon? ¡Es una basura cuando se enfrenta a mí!"]
	MEDAL_DATA[13] = [" ¡Propietaria del bosque!", 3496, "El culto de El Zairen me dio la propiedad del bosque como regalo sagrado. ¿Es este mi terreno?"]
	MEDAL_DATA[14] = [" ¡Propietaria del río!", 3496, "El culto de El Zairen me dio la propiedad del río esta vez. ¡Wow...!"]
	MEDAL_DATA[15] = [" ¡Donante de 100 yenes!", 3474, "¡Gracias! ¡Que la bendición de Erni esté contigo!"]
	MEDAL_DATA[16] = [" ¡Donante de 1000 yenes!", 3475, "¡Gracias! ¡Tu Erni es digna de la bendición de la diosa!"]
	MEDAL_DATA[17] = [" ¡Donante de 3000 yenes!", 3477, "¡Muchas gracias! ¡Este mundo ama a tu Erni!"]
	MEDAL_DATA[18] = [" ¡Superaste los límites!", 1385, "¡Alcanzaste el nivel 200! Erni ha superado los límites humanos. \\C[3](Puntos de habilidad +20)\\C[0]"]
	MEDAL_DATA[19] = [" ¡Contrataste un mercenario!", 3870, "¡Contrataste un mercenario! ¡Qué confiable!"]
	MEDAL_DATA[20] = [" ¡Donante de 2000 yenes!", 3476, "¡Muchas gracias! ¡Este mundo le gusta tu Erni!"]
	MEDAL_DATA[21] = [" ¡Propietaria de una casa!", 3454, "¡Aunque fue muy, muy caro, compraste una casa!"]
	MEDAL_DATA[22] = [" ¡Pequeña comedora!", 1691, "¡Te llenas con poco! Mantuviste una dieta regular y adquiriste la habilidad (característica) de 'Moderación'.\nSi no mantienes una dieta regular, parece que perderás la habilidad de 'Moderación'."]
	MEDAL_DATA[23] = [" ¡Dardo Tornado!", 1302, "¡Moja y brilla siguiendo el relámpago, chispa y brilla!"]
	MEDAL_DATA[24] = [" ¡Monje de El Zairen!", 929, "¡La fe es buena, pero cuida tus rodillas!"]
	MEDAL_DATA[25] = [" ¡Justiciera!", 1035, "¡Lograste derrotar a 500 bandidos! ¡En un mundo caótico, eres verdaderamente justiciera!"]
	MEDAL_DATA[26] = [" ¡Más fuerte, por favor!", 1139, "¡Alcanzaste 999 golpes recibidos! ¡Me siento extraña después de tanto golpear! ¡Hiii!"]
	MEDAL_DATA[27] = [" ¡Sobreviviente!", 1222, "¡Gran capacidad de supervivencia! ¡Ten cuidado!"]
	MEDAL_DATA[28] = [" ¡Sangre, sangre!", 1176, "¡Alcanzaste 100 estados de herida y sangrado! ¡¿Mi sangre es tu dolor?! ¡Necesito vendajes!"]
	MEDAL_DATA[29] = [" ¡Exploradora!", 1326, "¡Visitaste todas las áreas principales!"]
	MEDAL_DATA[30] = [" ¡Rompepuertas!", 1251, "¡Alcanzaste 100 puertas rotas! ¡Las puertas no se abren, se rompen!"]
	MEDAL_DATA[31] = [" ¡Cazadora de goblins!", 1035, "¡Lograste derrotar a 1000 goblins! ¿Eres la cazadora de goblins?"]
	MEDAL_DATA[32] = [" ¡Contrataste un mercenario!", 3870, "¡Contrataste un mercenario! ¡Qué confiable!"]
	MEDAL_DATA[33] = [" ¡Ascendiste a rango de hierro!", 3617, "¡Cambiado a rango de mercenario de hierro! ¡Esto recién comienza!"]
	MEDAL_DATA[34] = [" ¡Ascendiste a rango de plata!", 3618, "¡Cambiado a rango de mercenario de plata! ¡Ahora siento un poco de reconocimiento!"]
	MEDAL_DATA[35] = [" ¡Derrotaste a Atlach-Nacha!", 911, "¡Derrotaste a Atlach-Nacha en el piso 10 del subterráneo de las ruinas de la base de Faradel!"]
	MEDAL_DATA[36] = [" ¡Derrotaste a Ithaqua!", 911, "¿Un gran lobo? ¡Derrotaste a Ithaqua en la cueva helada!"]
	MEDAL_DATA[37] = [" ¡Derrotaste a la Madre del Enjambre!", 911, "¡Derrotaste a la Madre del Enjambre! ¡Extraño a mi mamá!"]
  
end