# encoding: utf-8
# Name: 251.Scene_Gid
# Size: 303
# 가이드 화면 작성시 가우시안 효과
class Scene_Gid < Scene_MenuBase
  def start
    create_background
  end
  
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
  end
end
# SceneManager.call(Scene_Reset)