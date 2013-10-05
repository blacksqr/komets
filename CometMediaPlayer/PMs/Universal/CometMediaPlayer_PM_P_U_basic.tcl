inherit CometMediaPlayer_PM_P_U_basic PM_U_Container

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometMediaPlayer_PM_P_U_basic constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id N_CometTravel_PM_P_U
   
   set this(is_updating_num_frame) 0
   
   # Nested COMET graph
   set this(cont_root)    [CPool get_a_comet CometContainer -Add_style_class [list CONTAINER ROOT]]
     set this(inter_file) [CPool get_a_comet CometInterleaving -set_name "Load medias" -Add_style_class [list INTERLEAVING COMMANDS FILE]]
		set this(cont_for_file) [CPool get_a_comet CometContainer -set_name "from upnp"  -Add_style_class [list CONTAINER CHOICE UPNP]]
		set this(cont_for_upnp) [CPool get_a_comet CometContainer -set_name "from files" -Add_style_class [list CONTAINER CHOICE FILE]]
		$this(inter_file) set_daughters_R [list $this(cont_for_file) $this(cont_for_upnp)]
     set this(inter_video) [CPool get_a_comet CometInterleaving -set_name "Video" -Add_style_class [list INTERLEAVING COMMANDS VIDEO]]
		set this(act_show_hide_video) [CPool get_a_comet CometActivator -set_name "Hide" -Add_style_class [list ACTIVATOR SHOW_HIDE]]
		$this(inter_video) set_daughters_R [list $this(act_show_hide_video)]
	 set this(cont_video) [CPool get_a_comet CometContainer -Add_style_class [list CONTAINER AUDIO VIDEO]]
	 set this(cont_controls) [CPool get_a_comet CometContainer -Add_style_class [list CONTAINER CONTROLS COMMANDS] -set_name "Commands of MediaPlayer"]
		set this(position)     [CPool get_a_comet CometChoiceN   -Add_style_class [list PARAM COMMAND GOTO]]
		set this(act_previous) [CPool get_a_comet CometActivator -set_text PREVIOUS -Add_style_class [list PARAM COMMAND PREVIOUS]]
		set this(act_next)     [CPool get_a_comet CometActivator -set_text NEXT     -Add_style_class [list PARAM COMMAND NEXT]]
		set this(act_play)     [CPool get_a_comet CometActivator -set_text PLAY     -Add_style_class [list PARAM COMMAND PLAY PAUSE]]
		set this(volume)       [CPool get_a_comet CometChoiceN   -Add_style_class [list PARAM COMMAND VOLUME]]
		$this(cont_controls) Add_daughters_R [list $this(position) $this(act_previous) $this(act_play) $this(act_next) $this(volume)]
	 set this(cont_playlist) [CPool get_a_comet CometContainer -Add_style_class [list CONTAINER PLAYLIST]  -set_name "Playlist"]
	 set this(cont_dght)     [CPool get_a_comet CometContainer -Add_style_class [list CONTAINER DAUGHTERS]]
	 
	 $this(cont_root) Add_daughters_R [list $this(inter_file) $this(inter_video) $this(cont_video) $this(cont_controls) $this(cont_playlist) $this(cont_dght)]
	 
   # Specify where are the handles 
   this set_L_nested_handle_LM    $this(cont_root)_LM_LP
   this set_L_nested_daughters_LM $this(cont_dght)_LM_LP

   # Subscribe to events...
   $this(act_show_hide_video) Subscribe_to_activate $objName "$objName Show_hide_video" UNIQUE
   
   $this(act_previous) Subscribe_to_activate $objName [list $objName prim_Previous] UNIQUE
   $this(act_next)     Subscribe_to_activate $objName [list $objName prim_Next    ] UNIQUE
   $this(act_play)     Subscribe_to_activate $objName "$objName prim_Play \[expr 1 - \[$objName is_playing\]\]" UNIQUE
   
   $this(volume)       Subscribe_to_set_val  $objName "$objName inner_set_volume \$v" UNIQUE
   $this(position)     Subscribe_to_set_val  $objName "$objName prim_go_to_frame \$v" UNIQUE
   
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometMediaPlayer_PM_P_U_basic dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometMediaPlayer_PM_P_U_basic [P_L_methodes_set_CometMediaPlayer] {} {}
Methodes_get_LC CometMediaPlayer_PM_P_U_basic [P_L_methodes_get_CometMediaPlayer] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters CometMediaPlayer_PM_P_U_basic [P_L_methodes_set_CometMediaPlayer_COMET_RE_P]

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometMediaPlayer_PM_P_U_basic set_LM {LM} {
	if {[this get_LM] != $LM && $LM != ""} {
		 set C_Video [[$LM get_LC] attribute C_Video]
		 $this(cont_video)    set_daughters_R $C_Video
		 $this(cont_playlist) set_daughters_R [[$LM get_LC] attribute C_list_medias]
		 set C [[$LM get_LC] attribute C_choice_media]
		 $this(cont_for_file) set_daughters_R $C; $this(cont_for_file) Add_MetaData TRIGGERABLE_ITEM "> $C"
		 $this(cont_for_upnp) set_daughters_R $C; $this(cont_for_upnp) Add_MetaData TRIGGERABLE_ITEM "> $C"
		}
	return [this inherited $LM]
}

#___________________________________________________________________________________________________________________________________________
method CometMediaPlayer_PM_P_U_basic inner_set_volume {v} {
	set min [$this(volume) get_b_inf]
	set max [$this(volume) get_b_sup]
	this prim_set_volume [expr int(255 * ($v - $min) / ($max - $min))]
}

#___________________________________________________________________________________________________________________________________________
method CometMediaPlayer_PM_P_U_basic Show_hide_video {} {
	if {[$this(act_show_hide_video) get_name] == "Hide"} {
		 $this(act_show_hide_video) set_name "Show"
		 $this(cont_video) set_daughters_R [list]
		} else {$this(act_show_hide_video) set_name "Hide"
		        $this(cont_video) set_daughters_R [[this get_LC] attribute C_Video]
			   }
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Inject_code CometMediaPlayer_PM_P_U_basic Play {} {
	if {$v} {
		 $this(act_play) set_text "PAUSE"
		} else {$this(act_play) set_text "PLAY"
			   }
}

#___________________________________________________________________________________________________________________________________________
Inject_code CometMediaPlayer_PM_P_U_basic Previous {} {

}

#___________________________________________________________________________________________________________________________________________
Inject_code CometMediaPlayer_PM_P_U_basic Next {} {

}

#___________________________________________________________________________________________________________________________________________
Inject_code CometMediaPlayer_PM_P_U_basic go_to_frame {} {
	if {$this(is_updating_num_frame)} {return}
	set this(is_updating_num_frame) 1
	if {[$this(position) get_val] != $v} {$this(position) set_val $v
										 }
	set this(is_updating_num_frame) 0
}

#___________________________________________________________________________________________________________________________________________
Inject_code CometMediaPlayer_PM_P_U_basic prim_go_to_frame {
	if {$this(is_updating_num_frame)} {return}
	set this(is_updating_num_frame) 1
} {set this(is_updating_num_frame) 0}

#___________________________________________________________________________________________________________________________________________
Inject_code CometMediaPlayer_PM_P_U_basic set_media_source {} {
	this prim_Play 0
	set C_video [[this get_LC] attribute C_Video]
	$this(position) configure set_b_sup [expr max(0, [$C_video get_video_nbFrames] - 1)] -set_val 0
}

