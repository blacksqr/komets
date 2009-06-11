inherit CometSWL_Missile_LM_LP Logical_presentation

#___________________________________________________________________________________________________________________________________________
method CometSWL_Missile_LM_LP constructor {name descr args} {
 this inherited $name $descr
# Adding some physical presentations 
 this Add_PM_factories [Generate_factories_for_PM_type [list {CometSWL_Missile_PM_P_B207_basic Ptf_BIGre} \
															 {CometSWL_Missile_PM_P_SVG_basic Ptf_SVG}    \
                                                       ] $objName]

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometSWL_Missile_LM_LP [P_L_methodes_set_CometSWL_Missile] {} {$this(L_actives_PM)}
Methodes_get_LC CometSWL_Missile_LM_LP [P_L_methodes_get_CometSWL_Missile] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_set_CometSWL_Missile_COMET_RE {} {return [list {set_X {v}} {set_Y {v}} {set_VX {v}} {set_VY {v}} {set_ship {v}}]}
Generate_LM_setters CometSWL_Missile_LM_LP [P_L_methodes_set_CometSWL_Missile_COMET_RE]

#___________________________________________________________________________________________________________________________________________


