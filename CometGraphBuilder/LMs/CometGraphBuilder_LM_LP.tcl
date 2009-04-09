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
proc P_L_methodes_set_CometGraphBuilder_COMET_RE {} {return [list {set_handle_root {n}} {set_handle_daughters {n}} {Add_node_type {t}} {Add_node_instance {n}} {Sub_node {n}} {Add_rel {m d}} {Sub_rel {n d}}]}
Generate_LM_setters CometGraphBuilder_LM_LP [P_L_methodes_set_CometGraphBuilder_COMET_RE]

#___________________________________________________________________________________________________________________________________________


