inherit CometUPNP_CFC CommonFC

#___________________________________________________________________________________________________________________________________________
method CometUPNP_CFC constructor {} {
 set this(dict_devices) {}
}
#___________________________________________________________________________________________________________________________________________
Generate_accessors CometUPNP_CFC [list dict_devices]
Generate_dict_accessors CometUPNP_CFC dict_devices

#___________________________________________________________________________________________________________________________________________
method CometUPNP_CFC exec_service {} {}
method CometUPNP_CFC device_appear {} {}
method CometUPNP_CFC device_disappear {} {}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_get_CometUPNP {} {return [list {get_dict_devices { }} {exec_service {}} {device_appear {}} {device_disappear {}} ]}
proc P_L_methodes_set_CometUPNP {} {return [list {set_dict_devices {v}} ]}

