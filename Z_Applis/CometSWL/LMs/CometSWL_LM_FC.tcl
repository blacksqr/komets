inherit CometSWL_LM_FC Logical_model

#___________________________________________________________________________________________________________________________________________
method CometSWL_LM_FC constructor {name descr args} {
 this inherited $name $descr
# Adding some physical presentations 
 
 set PM_basic [CPool get_a_comet CometSWL_PM_FC_basic]
 this Add_PM        $PM_basic
 this set_PM_active $PM_basic
 
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometSWL_LM_FC [P_L_methodes_set_CometSWL] {} {$this(L_actives_PM)}
Methodes_get_LC CometSWL_LM_FC [P_L_methodes_get_CometSWL] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_set_CometSWL_COMET_RE {} {return [list {set_mode {v}}]}
Generate_LM_setters CometSWL_LM_FC [P_L_methodes_set_CometSWL_COMET_RE]

#___________________________________________________________________________________________________________________________________________


