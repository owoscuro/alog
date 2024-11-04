# encoding: utf-8
# Name: 074.BM
# Size: 14594
# encoding: utf-8
# Name: 074.BM
# Size: 14425
#-------------------------------------------------------------------------------
# Actor's Notetag
# To set an actor's initial age, enter:
#       <age: number>
# To set an actor's birthplace to x, enter:
#       <birthplace: x>
# To set an actor's height to x, enter:
#       <height: x>
# To set an actor's custom bio y to x, enter:
#       <cbio y: x>
#-------------------------------------------------------------------------------
# Message Codes (x is actor_id)
# To write an actor's age, enter:
# \aage[x]
# To write an actor's birthplace, enter:
# \abirth[x]
# To write an actor's height, enter:
# \aheight[x]
# To write an actor's custom bio y, enter:
# \abio[y, x]
#-------------------------------------------------------------------------------
# Script Codes (x is actor_id, n is new value, c is custombio id)
# change bio properties ingame:
# $game_actors[x].set_age = n
# $game_actors[x].set_height = n
# $game_actors[x].set_birthplace = "n"
# $game_actors[x].set_custom_bio[c] = "n"
#-------------------------------------------------------------------------------
# * add this to the COMMANDS on YEA - status menu where you want it to show:
#      [    :element,      "Elements"],
#      [    :state,        "States"],
#      [    :infliction,   "Attributes"],
#      [    :resistance,   "Resistances"],
#      [    :bmproperties, "Properties"], #can be used instead of :properties
#-------------------------------------------------------------------------------
module BM
  module STATUS
    GAUGE = {
      :exp   => true,
      :hp    => true,
      :mp    => true,
      :tp    => true,
      :param => true,
    }
    
    BG_OPTIONS ={
      :win_opacity  => 255,
      #:show_bg_img  => false,        # show background image
      #:bg_image     => "Wallpaper",  # image name (Located in Graphics/System
      #:bg_opacity   => 255,          # background image opacity
      #:bg_scroll_x  => 1,            # horizontal movement
      #:bg_scroll_y  => 0,            # vertical movement
    }
    
    # :hit,:eva,:cri,:cev,:mev,:mrf,:cnt,:hrg,:mrg,:trg
    # :tgr,:grd,:rec,:pha,:mcr,:tcr,:pdr,:mdr,:fdr,:exr
    # :wur,:gut,:hcr,:tcr_y,:hp_physical,:mp_physical,:hp_magical,:mp_magical
    # :blank   (makes a empty entry for spacing, can be used in YEA or BM)
    # :hblank when you want half line empty
    
    BMPROPERTIES_COLUMN =[
      :hit, :eva, :cri, :cev, :mev, :mrf, :cnt,
      :cdr, :wur,
      :gut,
      :tgr, :grd, :rec, :pha, :mcr,
      :hcr, :tcr_y,
      :tcr, :exr, :hrg, :mrg, :trg, :pdr, :mdr, :fdr, :aps, :atk_lk,
      :rose_gold1, :rose_gold2,
      :hp_physical, :mp_physical, :hp_magical, :mp_magical,
    ]
    
    BMPROPERTIES_COLUMN_TEST =[
      :mhp, :mmp, :atk, :mat, :def, :mdf, :agi, :luk, :exp,
      :hit, :eva, :cri, :cev, :mev, :mrf, :cnt,
      :tgr, :grd, :rec, :pha, :mcr,
      :tcr, :exr, :hrg, :mrg, :trg, :pdr, :mdr, :fdr, :atk_lk,
    ]
    
    NUM_COL = 2
    PROPERTIES_FULL_NAME = true
    
    BIO_INFO = [:align,:age,:birthplace,:height,:custom_bio1,:custom_bio2,:custom_bio3,:custom_bio10]
    ACTOR_BIO_INFO = {}
    
    # 남성
    ACTOR_BIO_INFO[1] =   [:align,:age,:birthplace,:height,:custom_bio1,:custom_bio2,:custom_bio3,:custom_bio10,:custom_bio22,:blank,:custom_bio20,:custom_bio21]
    ACTOR_BIO_INFO[2] =   [:align,:age,:birthplace,:height,:custom_bio1,:custom_bio2,:custom_bio3,:custom_bio10,:custom_bio22,:blank,:custom_bio20,:custom_bio21]
    ACTOR_BIO_INFO[4] =   [:align,:age,:birthplace,:height,:custom_bio1,:custom_bio2,:custom_bio3,:custom_bio10,:custom_bio22,:blank,:custom_bio20,:custom_bio21]
    ACTOR_BIO_INFO[9] =   [:align,:age,:birthplace,:height,:custom_bio1,:custom_bio2,:custom_bio3,:custom_bio10,:custom_bio22,:blank,:custom_bio20,:custom_bio21]
    ACTOR_BIO_INFO[11] =  [:align,:age,:birthplace,:height,:custom_bio1,:custom_bio2,:custom_bio3,:custom_bio10,:custom_bio22,:blank,:custom_bio20,:custom_bio21]
    ACTOR_BIO_INFO[13] =  [:align,:age,:birthplace,:height,:custom_bio1,:custom_bio2,:custom_bio3,:custom_bio10,:custom_bio22,:blank,:custom_bio20,:custom_bio21]
    ACTOR_BIO_INFO[14] =  [:align,:age,:birthplace,:height,:custom_bio1,:custom_bio2,:custom_bio3,:custom_bio10,:custom_bio22,:blank,:custom_bio20,:custom_bio21]
    
    # 여성
    ACTOR_BIO_INFO[3] =   [:align,:age,:birthplace,:height,:custom_bio1,:custom_bio2,:custom_bio3,:custom_bio10,:custom_bio22,:blank,:custom_bio20,:custom_bio21]
    ACTOR_BIO_INFO[5] =   [:align,:age,:birthplace,:height,:custom_bio1,:custom_bio2,:custom_bio3,:custom_bio10,:custom_bio22,:blank,:custom_bio20,:custom_bio21]
    ACTOR_BIO_INFO[6] =   [:align,:age,:birthplace,:height,:custom_bio1,:custom_bio2,:custom_bio3,:custom_bio10,:custom_bio22,:blank,:custom_bio20,:custom_bio21]
    ACTOR_BIO_INFO[8] =   [:align,:age,:birthplace,:height,:custom_bio1,:custom_bio2,:custom_bio3,:custom_bio10,:custom_bio22,:blank,:custom_bio20,:custom_bio21]
    ACTOR_BIO_INFO[10] =  [:align,:age,:birthplace,:height,:custom_bio1,:custom_bio2,:custom_bio3,:custom_bio10,:custom_bio22,:blank,:custom_bio20,:custom_bio21]
    ACTOR_BIO_INFO[12] =  [:align,:age,:birthplace,:height,:custom_bio1,:custom_bio2,:custom_bio3,:custom_bio10,:custom_bio22,:blank,:custom_bio20,:custom_bio21]
    
    # 에르니
    ACTOR_BIO_INFO[7] =   [:align,:age,:birthplace,:height,:custom_bio1,:custom_bio2,:custom_bio3,:custom_bio4,:custom_bio5,:custom_bio6,:blank,:custom_bio7,:custom_bio8,:custom_bio9,:blank,:custom_bio11,:custom_bio12,:blank,:custom_bio13,:custom_bio14,:blank,:custom_bio15,:custom_bio16,:custom_bio17]
    
    # 자녀, 아들
    ACTOR_BIO_INFO[20] =  [:align,:age,:birthplace,:height,:custom_bio1,:custom_bio2,:custom_bio3,:custom_bio20,:custom_bio21,:blank,:custom_bio25,:custom_bio26]
    
    # 자녀, 딸
    ACTOR_BIO_INFO[21] =  [:align,:age,:birthplace,:height,:custom_bio1,:custom_bio2,:custom_bio3,:custom_bio20,:custom_bio21,:blank,:custom_bio25,:custom_bio26]
    ACTOR_BIO_INFO[22] =  [:align,:age,:birthplace,:height,:custom_bio1,:custom_bio2,:custom_bio3,:custom_bio20,:custom_bio21,:blank,:custom_bio25,:custom_bio26]
    
    BIO_INFO_TEXT = {
      :align      => "Nombre",          
      :age        => "Edad", 
      :birthplace => "Lugar de nacimiento", 
      :height     => "Altura",        :nickname   => "Apodo",
    }

    CBIO_INFO_TEXT = {
      :custom_bio1    => "Raza",      :custom_bio2    => "Peso",
      :custom_bio3    => "Virginidad",
      
      :custom_bio4    => "Sexo vaginal",   :custom_bio5    => "Sexo anal",
      :custom_bio6    => "Sexo oral",
      
      # 자녀의 경우 7번에 양육비를 받은 일수가 적용된다.
      :custom_bio7    => "Embarazo",      :custom_bio8    => "Parto",
      :custom_bio9    => "Aborto",
      
      :custom_bio10   => "Precio de contratación por día",
      
      :custom_bio11   => "Masturbación",  :custom_bio12   => "Acoso sexual",
      :custom_bio13   => "Orgasmo",       :custom_bio14   => "Clímax intenso",
      
      :custom_bio15   => "Beso",          :custom_bio16   => "Prostitución",
      :custom_bio17   => "Violación",
      
      :custom_bio18   => "Tipo de ataque",
      :custom_bio19   => "Tipo de movimiento",
      
      # 에르니는 성행위 횟수가 아니라, 성행위한 남성 대상자 이름을 기록한다.
      :custom_bio20   => "Actividad sexual con Ernie",
      
      :custom_bio21   => "Íntimidad con Ernie",
      
      :custom_bio22   => "Tiempo de contratación restante",
      :custom_bio23   => "Imagen del personaje",
      :custom_bio24   => "Estado de defunción",
      
      :custom_bio25   => "Padre biológico",
      :custom_bio26   => "Madre biológica",
      
      :custom_bio27   => "Nivel de abstinencia",
      :custom_bio28   => "Nivel de gula",
      :custom_bio29   => "Características de personalidad",
    }
    BIO_FONT_SIZE = 20    # font size of bio info text
    YEA_BIO_BOX = false   # background box for YEA bio
    HEIGHT_UNIT = "%scm"  # %s is the height given in actor's notebox
    EMPTY_BIO = 0
    #EMPTY_BIO = "?"
    
    PORTRAIT_BACKGROUND = [:general,:biography,:titles,:rename,:retitle,:yeabio,:bmbio]
    
    # 상태 메뉴에서 선택
    ONE_PAGE = {
      :element => true,
      :state   => true,
      :infliction => false,
      :resistance  => false,
    }
    
    LIST_ITEMS_ORDER={
      :element => [3,4,5,6,7,8,9,10,12],        # 당신이 표시하려는 요소
      :state   => [3..7,30,49,50,51,52,58,73],  # 상태는 표시하려는
      :param   => [2..7],
    }
    
    CHART_ITEMS_ORDER={
      :element => [3,4,5,6,7,8,9,10,12],        # 당신이 표시하려는 요소
      :state   => [3..7,30,49,50,51,52,58,73],  # 상태는 표시하려는
      :param   => [2..7],
    }
    
    # 0 .. numbers
    # 1 .. chart
    # 2 .. chart & numbers
    # 3 .. 숫자(공백은 차트의 크기를 비워 둡니다.)
    INFO_STYLE = {
      :element => 0,
      :state   => 0,
      :param   => 0,
      :resist  => 0,
      :inflict => 0,
    }
    
    CHART_FONT_SIZE = 16
    
    NUMBER_STYLE = {
      :element => 1,
      :state   => 1,
      :param   => 0,
    }
    
    PARAMETER_NAME = { 
      :element        => "Elemento",
      :state          => "Estado",
      :resist         => "Resistencia",
      :inflict        => "Debilidad",
    }
    
    CHART_ICONS={
    :param => {
      2 => 548, # ATK,   ATtacK power
      3 => 593, # DEF,   DEFense power
      4 => 549, # MAT,   Magic ATtack power
      5 => 615, # MDF,   Magic DeFense power
      6 => 604, # AGI,   AGIlity
      7 => 550, # LUK,   LUcK
      },
      
    :element   => {
      1  => 3627,
      2  => 3626,
      3  => 528,  # 화 속성
      4  => 529,  # 빙 속성
      5  => 530,  # 뇌 속성
      6  => 531,  # 지 속성
      7  => 532,  # 수 속성
      8  => 533,  # 풍 속성
      9  => 542,  # 성 속성
      10 => 543,  # 암 속성
      #11 => 540, # 무 속성
      12 => 541,  # 독 속성
      },
      
    :state   => {  
      2  => 104,
      3  => 105,
      4  => 106,
      5  => 107,
      6  => 108,
      7  => 109,
      8  => 110,
      9  => 111,
      },
    }
    
    LINE_COLOR = {
      :element => Color.new(128, 255, 128),
      :state   => Color.new(228, 255, 128),
      :param   => Color.new(228,  55,  28),
    }
    
    BASE_COLOR = {
      :element => Color.new(128, 192, 255),
      :state   => Color.new(128, 192, 255),
      :param   => Color.new(128, 192, 255),
    }
    
    FLASH_COLOR = {
      :element => Color.new(128, 255, 128),
      :state   => Color.new(228, 255, 128),
      :param   => Color.new(228,  55,  28),
    }
    
    CHART_HIGHQUALITY = true    
    CHART_FRAME_RATE = 0.2

    TOGGLE_ICON = 140
    TOGGLE_BUTTON = :C
    TOGGLE_SOUND = false
    
    TOGGLE_WINDOWS={
      :element    => [:element],  # :state
      :state      => [:state],    # :element
      
      #:element    => [:ele_resist, :ele_inflict],
      #:state      => [:state_resist, :state_inflict],
      #:general    => [:general, :bmbio,:yeabio],
      
      :biography     => [:bmbio], # :yeabio
      :parameters    => [:parameters, :bmproperties],
      :bmproperties  => [:bmproperties, :parameters],
      :resistance    => [:ele_resist, :state_resist],
      :infliction    => [:ele_inflict, :state_inflict],
    }
    
    CHART_STATUS_COMMANDS ={
    # switch Handler Method to :do_nothing when you don't want the confirm button
    # to do anything
    # :command => [EnableSwitch, ShowSwitch, Handler Method, Window Draw],
      :bmproperties  => [ 0,  0, :do_nothing, :draw_bmprop],
      :resistance    => [ 0,  0, :command_resist, :draw_resist], 
      :infliction    => [ 0,  0, :command_inflict, :draw_inflict],
      :element       => [ 0,  0, :command_elements, :draw_elemental],
      :ele_resist    => [ 0,  0, :command_elements, :draw_ele_resist],
      :ele_inflict   => [ 0,  0, :command_elements, :draw_ele_inflict],
      :state         => [ 0,  0, :command_states, :draw_states],
      :state_inflict => [ 0,  0, :command_states, :draw_state_inflict],
      :state_resist  => [ 0,  0, :command_states, :draw_state_resist],
      :yeabio        => [ 0,  0, :command_bio, :draw_actor_yeabiography],
      :bmbio         => [ 0,  0, :command_bio, :draw_actor_bmbiography],
    }
  end
