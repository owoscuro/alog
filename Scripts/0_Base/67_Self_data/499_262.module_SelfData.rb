# encoding: utf-8
# Name: 262.module SelfData
# Size: 6734
=begin
#==============================================================================
 ■ How to Use
 ┌──────────────────────────────────────────────────────────────────────────┐
 │ ■ Script calls                                                           │
 └──────────────────────────────────────────────────────────────────────────┘
      스크립트는 이벤트 자체 변수를 설정하고 가져오기 위해 호출합니다.
     
  Set: self_variable([map_id, event_id, id], value, oper)
  Get: self_variable([map_id, event_id, id])
    * map_id  : Set the map ID of the event you're applying the self variable to
    * event_id: The event's ID.
    * id      : The name of an Event's Self Variable. Case sensitive!
    * value   : New value of an Event's Self Variable.
    * oper    : 0: Equal / 1: Add / 2: Sub / 3: Multiply / 4: Divide / 5: Modulo

  Set: self_variable([event_id, id], value, oper)
  Get: self_variable([event_id, id])
    * This applies the self variable to an Event ID within the current map.
    * event_id: The event's ID within the current map.
    * id      : The name of an Event's Self Variable. Case sensitive!
    * value   : New value of an Event's Self Variable.
    * oper    : 0: Equal / 1: Add / 2: Sub / 3: Multiply / 4: Divide / 5: Modulo

  Set: self_variable(id, value)
  Get: self_variable(id)
    * This applies the self variable to This Event ID.
    * id      : The name of an Event's Self Variable. Case sensitive!
    * value   : New value of an Event's Self Variable.
    
      Script calls for setting and getting Event Self Metadata.
     
  Set: self_metadata([map_id, event_id, id], value)
  Get: self_metadata([map_id, event_id, id])
    * map_id  : Set the map ID of the event you're applying the self metadata to
    * event_id: The event's ID.
    * id      : The name of an Event's Self Metadata. Case sensitive!
    * value   : New value of an Event's Self Metadata.

  Set: self_metadata([event_id, id], value)
  Get: self_metadata([event_id, id])
    * This applies the self metadata to an Event ID within the current map.
    * event_id: The event's ID within the current map.
    * id      : The name of an Event's Self Metadata. Case sensitive!
    * value   : New value of an Event's Self Metadata.

  Set: self_metadata(id, value)
  Get: self_metadata(id)
    * This applies the self metadata to This Event ID.
    * id      : The name of an Event's Self Metadata. Case sensitive!
    * value   : New value of an Event's Self Metadata.
    
  map_id/event_id: Integers, ranges, and arrays are allowed. Nil = Everything.
 ┌──────────────────────────────────────────────────────────────────────────┐
 │ ■ Using Get script calls in conditional branches                         │
 └──────────────────────────────────────────────────────────────────────────┘
      Script calls to get an Event's Self Variable.
      
 To do this, go to the conditional branch event command, click on the fourth
 tab, select Script and type either of these in the input form:
    self_variable([map_id, event_id, id]) == value   <- Equal to
    self_variable([map_id, event_id, id]) >= value   <- Greater Than or Equal
    self_variable([map_id, event_id, id]) <= value   <- Less Than or Equal
    self_variable([map_id, event_id, id]) > value    <- Greater Than
    self_variable([map_id, event_id, id]) < value    <- Less Than
    self_variable([map_id, event_id, id]) != value   <- Not Equal To

    self_variable([event_id, id]) == value           <- Equal to
    self_variable([event_id, id]) >= value           <- Greater Than or Equal
    self_variable([event_id, id]) <= value           <- Less Than or Equal
    self_variable([event_id, id]) > value            <- Greater Than
    self_variable([event_id, id]) < value            <- Less Than
    self_variable([event_id, id]) != value           <- Not Equal To
    
    self_variable(id) == value                       <- Equal to.
    self_variable(id) >= value                       <- Greater Than or Equal.
    self_variable(id) <= value                       <- Less Than or Equal
    self_variable(id) > value                        <- Greater Than
    self_variable(id) < value                        <- Less Than
    self_variable(id) != value                       <- Not Equal To
    
      Script calls to get an Event's Self Metadata.
    self_metadata([map_id, event_id, id]) == value   <- Equal to.
    self_metadata([map_id, event_id, id]) != value   <- Not Equal to.

    self_metadata([event_id, id]) == value           <- Equal to.
    self_metadata([event_id, id]) != value           <- Not Equal to.

    self_metadata(id) == value                       <- Equal to.
    self_metadata(id) != value                       <- Not Equal to.
#==============================================================================
=end

module SelfData
  class Event
    Variables, Metadata = {}, {}
    
    Sensitive_IDs = false     # ID의 대소문자 구분을 활성화/비활성화합니다.
    #Sensitive_Values ​​= true  # 값의 대소문자 구분을 활성화/비활성화합니다.
                              # * 이 설정을 켜면
                              # if 조건문은 도움이 되지 않습니다.
                              # TRUE이면 ID 및 값 문자열을 대문자로 표시합니다.
    
    #--------------------------------------------------------------------------
    # * 이벤트에 대한 초기 자체 변수를 설정합니다.
    # 변수[[map_id, event_id, id]] = 값
    #--------------------------------------------------------------------------
    #Variables[[1, 1, "A"]] = 0
    
    #--------------------------------------------------------------------------
    # * 이벤트에 대한 초기 자체 메타데이터를 설정합니다.
    # 메타데이터[[map_id, event_id, id]] = 값
    #--------------------------------------------------------------------------
    #Metadata[[1, 1, "A"]] = ""
  end
end