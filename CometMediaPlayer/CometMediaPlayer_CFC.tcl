inherit CometMediaPlayer_CFC CommonFC

#___________________________________________________________________________________________________________________________________________
method CometMediaPlayer_CFC constructor {} {
 set this(media_source) {}
 set this(audio_canal) {}
 set this(volume) {}
}
#___________________________________________________________________________________________________________________________________________
Generate_accessors CometMediaPlayer_CFC [list media_source audio_canal volume]

#___________________________________________________________________________________________________________________________________________

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_get_CometMediaPlayer {} {return [list {get_media_source { }} {get_audio_canal { }} {get_volume { }} ]}
proc P_L_methodes_set_CometMediaPlayer {} {return [list {set_media_source {v}} {set_audio_canal {v}} {set_volume {v}} ]}

