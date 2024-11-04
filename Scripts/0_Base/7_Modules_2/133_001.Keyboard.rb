# module V
#   def self.K(key)
#     return Ascii::SYM[key]
#   end
# end

# module Ascii 
#   SYM = { 
#     # Function Keys:
#     :kF1 => 112,  :kF2 => 113,  :kF3 => 114, :kF4 => 115, :kF5 => 116,
#     :kF6 => 117,  :kF7 => 118,  :kF8 => 119, :kF9 => 120, :kF10 => 121,
#     :kF11 => 122, :kF12 => 123,
#     # Numbers:
#     :k0 => 48, :k1 => 49, :k2 => 50, :k3 => 51, :k4 => 52, :k5 => 53,
#     :k6 => 54, :k7 => 55, :k8 => 56, :k9 => 57,
#     # Numpad Numbers:
#     :kNUM0 => 96, :kNUM1 => 97, :kNUM2 => 98, :kNUM3 => 99, :kNUM4 => 100,
#     :kNUM5 => 101, :kNUM6 => 102, :kNUM7 => 103, :kNUM8 => 104, :kNUM9 => 105,
#     # Numpad Misc:
#     :kNUMMUL => 106, :kNUMPLUS => 107, :kNUMMINUS => 109, :kNUMPOINT => 110,
#     :kNUMSLASH => 111,
#     # Lock Keys:
#     :kCAPSLOCK => 20, :kNUMLOCK => 144, :kSCROLLLOCK => 145,
#     # Letters:
#     :kA => 65, :kB => 66, :kC => 67, :kD => 68, :kE => 69, :kF => 70,
#     :kG => 71, :kH => 72, :kI => 73, :kJ => 74, :kK => 75, :kL => 76,
#     :kM => 77, :kN => 78, :kO => 79, :kP => 80, :kQ => 81, :kR => 82,
#     :kS => 83, :kT => 84, :kU => 85, :kV => 86, :kW => 87, :kX => 88,
#     :kY => 89, :kZ => 90,
#     # Direction Keys:
#     :kLEFT => 37, :kRIGHT => 39, :kUP => 38, :kDOWN => 40,
#     # Others:
#     :kLALT => 164,    :kLCTRL => 162,  :kRALT => 165,    :kRCTRL => 163,
#     :kLSHIFT => 160,  :kRSHIFT => 161, :kPAUSE => 19, 
#     :kENTER => 13,    :kRETURN => 13,  :kBACKSPACE => 8, :kSPACE => 32,
#     :kESCAPE => 27,   :kESC => 27,     :kSHIFT => 16,    :kTAB => 9,
#     :kALT => 18,      :kCTRL => 17,    :kDELETE => 46,   :kDEL => 46,
#     :kINSERT => 45,   :kINS => 45,     :kPAGEUP => 33,   :kPUP => 33,
#     :kPAGEDOWN => 34, :kPDOWN => 34,   :kHOME => 36,     :kEND => 35,
#     # Symbols:
#     :kCOLON => 186,     :kAPOSTROPHE => 222, :kQUOTE => 222,
#     :kCOMMA => 188,     :kPERIOD => 190,     :kSLASH => 191,
#     :kBACKSLASH => 220, :kLEFTBRACE => 219,  :kRIGHTBRACE => 221,
#     :kMINUS => 189,     :kUNDERSCORE => 189, :kPLUS => 187,
#     :kEQUAL => 187,     :kEQUALS => 187,     :kTILDE => 192,
#     :kLTRI => 226,
#   }
# end

# module Keyboard
#   @key_state = Win32API.new("user32","GetKeyState", 'i', 'i')
#   @key_paste = Win32API.new("user32","GetClipboardData", 'i', 'i')
  
#   @trigger = Array.new(256, false)
#   @press   = Array.new(256, false)
#   @repeat  = Array.new(256, 0)
#   @release = Array.new(256, false)
#   @checked = false
#   @caps_lock_state = true

