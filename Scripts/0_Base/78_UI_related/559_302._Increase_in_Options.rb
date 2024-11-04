# encoding: utf-8
# Name: 302. Increase in Options
# Size: 18530
# encoding: utf-8
# Name: 302.선택지 증가
# Size: 19003
#======================================================================#
# MultiChoice
#-----------------------------------------------------------------------
# 사용 예 :
#
# mc_data.clear # 생략 가능 - 생략할 경우 마지막 선택지 재실행
#
# # mc_data.add("보여질 이름", 반환값, 설명) 형식으로 추가해주기
# mc_data.add("name1", 1, "1번항목 설명")
# mc_data.add("name2", :2, "2번항목 설명")
# mc_data.add("name3", "3", "3번항목 설명")
#
# # 아래 옵션은 생략가능 - 생략할 경우 기본값 사용
# mc_data.title = nil     # 타이틀 사용 안함
# mc_data.title = "타이틀" # 타이틀 고정문자 표시
# mc_data.title = :desc   # 설정한 항목설명 표시
# mc_data.title = "\\c[3]  \\i[3870] 101호 방"
# mc_data.row = 5
# mc_data.alig = 1
# mc_data.line = 5
# mc_data.column = 2
# mc_data.width = 320
# mc_data.cancel = -10
# mc_data.pos = [100,100]
# mc_data.time = 300
# mc_data.timeout = -20
# mc_data.var = 5
#
# mc_call
#
# mc_result #=> 마지막 선택지 실행한 결과값을 얻는다.
#
#======================================================================#
module LuD::MultiChoice
  DATA = {}
  #---------------------------------------------------------------------
  # 기본값 설정
  # mc_data.option = value
  #---------------------------------------------------------------------
  DATA[:ROW] = 0              # 최소 라인 : 0일경우 알아서 판단
  DATA[:ALIG] = 0             # 문장 위치
  DATA[:IF_ITEM] = 0          # 필요한 아이템
  DATA[:LINE] = 15            # 최대로 보여질 라인
  DATA[:COLUMN] = 2           # 최대 가로항목 크기
  DATA[:WIDTH] = 320          # 선택지 넓이
  DATA[:CANCEL_RESULT] = 50   # 취소할 경우 반환값
  DATA[:DEFAULT_TITLE] = "\\c[3]  \\i[3870] Por favor seleccione una opción."
  DATA[:POSITION] = []        # 기본 위치 : 빈 배열일 경우 화면 중앙
  DATA[:TIME_OUT] = 0         # 제한시간(프레임) : 0일경우 선택 대기
  DATA[:TIME_RESULT] = -2     # 시간초과일 경우 반환값
  DATA[:VARIABLE_ID] = 62     # 결과를 저장할 변수ID : 0일경우 사용안함
  #---------------------------------------------------------------------
  # 여기까지 설정
  #---------------------------------------------------------------------
end

#======================================================================#
# 내부 데이터 클래스, 함수 정의
#======================================================================#
module LuD::MultiChoice
  #---------------------------------------------------------------------
  class MC_Data
    #-------------------------------------------------------------------
    attr_accessor :index
    attr_accessor :title
    attr_accessor :row
    attr_accessor :alig
    attr_accessor :line
    attr_accessor :column
    attr_accessor :width
    attr_accessor :cancel
    attr_accessor :pos
    attr_accessor :time
    attr_accessor :timeout
    attr_accessor :var
    attr_accessor :result
    #-------------------------------------------------------------------
    def initialize
      clear
    end
    #-------------------------------------------------------------------
    def clear
      #print("103.선택지 증가 - 초기화 \n")
      clear_data
      clear_option
    end
    #-------------------------------------------------------------------
    def clear_data
      reset_data
      @data = []
    end
    #-------------------------------------------------------------------
    def clear_option
      @title = DATA[:DEFAULT_TITLE]
      @row = DATA[:ROW]
      @alig = DATA[:ALIG]
      @line = DATA[:LINE]
      @column = DATA[:COLUMN]
      @width = DATA[:WIDTH]
      @cancel = DATA[:CANCEL_RESULT]
      @pos = DATA[:POSITION]
      @time = DATA[:TIME_OUT]
      @timeout = DATA[:TIME_RESULT]
      @var = DATA[:VARIABLE_ID]
    end
    #-------------------------------------------------------------------
    def reset_data
      @index = 0
      @result = DATA[:CANCEL_RESULT]
    end
    #-------------------------------------------------------------------
    def ready?
      size > 0
    end
    #-------------------------------------------------------------------
    # 아이템 추가: (아이템 이름, 반환값)
    #-------------------------------------------------------------------
    def add(item, result = nil, if_item = nil, description = "")
      result = @data.size + 1 if result.nil?
      @data.push([item, result, if_item, description])
    end
    #-------------------------------------------------------------------
    def [](index, type = :data)
      case type
      when 1, 're', 'result', :re, :result
        @data[index][1]
      when 2, 'desc', 'description', :desc, :description
        @data[index][2].to_s || ""
      else
        @data[index][0]
      end
    end
    #-------------------------------------------------------------------
    def size
      @data.size
    end
  end
