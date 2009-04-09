inherit CometSWL_LM_LP Logical_presentation

#___________________________________________________________________________________________________________________________________________
method CometSWL_LM_LP constructor {name descr args} {
 this inherited $name $descr
# Adding some physical presentations 
 this Add_PM_factories [Generate_factories_for_PM_type [list {CometSWL_PM_P_U_basic Ptf_ALL} \
                                                       ] $objName]

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometSWL_LM_LP [P_L_methodes_set_CometSWL] {} {$this(L_actives_PM)}
Methodes_get_LC CometSWL_LM_LP [P_L_methodes_get_CometSWL] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_set_CometSWL_COMET_RE {} {return [list {set_mode {v}}]}
Generate_LM_setters CometSWL_LM_LP [P_L_methodes_set_CometSWL_COMET_RE]

#___________________________________________________________________________________________________________________________________________


