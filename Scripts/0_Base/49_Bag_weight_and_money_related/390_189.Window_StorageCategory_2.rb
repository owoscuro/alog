# encoding: utf-8
# Name: 189.Window_StorageCategory_2
# Size: 767
$imported ||= {}
$imported[:BRAVO_STORAGE_2] = true

class Window_StorageCategory_2 < Window_ItemCategory
  #--------------------------------------------------------------------------
  # 가온데 정렬 추가 수정
  #--------------------------------------------------------------------------
  def alignment
    return 1
  end
  
  def initialize
    super()
  end
  
  def col_max
    return 5
  end
  
  def make_command_list
    add_command(Vocab::weapon, :weapon)
    add_command(Vocab::armor, :armor)
    add_command(CAO::CategorizeItem::VOCAB_COMMANDS["포션"], "포션")
    add_command(CAO::CategorizeItem::VOCAB_COMMANDS["음식"], "음식")
    add_command(CAO::CategorizeItem::VOCAB_COMMANDS["기타"], "기타")
  end
end