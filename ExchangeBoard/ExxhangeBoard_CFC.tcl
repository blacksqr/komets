#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit ExchangeBoard_CFC CommonFC

#___________________________________________________________________________________________________________________________________________
method ExchangeBoard_CFC constructor {} {
 set this(L_comets)    [list]
 set this(last_change) [clock clicks -milliseconds]
}

#___________________________________________________________________________________________________________________________________________
Generate_accessors ExchangeBoard_CFC [list L_comets last_change]

#___________________________________________________________________________________________________________________________________________
method ExchangeBoard_CFC Add_comets {L} {
 Add_list this(L_comets) $L
 set this(last_change) [clock clicks -milliseconds] 
}

#___________________________________________________________________________________________________________________________________________
method ExchangeBoard_CFC Sub_comets {L} {
 Sub_list this(L_comets) $L
 set this(last_change) [clock clicks -milliseconds]
}

#___________________________________________________________________________________________________________________________________________
method ExchangeBoard_CFC Remove_local_comets {L} {
 foreach c $L {
   $c set_mothers_R ""
  }
}

#___________________________________________________________________________________________________________________________________________
method ExchangeBoard_CFC Update {} {}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_get_ExchangeBoard {} {return [list {get_L_comets { }} {get_last_change { }}]}
proc P_L_methodes_set_ExchangeBoard {} {return [list {Remove_local_comets {L}} {set_L_comets {L}} {Add_comets {L}} {Sub_comets {L}} {Update {}}]}