#   def self.update
#     @checked = false
#   end
  
#   def self.get_key_state
#     @checked = true
#     256.times do |vk|
#       check = @key_state.call(vk)
#       unless check == 1 or check == 0
#         unless @press[vk]
#           @press[vk] = true
#           @trigger[vk] = true
#           @release[vk] = false
#         else
#           @release[vk] = false
#           @trigger[vk] = false
#         end
#         @repeat[vk] += 1
#       else
#         @release[vk] = @press[vk] ? true : false
#         @press[vk] = false
#         @trigger[vk] = false
#         @repeat[vk] = 0
#       end
#     end
#   end
  
#   def self.press?(sym)    # <sym> 키가 눌렸는지 확인합니다.
#     return get_symb(sym, :press)
#   end
  
#   def self.trigger?(sym)  # 위와 같이 트리거를 확인합니다.
#     return get_symb(sym, :trigger)
#   end
  
#   def self.repeat?(sym)   # 위와 같이 확인을 반복합니다.
#     return get_symb(sym, :repeat)
#   end
  
#   def self.release?(sym)
#     return get_symb(sym, :release)
#   end
  
#   def self.get_symb(sym, type)                # <sym> 키가 <type>인지 확인합니다.
#     res = sym.is_a?(Symbol) ? V.K(sym) : sym  # 키의 숫자를 가져옵니다.
#     return false if res.nil?                  # 키가 허용되지 않으면 반환합니다.
#     get_key_state unless @checked             # 키 상태를 설정합니다.
#     case type                                 # 숫자로 키를 확인합니다.
#     when :press;   return ch_press?(res)
#     when :trigger; return ch_trigger?(res)
#     when :repeat;  return ch_repeat?(res)
#     when :release; return ch_release?(res)
#     end
#     return false
#   end
  
#   # 세 가지 적절한 확인, 확인할 키에 대한 숫자 값이 필요합니다.
#   def self.ch_press?(sym)
#     return @press[sym]
#   end
  
#   def self.ch_trigger?(sym)   # 이 프레임을 눌렀습니다.
#     return @trigger[sym]
#   end
  
#   def self.ch_repeat?(sym)    # 몇 프레임마다 번갈아 나타납니다.
#     return true if @repeat[sym] == 1
#     return true if (@repeat[sym] >= 24 && (@repeat[sym] % 6) == 0)
#     return false
#   end

#   def self.ch_release?(sym)   # 이 프레임을 출시했습니다.
#     return @release[sym]
#   end
  
#   def self.shifted?           # 두 Shift 키의 상태를 확인합니다.
#     return true if press?(16)
#     return true if caps_on?
#     return false
#   end

#   # Cambio de tecla a 164 (Alt), por tema de Joiplay.
#   def self.caps_on?           # capslock 상태를 확인합니다.
#     # if @key_state.call(20) == 1
#     #   return true
#     # else
#     #   return false
#     # end
#     if @key_state.call(164) == 1
#       @caps_lock_state = true
#     else
#       @caps_lock_state = false
#     end
#     @caps_lock_state
#   end

#   def self.bittype(text)      # 입력하여 허용되는 키.
#     for i in 48..57
#       if repeat?(i)
#         text += add_char(i)
#       end
#     end
#     for i in 65..90
#       if repeat?(i)
#         text += add_char(i)
#       end
#     end
#     for i in 186..192
#       if repeat?(i)
#         text += add_char(i)
#       end
#     end
#     for i in 219..222
#       if repeat?(i)
#         text += add_char(i)
#       end
#     end
#     text += " " if repeat?(32)
#     if repeat?(8)
#       text.chop!
#     end
#     return text
#   end

