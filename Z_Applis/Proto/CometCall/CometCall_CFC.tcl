inherit CometCall_CFC CommonFC

#___________________________________________________________________________________________________________________________________________
method CometCall_CFC constructor {} {
 set this(name)    {Doctor Mabuse}
 set this(adresse) "7th, TrucStreet"
 set this(contact) {Call : 06-78-83-93-02}
}
#___________________________________________________________________________________________________________________________________________
Generate_accessors CometCall_CFC [list name adresse contact]

#___________________________________________________________________________________________________________________________________________
method CometCall_CFC Call {} {}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_get_CometCall {} {return [list {get_name { }} {get_adresse { }} {get_contact { }} {Call {}} ]}
proc P_L_methodes_set_CometCall {} {return [list {set_name {v}} {set_adresse {v}} {set_contact {v}} ]}

