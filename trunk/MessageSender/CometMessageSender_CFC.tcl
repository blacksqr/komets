
#__________________________________________________
inherit CometMessageSender_CFC CommonFC

#______________________________________________________
method CometMessageSender_CFC constructor {} {
 set this(destination) ""
 set this(subject)     ""
 set this(message)     ""
}

#______________________________________________________
Generate_accessors CometMessageSender_CFC [list destination subject message]

#______________________________________________________
method CometMessageSender_CFC Compute_travel {} {}

#______________________________________________________
method CometMessageSender_CFC send_message {} {}

#__________________________________________________
proc P_L_methodes_get_CometMessageSender {} {return [list {get_destination { }} {get_subject { }} {get_message { }}  ]}
proc P_L_methodes_set_CometMessageSender {} {return [list {set_destination {v}} {set_subject {v}} {set_message {v}} {send_message {}} ]}
