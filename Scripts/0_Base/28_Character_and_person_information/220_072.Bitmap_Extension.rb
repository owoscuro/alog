# encoding: utf-8
# Name: 072.Bitmap_Extension
# Size: 18716
$imported = {} if $imported == nil
$imported["BitmapExtension"] = true

class Win32API
  STRING_BUF_SIZE = 255
  def self.GetPrivateProfileString(section, key, default, inifile)
    # Win32API remove: get_ini = Win32API.new('kernel32.dll', 'GetPrivateProfileStringA', %w(p p p p l p), 'l')
    # Win32API remove: buf = "\0" * (STRING_BUF_SIZE + 1)
    # Win32API remove: get_ini.call(section, key, default, buf, STRING_BUF_SIZE, inifile)
    # Win32API remove: return buf.delete!("\0")
  end
  def self.FindWindow(window_class, window_title)
    # Win32API remove: find_window = Win32API.new('user32.dll', 'FindWindowA', %w(p p), 'l')
    # Win32API remove: return find_window.call(window_class, window_title)
  end
  def self.GetActiveWindow
    # Win32API remove: active_window = Win32API.new('user32.dll', 'GetActiveWindow', %w(v), 'l')
    # Win32API remove: return active_window.call
  end
  def self.GetHwnd
    # Win32API remove: name = GetPrivateProfileString("Game", "Title", "", "./Game.ini")
    # Win32API remove: return FindWindow("RGSS Player", name)
  end
end

