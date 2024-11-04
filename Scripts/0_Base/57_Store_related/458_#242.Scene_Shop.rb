# encoding: utf-8
# Name: #242.Scene_Shop
# Size: 1915
=begin
$imported ||= {}
$imported[:bm_shop] = 2.00
BM.required(:bm_shop, :bm_base, 1.10, :above)

class Scene_Shop < Scene_MenuBase
  alias :bm_shop_start :start
  def start
    bm_shop_start
    bm_win_opacity
  end
  
  def selling_price
    rate = 50
    # 아래 원본
    rate = @item.selling_rate
    if $game_switches[TMPRICE::SW_USE]
      rate += $game_variables[TMPRICE::VN_SELLING_RATE] + $game_variables[171] + $game_variables[295]
    end
    # 구매
    @buy_window.make_item_list
    [@item.price * rate / (500 - $game_variables[163]), buying_price].min
  end
  
  def bm_win_opacity
    @gold_window.opacity = BM::SHOP::BG_OPTIONS[:win_opacity] unless @gold_window.nil?
    @help_window.opacity = BM::SHOP::BG_OPTIONS[:win_opacity] unless @help_window.nil?
    @command_window.opacity = BM::SHOP::BG_OPTIONS[:win_opacity] unless @command_window.nil?
    @number_window.opacity = BM::SHOP::BG_OPTIONS[:win_opacity] unless @number_window.nil?
    @status_window.opacity = BM::SHOP::BG_OPTIONS[:win_opacity] unless @status_window.nil?
    @buy_window.opacity = BM::SHOP::BG_OPTIONS[:win_opacity] unless @buy_window.nil?
    @category_window.opacity = BM::SHOP::BG_OPTIONS[:win_opacity] unless @category_window.nil?
    @sell_window.opacity = BM::SHOP::BG_OPTIONS[:win_opacity] unless @sell_window.nil?    
    @data_window.opacity = BM::SHOP::BG_OPTIONS[:win_opacity] unless @data_window.nil?    
  end
  
  def show_sub_window(window)
    @status_window.hide
    @gold_window.hide
    window.show.activate
  end
  
  def hide_sub_window(window)
    @status_window.show
    @gold_window.show
    window.hide.deactivate
    @command_window.activate
  end
  
  alias theo_liminv_buy_ok on_buy_ok
  def on_buy_ok
    @number_window.mode = :buy
    theo_liminv_buy_ok
  end
  
  alias theo_liminv_sell_ok on_sell_ok
  def on_sell_ok
    @number_window.mode = :sell
    theo_liminv_sell_ok
  end
end
=end