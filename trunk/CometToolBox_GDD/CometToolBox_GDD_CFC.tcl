inherit CometToolBox_GDD_CFC CommonFC

#___________________________________________________________________________________________________________________________________________
method CometToolBox_GDD_CFC constructor {} {
 set this(gdd_port) {}
 set this(L_nodes)  [list]
}
#___________________________________________________________________________________________________________________________________________
Generate_accessors CometToolBox_GDD_CFC [list L_nodes gdd_port]

#___________________________________________________________________________________________________________________________________________
method CometToolBox_GDD_CFC Select_node {n} {}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_get_CometToolBox_GDD {} {return [list {get_L_nodes { }} {get_gdd_port { }} ]}
proc P_L_methodes_set_CometToolBox_GDD {} {return [list {set_L_nodes {L}} {set_gdd_port {v}} {Select_node {n}} ]}

