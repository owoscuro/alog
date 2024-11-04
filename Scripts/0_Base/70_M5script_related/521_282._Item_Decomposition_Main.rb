# encoding: utf-8
# Name: 282. Item Decomposition Main
# Size: 12460
$m5script ||= {}; $m5script[:ScriptData] ||= {}
$m5script[:M5Base] = 20170304

module M5script
  def self.version(ver,name="베이스",key=:M5Base)
    version = $m5script[key.to_sym] || $m5script[key.to_s] ||
      fail("야옹야옹 5 #{name}스크립트 지원")
    fail("야옹야옹 5 #{name}스크립트 버전이 너무 낮습니다.") if (ver > version)
  end
end

#-------------------------------------------------------------------------------
# M5script::M5note.match_text(텍스트, 메모[, 옵션, &블록])
# 텍스트 일치를 위한 기본 지시어
#
# text : 텍스트 내용(문자열)
# 참고: 일치시킬 텍스트(문자열)
# option : 텍스트 일치 설정의 해시 테이블
# :default 기본값 (nil)
# :value 일치시킬 텍스트에 내용이 포함되어 있는지 여부(true)
# :list 일치하는 모든 결과의 배열을 반환할지 여부(nil)
# &block : 성공적인 매치 시 실행될 콜백
#
# M5script::M5note.map_note(map, note[, option, &block])
# 맵 노트 읽기
#
# M5script::M5note.event_note(map, id, note[, option, &block])
# 활성 이벤트 페이지의 첫 번째 명령을 읽고 댓글이면 일치시킵니다.
#-------------------------------------------------------------------------------

module M5script; module M5note; class << self
  def match_text(text, note, *option, &block)
    config = option[0].is_a?(Hash) ?
      [option[0][:default], option[0][:value], option[0][:list]] : option
    default, value, list =  *config
    value = true if value.nil?
    return list ? [] : default if text.empty?
    all_result = []
    text.each_line do |line|
      line.chomp!
      if value
        result = /^\s*<\s*#{note}\s+(\S+)\s*>\s*$/ =~ line ? $1 : nil
        next unless result
        yield(result) if block_given?
        return result unless list
        all_result << result
      else
        return true if /^\s*<\s*#{note}\s*>\s*$/ =~ line
      end
    end
    return false unless value
    list ? all_result : default
  end
  def map_note(map, *args)
    text = load_data(sprintf("Data/Map%03d.rvdata2", map)).note
    match_text(text, *args)
  end
  def event_note(map, id, *args)
    begin
      if map == $game_map.map_id then page = $game_map.events[id]
      else
        ev = load_data(sprintf("Data/Map%03d.rvdata2", map)).events[id]
        (page = Game_Event.new(map,ev)).refresh
      end
      page.empty? ? raise : ev_list = page.list
    rescue then return match_text('', *args)
    end
    text = ''
    ev_list.each do |c|
      c.code == 108 || c.code == 408 || break
      text += c.parameters[0] + "\n"
    end
    match_text(text, *args)
  end
end; end; end
#--------------------------------------------------------------------------
# ● 항목 비고 읽기
#--------------------------------------------------------------------------
class RPG::BaseItem
  def m5note *a,&b; M5script::M5note.match_text(@note,*a,&b); end
end
#--------------------------------------------------------------------------
# ● 레거시 기본 스크립트와의 호환성
#--------------------------------------------------------------------------
class << M5script
  def match_text *a,&b;      M5script::M5note.match_text *a,&b; end
  def read_map_note *a,&b;   M5script::M5note.map_note *a,&b;   end
  def read_event_note *a,&b; M5script::M5note.event_note *a,&b; end
end
#--------------------------------------------------------------------------
# ● 스프라이트 Sprite_M5_Base / Sprite_M5
#--------------------------------------------------------------------------
class Sprite_M5_Base < Sprite
  def dispose
    dispose_bitmap
    super
  end
  def dispose_bitmap; end
end
class Sprite_M5 < Sprite_M5_Base; end
#--------------------------------------------------------------------------
# ● 디스플레이 포트 Viewport_M5
#--------------------------------------------------------------------------
class Viewport_M5 < Viewport; end
#--------------------------------------------------------------------------
# ● 스프라이트 세트 Spriteset_M5
#--------------------------------------------------------------------------
class Spriteset_M5
  def update; end
  def dispose; end
