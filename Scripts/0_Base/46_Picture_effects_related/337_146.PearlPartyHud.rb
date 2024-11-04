# encoding: utf-8
# Name: 146.PearlPartyHud
# Size: 1250
class PearlPartyHud < Sprite
  include PearlBars
  def initialize(viewport)
    super(viewport)
    self.bitmap = Bitmap.new(160, 180)
    self.x = PartyHud::Pos_X
    self.y = PartyHud::Pos_Y
    @party = []
    @old_data = {}
    $game_player.followers.each {|f| @party << f.battler if f.visible?}
    @view = viewport
    @view.z = 999
    refresh_party_hud
    update
  end
  
  def refresh_party_hud
    #print("146.PearlPartyHud - refresh_party_hud \n");
    self.bitmap.clear
    self.bitmap.font.size = 16
    self.z = 999
    y = 0
    hc = HP_Color ; mc = MP_Color
    @party.each do |battler|                             # w    h
      PearlKernel.draw_hp(self.bitmap, battler, 8, y + 30, 65,  4,  hc, true)
      PearlKernel.draw_mp(self.bitmap, battler, 8, y + 43, 65,  4,  mc)
      @old_data[battler.id] = [battler.hp, battler.mp]
      y += 48
    end
  end
  
  def update
    if Graphics.frame_count % 2 == 0
      @party.each {|battler|
      if @old_data[battler.id][0] != battler.hp
        refresh_party_hud 
      elsif @old_data[battler.id][1] != battler.mp
        refresh_party_hud 
      end
      }
    end
  end
  
  def dispose
    self.bitmap.dispose
    super
  end
end