inherit CometToolBox_GDD_CFC CommonFC

#___________________________________________________________________________________________________________________________________________
method CometToolBox_GDD_CFC constructor {} {
 set this(gdd_port) {}
}
#___________________________________________________________________________________________________________________________________________
Generate_accessors CometToolBox_GDD_CFC [list gdd_port]

#___________________________________________________________________________________________________________________________________________
method CometToolBox_GDD_CFC Select_node {n} {}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_get_CometToolBox_GDD {} {return [list {get_gdd_port { }} {Select_node {n}} ]}
proc P_L_methodes_set_CometToolBox_GDD {} {return [list {set_gdd_port {v}} ]}

