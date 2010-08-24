#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Video_CFC CommonFC

#___________________________________________________________________________________________________________________________________________
method Video_CFC constructor {} {
 set this(audio_canal)     0
 set this(L_infos_sound)   ""
 set this(sample_rate)     0
 set this(nb_channels)     0
 set this(cb_audio)        ""

 set this(video_source)    ""
 set this(video_width)     0
 set this(video_height)    0 
 set this(video_framerate) 0
 
 set this(last_buffer)     NULL
}

#___________________________________________________________________________________________________________________________________________
Generate_accessors Video_CFC [list audio_canal video_source L_infos_sound video_width video_height last_buffer cb_audio nb_channels sample_rate video_framerate]

#___________________________________________________________________________________________________________________________________________
method Video_CFC set_video_source {src canal} {
 set this(video_source) $src
 set this(audio_canal)  $canal
}

#___________________________________________________________________________________________________________________________________________
method Video_CFC Play  {} {}
#___________________________________________________________________________________________________________________________________________
method Video_CFC Pause {} {}
#___________________________________________________________________________________________________________________________________________
method Video_CFC Stop {} {}
#___________________________________________________________________________________________________________________________________________
method Video_CFC go_to_time {t} {}
#___________________________________________________________________________________________________________________________________________
method Video_CFC go_to_frame {nb} {}

#___________________________________________________________________________________________________________________________________________
method Video_CFC Update_image {buffer} {}

#___________________________________________________________________________________________________________________________________________
method Video_CFC decr_buffer_use {buffer} {
 if {[info exists this(count,$buffer)]} {
   if {$this(count,$buffer) > 0} {incr this(count,$buffer) -1}
  } else {error "Trying to decrement the usage of an unregistered buffer.\n  in $objName Video_CFC::decr_buffer_use $buffer"}
}

#___________________________________________________________________________________________________________________________________________
method Video_CFC incr_buffer_use {buffer} {
 if {[info exists this(count,$buffer)]} {set this(count,$buffer) 0}
 incr this(count,$buffer) 1
}

#___________________________________________________________________________________________________________________________________________
method Video_CFC is_buffer_used  {buffer} {
 if {[info exists this(count,$buffer)]} {
   return [expr $this(count,$buffer) > 0]
  }
  
 return 0
}

#___________________________________________________________________________________________________________________________________________
method Video_CFC release_buffer  {buffer} {
 if {[info exists this(count,$buffer)]} {
   unset this(count,$buffer)
  }
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_get_Video {} {return [list {get_L_infos_sound { }} {get_video_width { }} {get_video_height { }} {get_video_source { }} {get_audio_canal {}} \
                                             {decr_buffer_use {buffer}} {incr_buffer_use {buffer}} {is_buffer_used {buffer}} {release_buffer {buffer}} \
											 {get_last_buffer {}} {set_last_buffer {buffer}} \
											 {get_cb_audio {}} {get_nb_channels {}} {get_sample_rate {}} {get_video_framerate {}} \
											 ]}
proc P_L_methodes_set_Video {} {return [list {set_L_infos_sound {v}} {set_video_width {v}} {set_video_height {v}} {set_video_source {s audio_canal}} \
                                             {Play {}} {Pause {}} {Stop {}} {go_to_time {t}} {go_to_frame {nb}} {Update_image {buffer}} \
											 {set_cb_audio {v}} {set_nb_channels {v}} {set_sample_rate {v}} {set_video_framerate {v}} \
											 ]}

