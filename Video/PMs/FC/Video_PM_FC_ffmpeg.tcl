if {[catch "load {C:/These/Projet Interface/BIGre/FFMPEG_for_TCL.dll}" err]} {
  set Video_PM_FC_ffmpeg_OK 0
  puts "ERROR while loading FFMPEG library:\n$err"
 } else {set Video_PM_FC_ffmpeg_OK 1
         ffmpeg_init
		}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#_______________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Video_PM_FC_ffmpeg Physical_model

#___________________________________________________________________________________________________________________________________________
method Video_PM_FC_ffmpeg constructor {name descr args} {
 this inherited $name $descr
    
   this set_GDD_id CT_Video_FC_ffmpeg

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC Video_PM_FC_ffmpeg [P_L_methodes_set_Video] {} {}
Methodes_get_LC Video_PM_FC_ffmpeg [P_L_methodes_get_Video] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_accessors Video_PM_FC_ffmpeg [list ffmpeg_rap_img ffmpeg_start_ms ffmpeg_time_frame ffmpeg_frame_num]


#___________________________________________________________________________________________________________________________________________
method Video_PM_FC_ffmpeg Goto_pos_rel {percent} {
 if {[this get_video_source] != "WEBCAM" && [this get_video_source] != ""} {
   set this(ffmpeg_frame_num) [expr int($percent * $this(ffmpeg_numFrames))]
   FFMPEG_getImageNr $this(ffmpeg_id) $this(ffmpeg_frame_num) $this(ffmpeg_buf)
  }
}

#___________________________________________________________________________________________________________________________________________
method Video_PM_FC_ffmpeg set_video_source {s canal_audio}  {
 if {$s == "WEBCAM"} {
   set visu_cam [Visu_Cam]; set this(visu_cam) $visu_cam
   set texture [$visu_cam Info_texture]
   $this(primitives_handle) Vider
   set tx [$texture Taille_reelle_x]; if {$tx == 0} {set tx 1}
   set ty [$texture Taille_reelle_y]; if {$ty == 0} {set ty 1}
   $this(primitives_handle) Ajouter_contour [ProcRect 0 0 $tx $ty]
   $this(primitives_handle) Info_texture $texture
  } else {set this(ffmpeg_id) [FFMPEG_Open_video_stream $s]
          FFMPEG_set_Synchronisation_threshold $this(ffmpeg_id) 0.11
          set t  [FFMPEG_startAcquisition $this(ffmpeg_id)]
          set tx [FFMPEG_Width  $this(ffmpeg_id)]
          set ty [FFMPEG_Height $this(ffmpeg_id)]
		  set this(tx) $tx; set this(ty) $ty
		  
		  set this(img) [B_image]
		    $this(img) Inverser_y 1

          set this(ffmpeg_buf) [FFMPEG_Get_a_buffer $t]

          set this(ffmpeg_start_ms)   [clock milliseconds]; 
		  set this(ffmpeg_frame_num)  0
		  set this(ffmpeg_numFrames)  [FFMPEG_numFrames    $this(ffmpeg_id)]
          set this(ffmpeg_frame_rate) [FFMPEG_getFramerate $this(ffmpeg_id)]

         # Sound
          set sample_rate [FFMPEG_Sound_sample_rate $this(ffmpeg_id)]
          set cb_audio    [Get_FFMPEG_FMOD_Stream_Info_audio]
          set buf_len [expr int(2 * [FFMPEG_Nb_channels $this(ffmpeg_id)] * $sample_rate / [FFMPEG_getFramerate $this(ffmpeg_id)])]
          this user_set_L_infos_sound [FFMPEG_Info_for_sound_CB $this(ffmpeg_id)]
          if {[FFMPEG_Nb_channels $this(ffmpeg_id)] == 2} {set mono_stereo [FSOUND_Stereo]} else {set mono_stereo [FSOUND_Mono]}
 
          FFMPEG_set_Debug_mode $this(ffmpeg_id) 0
          FFMPEG_Audio_buffer_size $this(ffmpeg_id)
          puts "Info audio (Video_PM_P_BIGre $objName):\n  - Sample rate : $sample_rate\n  - Mono([FSOUND_Mono])/Stereo([FSOUND_Stereo]) : $mono_stereo "
         }
}

#___________________________________________________________________________________________________________________________________________
method Video_PM_FC_ffmpeg Update_frame {{force_update 0}} {
 if {$this(is_updating)} {return}
 set this(is_updating) 1
 
 set ms [clock milliseconds]; 
 set num [expr int(($ms - [this get_ffmpeg_start_ms])*$this(ffmpeg_frame_rate)/1000.0)]
 if {$force_update || $num != [this get_ffmpeg_frame_num]} {
   this set_ffmpeg_frame_num $num
   FFMPEG_getImage $this(ffmpeg_id) $this(ffmpeg_buf)
  }
  
 set this(is_updating) 0
 after 1 "$objName Update_frame"
}
