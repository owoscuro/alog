# encoding: utf-8
# Name: Window_Gold
# Size: 1812
#==============================================================================
# ** Window_Gold
#------------------------------------------------------------------------------
#  This window displays the party's gold.
#==============================================================================

class Window_Gold < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, window_width, fitting_height(1))
    refresh
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    return 160
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_currency_value(value, currency_unit, 4, 0, contents.width - 8, 1)
  end
  #--------------------------------------------------------------------------
  # * Get Party Gold
  #--------------------------------------------------------------------------
  def value
    $game_party.gold
  end
  #--------------------------------------------------------------------------
  # Get Currency Unit
  #--------------------------------------------------------------------------
  def currency_unit
    Vocab::currency_unit
  end
  #--------------------------------------------------------------------------
  # * Open Window
  #--------------------------------------------------------------------------
  def open
    refresh
    super
  end
end