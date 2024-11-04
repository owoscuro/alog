# encoding: utf-8
# Name: 066.SZS_Factions
# Size: 7972
module SZS_Factions
  
  Levels = [
    {:name => "¿Quién es Ernie?", :rep_min => 0,
          :bar_color1 => Color.new(39, 138, 29),
          :bar_color2 => Color.new(52, 242, 32)},
          
    {:name => "Ernie, te suena el nombre.", :rep_min => 100000,
          :bar_color1 => Color.new(39, 138, 29),
          :bar_color2 => Color.new(52, 242, 32)},
          
    {:name => "¿Ernie? ¡Es un buen mercenario!", :rep_min => 18000000,
          :bar_color1 => Color.new(39, 138, 29),
          :bar_color2 => Color.new(52, 242, 32)},
    
    {:name => "Es un mercenario competente.", :rep_min => 24000000,
          :bar_color1 => Color.new(39, 138, 29),
          :bar_color2 => Color.new(52, 242, 32)}
  ]
  
  FactionType = {
      :faction => "Contribución regional",
      :individual => "Otro"
  }
  
  Factions = [
    {:name => "Aylo", :type => :faction, :initial_value => 0,
      :discovered => true,
      :graphic => "Aylo",
      :description => "Un pequeño pueblo de montaña que siempre está bajo la amenaza de monstruos.
      \n Los habitantes del pueblo cazan monstruos por recompensas o patrullan para proteger sus cultivos y ganado.
      \n Sin embargo, los monstruos se están volviendo más fuertes, por lo que los habitantes viven en constante vigilancia."
    },
    {:name => "Palserine", :type => :faction, :initial_value => 0,
      :discovered => true,
      :graphic => "Palserine",
      :description => "Un pueblo con un comercio muy desarrollado.
      \n Sin embargo, hay preocupaciones y cautela sobre este desarrollo, y por ello se han enviado iglesias y caballeros a proteger el lugar.
      \n Ellos se esfuerzan por mantener la estabilidad y seguridad del comercio.
      \n Es uno de los centros comerciales y políticos del continente de Ailance."
    },
    {:name => "Serat", :type => :faction, :initial_value => 0,
      :discovered => true,
      :graphic => "Serat",
      :description => "Un pequeño pueblo situado en una región por donde fluye un gran río, lo que favorece el comercio.
      \n Es conocido por comerciar muchos artículos extraños y los mercaderes venden productos únicos que no se pueden encontrar en otros pueblos. También es famoso por sus platos de mariscos."
    },
    {:name => "Base Paradel", :type => :faction, :initial_value => 0,
      :discovered => true,
      :graphic => "Paradel",
      :description => "Un lugar con ruinas antiguas, donde algunos mercenarios y aventureros se han reunido temporalmente en busca de riquezas.
      \n El descubrimiento de las ruinas ha atraído a muchos aventureros, y muchos de ellos permanecen allí buscando tesoros aún no hallados.
      \n Sin embargo, al ser una zona de alto riesgo, la base Paradel cuenta con muchos mercenarios poderosos y aventureros profesionales."
    },
    {:name => "Crotz", :type => :faction, :initial_value => 0,
      :discovered => true,
      :graphic => "Crotz",
      :description => "Una región con solo un edificio, el tocón (posada), que es el único edificio.
      \n Esta posada es conocida por vender drogas y artículos robados clandestinamente.
      \n Es un lugar ideal para criminales y también es un sitio al que los aventureros deben estar atentos."
    },
    {:name => "Sline", :type => :faction, :initial_value => 0,
      :discovered => true,
      :graphic => "Sline",
      :description => "Un lugar que santifica la religión de Elzairen, donde viven el arzobispo de Elzairen, la santa y los devotos religiosos.
      \n El pueblo alberga el gran templo de Elzairen, la residencia del arzobispo y una catedral, que son el núcleo del lugar.
      \n Sline tiene una atmósfera profundamente religiosa, que influye en la vida y cultura de sus habitantes."
    },
    {:name => "Darwin", :type => :faction, :initial_value => 0,
      :discovered => true,
      :graphic => "Darwin",
      :description => "Un pueblo donde se reúnen personas que han fracasado como aventureros, mercenarios o políticos. Generalmente son personas que no fueron reconocidas por sus habilidades o que sufrieron eventos desafortunados.
      \n Por eso, hay muchos trabajadores dispuestos a hacer trabajos desagradables.
      \n Aunque la mayoría vive en pobreza, los habitantes del pueblo se ayudan mutuamente."
    },
    {:name => "Bylas", :type => :faction, :initial_value => 0,
      :discovered => true,
      :graphic => "Bylas",
      :description => "Un pueblo conocido como el paraíso de los mercenarios y aventureros, donde la gente siente una atmósfera relativamente libre en comparación con otros pueblos.
      \n Hay una gran variedad de objetos mágicos y muchas misiones difíciles, lo que lo hace famoso.
      \n Bylas también alberga al famoso gremio de mercenarios de Bylas.
      \n Este gremio está formado por mercenarios de gran habilidad, por lo que muchas personas de otros pueblos reconocen y buscan sus capacidades."
    },
    {:name => "Serraton", :type => :faction, :initial_value => 0,
      :discovered => true,
      :graphic => "Serraton",
      :description => "Un pueblo donde viven aventureros retirados.
      \n Basándose en sus experiencias y conocimientos de aventuras y combates pasados, trabajan para mantener la seguridad y el bienestar del pueblo.
      \n También transmiten sus conocimientos a jóvenes aventureros y combaten monstruos grandes para proteger el lugar."
    },
    {:name => "Horifel", :type => :faction, :initial_value => 0,
      :discovered => true,
      :graphic => "Horifel",
      :description => "Un pueblo que una vez floreció, pero que cayó en desgracia debido a guerras con monstruos y conflictos internos.
      \n Durante ese proceso, muchos habitantes murieron o abandonaron el lugar.
      \n Actualmente, algunos residentes permanecen, pero el pueblo sigue desordenado y con muchas situaciones peligrosas.
      \n En el centro del pueblo hay un lugar de ejecución pública, conocido por sus ejecuciones de criminales y amenazas.
      \n Sin fuerzas del orden como patrullas o guardias, los residentes deben protegerse y sus pertenencias por sí mismos.
      \n A pesar de estos peligros, los habitantes continúan luchando para proteger el pueblo de los monstruos.
      \n El conflicto con el pueblo vecino de Drawwine también aumenta la tensión entre los residentes."
    },
    {:name => "Drawwine", :type => :faction, :initial_value => 0,
      :discovered => true,
      :graphic => "Drawwine",
      :description => "Un pueblo fundado por algunos residentes leales a una facción que perdió el control en Horifel.
      \n Debido a esta historia, hay tensión y rivalidad entre los residentes de Horifel y Drawwine."
    },
    {:name => "Bosque de Hasala", :type => :faction, :initial_value => 0,
      :discovered => true,
      :graphic => "Hasala",
      :description => "El bosque de Hasala es una vasta región boscosa en el centro del continente, rica en flora y fauna.
      \n Hay muchos monstruos peligrosos, por lo que raramente entran personas comunes.
      \n Gavitia Hasala es un hombre de mediana edad que ha vivido solo en este bosque durante mucho tiempo, adquiriendo conocimientos y habilidades de combate.
      \n Es un aventurero poderoso con gran capacidad de combate y un erudito con profundo conocimiento.
      \n Sin embargo, ha vivido solo durante tanto tiempo que se siente muy solitario y añora a su difunta esposa.
      \n Tiene una visión del mundo y una filosofía únicas, que a menudo provocan conflictos cuando se encuentra con otras personas.
      \n No obstante, sus conocimientos y habilidades de combate pueden ser de gran ayuda para los aventureros que viajan por la región."
    },
  ]
  
  UseInMenu = true
  MenuTerm = "Contribución regional"
  
  UseDescriptions = true
  UseGraphics = true
  DescriptionAlignment = 1
  
  MaxReputation = 100000000
  
  Default_BarColor1 = Color.new(172,196,36)
  Default_BarColor2 = Color.new(82,106,16)
end