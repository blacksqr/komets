package require Img
package require img::raw
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#_______________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Video_PM_P_TK PM_TK

#___________________________________________________________________________________________________________________________________________
method Video_PM_P_TK constructor {name descr args} {
 this inherited $name $descr
    
   this set_GDD_id CT_Video_AUI_CUI_basic_B207
 
 set this(play_audio_stream)     0
 set this(play_video_stream)     1
 
 set this(img_has_to_be_updated) 0
 set this(buffer_for_update)     ""
 
 set this(FMOD_audio_stream)     ""
 
 set this(lab)   ""
 set this(photo) ""
 
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC Video_PM_P_TK [P_L_methodes_set_Video] {} {}
Methodes_get_LC Video_PM_P_TK [P_L_methodes_get_Video] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters Video_PM_P_TK [P_L_methodes_set_Video_COMET_RE]

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method Video_PM_P_TK get_or_create_prims {root} {
 set this(lab) "$root.tk_${objName}_label"
 if {![winfo exists $this(lab)]} {
   if {$this(photo) == ""} {
     set tx [this get_video_width] ; set this(photo_tx) $tx
     set ty [this get_video_height]; set this(photo_ty) $ty
     set this(photo) [image create photo -format "raw -max 255 -nomap 1" -width $tx -height $ty]
    }
   label $this(lab) -image $this(photo)
   this Add_MetaData PRIM_STYLE_CLASS [list $this(lab) "PARAM RESULT OUT video VIDEO"]
  }
 this set_root_for_daughters $root

 return [this set_prim_handle $this(lab)]
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method Video_PM_P_TK Play_video_stream_locally {b} {
 set this(play_video_stream) $b
}

#___________________________________________________________________________________________________________________________________________
Inject_code Video_PM_P_TK Update_image {} {
 if {$this(play_video_stream)} {
   set tx [this get_video_width]
   set ty [this get_video_height]

   set buf_name buf_video_for_Video_PM_P_TK_of_[this get_LC]
   global $buf_name
   
   Void2Photo $buffer $this(photo) $this(photo_tx) $this(photo_ty) 3
   #set $buf_name $this(entete)
   #FFMPEG_Convert_void_to_binary_tcl_var $buffer [expr 3 * $tx * $ty] $buf_name 1
   #$this(photo) put [subst $$buf_name] -format "raw -max 255 -nomap 1"
  }
}
# Trace Video_PM_P_TK Update_image
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method Video_PM_P_TK Play_audio_stream_locally {b} {
 if {$b && $b != $this(play_audio_stream)} {
   this Open_audio_stream
  } else {if {!$b} {this Close_audio_stream}
         }
 set this(play_audio_stream) $b
}

#___________________________________________________________________________________________________________________________________________
method Video_PM_P_TK Open_audio_stream {} {
 if {[this get_video_source] == ""} {return}
 if {[this get_nb_channels] == 2} {set mono_stereo [FFMPEG_FSOUND_Stereo]} else {set mono_stereo [FFMPEG_FSOUND_Mono]}
 set buf_len [expr int(2 * [this get_nb_channels] * [this get_sample_rate] / [this get_video_framerate])]
 set this(FMOD_audio_stream) [FFMPEG_Get_a_new_FSOUND_STREAM [this get_cb_audio] \
																[this get_audio_canal] \
																$buf_len \
																[expr $mono_stereo | [FFMPEG_FSOUND_signed] | [FFMPEG_FSOUND_16b]] \
																[this get_sample_rate] \
																[this get_L_infos_sound] \
															 ]
}

#___________________________________________________________________________________________________________________________________________
method Video_PM_P_TK Close_audio_stream {} {
 if {$this(FMOD_audio_stream) != ""} {
   FFMPEG_close_FSOUND_STREAM $this(FMOD_audio_stream)
  }
}

#___________________________________________________________________________________________________________________________________________
Inject_code Video_PM_P_TK Close_video {} {
 this Close_audio_stream
}
Trace Video_PM_P_TK Close_video

#___________________________________________________________________________________________________________________________________________
Inject_code Video_PM_P_TK set_video_source {}  {
 if {$s != "WEBCAM"} {
   set tx [this get_video_width]
   set ty [this get_video_height]
   set this(photo_tx) $tx
   set this(photo_ty) $ty

   set    this(entete) "Magic=RAW\n"
   append this(entete) "Width=$tx\n"
   append this(entete) "Height=$ty\n"
   append this(entete) "NumChan=3\n"
   append this(entete) "ByteOrder=Intel\n"
   append this(entete) "ScanOrder=TopDown\n"
   append this(entete) "PixelType=byte\n"
   
   if {$this(photo) != ""} {
     $this(photo) configure -width $tx -height $ty
	 this Update_image [this get_last_buffer]
    }
	
   if {$this(play_audio_stream)} {
     this Open_audio_stream
    }
  }
}

Trace Video_PM_P_TK set_video_source