end
#--------------------------------------------------------------------------
# ● 릴리스 스프라이트 및 DisplayPort 자동 업데이트
#--------------------------------------------------------------------------
class Scene_Base
  alias m5_20141113_update_basic update_basic
  def update_basic
    m5_20141113_update_basic
    instance_variables.each do |varname|
      ivar = instance_variable_get(varname)
      ivar.update if ivar.is_a?(Sprite_M5) && !ivar.disposed?
      ivar.update if ivar.is_a?(Spriteset_M5)
    end
  end
  alias m5_20141113_terminate terminate
  def terminate
    m5_20141113_terminate
    instance_variables.each do |varname|
      ivar = instance_variable_get(varname)
      ivar.dispose if ivar.is_a?(Sprite_M5_Base)
      ivar.dispose if ivar.is_a?(Spriteset_M5)
      ivar.dispose if ivar.is_a?(Viewport_M5)
    end
  end
end
#--------------------------------------------------------------------------
# ● 제어 문자의 매개변수 가져오기(이 방법은 원본 데이터를 파괴함)
#
# m5_obtain_escape_param(text)
#--------------------------------------------------------------------------
class Window_Base
  def m5_obtain_escape_param(text)
    text.slice!(/^\[.*?\]/)[1..-2] rescue ""
  end
end
#--------------------------------------------------------------------------
# ● 글자 크기 조정
#
# include M5script::M5_Window_FontSize
#
# m5_font_width 기본 텍스트 폭
# m5_font_height 기본 텍스트 높이
# m5_font_size_change 텍스트 크기 조정
#--------------------------------------------------------------------------
module M5script; module M5_Window_FontSize
  def m5_font_size_change(width = m5_font_width, height = m5_font_height)
    contents.font.size = 40
    contents.font.size -= 1 while text_size("口").width > width if width
    contents.font.size -= 1 while text_size("口").height > height if height
  end
  def m5_font_width;  return nil; end
  def m5_font_height; return nil; end
end;end
class Window_Base
  alias m5_20140728_reset_font_settings reset_font_settings
  def reset_font_settings
    m5_20140728_reset_font_settings
    m5_font_size_change if respond_to?(:m5_font_size_change)
  end
  alias m5_20140728_create_contents create_contents
  def create_contents
    m5_20140728_create_contents
    m5_font_size_change if respond_to?(:m5_font_size_change)
  end
end
#--------------------------------------------------------------------------
# ● M5script::Window_Cal
#
# 텍스트의 크기를 계산할 때 사용되는 임시 창
#
# cal_all_text_height(text) 전체 높이 계산
# cal_all_text_width(text) 최대 너비 계산
# calc_line_width(text) 한 줄의 너비를 계산합니다.
# 대상 텍스트의 내용을 설명하는 m5_contents
# line_height는 각 텍스트 줄의 높이를 설정합니다.
#--------------------------------------------------------------------------
module M5script; class Window_Cal < Window_Base
  attr_writer :line_height, :m5_contents
  def initialize
    super(0, 0, Graphics.width, Graphics.height)
    self.visible = false
    @text = ""
    @line_height = nil
    @m5_contents = nil
  end
  def line_height
    return @line_height if @line_height
    super
  end
  def initialize_contents
    if @m5_contents
      self.contents.dispose
      self.contents = @m5_contents.clone
    end
  end
  def cal_all_text_height(text)
    initialize_contents
    reset_font_settings
    @text = text.clone
    all_text_height = 1
    convert_escape_characters(@text).each_line do |line|
      all_text_height += calc_line_height(line, false)
    end
    @m5_contents = nil
    return all_text_height
  end
  def cal_all_text_width(text)
    initialize_contents
    reset_font_settings
    @text = text.clone
    all_text_width = 1
    convert_escape_characters(@text).each_line do |line|
      all_text_width = [all_text_width,calc_line_width(line,false)].max
    end
    @m5_contents = nil
    return all_text_width
  end
  def calc_line_width(target, need_refresh = true)
    initialize_contents if need_refresh
    reset_font_settings
    text = target.clone
    pos = {:x => 0, :y => 0, :new_x => 0, :height => Graphics.height}
    process_character(text.slice!(0, 1), text, pos) until text.empty?
    @m5_contents = nil if need_refresh
    return pos[:x]
  end
  def process_new_line(text, pos);end
  def draw_text(*args);end
