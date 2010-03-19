if {[catch "load {C:/These/Projet Interface/BIGre/FFMPEG_for_TCL.dll}" err]} {
  set Video_PM_P_BIGre_ff_mpeg_OK 0
  puts "ERROR while loading FFMPEG library:\n$err"
 } else {set Video_PM_P_BIGre_ff_mpeg_OK 1;
         ffmpeg_init
		}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#_______________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Video_PM_P_BIGre PM_BIGre

#___________________________________________________________________________________________________________________________________________
method Video_PM_P_BIGre constructor {name descr args} {
 this inherited $name $descr
 
   set this(video_source) ""
   set this(canal_audio)  ""
   
   this set_GDD_id CT_Video_AUI_CUI_basic_B207

   set this(primitives_handle) [B_polygone]
   $this(primitives_handle) abonner_a_LR_parcours [$this(primitives_handle) LR_Av_pre_rendu] [$this(rap_placement) Rappel]

 this set_prim_handle        $this(primitives_handle)
 this set_root_for_daughters $this(primitives_handle)
 
 set this(video_x)  0; set this(video_y)  0
 set this(video_ex) 1; set this(video_ey) 1
 this Origine 0 0

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC Video_PM_P_BIGre [P_L_methodes_set_Video] {} {}
Methodes_get_LC Video_PM_P_BIGre [P_L_methodes_get_Video] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_accessors Video_PM_P_BIGre [list ffmpeg_rap_img ffmpeg_start_ms ffmpeg_time_frame ffmpeg_frame_num video_source canal_audio]

#___________________________________________________________________________________________________________________________________________
method Video_PM_P_BIGre Origine {x y} {
 set this(video_x) $x; set this(video_y) $y
 this Px $x
 this Py $y
}
#___________________________________________________________________________________________________________________________________________
method Video_PM_P_BIGre Py {v} {
 this inherited $v
 set this(video_y) $v
 if {[this get_video_source] != "WEBCAM"} {
   set bbox [$this(primitives_handle) Boite_noeud]
   $this(primitives_handle) Translation_interne 0 [expr $this(video_ey) * [$bbox Ty]]
  }
}

#___________________________________________________________________________________________________________________________________________
method Video_PM_P_BIGre Etirement {x y} {
 set this(video_ex) $x; set this(video_ey) $y
 if {[this get_video_source] == "WEBCAM"} {
   puts "$this(primitives_handle) Etirement $x $y"
   $this(primitives_handle) Etirement $x $y
  } else {set bbox [$this(primitives_handle) Boite_noeud]
          $this(primitives_handle) Etirement $x $y
          $this(primitives_handle) Etirement_interne 1 -1 [$bbox Cx] [$bbox Cy]
		  this Origine $this(video_x) $this(video_y)
		  puts $this(primitives_handle)
         }
}

#___________________________________________________________________________________________________________________________________________
method Video_PM_P_BIGre Inverser_x {v} {
 set n $this(primitives_handle)
 $n Ex [expr "abs([$this(primitives_handle) Ex])"]
 $n Calculer_boites
 set bb [$n Boite_noeud]
 if {$v} {
   $n Px [expr [$bb Tx]*[$n Ex]]
   $n Ex -[$n Ex]
   #$this(primitives_handle) Ex -[$this(primitives_handle) Ex]
  }
}

#___________________________________________________________________________________________________________________________________________
method Video_PM_P_BIGre Goto_pos_rel {percent} {
 if {$this(video_source) != "WEBCAM" && $this(video_source) != ""} {
   set this(ffmpeg_frame_num) [expr int($percent * $this(ffmpeg_numFrames))]
   FFMPEG_getImageNr $this(ffmpeg_id) $this(ffmpeg_frame_num) $this(ffmpeg_buf)
  }
}

#___________________________________________________________________________________________________________________________________________
method Video_PM_P_BIGre get_visu_cam {}  {return $this(visu_cam)}

#___________________________________________________________________________________________________________________________________________
method Video_PM_P_BIGre get_B207_currrent_video_img {} {
 if {[this get_video_source] == "WEBCAM"} {return $this(visu_cam)} else {return $this(img)}
}

#___________________________________________________________________________________________________________________________________________
method Video_PM_P_BIGre set_video_source {s canal_audio}  {
 set this(video_source) $s
 set this(canal_audio)  $canal_audio
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

          set this(ffmpeg_rap_img)    [B_rappel [Interp_TCL]]
          set this(ffmpeg_start_ms)   [N_i_mere ms]; 
		  set this(ffmpeg_frame_num)  0
		  set this(ffmpeg_numFrames)  [FFMPEG_numFrames    $this(ffmpeg_id)]
          set this(ffmpeg_frame_rate) [FFMPEG_getFramerate $this(ffmpeg_id)]
          $this(ffmpeg_rap_img) Texte "$objName Update_frame"

         # Sound
          set sample_rate [FFMPEG_Sound_sample_rate $this(ffmpeg_id)]
          set cb_audio [Get_FFMPEG_FMOD_Stream_Info_audio]
          #set canal_audio 0
          set buf_len [expr int(2 * [FFMPEG_Nb_channels $this(ffmpeg_id)] * $sample_rate / [FFMPEG_getFramerate $this(ffmpeg_id)])]
          set L_infos_B207_sound [FFMPEG_Info_for_sound_CB $this(ffmpeg_id)]
          if {[FFMPEG_Nb_channels $this(ffmpeg_id)] == 2} {set mono_stereo [FSOUND_Stereo]} else {set mono_stereo [FSOUND_Mono]}
 
          set this(B207_audio_stream) [N_i_mere Nouveau_flux $cb_audio $canal_audio $buf_len [expr $mono_stereo | [FSOUND_signed] | [FSOUND_16b]] $sample_rate $L_infos_B207_sound]
          FFMPEG_set_Debug_mode $this(ffmpeg_id) 0
          FFMPEG_Audio_buffer_size $this(ffmpeg_id)
          puts "Info audio :\n  - Sample rate : $sample_rate\n  - Mono([FSOUND_Mono])/Stereo([FSOUND_Stereo]) : $mono_stereo "
  
         # Gogogo!!!
          N_i_mere abonner_a_fin_simulation [$this(ffmpeg_rap_img) Rappel]
		 
		# DEBUG
		   this Update_frame 1
		   set texture [$this(img) Info_texture]
		   $this(primitives_handle) Vider
		   $this(primitives_handle) Ajouter_contour [ProcRect 0 0 $tx $ty]
		   $this(primitives_handle) Info_texture $texture
		   
		   $this(primitives_handle) Etirement_interne 1 -1 [expr $tx / 2.0] [expr $ty / 2.0]
		   #$this(primitives_handle) Ajouter_fils $this(img)
		   #$this(img) Afficher_noeud 0
		    # OLD $this(primitives_handle) Ajouter_fils $this(img)
		# /DEBUG
		
		#$this(img) Etirement 1 1
         }
}

