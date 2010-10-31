inherit LogicalVideo_FC Logical_model

#___________________________________________________________________________________________________________________________________________
method LogicalVideo_FC constructor {name descr args} {
 this inherited $name $descr

 set this(ffmpeg_PM) ${objName}_PM_ffmpeg
 Video_PM_FC_ffmpeg $this(ffmpeg_PM) "FFMPEG decoder" "This is the default PM of $objName (LogicalVideo_FC)"
 this Add_PM $this(ffmpeg_PM); this set_PM_active $this(ffmpeg_PM)
 
 eval "$objName configure $args"
 return $objName
}


#___________________________________________________________________________________________________________________________________________
Methodes_set_LC LogicalVideo_FC [P_L_methodes_set_Video] {} {$this(L_actives_PM)}
Methodes_get_LC LogicalVideo_FC [P_L_methodes_get_Video] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_set_Video_FC_COMET_RE {} {return [list {set_L_infos_sound {v}} {Update_image {buffer}} {set_video_width {v}} {set_video_height {v}} \
                                                         {set_cb_audio {v}} {set_nb_channels {v}} {set_sample_rate {v}} {set_video_framerate {v}} \
														 {Close_video {}} {set_video_nbFrames {v}} \
														 {set_B207_texture {v}} {set_visu_cam {v}} \
														 {set_resolution {x y}} \
														 ]}
Generate_LM_setters LogicalVideo_FC [P_L_methodes_set_Video_FC_COMET_RE]

