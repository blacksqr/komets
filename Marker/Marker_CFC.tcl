#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Marker_CFC CommonFC

#___________________________________________________________________________________________________________________________________________
method Marker_CFC constructor {{mark 0}} {
 set this(mark) $mark
}

#___________________________________________________________________________________________________________________________________________
method Marker_CFC get_mark {}  {return $this(mark)}
method Marker_CFC set_mark {m} {set this(mark) $m}

#___________________________________________________________________________________________________________________________________________
proc L_methodes_get_Marker {} {return [list {get_mark { }} ]}
proc L_methodes_set_Marker {} {return [list {set_mark {v}} ]}

proc L_methodes_CometRE_Marker {} {return [list {set_mark {v}} ]}
