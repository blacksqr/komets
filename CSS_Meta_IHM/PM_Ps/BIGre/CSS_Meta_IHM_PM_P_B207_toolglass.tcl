inherit CSS_Meta_IHM_PM_P_B207_toolglass PM_BIGre

#___________________________________________________________________________________________________________________________________________
method CSS_Meta_IHM_PM_P_B207_toolglass constructor {name descr args} {
 this inherited $name $descr
   #this set_GDD_id N_controller_CUI_basic_gfx_luna_B207
 if {[string length [info proc B_noeud]] > 0} {} else {return $objName}

 set this(mode_GDD_active) 1
 set this(img_reflet) [B_image [get_B207_files_root]reflet_transparent.png]

 set this(n_meta)  [B_noeud]
 set this(poly_tg) [B_polygone]
 $this(n_meta) Ajouter_fils $this(poly_tg)
 $this(n_meta) Position_des_fils_changeable 0
 B_configure $this(poly_tg) -Translucidite 1 -Couleur 0 1 0.4 0.5 -Ajouter_contour [ProcOvale 0 0 85 85 60] \
                     -Info_texture  NULL \
					   -Info_texture2 [$this(img_reflet) Info_texture] \
										-Combinaison_textures [GLenum2UI [GL_interpolate_ARB]] [GLenum2UI [GL_add]] \
										-Combinaison_textures_operande2 [GLenum2UI [GL_src_alpha]] \
										-Combinaison_textures_source_arg2 [GLenum2UI [GL_texture]] \
										-Mode_texture 1        \
										-Mode_texture_fils 1   \
										-Mode_texture2 1	   \
										-Nb_pixels_par_unite 1 \
										-Forcer_pre_rendu_noeud 1


 set this(poly_bord) [B_polygone]
   $this(n_meta) Ajouter_fils $this(poly_bord)
 B_configure $this(poly_bord) -Ajouter_contour [ProcOvale 0 0 120 120 60] \
                       -Couleur 0.6 0.7 0.8 1 \
					   -Difference $this(poly_tg) \
					   -Info_texture  NULL \
					   -Info_texture2 [$this(img_reflet) Info_texture] \
										-Combinaison_textures [GLenum2UI [GL_interpolate_ARB]] [GLenum2UI [GL_add]] \
										-Combinaison_textures_operande2 [GLenum2UI [GL_src_alpha]] \
										-Combinaison_textures_source_arg2 [GLenum2UI [GL_texture]] \
										-Mode_texture 1        \
										-Mode_texture_fils 1   \
										-Mode_texture2 1	   \
										-Nb_pixels_par_unite 1 \
										-Forcer_pre_rendu_noeud 1
# Configuration of contacts and toolglass callback
 B_contact ctc_$this(n_meta) "$this(n_meta) 0" -add "$this(poly_bord) 1"
 C_B_Toolglass $this(poly_tg) "if {\[catch {$objName GDD_call_now \$infos_origine \$infos} err]} {puts \"ERROR\n\$err\"}"

 # Configuration of toolglass "widgets informations" pool
 set this(L_ptr_in) {}
 set this(rap_in)  [B_rappel [Interp_TCL]]; $this(rap_in)  Texte "set p \[$this(rap_in)  Param\]; set infos \[Void_vers_info \$p\]; $objName Pointer_in  \$infos"
 set this(rap_out) [B_rappel [Interp_TCL]]; $this(rap_out) Texte "set p \[$this(rap_out) Param\]; set infos \[Void_vers_info \$p\]; $objName Pointer_out \$infos"
   $this(n_meta) abonner_a_detection_pointeur [$this(rap_out) Rappel] [ALX_pointeur_disparition]
   $this(n_meta) abonner_a_detection_pointeur [$this(rap_in)  Rappel] [ALX_pointeur_apparition]

 set this(n_for_GDD_txt_infos) [B_noeud]
   $this(n_meta) Ajouter_fils $this(n_for_GDD_txt_infos)
   
 set this(n_txt_wich_PM)        [B_noeud]; $this(n_for_GDD_txt_infos) Ajouter_fils $this(n_txt_wich_PM)
   $this(n_txt_wich_PM)        Origine 120 -120
   set this(rap_act_PM) [B_rappel [Interp_TCL]]; $this(rap_act_PM) Texte "set p \[$this(rap_act_PM) Param\]; set infos \[Void_vers_info \$p\]; $objName Clic_on_PM \$infos"
   $this(n_txt_wich_PM) abonner_a_detection_pointeur [$this(rap_act_PM) Rappel] [ALX_pointeur_relache]
   
 set this(n_txt_GDD_which_type) [B_noeud]; $this(n_for_GDD_txt_infos) Ajouter_fils $this(n_txt_GDD_which_type)
   $this(n_txt_GDD_which_type) Origine 120 -120
   set this(rap_act_GDD_type) [B_rappel [Interp_TCL]]; $this(rap_act_GDD_type) Texte "set p \[$this(rap_act_GDD_type) Param\]; set infos \[Void_vers_info \$p\]; $objName Clic_on_GDD_type \$infos"
   $this(n_txt_GDD_which_type) abonner_a_detection_pointeur [$this(rap_act_GDD_type) Rappel] [ALX_pointeur_relache]
 set this(L_free_B_texte) {}

 this set_prim_handle [list $this(n_meta)]
# Call of the extra constructor parameters
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CSS_Meta_IHM_PM_P_B207_toolglass [L_methodes_set_CSS_Meta_IHM_LM_LP] {$this(FC)} {}
Methodes_get_LC CSS_Meta_IHM_PM_P_B207_toolglass [L_methodes_get_CSS_Meta_IHM]       {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters CSS_Meta_IHM_PM_P_B207_toolglass [L_methodes_set_CSS_Meta_IHM_LM_LP]

#___________________________________________________________________________________________________________________________________________
Generate_accessors CSS_Meta_IHM_PM_P_B207_toolglass [list mode_GDD_active n_meta n_for_GDD_txt_infos poly_tg poly_bord n_txt_wich_PM n_txt_GDD_which_type]

#___________________________________________________________________________________________________________________________________________
method CSS_Meta_IHM_PM_P_B207_toolglass Clic_on_GDD_type {infos} {
 set noeud [$infos NOEUD]
 puts "$objName Clic_on_GDD_type $infos : $noeud"
 set gdd_type [$noeud Val_MetaData ${objName}_GDD_type_represented]
 if {[string equal $gdd_type {}]} {puts "$noeud do not represent a gdd_type !"; return}
 set PM       [$noeud Val_MetaData ${objName}_GDD_type_for_PM]
 if {[string equal $PM {}]} {puts "$noeud represent $gdd_type GDD type but is not related to any PM !"; return}
 #puts "__GO!"
 #puts "$PM Substitute_by_PM_factory [$gdd_type get_L_factories]"
   set new_PM [$PM Update_factories $gdd_type]
   #puts "  => new PM : \"$new_PM\""
   if {[string equal $new_PM {}]} {return}
# Update of PM metadata in texts 
 set n_pere $this(n_txt_GDD_which_type)
 set it [$n_pere Init_parcours_fils]
 while {![$n_pere Est_parcours_fils_fini $it]} {
   set n [$n_pere Courant_dans_parcours_fils $it]
   set old_PM [$n Val_MetaData ${objName}_GDD_type_for_PM]
   if {[string equal $old_PM $PM]} {
     $n Ajouter_MetaData_T ${objName}_GDD_type_for_PM $new_PM
    }
   set it [$n_pere Suivant_dans_parcours_fils $it]
  }
 $n_pere Terminer_parcours_fils $it
 puts "___END  Clic_on_GDD_type"
}

#___________________________________________________________________________________________________________________________________________
method CSS_Meta_IHM_PM_P_B207_toolglass Clic_on_PM {infos} {
 #puts "$objName Clic_on_PM $infos"
# Clic on a txt node representing a PM
 set noeud [$infos NOEUD]
 set PM [$noeud Val_MetaData ${objName}_PM_represented]
 if {[string equal $PM {}]} {puts "$noeud n'est pas un texte représentant un PM!!!"; return}

# Display corresponding GDD compatibles types
 this Vider_textes $this(n_txt_GDD_which_type)
 this Display_compatible_GDD_types_of $infos $noeud $PM
}

#___________________________________________________________________________________________________________________________________________
method CSS_Meta_IHM_PM_P_B207_toolglass Pointer_in {infos} {
 return
 #puts "$objName Pointer_in $infos"
 Add_element this(L_ptr_in) [$infos Ptr]
 set transfo [$this(n_meta) Val_MetaData ${objName}_transfo_fade_out]
 if {![string equal $transfo {}]} {
   if {[N_i_mere Retirer_deformation_dynamique $transfo]} {$transfo -delete}
   B_configure $this(n_txt_GDD_which_type) -Texture_translucide 1 -Composante_couleur_masque_texture 3 1
   B_configure $this(n_txt_wich_PM)	       -Texture_translucide 1 -Composante_couleur_masque_texture 3 1
  } 
}

#___________________________________________________________________________________________________________________________________________
method CSS_Meta_IHM_PM_P_B207_toolglass Fade_out_txt {transfo} {
 set v [$transfo V_courant]
 B_configure $this(n_txt_GDD_which_type) -Texture_translucide 1 -Composante_couleur_masque_texture 3 [expr 1-$v]
 B_configure $this(n_txt_wich_PM)	     -Texture_translucide 1 -Composante_couleur_masque_texture 3 [expr 1-$v]
}

#___________________________________________________________________________________________________________________________________________
method CSS_Meta_IHM_PM_P_B207_toolglass Pointer_out {infos} {
 return
 puts "$objName Pointer_out $infos"
 Sub_element this(L_ptr_in) [$infos Ptr]
 if {[llength $this(L_ptr_in)] == 0} {
   set transfo [B_transfo 1000]
     set rap_transfo     [B_rappel [Interp_TCL] "$objName Fade_out_txt $transfo"]
	 set rap_transfo_fin [B_rappel [Interp_TCL] "$this(n_meta) Retirer_MetaData_T ${objName}_transfo_fade_out; $objName Vider_textes $this(n_txt_GDD_which_type); $objName Vider_textes $this(n_txt_wich_PM); "]
     $this(n_meta) Ajouter_MetaData_T ${objName}_transfo_fade_out $transfo
	 $transfo abonner_a_rappel_pendant [$rap_transfo     Rappel]
	 $transfo abonner_a_rappel_fin	   [$rap_transfo_fin Rappel]
	 $transfo Demarrer
	 N_i_mere Ajouter_deformation_dynamique $transfo
  }
}

#___________________________________________________________________________________________________________________________________________
method CSS_Meta_IHM_PM_P_B207_toolglass Vider_textes {n_pere} {
 puts "$objName Vider_textes $n_pere"
 set L {}
 $n_pere Afficher_noeud 0
 set it [$n_pere Init_parcours_fils]
 while {![$n_pere Est_parcours_fils_fini $it]} {
   set n [$n_pere Courant_dans_parcours_fils $it]
   if {![string equal [$n Val_MetaData ${objName}_menu_text] {}]} {
     lappend L $n
    }
   set it [$n_pere Suivant_dans_parcours_fils $it]
  }
 $n_pere Terminer_parcours_fils $it
 
# Let's release these texts...
 foreach e $L {this release_L_txt_nodes $e} 
}

#___________________________________________________________________________________________________________________________________________
method CSS_Meta_IHM_PM_P_B207_toolglass get_a_txt_node {} {
#puts "$objName get_a_txt_node"
 set rep [lindex $this(L_free_B_texte) 0]
 if {[string equal $rep {}]} {
   return [B_texte 100 30 25 [fonte_Arial] [B_sim_sds]]
  }
 set this(L_free_B_texte) [lrange $this(L_free_B_texte) 1 end]
 return $rep
}

#___________________________________________________________________________________________________________________________________________
method CSS_Meta_IHM_PM_P_B207_toolglass release_L_txt_nodes {L} {
#puts "$objName release_L_txt_nodes {$L}"
 set L_n {}
 foreach e $L {lappend L_n [Real_class $e]} 
 Add_list this(L_free_B_texte) $L_n
 foreach n $L_n {$n Vider_peres; $n Vider_fils; $n Vider_MetaData}
}

#___________________________________________________________________________________________________________________________________________
method CSS_Meta_IHM_PM_P_B207_toolglass GDD_call_now {infos_origine infos} {
 set noeud [$infos NOEUD]
 
 if {!$this(mode_GDD_active)} {
   puts "$objName has still selected :\n{[this get_selected_elements]}"
   set PM [$noeud Val CometPM]
   if {$PM != ""} {
	 set L_PM_CSS [CSS++ cr "#$PM->PMs, #$PM->LC"]
	 set L  [Liste_Intersection [this get_selected_elements] $L_PM_CSS]
	 if {[llength $L] > 0} {
	   Sub_list L $PM
	   Sub_list L $L_PM_CSS
	   Sub_list L [$PM get_LC]
	  } else {Add_list L $PM
	         }
	 puts "$objName prim_Select_elements {$L}"
     this prim_Select_elements $L
    }
   return
  }
 
 #puts "$objName GDD_call_now $infos_origine $infos : [$infos_origine NOEUD]\n  noeud : $noeud"
 this Vider_textes $this(n_txt_wich_PM)
 this Vider_textes $this(n_txt_GDD_which_type)
   set rap_placement [$this(n_txt_wich_PM) Val_MetaData ${objName}_rap_placement]
   if {[string equal $rap_placement {}]} {
     set rap_placement [B_rappel [Interp_TCL]]
	 $this(n_txt_wich_PM) abonner_a_LR_parcours [$this(n_txt_wich_PM) LR_Av_pre_rendu] [$rap_placement Rappel]
	 $this(n_txt_wich_PM) Ajouter_MetaData_T ${objName}_rap_placement $rap_placement
    }
# What node do you really want to modify? 
 set PM [$noeud Val CometPM]; 
 if {[string equal $PM {}]} {return}
 set L [$PM get_ancestors_and_self]
 #puts $L 
 if {[llength $L] == 0} {return}
 $rap_placement Texte "B207_Line_v $this(n_txt_wich_PM)"
 B_configure $this(n_txt_wich_PM) -Position_des_fils_changeable 0 \
								  -Mode_texture 1 -Mode_texture_fils 1 \
								  -Couleur_fond_texture 0 0 0 0.8 \
								  -Composante_couleur_masque_texture 3 1 \
								  -Afficher_noeud 1 \
								  -Forcer_pre_rendu_noeud 1

 $this(n_txt_wich_PM) Origine [$infos_origine X_au_contact] [$infos_origine Y_au_contact]
   # XXX  DEBUG, transform coordinates according to the father node of $this(n_txt_wich_PM)
   set px [$this(n_txt_wich_PM) Px]; set py [$this(n_txt_wich_PM) Py]
     $this(n_txt_wich_PM) Origine [expr $px*[$this(poly_tg) Ex]] [expr $py*[$this(poly_tg) Ey]]
   
 $this(n_meta) Retirer_fils          $this(n_txt_wich_PM) 
 $this(n_meta) Ajouter_fils_au_debut $this(n_txt_wich_PM) 
 foreach e $L {
   set n_txt [this get_a_txt_node]
   #puts $n_txt
   if {[catch {$n_txt Maj_texte "[[$e get_LC] get_name] : [lindex [gmlObject info classes $e] 0]"} err]} {puts $err}
   B_configure $n_txt -Optimiser_dimensions \
					  -Ajouter_MetaData_T ${objName}_PM_represented $e \
					  -Ajouter_MetaData_T ${objName}_menu_text $this(n_txt_wich_PM) \
					  -Couleur_texte 1 1 1 1 \
					  -Editable 0 -Calculer_boites
   $this(n_txt_wich_PM) Ajouter_fils_au_debut $n_txt
  }
 $this(n_txt_wich_PM) Calculer_boites
}

#___________________________________________________________________________________________________________________________________________
method CSS_Meta_IHM_PM_P_B207_toolglass Display_compatible_GDD_types_of {infos noeud PM} {
 set noeud [$infos NOEUD]
 #puts "$objName Display_compatible_GDD_types_of $infos $noeud $PM"
 set PM_GDD_type [$PM get_GDD_id]
 if {[string equal $PM_GDD_type {}]} {puts "No indicated GDD_type for $PM"; return}
 if {[string equal $PM {}]} {return}
 set PM_ptf [get_Tab_PTF [${PM}_cou_ptf get_soft_type]]
 #puts "Retrieve_equivalents_implem_of [$PM get_DSL_GDD_QUERY] $PM_GDD_type \"\" \"ptf ~= $PM_ptf\""
 set L [Retrieve_equivalents_implem_of [$PM get_DSL_GDD_QUERY] $PM_GDD_type "" "ptf ~= $PM_ptf" 1]
 #puts "Retrived : {$L}"
 if {[string equal $L {}]} {return}
# Configure text node
 this Vider_textes $this(n_txt_GDD_which_type)
   set rap_placement [$this(n_txt_GDD_which_type) Val_MetaData ${objName}_rap_placement]
   if {[string equal $rap_placement {}]} {
     set rap_placement [B_rappel [Interp_TCL]]
	 $this(n_txt_GDD_which_type) abonner_a_LR_parcours [$this(n_txt_GDD_which_type) LR_Av_pre_rendu] [$rap_placement Rappel]
	 $this(n_txt_GDD_which_type) Ajouter_MetaData_T ${objName}_rap_placement $rap_placement
    }
 $rap_placement Texte "B207_Line_v $this(n_txt_GDD_which_type)"
 B_configure $this(n_txt_GDD_which_type) -Position_des_fils_changeable 0 \
								  -Mode_texture 1 -Mode_texture_fils 1 \
								  -Couleur_fond_texture 0 0.3 0.1 0.92 \
								  -Composante_couleur_masque_texture 3 1 \
								  -Afficher_noeud 1 \
								  -Forcer_pre_rendu_noeud 1
 $this(n_meta) Retirer_fils          $this(n_txt_GDD_which_type) 
 $this(n_meta) Ajouter_fils_au_debut $this(n_txt_GDD_which_type) 

 #puts "Building the text list"
# Building the text list
 foreach e $L {
   set c [lindex $e 0]
   set n_txt [this get_a_txt_node]
   $n_txt Maj_texte "Implementations of $c"
   B_configure $n_txt -Optimiser_dimensions \
					  -Ajouter_MetaData_T ${objName}_menu_text $this(n_txt_GDD_which_type) \
					  -Origine 0 0 -Couleur_texte 0.8 0.6 1 1 -Editable 0 -Calculer_boites
   $this(n_txt_GDD_which_type) Ajouter_fils $n_txt
   # Let's process node of this class
   foreach t [lindex $e 1] {
     set n_txt [this get_a_txt_node]
	 $n_txt Maj_texte "     - $t"
     B_configure $n_txt -Optimiser_dimensions \
	  				    -Ajouter_MetaData_T ${objName}_GDD_type_represented $t \
						-Ajouter_MetaData_T ${objName}_menu_text $this(n_txt_GDD_which_type) \
						-Ajouter_MetaData_T ${objName}_GDD_type_for_PM $PM \
					    -Origine 0 0 -Couleur_texte 0.6 0.8 1 1 -Editable 0 -Calculer_boites
     $this(n_txt_GDD_which_type) Ajouter_fils $n_txt
    }
  }

# Positionning the text node thanks to info point and englobing box
 $this(n_txt_wich_PM) Calculer_boites
 $noeud Calculer_boites
   B207_Line_v $this(n_txt_GDD_which_type)
 $this(n_txt_GDD_which_type) Calculer_boites
 set Ox [$this(n_txt_wich_PM) Px]
 set Oy [$this(n_txt_wich_PM) Py]
   set b       [$this(n_txt_GDD_which_type) Boite_noeud_et_fils]
   set b_noeud [$noeud 					    Boite_noeud_et_fils]
 $this(n_txt_GDD_which_type) Origine [expr $Ox-[$b Tx]-[$b BG_X]] \
                                     [expr $Oy + [$noeud Py] + [$b_noeud Ty] - [$b Ty] - [$b BG_Y]]  
 #puts "___END of Display_compatible_GDD_types_of"
}
