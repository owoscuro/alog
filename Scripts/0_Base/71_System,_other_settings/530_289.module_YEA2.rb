# encoding: utf-8
# Name: 289.module YEA2
# Size: 4799
module YEA2
  module SYSTEM2
    COMMAND_NAME = "기타 옵션"

    COMMANDS =[
      :autodash,
      :instantmsg,
      :blank,
      :switch_1,
      :switch_2,
      :switch_6,
      :blank,
      :switch_3,
      :switch_4,
      :switch_5,
      :switch_7,
      :switch_8,
      :blank,
      :variable_3,
      :variable_1,
      :variable_4,
      :variable_2,
    ]
    
    CUSTOM_SWITCHES ={
      :switch_1  => [ 284, "Desactivar reloj y UI de necesidades", "OFF", "ON",
                     "Puedes activar o desactivar el reloj en la esquina inferior derecha y la UI de necesidades en la esquina inferior izquierda."
                    ],
      :switch_2  => [ 38, "Desactivar recogida automática de botín", "OFF", "ON",
                     "Si cambias esta configuración a ON, no recogerás automáticamente los ítems de los cuerpos de los monstruos. \n" + 
                     '\C[1]Botón Caps Lock\C[0]' + " para alternar entre ON y OFF fácilmente."
                    ],
      :switch_3  => [ 34, "Forzar semitransparencia en tiles altos", "OFF", "ON",
                     "Puedes forzar la semitransparencia de imágenes como techos y árboles. \n" + 
                     '\C[1]Botón Y\C[0]' + " para alternar entre ON y OFF fácilmente. Los cambios se aplicarán al cambiar de mapa."
                    ],
      :switch_4  => [ 57, "Configurar imagen de ataque del personaje", "OFF", "ON",
                     "Si cambias esta configuración a ON, la imagen del personaje en la esquina inferior derecha no cambiará durante los ataques básicos."
                    ],
      :switch_5  => [ 30, "Configurar imágenes de nubes y niebla", "OFF", "ON",
                     "Si cambias esta configuración a ON, no se mostrarán imágenes de nubes y niebla en el mapa."
                    ],
      :switch_6  => [ 82, "Desactivar autoapuntado de flechas", "OFF", "ON",
                     "Si cambias esta configuración a ON, las flechas de armas y habilidades se moverán en línea recta.\n" + 
                     '\C[1]Botón Tab\C[0]' + " para alternar entre ON y OFF fácilmente."
                    ],
      :switch_7  => [ 91, "Desactivar sombras de personajes", "OFF", "ON",
                     "Si cambias esta configuración a ON, no se mostrarán las sombras de los personajes. \n" + 
                     "Los cambios se aplicarán al cambiar de mapa."
                    ],
      :switch_8  => [ 148, "Desactivar imágenes gore", "OFF", "ON",
                     "Si cambias esta configuración a ON, no se mostrarán imágenes gore. \n" + 
                     "Esto incluye las imágenes de los cadáveres."
                    ],
    }
    
    CUSTOM_VARIABLES ={
      :variable_3 => [ 103, "Efecto de respiración de imagen de personaje", 9, 3, 0, 10,
                      "Ajusta el valor del efecto de respiración en la imagen del personaje en la esquina inferior derecha.\n" +
                      '\C[1]Botón Shift\C[0]' + " para ajustar en incrementos de 10. El valor mínimo es 0 y el máximo es 10."
                     ],
      :variable_1 => [ 109, "Efecto de temblor de imagen de personaje", 9, 3, 0, 10,
                      "Ajusta el valor del efecto de temblor de la imagen del personaje durante ataques y golpes.\n" +
                      '\C[1]Botón Shift\C[0]' + " para ajustar en incrementos de 10. El valor mínimo es 0 y el máximo es 10."
                     ],
      :variable_4 => [ 83, "Escala de imagen de personaje", 9, 3, 70, 100,
                      "Ajusta la escala de la imagen del personaje y de los NPCs en la esquina inferior derecha.\n" +
                      '\C[1]Botón Shift\C[0]' + " para ajustar en incrementos de 10. El valor mínimo es 70 y el máximo es 100."
                     ],
      :variable_2 => [ 108, "Tiempo de cambio de imagen de personaje", 9, 3, 10, 50,
                      "Ajusta el tiempo de cambio de la imagen del personaje durante ataques y golpes en valores.\n" +
                      '\C[1]Botón Shift\C[0]' + " para ajustar en incrementos de 10. El valor mínimo es 10 y el máximo es 50."
                     ],
    }
    
    COMMAND_VOCAB ={
      :blank      => ["", "None", "None",
                      ""
                     ],
      :autodash   => ["Activar carrera automática", "OFF", "ON",
                      "Si cambias esta configuración a ON, siempre correrás sin necesidad de presionar " + '\C[1]el botón Shift\C[0]' + "."
                     ],
      :instantmsg => ["Omitir velocidad de mensajes", "OFF", "ON",
                      "Configura para mostrar los mensajes uno por uno o de inmediato."
                     ],
    }
  end
end