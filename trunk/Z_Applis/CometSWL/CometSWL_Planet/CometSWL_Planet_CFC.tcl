inherit CometSWL_Planet_CFC CommonFC

#___________________________________________________________________________________________________________________________________________
method CometSWL_Planet_CFC constructor {} {
 set this(X)       0
 set this(Y)       0
 set this(R)       100
 set this(density) 1
 set this(mass)    0
 
 this Update_mass
}
#___________________________________________________________________________________________________________________________________________
Generate_accessors CometSWL_Planet_CFC [list X Y R density mass]

#___________________________________________________________________________________________________________________________________________
method CometSWL_Planet_CFC Update_mass {} {
 set this(mass) [expr $this(density) * $this(R) * $this(R) * 3.14156592]
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Planet_CFC set_R {v} {
 set this(R) $v
 this Update_mass
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Planet_CFC set_density {v} {
 set this(density) $v
 this Update_mass
}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_get_CometSWL_Planet {} {return [list {get_mass {}} {get_R { }} {get_X { }} {get_Y { }} {get_density { }} ]}
proc P_L_methodes_set_CometSWL_Planet {} {return [list {set_R {v}} {set_X {v}} {set_Y {v}} {set_density {v}} ]}

