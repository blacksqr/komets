inherit CometInstantMessenger_LM_LP Logical_presentation

#___________________________________________________________________________________________________________________________________________
method CometInstantMessenger_LM_LP constructor {name descr args} {
 this inherited $name $descr
# Adding some physical presentations 
 this Add_PM_factories [Generate_factories_for_PM_type [list {CometInstantMessenger_PM_P_U_basic Ptf_ALL} \
                                                       ] $objName]

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometInstantMessenger_LM_LP [P_L_methodes_set_CometInstantMessenger] {} {$this(L_actives_PM)}
Methodes_get_LC CometInstantMessenger_LM_LP [P_L_methodes_get_CometInstantMessenger] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_set_CometInstantMessenger_COMET_RE_LP {} {return [list {get_available_protocols {}} {Send_msg {id msg}} {Msg_received {id msg}} {Connect_to {protocol D_infos}} {Search_for {user_canal_descr}}]}
Generate_LM_setters CometInstantMessenger_LM_LP [P_L_methodes_set_CometInstantMessenger_COMET_RE_LP]

#___________________________________________________________________________________________________________________________________________