class Bitmap
  def self.interpolation_mode
    return -1 if TRGSSX::NO_TRGSSX
    return TRGSSX.get_interpolation_mode
  end
  def self.interpolation_mode=(value)
    return if TRGSSX::NO_TRGSSX
    TRGSSX.set_interpolation_mode(value)
  end
  def self.smoothing_mode
    return -1 if TRGSSX::NO_TRGSSX
    return TRGSSX.get_smoothing_mode
  end
  def self.smoothing_mode=(value)
    return if TRGSSX::NO_TRGSSX
    TRGSSX.set_smoothing_mode(value)
  end
  def get_base_info
    return [object_id, width, height].pack('l!3')
  end
  def rop_blt(x, y, src_bitmap, src_rect, rop = TRGSSX::SRCCOPY)
    return -1 if TRGSSX::NO_TRGSSX
    return TRGSSX.rop_blt(get_base_info,
      x, y, src_rect.width, src_rect.height,
      src_bitmap.get_base_info, src_rect.x, src_rect.y, rop)
  end
  def clip_blt(x, y, src_bitmap, src_rect, region)
    return -1 if TRGSSX::NO_TRGSSX
    hRgn = region.create_region_handle
    return if hRgn == nil || hRgn == 0
    result = TRGSSX.clip_blt(get_base_info,
      x, y, src_rect.width, src_rect.height,
      src_bitmap.get_base_info, src_rect.x, src_rect.y, hRgn)
    Region.delete_region_handles
    return result
  end
  def blend_blt(x, y, src_bitmap, src_rect, blend = TRGSSX::BLEND_NORMAL)
    return -1 if TRGSSX::NO_TRGSSX
    return TRGSSX.blend_blt(get_base_info,
      x, y, src_rect.width, src_rect.height,
      src_bitmap.get_base_info, src_rect.x, src_rect.y, blend)
  end
  def stretch_blt_r(dest_rect, src_bitmap, src_rect, opacity = 255)
    return -1 if TRGSSX::NO_TRGSSX
    return TRGSSX.stretch_blt_r(get_base_info,
      dest_rect.x, dest_rect.y, dest_rect.width, dest_rect.height,
      src_bitmap.get_base_info,
      src_rect.x, src_rect.y, src_rect.width, src_rect.height,
      opacity)
  end
  def skew_blt(x, y, src_bitmap, src_rect, slope, opacity = 255)
    slope = [[slope, -89].max, 89].min
    sh    = src_rect.height
    off  = sh / Math.tan(Math::PI * (90 - slope.abs) / 180.0)
    if slope >= 0
      dx   = x + off.to_i
      diff = -off / sh
    else
      dx   = x
      diff = off / sh
    end
    rect = Rect.new(src_rect.x, src_rect.y, src_rect.width, 1)
    sh.times { |i|
      blt(dx + (diff * i).round, y + i, src_bitmap, rect, opacity)
      rect.y += 1
    }
  end
  def skew_blt_r(x, y, src_bitmap, src_rect, slope, opacity = 255)
    return -1 if TRGSSX::NO_TRGSSX
    return TRGSSX.skew_blt_r(get_base_info,
      x, y, src_bitmap.get_base_info,
      src_rect.x, src_rect.y, src_rect.width, src_rect.height,
      slope, opacity)
  end
  def draw_polygon(points, color, width = 1)
    return -1 if TRGSSX::NO_TRGSSX
    _points = create_point_pack(points)
    return TRGSSX.draw_polygon(get_base_info,
      _points, points.size, color.argb_code, width)
  end
  def fill_polygon(points, st_color, ed_color, fill_mode = TRGSSX::FM_FIT)
    return -1 if TRGSSX::NO_TRGSSX
    _points = create_point_pack(points)
    return TRGSSX.fill_polygon(get_base_info,
      _points, points.size, st_color.argb_code, ed_color.argb_code, fill_mode)
  end
  def create_point_pack(points)
    result = ''
    points.each { |pt| result += pt.pack('l!2') }
    return result
  end
  private :create_point_pack
  def draw_regular_polygon(x, y, r, n, color, width = 1)
    return -1 if TRGSSX::NO_TRGSSX
    return TRGSSX.draw_regular_polygon(get_base_info,
      x, y, r, n, color.argb_code, width)
  end
  def fill_regular_polygon(x, y, r, n, st_color, ed_color,
      fill_mode = TRGSSX::FM_FIT)
    return -1 if TRGSSX::NO_TRGSSX
    return TRGSSX.fill_regular_polygon(get_base_info,
      x, y, r, n, st_color.argb_code, ed_color.argb_code, fill_mode)
  end
  def draw_spoke(x, y, r, n, color, width = 1)
    return -1 if TRGSSX::NO_TRGSSX
    return TRGSSX.draw_spoke(get_base_info,
      x, y, r, n, color.argb_code, width)
  end
  def draw_text_na(*args)
    return -1 if TRGSSX::NO_TRGSSX
    x, y, width, height, text, align = get_text_args(args)
    fname = get_available_font_name
    flags = get_draw_text_flags
    return TRGSSX.draw_text_na(get_base_info, x, y, width, height, text,
      fname, font.size, get_text_color, align, flags)
  end
  def draw_text_fast(*args)
    return -1 if TRGSSX::NO_TRGSSX
    x, y, width, height, text, align = get_text_args(args)
    fname = get_available_font_name
    flags = get_draw_text_flags
    return TRGSSX.draw_text_fast(get_base_info, x, y, width, height, text,
      fname, font.size, get_text_color, align, flags)
  end
  def text_size_na(text)
    return -1 if TRGSSX::NO_TRGSSX
    fname = get_available_font_name
    flags = get_draw_text_flags
    size  = [0, 0].pack('l!2')
    result = TRGSSX.get_text_size_na(get_base_info, text.to_s,
      fname, font.size, flags, size)
    size = size.unpack('l!2')
    rect = Rect.new(0, 0, size[0], size[1])
    return rect
  end
  def text_size_fast(text)
    return -1 if TRGSSX::NO_TRGSSX
    fname = get_available_font_name
    flags = get_draw_text_flags
    size  = [0, 0].pack('l!2')
    result = TRGSSX.get_text_size_fast(get_base_info, text.to_s,
      fname, font.size, flags, size)
    size = size.unpack('l!2')
    rect = Rect.new(0, 0, size[0], size[1])
    return rect
  end
  def get_text_args(args)
    if args[0].is_a?(Rect)
      if args.size.between?(2, 4)
        x, y = args[0].x, args[0].y
        width, height = args[0].width, args[0].height
        text  = args[1].to_s
        align = (args[2].equal?(nil) ? 0 : args[2])
      else
        raise(ArgumentError,
          "wrong number of arguments(#{args.size} of #{args.size < 2 ? 2 : 4})")
        return
      end
    else
      if args.size.between?(5, 7)
        x, y, width, height = args
        text  = args[4].to_s
        align = (args[5].equal?(nil) ? 0 : args[5])
      else
        raise(ArgumentError,
          "wrong number of arguments(#{args.size} of #{args.size < 5 ? 5 : 7})")
        return
      end
    end
    return [x, y, width, height, text, align]
  end
  private :get_text_args
  def get_available_font_name
    if font.name.is_a?(Array)
      font.name.each { |f|
        return f if Font.exist?(f)
      }
      return nil
    else
      return font.name
    end
  end
  private :get_available_font_name
  def get_text_color
    need_grad = !font.gradation_color.equal?(nil)
    result = []
    result << font.color.argb_code
    result << (need_grad ? font.gradation_color.argb_code : 0)
    result << 0xFF000000
    result << (need_grad ? 1 : 0)
    return result.pack('l!4')
  end
  private :get_text_color
  def get_draw_text_flags
    flags  = 0
    flags |= TRGSSX::FS_BOLD   if font.bold
    flags |= TRGSSX::FS_ITALIC if font.italic
    flags |= TRGSSX::FS_SHADOW if font.shadow && !font.frame
    flags |= TRGSSX::FS_FRAME  if font.frame
    return flags
  end
  private :get_draw_text_flags
  def save(filename)
    return -1 if TRGSSX::NO_TRGSSX

    return TRGSSX.save_to_bitmap(filename, get_base_info)
  end
