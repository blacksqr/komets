inherit CometInstantMessenger_LM_FC Logical_model

#___________________________________________________________________________________________________________________________________________
method CometInstantMessenger_LM_FC constructor {name descr args} {
 this inherited $name $descr
# Adding some physical presentations 
 this set_PM_active [CPool get_a_comet CometInstantMessenger_PM_FC_IRC]

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometInstantMessenger_LM_FC [P_L_methodes_set_CometInstantMessenger] {} {$this(L_actives_PM)}
Methodes_get_LC CometInstantMessenger_LM_FC [P_L_methodes_get_CometInstantMessenger] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_set_CometInstantMessenger_COMET_RE_FC {} {return [list {get_available_protocols {}} {Send_msg {id msg}} {Msg_received {id msg}} {Connect_to {protocol D_infos}} {Search_for {user_canal_descr}}]}
Generate_LM_setters CometInstantMessenger_LM_FC [P_L_methodes_set_CometInstantMessenger_COMET_RE_FC]

#___________________________________________________________________________________________________________________________________________


