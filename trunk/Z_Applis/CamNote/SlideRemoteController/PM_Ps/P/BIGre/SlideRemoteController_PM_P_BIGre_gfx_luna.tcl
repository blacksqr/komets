inherit SlideRemoteController_PM_P_BIGre_gfx_luna PM_BIGre

#___________________________________________________________________________________________________________________________________________
method SlideRemoteController_PM_P_BIGre_gfx_luna constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id N_controller_CUI_basic_gfx_luna_B207
 if {[string length [info proc B_noeud]] > 0} {} else {return $objName}

 set this(nb) 0
 set this(node_created_inside) 1

 set this(img_reflet)  [B_image [get_B207_files_root]reflet_transparent.png]
 set this(img_reflet2) [B_image [get_B207_files_root]reflet2_transparent.png]
 set this(poly_luna)         [B_polygone]
 set this(poly_rond_interne) [B_polygone]
 set this(poly_entree_vague) [B_polygone]
 set this(poly_vague)		 [B_polygone]
 set this(poly_entree_tete)  [B_polygone]
 set this(poly_tete)		 [B_polygone]
   B_configure $this(poly_luna) -Ajouter_fils $this(poly_rond_interne) \
								-Ajouter_fils $this(poly_vague)        \
								-Ajouter_fils $this(poly_entree_vague) \
								-Ajouter_fils $this(poly_entree_tete)  \
								-Ajouter_fils $this(poly_tete)   	   \
								-Position_des_fils_changeable 0
   B_contact ${objName}_p_ctc "$this(poly_luna) 1"
   $this(poly_luna) Ajouter_MetaData_T B_contact ${objName}_p_ctc
 this create_polygone_luna 880 200 1.5
 this set_prim_handle $this(poly_luna)
 #[B_texte 0 0 999999 [fonte_Arial] [B_sim_sds]]

 this set_root_for_daughters [this get_prim_handle]

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method  SlideRemoteController_PM_P_BIGre_gfx_luna Coord {nb_pt R delta i} {
 set delta_a 0; set PI    3.14159265
   set r [expr $R*($delta+sin(2*$i*$PI/$nb_pt))]
   set a [expr 2*cos($PI*($delta_a+$r)/((300-$r)/10.0+$R.0))+2*$i*$PI/${nb_pt}.0]
   return "[expr $r*cos($a)] [expr $r*sin($a)]"
}

#___________________________________________________________________________________________________________________________________________
method  SlideRemoteController_PM_P_BIGre_gfx_luna Reload_textures {} {
 $this(img_reflet)  maj [get_B207_files_root]reflet_transparent.png
 $this(img_reflet2) maj [get_B207_files_root]reflet_sphere_hg.png
}
 
