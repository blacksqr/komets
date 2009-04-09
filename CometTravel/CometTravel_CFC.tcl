
#__________________________________________________
inherit CometTravel_CFC CommonFC

#______________________________________________________
method CometTravel_CFC constructor {} {
 set this(loc_src) ""
 set this(loc_dst) ""
 set this(travel)  ""
}

#______________________________________________________
Generate_accessors CometTravel_CFC [list loc_src loc_dst travel]

#______________________________________________________
method CometTravel_CFC Compute_travel {} {}

#__________________________________________________
proc P_L_methodes_get_CometTravel {} {return [list {get_loc_src { }} {get_loc_dst { }} {get_travel { }}    ]}
proc P_L_methodes_set_CometTravel {} {return [list {set_loc_src {l}} {set_loc_dst {l}} {set_travel {t}} {Compute_travel {}} ]}
