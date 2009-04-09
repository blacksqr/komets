inherit CometSWL_Ship_LM_LP Logical_presentation

#___________________________________________________________________________________________________________________________________________
method CometSWL_Ship_LM_LP constructor {name descr args} {
 this inherited $name $descr
# Adding some physical presentations 
 this Add_PM_factories [Generate_factories_for_PM_type [list {CometSWL_Ship_PM_P_B207_basic Ptf_BIGre}\
                                                       ] $objName]

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometSWL_Ship_LM_LP [P_L_methodes_set_CometSWL_Ship] {} {$this(L_actives_PM)}
Methodes_get_LC CometSWL_Ship_LM_LP [P_L_methodes_get_CometSWL_Ship] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_set_CometSWL_Ship_COMET_RE {} {return [list {set_X {v}} {set_Y {v}} {set_player {v}} {set_power {v}} {set_angle {v}} ]}
Generate_LM_setters CometSWL_Ship_LM_LP [P_L_methodes_set_CometSWL_Ship_COMET_RE]

#___________________________________________________________________________________________________________________________________________


