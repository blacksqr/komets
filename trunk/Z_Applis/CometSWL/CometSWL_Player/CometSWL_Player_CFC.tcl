inherit CometSWL_Player_CFC CommonFC

#___________________________________________________________________________________________________________________________________________
method CometSWL_Player_CFC constructor {} {
 set this(player_name)  {}
 set this(player_color) {}
 set this(L_ships)      {}
}
#___________________________________________________________________________________________________________________________________________
Generate_accessors CometSWL_Player_CFC [list player_name player_color]
Generate_List_accessor CometSWL_Player_CFC L_ships L_ships

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_get_CometSWL_Player {} {return [list {get_player_name { }} {get_player_color { }} {get_L_ships { }} ]}
proc P_L_methodes_set_CometSWL_Player {} {return [list {set_player_name {v}} {set_player_color {v}} {set_L_ships {v}} {Add_L_ships {v}} {Sub_L_ships {v}} ]}

