inherit CometSWL_CFC CommonFC

#___________________________________________________________________________________________________________________________________________
method CometSWL_CFC constructor {} {
 set this(G)          1
 set this(mode)       {}
 set this(L_players)  {}
 set this(L_planets)  {}
 set this(L_missiles) {}
}

#___________________________________________________________________________________________________________________________________________
Generate_accessors CometSWL_CFC [list mode G]
Generate_List_accessor CometSWL_CFC L_players  L_players
Generate_List_accessor CometSWL_CFC L_planets  L_planets
Generate_List_accessor CometSWL_CFC L_missiles L_missiles

#___________________________________________________________________________________________________________________________________________
method CometSWL_CFC Fire {} {}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_get_CometSWL {} {return [list {get_G { }} {get_mode { }} {get_L_players { }} {get_L_planets { }} {get_L_missiles { }} ]}
proc P_L_methodes_set_CometSWL {} {return [list {set_G {v}} {set_mode {v}} {Fire {}} {set_L_players {v}} {Add_L_players {v}} {Sub_L_players {v}} {set_L_planets {v}} {Add_L_planets {v}} {Sub_L_planets {v}} {set_L_missiles {v}} {Add_L_missiles {v}} {Sub_L_missiles {v}} ]}

