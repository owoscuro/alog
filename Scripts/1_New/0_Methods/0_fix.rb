class Bitmap
  alias_method :original_text_size, :text_size
  
  # `text_size' : Argument 0: Expected string
  # 			   fuck
  def text_size(str)
    original_text_size(str.to_s)
  end
end