end

class Color
  def argb_code
    n  = 0
    n |= alpha.to_i << 24
    n |= red.to_i   << 16
    n |= green.to_i <<  8
    n |= blue.to_i
    return n
  end
end

class Font
  unless const_defined?(:XP_MODE)
    unless method_defined?(:shadow)
      XP_MODE = true
      @@default_shadow = false
      attr_writer :shadow
      def self.default_shadow
        return @@default_shadow
      end
      def self.default_shadow=(s)
        @@default_shadow = s
      end
      def shadow
        return (@shadow == nil ? @@default_shadow : @shadow)
      end
    else
      XP_MODE = false
    end
  end
  @@default_frame           = KGC::BitmapExtension::DEFAULT_FRAME
  @@default_gradation_color = KGC::BitmapExtension::DEFAULT_GRAD_COLOR
  attr_accessor :gradation_color
  unless private_method_defined?(:initialize_KGC_BitmapExtension)
    alias initialize_KGC_BitmapExtension initialize
  end
  def initialize(name = Font.default_name, size = Font.default_size)
    initialize_KGC_BitmapExtension(name, size)
    @frame = nil
    @gradation_color = @@default_gradation_color
    if XP_MODE
      @shadow = nil
    end
  end
  def self.default_frame
    return @@default_frame
  end
  def self.default_frame=(value)
    @@default_frame = value
  end
  def self.default_gradation_color
    return @@default_gradation_color
  end
  def self.default_gradation_color=(value)
    @@default_gradation_color = value
  end
  unless method_defined?(:shadow_eq) || XP_MODE
    alias shadow_eq shadow=
  end
  def shadow=(value)
    XP_MODE ? @shadow = value : shadow_eq(value)
  end
  def frame
    return (@frame == nil ? @@default_frame : @frame)
  end
  def frame=(value)
    @frame = value
  end
end

class Region
  @@handles = []
  # Win32API remove: @@_api_delete_object = Win32API.new('gdi32', 'DeleteObject', 'l', 'l')
  def create_region_handle
    return 0
  end
  def &(obj)
    return nil unless obj.is_a?(Region)
    return CombinedRegion.new(CombinedRegion::RGN_AND, self, obj)
  end
  def *(obj)
    return self.&(obj)
  end
  def |(obj)
    return nil unless obj.is_a?(Region)
    return CombinedRegion.new(CombinedRegion::RGN_OR, self, obj)
  end
  def +(obj)
    return self.|(obj)
  end
  def ^(obj)
    return nil unless obj.is_a?(Region)
    return CombinedRegion.new(CombinedRegion::RGN_XOR, self, obj)
  end
  def -(obj)
    return nil unless obj.is_a?(Region)
    return CombinedRegion.new(CombinedRegion::RGN_DIFF, self, obj)
  end
  def self.delete_region_handles
    @@handles.uniq!
    # Win32API remove: @@handles.each { |h| @@_api_delete_object.call(h) }
    @@handles.clear
  end
end

