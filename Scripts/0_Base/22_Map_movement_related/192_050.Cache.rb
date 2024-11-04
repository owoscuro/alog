# encoding: utf-8
# Name: 050.Cache
# Size: 699
module Cache
  def self.world_map(filename)
    load_bitmap("Graphics/World Map/", filename)
  end
  
  def self.lights(filename)
    self.load_bitmap('Graphics/Lights/', filename)
  end
  
  def self.equip_body(filename, hue = 0)
    load_bitmap(BM::EQUIP::EQUIP_BODY_FOLDER, filename, hue)
  end
  
  def self.storage_image(bitmap, name)
    @image_cache ||= {}
    @image_cache[name] = bitmap unless @image_cache.has_key?(name)
    @image_cache[name]
  end  
  
  def self.restore_image(name)
    return false if @image_cache.nil? || !@image_cache.has_key?(name)
    @image_cache[name]
  end
  
  def self.portrait(filename, hue = 0)
    load_bitmap(BM::PORTRAIT_FOLDER, filename, hue)
  end
end