#   def self.add_char(key)  # 입력된 문자를 추가합니다.
#     caps = press?(16)
#     case key
#     when 48..57
#       return (key - 48).to_s unless caps
#       return '!' if key == 49
#       return '@' if key == 50
#       return '#' if key == 51
#       return '$' if key == 52
#       return '%' if key == 53
#       return '^' if key == 54
#       return '&' if key == 55
#       return '*' if key == 56
#       return '(' if key == 57
#       return ')' if key == 48
#     when 65..90
#       string = "abcdefghijklmnopqrstuvwxyz"
#       string.swapcase! if caps
#       string.swapcase! if caps_on?
#       return string[key - 65]
#     when 186; return !caps ? ';' : ':'
#     when 187; return !caps ? '=' : '+'
#     when 188; return !caps ? ',' : '<'
#     when 189; return !caps ? '-' : '_'
#     when 190; return !caps ? '.' : '>'
#     when 191; return !caps ? '/' : '?'
#     when 192; return !caps ? '`' : '~'
#     when 219; return !caps ? '[' : '{'
#     when 220; return !caps ? '\\' : '|'
#     when 221; return !caps ? ']' : '}'
#     when 222; return !caps ? '\'' : '"'
#     end
#   end

#   def self.press_any_key
#     for i in 48..57
#       return true if trigger?(i)
#     end
#     for i in 65..90
#       return true if trigger?(i)
#     end
#     for i in 186..192
#       return true if trigger?(i)
#     end
#     for i in 219..222
#       return true if trigger?(i)
#     end
#     [13, 22, 27, 192, 32].each {|i| return true if trigger?(i)}
#     return false
#   end
# end

# module Input
#   class << self
#     alias cp_keyboard_update update unless $@
#     alias cp_keyboard_press? press? unless $@
#     alias cp_keyboard_trigger? trigger? unless $@
#     alias cp_keyboard_repeat? repeat? unless $@
#   end
  
#   def self.update
#     Keyboard.update
#     cp_keyboard_update
#   end
  
#   def self.press?(*sym)
#     if $imported["CP_INPUT"]
#       cp_keyboard_press?(*sym)
#     else
#       sym.any? do |key|
#         (Keyboard.press?(key) || cp_keyboard_press?(key))
#       end
#     end
#   end
  
#   def self.trigger?(*sym)
#     if $imported["CP_INPUT"]
#       cp_keyboard_trigger?(*sym)
#     else
#       sym.any? do |key|
#         (Keyboard.trigger?(key) || cp_keyboard_trigger?(key))
#       end
#     end
#   end
  
#   def self.repeat?(*sym)
#     if $imported["CP_INPUT"]
#       cp_keyboard_repeat?(*sym)
#     else
#       sym.any? do |key|
#         (Keyboard.repeat?(key) || cp_keyboard_repeat?(key))
#       end
#     end
#   end
# end




module Input
  class << self
    alias cp_keyboard_update update unless $@
    alias cp_keyboard_press? press? unless $@
    alias cp_keyboard_trigger? trigger? unless $@
    alias cp_keyboard_repeat? repeat? unless $@
  end
  
  def self.update
    Keyboard.update
    cp_keyboard_update
  end
  
  def self.press?(*sym)
    if $imported["CP_INPUT"]
      cp_keyboard_press?(*sym)
    else
      sym.any? do |key|
        (Keyboard.press?(key) || cp_keyboard_press?(key))
      end
    end
  end
  
  def self.trigger?(*sym)
    if $imported["CP_INPUT"]
      cp_keyboard_trigger?(*sym)
    else
      sym.any? do |key|
        (Keyboard.trigger?(key) || cp_keyboard_trigger?(key))
      end
    end
  end
  
  def self.repeat?(*sym)
    if $imported["CP_INPUT"]
      cp_keyboard_repeat?(*sym)
    else
      sym.any? do |key|
        (Keyboard.repeat?(key) || cp_keyboard_repeat?(key))
      end
    end
  end
end

