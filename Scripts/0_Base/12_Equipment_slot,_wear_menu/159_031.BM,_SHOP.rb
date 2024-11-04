# encoding: utf-8
# Name: 031.BM, SHOP
# Size: 7542
# encoding: utf-8
# Name: 031.BM, SHOP
# Size: 8061
module BM
  # 회원은하지 전투 파티, 문자 / 얼굴을 투명하게하는 경우
  NON_PARTY_MEMBER_TRANSPARENCY = true
  STANDBY_COLOR = Color.new(0, 0, 0, 128)
  
  # 스킬 상태 윈도우, 국가 / 버프는 배우의 얼굴의 아래쪽에 나타납니다.
  MOVE_STATE_OVER_FACE = true
  PORTRAIT_FOLDER = "Graphics/Portraits/" 
  TEXT={
  :bold =>{
    :actor_name => true,
    :actor_class => false,
    },
  :italic =>{
    :actor_name => false,
    :actor_class => false,
    },
  }
  
  # 음향 효과를위한 임의의 피치는 어떤 변화를 줄 수있는 소정
  RAND_PITCH = true
  
  EXP_VOCAB = "EXP"
  EXP_GAUGE1   = 12            # "Window" skin text colour for gauge.
  EXP_GAUGE2   = 4             # "Window" skin text colour for gauge.
  SHOW_EXP_GAUGE = true        # show exp gauge in menu 
  
  # 상태 표시 매개 변수 측정
  SHOW_PARAM_GAUGE = false
  
  # 매개 변수 비율을 최대로 설정 : 설정, : 최대 또는 : 현재
  # stat가 param max보다 높은 경우 해당 통계를 기반으로합니다.
  # : set (최대 매개 변수는 설정된 숫자 임)
  # : max (기본 최대 매개 변수 사용)
  # : current (max param은 가장 높은 현재 param을 기반으로 함)
  
  PARAM_RATIO_MAX = :set
  PARAM_MAX = 100
  
  PARAM_COLOUR ={
          0 => [ :hp,  Color.new(115,  20,  20), Color.new(170,  44,  44)],
          1 => [ :mp,  Color.new(158, 113, 229), Color.new(205, 178, 245)],
          2 => [ :atk, Color.new(151,  83, 123), Color.new(207, 181, 187)],
          3 => [ :def, Color.new(121, 208, 151), Color.new(184, 233, 205)],
          4 => [ :mat, Color.new( 82, 150, 215), Color.new(161, 197, 236)],
          5 => [ :mdf, Color.new(236, 238, 150), Color.new(246, 253, 203)],
          6 => [ :agi, Color.new(182, 150, 131), Color.new(222, 208, 194)],
          7 => [ :luk, Color.new(146,  89, 165), Color.new(206, 182, 219)],
  }
  
  PARAM_VOCAB_FULL = {
    0 => "Salud", 
    1 => "Magia",
    2 => "Ataque",
    3 => "Defensa",
    4 => "Poder Mág.",
    5 => "Resistencia",
    6 => "Agilidad",
    7 => "Suerte",
}

  XPARAM_VOCAB = {
    0 => "Precisión",
    1 => "Evasión",
    2 => "Crit. Prob.",
    3 => "Crit. Evasión",
    4 => "Evasión Mág.",
    5 => "Efic. Mág.",
    6 => "Contraatque",
    7 => "HP Regen.",
    8 => "MP Regen.",
    9 => "TP Regen.",
}

  XPARAM_VOCAB_FULL = {
    0 => "Precisión",
    1 => "Evasión",
    2 => "Crit. Prob.",
    3 => "Crit. Evasión",
    4 => "Evasión Mág.",
    5 => "Efic. Mág.",
    6 => "Contraatque",
    7 => "HP Regen.",
    8 => "MP Regen.",
    9 => "TP Regen.",
}

  SPARAM_VOCAB = {
    0 => "Efic. Poción", 
    1 => "Defensa %",
    2 => "Curación %",
    3 => "Red. Cooldown",
    4 => "MP Consumo %",
    5 => "TP Carga %",
    6 => "Ataque Fís.",
    7 => "Ataque Mág.",
    8 => "Res. Terreno",
    9 => "Exp. Ganada %",
    10 => "Precio Compra %",
    11 => "Precio Venta %",
}

  SPARAM_VOCAB_FULL = {
    0 => "Efic. Poción", 
    1 => "Defensa %",
    2 => "Curación %",
    3 => "Red. Cooldown",
    4 => "MP Consumo %",
    5 => "TP Carga %",
    6 => "Ataque Fís.",
    7 => "Ataque Mág.",
    8 => "Res. Terreno",
    9 => "Exp. Ganada %",
    10 => "Precio Compra %",
    11 => "Precio Venta %",
    12 => "Res. Fuego",
    13 => "Res. Hielo",
    14 => "Res. Rayo",
    15 => "Res. Agua",
    16 => "Res. Tierra",
    17 => "Res. Viento",
    18 => "Res. Luz",
    19 => "Res. Oscuridad",
    20 => "Res. Veneno",
    21 => "Ignorar Empujón",
    22 => "Daño Crítico %",
}

  CPARAM_VOCAB = {
    :cdr => "Tiempo Reutiliz.",
    :wur => "Vel. Preparación",
    :hcr => "Consumo HP %",
    :tcr_y => "Consumo TP %",
    :gcr => "Consumo Oro %",
    :hp_physical => "Absorción HP Fís.",
    :mp_physical => "Absorción MP Fís.",
    :hp_magical => "Absorción HP Mág.",
    :mp_magical => "Absorción MP Mág.",
}

  CPARAM_VOCAB_FULL = {
    :tcr_y => "Consumo TP %",
    :hcr => "Consumo HP %",
    :gcr => "Consumo Oro %",    
    :cdr => "Tiempo Reutiliz.",
    :wur => "Vel. Preparación",  
    :hp_physical => "Absorción HP Fís.",
    :mp_physical => "Absorción MP Fís.",
    :mp_magical => "Absorción HP Mág.",
    :hp_magical => "Absorción MP Mág.",
}

  
  # 도움말 창에 추가 정보 표시
  ADVANCED_HELP = true
  
  # HELP_DISPLAY = [show_help_icon, show_name, show_description, show_type]
  HELP_DISPLAY = [true, true, true, true]
  HELP_SIZE = 2
  ITEM_NAME_COLOR = Color.new(182, 150, 131)
  
  # 게임의 프로세스 우선 순위를 "높음"으로 높일지 여부를 결정합니다.
  HIGH_PROCESS = true
  
  def self.required_script(name, req, version, type = 0)
    if version == true 
      return unless (!$imported[req]) # non-bm scripts
      msg = "The script '%s' requires the script\n"
      case type
      when :above
        msg += "'%s' above it to work properly\n"
      when :below
        msg += "'%s' or higher to work properly\n"
      else        
        msg += "'%s' below it to work properly\n"
      end
      msg += "Go to bmscripts.weebly.com to download this script."
      self.exit_message(msg, name, req, version)
    end
    if type != :below && (!$imported[req] || $imported[req] < version) #checks version number
      msg = "The script '%s' requires the script\n"
      case type
      when :above
        msg += "'%s' v%s or higher above it to work properly\n"
      else
        msg += "'%s' v%s or higher to work properly\n"
      end
      msg += "Go to bmscripts.weebly.com to download this script."
      self.exit_message(msg, name, req, version)
    elsif type == :below && $imported[req] # wrong position
      msg = "The script '%s' requires the script\n"
      msg += "'%s' below it to work properly\n"
      msg += "move the scripts to the proper position"
      self.exit_message(msg, name, req, version)
    end
  end
  
  def self.exit_message(message, name, req, version = 1.00)
    name = self.script_name(name)
    req  = self.script_name(req)
    msgbox(sprintf(message, name, req, version))
    exit
  end
  
  def self.script_name(name, ext = "BM")
    name = name.to_s.gsub("_", " ").upcase.split
    name.collect! {|char| char == ext ? "#{char} -" : char.capitalize }
    name.join(" ")
  end
  
  def self.handle
    # Removed Win32API code
  end
  
  module SHOP
    ITEM_EQUIPPED = "Ya está equipado"
    PARAM_FONT_SIZE = 18
    PARAM_SHOWN = 2..7
    
    PARAM_ICONS={
      2 => 548, # ATK
      3 => 593, # DEF
      4 => 549, # MAT
      5 => 615, # MDF
      6 => 604, # AGI
      7 => 550, # LUK
    }
    
    ACTOR_OPTIONS = {
      :image_width  => 40,
      :image_height => 40,
    }
  end
  
  def self.required(name, req, version, type = nil)
    if !$imported[:bm_base]
      msg = "'%s' 스크립트가 필요합니다.\n"
      msg += "'BM - Base' %s 이상이 있어야 제대로 작동합니다.\n"
      msgbox(sprintf(msg, self.script_name(name), version))
      exit
    else
      self.required_script(name, req, version, type)
    end
  end
  
  def self.script_name(name, ext = "BM")
    name = name.to_s.gsub("_", " ").upcase.split
    name.collect! {|char| char == ext ? "#{char} -" : char.capitalize }
    name.join(" ")
  end
end