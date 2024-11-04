# encoding: utf-8
# Name: 037.CAO
# Size: 1802
# encoding: utf-8
# Name: 037.CAO
# Size: 1272
module CAO
  module CategorizeItem
    COMMANDS = [:weapon, :armor, "포션", "음식", "기타", :key_item]

    VOCAB_COMMANDS = {}

    VOCAB_COMMANDS[:item] = Lang::TEXTS[:interface][:categorize_item][:item]
    VOCAB_COMMANDS[:weapon] = Lang::TEXTS[:interface][:categorize_item][:weapon]
    VOCAB_COMMANDS[:armor] = Lang::TEXTS[:interface][:categorize_item][:armor]
    VOCAB_COMMANDS["포션"] = Lang::TEXTS[:interface][:categorize_item][:potion]
    VOCAB_COMMANDS["음식"] = Lang::TEXTS[:interface][:categorize_item][:food]
    VOCAB_COMMANDS["기타"] = Lang::TEXTS[:interface][:categorize_item][:others]
    VOCAB_COMMANDS[:key_item] = Lang::TEXTS[:interface][:categorize_item][:key_item]

    INCLUDE_KEYWORD = true
    VISIBLE_CURSOR = true
  end
  
  module CategorizeShop
    COMMANDS = [:weapon, :armor, "포션", "음식", "기타"]
    CUT_RATE = 0.5

    IMAGE_ICONS = {}
    
    VISIBLE_CURSOR = true
    VISIBLE_BACKWINDOW = true

    VOCAB_COMMANDS = {}
    VOCAB_COMMANDS[:item] = Lang::TEXTS[:interface][:categorize_item][:item]
    VOCAB_COMMANDS[:weapon] = Lang::TEXTS[:interface][:categorize_item][:weapon]
    VOCAB_COMMANDS[:armor] = Lang::TEXTS[:interface][:categorize_item][:armor]
    VOCAB_COMMANDS["포션"] = Lang::TEXTS[:interface][:categorize_item][:potion]
    VOCAB_COMMANDS["음식"] = Lang::TEXTS[:interface][:categorize_item][:food]
    VOCAB_COMMANDS["기타"] = Lang::TEXTS[:interface][:categorize_item][:others]
    VOCAB_COMMANDS[:key_item] = Lang::TEXTS[:interface][:categorize_item][:key_item]
  end
end

module CAO::CategorizeItem
  KEYWORD_PREFIX = "<"
  KEYWORD_SUFFIX = ">"
  KEYWORDS = COMMANDS.select {|k| k.is_a?(String) }
                     .map    {|k| KEYWORD_PREFIX + k + KEYWORD_SUFFIX }
end