end

module BM
  def self.required(name, req, version, type = nil)
    if !$imported[:bm_base]
      msg = "The script '%s' requires the script\n"
      msg += "'BM - Base' v%s or higher above it to work properly\n"
      msg += "Go to bmscripts.weebly.com to download this script."
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

module BM
  module REGEXP
     module ACTOR
       AGE = /<(?:AGE|age):[ ](\d+)>/i
       BIRTHPLACE = /<(?:BIRTHPLACE|birthplace|birth|BIRTH):[ ](.*)>/i
       HEIGHT = /<(?:HEIGHT|height):[ ](.*)>/i
       CUSTOMBIO = /<(?:CBIO|cbio)[ ](\d+):[ ](.*)>/i
     end
  end
end

module BM::STATUS
  module_function
  def convert_integer_array(chart)
    array = LIST_ITEMS_ORDER[chart]
    result = []
    array.each { |i|
      case i
      when Range
        result |= i.to_a
      when Integer
        result |= [i]
      end
    }
    return result
  end
  
  def convert_integer_chart_array(chart)
    array = CHART_ITEMS_ORDER[chart]
    result = []
    array.each { |i|
      case i
      when Range
        result |= i.to_a
      when Integer
        result |= [i]
      end
    }
    return result
  end
  
  LIST_ITEMS_ORDER[:element] = convert_integer_array(:element)
  LIST_ITEMS_ORDER[:state] = convert_integer_array(:state)
  LIST_ITEMS_ORDER[:param] = convert_integer_array(:param)
  
  CHART_ITEMS_ORDER[:element] = convert_integer_chart_array(:element)
  CHART_ITEMS_ORDER[:state] = convert_integer_chart_array(:state)
  CHART_ITEMS_ORDER[:param] = convert_integer_chart_array(:param)
end