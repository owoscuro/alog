# encoding: utf-8
# Name: Game_Followers
# Size: 4716
#==============================================================================
# ** Game_Followers
#------------------------------------------------------------------------------
#  This is a wrapper for a follower array. This class is used internally for
# the Game_Player class. 
#==============================================================================

class Game_Followers
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :visible                  # Player Followers ON?
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     leader:  Lead character
  #--------------------------------------------------------------------------
  def initialize(leader)
    @visible = $data_system.opt_followers
    @gathering = false                    # Gathering processing underway flag
    @data = []
    @data.push(Game_Follower.new(1, leader))
    (2...$game_party.max_battle_members).each do |index|
      @data.push(Game_Follower.new(index, @data[-1]))
    end
  end
  #--------------------------------------------------------------------------
  # * Get Followers
  #--------------------------------------------------------------------------
  def [](index)
    @data[index]
  end
  #--------------------------------------------------------------------------
  # * Iterator
  #--------------------------------------------------------------------------
  def each
    @data.each {|follower| yield follower } if block_given?
  end
  #--------------------------------------------------------------------------
  # * Iterator (Reverse)
  #--------------------------------------------------------------------------
  def reverse_each
    @data.reverse.each {|follower| yield follower } if block_given?
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    each {|follower| follower.refresh }
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    if gathering?
      move unless moving? || moving?
      @gathering = false if gather?
    end
    each {|follower| follower.update }
  end
  #--------------------------------------------------------------------------
  # * Movement
  #--------------------------------------------------------------------------
  def move
    reverse_each {|follower| follower.chase_preceding_character }
  end
  #--------------------------------------------------------------------------
  # * Synchronize
  #--------------------------------------------------------------------------
  def synchronize(x, y, d)
    each do |follower|
      follower.moveto(x, y)
      follower.set_direction(d)
    end
  end
  #--------------------------------------------------------------------------
  # * Gather
  #--------------------------------------------------------------------------
  def gather
    @gathering = true
  end
  #--------------------------------------------------------------------------
  # * Determine if Gathering
  #--------------------------------------------------------------------------
  def gathering?
    @gathering
  end
  #--------------------------------------------------------------------------
  # * 표시된 추종자 배열 가져오기
  # "folloers"는 오타이지만 호환성 때문에 유지됩니다.
  #--------------------------------------------------------------------------
  def visible_folloers
    @data.select {|follower| follower.visible? }
  end
  #--------------------------------------------------------------------------
  # * 이사 여부 확인
  #--------------------------------------------------------------------------
  def moving?
    visible_folloers.any? {|follower| follower.moving?}
  end
  #--------------------------------------------------------------------------
  # * 수집 여부 확인
  #--------------------------------------------------------------------------
  def gather?
    visible_folloers.all? {|follower| follower.gather?}
  end
  #--------------------------------------------------------------------------
  # * 충돌 감지
  #--------------------------------------------------------------------------
  def collide?(x, y)
    visible_folloers.any? {|follower| follower.pos?(x, y)}
  end
end