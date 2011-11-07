inherit CometUPNP_CFC CommonFC

#___________________________________________________________________________________________________________________________________________
method CometUPNP_CFC constructor {} {
 set this(dict_devices) {}
}
#___________________________________________________________________________________________________________________________________________
Generate_accessors CometUPNP_CFC [list dict_devices]
Generate_dict_accessors CometUPNP_CFC dict_devices

#___________________________________________________________________________________________________________________________________________
method CometUPNP_CFC get_devices_UDN  {} {
 set L [list]
 foreach {u v} $this(dict_devices) {lappend L $u}
 return $L
}

#___________________________________________________________________________________________________________________________________________
method CometUPNP_CFC get_children_attributes {keys} {
 set L [list]
 foreach {u v} [this get_item_of_dict_devices $keys] {lappend L $u}
 return $L
}

#___________________________________________________________________________________________________________________________________________
method CometUPNP_CFC soap_call {UDN service action L_params CB} {}

#___________________________________________________________________________________________________________________________________________
method CometUPNP_CFC device_appear    {} {}
method CometUPNP_CFC device_disappear {} {}
method CometUPNP_CFC M-SEARCH         {ST} {}

method CometUPNP_CFC Do_a_SSDP_M-SEARCH {} {}

#___________________________________________________________________________________________________________________________________________
method CometUPNP_CFC Subscribe_to_UPNP_events   {UDN service_id ID_subscribe CB} {}
method CometUPNP_CFC UnSubscribe_to_UPNP_events {UDN service_id ID_subscribe}    {}

#___________________________________________________________________________________________________________________________________________
method CometUPNP_CFC Add_eventing_CB    {UDN service_id ID_subscribe CB} {}
method CometUPNP_CFC Remove_eventing_CB {UDN service_id ID_subscribe}    {}

#___________________________________________________________________________________________________________________________________________
proc P_CometUPNP_CFC__eval_cond {D D_name L_var cond} {
	if {$cond == ""} {return 1}
	foreach var $L_var {
		 if {![dict exists $D $var]} {return 0}
		 set $var [dict get $D $var]
		}
	return [expr $cond]
}

#___________________________________________________________________________________________________________________________________________
method CometUPNP_CFC get_service_having_variable {UDN var_name} {
	dict for {SRV SRV_descr} [dict get $this(dict_devices) $UDN ServiceList] {
		 dict for {VAR VAR_descr} [dict get $SRV_descr stateVariables] {
			 if {$VAR == $var_name} {return $SRV}
			}
		}
		
	return ""
}

#___________________________________________________________________________________________________________________________________________
method CometUPNP_CFC Search_UDN_service_action {L_cond_UDN L_cond_SRV L_cond_ACT} {
	set L_rep [list]
	
	lassign $L_cond_UDN L_var_UDN cond_UDN
	lassign $L_cond_SRV L_var_SRV cond_SRV
	lassign $L_cond_ACT L_var_ACT cond_ACT
	
	dict for {UDN UDN_descr} $this(dict_devices) {
		 if {[P_CometUPNP_CFC__eval_cond $UDN_descr $UDN $L_var_UDN $cond_UDN]} {
			 dict for {SRV SRV_descr} [dict get $UDN_descr ServiceList] {
				 if {[P_CometUPNP_CFC__eval_cond $SRV_descr $SRV $L_var_SRV $cond_SRV]} {
					 dict for {ACT ACT_descr} [dict get $SRV_descr actions] {
						 if {[P_CometUPNP_CFC__eval_cond $ACT_descr $ACT $L_var_ACT $cond_ACT]} {lappend L_rep [list $UDN $SRV $ACT]}
						}
					}
				}
			}
		}
		
	return $L_rep
}

#___________________________________________________________________________________________________________________________________________
method CometUPNP_CFC CometUPNP_Read_variable_from_xml {str_xml str_var} {
 set rep ""
 set doc [dom parse [string trim $str_xml]]
	set root [$doc documentElement]; set ns_root [$root namespace]
	foreach res [$root selectNodes -namespace [list ns $ns_root] "//ns:property/$str_var"] {
		 set rep [$res text]
		}
 $doc delete
 
 return $rep
}


#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_get_CometUPNP {} {return [list {get_service_having_variable {UDN var_name}} {CometUPNP_Read_variable_from_xml {str_xml str_var}} {Search_UDN_service_action {L_cond_UDN L_cond_SRV L_cond_ACT}} {get_dict_devices { }} {get_item_of_dict_devices {keys}} {get_devices_UDN {}} {get_children_attributes {keys}} ]}
proc P_L_methodes_set_CometUPNP {} {return [list {Do_a_SSDP_M-SEARCH {}} {M-SEARCH {ST}} {UnSubscribe_to_UPNP_events {UDN service_id ID_subscribe}} {Subscribe_to_UPNP_events {UDN service_id ID_subscribe CB}} {Remove_eventing_CB {UDN service_id ID_subscribe}} {soap_call {UDN service action L_params CB}} {set_dict_devices {v}} {remove_item_of_dict_devices {UDN}} {set_item_of_dict_devices {keys val}} ]}