end; end
#--------------------------------------------------------------------------
# ● 자동으로 크기와 위치를 계산하고 배경정보 표시창 포함
#
# M5script::Window_Var
#
# Cal은 M5script::Window_Cal의 인스턴스인 창 크기에 사용되는 임시 창을 계산합니다.
# 다음 키 값을 사용하여 구성 창에서 설정한 해시 테이블:
# :X :X2 :Y :Y2 :Z :BACK :SX :SY
#--------------------------------------------------------------------------
module M5script; class Window_Var < Window_Base
  def initialize(config, cal = nil)
    get_config(config)
    @dispose_flag = true unless cal
    @size_window = cal || M5script::Window_Cal.new
    super(0,0,0,0)
    self.arrows_visible = false
    self.z = @config[:Z]
    self.openness = 0
    create_back_sprite
  end
  def get_config(config)
    @config = config.clone
    @config[:SX] ||= 0
    @config[:SY] ||= 0
    @config[:Z] ||= 0
  end
  def create_back_sprite
    return unless @config[:BACK]
    self.opacity = 0
    bitmap = Cache.system(@config[:BACK]) rescue nil
    return unless bitmap
    @background_sprite = Sprite.new
    @background_sprite.x, @background_sprite.y = @config[:SX], @config[:SY]
    @background_sprite.z = self.z - 1
    @background_sprite.bitmap = bitmap
  end
  def update_placement
    if @config[:X] && @config[:X2]
      self.width = (@config[:X2] - @config[:X]).abs
    else
      @size_window.m5_contents = self.contents
      self.width  = @size_window.cal_all_text_width(@word)
      self.width += standard_padding * 2
    end
    if @config[:Y] && @config[:Y2]
      self.height = (@config[:Y2] - @config[:Y]).abs
    else
      @size_window.m5_contents = self.contents
      self.height = @size_window.cal_all_text_height(@word)
      self.height += standard_padding * 2
    end
    create_contents
  end
  def update_position
    if    @config[:X]  then self.x = @config[:X]
    elsif @config[:X2] then self.x = @config[:X2] - self.width
    else                    self.x = 0
    end
    if    @config[:Y]  then self.y = @config[:Y]
    elsif @config[:Y2] then self.y = @config[:Y2] - self.height
    else                    self.y = 0
    end
  end
  def dispose
    super
    @size_window.dispose if @dispose_flag
    @background_sprite.dispose if @background_sprite
  end
end; end
#--------------------------------------------------------------------------
# ● TXT 생성
#
# M5script.creat_text(name,word,type)
#--------------------------------------------------------------------------
module M5script
  def self.creat_text(name,word,type = 'w')
    content = File.open("#{name}",type)
    content.puts word
    content.close
  end
end
#--------------------------------------------------------------------------
# ● 열린 주소
#
# M5script.open_url(addr)
#--------------------------------------------------------------------------
module M5script
  def self.open_url(addr)
    # Win32API remove: api = Win32API.new('shell32.dll','ShellExecuteA','pppppi','i')
    # Win32API remove: api.call(0,'open',addr,0, 0, 1)
  end
end
#--------------------------------------------------------------------------
# ● 읽다、쓰기 Game.ini
#
# M5script::M5ini.get(키, default_value[, 섹션])
# M5script::M5ini.write(키, 값[, 섹션])
#--------------------------------------------------------------------------
module M5script; module M5ini; class << self
  def filename; './Game.ini'; end
  def default_section; 'M5script'; end
  def get(key, default_value, section = default_section)
    # Win32API remove: buffer = [].pack('x256')
    # Win32API remove: api = Win32API.new('kernel32','GetPrivateProfileString','ppppip', 'i')
    # Win32API remove: l = api.call(section, key, default_value, buffer, buffer.size, filename)
    # Win32API remove: return buffer[0, l]
  end
  def write(key, value, section = default_section)
    # Win32API remove: api = Win32API.new('kernel32','WritePrivateProfileString','pppp', 'i')
    # Win32API remove: api.call(section, key, value.to_s, filename)
  end
end; end; end