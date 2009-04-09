inherit CometSWL_Ship_CFC CommonFC

#___________________________________________________________________________________________________________________________________________
method CometSWL_Ship_CFC constructor {} {
 set this(X)      0
 set this(Y)      0
 set this(R)      10
 set this(player) {}
 set this(power)  0
 set this(angle)  0
}
#___________________________________________________________________________________________________________________________________________
Generate_accessors CometSWL_Ship_CFC [list G X Y R player power angle]

#___________________________________________________________________________________________________________________________________________

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_get_CometSWL_Ship {} {return [list {get_G { }} {get_R { }} {get_X { }} {get_Y { }} {get_player { }} {get_power { }} {get_angle { }} ]}
proc P_L_methodes_set_CometSWL_Ship {} {return [list {set_G {v}} {set_R {v}} {set_X {v}} {set_Y {v}} {set_player {v}} {set_power {v}} {set_angle {v}} ]}

