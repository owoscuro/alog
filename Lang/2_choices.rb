# encoding: utf-8

# Lang::TEXTS[:choices][:command][:forward]
module Lang
	TEXTS[:choices][:command] = {
		forward: "Empujar hacia adelante.", # Original:  앞으로 민다.
		backward_pull: "Tirar hacia atrás.", # Original: 뒤로 당긴다.
		spray_water: "Rociar agua.", # Original: 물을 뿌린다.
		cook: "Cocinar.", # Original: 요리한다.
		cancel: "Cancelar.", # Original: 취소한다.
		use_match: "Usar fósforo.", # 성냥을 사용한다.
		rest: "Descansar.", # 휴식한다.
		take_down_tent: "Recoger tienda.", # 천막을 회수한다.
		remove_barrier: "Eliminar barrera.", # 방책을 제거한다.
		use_pickaxe: "Usar pico.", # Original: 곡괭이를 사용한다.
		use_scythe: "Usar hoz.", # Original: 낫을 사용한다.
		use_saw: "Usar sierra.", # 톱을 사용한다.
		donate_money: "Donar dinero.", # 돈을 기부한다.
		donate: "Donar.", # 기부한다.
		use_lockpick: "Usar ganzúa.", # 락픽을 사용한다.
		use_old_key: "Usar llave vieja.", # 낡은 열쇠를 사용한다.
		use_copper_key: "Usar llave de cobre.", # 구리 열쇠를 사용한다.
		use_iron_key: "Usar llave de hierro.", # 철 열쇠를 사용한다.
		use_mithril_key: "Usar llave de mithril.", # 미스릴 열쇠를 사용한다.
		close_door: "Cerrar puerta.", # 문을 닫는다.
		open_door: "Abrir puerta.", # 문을 연다.
		fix_torch: "Reparar antorcha.", # 횃불을 고친다.
		use_lunatic_key: "Usar llave lunática.", # 루나틱 열쇠를 사용한다.
		search_corpse: "(Revisar cuerpo)",  # (시체를 뒤적거린다.)
		recover_corpse: "(Recoger cuerpo).", # (시체를 수습한다.)
		carry_male_corpse: "(Levantar cuerpo masculino)", # (남성의 시체를 올린다.)
		carry_female_corpse: "(Levantar cuerpo femenino)", # (여성의 시체를 올린다.)
		buy_weapon_armor_enchant: "Comprar arma/armadura (Encantar)", # 무기, 방어구 구매(인챈트)
		earn_money: "Obtener dinero.", # 돈 획득
		hire_alek_turner: "Contratar a Alek Turner.", # 알렉 터너 고용
		hire_juust: "Contratar a Juust.", # 주스트 고용
		level_up: "Subir de nivel.", # 레벨 업
		set_world_difficulty: "Establecer dificultad del mundo.", # 월드 난이도 설정
		open_debug_cheat: "Abrir trampa de depuración.", # 디버깅 치트 열기
		heal_all: "Recuperar todo.", # 모두 회복
		learn_special_skill_whirlwind: "Aprender habilidad especial: Torbellino.", # 특수스킬 : 휠윈드 배우기
		summon_rat_1: "Invocar rata 1.", # 쥐 1 소환
		summon_rat_2: "Invocar rata 2.", # 쥐 2 소환
		summon_rabbit: "Invocar conejo.", # 토끼 소환
		summon_deer: "Invocar ciervo.", # 사슴 소환
		summon_wolf: "Invocar lobo.", # 늑대 소환
		summon_bear: "Invocar oso.", # 곰 소환
		summon_grizzly_bear: "Invocar oso gris.", # 회색곰 소환
		summon_slime: "Invocar slime.", # 슬라임 소환
		summon_nelly_slime: "Invocar Nelly Slime.", # 넬리 슬라임 소환
		summon_rafflesia_1: "Invocar Rafflesia 1.", # 라플레시아 1 소환
		summon_rafflesia_2: "Invocar Rafflesia 2.", # 라플레시아 2 소환
		summon_skeleton_1: "Invocar esqueleto 1.", # 스켈레톤 1 소환
		summon_skeleton_2: "Invocar esqueleto 2.", # 스켈레톤 2 소환
		summon_skeleton_3: "Invocar esqueleto 3.", # 스켈레톤 3 소환
		summon_skeleton_4: "Invocar esqueleto 4.", # 스켈레톤 4 소환
		summon_skeleton_5: "Invocar esqueleto 5.", # 스켈레톤 5 소환
		summon_skeleton_6: "Invocar esqueleto 6.", # 스켈레톤 6 소환
		summon_bandit_1: "Invocar bandido 1.", # 도적 1 소환
		summon_bandit_2: "Invocar bandido 2.", # 도적 2 소환
		summon_bandit_3: "Invocar bandido 3.", # 도적 3 소환
		summon_bandit_4: "Invocar bandido 4.", # 도적 4 소환
		summon_bandit_5: "Invocar bandido 5.", # 도적 5 소환
		summon_dullahan_1: "Invocar Dullahan 1.", # 듀라한 1소환
		summon_dullahan_2: "Invocar Dullahan 2.", # 듀라한 2소환
		summon_orc_1: "Invocar orco 1.", # 오크 1 소환
		summon_orc_2: "Invocar orco 2.", # 오크 2 소환
		summon_orc_3: "Invocar orco 3.", # 오크 3 소환
		summon_orc_4: "Invocar orco 4.", # 오크 4 소환
		summon_orc_5: "Invocar orco 5.", # 오크 5 소환
		summon_orc_6: "Invocar orco 6.", # 오크 6 소환
		summon_zombie_1: "Invocar zombi 1.", # 좀비 1 소환
		summon_zombie_2: "Invocar zombi 2.", # 좀비 2 소환
		summon_ghoul: "Invocar ghoul.", # 구울 소환
		summon_hornet_1: "Invocar avispón 1.", # 호넷 1 소환
		summon_hornet_2: "Invocar avispón 2.", # 호넷 2 소환
		summon_bat: "Invocar murciélago.", # 박쥐 소환
		summon_small_lesser_taratect_1: "Invocar pequeña tarántula menor 1.", # 스몰 레서 타라텍트 1 소환
		summon_small_lesser_taratect_2: "Invocar pequeña tarántula menor 2.", # 스몰 레서 타라텍트 2 소환
		summon_small_lesser_taratect_3: "Invocar pequeña tarántula menor 3.", # 스몰 레서 타라텍트 3 소환
		summon_small_poison_taratect: "Invocar pequeña tarántula venenosa.", # 스몰 포이즌 타라텍트 소환
		summon_ticktail: "Invocar Ticktail.",
		summon_tentacle: "Invocar tentáculo.",
		summon_goblin_1: "Invocar goblin 1.",
		summon_goblin_2: "Invocar goblin 2.",
		summon_goblin_3: "Invocar goblin 3.",
		summon_hobgoblin_1: "Invocar hobgoblin 1.",
		summon_hobgoblin_2: "Invocar hobgoblin 2.",
		summon_hobgoblin_3: "Invocar hobgoblin 3.",
		summon_hobgoblin_4: "Invocar hobgoblin 4.",
		summon_ogre: "Invocar ogro.",
		summon_giant_worm: "Invocar gusano gigante.",
		summon_atlaq_nacha: "Invocar Atlaq Nacha.",
		summon_mamon: "Invocar Mamon.",
		summon_itaqua: "Invocar Itaqua.",
		want_to_trade: "Quiero hacer un intercambio.", # 거래를 하고 싶어요.
		had_your_child: "Tuve a tu hijo...", # 당신의 아이를 낳았어….
		enter: "Entrar.", # 들어간다.
		give_food_gifts: "Regalar comida u otras cosas.", # 음식등을 선물한다.
		looking_for_work: "Estoy buscando trabajo.", # 일거리를 찾고 있다.
		use_room_key: "Usar llave de la habitación.", # 방 열쇠를 사용한다.
		want_to_ask: "Quiero preguntar algo.", # 물어보고 싶은게 있습니다.
		about_likes: "Sobre sus gustos.", # 좋아하는 것에 대해서,
		about_idine: "Sobre Idine.", # 이딘에 대해서,
		about_atel_reine: "Sobre Atel Reine.", # 아텔 레이네에 대해서,
		about_atel_reine_parents: "Sobre los padres de Atel Reine.", # 아텔 레이네 부모에 대해서,
		use_palselin_warehouse: "Usar almacén de Palselin.", # 팔세린 창고를 이용한다.
		use_seraiten_warehouse: "Usar almacén de Seraiten.", # Seraiten 창고를 이용한다.
		use_slyne_warehouse: "Usar almacén de Slyne.", # 슬라인 창고를 이용한다.
		use_vailas_warehouse: "Usar almacén de Vailas.", # 바일라스 창고를 이용한다.
		report_mission: "Vengo a informar una misión.", # 의뢰 보고를 하려고 왔습니다.
		want_to_buy_house: "Quiero comprar una casa.", # House을 사고 싶어요.
		empty_house_a: "Casa vacía A (contribución 11%)", # Empty House A (공헌도 11%)
		empty_house_b: "Casa vacía B (contribución 11%)", # Empty House B (공헌도 11%)
		contract: "Firmar un contrato.", # 계약한다.
		accept_quest: "Aceptar misión.", # 의뢰를 수주한다.
		exit_quest_board: "Salir del tablón de misiones.", # 의뢰 게시판을 나간다.
		enter_with_keyboard: "Escribir con teclado.",
		enter_with_virtual_keyboard: "Escribir con teclado virtual.", # 가상 키보드로 입력한다.
		shortcut_keys_for_weapons_tools: "Teclas rápidas para armas y herramientas", # 무기, 도구등 단축키 사용법!
		how_to_recover_needs: "¡Cómo recuperar necesidades!", # 욕구 회복 방법!
		how_to_learn_skills: "¡Cómo aprender habilidades!", # 스킬 배우는 방법!
		basic_shortcut_types: "¡Tipos básicos de teclas de acceso rápido!", # 기본적인 단축키 종류!
		end_tutorial: "¡Finalizar tutorial!", # 튜토리얼 종료!
		very_easy: "MUY FÁCIL", # VERY EASY, 매우 쉬움
		easy: "FÁCIL", # EASY, 쉬움
		normal: "NORMAL", # NORMAL, 보통
		hard: "DIFÍCIL", # HARD, 어려움
		hell: "INFIERNO", # HELL, 지옥
		lunatic: "LUNÁTICO", # LUNATIC, 루나틱
		# january_winter: "Enero (invierno)", # 1월(겨울)
		# february_winter: "Febrero (invierno)", # 2월(겨울)
		# march_winter: "Marzo (invierno)", # 3월(겨울)
		# april_spring: "Abril (primavera)", # 4월(봄)
		# may_spring: "Mayo (primavera)", # 5월(봄)
		# june_summer: "Junio (verano)", # 6월(여름)
		# july_summer: "Julio (verano)", # 7월(여름)
		# august_summer: "Agosto (verano)", # 8월(여름)
		# september_summer: "Septiembre (verano)", # 9월(여름)
		# october_fall: "Octubre (otoño)", # 10월(가을)
		# november_fall: "Noviembre (otoño)", # 11월(가을)
		# december_winter: "Diciembre (invierno)", # 12월(겨울)
	    january_winter: "Ene (inv)",   # 1월(겨울)
	    february_winter: "Feb (inv)",  # 2월(겨울)
	    march_winter: "Mar (inv)",     # 3월(겨울)
	    april_spring: "Abr (prim)",    # 4월(봄)
	    may_spring: "May (prim)",      # 5월(봄)
	    june_summer: "Jun (ver)",      # 6월(여름)
	    july_summer: "Jul (ver)",      # 7월(여름)
	    august_summer: "Ago (ver)",    # 8월(여름)
	    september_summer: "Sep (ver)", # 9월(여름)
	    october_fall: "Oct (oto)",     # 10월(가을)
	    november_fall: "Nov (oto)",    # 11월(가을)
	    december_winter: "Dic (inv)",   # 12월(겨울)
		axe: "Hacha", # 도끼
		knuckles: "Nudillos", # 너클
		spear: "Lanza", # 창
        sword: "Espada", # 검
        sabre: "Katana", # 도
        bow: "Arco", # 활
        dagger: "Daga", # 단검
        mace: "Maza", # 메이스
        staff: "Báculo", # 지팡이
        proceed_with_tutorial: "Proceder con el tutorial.", # 튜토리얼을 진행한다.
        proceed_now: "Proceder ahora.", # 바로 진행한다.
        brought_treasure_from_underground: "Traje un tesoro de la guarida subterránea.", # 지하소굴에서 보물을 찾아 왔어요.
        refuse: "Rechazar.", # 거절한다.
        use_match: "Usar cerilla.", # 성냥을 사용한다
        use_frying_pan: "Usar sartén.", # 프라이팬을 사용한다.
        want_to_use_horse: "Quiero usar el caballo.", # 말을 이용하고 싶다. - The word “말” in Korean can mean “horse” or “words”.  
		check_mercenary_info: "Revisar info del mercenario", # 용병 정보를 확인한다.
		can_you_tell_me_restaurant_location: "¿Dónde está el restaurante?", # 식당 위치 좀 알려줄 수 있나요?
		can_you_tell_me_smithy_location: "¿Dónde está la herrería?", # 대장간 위치 좀 알려줄 수 있나요?
		can_you_tell_me_inn_location: "¿Dónde está la posada?", # 여관 위치 좀 알려줄 수 있나요?
		can_you_tell_me_guild_location: "¿Dónde está el gremio?", # 길드 위치 좀 알려줄 수 있나요?
        about_mamon: "Sobre Mamon",
        about_archmage_seila: "Sobre la archimaga Seila",
        about_pregnancy: "Sobre el embarazo",
        about_abortive_injection: "Sobre la inyección abortiva",
        about_elves: "Sobre los elfos",
        about_level_points: "Sobre los puntos de nivel",
        about_forgetfulness_elixir: "Sobre el elixir del olvido",
        about_bailas_village: "Sobre el pueblo de Bailas",
  		can_you_tell_me_general_store_location: "¿Dónde está la tienda general?", # 일반 상점 위치 좀 알려줄 수 있나요?
  		here_for_task_terian_requested: "Vine por el encargo de Terian.", # 테리안이 요청한 일로 왔습니다.
        pray: "Orar.",
        want_donations: "Quiero recibir donaciones.",
        empty_house_a_21: "Casa vacía A (contribución 21%)",
        want_to_dismantle: "Quiero desmantelar objetos.", # 물건을 분해하고 싶어요.
        want_to_enchant_equipment: "Quiero encantar equipo.", # 장비에 인챈트를 하고 싶어요.
        want_to_request_repair: "Quiero pedir una reparación.", # 수리를 부탁하고 싶어요.
        came_to_learn_whirlwind: "Vine a aprender Torbellino.", # 휠윈드를 배우려고 왔습니다.
        about_whirlwind: "Sobre Torbellino.", # 휠윈드에 대해서,
        about_power_of_crystal: "Sobre el poder de los cristales mágicos.", # 마결정의 힘에 대해서,
        about_darwin: "Sobre Darwin.", # 다윈에 대해서,
        proceed: "Proceder.", # 진행한다.
        skip: "Omitir.", # 생략한다.
        about_beastmen: "Sobre los hombres bestia.", # 수인에 대해서, - to be corrected. For the moment “beast man” would be more accurate.
        about_inn: "Sobre la posada.", # 여관에 대해서,
        about_magic_scrolls: "Sobre los pergaminos mágicos.", # 마법 스크롤에 대해서,
        about_gate_incident: "Sobre el incidente de la puerta.", # 게이트 사건에 대해서,
        about_lies: "Sobre las mentiras.", # 거짓말에 대해서,
        want_special_meal: "Quiero una comida especial.", # 특식을 먹고 싶어요.
        so_hungry: "Tengo... mucha hambre.", # 배가… 배가 고파요.
        yes_want_to_eat: "¡Sí, quiero comer!", # 네, 먹고 싶어요!
        who_are_you: "¿Quién eres?", # 당신은 누구신가요?
        what_are_you_doing_here: "¿Qué estás... haciendo aquí?", # 여기서 뭐하고… 계신가요?
        want_to_challenge_itaqua: "Quiero desafiar a Itaqua.", # 이타콰에게 도전하고 싶다.
        shortcut_to_itaqua: "Atajo hacia Itaqua...", # 이타콰에게 가는 지름길….
        ok_please_guide_me: "De acuerdo, por favor guíame.", # 알겠습니다, 안내를 부탁합니다.
        use_warehouse: "Usar almacén.", # 창고를 이용한다.
        check_land_info: "Ver información del terreno.", # 땅 정보를 확인한다.
        rename_land: "Cambiar nombre del terreno.", # 땅 이름을 변경한다.
        about_trolls: "Sobre los trolls.", # 트롤에 대해서,
        about_horifel: "Sobre Horifel.", # 호리펠에 대해서,
        touch_with_hands: "Tocar con las manos.", # 손으로 만진다.
        equipped_weapon: "Arma equipada.", # 무기를 착용했습니다.
		basic_shortcut_keys_part1: "Teclas de acceso rápido (1)", # 기본적인 단축키 종류 1편!
		basic_shortcut_keys_part2: "Teclas de acceso rápido (2)", # 기본적인 단축키 종류 2편!
        no_thanks_enough: "Gracias, ya es suficiente.", # 감사합니다, 이제 충분합니다.
        too_late: "¡Es demasiado tarde!", # 너무 늦잖아요!
        leave_to_reinforcements: "(Se lo deja a los refuerzos y se retira).", # (지원군에게 맡기고 돌아간다.)
        just_need_to_get_you_out: "¿Sólo tengo que sacarte de aquí?", # 꺼내드리면 되는거죠?
        hurt_if_hit_bars: "¿Dolerá si golpeo las rejas?", # 창살을 때리면 아픈건가요?
        looks_like_trap: "Parece una trampa...", # 딱 봐도 함정이 있어 보이는데….
        how_opened_chest: "¿Cómo has abierto el cofre?", # 보물상자는 어떻게 열었네요?
        how_to_open_clues: "¿Cómo lo abro? ¿No hay pistas?", # 어떻게 열죠? 단서라도 없나요?
        look_around: "Voy a echar un vistazo.", # 한번 둘러보고 올께요.
        take_out_blue_gem: "Sacar la gema azul.", # 푸른색 보석을 꺼낸다.
        forgive_and_take_reward: "(Perdona y acepta la recompensa).", # (보상금을 받고 용서한다.)
        report_to_guild: "(Informar al gremio).", # (길드에 보고한다.)
        pull_handle: "Tirar del mango.", # 손잡이를 당긴다.
        about_hornet: "Sobre los avispones.", # 호넷에 대해서,
        about_fruit_vendor: "Sobre el vendedor de frutas.", # 과일 장사에 대해서, - Text not found- who knows where the hell it ended up. lmao
        about_dwarves: "Sobre los enanos.", # 드워프에 대해서, - Text not found-
        here_for_delivery_request: "Vengo a entregar los suministros.", # 물품 배달하기 의뢰를 보고 왔어요. - Text not found-
        about_mithril: "Sobre el mithril.", # 미스릴에 대해서, - Text not found-
        about_zirconium: "Sobre el circonio.", # 지르코늄에 대해서, - Text not found-
        about_goblins: "Sobre los goblins.", # 고블린에 대해서, - Text not found-
        about_palseirin_security: "Sobre la seguridad en Palseirin.", # 팔세린의 치안에 대해서, - Text not found-
        about_female_mercenaries_adventurers: "Sobre las mercenarias y aventureras.", # 여성 용병, 모험가에 대해서, - Text not found-
        about_prayer: "Sobre la oración.", # 기도에 대해서, - Text not found-
        about_true_faith: "Sobre la verdadera fe.", # 진정한 신앙심에 대해서, - Text not found-
        steal_items: "Robar objetos.", # 물건을 훔친다. - Text not found-
        about_quests: "Sobre las misiones.", # 의뢰에 대해서, - Text not found-
        about_strange_quests: "Sobre misiones extrañas.", # 이상한 의뢰에 대해서, - Text not found-
        about_lapalie_olr: "Sobre Lapalie Olr.", # 라팔리 올르에 대해서, - Text not found-
        want_to_take_mercenary_promotion_exam: "Quiero hacer el examen de ascenso de mercenario.", # 용병 승급 시험을 받고 싶다. - Text not found-
        empty_house_b_5: "Casa vacía B (contribución 5%)", # Empty House B (공헌도 5%) - Text not found-
        about_guards: "Sobre los guardias.", # 경비병에 대해서, -Text not found-
        about_village: "Sobre el pueblo.", # 마을에 대해서, -Text not found-
        about_jobs: "Sobre los trabajos.", # 일거리에 대해서, -Text not found-
        about_ogres: "Sobre los ogros.", # 오우거에 대해서, -Text not found-
        about_simple_tasks: "Sobre tareas simples.",  # 간단한 의뢰에 대해서, -Text not found-
        about_pots: "Sobre las vasijas.", # 항아리에 대해서, -Text not found-
        want_to_enter_cave: "Quiero entrar en la cueva.", # 동굴에 들어가 보고 싶다. -Text not found-
        about_gate_incident_missing_people: "Desaparecidos en el incidente de la puerta.", # 게이트 사건 실종자들에 대해서, -Text not found
		about_ailo_village: "Sobre el pueblo de Ailo.", # 아일로 마을에 대해서, -Text not found-

		# Yeah- I fall asleep doing this.
		
		about_goddess_statue: "Sobre la estatua de la diosa.", 
		about_archbishop: "Sobre el arzobispo.",
		about_cave: "Sobre la cueva.",
		about_skeleton: "Sobre el esqueleto.",
		about_saint: "Sobre la santa.",
		about_el_zyren_order: "Sobre la orden de El Zyren.",
		about_slime: "Sobre los slimes.",
		here_for_bear_pelt_delivery: "Vengo por el encargo de entregar pieles de oso.",
		here_at_silvia_request: "He venido por el encargo de Silvia.",
		about_traps: "Sobre las trampas.",
		about_trap_mine_defusal: "Sobre la desactivación de trampas y minas.",
		about_weight: "Sobre el peso.",
		about_el_raizen_order: "Sobre la orden de El Raizen.",
		about_seraiten_village: "Sobre el pueblo de Seraiten.",
		about_small_lesser_taratect: "Sobre la pequeña Lesser Taratect.",
		about_medicinal_herbs: "Sobre las hierbas medicinales.",
		about_sirwen: "Sobre Sirwen.",
		about_paradel: "Sobre Paradel.",
		here_for_mushroom_delivery: "Vengo por el encargo de entregar setas.",
		about_ailo_village: "Sobre el pueblo de Ailo.",
		about_goddess_statue: "Sobre la estatua de la diosa.",
		about_archbishop: "Sobre el arzobispo.",
		about_cave: "Sobre la cueva.",
		about_skeleton: "Sobre el esqueleto.",
		about_saint: "Sobre la santa.",
		about_el_zyren_order: "Sobre la orden de El Zyren.",
		about_slime: "Sobre los slimes.",
		here_for_bear_pelt_delivery: "Vengo por el encargo de entregar pieles de oso.",
		here_at_silvia_request: "He venido por el encargo de Silvia.",
		about_traps: "Sobre las trampas.",
		about_trap_mine_defusal: "Sobre la desactivación de trampas y minas.",
		about_weight: "Sobre el peso.",
		about_el_raizen_order: "Sobre la orden de El Raizen.",
		about_seraiten_village: "Sobre el pueblo de Seraiten.",
		about_small_lesser_taratect: "Sobre la pequeña Lesser Taratect.",
		about_medicinal_herbs: "Sobre las hierbas medicinales.",
		about_sirwen: "Sobre Sirwen.",
		about_paradel: "Sobre Paradel.",
		here_for_mushroom_delivery: "Vengo por el encargo de entregar setas.",

	}
end