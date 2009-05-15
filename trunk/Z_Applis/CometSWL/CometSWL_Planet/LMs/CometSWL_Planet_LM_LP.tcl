inherit CometSWL_Planet_LM_LP Logical_presentation

#___________________________________________________________________________________________________________________________________________
method CometSWL_Planet_LM_LP constructor {name descr args} {
 this inherited $name $descr
# Adding some physical presentations 
 this Add_PM_factories [Generate_factories_for_PM_type [list {CometSWL_Planet_PM_P_B207_basic Ptf_BIGre} \
															 {CometSWL_Planet_PM_P_SVG_basic Ptf_SVG} \
                                                       ] $objName]

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometSWL_Planet_LM_LP [P_L_methodes_set_CometSWL_Planet] {} {$this(L_actives_PM)}
Methodes_get_LC CometSWL_Planet_LM_LP [P_L_methodes_get_CometSWL_Planet] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_set_CometSWL_Planet_COMET_RE {} {return [list {set_R {v}} {set_X {v}} {set_Y {v}} {set_density {v}} {set_mode {v}}]}
Generate_LM_setters CometSWL_Planet_LM_LP [P_L_methodes_set_CometSWL_Planet_COMET_RE]

