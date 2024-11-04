# encoding: utf-8
# Name: 159.Window_FileList
# Size: 1521
module Icon
  def self.etype(id)
    return BM::EQUIP::EQUIP_TYPE_OPTIONS[id] if BM::EQUIP::EQUIP_TYPE_OPTIONS.include?(id)
    return 0
  end
  
  def self.equip_border
    BM::EQUIP::ICON_BORDER
  end
  
  def self.save_icon
    return  YEA::SAVE::SAVE_ICON
  end
  
  def self.empty_icon
    return  YEA::SAVE::EMPTY_ICON
  end
end

class Window_FileList < Window_Selectable
  def initialize(dx, dy)
    super(dx, dy, 128, Graphics.height - dy)
    refresh
    activate
    select(SceneManager.scene.first_savefile_index)
  end
  
  # 001 + module
  # DataManager 에서 저장 슬롯 최대 값 획득
  def item_max; return DataManager.savefile_max; end
  
  def current_item_enabled?
    header = DataManager.load_header(index)
    return false if header.nil? && SceneManager.scene_is?(Scene_Load)
    return true
  end
  
  def refresh
    create_contents
    draw_all_items
  end
  
  def draw_item(index)
    header = DataManager.load_header(index)
    enabled = !header.nil?
    rect = item_rect(index)
    rect.width -= 4
    draw_icon(save_icon?(header), rect.x, rect.y - 2, enabled)
    change_color(normal_color, enabled)
    if index == 0
      text = sprintf(" 파일 F4", (index).group)
    else
      text = sprintf(YEA::SAVE::SLOT_NAME2, (index).group)
    end
    draw_text(rect.x+24, rect.y, rect.width-24, line_height, text)
  end
  
  def save_icon?(header)
    return Icon.empty_icon if header.nil?
    return Icon.save_icon
  end
end