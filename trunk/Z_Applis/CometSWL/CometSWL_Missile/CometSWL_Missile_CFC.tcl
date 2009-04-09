inherit CometSWL_Missile_CFC CommonFC

#___________________________________________________________________________________________________________________________________________
method CometSWL_Missile_CFC constructor {} {
 set this(X) {}
 set this(Y) {}
 set this(VX) {}
 set this(VY) {}
 set this(ship) {}
}
#___________________________________________________________________________________________________________________________________________
Generate_accessors CometSWL_Missile_CFC [list X Y VX VY ship]

#___________________________________________________________________________________________________________________________________________

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_get_CometSWL_Missile {} {return [list {get_X { }} {get_Y { }} {get_VX { }} {get_VY { }} {get_ship { }} ]}
proc P_L_methodes_set_CometSWL_Missile {} {return [list {set_X {v}} {set_Y {v}} {set_VX {v}} {set_VY {v}} {set_ship {v}} ]}

