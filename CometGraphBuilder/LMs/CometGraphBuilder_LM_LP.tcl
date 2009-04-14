inherit CometGraphBuilder_LM_LP Logical_presentation

#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder_LM_LP constructor {name descr args} {
 this inherited $name $descr
# Adding some physical presentations 
 this Add_PM_factories [Generate_factories_for_PM_type [list {CometGraphBuilder_PM_P_B207_basic Ptf_BIGre} \
                                                       ] $objName]

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometGraphBuilder_LM_LP [P_L_methodes_set_CometGraphBuilder] {} {$this(L_actives_PM)}
Methodes_get_LC CometGraphBuilder_LM_LP [P_L_methodes_get_CometGraphBuilder] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_set_CometGraphBuilder_COMET_RE {} {return [list {set_handle_root {id}} {set_handle_daughters {id}} \
                                                                  {Add_node_type {id name}} {Add_node_instance {id name}} \
																  {Sub_node {id}} {Add_rel {id_m id_d}} {Sub_rel {id_n id_d}} \
																  {set_marks_for {id L_marks}} \
															]}
Generate_LM_setters CometGraphBuilder_LM_LP [P_L_methodes_set_CometGraphBuilder_COMET_RE]

#___________________________________________________________________________________________________________________________________________
Inject_code CometGraphBuilder_LM_LP \
            prim_Add_rel \
			"puts \"\$objName prim_Add_rel \$id_d == \$id_m\"\nif {\$id_d == \$id_m  ||  \[this Has_for_descendant \$id_d \$id_m\]} {return}" \
			""

