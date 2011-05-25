inherit CometInstantMessenger_CFC CommonFC

#___________________________________________________________________________________________________________________________________________
method CometInstantMessenger_CFC constructor {} {
 set this(file_config) {}
}
#___________________________________________________________________________________________________________________________________________
Generate_accessors CometInstantMessenger_CFC [list file_config]

#___________________________________________________________________________________________________________________________________________
method CometInstantMessenger_CFC get_available_protocols {} {}
method CometInstantMessenger_CFC Send_msg {id msg} {}
method CometInstantMessenger_CFC Msg_received {id msg} {}
method CometInstantMessenger_CFC Connect_to {protocol D_infos} {}
method CometInstantMessenger_CFC Search_for {user_canal_descr} {}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_get_CometInstantMessenger {} {return [list {get_file_config { }} {get_available_protocols {}} {Send_msg {id msg}} {Msg_received {id msg}} {Connect_to {protocol D_infos}} {Search_for {user_canal_descr}} ]}
proc P_L_methodes_set_CometInstantMessenger {} {return [list {set_file_config {v}} ]}

