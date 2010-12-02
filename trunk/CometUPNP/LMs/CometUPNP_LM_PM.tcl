inherit CometUPNP_LM_PM Logical_model

#___________________________________________________________________________________________________________________________________________
method CometUPNP_LM_PM constructor {name descr args} {
 this inherited $name $descr
# Adding some physical presentations 
 this Add_PM_factories [Generate_factories_for_PM_type [list \
                                                       ] $objName]

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometUPNP_LM_PM [P_L_methodes_set_CometUPNP] {} {$this(L_actives_PM)}
Methodes_get_LC CometUPNP_LM_PM [P_L_methodes_get_CometUPNP] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_set_CometUPNP_COMET_RE {} {return [list {set_dict_devices {}}]}
Generate_LM_setters CometUPNP_LM_PM [P_L_methodes_set_CometUPNP_COMET_RE]

#___________________________________________________________________________________________________________________________________________


