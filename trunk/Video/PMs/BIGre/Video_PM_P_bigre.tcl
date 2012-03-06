#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#_______________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Video_PM_P_BIGre PM_BIGre

#___________________________________________________________________________________________________________________________________________
method Video_PM_P_BIGre constructor {name descr args} {
 this inherited $name $descr
    
   this set_GDD_id CT_Video_AUI_CUI_basic_B207

   set this(img) [B_image]
   $this(img) Inverser_y 1

   set this(primitives_handle) [B_polygone]
   $this(primitives_handle) abonner_a_LR_parcours [$this(primitives_handle) LR_Av_pre_rendu] [$this(rap_placement) Rappel]

   set this(rap_img_update)        [B_rappel [Interp_TCL] "$objName Update_B207_img"]
   N_i_mere abonner_a_fin_simulation [$this(rap_img_update) Rappel]
   
 this set_prim_handle        $this(primitives_handle)
 this set_root_for_daughters $this(primitives_handle)
 $this(primitives_handle) Translucidite 0
 
 set this(video_x)  0; set this(video_y)  0
 set this(video_ex) 1; set this(video_ey) 1
 
 set this(img_has_to_be_updated) 0
 set this(buffer_for_update)     ""
 
 set this(B207_audio_stream)     ""

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC Video_PM_P_BIGre [P_L_methodes_set_Video] {} {}
Methodes_get_LC Video_PM_P_BIGre [P_L_methodes_get_Video] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_accessors Video_PM_P_BIGre [list ffmpeg_rap_img]

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters Video_PM_P_BIGre [P_L_methodes_set_Video_COMET_RE]

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Inject_code Video_PM_P_BIGre Update_image {} {
 set this(img_has_to_be_updated) 1
 if {$this(buffer_for_update) != ""} {
   this decr_buffer_use $this(buffer_for_update)
  }
 set this(buffer_for_update) $buffer
 this incr_buffer_use   $buffer
}

#___________________________________________________________________________________________________________________________________________
Inject_code Video_PM_P_BIGre Close_video {} {
   # Close the previous audio flow
   if {$this(B207_audio_stream) != ""} {
     puts "    Close previous audio stream $this(B207_audio_stream) ..."
	 while {[N_i_mere Fermer_flux $this(B207_audio_stream)] == 0} {
	   puts "    waiting for stream to be ready"
	  }
	 puts "    ... done !"
	}   
}
Trace Video_PM_P_BIGre Close_video

#___________________________________________________________________________________________________________________________________________
Inject_code Video_PM_P_BIGre set_video_source {}  {
 set tx [this get_video_width]
 set ty [this get_video_height]
 
 set num_cam 0
 if {$s == "WEBCAM" || [regexp {^WEBCAM([0-9])$} $s reco num_cam]} {
	 set is_webcam 1
	} else {set is_webcam 0}
 
 if {!$is_webcam} {
   $this(img) maj_raw_with_transfo [this get_video_width] [this get_video_height] [GL_rvb] 3 [GL_rvba] 4 [this get_last_buffer]
   
   set texture [$this(img) Info_texture]
   $this(primitives_handle) Vider
   $this(primitives_handle) Ajouter_contour [ProcRect 0 0 $tx $ty]
   $this(primitives_handle) Info_texture $texture
   $this(primitives_handle) Etirement 1 1
   $this(primitives_handle) Etirement_interne 1 -1 [expr $tx / 2.0] [expr $ty / 2.0]
   
   this Origine $this(video_x) $this(video_y)
   
   # Audio with Fmod
   set buf_len [expr int(2 * [this get_nb_channels] * [this get_sample_rate] / [this get_video_framerate])]
   set buf_len 8192
   if {$buf_len > 0} {
		   if {[this get_nb_channels] == 2} {set mono_stereo [FSOUND_Stereo]} else {set mono_stereo [FSOUND_Mono]}
		   set this(B207_audio_stream) [N_i_mere Nouveau_flux [this get_cb_audio] \
															  $audio_canal \
															  $buf_len \
															  [expr $mono_stereo | [FSOUND_signed] | [FSOUND_16b]] \
															  [this get_sample_rate] \
															  [this get_L_infos_sound] \
															  ]
		}
  } else {set texture [this get_B207_texture]
          if {$texture != "" && $texture != "NULL"} {
            puts "We have a Webcam for video player Video_PM_P_BIGre $objName"
		    $this(primitives_handle) Vider
		    $this(primitives_handle) Ajouter_contour [ProcRect 0 0 $tx $ty]
		    $this(primitives_handle) Info_texture $texture
		    this Origine $this(video_x) $this(video_y)
		   } else {puts "Try again to get the WEBCAM info..."; after 100 "[this get_LC] set_B207_texture \[[this get_visu_cam] Info_texture\]; $objName set_video_source WEBCAM $audio_canal"}
         }
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method Video_PM_P_BIGre Update_B207_img {} {
 if {$this(img_has_to_be_updated)} {
   if {[this get_video_source] == "WEBCAM" && ![[this get_visu_cam] EstPret]} {puts "Camera not ready"; return}
   
   $this(img) maj_raw_with_transfo [this get_video_width] [this get_video_height] [GL_rvb] 3 [GL_rvba] 4 $this(buffer_for_update)
   this decr_buffer_use $this(buffer_for_update)
   set this(buffer_for_update) ""
   set this(img_has_to_be_updated) 0
  }
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
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
   #puts "$this(primitives_handle) Etirement $x $y"
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
method Video_PM_P_BIGre get_B207_currrent_video_img {} {
 if {[this get_video_source] == "WEBCAM"} {return $this(primitives_handle)} else {return $this(img)}
}


#___________________________________________________________________________________________________________________________________________
method Video_PM_P_BIGre is_translucide {{v {}}}  {
 if {$v == ""} {
   return [$this(primitives_handle) Translucidite]
  } else {$this(primitives_handle) Translucidite $v}
}

#___________________________________________________________________________________________________________________________________________
method Video_PM_P_BIGre set_translucidity {v}  {
 $this(primitives_handle) Couleur 3 $v
}

#___________________________________________________________________________________________________________________________________________
method Video_PM_P_BIGre set_resolution {x y} {
 if {[this get_video_source] == "WEBCAM"} {
   after 100 "$this(primitives_handle) Vider
              $this(primitives_handle) Ajouter_contour \[ProcRect 0 0 $x $y\]
              $this(primitives_handle) Info_texture [this get_B207_texture]
			 " 
  }
}