end

#======================================================================#
# 내부 윈도우 클래스, 함수 정의
#======================================================================#
module LuD::MultiChoice
  #---------------------------------------------------------------------
  # 타이틀 윈도우
  #---------------------------------------------------------------------
  class Window_MultiChoiceTitle < Window_Base
    #-------------------------------------------------------------------
    def initialize(text)
      super(0, 0, window_width, fitting_height(1))
      set_text(text)
      self.visible = use?
    end
    #-------------------------------------------------------------------
    def window_width
      return $game_temp.mc_data.width + 50
    end
    #-------------------------------------------------------------------
    def set_text(value)
      unless @text == value
        @text = value
        refresh
      end
    end
    #-------------------------------------------------------------------
    def refresh
      contents.clear
      return unless @text
      draw_text_ex(0,0,@text)
    end
    #-------------------------------------------------------------------
    def use?
      return !@text.nil?
    end
  end

  #---------------------------------------------------------------------
  # 선택지 윈도우
  #---------------------------------------------------------------------
  class Window_MultiChoice < Window_Command
    #-------------------------------------------------------------------
    # * 공개 인스턴스 변수
    #-------------------------------------------------------------------
    attr_reader   :tex_it
    attr_reader   :tex_itn
    attr_reader   :item_ro_n2
    #-------------------------------------------------------------------
    def window_width
      return $game_temp.mc_data.width + 50
    end
    #-------------------------------------------------------------------
    def visible_line_number
      ln = (item_max + (col_max - 1)) / col_max
      ln_min = $game_temp.mc_data.row
      ln_max = $game_temp.mc_data.line
      return [[ln, ln_max].min, ln_min].max
    end
    #-------------------------------------------------------------------
    def col_max
      return [item_max, $game_temp.mc_data.column].min
    end
    #-------------------------------------------------------------------
    def item_max
      $game_temp.mc_data.size
    end
    #-------------------------------------------------------------------
    def make_command_list
      for i in 0...$game_temp.mc_data.size
        add_command($game_temp.mc_data[i], i.to_s.to_sym)
      end
    end
    #-------------------------------------------------------------------
    def draw_item(index)
      # 해상도 수정
      if Graphics.height == 704 or Graphics.height == 640
        ro_ry = 1
        contents.font.size = 22
      else
        ro_ry = 0
        contents.font.size = 20
      end
      r = item_rect_for_text(index)
      
      # 아이템 조건
      @tex_itn = []
      @tex_itn = $game_temp.mc_data[index,:description].split("*")
      if @tex_itn[1] == nil
        @item_ro_n2 = $game_temp.mc_data[index,:description].to_i
        @tex_itn[1] = 1
      else
        @item_ro_n2 = @tex_itn[0].to_i
      end
      
      change_color(normal_color)
      contents.font.color.alpha = 255
      @tex_it = []
      @tex_it = $game_temp.mc_data[index,:description].split(".")
      if @tex_it[1] != nil
        change_color(text_color(10))
        contents.font.color.alpha = 160
        iv = @tex_it[0].to_i
        #print("103.선택지 증가 - %s, %s \n" % [iv, @tex_it[1].to_s]);
        if $game_variables[iv] >= @tex_it[1].to_i
          change_color(normal_color)
          contents.font.color.alpha = 255
        end
      else
        if @item_ro_n2 != 0
          if @tex_itn[1].to_i != nil and @tex_itn[1].to_i != 0
            if @tex_itn[1].to_i > $game_party.item_number($data_items[@item_ro_n2])
              change_color(text_color(10))
              contents.font.color.alpha = 160
            else
              change_color(normal_color)
              contents.font.color.alpha = 255
            end
          else
            if 1 > $game_party.item_number($data_items[@item_ro_n2])
              change_color(text_color(10))
              contents.font.color.alpha = 160
            else
              change_color(normal_color)
              contents.font.color.alpha = 255
            end
          end
        end
      end
      if $game_temp.mc_data.alig == -1
        draw_text_ex(r.x, r.y - ro_ry, $game_temp.mc_data[index])
      else
        text = convert_escape_characters($game_temp.mc_data[index])
        draw_text(r.x - 9, r.y - ro_ry, window_width / col_max, line_height, text, 1)
        #draw_text(r.x - 9, r.y - ro_ry, window_width / col_max, line_height, $game_temp.mc_data[index], 1)
      end
    end
  end
