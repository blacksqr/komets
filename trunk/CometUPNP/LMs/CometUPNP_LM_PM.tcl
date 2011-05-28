inherit CometUPNP_LM_LP Logical_model

#___________________________________________________________________________________________________________________________________________
method CometUPNP_LM_LP constructor {name descr args} {
 this inherited $name $descr
# Adding some physical presentations 
 this Add_PM_factories [Generate_factories_for_PM_type [list {CometUPNP_PM_P_tk_tree Ptf_TK} \
                                                       ] $objName]

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometUPNP_LM_LP [P_L_methodes_set_CometUPNP] {} {$this(L_actives_PM)}
Methodes_get_LC CometUPNP_LM_LP [P_L_methodes_get_CometUPNP] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_set_CometUPNP_COMET_RE_LP {} {return [list {Do_a_SSDP_M-SEARCH {}} {set_dict_devices {}} {soap_call {UDN service action L_params CB}} {Add_eventing_CB {UDN service_id ID_subscribe CB}} {Remove_eventing_CB {UDN service_id ID_subscribe}}]}
Generate_LM_setters CometUPNP_LM_LP [P_L_methodes_set_CometUPNP_COMET_RE_LP]

#___________________________________________________________________________________________________________________________________________


