# encoding: utf-8
# Name: 060.Region_Effects
# Size: 7373
module Region_Effects
  MAX_EFFECTS = 20           # 화면에 나타날 수 있는 효과의 수
  SPAWN_MAP_ID = 2           # 이벤트 효과를 저장한 맵의 맵 ID입니다.
  
  #-----------------------------------------------------------------------------
  # region => ["sound", vol, pitch, event_id, common_event_id]
  #
  # 지역              효과가 활성화됩니다 지역 ID
  # sound             SE 파일의 이름, "" 소리 없음
  # vol               SE의 볼륨 (0 - 100)
  # pitch             SE의 피치 (50-150)
  # event_id          스폰지도에서 호출 이벤트 ID. 없음 0입니다.
  # common_event_id   일반적인 이벤트 ID는 호출합니다, 더 일반적인 경우 0입니다.
  #-----------------------------------------------------------------------------
  EFFECT = {
  # 경비병 시야 범위 지정
  34   => ["", 0, 0, 0, 125],
  }
end

module MOG_PICURE_EFFECTS
  # 게임 중간에 "set_picture_z(value)" 명령을 사용하여 Z 값을 변경할 수 있습니다.
  DEFAULT_SCREEN_Z = 100
end

module KGC
  module BitmapExtension
    DEFAULT_FRAME = true
    DEFAULT_GRAD_COLOR = nil
  end
end

