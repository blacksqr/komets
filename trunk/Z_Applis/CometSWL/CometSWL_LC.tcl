inherit CometSWL Logical_consistency

#___________________________________________________________________________________________________________________________________________
method CometSWL constructor {name descr args} {
 this inherited $name $descr
 this set_GDD_id CT_CometSWL

# set up internal COMET graph
 set this(inter_SWL)              [CPool get_a_comet CometInterleaving -set_name "SWL top interleaving" -Add_style_class "inter_SWL"]
   set this(cont_edition)         [CPool get_a_comet CometContainer    -set_name "Edition Container" -Add_style_class "CONT EDITION edition cont cont_edition"]
     set this(cont_ops_edition)   [CPool get_a_comet CometContainer    -set_name "Operations" -Add_style_class "CONT OP_EDITION edition cont cont_edition"]
	 set this(cont_op_planets)    [CPool get_a_comet CometContainer    -set_name "Planets operations" -Add_style_class "CONT OP OPERATIONS PLANET cont_op_planets"]
	   set this(act_add_planet)   [CPool get_a_comet CometActivator    -set_name "Add a planet" -Add_style_class "ACT ADD PLANET act_add_planet add planet add_planet" -set_text "Add planet"]
	   set this(act_sub_planet)   [CPool get_a_comet CometActivator    -set_name "Sub a planet" -Add_style_class "ACT SUB PLANET act_sub_planet sub planet sub_planet" -set_text "Sub planet"]
	 set this(cont_op_ships)      [CPool get_a_comet CometContainer    -set_name "Ships operations" -Add_style_class "CONT OP OPERATIONS SHIP cont_op_ships"]
	   set this(act_add_ship)     [CPool get_a_comet CometActivator    -set_name "Add a ship" -Add_style_class "ACT ADD SHIP act_add_ship add ship add_ship"  -set_text "Add ship"]
	   set this(act_sub_ship)     [CPool get_a_comet CometActivator    -set_name "Sub a ship" -Add_style_class "ACT SUB SHIP act_sub_ship sub ship sub_ship"  -set_text "Sub ship"]
	 set this(cont_op_players)    [CPool get_a_comet CometContainer    -set_name "Players container" -Add_style_class "CONT OPERATIONS OP_PLAYER cont_op_players"]
	   set this(op_players)       [CPool get_a_comet CometContainer    -set_name "Players operations" -Add_style_class "PLAYER PLAYERS op_players"]
	     set this(act_add_player) [CPool get_a_comet CometActivator    -set_name "Add a player" -Add_style_class "ACT ADD PLAYER act_add_player add player add_player"   -set_text "Add player"]
	     set this(act_sub_player) [CPool get_a_comet CometActivator    -set_name "Sub a player" -Add_style_class "ACT SUB PLAYER act_sub_player sub player sub_player"   -set_text "Sub player"]
	   set this(cont_players)     [CPool get_a_comet CometContainer    -set_name "Set of players" -Add_style_class "CONT PLAYERS PLAYER cont_players"]
   set this(cont_game)            [CPool get_a_comet CometContainer    -set_name "Play container" -Add_style_class "CONT GAME game cont cont_game"]
     set this(act_fire)           [CPool get_a_comet CometActivator    -set_name "Fire missiles" -Add_style_class "act_fire" -set_text "Fire!"]
   set this(cont_op_space)        [CPool get_a_comet CometContainer    -set_name "Space container" -Add_style_class "ROOT ALL SPACE cont_op_space"]
     set this(op_space)           [CPool get_a_comet CometContainer    -set_name "Space operations" -Add_style_class "CONT OP_SPACE op_space"]
	   set this(new_space)        [CPool get_a_comet CometActivator    -set_name "New space" -Add_style_class "ACT NEW SPACE new new_space"   -set_text "New space"]
	   set this(load_space)       [CPool get_a_comet CometActivator    -set_name "Load space" -Add_style_class "ACT LOAD SPACE load load_space" -set_text "Load space"]
	   set this(save_space)       [CPool get_a_comet CometActivator    -set_name "Save space" -Add_style_class "ACT SAVE SPACE save save_space" -set_text "Save space"]
	 set this(cont_space)         [CPool get_a_comet CometContainer    -set_name "Space" -Add_style_class "CONT SPACE cont space cont_space"]
	 
 $this(inter_SWL)           Add_daughters_R [list $this(cont_edition)   $this(cont_game)     ]
   $this(cont_game)         Add_daughters_R [list $this(cont_space)     $this(act_fire)      ]
   $this(cont_edition)      Add_daughters_R [list $this(cont_space)     $this(cont_ops_edition)]
    $this(cont_ops_edition) Add_daughters_R [list $this(op_space)        $this(cont_op_planets) $this(cont_op_ships) $this(cont_op_players)]
     $this(cont_op_players) Add_daughters_R [list $this(op_players)     $this(cont_players)  ]
	   $this(op_players)    Add_daughters_R [list $this(act_sub_player) $this(act_add_player)]
     $this(cont_op_ships)   Add_daughters_R [list $this(act_sub_ship)   $this(act_add_ship)  ]
	 $this(cont_op_planets) Add_daughters_R [list $this(act_sub_planet) $this(act_add_planet)]
     $this(op_space)        Add_daughters_R [list $this(new_space)      $this(load_space)      $this(save_space)]
# set up actions
 $this(act_add_player) Subscribe_to_activate $objName "Eval_in_context \$type $objName Add_a_player \\\$player"          UNIQUE
 $this(act_sub_player) Subscribe_to_activate $objName "Eval_in_context \$type $objName Sub_a_player \\\$player"          UNIQUE
 $this(act_add_ship)   Subscribe_to_activate $objName "Eval_in_context \$type $objName Add_a_ship   \\\$player \\\$ship" UNIQUE
 $this(act_sub_ship)   Subscribe_to_activate $objName "Eval_in_context \$type $objName Sub_a_ship   \\\$ship"            UNIQUE
 $this(act_add_planet) Subscribe_to_activate $objName "Eval_in_context \$type $objName Add_a_planet \\\$planet; Eval_in_context \$type \\\$planet set_R \\\$ray"          UNIQUE
 $this(act_sub_planet) Subscribe_to_activate $objName "Eval_in_context \$type $objName Sub_a_planet \\\$planet"          UNIQUE

 $this(new_space)      Subscribe_to_activate $objName "$objName New_space"
 $this(load_space)     Subscribe_to_activate $objName "Eval_in_context \$type $objName Load_space \\\$root"
 $this(save_space)     Subscribe_to_activate $objName "Eval_in_context \$type $objName Save_space \\\$root"
 
 $this(act_fire)       Subscribe_to_activate $objName "$objName Fire"
 
# set up internal graph
 this Add_composing_comet [CSS++ cr "#$this(inter_SWL), #$this(inter_SWL) *"]
 this set_handle_composing_comet $this(inter_SWL)
 this set_handle_comet_daughters $this(inter_SWL) ""
 this Add_daughter               $this(inter_SWL)
 
# set up other facets
 set CFC ${objName}_CFC; CometSWL_CFC $CFC; this set_Common_FC $CFC

 set this(LM_LP) ${objName}_LM_LP
 CometSWL_LM_LP $this(LM_LP) $this(LM_LP) "The LM LP of $name"
   this Add_LM $this(LM_LP)
 set this(LM_FC) ${objName}_LM_FC
 CometSWL_LM_FC $this(LM_FC) $this(LM_FC) "The LM FC of $name"
   this Add_LM $this(LM_FC)

   this set_default_op_gdd_file    [Comet_files_root]Comets/CSS_STYLESHEETS/GDD/Common_GDD_requests.css++
   this set_default_css_style_file [Comet_files_root]Comets/CSS_STYLESHEETS/SWL/drag_drop.css++


 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometSWL dispose {} {this inherited}

Generate_accessors CometSWL [list inter_SWL cont_edition cont_op_planets act_add_planet act_sub_planet cont_op_ships act_add_ship act_sub_ship \
                                  cont_op_players op_players act_add_ship act_sub_ship cont_game act_fire cont_op_space op_space new_space \
								  load_space save_space cont_space \
							]

#___________________________________________________________________________________________________________________________________________
method CometSWL Erase_space {} {
 foreach P [this get_L_players] {
   foreach S [$P get_L_ships] {
     this Sub_a_ship $S
    }
  }
 foreach P [this get_L_planets] {this Sub_a_planet $P}
}

#___________________________________________________________________________________________________________________________________________
method CometSWL New_space {} {
 this Erase_space
}

#___________________________________________________________________________________________________________________________________________
method CometSWL Load_space {f_name} {
 this Erase_space
}

#___________________________________________________________________________________________________________________________________________
method CometSWL Save_space {f_name} {

}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometSWL [P_L_methodes_set_CometSWL] {$this(FC)} {$this(L_LM)}
Methodes_get_LC CometSWL [P_L_methodes_get_CometSWL] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method CometSWL Add_a_player {C} {
 this Add_L_players $C
 $this(cont_players) Add_daughters_R $C
 $C set_name "A player"
}

#___________________________________________________________________________________________________________________________________________
method CometSWL Sub_a_player {C} {
 if {[lsearch [this get_L_players] $C] != -1} {
   this Sub_L_players $C
   foreach S [$C get_L_ships] {$S dispose}
   $C dispose
  }
}

#___________________________________________________________________________________________________________________________________________
method CometSWL Add_a_planet {C} {
 this Add_L_planets $C
 $this(cont_space) Add_daughters_R $C
 foreach PM [CSS++ cr "#${C}->PMs \\<--< CONT.GAME/"   ] {$PM set_mode "game"}
 foreach PM [CSS++ cr "#${C}->PMs \\<--< CONT.EDITION/"] {$PM set_mode "edition"}
 $C set_name "A planet"
}

#___________________________________________________________________________________________________________________________________________
method CometSWL Sub_a_planet {C} {
 if {[lsearch [this get_L_planets] $C] != -1} {
   this Sub_L_planets $C
   $C dispose
  }
}

#___________________________________________________________________________________________________________________________________________
method CometSWL Add_a_ship   {CP CS} {
 $CP Add_L_ships $CS
 $this(cont_space) Add_daughters_R $CS
 $CS set_player  $CP
 foreach PM [CSS++ cr "#${CS}->PMs \\<--< CONT.GAME/"   ] {$PM set_mode "game"}
 foreach PM [CSS++ cr "#${CS}->PMs \\<--< CONT.EDITION/"] {$PM set_mode "edition"}
 $CS set_name "A ship of player [$CP get_name]"
}

#___________________________________________________________________________________________________________________________________________
method CometSWL Sub_a_ship   {C} {
 if {[lsearch [gmlObject info classes $C] CometSWL_Ship] != -1} {
   [$C get_player] Sub_L_ships $C
   $C dispose
  } else {puts "ERROR in $objName Sub_a_ship $C:\n$C is not a ship"}
}

#___________________________________________________________________________________________________________________________________________
method CometSWL Add_a_missile {M} {
 this Add_L_missiles $M
 $this(cont_space) Add_daughters_R $M
 $M set_name "A missile"
}

#___________________________________________________________________________________________________________________________________________
method CometSWL Sub_a_missile {M} {
 this Sub_L_missiles $M
 $M dispose
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Manage_CallbackList CometSWL [list Add_a_player Sub_a_player Add_a_planet Sub_a_planet Add_a_ship Sub_a_ship] end