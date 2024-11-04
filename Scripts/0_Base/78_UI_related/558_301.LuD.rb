# encoding: utf-8
# Name: 301.LuD
# Size: 5636
module LuD
  VER = 1.2
  List = [:LuDCore]
  def self.call_LuDCore_error
    raise LoadError, "LuDCore 스크립트가 필요합니다."
  end
  def self.add_script(name, *requires)
    req_list = []
    [requires].flatten.each do |r|
      req_list.push r.to_s unless List.include?(r)
    end
    unless req_list.empty?
      error_msg = "다음 스크립트가 필요합니다.\n"
      msgbox (req_list.inject(error_msg) {|m, r| m + r + "\n"}).rstrip
      exit
    end
    List.push(name)
  end
end

module LuD
  POS = Struct.new(:x, :y)
  SIZE = Struct.new(:width, :height)
  VECTOR = Struct.new(:x, :y, :z)
  RECT = Struct.new(:x, :y, :width, :height)
  SQUARE = Struct.new(:left, :right, :top, :bottom)
  CIRCLE = Struct.new(:x, :y, :dist)
end

module LuD
  #====================================================================#
  # 키패드에 대응하는 x, y 좌표 반환
  # LuD.position(pos, width, height)
  #====================================================================#
  def self.position(pos, width, height)
    x = Graphics.width/2 - width/2
    y = Graphics.height/2 - height/2
    case pos
    when 1,4,7; x = 0
    when 3,6,9; x = Graphics.width - width
    end
    case pos
    when 1,2,3; y = Graphics.height - height
    when 7,8,9; y = 0
    end
    return POS[x,y]
  end
  #====================================================================#
  # 아이템 노트 읽어주는 스크립트
  # LuD.read_note(note, key)
  #====================================================================#
  def self.read_note(note, key)
    result = []
    set_option = false
    option = []
    note.each_line do |line|
      if line =~ /<#{key}\s?(?:[ |:|-])\s?(.*)>/i
        re = $1.split(/;/)
        result += re
        next
      end
      if line =~ /<\/#{key}>/i
        set_option = false
      end
      if set_option
        opt = line.gsub(/[\r|\n]/,'')
        option.push(opt)
        next
      end
      if line =~ /<#{key}>/i
        option.push("") unless option.include?("")
        set_option = true
      end
    end
    result += option
    return result
  end
  #====================================================================#
  # 이벤트 주석 읽어주는 스크립트
  # LuD.read_comment(list, key)
  #====================================================================#
  def self.read_comment(list, key)
    result = []
    return result unless list
    note = ""
    list.each do |r|
      if r.code == 108 || r.code == 408
        note += r.parameters[0]
        note += "\n"
      end
    end
    result += LuD.read_note(note, key)
    result.flatten!
    return result
  end
  #====================================================================#
  # read_note, read_comment 로 읽어온 옵션들을 구분해주는 기능
  # LuD.get_options(data, key)
  #====================================================================#
  def self.get_options(data, key)
    result = {}
    return result unless data
    list = (data.is_a?(String) ? read_note(data, key) : read_comment(data, key))
    return result unless list
    return result if list.empty?
    options = list.collect {|item| item.split(/[;|\r|\n]/)}.flatten
    options.each do |option|
      code, params = option, nil
      option.gsub(/(\w.*?)\s?=\s?(.*)/) do
        code, param = $1, $2
        params = param.split(/,/)
        params ||= param
        params = params[0] unless params.size > 1
      end
      code.strip!
      if result[code]
        result[code] = ([result[code]] + [params]).flatten
      else
        result[code] = params
      end
    end
    result[''] = true
    result
  end
  #====================================================================#
  # read_note, read_comment 로 읽어온 옵션중 하나의 값을 얻음
  # LuD.get_option(options, name[, uniq])
  # uniq : true/false - 중복값 제거할지 안할지 설정
  #====================================================================#
  def self.get_option(options, name, uniq = false)
    result = nil
    if options[name]
      result = options[name].dup
      result.uniq! if result.is_a?(Array) && uniq
    end
    result
  end
  #====================================================================#
  # 문자열 바꿔주기
  # LuD.convert_text(list)
  #====================================================================#
  def self.convert_text(text)
    result = text.clone
    result.gsub!(/\\/)            { "\e" }
    result.gsub!(/\e\e/)          { "\\" }
    until result.scan(/\eV\[(\d+)\]/i)
      result.gsub!(/\eV\[(\d+)\]/i) { $game_variables[$1.to_i] }
    end
    result.gsub!(/\eN\[(\d+)\]/i) { actor_name($1.to_i) }
    result.gsub!(/\eP\[(\d+)\]/i) { party_member_name($1.to_i) }
    result.gsub!(/\eG/i)          { Vocab::currency_unit }
    result.gsub!(/v\[(\d+)\]/i) {$game_variables[$1.to_i]}
    result.gsub!(/s\[(\d+)\]/i) {$game_switches[$1.to_i]}
    result
  end
  #====================================================================#
  # 문자너비 계산
  # LuD.calc_text_size(text[, font])
  #====================================================================#
  def self.calc_text_size(text, font = nil)
    text = LuD.convert_text(text)
    dummy = Window_Base.new(Graphics.width, Graphics.height, 1,1)
    dummy.contents.font = font if font
    size = dummy.text_size(text)
    _text = text.clone
    pos = {:x => 0, :y => 0, :new_x => 0, :height => dummy.calc_line_height(_text)}
    dummy.process_character(_text.slice!(0, 1), _text, pos) until _text.empty?
    dummy.dispose
    size.width = pos[:x]
    size.height = pos[:height]
    size
  end
end