end
#======================================================================#
# 내부 씬 클래스, 함수 정의
#======================================================================#
module LuD::MultiChoice
  class Scene_MultiChoice < Scene_MenuBase
    #-------------------------------------------------------------------
    # * 공개 인스턴스 변수
    #-------------------------------------------------------------------
    attr_reader   :tex_it
    attr_reader   :tex_itn
    attr_reader   :item_ro_n2
    #-------------------------------------------------------------------
    def start
      super
      create_windows
      $game_temp.mc_data.reset_data
      @timer = 0
      @ro_cancel = 0
    end
    #-------------------------------------------------------------------
    #def create_background
    #  @background_sprite = Sprite.new
    #  @background_sprite.bitmap = SceneManager.background_bitmap
      # 수정 실험 추가
      #@background_sprite.color.set(16, 16, 16, 128)
    #end
    #-------------------------------------------------------------------
    def create_windows
      create_choice_window
      create_title_window
      update_placement
    end
    #
    def create_choice_window
      @choice_window = Window_MultiChoice.new(0,0)
      for i in 0...$game_temp.mc_data.size
        @choice_window.set_handler(i.to_s.to_sym, method(:command_ok))
        #print("302.선택지 증가 - %s \n" % [$game_temp.mc_data[i]])
        if $game_temp.mc_data[i] == "취소한다."
          @ro_cancel = 1
        end
      end
      # 취소 기능 제거, 다시 추가
      if @ro_cancel == 1
        @choice_window.set_handler(:cancel, method(:command_cancel))
      end
    end
    #
    def create_title_window
      @title_window = Window_MultiChoiceTitle.new($game_temp.mc_data.title)
    end
    #-------------------------------------------------------------------
    def update_placement
      x = Graphics.width/2 - window_width/2
      y = Graphics.height/2 - window_height/2
      unless $game_temp.mc_data.pos.empty?
        x = $game_temp.mc_data.pos[0]
        y = $game_temp.mc_data.pos[1]
      end
      @title_window.x = @choice_window.x = x
      @choice_window.y = y
      if @title_window.use?
        @title_window.y = y
        @choice_window.y += @title_window.height
      end
    end
    #
    def window_width
      $game_temp.mc_data.width + 50
    end
    #
    def window_height
      result = @choice_window.height
      result += @title_window.height if @title_window.use?
      result
    end
    #-------------------------------------------------------------------
    def update
      super
      #print("%s \n" % [@choice_window.index]) if @choice_window.index != nil
      update_title_window_text
      update_timer
    end
    
    def update_timer
      if $game_temp.mc_data.time > 0
        @timer += 1
        if @timer > $game_temp.mc_data.time
          command_timeout
        end
      end
    end
    
    def update_title_window_text
      return unless @title_window.use?
      return if $game_temp.mc_data.title.is_a?(String)
      text = $game_temp.mc_data[@choice_window.index,:description]
      @title_window.set_text(text)
    end
    #-------------------------------------------------------------------
    def command_ok
      # 아이템 조건
      @tex_itn = []
      @tex_itn = $game_temp.mc_data[@choice_window.index,:description].split("*")
      if @tex_itn[1] == nil
        @item_ro_n = $game_temp.mc_data[@choice_window.index,:description].to_i
        @tex_itn[1] = 1
      else
        @item_ro_n = @tex_itn[0].to_i
      end
      #@item_ro_n = $game_temp.mc_data[@choice_window.index,:description].to_i
      
      @tex_it = []
      @tex_it = $game_temp.mc_data[@choice_window.index,:description].split(".")
      #print("103.선택지 2 증가 - %s, %s \n" % [@tex_itn[0], @tex_itn[1]]);
      if @tex_it[1] != nil
        iv = @tex_it[0].to_i
        name = $data_system.variables[iv].to_s
        if $game_variables[iv] >= @tex_it[1].to_i
          $game_temp.mc_data.result = $game_temp.mc_data[@choice_window.index,:result]
          return_scene
        else
          # 오류 메세지 표시 실험 -----------------------
          $game_temp.pop_w(180, 'SYSTEM', " '%s' no tiene suficientes puntos. " % [name])
          # -------------------------------------------
          Sound.play_buzzer
          @choice_window.activate
        end
      else
        if @item_ro_n != 0
          if @tex_itn[1].to_i == 0 and  1 > $game_party.item_number($data_items[@item_ro_n])
            $game_temp.pop_w(180, 'SYSTEM', " No tienes el ítem '%s'. " % [$data_items[@item_ro_n].name])
            Sound.play_buzzer
            @choice_window.activate
          elsif @tex_itn[1].to_i > $game_party.item_number($data_items[@item_ro_n])
            if @tex_itn[1].to_i != 0
              $game_temp.pop_w(180, 'SYSTEM', "  No tienes %s unidades del ítem '%s'.  " % [@tex_itn[1].to_i, $data_items[@item_ro_n].name])
            else
              $game_temp.pop_w(180, 'SYSTEM', "  No tienes el ítem '%s'.  " % [$data_items[@item_ro_n].name])
            end
            Sound.play_buzzer
            @choice_window.activate
          else
            $game_temp.mc_data.result = $game_temp.mc_data[@choice_window.index,:result]
            if @tex_itn[1].to_i != 0
              $game_temp.pop_w(180, 'SYSTEM', " Has usado %s unidades del ítem '%s'. " % [@tex_itn[1].to_i, $data_items[@item_ro_n].name])
            end
            return_scene
          end
        else
          $game_temp.mc_data.result = $game_temp.mc_data[@choice_window.index,:result]
          return_scene
        end
      end
    end
    
    # 취소 기능 제거 실험
    def command_cancel
      $game_temp.mc_data.result = $game_temp.mc_data.cancel
      return_scene
    end
    
    def command_timeout
      $game_temp.mc_data.result = $game_temp.mc_data.timeout
      return_scene
    end
    #-------------------------------------------------------------------
    def pre_terminate
      super
      if $game_temp.mc_data.var > 0
        $game_variables[$game_temp.mc_data.var] = $game_temp.mc_data.result
      end
    end
  end
