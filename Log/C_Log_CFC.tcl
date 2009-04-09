#_______________________________________________________________________________________#
inherit CommonFC_Log CommonFC

method CommonFC_Log constructor {} {
 this inherited
 set this(id)   {}
 set this(pass) {}
 set this(L_valid_id_pass) {}
}

#_______________________________________________________________________________________#
Generate_accessors     CommonFC_Log [list id pass]
Generate_List_accessor CommonFC_Log L_valid_id_pass L_valid_id_pass

#_______________________________________________________________________________________#
method CommonFC_Log Is_validated {} {
 foreach id_pass $this(L_valid_id_pass) {
   if {[string equal $this(id) [lindex $id_pass 0]] && [string equal $this(pass) [lindex $id_pass 1]]} {
    return 1}
  }
 return 0
}

#_______________________________________________________________________________________#
method CommonFC_Log Reset {} {
 set this(id)   {}
 set this(pass) {}
}

#_______________________________________________________________________________________#
#__________________________ Adding the activator functions _____________________________#
#_______________________________________________________________________________________#
proc L_methodes_get_Log {} {return [list {get_id { }} {get_pass { }} {get_L_valid_id_pass { }} {Is_validated { }} ]}
proc L_methodes_set_Log {} {return [list {set_id {v}} {set_pass {v}} {set_L_valid_id_pass {L}} {Reset {}} {Add_L_valid_id_pass {L}} {Sub_L_valid_id_pass {L}} ]}