#___________________________________________________________________________________________________________________________________________
method Video_PM_P_BIGre Update_frame {{force_update 0}} {
 set ms [N_i_mere ms]; 
 set num [expr int(($ms - [this get_ffmpeg_start_ms])*$this(ffmpeg_frame_rate)/1000.0)]
 if {$force_update || $num != [this get_ffmpeg_frame_num]} {
   this set_ffmpeg_frame_num $num
   FFMPEG_getImage $this(ffmpeg_id) $this(ffmpeg_buf)
   $this(img) maj_raw_with_transfo $this(tx) $this(ty) [GL_rvb] 3 [GL_rvba] 4 $this(ffmpeg_buf)
  }
 # N_i_mere Fermer_flux $this(B207_audio_stream)
}

#___________________________________________________________________________________________________________________________________________
method Video_PM_P_BIGre set_translucidity {v}  {
 $this(primitives_handle) Couleur 3 $v
}

#___________________________________________________________________________________________________________________________________________
method Video_PM_P_BIGre set_resolution {x y} {
 if {[this get_video_source] == "WEBCAM"} {
   $this(visu_cam) set_resolution $x $y
   $this(primitives_handle) Vider
   $this(primitives_handle) Ajouter_contour [ProcRect 0 0 $x $y]
  }
}
