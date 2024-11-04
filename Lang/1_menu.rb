# encoding: utf-8

module Lang
  # Window_MenuCommand
  TEXTS[:interface][:menu_command] = {
    item: "Inventario",
    skill: "Habilidades",
    equip: "Equipo",
    status: "Estadísticas",
    distribute_parameter: "Puntos Nivel",
    skill_learn: "Aprender Habs.",
    recipes: "Recetas",
    stateview: "Estados",
    quest_journal: "Misiones",
    medal: "Logros",
    roster: "Compañeros",
    factions: "Regiones",
    save: "Guardar",
    rotools: "Config. Atajos",
    rotools2: "Historial Pesca",
    bestiary: "Bestiario",
    game_end2: "Otras Opciones",
    game_end: "Config. Sistema"
  }

  # Window_location
  # Lang::TEXTS[:interface][:window_location][:item]
  TEXTS[:interface][:window_location] = {
    location: "Ubicación:",
    date: "Fecha:",
    playing_time: "Tiempo de juego:",
    time: "Hora:",
  }


  # 037.CAO
  # Lang::TEXTS[:interface][:categorize_item][:item]
  TEXTS[:interface][:categorize_item] = {
    item: "Items",
    weapon: "Arma",
    armor: "Armadura",
    potion: "Poción",
    food: "Comida",
    others: "Otros",
    key_item: "Obj. Clave"
  }


  # Vocab
  # Lang::TEXTS[:interface][:vocab][:level]
  TEXTS[:interface][:vocab] = {
    level: "Level",
    level_a: "Level",
    hp: "HP",
    hp_a: "HP",
    mp: "MP",
    mp_a: "MP",
    tp: "TP",
    tp_a: "TP",
    fight: "Fight",
    escape: "Escape",
    attack: "Attack",
    guard: "Guard",
    item: "Item",
    skill: "Skill",
    equip: "Equip",
    status: "Status",
    formation: "Formation",
    save: "Save",
    game_end: "Game End",
    weapon: "Weapon",
    armor: "Armor",
    key_item: "Key Item",
    equip2: "Equip Change",
    optimize: "Optimize",
    clear: "Clear",
    new_game: "New Game",
    continue: "Continue",
    shutdown: "Shutdown",
    to_title: "To Title",
    cancel: "Cancel"
  }

  # 061.KMS
  TEXTS[:interface][:vocab_param] = {
    :hrg => "Rec HP",
    :mrg => "Rec MP",
    :mcr => "Ratio MP",
    :trg => "Rec TP",
    :tcr => "Ratio TP",
    :rec => "Ratio Rec",
    :tgr => "Efic Poción",
    :pdr => "Ataque Físico",
    :cnt => "Prob Contraataque",
    :mdr => "Ataque Mágico",
    :mrf => "Efic Mágica",
    :hit => "Precisión",
    :atk_lk => "Ratio Crítico",
    :weight_limit => "Lím Peso",
    :cri => "Prob Crítico",
    :eva => "Evasión",
    :cev => "Ev Crit",
    :mev => "Ev Mág",
    :grd => "Ratio Def",
    :pha => "Reducción CD",
    :exr => "Gan EXP",
    :rose_gold1 => "Precio Compra",
    :rose_gold2 => "Precio Venta",
    :aps => "Prob No Knockback",
    :fdr => "Resist Terreno",
    :el_3 => "Elemento Fuego",
    :el_4 => "Elemento Hielo",
    :el_5 => "Elemento Rayo",
    :el_6 => "Elemento Agua",
    :el_7 => "Elemento Tierra",
    :el_8 => "Elemento Viento",
    :el_9 => "Elemento Sagrado",
    :el_10 => "Elemento Oscuro",
    :el_12 => "Elemento Veneno",
    :atk_times_add => "Vel Mov asd",
  }

  # 061.KMS
  TEXTS[:interface][:confirm_commands] = [
    "Confirmar & Salir",
    "Cancelar & Salir",
    "Continuar",
  ]

  # 061.KMS
  TEXTS[:interface][:confirm_command_help] = [
    "Confirma distribución de puntos. \n\\C[10]* Una vez confirmado, no se puede deshacer.\\C[0]",
    "Restablece puntos distribuidos.",
    "Continuar distribuyendo puntos.",
  ]

  # 061.KMS
  TEXTS[:interface][:gain_parameter] = [
    "Salud",
    "Magia",
    "Fuerza",
    "Agilidad",
    "Suerte",
    "Precisión",
    "Evasión",
    "Crit. Prob",
    "Eva. Crítica",
    "Percepción",
    "Acc. Adicionales",
    "Afi. Mágica",
    "Efi. Poción",
  ]

  TEXTS[:interface][:vocab_menu_distribute_parameter] = "Pts Nivel"
  TEXTS[:interface][:vocab_rp] = "RP Costo"
  TEXTS[:interface][:vocab_rp_a] = "RP"

  # 021.IMIR_SkillPoint
  TEXTS[:interface][:vocab_point] = "Punto"
  TEXTS[:interface][:vocab_menu] = "Pts de Habilidad"

  # 151_Window_Base
  TEXTS[:interface][:text_sp] = "SP" #"Puntos de habilidad (SP)"
end