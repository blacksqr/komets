inherit CometSWL_Player Logical_consistency

#___________________________________________________________________________________________________________________________________________
method CometSWL_Player constructor {name descr args} {
 this inherited $name $descr
 this set_GDD_id CT_CometSWL_Player

 set CFC ${objName}_CFC; CometSWL_Player_CFC $CFC; this set_Common_FC $CFC

 set this(LM_LP) ${objName}_LM_LP
 CometSWL_Player_LM_LP $this(LM_LP) $this(LM_LP) "The LM LP of $name"
   this Add_LM $this(LM_LP)
 
 this Subscribe_to_set_player_name $objName "$objName set_name \[$objName get_player_name\]"
 
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Player dispose {} {this inherited}
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometSWL_Player [P_L_methodes_set_CometSWL_Player] {$this(FC)} {$this(L_LM)}
Methodes_get_LC CometSWL_Player [P_L_methodes_get_CometSWL_Player] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Manage_CallbackList CometSWL_Player [list set_player_color set_player_name] end

#___________________________________________________________________________________________________________________________________________
method CometSWL_Player set_name {n} {
 this inherited $n
 foreach S [this get_L_ships] {
   $S set_name "A ship of player $n"
  }
}