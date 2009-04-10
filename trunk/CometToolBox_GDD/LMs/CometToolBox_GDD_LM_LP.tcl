inherit CometToolBox_GDD_LM_LP Logical_presentation

#___________________________________________________________________________________________________________________________________________
method CometToolBox_GDD_LM_LP constructor {name descr args} {
 this inherited $name $descr
# Adding some physical presentations 
 this Add_PM_factories [Generate_factories_for_PM_type [list \
                                                       ] $objName]

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometToolBox_GDD_LM_LP [P_L_methodes_set_CometToolBox_GDD] {} {$this(L_actives_PM)}
Methodes_get_LC CometToolBox_GDD_LM_LP [P_L_methodes_get_CometToolBox_GDD] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_set_CometToolBox_GDD_COMET_RE {} {return [list {set_gdd_port {v}} {Select_node {n}}]}
Generate_LM_setters CometToolBox_GDD_LM_LP [P_L_methodes_set_CometToolBox_GDD_COMET_RE]

#___________________________________________________________________________________________________________________________________________


