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

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_get_CometUPNP {} {return [list {get_dict_devices { }} {get_item_of_dict_devices {keys}} {get_devices_UDN {}} {get_children_attributes {keys}} ]}
proc P_L_methodes_set_CometUPNP {} {return [list {soap_call {UDN service action L_params CB}} {set_dict_devices {v}} {remove_item_of_dict_devices {v}} {set_item_of_dict_devices {keys val}} ]}

