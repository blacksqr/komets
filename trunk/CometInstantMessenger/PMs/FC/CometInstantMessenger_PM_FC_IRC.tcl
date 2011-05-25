#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#_______________________________________________ Définition of the IRC functionnal core ____________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit CometInstantMessenger_PM_FC_IRC Physical_model

#___________________________________________________________________________________________________________________________________________
method CometInstantMessenger_PM_FC_IRC constructor {name descr args} {
 this inherited $name $descr
    
 package require irc
 set this(IRC_connection) [::irc::connection]
 
 # Terminate with configuration's parameters
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometInstantMessenger_PM_FC_IRC [P_L_methodes_set_CometInstantMessenger] {} {$this(L_actives_PM)}
Methodes_get_LC CometInstantMessenger_PM_FC_IRC [P_L_methodes_get_CometInstantMessenger] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_LM_setters CometInstantMessenger_PM_FC_IRC [P_L_methodes_set_CometInstantMessenger_COMET_RE_FC]

# get_available_protocols {}} {Send_msg {id msg}} {Msg_received {id msg}} {Connect_to {protocol D_infos}} {Search_for {user_canal_descr}
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Inject_code CometInstantMessenger_PM_FC_IRC Connect_to {} {
	# {protocol D_infos}
	if {$protocol == "IRC"} {
		 if {![dict exists $D_infos host]} {error "Connect_to IRC with a dict having a host entry, port entry is optionnal"}
		 if {![dict exists $D_infos port]} {dict set D_infos port 6668}
		 lappend this(L_connection) [$this(IRC_connection) connect [dict get $D_infos host] [dict get $D_infos port]]
		}
}


