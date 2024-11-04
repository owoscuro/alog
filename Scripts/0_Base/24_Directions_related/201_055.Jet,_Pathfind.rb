# encoding: utf-8
# Name: 055.Jet, Pathfind
# Size: 990
#-------------------------------------------------------------------------------
# 이동 루트의 설정에서 다음 스크립트를 호출하세요.
#   pathfind(x, y)
#   pathfind_ev(event_id)
# 
# 탐색 깊이를 변경하려면 다음 코드를 스크립트 호출로 호출해주세요.
#
#   Pathfind.limit = 15
#-------------------------------------------------------------------------------

$imported = {} if $imported.nil?
$imported["RS_Pathfind"] = true

module Pathfind
  # 최대 탐색 깊이입니다.
  # 이 값보다 크게 하면 탐색 범위가 넓어집니다.
  # 하지만 범위 내에 타겟이 없을 경우 렉이 심해지게 됩니다.
  @@search_limit = 50
  
  # 스크립트 호출로 값을 탐색 깊이 값을 변경할 수 있습니다.
  def self.limit=(val)
    @@search_limit = val
  end
  
  def self.limit
    @@search_limit
  end
end

module Jet
  module Pathfinder
    # 길 찾기 시도 제한 횟수
    MAXIMUM_ITERATIONS = 500
  end
end