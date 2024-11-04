# encoding: utf-8
# Name: 226.Object
# Size: 587
class Object
  def file_exist?(path, filename)
    $file_list ||= {}
    $file_list[path + filename] ||= file_test(path, filename)
    $file_list[path + filename]
  end
  
  def file_test(path, filename)
    bitmap = Cache.load_bitmap(path, filename) rescue nil
    bitmap ? true : false
  end
  
  def portrait_exist?(filename)
    file_exist?(BM::PORTRAIT_FOLDER, filename)
  end
  
  def character_exist?(filename)
    file_exist?("Graphics/Characters/", filename)
  end
  
  def faceset_exist?(filename)
    file_exist?("Graphics/Faces/", filename)
  end
end