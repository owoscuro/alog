# encoding: utf-8
# Name: 274.Customize Section
# Size: 96751
# encoding: utf-8
# Name: 274.Customize Section
# Size: 96623
#===============================================================================
# Crafting Script Customize Settings - v3.8                 updated: 10/27/2014
#===============================================================================
$imported = {} unless $imported
$imported[:Venka_Crafting] = true
#===============================================================================
# ■ Venka Module
#===============================================================================
module Venka; module Crafting
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  Window_Opacity     = 255      # Window's over all opacity. Number 0 - 255
  Window_BGOpacity   = 180      # Window's background opacity (default 192)
  Auto_Learn         = true     # 평평하게 할 때 자동으로 요리법 배우기
  Gold_Icon          = 3872     # Icon Index used for Gold Coins
  Gold_Text          = "Oro"
  Gold_Hue           = 0        # Icon Hue (if using modern alegbra's Icon Hues)
  Use_Line_Dividers  = true     # 줄 구분 기호 표시 토글
  Failure_Exp_Rate   = 0.25     # Exp 실패시 수신. Ex 0.25는 25 %
  Include_Equipment  = true     # 총 소유 품목에 장착 된 품목을 포함 시키시겠습니까?
  Use_Craft_Exp      = true     # 공예 경험과 레벨을 사용하여 진실 / 거짓
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  Timer_Type = :timer          # :active, :timer, :none
  Crafting_Time_Max  = 100     # 최대 공예 시간 (총 시간)
  Crafting_Buffer    = 5       # 버퍼에서 활성화 된 타이머 (소유권 주장을위한 창)
  Default_Craft_Time = 6       # 기본 공예 시간 (항목을 청구 할시기)
  Time_Variance      = 100     # 분산 시간을 0으로 설정하여 사용 중지합니다.
  Accelerate_Time    = true    # 크래프트 타임은 레벨을 올리면 빠릅니다.
  # 이것은 공예 시간을 가속화하는 속도입니다. 이 값은 0.1에서 0.9 사이 여야합니다.
  Accelerate_Rate    = 0.6     # 숫자가 낮을수록 속도가 빨라집니다.
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  Craft_Stacks = true          # 항목 스택 제작을 허용하려면 true로 설정하십시오.
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  Sort_Type = :level           # choices are :level, :alphabet, or :default
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  # You can use window skin color code by simply putting the number (0 - 31) 
  # OR use RBG Colors by putting (red, blue, green, opacity) 0 - 255 each.
  #    Examples:    Exp_Gauge_Color1 = 27
  #                 Exp_Gauge_Color1 = [10, 100, 215, 100]
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  Exp_Gauge_Color1   = [110,   0, 215, 200]   # Left side of the exp gauge
  Exp_Gauge_Color2   = [180, 150, 255, 230]   # Right side of the exp gauge
  Craft_Gauge_Color1 = 10                     # Left side of the crafting gauge
  Craft_Gauge_Color2 = 21                     # Right side of the crafting gauge
  Claim_Gauge_Color1 = [ 25, 100,   0, 255]   # Left side of the claim gauge
  Claim_Gauge_Color2 = [  0, 255,   0, 240]   # Right side of the claim gauge
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  Start_Scene      = ["Book1", 80, 100]            # Sound on book open
  Success_Sound    = ["Item1", 80, 75]             # Crafted successfully
  Premature_Sound  = ["Disappointment", 80, 100]   # Crafted too soon
  Failure_Sound    = ["Chime1", 80, 50]            # Crafted too late
  Level_Up_Sound   = ["Sound2", 80, 100]           # Gained crafting level
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  Craft_Button_Text = "Fabricar"
  Directions_Msg    = "Presiona la tecla Z cuando la barra esté en verde."
  Possessed_Text    = "Actualmente poseído:"
  Ingredients_Text  = "Materiales necesarios"
  Needed_Owned_Text = "Necesario / Poseído"
  Level_Text        = "Nivel requerido:"
  EXP_Text          = "EXP"
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  Pop_up_Window    = true
  Result_Opacity   = 255
  Result_BGOpacity = 215
  Results_Text     = "Resultados"
  Failed_Msg       = "Fabricación fallida."
  Result_Msg       = "Ítems obtenidos:"
  Lv_Gain          = "¡Nivel arriba!"
  Exp_Earned       = "EXP obtenida"
  Max_Exp          = "¡EXP máxima!"
  Learn_Text       = "Receta aprendida:" 
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  # :title_text   = the text craft's name in the Title Window.
  # :recipe_name  = the recipe's name at the top of the detail window
  # :recipe_list  = font used in the recipe list window
  # :header_text  = the "Ingredients: Needed/Owned" line in the detail window
  # :description  = the crafted item's description text.
  # :help_text    = the text that appears when crafting an item.
  # :other_text   = all other text
  # :button_text  = the Create/Cancel Buttons test
  # 
  # For each text type you need to set up the Fonts, Size, Boldness and Color.
  # Use the following format:
  #   [["Font_Name, Font_Name, etc], Font_Size, Bold?, Color]],
  #      Font_Name = an array holding font choices. The fist one is your first 
  #         choice to use, but if the player doesn't have that font on their 
  #         computer, it will go through the list until it finds one it can use
  #      Font_Size = the size font you want to use
  #      Bold? = this should be true for bold, false to turn bold off
  #      Color = This is the same format as setting colors for Gauge Color.
  #         Use [red, blue, green, opacity] or window skin color number.
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  Line_Color = [150, 150, 250, 225]
  Fonts = {       # [["Fonts"]], Size, Bold?, Color
    :title_text  => [["한컴 윤체 L"], 22, false,  0],
    :recipe_name => [["한컴 윤체 L"], 22, false,  14],
    :recipe_list => [["한컴 윤체 L"], 20, false,  0],
    :header_text => [["한컴 윤체 L"], 22, false,  1],
    :description => [["한컴 윤체 L"], 22, false, 0],
    :help_text   => [["한컴 윤체 L"], 20, false, 17],
    :other_text  => [["한컴 윤체 L"], 22, false, 0],
    :button_text => [["한컴 윤체 L"], 22, false, [0, 255, 0, 200]],
    }
  Craft_Info ||= {}
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  #  Craft_Info[ID] => {                          # ID must be a unique number
  #      :craft_name    => "Title",               # The name of the craft
  #          "Title" will be the name of the craft
  #      :craft_time    => n,                     # n은 공예 시간이 될 것입니다.
  # 아이템의 제작 유형에 따라 기본 제작 시간을 설정할 수 있습니다.
  # 이 옵션은 생략 가능합니다. 이 옵션을 사용하면
  # 이 공예 유형에 대해 위에 설정된 Default_Craft_Time을 덮어씁니다.
  #      :buffer_time   => n,                     # n은 버퍼 시간입니다.
  # 공예품 종류별로 아이템의 기본 버퍼 시간을 설정할 수 있습니다.
  # 버퍼 타임은 제작할 수 있는 기회의 창
  # :active 제작 Timer_Type을 사용할 때의 아이템. 생략 가능
  # 이 설정은 Crafting_Buffer 시간을 사용합니다.
  #      :exp_table     => [A, B, C, D],          # Exp Curve
  #          A is the base exp needed (this number can be 10 or higher)
  #          B is the exp tacked on to each level (this can be 0 or higher)
  #          C is a curve that effects all levels (must be 10 or higher)
  #          D is another curve that effects high levels mostly (must be 10+)
  #          NOTE: This functions exactly like class exp in the database
  #      :max_level     => x,                     # Max Craft Level
  #          x is the maximum level for the craft (1-99)
  #      :mastered      => "Text",                # Title seen at Max Level
  #          "Text" is text shown when the exp gauge for the craft is maxed out
  #      :bg_image      => "File_Name",           # Background image for scene
  #          "File_Name" is file found Graphics/Titles1 or Graphics/Picture.
  #          Use nil to omit this option.
  #      :bg_music      => "File_Name",           # Background music for scene
  #          "File_Name" is file found Audio/BGM. Use nil to omit
  #      :active_sound  => ["File_Name", Volume, Pitch],  # Sound while crafting
  #          For this one, it will check in the Audio/BGS folder first if it 
  #          doesn't find the file, then it'll check in Audio/SE. If the file 
  #          is a SE (sound effect) it will play ever 2 seconds. Can be omitted.
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  Craft_Info[1] = {
    :craft_name    => "Alquimista",
    :exp_table     => [ 10, 5, 12, 20],
    :max_level     => 100,
    :mastered      => "Alquimista",
    :bg_image      => nil,
    :bg_music      => nil,
    :active_sound  => ["Fire", 100, 100],
    } # <-DO NOT REMOVE
  Craft_Info[2] = {
    :craft_name    => "Herrero",
    :exp_table     => [ 12, 3, 20, 15],
    :max_level     => 100,
    :mastered      => "Herrero",
    :bg_image      => nil,
    :bg_music      => nil,
    :active_sound  => ["Hammer", 100, 100],
    } # <-DO NOT REMOVE
  Craft_Info[3] = {
    :craft_name    => "Joyería",
    :exp_table     => [ 17, 8, 25, 20],
    :max_level     => 100,
    :mastered      => "Joyería",
    :bg_image      => nil,
    :bg_music      => nil,
    :active_sound  => ["Hammer", 100, 100],
    } # <-DO NOT REMOVE
  Craft_Info[4] = {
    :craft_name    => "Cocinero",
    #:craft_time    => 30,
    #:buffer_time   => 90,
    :exp_table     => [ 10, 5, 12, 20],
    :max_level     => 100,
    :mastered      => "Cocinero",
    :bg_image      => nil,
    :bg_music      => nil,
    :active_sound  => ["Fire", 100, 100],
    } # <-DO NOT REMOVE
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  # - Recipe Settings -
  #----------------------------------------------------------------------------
  # To create a recipe you will need to fill out the information below. Most of 
  # these entries are optional. The only ones that MUST be defined are the ID, 
  # :recipe_type, :crafted_item and :ingredients. The id is requred so the 
  # script can find the recipe. The :recipe_type is so it know which crafting 
  # category it belongs to. The :crafted_item is what it will produce (failed 
  # and prefailed items are optional). And lastly, you will need to set up 
  # atleast one required item to craft in :ingredients. It can be an item, gold, 
  # weapons or armor or any combo of these items. There are 10 recipes set up 
  # in the demo that should demonstrate the various things you can do.
  # 
  # Recipe[ID] => {      The ID must be a unique number.
  #   :recipe_type  => x,
  #         x = the Craft_Info ID this recipe belongs to.
  #             If it was 1 then it'd be a cooking recipe, 2 is blacksmith, etc
  #   :auto_learn    => false,
  #         This can be omitted. This option only works if Auto_Learn = true
  #         You'll set this option to false if you want this recipe to be 
  #         learned from a special source (like a NPC, quest, boss kill, etc).
  #   :req_level    => y
  #         y = the crafting level needed to make the recipe
  #   :display_name => "text"
  #         text is the text that will appear in place of the crafted item's 
  #         name. The crafted items icon will still show.
  #   :shop_fee => n,         # The cost to craft the recipe at a shop keeper
  #         n = a number in gold pieces. This only matters if using the Shop
  #             Craft & Decompile Add on script.
  #   :craft_time   => t,
  #         t = time in frames (60 frames = 1 second). This is the time when 
  #             the recipe can claim success. Before the time results in lost
  #             ingredients and no item. After this time results in lost
  #             ingredients and a failed attempt item is granted.
  #         NOTE: You can omit this one to use the Default_Craft_Time above
  #   :earned_exp   => exp,
  #         exp = the amount of exp received on successful crafting of the item
  #   :crafted_item => [:Type/Item_ID, Amount],
  #   :failed_item  => [:Type/Item_ID, Amount], # Item made if crafted too late
  #   :pre_failed   => [:Type/Item_ID, Amount], # Item made if crafted too soon
  #   :ingredients  => [[:Type/ItemID, Amount], [:Type/ItemID, Amount], ... ]
  #         Type = i for Items
  #                a for Armor
  #                w for Weapons
  #                g for Gold
  #         Item_ID = item's id in the database
  #         Amount  = the amount of items to reward
  # 
  # NOTE: :ingredients can have multiple entries. The following entries can be
  #     omitted - :failed_item, :pre_failed, and :craft_time
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  Recipes ||= {}
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  ro_nb = 1
Recipes[ro_nb] = {  #초강철, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 2, # 레벨 조건
  :shop_fee     => 4, # 가게에서 만드는 경우 수수료
  :craft_time   => 100, # 제작 시간
  :earned_exp   => 10, # 얻을 경험치
  :crafted_item => [:i482, 5], # 성공시 아이템
  :failed_item  => [:i482, 1], # 실패시 아이템
  :ingredients  => [[:i121, 5], [:i130, 3], [:i146, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #은, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 2, # 레벨 조건
  :shop_fee     => 4, # 가게에서 만드는 경우 수수료
  :craft_time   => 100, # 제작 시간
  :earned_exp   => 10, # 얻을 경험치
  :crafted_item => [:i475, 15], # 성공시 아이템
  :failed_item  => [:i475, 1], # 실패시 아이템
  :ingredients  => [[:i131, 15], [:i141, 1], [:i146, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #금, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 3, # 레벨 조건
  :shop_fee     => 4, # 가게에서 만드는 경우 수수료
  :craft_time   => 150, # 제작 시간
  :earned_exp   => 10, # 얻을 경험치
  :crafted_item => [:i476, 15], # 성공시 아이템
  :failed_item  => [:i476, 1], # 실패시 아이템
  :ingredients  => [[:i123, 15], [:i473, 2], [:i146, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #골든 다이아몬드, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 4, # 레벨 조건
  :shop_fee     => 6, # 가게에서 만드는 경우 수수료
  :craft_time   => 200, # 제작 시간
  :earned_exp   => 20, # 얻을 경험치
  :crafted_item => [:i477, 3], # 성공시 아이템
  :failed_item  => [:i477, 1], # 실패시 아이템
  :ingredients  => [[:i476, 3], [:i145, 1], [:i146, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #세라믹 티타늄, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 5, # 레벨 조건
  :shop_fee     => 8, # 가게에서 만드는 경우 수수료
  :craft_time   => 220, # 제작 시간
  :earned_exp   => 24, # 얻을 경험치
  :crafted_item => [:i478, 2], # 성공시 아이템
  :failed_item  => [:i478, 1], # 실패시 아이템
  :ingredients  => [[:i475, 2], [:i141, 1], [:i146, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #골든 티타늄, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 5, # 레벨 조건
  :shop_fee     => 8, # 가게에서 만드는 경우 수수료
  :craft_time   => 220, # 제작 시간
  :earned_exp   => 24, # 얻을 경험치
  :crafted_item => [:i479, 2], # 성공시 아이템
  :failed_item  => [:i479, 1], # 실패시 아이템
  :ingredients  => [[:i476, 2], [:i473, 1], [:i146, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #루나틱 티타늄, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 7, # 레벨 조건
  :shop_fee     => 14, # 가게에서 만드는 경우 수수료
  :craft_time   => 360, # 제작 시간
  :earned_exp   => 34, # 얻을 경험치
  :crafted_item => [:i480, 1], # 성공시 아이템
  :failed_item  => [:i480, 1], # 실패시 아이템
  :ingredients  => [[:i479, 1], [:i478, 1], [:i477, 1],]}; ro_nb += 1
  
Recipes[ro_nb] = {  #빵, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 3, # 가게에서 만드는 경우 수수료
  :craft_time   => 100, # 제작 시간
  :earned_exp   => 10, # 얻을 경험치
  :crafted_item => [:i197, 5], # 성공시 아이템
  :failed_item  => [:i224, 1], # 실패시 아이템
  :ingredients  => [[:i224, 3], [:i227, 4], [:i221, 3],]}; ro_nb += 1
Recipes[ro_nb] = {  #스콘, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 2, # 레벨 조건
  :shop_fee     => 3, # 가게에서 만드는 경우 수수료
  :craft_time   => 200, # 제작 시간
  :earned_exp   => 10, # 얻을 경험치
  :crafted_item => [:i194, 3], # 성공시 아이템
  :failed_item  => [:i224, 1], # 실패시 아이템
  :ingredients  => [[:i224, 3], [:i227, 4], [:i223, 3],]}; ro_nb += 1
Recipes[ro_nb] = {  #베이글, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 2, # 레벨 조건
  :shop_fee     => 3, # 가게에서 만드는 경우 수수료
  :craft_time   => 200, # 제작 시간
  :earned_exp   => 10, # 얻을 경험치
  :crafted_item => [:i195, 3], # 성공시 아이템
  :failed_item  => [:i224, 1], # 실패시 아이템
  :ingredients  => [[:i224, 4], [:i227, 3], [:i223, 2],]}; ro_nb += 1
Recipes[ro_nb] = {  #미트 파이, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 2, # 레벨 조건
  :shop_fee     => 3, # 가게에서 만드는 경우 수수료
  :craft_time   => 220, # 제작 시간
  :earned_exp   => 10, # 얻을 경험치
  :crafted_item => [:i196, 3], # 성공시 아이템
  :failed_item  => [:i224, 1], # 실패시 아이템
  :ingredients  => [[:i224, 3], [:i227, 2], [:i223, 1], [:i162, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #미트 파이, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 2, # 레벨 조건
  :shop_fee     => 3, # 가게에서 만드는 경우 수수료
  :craft_time   => 220, # 제작 시간
  :earned_exp   => 10, # 얻을 경험치
  :crafted_item => [:i196, 3], # 성공시 아이템
  :failed_item  => [:i224, 1], # 실패시 아이템
  :ingredients  => [[:i224, 3], [:i227, 2], [:i223, 1], [:i289, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #미트 파이, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 2, # 레벨 조건
  :shop_fee     => 3, # 가게에서 만드는 경우 수수료
  :craft_time   => 220, # 제작 시간
  :earned_exp   => 10, # 얻을 경험치
  :crafted_item => [:i196, 3], # 성공시 아이템
  :failed_item  => [:i224, 1], # 실패시 아이템
  :ingredients  => [[:i224, 3], [:i227, 2], [:i223, 1], [:i293, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #쌈밥, 제작 아이템	
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사	
  :auto_learn   => true, # 레시피 자동 학습 여부	
  :req_level    => 1, # 레벨 조건	
  :shop_fee     => 3, # 가게에서 만드는 경우 수수료	
  :craft_time   => 70, # 제작 시간	
  :earned_exp   => 10, # 얻을 경험치	
  :crafted_item => [:i199, 3], # 성공시 아이템	
  :failed_item  => [:i197, 1], # 실패시 아이템	
  :ingredients  => [[:i197, 3], [:i94, 3],]}; ro_nb += 1	
Recipes[ro_nb] = {  #계란말이, 제작 아이템	
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사	
  :auto_learn   => true, # 레시피 자동 학습 여부	
  :req_level    => 2, # 레벨 조건	
  :shop_fee     => 3, # 가게에서 만드는 경우 수수료	
  :craft_time   => 90, # 제작 시간	
  :earned_exp   => 15, # 얻을 경험치	
  :crafted_item => [:i200, 3], # 성공시 아이템	
  :failed_item  => [:i227, 3], # 실패시 아이템	
  :ingredients  => [[:i227, 10], [:i225, 5],]}; ro_nb += 1	
Recipes[ro_nb] = {  #오므라이스, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 2, # 레벨 조건
  :shop_fee     => 3, # 가게에서 만드는 경우 수수료
  :craft_time   => 90, # 제작 시간
  :earned_exp   => 20, # 얻을 경험치
  :crafted_item => [:i201, 3], # 성공시 아이템
  :failed_item  => [:i227, 3], # 실패시 아이템
  :ingredients  => [[:i227, 10], [:i225, 5], [:i198, 5],]}; ro_nb += 1
Recipes[ro_nb] = {  #소형 폭탄, 제작 아이템
  :recipe_type  => 3, # 레시피 타입, 3은 도구
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 100, # 가게에서 만드는 경우 수수료
  :craft_time   => 220, # 제작 시간
  :earned_exp   => 20, # 얻을 경험치
  :crafted_item => [:i75, 5], # 성공시 아이템
  :failed_item  => [:i125, 1], # 실패시 아이템
  :ingredients  => [[:i121, 2], [:i125, 2], [:i122, 5],]}; ro_nb += 1
Recipes[ro_nb] = {  #중형 폭탄, 제작 아이템
  :recipe_type  => 3, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 2, # 레벨 조건
  :shop_fee     => 120, # 가게에서 만드는 경우 수수료
  :craft_time   => 220, # 제작 시간
  :earned_exp   => 20, # 얻을 경험치
  :crafted_item => [:i76, 5], # 성공시 아이템
  :failed_item  => [:i125, 1], # 실패시 아이템
  :ingredients  => [[:i121, 4], [:i125, 4], [:i122, 7],]}; ro_nb += 1
Recipes[ro_nb] = {  #대형 폭탄, 제작 아이템
  :recipe_type  => 3, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 3, # 레벨 조건
  :shop_fee     => 120, # 가게에서 만드는 경우 수수료
  :craft_time   => 220, # 제작 시간
  :earned_exp   => 30, # 얻을 경험치
  :crafted_item => [:i77, 5], # 성공시 아이템
  :failed_item  => [:i125, 1], # 실패시 아이템
  :ingredients  => [[:i121, 4], [:i125, 4], [:i122, 7], [:i265, 10],]}; ro_nb += 1
Recipes[ro_nb] = {  #익은 고기, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 1, # 가게에서 만드는 경우 수수료
  :craft_time   => 250, # 제작 시간
  :earned_exp   => 5, # 얻을 경험치
  :crafted_item => [:i161, 1], # 성공시 아이템
  :failed_item  => [:i265, 1], # 실패시 아이템
  :ingredients  => [[:i159, 1], [:i225, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #작은 익은 고기, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 1, # 가게에서 만드는 경우 수수료
  :craft_time   => 450, # 제작 시간
  :earned_exp   => 5, # 얻을 경험치
  :crafted_item => [:i162, 1], # 성공시 아이템
  :failed_item  => [:i265, 1], # 실패시 아이템
  :ingredients  => [[:i160, 1], [:i225, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #화염병, 제작 아이템
  :recipe_type  => 3, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 120, # 가게에서 만드는 경우 수수료
  :craft_time   => 220, # 제작 시간
  :earned_exp   => 20, # 얻을 경험치
  :crafted_item => [:i78, 5], # 성공시 아이템
  :failed_item  => [:i36, 1], # 실패시 아이템
  :ingredients  => [[:i62, 5], [:i243, 1], [:i122, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #방책, 제작 아이템
  :recipe_type  => 3, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 120, # 가게에서 만드는 경우 수수료
  :craft_time   => 220, # 제작 시간
  :earned_exp   => 30, # 얻을 경험치
  :crafted_item => [:i28, 5], # 성공시 아이템
  :failed_item  => [:i121, 2], # 실패시 아이템
  :ingredients  => [[:i121, 2], [:i238, 1], [:i136, 10],]}; ro_nb += 1
Recipes[ro_nb] = {  #모닥불, 제작 아이템
  :recipe_type  => 3, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 120, # 가게에서 만드는 경우 수수료
  :craft_time   => 220, # 제작 시간
  :earned_exp   => 30, # 얻을 경험치
  :crafted_item => [:i27, 5], # 성공시 아이템
  :failed_item  => [:i122, 2], # 실패시 아이템
  :ingredients  => [[:i122, 2], [:i62, 2], [:i136, 10],]}; ro_nb += 1
Recipes[ro_nb] = {  #각성 Poción, 제작 아이템
  :recipe_type  => 1, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 3, # 레벨 조건
  :shop_fee     => 10, # 가게에서 만드는 경우 수수료
  :craft_time   => 50, # 제작 시간
  :earned_exp   => 5, # 얻을 경험치
  :crafted_item => [:i11, 1], # 성공시 아이템
  :failed_item  => [:i36, 1], # 실패시 아이템
  :ingredients  => [[:i36, 1],[:i60, 1],[:i96, 4],]}; ro_nb += 1
Recipes[ro_nb] = {  #안정 Poción, 제작 아이템
  :recipe_type  => 1, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 3, # 레벨 조건
  :shop_fee     => 10, # 가게에서 만드는 경우 수수료
  :craft_time   => 50, # 제작 시간
  :earned_exp   => 5, # 얻을 경험치
  :crafted_item => [:i12, 1], # 성공시 아이템
  :failed_item  => [:i36, 1], # 실패시 아이템
  :ingredients  => [[:i36, 1],[:i60, 1],[:i95, 4],]}; ro_nb += 1
Recipes[ro_nb] = {  #흥분 Poción, 제작 아이템
  :recipe_type  => 1, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 3, # 레벨 조건
  :shop_fee     => 10, # 가게에서 만드는 경우 수수료
  :craft_time   => 50, # 제작 시간
  :earned_exp   => 5, # 얻을 경험치
  :crafted_item => [:i13, 1], # 성공시 아이템
  :failed_item  => [:i36, 1], # 실패시 아이템
  :ingredients  => [[:i36, 1],[:i60, 1],[:i95, 2],[:i94, 4],]}; ro_nb += 1
Recipes[ro_nb] = {  #감기 치료 Poción, 제작 아이템
  :recipe_type  => 1, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 2, # 레벨 조건
  :shop_fee     => 10, # 가게에서 만드는 경우 수수료
  :craft_time   => 50, # 제작 시간
  :earned_exp   => 5, # 얻을 경험치
  :crafted_item => [:i14, 1], # 성공시 아이템
  :failed_item  => [:i36, 1], # 실패시 아이템
  :ingredients  => [[:i36, 1],[:i60, 1],[:i100, 3],[:i99, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #복통 치료 Poción, 제작 아이템
  :recipe_type  => 1, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 2, # 레벨 조건
  :shop_fee     => 10, # 가게에서 만드는 경우 수수료
  :craft_time   => 50, # 제작 시간
  :earned_exp   => 5, # 얻을 경험치
  :crafted_item => [:i16, 1], # 성공시 아이템
  :failed_item  => [:i36, 1], # 실패시 아이템
  :ingredients  => [[:i36, 1],[:i60, 1],[:i95, 1],[:i98, 3],]}; ro_nb += 1
Recipes[ro_nb] = {  #두통 치료 Poción, 제작 아이템
  :recipe_type  => 1, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 2, # 레벨 조건
  :shop_fee     => 10, # 가게에서 만드는 경우 수수료
  :craft_time   => 50, # 제작 시간
  :earned_exp   => 5, # 얻을 경험치
  :crafted_item => [:i17, 1], # 성공시 아이템
  :failed_item  => [:i36, 1], # 실패시 아이템
  :ingredients  => [[:i36, 1],[:i60, 1],[:i93, 2],[:i97, 2],]}; ro_nb += 1
  
Recipes[ro_nb] = {  # 소형 빨간 Poción, 제작 아이템
  :recipe_type  => 1, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 10, # 가게에서 만드는 경우 수수료
  :craft_time   => 50, # 제작 시간
  :earned_exp   => 5, # 얻을 경험치
  :crafted_item => [:i1, 1], # 성공시 아이템
  :failed_item  => [:i36, 1], # 실패시 아이템
  :ingredients  => [[:i36, 1],[:i60, 1],[:i93, 4],[:i98, 2],]}; ro_nb += 1
Recipes[ro_nb] = {  # 중형 빨간 Poción, 제작 아이템
  :recipe_type  => 1, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 2, # 레벨 조건
  :shop_fee     => 10, # 가게에서 만드는 경우 수수료
  :craft_time   => 50, # 제작 시간
  :earned_exp   => 5, # 얻을 경험치
  :crafted_item => [:i2, 1], # 성공시 아이템
  :failed_item  => [:i36, 1], # 실패시 아이템
  :ingredients  => [[:i36, 1],[:i60, 2],[:i93, 6],[:i98, 6],]}; ro_nb += 1
Recipes[ro_nb] = {  # 대형 빨간 Poción, 제작 아이템
  :recipe_type  => 1, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 3, # 레벨 조건
  :shop_fee     => 10, # 가게에서 만드는 경우 수수료
  :craft_time   => 50, # 제작 시간
  :earned_exp   => 5, # 얻을 경험치
  :crafted_item => [:i3, 1], # 성공시 아이템
  :failed_item  => [:i36, 1], # 실패시 아이템
  :ingredients  => [[:i36, 1],[:i60, 3],[:i93, 10],[:i98, 10],]}; ro_nb += 1
Recipes[ro_nb] = {  # 소형 파란 Poción, 제작 아이템
  :recipe_type  => 1, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 10, # 가게에서 만드는 경우 수수료
  :craft_time   => 50, # 제작 시간
  :earned_exp   => 5, # 얻을 경험치
  :crafted_item => [:i5, 1], # 성공시 아이템
  :failed_item  => [:i36, 1], # 실패시 아이템
  :ingredients  => [[:i36, 1],[:i60, 1],[:i93, 2],[:i96, 2],]}; ro_nb += 1
Recipes[ro_nb] = {  # 중형 파란 Poción, 제작 아이템
  :recipe_type  => 1, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 2, # 레벨 조건
  :shop_fee     => 10, # 가게에서 만드는 경우 수수료
  :craft_time   => 50, # 제작 시간
  :earned_exp   => 5, # 얻을 경험치
  :crafted_item => [:i6, 1], # 성공시 아이템
  :failed_item  => [:i36, 1], # 실패시 아이템
  :ingredients  => [[:i36, 1],[:i60, 2],[:i93, 6],[:i96, 6],]}; ro_nb += 1
Recipes[ro_nb] = {  # 대형 파란 Poción, 제작 아이템
  :recipe_type  => 1, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 3, # 레벨 조건
  :shop_fee     => 10, # 가게에서 만드는 경우 수수료
  :craft_time   => 50, # 제작 시간
  :earned_exp   => 5, # 얻을 경험치
  :crafted_item => [:i7, 1], # 성공시 아이템
  :failed_item  => [:i36, 1], # 실패시 아이템
  :ingredients  => [[:i36, 1],[:i60, 3],[:i93, 10],[:i96, 10],]}; ro_nb += 1
Recipes[ro_nb] = {  # 피임약, 제작 아이템
  :recipe_type  => 1, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 10, # 레벨 조건
  :shop_fee     => 10, # 가게에서 만드는 경우 수수료
  :craft_time   => 300, # 제작 시간
  :earned_exp   => 25, # 얻을 경험치
  :crafted_item => [:i70, 5], # 성공시 아이템
  :failed_item  => [:i36, 1], # 실패시 아이템
  :ingredients  => [[:i36, 1],[:i267, 5],[:i156, 3],[:i98, 5],]}; ro_nb += 1
Recipes[ro_nb] = {  # 배란유도제, 제작 아이템
  :recipe_type  => 1, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 20, # 레벨 조건
  :shop_fee     => 10, # 가게에서 만드는 경우 수수료
  :craft_time   => 350, # 제작 시간
  :earned_exp   => 25, # 얻을 경험치
  :crafted_item => [:i71, 5], # 성공시 아이템
  :failed_item  => [:i36, 1], # 실패시 아이템
  :ingredients  => [[:i36, 1],[:i448, 10],[:i449, 5],[:i250, 5],[:i155, 5],[:i63, 10],]}; ro_nb += 1
Recipes[ro_nb] = {  # 낙태 주사기, 제작 아이템
  :recipe_type  => 1, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 10, # 레벨 조건
  :shop_fee     => 10, # 가게에서 만드는 경우 수수료
  :craft_time   => 330, # 제작 시간
  :earned_exp   => 20, # 얻을 경험치
  :crafted_item => [:i72, 5], # 성공시 아이템
  :failed_item  => [:i36, 1], # 실패시 아이템
  :ingredients  => [[:i36, 1],[:i95, 10],[:i113, 5],[:i226, 5],]}; ro_nb += 1
Recipes[ro_nb] = {  # 성욕 제거 주사기, 제작 아이템
  :recipe_type  => 1, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 10, # 레벨 조건
  :shop_fee     => 10, # 가게에서 만드는 경우 수수료
  :craft_time   => 330, # 제작 시간
  :earned_exp   => 20, # 얻을 경험치
  :crafted_item => [:i73, 5], # 성공시 아이템
  :failed_item  => [:i36, 1], # 실패시 아이템
  :ingredients  => [[:i36, 1],[:i97, 5],[:i109, 3],[:i264, 3],]}; ro_nb += 1
Recipes[ro_nb] = {  #보라색 익은 고기, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 1, # 가게에서 만드는 경우 수수료
  :craft_time   => 250, # 제작 시간
  :earned_exp   => 5, # 얻을 경험치
  :crafted_item => [:i288, 1], # 성공시 아이템
  :failed_item  => [:i265, 1], # 실패시 아이템
  :ingredients  => [[:i286, 1], [:i225, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #보라색 작은 익은 고기, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 1, # 가게에서 만드는 경우 수수료
  :craft_time   => 450, # 제작 시간
  :earned_exp   => 5, # 얻을 경험치
  :crafted_item => [:i289, 1], # 성공시 아이템
  :failed_item  => [:i265, 1], # 실패시 아이템
  :ingredients  => [[:i287, 1], [:i225, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #녹색 익은 고기, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 1, # 가게에서 만드는 경우 수수료
  :craft_time   => 250, # 제작 시간
  :earned_exp   => 5, # 얻을 경험치
  :crafted_item => [:i292, 1], # 성공시 아이템
  :failed_item  => [:i265, 1], # 실패시 아이템
  :ingredients  => [[:i290, 1], [:i225, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #녹색 작은 익은 고기, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 1, # 가게에서 만드는 경우 수수료
  :craft_time   => 450, # 제작 시간
  :earned_exp   => 5, # 얻을 경험치
  :crafted_item => [:i293, 1], # 성공시 아이템
  :failed_item  => [:i265, 1], # 실패시 아이템
  :ingredients  => [[:i291, 1], [:i225, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #붕대, 제작 아이템
  :recipe_type  => 3, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 120, # 가게에서 만드는 경우 수수료
  :craft_time   => 220, # 제작 시간
  :earned_exp   => 30, # 얻을 경험치
  :crafted_item => [:i24, 10], # 성공시 아이템
  :failed_item  => [:i243, 1], # 실패시 아이템
  :ingredients  => [[:i174, 1], [:i242, 3], [:i243, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #밧줄, 제작 아이템
  :recipe_type  => 3, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 120, # 가게에서 만드는 경우 수수료
  :craft_time   => 220, # 제작 시간
  :earned_exp   => 30, # 얻을 경험치
  :crafted_item => [:i50, 10], # 성공시 아이템
  :failed_item  => [:i243, 1], # 실패시 아이템
  :ingredients  => [[:i242, 4], [:i243, 2],]}; ro_nb += 1
Recipes[ro_nb] = {  #치즈, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 1, # 가게에서 만드는 경우 수수료
  :craft_time   => 650, # 제작 시간
  :earned_exp   => 5, # 얻을 경험치
  :crafted_item => [:i205, 5], # 성공시 아이템
  :failed_item  => [:i36, 1], # 실패시 아이템
  :ingredients  => [[:i165, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #케이크, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 1, # 가게에서 만드는 경우 수수료
  :craft_time   => 350, # 제작 시간
  :earned_exp   => 5, # 얻을 경험치
  :crafted_item => [:i190, 2], # 성공시 아이템
  :failed_item  => [:i190, 1], # 실패시 아이템
  :ingredients  => [[:i224, 1], [:i227, 1], [:i223, 2],]}; ro_nb += 1
Recipes[ro_nb] = {  #초코 케이크, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 1, # 가게에서 만드는 경우 수수료
  :craft_time   => 350, # 제작 시간
  :earned_exp   => 5, # 얻을 경험치
  :crafted_item => [:i191, 5], # 성공시 아이템
  :failed_item  => [:i190, 1], # 실패시 아이템
  :ingredients  => [[:i190, 1], [:i206, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #초코 케이크, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 1, # 가게에서 만드는 경우 수수료
  :craft_time   => 350, # 제작 시간
  :earned_exp   => 5, # 얻을 경험치
  :crafted_item => [:i192, 5], # 성공시 아이템
  :failed_item  => [:i190, 1], # 실패시 아이템
  :ingredients  => [[:i190, 1], [:i206, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #딸기 케이크, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 1, # 가게에서 만드는 경우 수수료
  :craft_time   => 350, # 제작 시간
  :earned_exp   => 5, # 얻을 경험치
  :crafted_item => [:i193, 5], # 성공시 아이템
  :failed_item  => [:i190, 1], # 실패시 아이템
  :ingredients  => [[:i190, 1], [:i222, 2],]}; ro_nb += 1
Recipes[ro_nb] = {  #화살, 제작 아이템
  :recipe_type  => 3, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 120, # 가게에서 만드는 경우 수수료
  :craft_time   => 320, # 제작 시간
  :earned_exp   => 30, # 얻을 경험치
  :crafted_item => [:i19, 30], # 성공시 아이템
  :failed_item  => [:i19, 10], # 실패시 아이템
  :ingredients  => [[:i135, 3], [:i121, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #화살, 제작 아이템
  :recipe_type  => 3, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 120, # 가게에서 만드는 경우 수수료
  :craft_time   => 320, # 제작 시간
  :earned_exp   => 30, # 얻을 경험치
  :crafted_item => [:i19, 60], # 성공시 아이템
  :failed_item  => [:i19, 10], # 실패시 아이템
  :ingredients  => [[:i136, 1], [:i121, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #화살, 제작 아이템
  :recipe_type  => 3, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 4, # 레벨 조건
  :shop_fee     => 120, # 가게에서 만드는 경우 수수료
  :craft_time   => 320, # 제작 시간
  :earned_exp   => 30, # 얻을 경험치
  :crafted_item => [:i19, 80], # 성공시 아이템
  :failed_item  => [:i19, 10], # 실패시 아이템
  :ingredients  => [[:i135, 5], [:i121, 2],]}; ro_nb += 1
Recipes[ro_nb] = {  #화살, 제작 아이템
  :recipe_type  => 3, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 4, # 레벨 조건
  :shop_fee     => 120, # 가게에서 만드는 경우 수수료
  :craft_time   => 320, # 제작 시간
  :earned_exp   => 30, # 얻을 경험치
  :crafted_item => [:i19, 150], # 성공시 아이템
  :failed_item  => [:i19, 10], # 실패시 아이템
  :ingredients  => [[:i136, 2], [:i121, 2],]}; ro_nb += 1
Recipes[ro_nb] = {  #고기 꼬치, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 1, # 가게에서 만드는 경우 수수료
  :craft_time   => 250, # 제작 시간
  :earned_exp   => 3, # 얻을 경험치
  :crafted_item => [:i182, 2], # 성공시 아이템
  :failed_item  => [:i182, 1], # 실패시 아이템
  :ingredients  => [[:i228, 1], [:i225, 1], [:i226, 1], [:i160, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #고기 꼬치, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 1, # 가게에서 만드는 경우 수수료
  :craft_time   => 250, # 제작 시간
  :earned_exp   => 3, # 얻을 경험치
  :crafted_item => [:i182, 2], # 성공시 아이템
  :failed_item  => [:i182, 1], # 실패시 아이템
  :ingredients  => [[:i228, 1], [:i225, 1], [:i226, 1], [:i287, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #고기 꼬치, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 1, # 가게에서 만드는 경우 수수료
  :craft_time   => 250, # 제작 시간
  :earned_exp   => 3, # 얻을 경험치
  :crafted_item => [:i182, 2], # 성공시 아이템
  :failed_item  => [:i182, 1], # 실패시 아이템
  :ingredients  => [[:i228, 1], [:i225, 1], [:i226, 1], [:i291, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #소시지, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 1, # 가게에서 만드는 경우 수수료
  :craft_time   => 450, # 제작 시간
  :earned_exp   => 5, # 얻을 경험치
  :crafted_item => [:i185, 10], # 성공시 아이템
  :failed_item  => [:i185, 1], # 실패시 아이템
  :ingredients  => [[:i275, 1], [:i225, 1], [:i226, 1], [:i159, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #얼큰 고기 국, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 1, # 가게에서 만드는 경우 수수료
  :craft_time   => 450, # 제작 시간
  :earned_exp   => 5, # 얻을 경험치
  :crafted_item => [:i184, 5], # 성공시 아이템
  :failed_item  => [:i184, 1], # 실패시 아이템
  :ingredients  => [[:i60, 5], [:i228, 5], [:i225, 1], [:i226, 1], [:i155, 2], [:i159, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #고기 수프, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 1, # 가게에서 만드는 경우 수수료
  :craft_time   => 450, # 제작 시간
  :earned_exp   => 5, # 얻을 경험치
  :crafted_item => [:i186, 5], # 성공시 아이템
  :failed_item  => [:i186, 1], # 실패시 아이템
  :ingredients  => [[:i60, 2], [:i165, 2], [:i225, 1], [:i226, 1], [:i155, 1], [:i159, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #소시지, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 1, # 가게에서 만드는 경우 수수료
  :craft_time   => 450, # 제작 시간
  :earned_exp   => 5, # 얻을 경험치
  :crafted_item => [:i185, 10], # 성공시 아이템
  :failed_item  => [:i185, 1], # 실패시 아이템
  :ingredients  => [[:i275, 1], [:i225, 1], [:i226, 1], [:i286, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #얼큰 고기 국, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 1, # 가게에서 만드는 경우 수수료
  :craft_time   => 450, # 제작 시간
  :earned_exp   => 5, # 얻을 경험치
  :crafted_item => [:i184, 5], # 성공시 아이템
  :failed_item  => [:i184, 1], # 실패시 아이템
  :ingredients  => [[:i60, 5], [:i228, 5], [:i225, 1], [:i226, 1], [:i155, 2], [:i286, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #고기 수프, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 1, # 가게에서 만드는 경우 수수료
  :craft_time   => 450, # 제작 시간
  :earned_exp   => 5, # 얻을 경험치
  :crafted_item => [:i186, 5], # 성공시 아이템
  :failed_item  => [:i186, 1], # 실패시 아이템
  :ingredients  => [[:i60, 2], [:i165, 2], [:i225, 1], [:i226, 1], [:i155, 1], [:i286, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #소시지, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 1, # 가게에서 만드는 경우 수수료
  :craft_time   => 450, # 제작 시간
  :earned_exp   => 5, # 얻을 경험치
  :crafted_item => [:i185, 10], # 성공시 아이템
  :failed_item  => [:i185, 1], # 실패시 아이템
  :ingredients  => [[:i275, 1], [:i225, 1], [:i226, 1], [:i290, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #얼큰 고기 국, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 1, # 가게에서 만드는 경우 수수료
  :craft_time   => 450, # 제작 시간
  :earned_exp   => 5, # 얻을 경험치
  :crafted_item => [:i184, 5], # 성공시 아이템
  :failed_item  => [:i184, 1], # 실패시 아이템
  :ingredients  => [[:i60, 5], [:i228, 5], [:i225, 1], [:i226, 1], [:i155, 2], [:i290, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #고기 수프, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 1, # 가게에서 만드는 경우 수수료
  :craft_time   => 450, # 제작 시간
  :earned_exp   => 5, # 얻을 경험치
  :crafted_item => [:i186, 5], # 성공시 아이템
  :failed_item  => [:i186, 1], # 실패시 아이템
  :ingredients  => [[:i60, 2], [:i165, 2], [:i225, 1], [:i226, 1], [:i155, 1], [:i290, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #야채 수프, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 1, # 가게에서 만드는 경우 수수료
  :craft_time   => 450, # 제작 시간
  :earned_exp   => 5, # 얻을 경험치
  :crafted_item => [:i187, 5], # 성공시 아이템
  :failed_item  => [:i187, 1], # 실패시 아이템
  :ingredients  => [[:i60, 2], [:i214, 1], [:i225, 1], [:i226, 1], [:i155, 1], [:i215, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #크림 수프, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 1, # 가게에서 만드는 경우 수수료
  :craft_time   => 450, # 제작 시간
  :earned_exp   => 5, # 얻을 경험치
  :crafted_item => [:i188, 5], # 성공시 아이템
  :failed_item  => [:i188, 1], # 실패시 아이템
  :ingredients  => [[:i60, 2], [:i165, 5], [:i227, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #크림 수프, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 1, # 가게에서 만드는 경우 수수료
  :craft_time   => 450, # 제작 시간
  :earned_exp   => 5, # 얻을 경험치
  :crafted_item => [:i188, 5], # 성공시 아이템
  :failed_item  => [:i188, 1], # 실패시 아이템
  :ingredients  => [[:i60, 2], [:i65, 5], [:i227, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #곡괭이, 제작 아이템
  :recipe_type  => 3, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 120, # 가게에서 만드는 경우 수수료
  :craft_time   => 320, # 제작 시간
  :earned_exp   => 30, # 얻을 경험치
  :crafted_item => [:i37, 4], # 성공시 아이템
  :failed_item  => [:i136, 1], # 실패시 아이템
  :ingredients  => [[:i121, 2], [:i136, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #톱, 제작 아이템
  :recipe_type  => 3, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 120, # 가게에서 만드는 경우 수수료
  :craft_time   => 270, # 제작 시간
  :earned_exp   => 30, # 얻을 경험치
  :crafted_item => [:i38, 7], # 성공시 아이템
  :failed_item  => [:i136, 1], # 실패시 아이템
  :ingredients  => [[:i121, 2], [:i136, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #낫, 제작 아이템
  :recipe_type  => 3, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 120, # 가게에서 만드는 경우 수수료
  :craft_time   => 220, # 제작 시간
  :earned_exp   => 30, # 얻을 경험치
  :crafted_item => [:i39, 10], # 성공시 아이템
  :failed_item  => [:i136, 1], # 실패시 아이템
  :ingredients  => [[:i121, 2], [:i136, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #프라이팬, 제작 아이템
  :recipe_type  => 3, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 120, # 가게에서 만드는 경우 수수료
  :craft_time   => 320, # 제작 시간
  :earned_exp   => 30, # 얻을 경험치
  :crafted_item => [:i40, 4], # 성공시 아이템
  :failed_item  => [:i121, 1], # 실패시 아이템
  :ingredients  => [[:i121, 3], [:i126, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #핸드 액스, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 220, # 가게에서 만드는 경우 수수료
  :craft_time   => 220, # 제작 시간
  :earned_exp   => 10, # 얻을 경험치
  :crafted_item => [:w1, 1], # 성공시 아이템
  :failed_item  => [:i121, 2], # 실패시 아이템
  :ingredients  => [[:i136, 2], [:i121, 3],]}; ro_nb += 1
Recipes[ro_nb] = {  #전투 액스, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 220, # 가게에서 만드는 경우 수수료
  :craft_time   => 320, # 제작 시간
  :earned_exp   => 20, # 얻을 경험치
  :crafted_item => [:w2, 1], # 성공시 아이템
  :failed_item  => [:i121, 2], # 실패시 아이템
  :ingredients  => [[:i136, 2], [:i121, 5],]}; ro_nb += 1
Recipes[ro_nb] = {  #바르디슈, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 2, # 레벨 조건
  :shop_fee     => 220, # 가게에서 만드는 경우 수수료
  :craft_time   => 320, # 제작 시간
  :earned_exp   => 20, # 얻을 경험치
  :crafted_item => [:w3, 1], # 성공시 아이템
  :failed_item  => [:i121, 2], # 실패시 아이템
  :ingredients  => [[:i136, 3], [:i121, 6],]}; ro_nb += 1
Recipes[ro_nb] = {  #미스릴 액스, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 3, # 레벨 조건
  :shop_fee     => 220, # 가게에서 만드는 경우 수수료
  :craft_time   => 320, # 제작 시간
  :earned_exp   => 20, # 얻을 경험치
  :crafted_item => [:w4, 1], # 성공시 아이템
  :failed_item  => [:i121, 2], # 실패시 아이템
  :ingredients  => [[:i136, 3], [:i121, 6], [:i130, 2],]}; ro_nb += 1
Recipes[ro_nb] = {  #세스타스, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 220, # 가게에서 만드는 경우 수수료
  :craft_time   => 220, # 제작 시간
  :earned_exp   => 10, # 얻을 경험치
  :crafted_item => [:w7, 1], # 성공시 아이템
  :failed_item  => [:i121, 2], # 실패시 아이템
  :ingredients  => [[:i136, 2], [:i121, 3],]}; ro_nb += 1
Recipes[ro_nb] = {  #바그 나우, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 220, # 가게에서 만드는 경우 수수료
  :craft_time   => 260, # 제작 시간
  :earned_exp   => 16, # 얻을 경험치
  :crafted_item => [:w8, 1], # 성공시 아이템
  :failed_item  => [:i121, 4], # 실패시 아이템
  :ingredients  => [[:i125, 1], [:i121, 5],]}; ro_nb += 1
Recipes[ro_nb] = {  #아이언 크로우, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 2, # 레벨 조건
  :shop_fee     => 220, # 가게에서 만드는 경우 수수료
  :craft_time   => 260, # 제작 시간
  :earned_exp   => 16, # 얻을 경험치
  :crafted_item => [:w9, 1], # 성공시 아이템
  :failed_item  => [:i121, 4], # 실패시 아이템
  :ingredients  => [[:i125, 2], [:i121, 6],]}; ro_nb += 1
Recipes[ro_nb] = {  #미스릴 크로우, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 3, # 레벨 조건
  :shop_fee     => 220, # 가게에서 만드는 경우 수수료
  :craft_time   => 260, # 제작 시간
  :earned_exp   => 16, # 얻을 경험치
  :crafted_item => [:w10, 1], # 성공시 아이템
  :failed_item  => [:i121, 4], # 실패시 아이템
  :ingredients  => [[:i125, 2], [:i121, 6], [:i130, 2],]}; ro_nb += 1
Recipes[ro_nb] = {  #스피어, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 220, # 가게에서 만드는 경우 수수료
  :craft_time   => 220, # 제작 시간
  :earned_exp   => 10, # 얻을 경험치
  :crafted_item => [:w13, 1], # 성공시 아이템
  :failed_item  => [:i121, 1], # 실패시 아이템
  :ingredients  => [[:i136, 3], [:i121, 2],]}; ro_nb += 1
Recipes[ro_nb] = {  #파르티잔, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 220, # 가게에서 만드는 경우 수수료
  :craft_time   => 240, # 제작 시간
  :earned_exp   => 14, # 얻을 경험치
  :crafted_item => [:w14, 1], # 성공시 아이템
  :failed_item  => [:i121, 2], # 실패시 아이템
  :ingredients  => [[:i136, 3], [:i121, 3],]}; ro_nb += 1
Recipes[ro_nb] = {  #미늘창, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 2, # 레벨 조건
  :shop_fee     => 220, # 가게에서 만드는 경우 수수료
  :craft_time   => 240, # 제작 시간
  :earned_exp   => 14, # 얻을 경험치
  :crafted_item => [:w15, 1], # 성공시 아이템
  :failed_item  => [:i121, 2], # 실패시 아이템
  :ingredients  => [[:i136, 4], [:i121, 4],]}; ro_nb += 1
Recipes[ro_nb] = {  #미스릴 스피어, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 3, # 레벨 조건
  :shop_fee     => 220, # 가게에서 만드는 경우 수수료
  :craft_time   => 240, # 제작 시간
  :earned_exp   => 14, # 얻을 경험치
  :crafted_item => [:w16, 1], # 성공시 아이템
  :failed_item  => [:i121, 2], # 실패시 아이템
  :ingredients  => [[:i136, 4], [:i121, 4], [:i130, 2],]}; ro_nb += 1
Recipes[ro_nb] = {  #숏소드, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 220, # 가게에서 만드는 경우 수수료
  :craft_time   => 220, # 제작 시간
  :earned_exp   => 10, # 얻을 경험치
  :crafted_item => [:w19, 1], # 성공시 아이템
  :failed_item  => [:i121, 2], # 실패시 아이템
  :ingredients  => [[:i126, 3], [:i121, 3],]}; ro_nb += 1
Recipes[ro_nb] = {  #장검, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 230, # 가게에서 만드는 경우 수수료
  :craft_time   => 320, # 제작 시간
  :earned_exp   => 20, # 얻을 경험치
  :crafted_item => [:w20, 1], # 성공시 아이템
  :failed_item  => [:i121, 4], # 실패시 아이템
  :ingredients  => [[:i126, 4], [:i121, 5],]}; ro_nb += 1
Recipes[ro_nb] = {  #펄션, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 2, # 레벨 조건
  :shop_fee     => 230, # 가게에서 만드는 경우 수수료
  :craft_time   => 320, # 제작 시간
  :earned_exp   => 20, # 얻을 경험치
  :crafted_item => [:w21, 1], # 성공시 아이템
  :failed_item  => [:i121, 4], # 실패시 아이템
  :ingredients  => [[:i126, 5], [:i121, 6],]}; ro_nb += 1
Recipes[ro_nb] = {  #미스릴 소드, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 3, # 레벨 조건
  :shop_fee     => 230, # 가게에서 만드는 경우 수수료
  :craft_time   => 320, # 제작 시간
  :earned_exp   => 20, # 얻을 경험치
  :crafted_item => [:w22, 1], # 성공시 아이템
  :failed_item  => [:i121, 4], # 실패시 아이템
  :ingredients  => [[:i126, 5], [:i121, 6], [:i130, 2],]}; ro_nb += 1
Recipes[ro_nb] = {  #무명도, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 220, # 가게에서 만드는 경우 수수료
  :craft_time   => 220, # 제작 시간
  :earned_exp   => 10, # 얻을 경험치
  :crafted_item => [:w25, 1], # 성공시 아이템
  :failed_item  => [:i121, 3], # 실패시 아이템
  :ingredients  => [[:i126, 3], [:i121, 4],]}; ro_nb += 1
Recipes[ro_nb] = {  #참말도, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 250, # 가게에서 만드는 경우 수수료
  :craft_time   => 340, # 제작 시간
  :earned_exp   => 24, # 얻을 경험치
  :crafted_item => [:w26, 1], # 성공시 아이템
  :failed_item  => [:i121, 6], # 실패시 아이템
  :ingredients  => [[:i126, 4], [:i121, 7],]}; ro_nb += 1
Recipes[ro_nb] = {  #범 토오루, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 2, # 레벨 조건
  :shop_fee     => 250, # 가게에서 만드는 경우 수수료
  :craft_time   => 340, # 제작 시간
  :earned_exp   => 24, # 얻을 경험치
  :crafted_item => [:w27, 1], # 성공시 아이템
  :failed_item  => [:i121, 6], # 실패시 아이템
  :ingredients  => [[:i126, 5], [:i121, 8],]}; ro_nb += 1
Recipes[ro_nb] = {  #미스릴 칼, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 3, # 레벨 조건
  :shop_fee     => 250, # 가게에서 만드는 경우 수수료
  :craft_time   => 340, # 제작 시간
  :earned_exp   => 24, # 얻을 경험치
  :crafted_item => [:w28, 1], # 성공시 아이템
  :failed_item  => [:i121, 6], # 실패시 아이템
  :ingredients  => [[:i126, 5], [:i121, 8], [:i130, 2],]}; ro_nb += 1
Recipes[ro_nb] = {  #브레이브 타이푼, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 20, # 레벨 조건
  :shop_fee     => 1550, # 가게에서 만드는 경우 수수료
  :craft_time   => 740, # 제작 시간
  :earned_exp   => 124, # 얻을 경험치
  :crafted_item => [:w86, 1], # 성공시 아이템
  :failed_item  => [:i144, 1], # 실패시 아이템
  :ingredients  => [[:i144, 10], [:i473, 4], [:i145, 6], [:i141, 4], [:i126, 10],]}; ro_nb += 1
Recipes[ro_nb] = {  #숏보우, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 180, # 가게에서 만드는 경우 수수료
  :craft_time   => 220, # 제작 시간
  :earned_exp   => 14, # 얻을 경험치
  :crafted_item => [:w31, 1], # 성공시 아이템
  :failed_item  => [:i136, 1], # 실패시 아이템
  :ingredients  => [[:i136, 2], [:i263, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #장궁, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 180, # 가게에서 만드는 경우 수수료
  :craft_time   => 220, # 제작 시간
  :earned_exp   => 18, # 얻을 경험치
  :crafted_item => [:w32, 1], # 성공시 아이템
  :failed_item  => [:i136, 2], # 실패시 아이템
  :ingredients  => [[:i136, 3], [:i263, 3],]}; ro_nb += 1
Recipes[ro_nb] = {  #크로스 보우, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 2, # 레벨 조건
  :shop_fee     => 180, # 가게에서 만드는 경우 수수료
  :craft_time   => 220, # 제작 시간
  :earned_exp   => 18, # 얻을 경험치
  :crafted_item => [:w33, 1], # 성공시 아이템
  :failed_item  => [:i136, 2], # 실패시 아이템
  :ingredients  => [[:i136, 4], [:i263, 4],]}; ro_nb += 1
Recipes[ro_nb] = {  #미스릴 보우, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 3, # 레벨 조건
  :shop_fee     => 180, # 가게에서 만드는 경우 수수료
  :craft_time   => 220, # 제작 시간
  :earned_exp   => 18, # 얻을 경험치
  :crafted_item => [:w34, 1], # 성공시 아이템
  :failed_item  => [:i136, 2], # 실패시 아이템
  :ingredients  => [[:i136, 4], [:i263, 4], [:i130, 2],]}; ro_nb += 1
Recipes[ro_nb] = {  #단검, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 220, # 가게에서 만드는 경우 수수료
  :craft_time   => 170, # 제작 시간
  :earned_exp   => 8, # 얻을 경험치
  :crafted_item => [:w37, 1], # 성공시 아이템
  :failed_item  => [:i121, 1], # 실패시 아이템
  :ingredients  => [[:i126, 2], [:i121, 2],]}; ro_nb += 1
Recipes[ro_nb] = {  #단도, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 220, # 가게에서 만드는 경우 수수료
  :craft_time   => 180, # 제작 시간
  :earned_exp   => 9, # 얻을 경험치
  :crafted_item => [:w38, 1], # 성공시 아이템
  :failed_item  => [:i121, 2], # 실패시 아이템
  :ingredients  => [[:i126, 2], [:i121, 3],]}; ro_nb += 1
Recipes[ro_nb] = {  #망고슈, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 2, # 레벨 조건
  :shop_fee     => 220, # 가게에서 만드는 경우 수수료
  :craft_time   => 180, # 제작 시간
  :earned_exp   => 9, # 얻을 경험치
  :crafted_item => [:w39, 1], # 성공시 아이템
  :failed_item  => [:i121, 2], # 실패시 아이템
  :ingredients  => [[:i126, 3], [:i121, 4],]}; ro_nb += 1
Recipes[ro_nb] = {  #미스릴 나이프, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 3, # 레벨 조건
  :shop_fee     => 220, # 가게에서 만드는 경우 수수료
  :craft_time   => 180, # 제작 시간
  :earned_exp   => 9, # 얻을 경험치
  :crafted_item => [:w40, 1], # 성공시 아이템
  :failed_item  => [:i121, 2], # 실패시 아이템
  :ingredients  => [[:i126, 3], [:i121, 4], [:i130, 2],]}; ro_nb += 1
Recipes[ro_nb] = {  #메이스, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 180, # 가게에서 만드는 경우 수수료
  :craft_time   => 150, # 제작 시간
  :earned_exp   => 10, # 얻을 경험치
  :crafted_item => [:w43, 1], # 성공시 아이템
  :failed_item  => [:i136, 3], # 실패시 아이템
  :ingredients  => [[:i136, 4], [:i243, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #도리깨, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 180, # 가게에서 만드는 경우 수수료
  :craft_time   => 170, # 제작 시간
  :earned_exp   => 14, # 얻을 경험치
  :crafted_item => [:w44, 1], # 성공시 아이템
  :failed_item  => [:i136, 3], # 실패시 아이템
  :ingredients  => [[:i136, 4], [:i243, 1], [:i250, 2],]}; ro_nb += 1
Recipes[ro_nb] = {  #워해머, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 2, # 레벨 조건
  :shop_fee     => 180, # 가게에서 만드는 경우 수수료
  :craft_time   => 170, # 제작 시간
  :earned_exp   => 14, # 얻을 경험치
  :crafted_item => [:w45, 1], # 성공시 아이템
  :failed_item  => [:i136, 3], # 실패시 아이템
  :ingredients  => [[:i136, 5], [:i243, 2], [:i250, 3],]}; ro_nb += 1
Recipes[ro_nb] = {  #미스릴 메이스, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 3, # 레벨 조건
  :shop_fee     => 180, # 가게에서 만드는 경우 수수료
  :craft_time   => 170, # 제작 시간
  :earned_exp   => 14, # 얻을 경험치
  :crafted_item => [:w46, 1], # 성공시 아이템
  :failed_item  => [:i136, 3], # 실패시 아이템
  :ingredients  => [[:i136, 5], [:i243, 2], [:i250, 3], [:i130, 2],]}; ro_nb += 1
Recipes[ro_nb] = {  #타이탄 메이스, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 20, # 레벨 조건
  :shop_fee     => 2250, # 가게에서 만드는 경우 수수료
  :craft_time   => 770, # 제작 시간
  :earned_exp   => 144, # 얻을 경험치
  :crafted_item => [:w94, 1], # 성공시 아이템
  :failed_item  => [:i145, 1], # 실패시 아이템
  :ingredients  => [[:i145, 5], [:i141, 5], [:i473, 2], [:i462, 30],]}; ro_nb += 1
Recipes[ro_nb] = {  #우드 스태프, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 170, # 가게에서 만드는 경우 수수료
  :craft_time   => 160, # 제작 시간
  :earned_exp   => 8, # 얻을 경험치
  :crafted_item => [:w49, 1], # 성공시 아이템
  :failed_item  => [:i136, 2], # 실패시 아이템
  :ingredients  => [[:i136, 3], [:i124, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #보석 스태프, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 170, # 가게에서 만드는 경우 수수료
  :craft_time   => 190, # 제작 시간
  :earned_exp   => 13, # 얻을 경험치
  :crafted_item => [:w50, 1], # 성공시 아이템
  :failed_item  => [:i136, 2], # 실패시 아이템
  :ingredients  => [[:i136, 3], [:i124, 2], [:i6, 2],]}; ro_nb += 1
Recipes[ro_nb] = {  #포스 스태프, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 2, # 레벨 조건
  :shop_fee     => 170, # 가게에서 만드는 경우 수수료
  :craft_time   => 190, # 제작 시간
  :earned_exp   => 13, # 얻을 경험치
  :crafted_item => [:w51, 1], # 성공시 아이템
  :failed_item  => [:i136, 2], # 실패시 아이템
  :ingredients  => [[:i136, 4], [:i124, 3], [:i6, 3],]}; ro_nb += 1
Recipes[ro_nb] = {  #미스릴 스태프, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 3, # 레벨 조건
  :shop_fee     => 170, # 가게에서 만드는 경우 수수료
  :craft_time   => 190, # 제작 시간
  :earned_exp   => 13, # 얻을 경험치
  :crafted_item => [:w52, 1], # 성공시 아이템
  :failed_item  => [:i136, 2], # 실패시 아이템
  :ingredients  => [[:i136, 4], [:i124, 3], [:i6, 3], [:i130, 2],]}; ro_nb += 1
Recipes[ro_nb] = {  #갈고리, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 220, # 가게에서 만드는 경우 수수료
  :craft_time   => 120, # 제작 시간
  :earned_exp   => 4, # 얻을 경험치
  :crafted_item => [:w120, 1], # 성공시 아이템
  :failed_item  => [:i121, 2], # 실패시 아이템
  :ingredients  => [[:i121, 5], [:i50, 7],]}; ro_nb += 1
Recipes[ro_nb] = {  #목함 지뢰, 제작 아이템
  :recipe_type  => 3, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 3, # 레벨 조건
  :shop_fee     => 250, # 가게에서 만드는 경우 수수료
  :craft_time   => 220, # 제작 시간
  :earned_exp   => 22, # 얻을 경험치
  :crafted_item => [:i31, 1], # 성공시 아이템
  :failed_item  => [:i265, 3], # 실패시 아이템
  :ingredients  => [[:i265, 5], [:i120, 2], [:i76, 1], [:i78, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #덫, 제작 아이템
  :recipe_type  => 3, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 2, # 레벨 조건
  :shop_fee     => 50, # 가게에서 만드는 경우 수수료
  :craft_time   => 120, # 제작 시간
  :earned_exp   => 10, # 얻을 경험치
  :crafted_item => [:i30, 2], # 성공시 아이템
  :failed_item  => [:i121, 1], # 실패시 아이템
  :ingredients  => [[:i121, 4], [:i263, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #금덩어리, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 2, # 가게에서 만드는 경우 수수료
  :craft_time   => 50, # 제작 시간
  :earned_exp   => 3, # 얻을 경험치
  :crafted_item => [:i123, 1], # 성공시 아이템
  :failed_item  => [:i116, 1], # 실패시 아이템
  :ingredients  => [[:i116, 11],]}; ro_nb += 1
Recipes[ro_nb] = {  #루비, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 2, # 가게에서 만드는 경우 수수료
  :craft_time   => 50, # 제작 시간
  :earned_exp   => 5, # 얻을 경험치
  :crafted_item => [:i142, 1], # 성공시 아이템
  :failed_item  => [:i117, 1], # 실패시 아이템
  :ingredients  => [[:i117, 11], [:i131, 4],]}; ro_nb += 1
Recipes[ro_nb] = {  #지르코늄, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 2, # 가게에서 만드는 경우 수수료
  :craft_time   => 50, # 제작 시간
  :earned_exp   => 5, # 얻을 경험치
  :crafted_item => [:i141, 1], # 성공시 아이템
  :failed_item  => [:i118, 1], # 실패시 아이템
  :ingredients  => [[:i118, 11], [:i131, 4],]}; ro_nb += 1
Recipes[ro_nb] = {  #사파이어, 제작 아이템
  :recipe_type  => 2, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 2, # 가게에서 만드는 경우 수수료
  :craft_time   => 50, # 제작 시간
  :earned_exp   => 5, # 얻을 경험치
  :crafted_item => [:i138, 1], # 성공시 아이템
  :failed_item  => [:i119, 1], # 실패시 아이템
  :ingredients  => [[:i119, 11], [:i131, 4],]}; ro_nb += 1
Recipes[ro_nb] = {  #햄버거, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 1, # 가게에서 만드는 경우 수수료
  :craft_time   => 350, # 제작 시간
  :earned_exp   => 4, # 얻을 경험치
  :crafted_item => [:i204, 3], # 성공시 아이템
  :failed_item  => [:i197, 1], # 실패시 아이템
  :ingredients  => [[:i197, 2], [:i214, 1], [:i205, 1], [:i162, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #마늘빵, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 1, # 가게에서 만드는 경우 수수료
  :craft_time   => 320, # 제작 시간
  :earned_exp   => 4, # 얻을 경험치
  :crafted_item => [:i208, 3], # 성공시 아이템
  :failed_item  => [:i203, 1], # 실패시 아이템
  :ingredients  => [[:i203, 2], [:i226, 1], [:i66, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #콘치즈, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 1, # 레벨 조건
  :shop_fee     => 1, # 가게에서 만드는 경우 수수료
  :craft_time   => 320, # 제작 시간
  :earned_exp   => 4, # 얻을 경험치
  :crafted_item => [:i209, 2], # 성공시 아이템
  :failed_item  => [:i221, 1], # 실패시 아이템
  :ingredients  => [[:i221, 2], [:i225, 1], [:i205, 3],]}; ro_nb += 1
Recipes[ro_nb] = {  #천, 제작 아이템
  :recipe_type  => 3, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 3, # 레벨 조건
  :shop_fee     => 150, # 가게에서 만드는 경우 수수료
  :craft_time   => 420, # 제작 시간
  :earned_exp   => 22, # 얻을 경험치
  :crafted_item => [:i244, 1], # 성공시 아이템
  :failed_item  => [:i243, 1], # 실패시 아이템
  :ingredients  => [[:i243, 9], [:i242, 10],]}; ro_nb += 1
Recipes[ro_nb] = {  #실타래, 제작 아이템
  :recipe_type  => 3, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 2, # 레벨 조건
  :shop_fee     => 150, # 가게에서 만드는 경우 수수료
  :craft_time   => 420, # 제작 시간
  :earned_exp   => 12, # 얻을 경험치
  :crafted_item => [:i242, 1], # 성공시 아이템
  :failed_item  => [:i241, 1], # 실패시 아이템
  :ingredients  => [[:i241, 11],]}; ro_nb += 1
Recipes[ro_nb] = {  #락픽, 제작 아이템
  :recipe_type  => 3, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 3, # 레벨 조건
  :shop_fee     => 50, # 가게에서 만드는 경우 수수료
  :craft_time   => 230, # 제작 시간
  :earned_exp   => 10, # 얻을 경험치
  :crafted_item => [:i49, 1], # 성공시 아이템
  :failed_item  => [:i121, 1], # 실패시 아이템
  :ingredients  => [[:i121, 1], [:i135, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #붕어 조림, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 3, # 레벨 조건
  :shop_fee     => 10, # 가게에서 만드는 경우 수수료
  :craft_time   => 300, # 제작 시간
  :earned_exp   => 4, # 얻을 경험치
  :crafted_item => [:i356, 1], # 성공시 아이템
  :failed_item  => [:i225, 1], # 실패시 아이템
  :ingredients  => [[:i497, 1], [:i225, 1], [:i226, 1], [:i228, 1], [:i155, 1], [:i60, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #숭어 조림, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 3, # 레벨 조건
  :shop_fee     => 10, # 가게에서 만드는 경우 수수료
  :craft_time   => 300, # 제작 시간
  :earned_exp   => 4, # 얻을 경험치
  :crafted_item => [:i357, 1], # 성공시 아이템
  :failed_item  => [:i225, 1], # 실패시 아이템
  :ingredients  => [[:i498, 1], [:i225, 1], [:i226, 1], [:i228, 1], [:i155, 1], [:i60, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #잉어 조림, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 3, # 레벨 조건
  :shop_fee     => 10, # 가게에서 만드는 경우 수수료
  :craft_time   => 300, # 제작 시간
  :earned_exp   => 4, # 얻을 경험치
  :crafted_item => [:i358, 1], # 성공시 아이템
  :failed_item  => [:i225, 1], # 실패시 아이템
  :ingredients  => [[:i499, 1], [:i225, 1], [:i226, 1], [:i228, 1], [:i155, 1], [:i60, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #잉어 조림, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 3, # 레벨 조건
  :shop_fee     => 10, # 가게에서 만드는 경우 수수료
  :craft_time   => 300, # 제작 시간
  :earned_exp   => 4, # 얻을 경험치
  :crafted_item => [:i358, 1], # 성공시 아이템
  :failed_item  => [:i225, 1], # 실패시 아이템
  :ingredients  => [[:i500, 1], [:i225, 1], [:i226, 1], [:i228, 1], [:i155, 1], [:i60, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #잉어 조림, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 3, # 레벨 조건
  :shop_fee     => 10, # 가게에서 만드는 경우 수수료
  :craft_time   => 300, # 제작 시간
  :earned_exp   => 4, # 얻을 경험치
  :crafted_item => [:i358, 1], # 성공시 아이템
  :failed_item  => [:i225, 1], # 실패시 아이템
  :ingredients  => [[:i501, 1], [:i225, 1], [:i226, 1], [:i228, 1], [:i155, 1], [:i60, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #잉어 조림, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 3, # 레벨 조건
  :shop_fee     => 10, # 가게에서 만드는 경우 수수료
  :craft_time   => 300, # 제작 시간
  :earned_exp   => 4, # 얻을 경험치
  :crafted_item => [:i358, 1], # 성공시 아이템
  :failed_item  => [:i225, 1], # 실패시 아이템
  :ingredients  => [[:i502, 1], [:i225, 1], [:i226, 1], [:i228, 1], [:i155, 1], [:i60, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #잉어 조림, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 3, # 레벨 조건
  :shop_fee     => 10, # 가게에서 만드는 경우 수수료
  :craft_time   => 300, # 제작 시간
  :earned_exp   => 4, # 얻을 경험치
  :crafted_item => [:i358, 1], # 성공시 아이템
  :failed_item  => [:i225, 1], # 실패시 아이템
  :ingredients  => [[:i503, 1], [:i225, 1], [:i226, 1], [:i228, 1], [:i155, 1], [:i60, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #잉어 조림, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 3, # 레벨 조건
  :shop_fee     => 10, # 가게에서 만드는 경우 수수료
  :craft_time   => 300, # 제작 시간
  :earned_exp   => 4, # 얻을 경험치
  :crafted_item => [:i358, 1], # 성공시 아이템
  :failed_item  => [:i225, 1], # 실패시 아이템
  :ingredients  => [[:i504, 1], [:i225, 1], [:i226, 1], [:i228, 1], [:i155, 1], [:i60, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #향어 조림, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 3, # 레벨 조건
  :shop_fee     => 10, # 가게에서 만드는 경우 수수료
  :craft_time   => 300, # 제작 시간
  :earned_exp   => 4, # 얻을 경험치
  :crafted_item => [:i359, 1], # 성공시 아이템
  :failed_item  => [:i225, 1], # 실패시 아이템
  :ingredients  => [[:i505, 1], [:i225, 1], [:i226, 1], [:i228, 1], [:i155, 1], [:i60, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #가물치 조림, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 3, # 레벨 조건
  :shop_fee     => 10, # 가게에서 만드는 경우 수수료
  :craft_time   => 300, # 제작 시간
  :earned_exp   => 4, # 얻을 경험치
  :crafted_item => [:i360, 1], # 성공시 아이템
  :failed_item  => [:i225, 1], # 실패시 아이템
  :ingredients  => [[:i506, 1], [:i225, 1], [:i226, 1], [:i228, 1], [:i155, 1], [:i60, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #붕어 구이, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 2, # 레벨 조건
  :shop_fee     => 5, # 가게에서 만드는 경우 수수료
  :craft_time   => 100, # 제작 시간
  :earned_exp   => 2, # 얻을 경험치
  :crafted_item => [:i361, 1], # 성공시 아이템
  :failed_item  => [:i225, 1], # 실패시 아이템
  :ingredients  => [[:i497, 1], [:i225, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #숭어 구이, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 2, # 레벨 조건
  :shop_fee     => 5, # 가게에서 만드는 경우 수수료
  :craft_time   => 100, # 제작 시간
  :earned_exp   => 2, # 얻을 경험치
  :crafted_item => [:i362, 1], # 성공시 아이템
  :failed_item  => [:i225, 1], # 실패시 아이템
  :ingredients  => [[:i498, 1], [:i225, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #잉어 구이, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 2, # 레벨 조건
  :shop_fee     => 5, # 가게에서 만드는 경우 수수료
  :craft_time   => 100, # 제작 시간
  :earned_exp   => 2, # 얻을 경험치
  :crafted_item => [:i363, 1], # 성공시 아이템
  :failed_item  => [:i225, 1], # 실패시 아이템
  :ingredients  => [[:i499, 1], [:i225, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #잉어 구이, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 2, # 레벨 조건
  :shop_fee     => 5, # 가게에서 만드는 경우 수수료
  :craft_time   => 100, # 제작 시간
  :earned_exp   => 2, # 얻을 경험치
  :crafted_item => [:i363, 1], # 성공시 아이템
  :failed_item  => [:i225, 1], # 실패시 아이템
  :ingredients  => [[:i500, 1], [:i225, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #잉어 구이, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 2, # 레벨 조건
  :shop_fee     => 5, # 가게에서 만드는 경우 수수료
  :craft_time   => 100, # 제작 시간
  :earned_exp   => 2, # 얻을 경험치
  :crafted_item => [:i363, 1], # 성공시 아이템
  :failed_item  => [:i225, 1], # 실패시 아이템
  :ingredients  => [[:i501, 1], [:i225, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #잉어 구이, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 2, # 레벨 조건
  :shop_fee     => 5, # 가게에서 만드는 경우 수수료
  :craft_time   => 100, # 제작 시간
  :earned_exp   => 2, # 얻을 경험치
  :crafted_item => [:i363, 1], # 성공시 아이템
  :failed_item  => [:i225, 1], # 실패시 아이템
  :ingredients  => [[:i502, 1], [:i225, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #잉어 구이, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 2, # 레벨 조건
  :shop_fee     => 5, # 가게에서 만드는 경우 수수료
  :craft_time   => 100, # 제작 시간
  :earned_exp   => 2, # 얻을 경험치
  :crafted_item => [:i363, 1], # 성공시 아이템
  :failed_item  => [:i225, 1], # 실패시 아이템
  :ingredients  => [[:i503, 1], [:i225, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #잉어 구이, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 2, # 레벨 조건
  :shop_fee     => 5, # 가게에서 만드는 경우 수수료
  :craft_time   => 100, # 제작 시간
  :earned_exp   => 2, # 얻을 경험치
  :crafted_item => [:i363, 1], # 성공시 아이템
  :failed_item  => [:i225, 1], # 실패시 아이템
  :ingredients  => [[:i504, 1], [:i225, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #향어 구이, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 2, # 레벨 조건
  :shop_fee     => 5, # 가게에서 만드는 경우 수수료
  :craft_time   => 100, # 제작 시간
  :earned_exp   => 2, # 얻을 경험치
  :crafted_item => [:i364, 1], # 성공시 아이템
  :failed_item  => [:i225, 1], # 실패시 아이템
  :ingredients  => [[:i505, 1], [:i225, 1],]}; ro_nb += 1
Recipes[ro_nb] = {  #가물치 구이, 제작 아이템
  :recipe_type  => 4, # 타입 : 1 연금술사, 2 대장장이, 3 수세공, 4 요리사
  :auto_learn   => true, # 레시피 자동 학습 여부
  :req_level    => 2, # 레벨 조건
  :shop_fee     => 5, # 가게에서 만드는 경우 수수료
  :craft_time   => 100, # 제작 시간
  :earned_exp   => 2, # 얻을 경험치
  :crafted_item => [:i365, 1], # 성공시 아이템
  :failed_item  => [:i225, 1], # 실패시 아이템
  :ingredients  => [[:i506, 1], [:i225, 1],]}; ro_nb += 1

#===============================================================================
# ■ Notetag settings. Skip edits here unless you know what you're doing
#===============================================================================
end; end
module Venka::Notetag
  Tool = /<(?:TOOL|tool)>/i
end