# encoding: utf-8
# Name: 032.BM
# Size: 4335
# encoding: utf-8
# Name: 032.BM
# Size: 4462
#-------------------------------------------------------------------------------
# <image: string>
#
# 액터의 장착 이미지 배경을 설정하려면 다음을 입력하십시오.
# <equip image: name>
# name은 이미지의 파일 이름이며 스크립트에 할당된 폴더에 들어갑니다.
#
# <equip body>
#  string
#  string
# </equip body>
#
# "equip slotx id: n" 장비 슬롯이 id인 경우 n은 x 좌표입니다.
# "equip sloty id: n" 장비 슬롯이 id인 경우 n은 y 좌표입니다.
#
# 클래스의 장착 이미지 배경을 설정하려면 다음을 입력하십시오.
# <equip image: name>
# name은 이미지의 파일 이름이며 스크립트에 할당된 폴더에 들어갑니다.
#
# <equip body>
#  string
#  string
# </equip body>
#
# "equip slotx id: n" 장비 슬롯이 id인 경우 n은 x 좌표입니다.
# "equip sloty id: n" 장비 슬롯이 id인 경우 n은 y 좌표입니다.
#-------------------------------------------------------------------------------
module BM
  module EQUIP
    MINI_FONT_SIZE = 18
    COMMAND_SIDE_OPTIONS = {
      :width => Graphics.width - 516,
      :left  => true,
      :lines_shown => 1,
      :alignment => 0,
    }
    
    COMMAND_HELP = [
      "Cambia el equipo que estás usando.",
      "Retira todo el equipo que estás usando.",
      "Retira todo el equipo.",
    ]
    
    EQUIP_TYPE_OPTIONS={
      0 => 147,   # 오른손
      1 => 161,   # 왼손
      2 => 162,   # 머리
      3 => 168,   # 몸
      4 => 172,   # 발
      5 => 180,   # 목
      6 => 515,   # 귀
      7 => 181,   # 허리
      8 => 176,   # 반지
      9 => 4592,  # Otros
      10 => 3705, # Otros
      11 => 4308, # 성인용품
    }
    
    BODY_ICON_LOCATIONS = {
      0 => [4,41],    # 무기
      1 => [4,75],    # 방패
      2 => [4,109],   # 머리
      3 => [4,143],   # 몸
      4 => [4,177],   # 신발
      5 => [4,211],   # 목걸이
      6 => [4,245],   # 귀걸이
      7 => [4,279],   # 허리
      8 => [4,313],   # 다리
      9 => [4,347],   # 반지
      10 => [4,381],  # 반지
      11 => [4,415],  # 성인용품
    }
    
    ICON_BORDER = 687
    BODY_ICON_SIZE = 24
    BODY_OPTIONS = {
      :show_box   => true,      # 아이콘 주위에 상자를 표시합니다.
      :show_text  => false,     # 장비 유형 위의 아이콘을 보여줍니다.
      :image      => "equip_m", # 배경 실루엣의 기본 이미지
      :show_face  => false,     # 배우의 얼굴을 오른쪽 모서리에 표시하십시오.
      :face_size  => 60,        # 배우 얼굴 크기
    }
    
    # 장비 본체의 이미지를 원하는 위치로 설정합니다.
    EQUIP_BODY_FOLDER = "Graphics/System/" 
    
    EQUIP_BODY_FACENAME = true
    
    # can include parameters, xparameters, sparameters
    # :hp,:mp,:atk,:mat,:def,:mdf,:agi,:luk
    # :hit,:eva,:cri,:cev,:mev,:mrf,:cnt,:hrg,:mrg,:trg
    # :tgr,:grd,:rec,:pha,:mcr,:tcr,:pdr,:mdr,:fdr,:exr
    PARAM_SHOWN = [ :hp, :mp, :atk, :mat, :def, :mdf, :agi, :luk,
                    :hit, :eva, :cri, :cev, :mev, :hrg, :mrg, :mrf,
                    :grd, :rec, :pha, :mcr, :tcr, :trg, :tgr, :pdr, :mdr, :atk_lk, :exr, 
                    :el_3, :el_4, :el_5, :el_6, :el_7, :el_8, :el_9, :el_10, :el_12,
                    :amove, :aps
                    #:hp_physical, :mp_physical, :hp_magical, :mp_magical
                    ]
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
    EQUIP_IMAGE = /<(?:EQUIP_IMAGE|equip image):[ ](.*)>/i
    EQUIP_BODY_ON  = /<(?:EQUIP_BODY|equip body)>/i
    EQUIP_BODY_OFF = /<\/(?:EQUIP_BODY|equip body)>/i
    E_IMAGE    = /<(?:IMAGE|image):[ ](.*)>/i
  end
end