# encoding: utf-8
# Name: 184.Window_StorageCategory
# Size: 792
class Window_StorageCategory < Window_ItemCategory
  #--------------------------------------------------------------------------
  # 가온데 정렬 추가 수정
  #--------------------------------------------------------------------------
  def alignment
    return 1
  end
  
  def initialize(gold)
    @gold = gold
    super()
  end
  
  def col_max
    if @gold == true
      return 6
    else
      return 5
    end
  end
  
  def make_command_list
    add_command(Vocab::weapon, :weapon)
    add_command(Vocab::armor, :armor)
    add_command(CAO::CategorizeItem::VOCAB_COMMANDS["포션"], "포션")
    add_command(CAO::CategorizeItem::VOCAB_COMMANDS["음식"], "음식")
    add_command(CAO::CategorizeItem::VOCAB_COMMANDS["기타"], "기타")
  end
end