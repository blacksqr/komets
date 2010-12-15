inherit CometMediaPlayer Logical_consistency

#___________________________________________________________________________________________________________________________________________
method CometMediaPlayer constructor {name descr args} {
 this inherited $name $descr
 this set_GDD_id CT_CometMediaPlayer

 # Common functionnal core
 set CFC ${objName}_CFC; CometMediaPlayer_CFC $CFC; this set_Common_FC $CFC

 # List of Lofical models
 set this(LM_FC) ${objName}_LM_FC
 CometMediaPlayer_LM_FC $this(LM_FC) $this(LM_FC) "The LM FC of $name"
   this Add_LM $this(LM_FC)
 set this(LM_LP) ${objName}_LM_LP
 CometMediaPlayer_LM_LP $this(LM_LP) $this(LM_LP) "The LM LP of $name"
   this Add_LM $this(LM_LP)
   
 # Nested COMETs
 set this(C_Video)        [CPool get_a_comet CometVideo  -set_name "Video player" -Add_style_class [list PLAYER VIDEO]]
 set this(C_choice_media) [CPool get_a_comet CometChoice -set_name "Load media"   -Add_style_class [list CHOICE NEW MEDIA]]
 set this(C_list_medias)  [CPool get_a_comet CometChoice -set_name "Play list"    -Add_style_class [list LIST MEDIAS]]
 
 # Subscription
 $this(C_choice_media) Subscribe_to_set_currents $objName "$objName set_media_source \$lc" UNIQUE
 
 # Evaluate optionnal parameters
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometMediaPlayer dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometMediaPlayer [P_L_methodes_set_CometMediaPlayer] {$this(FC)} {$this(L_LM)}
Methodes_get_LC CometMediaPlayer [P_L_methodes_get_CometMediaPlayer] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Inject_code CometMediaPlayer Play {} {
	if {$v} {
		 $this(C_Video) Play
		} else {$this(C_Video) Pause}
}

#___________________________________________________________________________________________________________________________________________
Inject_code CometMediaPlayer set_media_source {} {
	if {[catch {$this(C_Video) set_video_source $v [this get_audio_channel]} err_video]} {
		 puts "Error while loading video $v\n$err_video"
		 # Try audio player
		}
}
Trace CometMediaPlayer set_media_source
#___________________________________________________________________________________________________________________________________________
Inject_code CometMediaPlayer set_audio_channel {} {

}

#___________________________________________________________________________________________________________________________________________
Inject_code CometMediaPlayer set_volume {} {
	if {[this get_video_source] != ""} {
		 FFMPEG_set_volume_of_canal [this get_audio_channel] $v
		}
}
Trace CometMediaPlayer set_volume
#___________________________________________________________________________________________________________________________________________
Inject_code CometMediaPlayer Add_L_medias {} {
	$this(C_list_medias) Add_choices $L
}

#___________________________________________________________________________________________________________________________________________
Inject_code CometMediaPlayer Sub_L_medias {} {
	$this(C_list_medias) Sub_choices $L
}

#___________________________________________________________________________________________________________________________________________
Inject_code CometMediaPlayer set_L_medias {} {
	$this(C_list_medias) set_L_choices $L
}


