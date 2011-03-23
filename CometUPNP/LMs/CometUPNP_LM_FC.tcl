inherit CometUPNP_LM_FC Logical_model

#___________________________________________________________________________________________________________________________________________
method CometUPNP_LM_FC constructor {name descr args} {
 this inherited $name $descr
 
# Adding some physical presentations 
 set PM [CPool get_a_unique_name]; CometUPNP_PM_FC_intelbased $PM "UPNP server" "UPNP based on thread, sockets and intel stack"; this set_PM_active $PM

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometUPNP_LM_FC [P_L_methodes_set_CometUPNP] {} {$this(L_actives_PM)}
Methodes_get_LC CometUPNP_LM_FC [P_L_methodes_get_CometUPNP] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_set_CometUPNP_COMET_FC_RE {} {return [list {M-SEARCH {ST}} {set_dict_devices {v}} {remove_item_of_dict_devices {UDN}} {set_item_of_dict_devices {keys val}}]}
Generate_LM_setters CometUPNP_LM_FC [P_L_methodes_set_CometUPNP_COMET_FC_RE]

#___________________________________________________________________________________________________________________________________________