class RectRegion < Region
  attr_accessor :x
  attr_accessor :y
  attr_accessor :width
  attr_accessor :height
  #--------------------------------------------------------------------------
  # ∝ Win32API
  #--------------------------------------------------------------------------
  # Win32API remove: @@_api_create_rect_rgn = Win32API.new('gdi32', 'CreateRectRgn', 'llll', 'l')
  # Win32API remove: @@_api_create_rect_rgn_indirect = Win32API.new('gdi32', 'CreateRectRgnIndirect', 'l', 'l')
  #--------------------------------------------------------------------------
  # ∝ ⅹΧⅨⅶ?Θ놓퍅뺏
  #--------------------------------------------------------------------------
  def initialize(*args)
    if args[0].is_a?(Rect)
      rect = args[0]
      @x = rect.x
      @y = rect.y
      @width  = rect.width
      @height = rect.height
    else
      @x, @y, @width, @height = args
    end
  end
  #--------------------------------------------------------------------------
  # ∝ κ?ⅨητΟτΙλ냥
  #--------------------------------------------------------------------------
  def create_region_handle
    # Win32API remove: hRgn = @@_api_create_rect_rgn.call(@x, @y, @x + @width, @y + @height)
    # Win32API remove: @@handles << hRgn
    # Win32API remove: return hRgn
  end
end

class RoundRectRegion < RectRegion
  attr_accessor :width_ellipse
  attr_accessor :height_ellipse
  # Win32API remove: @@_api_create_round_rect_rgn = Win32API.new('gdi32', 'CreateRoundRectRgn', 'llllll', 'l')
  def initialize(*args)
    super
    if args[0].is_a?(Rect)
      @width_ellipse  = args[1]
      @height_ellipse = args[2]
    else
      @width_ellipse  = args[4]
      @height_ellipse = args[5]
    end
  end
  def create_region_handle
    # Win32API remove: hRgn = @@_api_create_round_rect_rgn.call(@x, @y, @x + @width, @y + @height, width_ellipse, height_ellipse)
    # Win32API remove: @@handles << hRgn
    # Win32API remove: return hRgn
  end
end

class EllipticRegion < RectRegion
  # Win32API remove: @@_api_create_elliptic_rgn = Win32API.new('gdi32', 'CreateEllipticRgn', 'llll', 'l')
  # Win32API remove: @@_api_create_elliptic_rgn_indirect = Win32API.new('gdi32', 'CreateEllipticRgnIndirect', 'l', 'l')
  def create_region_handle
    # Win32API remove: hRgn = @@_api_create_elliptic_rgn.call(@x, @y, @x + @width, @y + @height)
    # Win32API remove: @@handles << hRgn
    # Win32API remove: return hRgn
  end
end

class CircularRegion < EllipticRegion
  attr_reader   :radius
  def initialize(x, y, r)
    @cx = x
    @cy = y
    self.radius = r
    super(@cx - r, @cy - r, r * 2, r * 2)
  end
  def x
    return @cx
  end
  def y
    return @cy
  end
  def x=(value)
    @cx = value
    @x = @cx - @radius
  end
  def y=(value)
    @cy = value
    @y = @cy - @radius
  end
  def radius=(value)
    @radius = value
    @x = @cx - @radius
    @y = @cy - @radius
    @width = @height = @radius * 2
  end
end

class PolygonRegion < Region
  ALTERNATE = 1
  WINDING   = 2
  
  attr_accessor :points
  attr_accessor :fill_mode
  
  # Win32API remove: @@_api_create_polygon_rgn = Win32API.new('gdi32', 'CreatePolygonRgn', 'pll', 'l')
  # Win32API remove: @@_api_create_polypolygon_rgn = Win32API.new('gdi32', 'CreatePolyPolygonRgn', 'llll', 'l')
  def initialize(*points)
    @points = points
    @fill_mode = WINDING
  end
  def create_region_handle
    # Win32API remove: pts = ""
    # Win32API remove: points.each { |pt| pts += pt.pack("ll") }
    # Win32API remove: hRgn = @@_api_create_polygon_rgn.call(pts, points.size, fill_mode)
    # Win32API remove: @@handles << hRgn
    # Win32API remove: return hRgn
  end
end