end

#======================================================================#
# 기존 클래스, 함수 추가/수정
#======================================================================#
module LuD::MultiChoice
  #---------------------------------------------------------------------
  #  - *Game_Temp 추가
  #---------------------------------------------------------------------
  class ::Game_Temp
    def mc_data
      @mc_data ||= MC_Data.new
      @mc_data
    end
  end
  
  #---------------------------------------------------------------------
  #  - *Game_Interpreter 추가
  #---------------------------------------------------------------------
  class ::Game_Interpreter
    def mc_data
      $game_temp.mc_data
    end
    #def mc_call
    #def mc_call(time = mc_data.time)
    def mc_call(time = 0)
      # 화면 전환, 메뉴, 메세지인 경우 대기한다.
      #Fiber.yield while $game_player.transfer? or $game_system.menu_disabled or $game_message.visible
      #Fiber.yield while $game_player.transfer? or ($game_system.menu_disabled and $game_map.map_id != 35)
      Fiber.yield while !SceneManager.scene_is?(Scene_Map) or $game_map.scrolling?
      #Fiber.yield while $game_switches[54] == true and $game_map.map_id != 35
      
      # 화면이 이동중인 경우 대기
      Fiber.yield while ($game_player.screen_x - Graphics.width/2).abs >= 5
      Fiber.yield while ($game_player.screen_y - 16 - Graphics.height/2).abs >= 5
      
      SceneManager.call(Scene_MultiChoice)
      wait(2)
    end
    def mc_result
      $game_temp.mc_data.result
    end
  end
end

#======================================================================#
# MultiChoice
#======================================================================#
module LuD::MultiChoice
  def self.call_LuDCore_error
    raise LoadError, "LuDCore 스크립트가 필요합니다."
  end
  # 필요한 스크립트들 리스트에 적기 - 없으면 빈 배열
  require_list = []
  # 추가되는 스크립트의 이름
  script_name = :MultiChoice
  LuD.add_script(script_name, *require_list) rescue call_LuDCore_error
end
#======================================================================#
# LuD
#======================================================================#