module Ascii 
  SYM = { 
    # Function Keys:
    :kF1 => 58,  :kF2 => 59,  :kF3 => 60, :kF4 => 61, :kF5 => 62,
    :kF6 => 63,  :kF7 => 64,  :kF8 => 65, :kF9 => 66, :kF10 => 67,
    :kF11 => 68, :kF12 => 69,
    # Numbers:
    :k0 => 39, :k1 => 30, :k2 => 31, :k3 => 32, :k4 => 33, :k5 => 34,
    :k6 => 35, :k7 => 36, :k8 => 37, :k9 => 38,
    # Numpad Numbers:
    :kNUM0 => 98, :kNUM1 => 89, :kNUM2 => 90, :kNUM3 => 91, :kNUM4 => 92,
    :kNUM5 => 93, :kNUM6 => 94, :kNUM7 => 95, :kNUM8 => 96, :kNUM9 => 97,
    # Numpad Misc:
    :kNUMMUL => 85, :kNUMPLUS => 87, :kNUMMINUS => 86, :kNUMPOINT => 99,
    :kNUMSLASH => 84,
    # Lock Keys:
    :kCAPSLOCK => 57, :kNUMLOCK => 144, :kSCROLLLOCK => 145,
    # Letters:
    :kA => 4, :kB => 5, :kC => 6, :kD => 7, :kE => 8, :kF => 9,
    :kG => 10, :kH => 11, :kI => 12, :kJ => 13, :kK => 14, :kL => 15,
    :kM => 16, :kN => 17, :kO => 18, :kP => 19, :kQ => 20, :kR => 21,
    :kS => 22, :kT => 23, :kU => 24, :kV => 25, :kW => 26, :kX => 27,
    :kY => 28, :kZ => 29,
    # Direction Keys:
    :kLEFT => 80, :kRIGHT => 79, :kUP => 82, :kDOWN => 81,
    # Others:
    :kLALT => 226,    :kLCTRL => 224,  :kRALT => 226,    :kRCTRL => 224,
    :kLSHIFT => 225,  :kRSHIFT => 225, :kPAUSE => 72, 
    :kENTER => 40,    :kRETURN => 40,  :kBACKSPACE => 42, :kSPACE => 44,
    :kESCAPE => 41,   :kESC => 41,     :kSHIFT => 225,   :kTAB => 43,
    :kALT => 226,     :kCTRL => 224,   :kDELETE => 76,   :kDEL => 76,
    :kINSERT => 73,   :kINS => 73,     :kPAGEUP => 75,   :kPUP => 75,
    :kPAGEDOWN => 78, :kPDOWN => 78,   :kHOME => 74,     :kEND => 77,
    # Symbols:
    :kCOLON => 186,     :kAPOSTROPHE => 222, :kQUOTE => 222,
    :kCOMMA => 188,     :kPERIOD => 190,     :kSLASH => 191,
    :kBACKSLASH => 220, :kLEFTBRACE => 219,  :kRIGHTBRACE => 221,
    :kMINUS => 189,     :kUNDERSCORE => 189, :kPLUS => 187,
    :kEQUAL => 187,     :kEQUALS => 187,     :kTILDE => 192,
    :kLTRI => 226,
  }
end

module Keyboard
  def self.repeat?(sym)
    key = get_key(sym)
    return Input.repeat_key?(key) if key
    false
  end

  def self.press?(sym)
    key = get_key(sym)
    return Input.press_key?(key) if key
    false
  end

  def self.trigger?(sym)
    key = get_key(sym)
    return Input.trigger_key?(key) if key
    false
  end

  # Cambio de tecla a 226 (Alt).
  def self.caps_on?           # capslock 상태를 확인합니다.
    press?(226)
  end

  def self.get_key(sym)
    return sym if sym.is_a?(Integer) # Devuelve el valor si ya es un Fixnum
    return Ascii::SYM[sym] if sym.is_a?(Symbol)
    nil 
  end

  def self.update
    @checked = false
  end
end