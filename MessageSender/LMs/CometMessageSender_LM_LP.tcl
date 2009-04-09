#___________________________________________ Définition of Logical Model of présentation ___________________________________________________
inherit CometMessageSender_LM_LP Logical_presentation

#___________________________________________________________________________________________________________________________________________
method CometMessageSender_LM_LP constructor {name descr args} {
 this inherited $name $descr
 
# Adding some physical presentations
 this Add_PM_factories [Generate_factories_for_PM_type [list  {CometMessageSender_PM_P_U Ptf_ALL}      \
                                                       ] $objName]

 
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometMessageSender_LM_LP [P_L_methodes_set_CometMessageSender] {} {$this(L_actives_PM)}
Methodes_get_LC CometMessageSender_LM_LP [P_L_methodes_get_CometMessageSender] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_set_CometMessageSender_COMET_RE {} {return [list {set_destination {v}} {set_subject {v}} {set_message {v}} {send_message {}}]}
  Generate_LM_setters CometMessageSender_LM_LP [P_L_methodes_set_CometMessageSender_COMET_RE]
#___________________________________________________________________________________________________________________________________________
Manage_CallbackList CometMessageSender_LM_LP [list prim_set_destination prim_set_subject prim_set_message prim_send_message] begin

#___________________________________________________________________________________________________________________________________________
method CometMessageSender_LM_LP set_PM_active {PM} {
 this inherited $PM
 if {[string equal [this get_LC] {}]} {return}
 $PM set_destination [this get_destination]
 $PM set_subject     [this get_subject]
 $PM set_message     [this get_message]
}

