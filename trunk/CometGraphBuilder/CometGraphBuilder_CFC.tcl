inherit CometGraphBuilder_CFC CommonFC

#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder_CFC constructor {} {
 set this(handle_root) {}
 set this(handle_daughters) {}
}
#___________________________________________________________________________________________________________________________________________
Generate_accessors CometGraphBuilder_CFC [list handle_root handle_daughters]

#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder_CFC Add_node_type {t} {}
method CometGraphBuilder_CFC Add_node_instance {n} {}
method CometGraphBuilder_CFC Sub_node {n} {}
method CometGraphBuilder_CFC Add_rel {m d} {}
method CometGraphBuilder_CFC Sub_rel {n d} {}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_get_CometGraphBuilder {} {return [list {get_handle_root { }} {get_handle_daughters { }} ]}
proc P_L_methodes_set_CometGraphBuilder {} {return [list {set_handle_root {v}} {set_handle_daughters {v}} {Add_node_type {t}} {Add_node_instance {n}} {Sub_node {n}} {Add_rel {m d}} {Sub_rel {n d}} ]}

