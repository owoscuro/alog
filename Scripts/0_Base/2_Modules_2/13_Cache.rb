# encoding: utf-8
# Name: Cache
# Size: 6997
#==============================================================================
# ** Cache
#------------------------------------------------------------------------------
#  This module loads graphics, creates bitmap objects, and retains them.
# To speed up load times and conserve memory, this module holds the
# created bitmap object in the internal hash, allowing the program to
# return preexisting objects when the same bitmap is requested again.
#==============================================================================

module Cache
  #--------------------------------------------------------------------------
  # * 맵 오버레이
  #--------------------------------------------------------------------------
  def self.layers(filename)
    #print("Cache - self.layers, %s \n" % [filename]);
    load_bitmap("Graphics/Layers/", filename)
  end
  #--------------------------------------------------------------------------
  # * Get Animation Graphic
  #--------------------------------------------------------------------------
  def self.animation(filename, hue)
    #print("Cache - self.animation, %s \n" % [filename]);
    load_bitmap("Graphics/Animations/", filename, hue)
  end
  #--------------------------------------------------------------------------
  # * Get Battle Background (Floor) Graphic
  #--------------------------------------------------------------------------
  def self.battleback1(filename)
    #print("Cache - self.battleback1, %s \n" % [filename]);
    load_bitmap("Graphics/Battlebacks1/", filename)
  end
  #--------------------------------------------------------------------------
  # * Get Battle Background (Wall) Graphic
  #--------------------------------------------------------------------------
  def self.battleback2(filename)
    #print("Cache - self.battleback2, %s \n" % [filename]);
    load_bitmap("Graphics/Battlebacks2/", filename)
  end
  #--------------------------------------------------------------------------
  # * Get Battle Graphic
  #--------------------------------------------------------------------------
  def self.battler(filename, hue)
    #print("Cache - self.filename, %s \n" % [filename]);
    load_bitmap("Graphics/Battlers/", filename, hue)
  end
  #--------------------------------------------------------------------------
  # * Get Character Graphic
  #--------------------------------------------------------------------------
  def self.character(filename)
    #print("Cache - self.character, %s \n" % [filename]);
    load_bitmap("Graphics/Characters/", filename)
  end
  #--------------------------------------------------------------------------
  # * Get Face Graphic
  #--------------------------------------------------------------------------
  def self.face(filename)
    #print("Cache - self.face, %s \n" % [filename]);
    load_bitmap("Graphics/Faces/", filename)
  end
  #--------------------------------------------------------------------------
  # * Get Parallax Background Graphic
  #--------------------------------------------------------------------------
  def self.parallax(filename)
    #print("Cache - self.parallax, %s \n" % [filename]);
    load_bitmap("Graphics/Parallaxes/", filename)
  end
  #--------------------------------------------------------------------------
  # * Get Picture Graphic
  #--------------------------------------------------------------------------
  def self.picture(filename)
    #print("Cache - self.picture, %s \n" % [filename]);
    # 메뉴창의 스탠딩 이미지를 변수값으로 읽기 때문에 아래 조건 추가
    if filename != nil and filename != 0 and filename != ""
      load_bitmap("Graphics/Pictures/", filename)
    end
  end
  #--------------------------------------------------------------------------
  # * Get System Graphic
  #--------------------------------------------------------------------------
  def self.system(filename)
    #print("Cache - self.system, %s \n" % [filename]);
    load_bitmap("Graphics/System/", filename)
  end
  #--------------------------------------------------------------------------
  # * Get Tileset Graphic
  #--------------------------------------------------------------------------
  def self.tileset(filename)
    #print("Cache - self.tileset, %s \n" % [filename]);
    load_bitmap("Graphics/Tilesets/", filename)
  end
  #--------------------------------------------------------------------------
  # * Get Title (Background) Graphic
  #--------------------------------------------------------------------------
  def self.title1(filename)
    #print("Cache - self.title1, %s \n" % [filename]);
    load_bitmap("Graphics/Titles1/", filename)
  end
  #--------------------------------------------------------------------------
  # * Get Title (Frame) Graphic
  #--------------------------------------------------------------------------
  def self.title2(filename)
    #print("Cache - self.title2, %s \n" % [filename]);
    load_bitmap("Graphics/Titles2/", filename)
  end
  #--------------------------------------------------------------------------
  # * Load Bitmap
  #--------------------------------------------------------------------------
  def self.load_bitmap(folder_name, filename, hue = 0)
    @cache ||= {}
    if filename.empty?
      empty_bitmap
    elsif hue == 0
      normal_bitmap(folder_name + filename)
    else
      hue_changed_bitmap(folder_name + filename, hue)
    end
  end
  #--------------------------------------------------------------------------
  # * Create Empty Bitmap
  #--------------------------------------------------------------------------
  def self.empty_bitmap
    Bitmap.new(32, 32)
  end
  #--------------------------------------------------------------------------
  # * Create/Get Normal Bitmap
  #--------------------------------------------------------------------------
  def self.normal_bitmap(path)
    @cache[path] = Bitmap.new(path) unless include?(path)
    @cache[path]
  end
  #--------------------------------------------------------------------------
  # * Create/Get Hue-Changed Bitmap
  #--------------------------------------------------------------------------
  def self.hue_changed_bitmap(path, hue)
    key = [path, hue]
    unless include?(key)
      @cache[key] = normal_bitmap(path).clone
      @cache[key].hue_change(hue)
    end
    @cache[key]
  end
  #--------------------------------------------------------------------------
  # * 캐시 존재 확인
  #--------------------------------------------------------------------------
  def self.include?(key)
    @cache[key] && !@cache[key].disposed?
  end
  #--------------------------------------------------------------------------
  # * Clear Cache
  #--------------------------------------------------------------------------
  def self.clear
    @cache ||= {}
    @cache.clear
    GC.start
  end
end