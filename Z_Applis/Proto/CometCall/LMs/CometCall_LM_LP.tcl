inherit CometCall_LM_LP Logical_presentation

#___________________________________________________________________________________________________________________________________________
method CometCall_LM_LP constructor {name descr args} {
 this inherited $name $descr
# Adding some physical presentations 
 this Add_PM_factories [Generate_factories_for_PM_type [list {CometCall_PM_P_TK_basic Ptf_TK} \
                                                       ] $objName]

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometCall_LM_LP [P_L_methodes_set_CometCall] {} {$this(L_actives_PM)}
Methodes_get_LC CometCall_LM_LP [P_L_methodes_get_CometCall] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_set_CometCall_COMET_RE {} {return [list {Call {}} {set_name {v}} {set_adresse {v}} {set_contact {v}}]}
Generate_LM_setters CometCall_LM_LP [P_L_methodes_set_CometCall_COMET_RE]

#___________________________________________________________________________________________________________________________________________


