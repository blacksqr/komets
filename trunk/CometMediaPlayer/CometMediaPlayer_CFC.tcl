inherit CometMediaPlayer_CFC CommonFC

#___________________________________________________________________________________________________________________________________________
method CometMediaPlayer_CFC constructor {} {
 set this(media_source)  {}
 set this(audio_channel) 0
 set this(volume)        0
 
 set this(play)          0
 
 set this(L_medias)      [list]
}
#___________________________________________________________________________________________________________________________________________
Generate_accessors     CometMediaPlayer_CFC [list media_source audio_channel volume]
Generate_List_accessor CometMediaPlayer_CFC L_medias L_medias

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometMediaPlayer_CFC Play       {v} {set this(play) $v} 
method CometMediaPlayer_CFC is_playing { } {return $this(play)}

method CometMediaPlayer_CFC Next     {} {}
method CometMediaPlayer_CFC Previous {} {}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_get_CometMediaPlayer {} {return [list {get_L_medias {}} {Contains_L_medias {v}} {Index_of_L_medias {v}} {is_playing {}} {get_media_source { }} {get_audio_channel { }} {get_volume { }} ]}
proc P_L_methodes_set_CometMediaPlayer {} {return [list {Play {v}} {Next {}} {Previous {}} {set_L_medias {L}} {Add_L_medias {L}} {Sub_L_medias {L}} {set_media_source {v}} {set_audio_channel {v}} {set_volume {v}} ]}

