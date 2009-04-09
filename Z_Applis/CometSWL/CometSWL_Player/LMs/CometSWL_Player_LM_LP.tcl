inherit CometSWL_Player_LM_LP Logical_presentation

#___________________________________________________________________________________________________________________________________________
method CometSWL_Player_LM_LP constructor {name descr args} {
 this inherited $name $descr
# Adding some physical presentations 
 this Add_PM_factories [Generate_factories_for_PM_type [list {CometSWL_Player_PM_P_U_basic Ptf_ALL} \
                                                       ] $objName]

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometSWL_Player_LM_LP [P_L_methodes_set_CometSWL_Player] {} {$this(L_actives_PM)}
Methodes_get_LC CometSWL_Player_LM_LP [P_L_methodes_get_CometSWL_Player] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_set_CometSWL_Player_COMET_RE {} {return [list {set_player_name {v}} {set_player_color {v}} {set_L_ships {v}} {Add_L_ships {v}} {Sub_L_ships {v}}]}
Generate_LM_setters CometSWL_Player_LM_LP [P_L_methodes_set_CometSWL_Player_COMET_RE]

#___________________________________________________________________________________________________________________________________________


