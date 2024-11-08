# encoding: utf-8
# Name: Window_ShopSell
# Size: 1205
#==============================================================================
# ** Window_ShopSell
#------------------------------------------------------------------------------
#  This window displays a list of items in possession for selling on the shop
# screen.
#==============================================================================

class Window_ShopSell < Window_ItemList
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super(x, y, width, height)
  end
  #--------------------------------------------------------------------------
  # * Get Activation State of Selection Item
  #--------------------------------------------------------------------------
  def current_item_enabled?
    enable?(@data[index]) if @data[index] != nil
  end
  #--------------------------------------------------------------------------
  # * Display in Enabled State?
  #--------------------------------------------------------------------------
  def enable?(item)
    item && item.price > 0
  end
end