module TRGSSX
  BLEND_NORMAL  = 0
  BLEND_ADD     = 1
  BLEND_SUB     = 2
  BLEND_MUL     = 3
  BLEND_HILIGHT = 4

  SRCCOPY     = 0x00CC0020  # dest = src
  SRCPAINT    = 0x00EE0086  # dest = dest | src
  SRCAND      = 0x008800C6  # dest = dest & src
  SRCINVERT   = 0x00660046  # dest = dest ^ src
  SRCERASE    = 0x00440328  # dest = dest & ~src
  NOTSRCCOPY  = 0x00330008  # dest = ~src
  NOTSRCERASE = 0x001100A6  # dest = ~(dest | src) = ~dest & ~src

  IM_INVALID             = -1
  IM_DEFAULT             = 0
  IM_LOWQUALITY          = 1
  IM_HIGHQUALITY         = 2
  IM_BILINEAR            = 3
  IM_BICUBIC             = 4
  IM_NEARESTNEIGHBOR     = 5
  IM_HIGHQUALITYBILINEAR = 6
  IM_HIGHQUALITYBICUBIC  = 7

  SM_INVALID     = -1
  SM_DEFAULT     = 0
  SM_HIGHSPEED   = 1
  SM_HIGHQUALITY = 2
  SM_NONE        = 3
  SM_ANTIALIAS   = 4

  FM_FIT    = 0
  FM_CIRCLE = 1

  FS_BOLD      = 0x0001
  FS_ITALIC    = 0x0002
  FS_UNDERLINE = 0x0004
  FS_STRIKEOUT = 0x0008
  FS_SHADOW    = 0x0010
  FS_FRAME     = 0x0020

  DLL_NAME = 'TRGSSX'
  begin
    NO_TRGSSX = false
    unless defined?(@@_trgssx_version)
      # Win32API remove: @@_trgssx_version = Win32API.new(DLL_NAME, 'DllGetVersion', 'v', 'l')
      # Win32API remove: @@_trgssx_get_interpolation_mode = Win32API.new(DLL_NAME, 'GetInterpolationMode', 'v', 'l')
      # Win32API remove: @@_trgssx_set_interpolation_mode = Win32API.new(DLL_NAME, 'SetInterpolationMode', 'l', 'v')
      # Win32API remove: @@_trgssx_get_smoothing_mode = Win32API.new(DLL_NAME, 'GetSmoothingMode', 'v', 'l')
      # Win32API remove: @@_trgssx_set_smoothing_mode = Win32API.new(DLL_NAME, 'SetSmoothingMode', 'l', 'v')
      # Win32API remove: @@_trgssx_rop_blt = Win32API.new(DLL_NAME, 'RopBlt', 'pllllplll', 'l')
      # Win32API remove: @@_trgssx_clip_blt = Win32API.new(DLL_NAME, 'ClipBlt', 'pllllplll', 'l')
      # Win32API remove: @@_trgssx_blend_blt = Win32API.new(DLL_NAME, 'BlendBlt', 'pllllplll', 'l')
      # Win32API remove: @@_trgssx_stretch_blt_r = Win32API.new(DLL_NAME, 'StretchBltR', 'pllllplllll', 'l')
      # Win32API remove: @@_trgssx_skew_blt_r = Win32API.new(DLL_NAME, 'SkewBltR', 'pllpllllll', 'l')
      # Win32API remove: @@_trgssx_draw_polygon = Win32API.new(DLL_NAME, 'DrawPolygon', 'pplll', 'l')
      # Win32API remove: @@_trgssx_fill_polygon = Win32API.new(DLL_NAME, 'FillPolygon', 'ppllll', 'l')
      # Win32API remove: @@_trgssx_draw_regular_polygon = Win32API.new(DLL_NAME, 'DrawRegularPolygon', 'pllllll', 'l')
      # Win32API remove: @@_trgssx_fill_regular_polygon = Win32API.new(DLL_NAME, 'FillRegularPolygon', 'plllllll', 'l')
      # Win32API remove: @@_trgssx_draw_spoke = Win32API.new(DLL_NAME, 'DrawSpoke', 'pllllll', 'l')
      # Win32API remove: @@_trgssx_draw_text_na = Win32API.new(DLL_NAME, 'DrawTextNAA', 'pllllpplpll', 'l')
      # Win32API remove: @@_trgssx_draw_text_fast = Win32API.new(DLL_NAME, 'DrawTextFastA', 'pllllpplpll', 'l')
      # Win32API remove: @@_trgssx_get_text_size_na = Win32API.new(DLL_NAME, 'GetTextSizeNAA', 'pppllp', 'l')
      # Win32API remove: @@_trgssx_get_text_size_fast = Win32API.new(DLL_NAME, 'GetTextSizeFastA', 'pppllp', 'l')
      # Win32API remove: @@_trgssx_save_to_bitmap = Win32API.new(DLL_NAME, 'SaveToBitmapA', 'pp', 'l')
    end
  rescue
    NO_TRGSSX = true
    msgbox("\"#{DLL_NAME}.dll\"를 찾을 수 없습니다." +
      "또는 오래된 버전을 사용하고 있습니다.")
    exit
  end
  module_function
  def version
    return -1 if NO_TRGSSX
    # Win32API remove: return @@_trgssx_version.call
  end
  def get_interpolation_mode
    # Win32API remove: return @@_trgssx_get_interpolation_mode.call
  end
  def set_interpolation_mode(mode)
    # Win32API remove: @@_trgssx_set_interpolation_mode.call(mode)
  end
  def get_smoothing_mode
    # Win32API remove: return @@_trgssx_get_smoothing_mode.call
  end
  def set_smoothing_mode(mode)
    # Win32API remove: @@_trgssx_set_smoothing_mode.call(mode)
  end
  def rop_blt(dest_info, dx, dy, dw, dh, src_info, sx, sy, rop)
    # Win32API remove: return @@_trgssx_rop_blt.call(dest_info, dx, dy, dw, dh,
    # Win32API remove:   src_info, sx, sy, rop)
  end
  def clip_blt(dest_info, dx, dy, dw, dh, src_info, sx, sy, hRgn)
    # Win32API remove: return @@_trgssx_clip_blt.call(dest_info, dx, dy, dw, dh,
    # Win32API remove:   src_info, sx, sy, hRgn)
  end
  def blend_blt(dest_info, dx, dy, dw, dh, src_info, sx, sy, blend)
    # Win32API remove: return @@_trgssx_blend_blt.call(dest_info, dx, dy, dw, dh,
    # Win32API remove:   src_info, sx, sy, blend)
  end
  def stretch_blt_r(dest_info, dx, dy, dw, dh, src_info, sx, sy, sw, sh, op)
    # Win32API remove: return @@_trgssx_stretch_blt_r.call(dest_info, dx, dy, dw, dh,
    # Win32API remove:   src_info, sx, sy, sw, sh, op)
  end
  def skew_blt_r(dest_info, dx, dy, src_info, sx, sy, sw, sh, slope, op)
    # Win32API remove: return @@_trgssx_skew_blt_r.call(dest_info, dx, dy,
    # Win32API remove:   src_info, sx, sy, sw, sh, slope, op)
  end
  def draw_polygon(dest_info, pts, n, color, width)
    # Win32API remove: return @@_trgssx_draw_polygon.call(dest_info, pts,
    # Win32API remove:   n, color, width)
  end
  def fill_polygon(dest_info, pts, n, st_color, ed_color, fm)
    # Win32API remove: return @@_trgssx_fill_polygon.call(dest_info, pts,
    # Win32API remove:   n, st_color, ed_color, fm)
  end
  def draw_regular_polygon(dest_info, dx, dy, r, n, color, width)
    # Win32API remove: return @@_trgssx_draw_regular_polygon.call(dest_info, dx, dy,
    # Win32API remove:   r, n, color, width)
  end
  def fill_regular_polygon(dest_info, dx, dy, r, n, st_color, ed_color, fm)
    # Win32API remove: return @@_trgssx_fill_regular_polygon.call(dest_info, dx, dy,
    # Win32API remove:   r, n, st_color, ed_color, fm)
  end
  def draw_spoke(dest_info, dx, dy, r, n, color, width)
    # Win32API remove: return @@_trgssx_draw_spoke.call(dest_info, dx, dy,
    # Win32API remove:   r, n, color, width)
  end
  def draw_text_na(dest_info, dx, dy, dw, dh, text,
      fontname, fontsize, color, align, flags)
    # Win32API remove: return @@_trgssx_draw_text_na.call(dest_info, dx, dy, dw, dh, text.dup,
    # Win32API remove:   fontname, fontsize, color, align, flags)
  end
  def draw_text_fast(dest_info, dx, dy, dw, dh, text,
      fontname, fontsize, color, align, flags)
    # Win32API remove: return @@_trgssx_draw_text_fast.call(dest_info, dx, dy, dw, dh, text.dup,
    # Win32API remove:   fontname, fontsize, color, align, flags)
  end
  def get_text_size_na(dest_info, text, fontname, fontsize, flags, size)
    # Win32API remove: return @@_trgssx_get_text_size_na.call(dest_info, text,
    # Win32API remove:   fontname, fontsize, flags, size)
  end
  def get_text_size_fast(dest_info, text, fontname, fontsize, flags, size)
    # Win32API remove: return @@_trgssx_get_text_size_fast.call(dest_info, text,
    # Win32API remove:   fontname, fontsize, flags, size)
  end
  def save_to_bitmap(filename, info)
    # Win32API remove: return @@_trgssx_save_to_bitmap.call(filename, info)
  end
end