#___________________________________________________________________________________________________________________________________________
method  SlideRemoteController_PM_P_BIGre_gfx_luna create_polygone_luna {nb_pt R delta} {
 if {[info exists delta_a]} {} else {set delta_a 0}
 set L {}
 set PI    3.14159265
 for {set i 0} {$i<$nb_pt} {incr i} {
   set r [expr $R*($delta+sin(2*$i*$PI/$nb_pt))]
 
   set a [expr 2*cos($PI*($delta_a+$r)/((300-$r)/10.0+$R.0))+2*$i*$PI/${nb_pt}.0]
   lappend L [expr $r*cos($a)] \
             [expr $r*sin($a)]
  } 

 
 set p $this(poly_luna)
 $p Vider
 $p Etirement 0.3 0.3
 $p Ajouter_contour [ProcTabDouble $L]
 
 $this(poly_rond_interne) Vider
 $this(poly_rond_interne) Ajouter_contour [ProcOvale 0 20 120 120 60]
   B_configure $this(poly_rond_interne) -Origine 0 25 -Etirement 1 1 -Glissement 0 0.3
  # Multi texture
   B_configure $this(poly_rond_interne) -Info_texture  NULL \
										-Info_texture2 [$this(img_reflet) Info_texture] \
										-Combinaison_textures [GL_interpolate_ARB] [GL_add] \
										-Mode_texture 1        \
										-Mode_texture_fils 1   \
										-Mode_texture2 1	   \
										-Nb_pixels_par_unite 1 \
										-Translucidite 1	   \
										-Couleur 1 0 0 0.5	   \
										-Forcer_pre_rendu_noeud 1
  
   $p Difference $this(poly_rond_interne) $p
   C_B_Toolglass $this(poly_rond_interne) {set PM [$noeud Val CometPM]; set L [list $noeud [$PM get_GDD_id] [$noeud Tab_Val CometPM]]; puts $L"}
   
   $this(poly_entree_vague) Vider
   $this(poly_entree_vague) maj 397 -20 0 1 1
   B_configure $this(poly_entree_vague) -Ajouter_contour [ProcOvale 0 0 100 50 60] \
										-Difference $this(poly_luna) $this(poly_luna) \
										-Translucidite 1 -Couleur 0 1 0.6 0.5 -Couleur_perimetre 0 0.7 0.9 0.5 \
										-Info_texture NULL -Info_texture2 [$this(img_reflet) Info_texture] \
										-Combinaison_textures [GL_interpolate_ARB] [GL_add] \
										-Mode_texture 1 -Mode_texture_fils 1 -Mode_texture2 1 -Nb_pixels_par_unite 1 \
										-Forcer_pre_rendu_noeud 1
   set L {}
   set deb [expr int(-$nb_pt/880.0)]
   set fin [expr int($nb_pt*190/880.0)]
   for {set i $deb} {$i<=$fin} {incr i} {eval "lappend L [this Coord $nb_pt $R $delta $i]"}
   B_configure $this(poly_vague) -Vider -Ajouter_contour [ProcTabDouble $L] \
								 -Translucidite 1 -Couleur 0 0.7 0.9 0.5 \
								 -Difference $this(poly_entree_vague) \
								 -Forcer_pre_rendu_noeud 1
 # Poly tête 385 à 860
   $this(poly_tete) Vider
   #return 
   set L {}
   set deb [expr int($nb_pt*385/880.0)]
   set fin [expr int($nb_pt*860/880.0)]
   for {set i $deb} {$i<=$fin} {incr i} {eval "lappend L [this Coord $nb_pt $R $delta $i]"}
   B_configure $this(poly_tete) -Vider -Ajouter_contour [ProcTabDouble $L] \
								-Info_texture  NULL -Info_texture2 [$this(img_reflet2) Info_texture] -Combinaison_textures [GL_interpolate_ARB] [GL_add] \
								-Mode_texture 1 -Mode_texture_fils 1 -Mode_texture2 1 -Nb_pixels_par_unite 0.3 \
								-Translucidite 1 -Couleur 1 1 0 0.7 \
								-Difference $this(poly_entree_tete) \
								-Forcer_pre_rendu_noeud 1
}

#___________________________________________________________________________________________________________________________________________
method  SlideRemoteController_PM_P_BIGre_gfx_luna dispose {} {
 if {$this(node_created_inside)} {
   $this(primitives_handle) -delete
  }
 this inherited
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC SlideRemoteController_PM_P_BIGre_gfx_luna $L_methodes_set_choicesN {$this(FC)} {}
Methodes_get_LC SlideRemoteController_PM_P_BIGre_gfx_luna $L_methodes_get_choicesN {$this(FC)}
Methodes_set_LC SlideRemoteController_PM_P_BIGre_gfx_luna [L_methodes_set_SlideRemoteController] {$this(FC)} {}
Methodes_get_LC SlideRemoteController_PM_P_BIGre_gfx_luna [L_methodes_get_SlideRemoteController] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters SlideRemoteController_PM_P_BIGre_gfx_luna [L_methodes_set_SlideRemoteController]

#___________________________________________________________________________________________________________________________________________
method  SlideRemoteController_PM_P_BIGre_gfx_luna Char_entered {} {
 set c [Void_vers_int [$this(rap_car) Param]]
 puts "$objName à capter num $c :?: \'[Void_vers_char [$this(rap_car) Param]]\'"
 if {$c == [SDSK_LEFT] } {this go_to_prv} else {
 if {$c == [SDSK_RIGHT]} {this go_to_nxt} else {
 if {$c == [SDSK_HOME]}  {this go_to_bgn} else {
 if {$c == [SDSK_END]}   {this go_to_end} else {
 if {$c>=48 && $c<=57} {this Chiffre [Void_vers_char [$this(rap_car) Param]]}
   }
  }}}
}

#___________________________________________________________________________________________________________________________________________
method SlideRemoteController_PM_P_BIGre_gfx_luna Chiffre {c} {
 puts "$objName Chiffre $c"
 set this(nb) [expr $this(nb)*10 + $c]
 after 500 "$objName TMP_go_to_num $this(nb)"
}

#___________________________________________________________________________________________________________________________________________
method SlideRemoteController_PM_P_BIGre_gfx_luna TMP_go_to_num {nb} {
 if {$this(nb) == $nb} {this go_to_num $nb
                        set this(nb) 0
                       }
}

