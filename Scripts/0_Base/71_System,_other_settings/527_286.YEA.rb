# encoding: utf-8
# Name: 286.YEA
# Size: 5575
$imported = {} if $imported.nil?
$imported["YEA-SystemOptions"] = true

#-------------------------------------------------------------------------------
# $game_system.volume_change(:bgm, x)
# $game_system.volume_change(:bgs, x)
# $game_system.volume_change(:sfx, x)
#
# $game_system.set_volume(:bgm, x)
# $game_system.set_volume(:bgs, x)
# $game_system.set_volume(:sfx, x)
# Use this script call to set the bgm, bgs, or sfx volume directly. (x should
# be between 0 and 100.)
# 
# $game_system.set_autodash(true)
# $game_system.set_autodash(false)
# 
# $game_system.set_instantmsg(true)
# $game_system.set_instantmsg(false)
#-------------------------------------------------------------------------------

module YEA
  module SYSTEM
    COMMAND_NAME = "시스템 옵션"  # 게임 종료를 대체하는 데 사용되는 명령 이름입니다.
    DEFAULT_AUTODASH   = false   # 기본적으로 자동 대시를 사용하시겠습니까?
    DEFAULT_INSTANTMSG = false   # 기본적으로 인스턴트 메시지 텍스트를 사용하시겠습니까?

    #---------------------------------------------------------------------------
    # :command         Description
    #---------------------------------------------------------------------------
    # :blank           Inserts an empty blank space.
    # 
    # :window_red      Changes the red tone for all windows.
    # :window_grn      Changes the green tone for all windows.
    # :window_blu      Changes the blue tone for all windows.
    # 
    # :volume_bgm      Changes the BGM volume used.
    # :volume_bgs      Changes the BGS volume used.
    # :volume_sfx      Changes the SFX volume used.
    # 
    # :autodash        Sets the player to automatically dash.
    # :instantmsg      Sets message text to appear instantly.
    # 
    # :to_title        Returns to the title screen.
    # :shutdown        Shuts down the game.
    # 
    #---------------------------------------------------------------------------
    COMMANDS =[
      :volume_bgm,   # Changes the BGM volume used.
      :volume_bgs,   # Changes the BGS volume used.
      :volume_sfx,   # Changes the SFX volume used.
      :blank,
      :to_title3,    # 후원자 혜택 선택
      :to_title2,    # 끼임 탈출 추가
      :to_title,     # Returns to the title screen.
      :shutdown,     # Shuts down the game.
    ]

=begin
    CUSTOM_SWITCHES ={
    #---------------------------------------------------------------------------
    # :switch    => [스위치, 이름, 텍스트 끄기, 텍스트 켜기,
    #                도움말 창 설명
    #               ],
    #---------------------------------------------------------------------------
      :switch_1  => [ 284, "시계 및 욕구 UI 끄기", "OFF", "ON",
                     "우측 하단 시계, 좌측 하단 욕구 UI를 켜기 또는 끄기 할 수 있습니다."
                    ],
    }
    
    CUSTOM_VARIABLES ={
    #---------------------------------------------------------------------------
    # :variable   => [스위치, 이름, Color1, Color2, 최소, 최대,
    #                 도움말 창 설명
    #                ],
    #---------------------------------------------------------------------------
      :variable_3 => [ 103, "캐릭터 이미지 숨결", 9, 3, 0, 10,
                      "우측 하단에 캐릭터 이미지의 숨결 효과의 수치를 조절합니다.\n" +
                      "\\C[1]Shift 버튼\\C[0]을 누르고 움직이면 10씩 조절 가능하며, 최소 0, 최대 10까지 조절 가능합니다."
                     ],
    }
=end

    COMMAND_VOCAB ={
    #---------------------------------------------------------------------------
    # :command    => [Command Name, Option1, Option2
    #                 Help Window Description,
    #                ],
    #---------------------------------------------------------------------------
      :blank      => ["", "None", "None",
                      ""
                     ],
      :volume_bgm => ["Volumen de la música de fondo", 12, 4,
                      "Cambia el volumen utilizado para la música de fondo.\n" +
                      '\C[1]Botón Shift\C[0]' + " para ajustar en incrementos de 10."
                     ],
      :volume_bgs => ["Volumen del sonido de fondo", 13, 5,
                      "Cambia el volumen utilizado para el sonido de fondo.\n" +
                      '\C[1]Botón Shift\C[0]' + " para ajustar en incrementos de 10."
                     ],
      :volume_sfx => ["Volumen de los efectos de sonido", 14, 6,
                      "Cambia el volumen utilizado para los efectos de sonido.\n" +
                      '\C[1]Botón Shift\C[0]' + " para ajustar en incrementos de 10."
                     ],
      :to_title3   => ["Seleccionar beneficios de patrocinador", "None", "None",
                      "Usa puntos de beneficios de patrocinador o ingresa un código."
                     ],
      :to_title2   => ["Escapar de atascos (errores)", "None", "None",
                      "Escapa a un lugar seguro."
                     ],
      :to_title   => ["Volver a la pantalla de título", "None", "None",
                      "Regresa a la pantalla de título."
                     ],
      :shutdown   => ["Salir del juego", "None", "None",
                      "Termina el juego."
                     ],
    }
  end
end

module Lune_cam_slide
  Slide = 0.005
end