class StarRegion < PolygonRegion
  POINT_NUM = 5
  PI_4      = 4.0 * Math::PI
  attr_reader   :x
  attr_reader   :y
  attr_reader   :width
  attr_reader   :height
  attr_reader   :angle
  
  def initialize(*args)
    super()
    shape = args[0]
    ang = args[1]
    case shape
    when CircularRegion
      @x = shape.x - shape.radius
      @y = shape.y - shape.radius
      @width = @height = shape.radius * 2
    when Rect, RectRegion, EllipticRegion
      @x = shape.x
      @y = shape.y
      @width  = shape.width
      @height = shape.height
    when Integer
      @x, @y, @width, @height = args
      ang = args[4]
    else
      @x = @y = @width = @height = 0
    end
    @angle = (ang == nil ? 0 : ang % 360)
    @__init = true
    @points = create_star_points
  end
  def create_star_points
    return unless @__init

    dw = (width + 1) / 2
    dh = (height + 1) / 2
    dx = x + dw
    dy = y + dh
    base_angle = angle * Math::PI / 180.0
    pts = []
    POINT_NUM.times { |i|
      ang = base_angle + PI_4 * i / POINT_NUM
      pts << [dx + (Math.sin(ang) * dw).to_i,
        dy - (Math.cos(ang) * dh).to_i]
    }
    return pts
  end
  def x=(value)
    @x = value
    @points = create_star_points
  end
  def y=(value)
    @y = value
    @points = create_star_points
  end
  def width=(value)
    @width = value
    @points = create_star_points
  end
  def height=(value)
    @height = value
    @points = create_star_points
  end
  def angle=(value)
    @angle = value % 360
    @points = create_star_points
  end
end

class PieRegion < Region
  HALF_PI = Math::PI / 2.0
  
  attr_reader   :begin_angle
  attr_reader   :sweep_angle
  
  def initialize(*args)
    super()
    shape = args[0]
    ang1, ang2 = args[1..2]
    case shape
    when CircularRegion
      @cx = shape.x
      @cy = shape.y
      self.radius = shape.radius
    else
      @cx = @cy = @x = @y = @radius = 0
    end
    self.start_angle = (ang1 == nil ? 0 : ang1)
    self.sweep_angle = (ang2 == nil ? 0 : ang2)
    @__init = true
    create_pie_region
  end
  
  def create_pie_region
    return unless @__init
    st_deg = @start_angle += (@sweep_angle < 0 ? @sweep_angle : 0)
    st_deg %= 360
    ed_deg = st_deg + @sweep_angle.abs
    diff = st_deg % 90
    r = @radius * 3 / 2
    s = st_deg / 90
    e = ed_deg / 90
    @region = nil
    (s..e).each { |i|
      break if i * 90 >= ed_deg
      if diff > 0
        st_rad = (i * 90 + diff) * Math::PI / 180.0
        diff = 0
      else
        st_rad = i * HALF_PI
      end
      if (i + 1) * 90 > ed_deg
        ed_rad = ed_deg * Math::PI / 180.0
      else
        ed_rad = (i + 1) * HALF_PI
      end
      pt1 = [@cx, @cy]
      pt2 = [
        @cx + Integer(Math.cos(st_rad) * r),
        @cy + Integer(Math.sin(st_rad) * r)
      ]
      pt3 = [
        @cx + Integer(Math.cos(ed_rad) * r),
        @cy + Integer(Math.sin(ed_rad) * r)
      ]
      rgn = PolygonRegion.new(pt1, pt2, pt3)
      if @region == nil
        @region = rgn
      else
        @region |= rgn
      end
    }
    @region &= CircularRegion.new(@cx, @cy, @radius)

    return @region
  end
  def x
    return @cx
  end
  def y
    return @cy
  end
  def x=(value)
    @cx = value
    @x = @cx - @radius
    create_pie_region
  end
  def y=(value)
    @cy = value
    @y = @cy - @radius
    create_pie_region
  end
  def radius=(value)
    @radius = value
    @x = @cx - @radius
    @y = @cy - @radius
    create_pie_region
  end
  def start_angle=(value)
    @start_angle = value
    create_pie_region
  end
  def sweep_angle=(value)
    @sweep_angle = [[value, -360].max, 360].min
    create_pie_region
  end
  def create_region_handle
    return @region.create_region_handle
  end
end

class CombinedRegion < Region
  RGN_AND  = 1
  RGN_OR   = 2
  RGN_XOR  = 3
  RGN_DIFF = 4
  RGN_COPY = 5
  # Win32API remove: @@_api_combine_rgn = Win32API.new('gdi32', 'CombineRgn', 'llll', 'l')
  def initialize(mode, region1, region2)
    @exp = CombinedRegionExp.new(mode, region1.clone, region2.clone)
  end
  def create_region_handle
    return combine_region(@exp.region1, @exp.region2, @exp.mode)
  end
  def combine_region(dest, src, mode)
    hdest = dest.create_region_handle
    hsrc  = src.create_region_handle
    # Win32API remove: @@_api_combine_rgn.call(hdest, hdest, hsrc, mode)
    return hdest
  end
  protected :combine_region
end

CombinedRegionExp = Struct.new("CombinedRegionExp", :mode, :region1, :region2)