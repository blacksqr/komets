inherit CometSlideRemoteController_PM_P_B207_image_dynamic PM_BIGre

#___________________________________________________________________________________________________________________________________________
method CometSlideRemoteController_PM_P_B207_image_dynamic constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id N_controller_CUI_basic_gfx_skinnable_simple_B207

   set this(L_boutons)  [list go_to_bgn go_to_nxt go_to_prv go_to_end]
   set this(dir)        {Comets/Z_Applis/CamNote/SlideRemoteController/PM_Ps/P/BIGre}

   if {[string length [info proc B_noeud]] > 0} {} else {return $objName}

 set this(nb) 0
 set this(node_created_inside) 1

 set this(bg)        [B_image]
 set this(go_to_bgn) [B_image]
 set this(go_to_end) [B_image]
 set this(go_to_nxt) [B_image]
 set this(go_to_prv) [B_image]
 
 set this(go_to_slide) [B_polygone]
 set this(z_txt)       [B_texte 100 100 25 [fonte_Arial] [B_sim_sds]]
   $this(z_txt) Editable 0
 
 B_configure $this(bg) -Ajouter_fils $this(go_to_bgn) \
					   -Ajouter_fils $this(go_to_end) \
					   -Ajouter_fils $this(go_to_nxt) \
					   -Ajouter_fils $this(go_to_prv) \
					   -Ajouter_fils $this(go_to_slide) \
					   -Ajouter_fils $this(z_txt)
						   
 B_contact ${objName}_p_ctc "$this(bg) 11"

 this set_prim_handle $this(bg)
 #[B_texte 0 0 999999 [fonte_Arial] [B_sim_sds]]

 this set_root_for_daughters [this get_prim_handle]

 this read_style_from_file [Comet_files_root]$this(dir)/Skins/skin1.xml
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method  CometSlideRemoteController_PM_P_B207_image_dynamic dispose {} {
 this inherited
}

#___________________________________________________________________________________________________________________________________________
Generate_accessors CometSlideRemoteController_PM_P_B207_image_dynamic [list go_to_bgn go_to_nxt go_to_prv go_to_end]

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometSlideRemoteController_PM_P_B207_image_dynamic $L_methodes_set_choicesN {} {}
Methodes_get_LC CometSlideRemoteController_PM_P_B207_image_dynamic $L_methodes_get_choicesN {$this(FC)}
Methodes_set_LC CometSlideRemoteController_PM_P_B207_image_dynamic [L_methodes_set_SlideRemoteController] {} {}
Methodes_get_LC CometSlideRemoteController_PM_P_B207_image_dynamic [L_methodes_get_SlideRemoteController] {$this(FC)}

Generate_PM_setters CometSlideRemoteController_PM_P_B207_image_dynamic [L_methodes_set_SlideRemoteController]

#___________________________________________________________________________________________________________________________________________
method CometSlideRemoteController_PM_P_B207_image_dynamic go_to_bgn {} {this Update_ccn_PM_val}
method CometSlideRemoteController_PM_P_B207_image_dynamic go_to_prv {} {this Update_ccn_PM_val}
method CometSlideRemoteController_PM_P_B207_image_dynamic go_to_nxt {} {this Update_ccn_PM_val}
method CometSlideRemoteController_PM_P_B207_image_dynamic go_to_end {} {this Update_ccn_PM_val}
method CometSlideRemoteController_PM_P_B207_image_dynamic set_val  {v} {this Update_ccn_PM_val}
method CometSlideRemoteController_PM_P_B207_image_dynamic set_current {v} {this Update_ccn_PM_val}

#___________________________________________________________________________________________________________________________________________
method CometSlideRemoteController_PM_P_B207_image_dynamic Update_ccn_PM_val {} {
 puts "  $objName Update_ccn_PM_val"
 set b [$this(bg) Boite_noeud]
   set ty [$b Ty]
 set v [this get_val]
 $this(z_txt) Maj_texte $v
 B_configure $this(z_txt) -Optimiser_dimensions -Calculer_boites
   set b [$this(z_txt) Boite_noeud]
 set x $this(z_txt,x); regexp {^(.*)px$} $x reco x
 set y $this(z_txt,y); regexp {^(.*)px$} $y reco y
 $this(z_txt) Origine [expr $x-[$b Cx]]  [expr $ty - $y - [$b Cy]]
}

#___________________________________________________________________________________________________________________________________________
method CometSlideRemoteController_PM_P_B207_image_dynamic maj_images {} {
 set L $this(L_boutons); lappend L bg
 puts "$objName maj_images"
 foreach e $L {
   puts "$this($e) maj {[Comet_files_root]$this(dir)/Skins/$this($e,img)}"
   $this($e) maj [Comet_files_root]$this(dir)/Skins/$this($e,img)
   $this($e) Translucidite 1
  }
# Calcul de la boite englobante pour positionnement des images selon coordonnées exprimé avec y inversé dans fichier skin (héritage AJAX...)
 $this(bg) Calculer_boites
 set b [$this(bg) Boite_noeud]
   set ctc [lindex [$this(bg) Val_MetaData B_contact_and_capa] 0]
   $ctc pt_rot   [$b Cx] [$b Cy]
   $ctc pt_trans [$b Cx] [$b Cy]
 set ty [$b Ty]
 foreach e $this(L_boutons) {
  # Position
   $this($e) Calculer_boites
   set b_e [$this($e) Boite_noeud]
   set x $this($e,x); regexp {^(.*)px$} $x reco x
   set y $this($e,y); regexp {^(.*)px$} $y reco y
   $this($e) Origine $x [expr $ty - $y - [$b_e Ty]]
  # Abonnement aux évennements
   set rap [$this($e) Val_MetaData CometSlideRemoteController_PM_P_B207_image_dynamic_rappel_bt]
     if {[string equal $rap {}]} {
	   set rap [B_rappel [Interp_TCL]]
	   $this($e) Ajouter_MetaData_T CometSlideRemoteController_PM_P_B207_image_dynamic_rappel_bt $rap
	   $this($e) abonner_a_detection_pointeur [$rap Rappel] [ALX_pointeur_relache]
	  }
   $rap Texte "$objName prim_$e"
  }
# Configuration du texte
 $this(z_txt) Calculer_boites; set b_z_txt [$this(z_txt) Boite_noeud]
 set x $this(z_txt,x); regexp {^(.*)px$} $x reco x
 set y $this(z_txt,y); regexp {^(.*)px$} $y reco y
 $this(z_txt) Origine $x [expr $ty - $y - [$b_z_txt Ty]] 
 set t $this(z_txt,size); regexp {^(.*)px$} $t reco t
 $this(z_txt) Zoom $t
 eval "$this(z_txt) Couleur_texte $this(z_txt,color)"
}

#___________________________________________________________________________________________________________________________________________
method CometSlideRemoteController_PM_P_B207_image_dynamic read_style_from_file {f_name} {
 set f [open $f_name]
   set txt [read $f]
 close $f

 set L {}; xml2list $txt L
   set L [lindex $L 0]
   foreach e [lindex $L 2] {
 	 set name [lindex $e 0]
     foreach {att val} [lindex $e 1] {
	   set this($name,$att) $val
	  }
    }
 this maj_images
}
