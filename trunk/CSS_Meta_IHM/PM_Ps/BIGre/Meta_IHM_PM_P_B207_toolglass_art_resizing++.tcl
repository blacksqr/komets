inherit Meta_IHM_PM_P_B207_toolglass_art_resizing PM_BIGre
if {[file exists [get_B207_files_root]]} {source {C:/These/Projet Interface/BIGre/Contraintes/Constraint_Engine.tcl}}

#___________________________________________________________________________________________________________________________________________
method Meta_IHM_PM_P_B207_toolglass_art_resizing constructor {name descr args} {
 this inherited $name $descr
  #XXX this set_GDD_id N_controller_CUI_basic_gfx_luna_B207
 if {[string length [info proc B_noeud]] > 0} {} else {return $objName}

# Redesigning class
 set this(interpolator) ${objName}_interpolator
 B207_Redesigning_MetaUI $this(interpolator)
 set this(reference_node) ""
 set this(L_transfo_structures)   {}
 set this(id_transfo_structures)  0
 set this(space_of_ref_exemples)  ""
 set this(Do_not_change_ref_vars) 0
 set this(id_for_ref_var) 0
 set this(last_zone_for_presentation_example) ""

# Pool of B207 elements
 set this(L_pool_txt) {}

 # HCI 
 set this(img_reflet) [B_image [get_B207_files_root]reflet_transparent.png]
 set this(img_up)     [B_image [get_B207_files_root]BUp.bmp]
 set this(img_down)   [B_image [get_B207_files_root]BDown.bmp]
 set this(img_what)   [B_image [get_B207_files_root]BWhat.bmp]

 set this(n_meta)  [B_noeud]
 set this(poly_tg) [B_polygone]
 $this(n_meta) Ajouter_fils $this(poly_tg)
 $this(n_meta) Position_des_fils_changeable 0
 B_configure $this(poly_tg) -Translucidite 1 -Couleur 0 0.4 1 0.5 -Ajouter_contour [ProcOvale 0 0 85 85 60] \
                     -Info_texture  NULL \
					   -Info_texture2 [$this(img_reflet) Info_texture] \
										-Combinaison_textures [GL_interpolate_ARB] [GL_add] \
										-Mode_texture 1        \
										-Mode_texture_fils 1   \
										-Mode_texture2 1	   \
										-Nb_pixels_par_unite 1 \
										-Forcer_pre_rendu_noeud 1


 set this(poly_bord) [B_polygone]
   $this(n_meta) Ajouter_fils $this(poly_bord)
 B_configure $this(poly_bord) -Ajouter_contour [ProcOvale 0 0 120 120 60] \
                       -Couleur 1 0.8 0.6 1 \
					   -Difference $this(poly_tg) \
					   -Info_texture  NULL \
					   -Info_texture2 [$this(img_reflet) Info_texture] \
										-Combinaison_textures [GL_interpolate_ARB] [GL_add] \
										-Mode_texture 1        \
										-Mode_texture_fils 1   \
										-Mode_texture2 1	   \
										-Nb_pixels_par_unite 1 \
										-Forcer_pre_rendu_noeud 1
 set this(poly_bord_full) [B_polygone]
   $this(poly_bord_full) Union $this(poly_bord)

# Polygone to navigate in the B207 tree from the toolglass (useful to select invisible nodes)
 set this(poly_select_ref)     [B_polygone]; 
 set this(poly_unselect_ref)   [B_polygone];
 set this(poly_save_ref_into)  [B_polygone];
 set this(toggle_var_changing) [B_polygone];
 set this(poly_what_PM_is_it)  [B_polygone];
# Buttons for selecting the right element, also display the corresponding PM
 # Select the upper element
   set this(poly_go_upper_element) [B_polygone]
 # Select the lower element
   set this(poly_go_lower_element) [B_polygone]
 # Show the corresponding PM name
   set this(txt_corresponding_PM)  [B_texte 20 100 30 [fonte_Arial] [B_sim_sds]]

# Buttons configuration
   set mini_tg_radius 15
   B_configure $this(poly_select_ref)     -Ajouter_contour [ProcOvale 0 0 $mini_tg_radius $mini_tg_radius 60] \
                                          -Couleur 0 0 1 0.5 \
							              -Info_texture NULL \
										  -Info_texture2 [$this(img_reflet) Info_texture] -Combinaison_textures [GL_interpolate_ARB] [GL_add] -Mode_texture 1 -Mode_texture_fils 1 -Mode_texture2 1 -Nb_pixels_par_unite 1 -Forcer_pre_rendu_noeud 1
   B_configure $this(poly_unselect_ref)   -Union $this(poly_select_ref) \
                                          -Couleur 1 0 0 0.5 \
							              -Info_texture NULL \
										  -Info_texture2 [$this(img_reflet) Info_texture] -Combinaison_textures [GL_interpolate_ARB] [GL_add] -Mode_texture 1 -Mode_texture_fils 1 -Mode_texture2 1 -Nb_pixels_par_unite 1 -Forcer_pre_rendu_noeud 1
   B_configure $this(poly_save_ref_into)  -Union $this(poly_select_ref) \
                                          -Couleur 0 1 0 0.5 \
							              -Info_texture NULL \
										  -Info_texture2 [$this(img_reflet) Info_texture] -Combinaison_textures [GL_interpolate_ARB] [GL_add] -Mode_texture 1 -Mode_texture_fils 1 -Mode_texture2 1 -Nb_pixels_par_unite 1 -Forcer_pre_rendu_noeud 1
   B_configure $this(toggle_var_changing) -Union $this(poly_select_ref) \
                                          -Couleur 0 1 0 1 \
							              -Info_texture NULL \
										  -Info_texture2 [$this(img_reflet) Info_texture] -Combinaison_textures [GL_interpolate_ARB] [GL_add] -Mode_texture 1 -Mode_texture_fils 1 -Mode_texture2 1 -Nb_pixels_par_unite 1 -Forcer_pre_rendu_noeud 1
   # Buttons for navigation   
   B_configure $this(poly_what_PM_is_it)    -Union $this(poly_select_ref) \
                                            -Couleur 1 1 1 0.7 \
							                -Info_texture  [$this(img_what)   Info_texture] \
										    -Info_texture2 [$this(img_reflet) Info_texture] -Combinaison_textures [GL_interpolate_ARB] [GL_add] -Mode_texture 1 -Mode_texture_fils 1 -Mode_texture2 1 -Nb_pixels_par_unite 1 -Forcer_pre_rendu_noeud 1
   B_configure $this(poly_go_upper_element) -Union $this(poly_select_ref) \
                                            -Couleur 1 1 1 0.7 \
							                -Info_texture  [$this(img_up)     Info_texture] \
										    -Info_texture2 [$this(img_reflet) Info_texture] -Combinaison_textures [GL_interpolate_ARB] [GL_add] -Mode_texture 1 -Mode_texture_fils 1 -Mode_texture2 1 -Nb_pixels_par_unite 1 -Forcer_pre_rendu_noeud 1
   B_configure $this(poly_go_lower_element) -Union $this(poly_select_ref) \
                                            -Couleur 1 1 1 0.7 \
							                -Info_texture  [$this(img_down)   Info_texture] \
										    -Info_texture2 [$this(img_reflet) Info_texture] -Combinaison_textures [GL_interpolate_ARB] [GL_add] -Mode_texture 1 -Mode_texture_fils 1 -Mode_texture2 1 -Nb_pixels_par_unite 1 -Forcer_pre_rendu_noeud 1

# Save buttons lists
   set this(L_buttons_var_refs) [list $this(poly_select_ref) $this(poly_unselect_ref) $this(poly_save_ref_into)]
   set this(L_buttons_poly) $this(L_buttons_var_refs); lappend this(L_buttons_poly) $this(toggle_var_changing) $this(poly_go_upper_element) $this(poly_go_lower_element)
   foreach bt $this(L_buttons_poly) {
     B_poly_devient_bouton $bt
    }

# Place poly_select_ref
 set r 17.0; set R 102.5; set PI 3.14159265
 set a [expr $PI/2.0 - 0*asin($r/$R)]
 $this(poly_select_ref) Origine [expr $R*cos($a)] [expr $R*sin($a)]
   $this(n_meta)    Ajouter_fils_au_debut $this(poly_select_ref)
   $this(poly_bord) Difference 			  $this(poly_select_ref)
   C_B_Toolglass $this(poly_select_ref) "if {\[catch {$objName add_reference_var \[\$infos NOEUD\]} err]} {puts \"ERROR in $this(poly_select_ref)\n\$err\"}"
 set a [expr $PI/2.0 + 2*asin($r/$R)]
 $this(poly_unselect_ref) Origine [expr $R*cos($a)] [expr $R*sin($a)]
   $this(n_meta)    Ajouter_fils_au_debut $this(poly_unselect_ref)
   $this(poly_bord) Difference 			  $this(poly_unselect_ref)
   C_B_Toolglass $this(poly_unselect_ref) "if {\[catch {$objName Unset_ref_vars \[\$infos NOEUD\]} err]} {puts \"ERROR in $this(poly_select_ref)\n\$err\"}"
   
 set a [expr $PI/2.0 - 2*asin($r/$R)]
 $this(poly_save_ref_into) Origine [expr $R*cos($a)] [expr $R*sin($a)]
   $this(n_meta)    Ajouter_fils_au_debut $this(poly_save_ref_into)
   $this(poly_bord) Difference  	      $this(poly_save_ref_into)
   C_B_Toolglass $this(poly_save_ref_into) "if {\[catch {$objName Save_refs_into \[\$infos NOEUD\]} err]} {puts \"ERROR in $this(poly_select_ref)\n\$err\"}"

 set a [expr 0]
 #$this(toggle_var_changing) Origine [expr $R*cos($a)] [expr $R*sin($a)]
 #  $this(n_meta) Ajouter_fils_au_debut $this(toggle_var_changing)
 #  set this(rap_toggle_var_changing) [B_rappel [Interp_TCL] "$objName set_Do_not_change_ref_vars \[expr 1-\[$objName get_Do_not_change_ref_vars\]\]"] 
 #  $this(toggle_var_changing) abonner_a_detection_pointeur [$this(rap_toggle_var_changing) Rappel] [ALX_pointeur_relache]
 set this(meta_tg_GDD) ${objName}_meta_tg_GDD
 CSS_Meta_IHM_PM_P_B207_toolglass $this(meta_tg_GDD) "GDD Toolglass" "Toolglass for GDD access"
   set poly_tg_GDD [$this(meta_tg_GDD) get_poly_tg]; $poly_tg_GDD Calculer_boites;
   set this(noeud_for_tg_GDD) [B_noeud];
	 $this(noeud_for_tg_GDD) Ajouter_fils [$this(meta_tg_GDD) get_n_for_GDD_txt_infos]
     $this(noeud_for_tg_GDD) Ajouter_fils $poly_tg_GDD;
	 $this(noeud_for_tg_GDD) Position_des_fils_changeable 0
	 set box_tg_GDD [$poly_tg_GDD Boite_noeud]
   $poly_tg_GDD            Etirement [expr 2*$mini_tg_radius/[$box_tg_GDD Tx]] [expr 2*$mini_tg_radius/[$box_tg_GDD Ty]]
   $this(n_meta)           Ajouter_fils_au_debut $this(noeud_for_tg_GDD)
   $this(noeud_for_tg_GDD) Origine               [expr $R*cos($a)] [expr $R*sin($a)]
   $this(poly_bord)        Difference            $poly_tg_GDD $this(n_meta)
   
 set a [expr $PI + 2*asin($r/$R)]
 $this(poly_what_PM_is_it) Origine [expr $R*cos($a)] [expr $R*sin($a)]
   $this(n_meta)    Ajouter_fils          $this(poly_what_PM_is_it)
   $this(poly_bord) Difference            $this(poly_what_PM_is_it)
   C_B_Toolglass $this(poly_what_PM_is_it) "if {\[catch {$objName What_PM_is_it \[\$infos NOEUD\]} err]} {puts \"ERROR in $this(poly_go_upper_element)\n\$err\"}"

 set a [expr $PI - 2*asin($r/$R)]
 $this(poly_go_upper_element) Origine [expr $R*cos($a)] [expr $R*sin($a)]
   $this(n_meta)    Ajouter_fils $this(poly_go_upper_element)
   $this(poly_bord) Difference 			  $this(poly_go_upper_element)
   C_B_Toolglass $this(poly_go_upper_element) "if {\[catch {$objName Select_upper_element \[\$infos NOEUD\]} err]} {puts \"ERROR in $this(poly_go_upper_element)\n\$err\"}"
   
 set a [expr $PI]
 $this(poly_go_lower_element) Origine [expr $R*cos($a)] [expr $R*sin($a)]
   $this(n_meta)    Ajouter_fils $this(poly_go_lower_element)
   $this(poly_bord) Difference 			  $this(poly_go_lower_element)
   C_B_Toolglass $this(poly_go_lower_element) "if {\[catch {$objName Select_lower_element \[\$infos NOEUD\]} err]} {puts \"ERROR in $this(poly_go_lower_element)\n\$err\"}"
   
# Configuration of contacts and toolglass callback
 B_contact ctc_$this(n_meta) "$this(n_meta) 0" -add "$this(poly_bord) 1"
 C_B_Toolglass $this(poly_tg) "if {\[catch {$objName Central_clic_on \$infos_origine \$infos} err]} {puts \"ERROR in $this(poly_tg)\n\$err\"}"

# Saving the poly bord with holes
  set this(poly_bord_holes) [B_polygone]
   $this(poly_bord_holes) Union $this(poly_bord)

 this set_prim_handle [list $this(n_meta)]
# Call of the extra constructor parameters
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Generate_accessors Meta_IHM_PM_P_B207_toolglass_art_resizing [list poly_bord Do_not_change_ref_vars reference_node L_transfo_structures id_transfo_structures space_of_ref_exemples]

#___________________________________________________________________________________________________________________________________________
method Meta_IHM_PM_P_B207_toolglass_art_resizing get_a_txt_node {} {
 if {[llength $this(L_pool_txt)]} {
   set rep [lindex $this(L_pool_txt) 0]
   set this(L_pool_txt) [lreplace $this(L_pool_txt) 0 0]
  } else {set rep [B_texte 20 100 30 [fonte_Arial] [B_sim_sds]]}
 return $rep
}

#___________________________________________________________________________________________________________________________________________
method Meta_IHM_PM_P_B207_toolglass_art_resizing Release_txt_node {n} {
 Add_element this(L_pool_txt) $n
 $n Vider_peres
}

#___________________________________________________________________________________________________________________________________________
# Trigger an animation fade out of the text
#___________________________________________________________________________________________________________________________________________
method Meta_IHM_PM_P_B207_toolglass_art_resizing What_PM_is_it {noeud} {
 puts "$objName What_PM_is_it $noeud"
# Is it a zone?
 if {![string equal [$noeud Val_MetaData Meta_IHM_PM_P_B207_toolglass_art_resizing_is_a_zone] {}]} {
   this Display_examples $noeud [$noeud Val_MetaData Meta_IHM_PM_P_B207_toolglass_art_resizing_L_var_obj]
   return
  }
# If not a zone, then tetrieve some infos about the node
 set managed_node [$noeud Val B207_Transfo_Structure_Managed_node]
 if {![string equal $managed_node ""]} {
   puts "  Managed node : $managed_node"
   set PM [$managed_node Val Real_PM]; if {[string equal $PM ""]} {set PM [$managed_node Val CometPM]}
   if {![string equal $PM ""]} {set info_to_display $PM} else {puts "  No related PM"; return}
  } else {set PM [$noeud Val Real_PM]; if {[string equal $PM ""]} {set PM [$noeud Val CometPM]}
          if {![string equal $PM ""]} {set info_to_display $PM} else {puts "  No related PM"; return}
		 }

# Get a B207 text node to present infos
 set n_txt [this get_a_txt_node]
# Set text
 $n_txt TEXTE $info_to_display;
 B_configure $n_txt -Optimiser_dimensions -Calculer_boites \
                    -Noeud_touchable 0 -Couleur_texte 1 1 1 1 \
					-Editable 0
 $this(n_meta) Ajouter_fils_au_debut $n_txt
# Place node
 set b_box [$this(poly_what_PM_is_it) Boite_noeud_et_fils_glob]
 set n_box [$n_txt Boite_noeud]
 $n_txt Origine [expr [$b_box Cx]-[$n_box Cx]] [expr [$b_box Cy]-[$n_box Cy]]
# Trigger animation (with a delay to start)
 set transfo [B_transfo 2000]
   $transfo Delai_amorce 1000
   $transfo Demarrer; N_i_mere Ajouter_deformation_dynamique $transfo
   set rap_pdt [B_rappel [Interp_TCL] "$n_txt Couleur_texte 1 1 1 \[expr 1-\[$transfo V_courant\]\]"]
     $transfo abonner_a_rappel_pendant [$rap_pdt Rappel]
   set rap_fin [B_rappel [Interp_TCL] "$objName Release_txt_node $n_txt"]
     $transfo abonner_a_rappel_fin [$rap_fin Rappel]
}

#___________________________________________________________________________________________________________________________________________
# List of ancestor from the closest to original ref node to the farest
method Meta_IHM_PM_P_B207_toolglass_art_resizing Select_upper_element {n_transfo_structure} {
 puts "$objName Select_upper_element $n_transfo_structure"
# Is it really a transfo structure?
 set noeud [$n_transfo_structure Val B207_Transfo_Structure_Managed_node]
 if {[string equal $noeud ""]} {
   puts "Meta_IHM_PM_P_B207_toolglass_art_resizing Select_upper_element:\n  $n_transfo_structure is not a transfo structure"; 
   return
  }
 
# If yes, then find the transformed node and take its father
#set Real_PM [$noeud Val Real_PM]
 set pere    [$noeud Pere]; 
 set noeud_Real_PM [$noeud Val Real_PM]
 set Real_PM ""

 # Check if it is the root of a composite PM
 if {[string equal $noeud_Real_PM ""]} {
   set noeud_PM [$noeud Val CometPM]
   if {![string equal $noeud_PM {}]} {
     set pere_PM [lindex [$noeud_PM get_mothers] 0]
	 set L_handle_composing_comets [$pere_PM get_handle_composing_comet]
	 if {[lsearch $L_handle_composing_comets $noeud_PM] != -1} {
	   puts "_____ Let's place in the composite PM $pere_PM"
	   set Real_PM $pere_PM
	   set next_pere $pere
	   set pere [lindex [$pere_PM get_prim_handle] 0]
	   $pere Ajouter_MetaData_T upper_element $next_pere
	  }
    }
  } else {puts "_____ noeud_Real_PM already specified : $noeud_Real_PM"
          set next [$noeud Val_MetaData upper_element]
		  if {[string equal $next ""]} {set pere $noeud} else {set pere $next}
		 }
  
 if {![string equal $pere NULL]} {
  # Unmanage previous node
   set transfo_structure [$noeud Val_MetaData Transfo_structure]
   if {![string equal $transfo_structure {}]} {$transfo_structure UnManage_node}
   $noeud Retirer_MetaData_T Transfo_structure
  # Manage new one
   puts "  $pere Ajouter_au_contexte Real_PM \"$Real_PM\""
   $pere Ajouter_au_contexte Real_PM $Real_PM; $pere Charger_contexte_local
     this Adapt_node $pere
   if {![string equal $pere $noeud]} {$pere Ajouter_MetaData_T lower_element $noeud}
  }

 this What_PM_is_it $pere
}

#___________________________________________________________________________________________________________________________________________
method Meta_IHM_PM_P_B207_toolglass_art_resizing Select_lower_element {n_transfo_structure} {
 set noeud [$n_transfo_structure Val B207_Transfo_Structure_Managed_node] 
 if {[string equal $noeud ""]} {puts "Meta_IHM_PM_P_B207_toolglass_art_resizing Select_lower_element:\n  $n_transfo_structure is not a transfo structure"; return}
 
 set n_lower [$noeud Val_MetaData lower_element]
 $n_lower Ajouter_MetaData_T Real_PM ""
 if {[string equal $n_lower ""]} {puts "Meta_IHM_PM_P_B207_toolglass_art_resizing Select_lower_element:\n  No lower node specifyed in managed node $noeud"; return}

# Unmanage previous node
 set transfo_structure [$noeud Val_MetaData Transfo_structure]
 if {![string equal $transfo_structure {}]} {$transfo_structure UnManage_node}
# Manage new one
 this Adapt_node $n_lower
}

#___________________________________________________________________________________________________________________________________________
method Meta_IHM_PM_P_B207_toolglass_art_resizing set_Do_not_change_ref_vars {b} {
 set this(Do_not_change_ref_vars) $b
 foreach bt $this(L_buttons_var_refs) {
   $bt Afficher_noeud [expr 1-$b]
   $bt Gerer_contacts [expr 1-$b]
  }
 if {$b} {
   $this(poly_bord) Vider
   $this(poly_bord) Union $this(poly_bord_full)
  } else {$this(poly_bord) Vider
          $this(poly_bord) Union $this(poly_bord_holes)
         }
}

#___________________________________________________________________________________________________________________________________________
method Meta_IHM_PM_P_B207_toolglass_art_resizing Save_refs_into {noeud} {
 set L_var_obj [$this(reference_node) Val_MetaData Meta_IHM_PM_P_B207_toolglass_art_resizing_L_var_obj]
 $noeud Ajouter_MetaData_T Meta_IHM_PM_P_B207_toolglass_art_resizing_L_var_obj $L_var_obj
 $noeud Ajouter_MetaData_T Meta_IHM_PM_P_B207_toolglass_art_resizing_rap_dims  [$this(reference_node) Val_MetaData Meta_IHM_PM_P_B207_toolglass_art_resizing_rap_dims ]
 $noeud Ajouter_MetaData_T Meta_IHM_PM_P_B207_toolglass_art_resizing_is_a_zone 1
 
 this Display_examples $noeud $L_var_obj
}

#___________________________________________________________________________________________________________________________________________
# This method is called each time the reference vars are modified, it's aim it to deal with different set of ref vars
# Indeed, ref vars may be associated to a zone of validity (i.e. a shape in the space defined by ref vars (e.g. length and width))
# So here we just check wether we are in a new shape using new vars or not
#___________________________________________________________________________________________________________________________________________
method Meta_IHM_PM_P_B207_toolglass_art_resizing Do_we_change_ref_vars {} {
 if {[string equal $this(space_of_ref_exemples) ""] || [this get_Do_not_change_ref_vars]} {return}
 set L_ref_vars [$this(reference_node) Val_MetaData Meta_IHM_PM_P_B207_toolglass_art_resizing_L_var_obj]
   set var_x [lindex $L_ref_vars 0]; set x [$var_x get_current_value]
   set var_y [lindex $L_ref_vars 1]; set y [$var_y get_current_value]
   $this(space_of_ref_exemples) set_current_point $x $y;
 set poly_zone [$this(space_of_ref_exemples) get_poly_zone_under $x $y]
 if {![string equal $poly_zone NULL]} {
  # Do we have to change reference variables?
   # Retrieve reference variables associated with poly_zone
   #set new_ref_vars [$poly_zone Val_MetaData ${objName}_L_ref_vars]
   set new_ref_vars [$poly_zone Val_MetaData Meta_IHM_PM_P_B207_toolglass_art_resizing_L_var_obj]
   if {[string equal $new_ref_vars ""]} {
     puts "The new poly zone has no associated reference variables"
	 return
    }
   set L_ref_vars [$this(reference_node) Val_MetaData Meta_IHM_PM_P_B207_toolglass_art_resizing_L_var_obj]
   # If different, change
   set zone_has_changed 0
   set nb [llength $new_ref_vars]
   if {$nb == [llength $L_ref_vars]} {
     set pos 0;
     while {$pos < $nb} {
       set old_v [lindex $L_ref_vars   $pos]
	   set new_v [lindex $new_ref_vars $pos]
	   if {![string equal $old_v $new_v]} {
	     set zone_has_changed 1
	     # Desabonner old_v
	     $old_v Do_unsubscribe
	     # Abonner new_v
	     $new_v Do_subscribe
	    }
	   incr pos
      }
	} else {foreach rv $L_ref_vars   {$rv Do_unsubscribe}
	        foreach rv $new_ref_vars {$rv Do_subscribe}
			set zone_has_changed 1
	       }
   if {$zone_has_changed} {
    # Display examples
     this Display_examples $poly_zone $new_ref_vars
    }
  # Update MetaDatas in reference node
   $this(reference_node) Ajouter_MetaData_T Meta_IHM_PM_P_B207_toolglass_art_resizing_L_var_obj $new_ref_vars
  }
}

#___________________________________________________________________________________________________________________________________________
method Meta_IHM_PM_P_B207_toolglass_art_resizing Update_presentation_of_examples {L_v} {
 set zone [$this(space_of_ref_exemples) get_current_zone]
 if {[string equal $zone NULL]} {
   set zone $this(last_zone_for_presentation_example)
   if {[string equal $zone ""]} {return}
  }
 if {[string equal $zone NULL]} {return}
 set new_ref_vars [$zone Val_MetaData Meta_IHM_PM_P_B207_toolglass_art_resizing_L_var_obj]
 this Display_examples $zone $L_v
}

#___________________________________________________________________________________________________________________________________________
method Meta_IHM_PM_P_B207_toolglass_art_resizing Unset_ref_vars {noeud} {
# Check if it is an example...
 if {[string equal [$noeud Val_MetaData Is_an_example] 1]} {
   set L_rel_vars [$noeud Val_MetaData L_rel_vars]
   foreach v $L_rel_vars {
     $v Sub_exemples_related_to [$noeud Px] [$noeud Py]
    }
   set this(last_zone_for_presentation_example) ""
   set L_ref_vars [$noeud Val_MetaData L_ref_vars]
     this Update_presentation_of_examples $L_ref_vars
     foreach v $L_ref_vars {puts "$v Compute"; $v Compute}
  #puts "  Examples related to point ([$noeud Px] ; [$noeud Py]) where destroyed for $v"
   return
  }

# If not, check if it is a reference
 set L_ref_vars [$noeud Val_MetaData Meta_IHM_PM_P_B207_toolglass_art_resizing_L_var_obj]
 set rap        [$noeud Val_MetaData Meta_IHM_PM_P_B207_toolglass_art_resizing_rap_dims ]
 foreach rv $L_ref_vars {
  #puts "$rv Do_unsubscribe"
   $rv Do_unsubscribe
  }
 $noeud Retirer_MetaData_T Meta_IHM_PM_P_B207_toolglass_art_resizing_L_var_obj
 $noeud Retirer_MetaData_T Meta_IHM_PM_P_B207_toolglass_art_resizing
}

#___________________________________________________________________________________________________________________________________________
method Meta_IHM_PM_P_B207_toolglass_art_resizing Display_examples {poly_zone L_ref_vars} {
#puts "$objName Display_examples $poly_zone {$L_ref_vars}"
 set this(last_zone_for_presentation_example) $poly_zone
# Get the root where to plug examples representation
 set root [$poly_zone Pere]
# Retrieve examples related to this zone
#puts "Retrieve examples related to $poly_zone in {$L_ref_vars}"
# set T_points {}
 foreach ref_v $L_ref_vars {
   foreach rel_v [$ref_v get_L_related_vars] {
     foreach ex [$rel_v get_L_examples] {
	   set id [lindex $ex 3]
	   if {![string equal $ref_v [lindex $id 1]]} {continue}
	   set x [lindex $ex 4]; set y [lindex $ex 5]
	    #puts "  \[array get T_points $x,$y\] = [array get T_points $x,$y]"
	     set vals_prev [lindex [array get T_points $x,$y] 1]
	     Add_list vals_prev $rel_v
	     set T_points($x,$y) $vals_prev
	   set T_vars($x,$y,[lindex $id 0]) [lrange $id 1 end]
	  }
    }
  }
# Update points examples in the examples space
 $this(space_of_ref_exemples) Free_all_poly_points
 #puts "T_points : {[array get T_points]}"
 foreach {coord L} [array get T_points] {
   set c [split $coord ,]
   set cmd "$this(space_of_ref_exemples) get_a_poly_point $c"
   set poly_pt [eval $cmd]
   $poly_pt Ajouter_MetaData_T L_rel_vars $L
   $poly_pt Ajouter_MetaData_T L_ref_vars $L_ref_vars
   # Subscribe to click...
     set rap_click [$poly_pt Val_MetaData Meta_IHM_PM_P_B207_toolglass_art_resizing_rap_on_click]
	 if {[string equal $rap_click {}]} {
  	   set rap_click [B_rappel [Interp_TCL]]
	   $poly_pt Ajouter_MetaData_T Meta_IHM_PM_P_B207_toolglass_art_resizing_rap_on_click $rap_click
	   $poly_pt abonner_a_detection_pointeur [$rap_click Rappel] [ALX_pointeur_relache]
	  }
	 # Retrice couples ref var ref val...
	 set L_ref_var_ref_val {}
	#puts "______\n[array get T_vars $coord,*]\n________"
	 foreach {indice var_val} [array get T_vars $coord,*] {
	   lappend L_ref_var_ref_val $var_val
	  }
	 # Subscribe...
	#puts "  - L_ref_var_ref_val : {$L_ref_var_ref_val}"
	 $rap_click Texte "$objName Goto_pt_example $poly_pt {$L_ref_var_ref_val}"
  }
#puts "  END"
}

#___________________________________________________________________________________________________________________________________________
method Meta_IHM_PM_P_B207_toolglass_art_resizing Goto_pt_example {poly_pt L_ref_var_ref_val} {
 puts "$objName Goto_pt_example $poly_pt {$L_ref_var_ref_val}"
 foreach ref_var_ref_val $L_ref_var_ref_val {
   set cmd "[lindex $ref_var_ref_val 0] set_current_val [lindex $ref_var_ref_val 1]"
   puts "  - $cmd"
   eval $cmd
  }
 set cmd [[lindex $cmd 0] get_cmd_get]
 if {[catch {[lindex $cmd 0] Mettre_a_jour} err]} {puts "  ...ERROR: [lindex $cmd 0] Mettre_a_jour\n     $err"}
}

#___________________________________________________________________________________________________________________________________________
method Meta_IHM_PM_P_B207_toolglass_art_resizing get_interpolator {} {
 return $this(interpolator)
}

#___________________________________________________________________________________________________________________________________________
method Meta_IHM_PM_P_B207_toolglass_art_resizing add_reference_var {noeud} {
 set noeud [Real_class $noeud]
# Is this still the reference node?
 if {[string equal $this(reference_node) $noeud]} {puts "$objName add_reference_var $noeud:\n  This is still the reference node"; return}
 if {[string equal [$noeud Val_MetaData Meta_IHM_PM_P_B207_toolglass_art_resizing] $objName]} {
  # Unsubscribe reference variables related to previous reference nodes
   puts "  REFERENCE NODE IS NOW $noeud, it was still a reference node previously used"
   set L_ref_vars [$this(reference_node) Val_MetaData Meta_IHM_PM_P_B207_toolglass_art_resizing_L_var_obj]
   set rap        [$this(reference_node) Val_MetaData Meta_IHM_PM_P_B207_toolglass_art_resizing_rap_dims]
     set lg_var [lindex $L_ref_vars 0]
	 set ht_var [lindex $L_ref_vars 1]
     eval [$lg_var get_cmd_unsubscribe] 
	 eval [$lg_var get_cmd_unsubscribe] 
   set this(reference_node) $noeud
   set L_ref_vars [$this(reference_node) Val_MetaData Meta_IHM_PM_P_B207_toolglass_art_resizing_L_var_obj]
     set lg_var [lindex $L_ref_vars 0]
	 set ht_var [lindex $L_ref_vars 1]
     eval [$lg_var get_cmd_subscribe]
	 eval [$lg_var get_cmd_subscribe]
	 eval [$rap Texte]
   return
  }
  
# Is this a window? Then subscribe to length and width
 if {[llength [B_Aide_nom_list $noeud Hauteur_corp]] >= 1} {
  # Create var to look up
   set lg_var [$this(interpolator) add_reference_var "$noeud Longueur_corp" "$noeud Longueur_corp" "$noeud abonner_a_dimension" "$noeud desabonner_de_dimension"]
   set ht_var [$this(interpolator) add_reference_var "$noeud Hauteur_corp"  "$noeud Hauteur_corp"  "$noeud abonner_a_dimension" "$noeud desabonner_de_dimension"]
  # OK, clean up for the next...  
   set L_var_obj [list $lg_var $ht_var]
   set noeud [$noeud Noeud_scene]
   set this(reference_node) $noeud
  } else {puts "Nothing to do with $noeud (we can not subscribe to stretching for now in B207)"
          return
         }
# Add meta data to the node
 puts "  REFERENCE NODE IS NOW $noeud"
 $this(poly_tg) Couleur 0 1 0 1
 $noeud Ajouter_MetaData_T Meta_IHM_PM_P_B207_toolglass_art_resizing $objName
 $noeud Ajouter_MetaData_T Meta_IHM_PM_P_B207_toolglass_art_resizing_L_var_obj $L_var_obj
# Subscribe to reference variables
 set rap [B_rappel [Interp_TCL] "$objName Do_we_change_ref_vars"]
   $noeud Ajouter_MetaData_T Meta_IHM_PM_P_B207_toolglass_art_resizing_rap_dims $rap
 eval "[$lg_var get_cmd_subscribe] [$rap Rappel]" 
 eval "[$ht_var get_cmd_subscribe] [$rap Rappel]"
 eval [$rap Texte]
}

#___________________________________________________________________________________________________________________________________________
method Meta_IHM_PM_P_B207_toolglass_art_resizing sub_reference_var {noeud} {
 
}

#___________________________________________________________________________________________________________________________________________
method Meta_IHM_PM_P_B207_toolglass_art_resizing Central_clic_on {infos_origine infos} {
 set noeud [$infos NOEUD]
 set this(L_ref_node_ancestor) $noeud
 puts "$objName add_reference_var $noeud :"
 if {![string equal $this(reference_node) {}]} {
   if {[string equal $noeud $this(reference_node)]} {
	 return
	}
   this Adapt_node $noeud
   return
  }
  
 # XXX DEBUG 
   return 
   
 set L [$noeud Val_MetaData Meta_IHM_PM_P_B207_toolglass_art_resizing]
 if {![string equal $L {}]} {
   puts "  $noeud is still managed by $objName"; 
   set this(reference_node) $noeud
   return
  }
#this add_reference_var $noeud
}

#___________________________________________________________________________________________________________________________________________
method Meta_IHM_PM_P_B207_toolglass_art_resizing get_a_transfo_structure {} {
 if {[llength $this(L_transfo_structures)]} {
   set rep [lindex $this(L_transfo_structures) 0]
   set this(L_transfo_structures) [lrange $this(L_transfo_structures) 1 end]
  } else {set rep ${objName}_Transfo_Structure_$this(id_transfo_structures)
          incr this(id_transfo_structures)
          B207_Transfo_Structure $rep
		 }
 return $rep
}

#___________________________________________________________________________________________________________________________________________
method Meta_IHM_PM_P_B207_toolglass_art_resizing release_transfo_structure {t} {
 Add_element this(L_transfo_structures) $t
}

#___________________________________________________________________________________________________________________________________________
method Meta_IHM_PM_P_B207_toolglass_art_resizing get_a_unique_id_for_ref_var {} {
 incr this(id_for_ref_var)
 return $this(id_for_ref_var)
}

#___________________________________________________________________________________________________________________________________________
method Meta_IHM_PM_P_B207_toolglass_art_resizing Adapt_node {noeud} {
 #puts "$objName Adapt_node $noeud"
 set n [$noeud Val Meta_IHM_PM_P_B207_toolglass_art_resizing]
 if {[string equal $n $objName]} {
 # Add exemple (position, rotation, stretching...)
   set s [$noeud Val B207_Transfo_Structure]
   set managed_node [$noeud Val B207_Transfo_Structure_Managed_node]
     set lg_var [$managed_node Val_MetaData ${objName}_lg_var]
	 set ht_var [$managed_node Val_MetaData ${objName}_ht_var]
   set L_var_obj [$this(reference_node) Val_MetaData Meta_IHM_PM_P_B207_toolglass_art_resizing_L_var_obj]
     set op <
	 set id_ref_var ref_var_[this get_a_unique_id_for_ref_var]
	   set val_x_ref [$lg_var get_current_val]
	   set val_y_ref [$ht_var get_current_val]
	  # XXX DEBUG
	  # THIS IS NOT $lg_var and $ht_var that have to been saved...but vars directly related to the manipulated UI element
	   puts "example : $id_ref_var lg $val_x_ref $val_y_ref\n  - lg_var : $lg_var\n  - ht_var : $ht_var\n  - noeud : $noeud\n  -MetaData : [$noeud T_MetaData]"
	   puts "  - managed_node : $managed_node"
	   puts "  - managed MetaData : [$managed_node T_MetaData]"
	   foreach v [$managed_node Val_MetaData ${objName}_lg_var_L_rel_var] {
	     $v Add_current_exemple $val_x_ref $op "$id_ref_var {lg $lg_var $val_x_ref} $val_x_ref $val_y_ref"
	    }
	   foreach v [$managed_node Val_MetaData ${objName}_ht_var_L_rel_var] {
	     $v Add_current_exemple $val_y_ref $op "$id_ref_var {ht $ht_var $val_y_ref} $val_x_ref $val_y_ref"
	    }
       this Update_presentation_of_examples [list $lg_var $ht_var]
	   #$lg_var add_current_exemple $op "$id_ref_var {lg $lg_var $val_x_ref} $val_x_ref $val_y_ref"
	   #$ht_var add_current_exemple $op "$id_ref_var {ht $ht_var $val_y_ref} $val_x_ref $val_y_ref"
  # Quit
   set rap_redim_after_refs_change [$managed_node Val_MetaData rap_redim_after_refs_change]
     set L_var_obj [$managed_node Val_MetaData L_var_obj]
	 foreach v $L_var_obj {
	   set cmd_unsubscribe [$v get_cmd_unsubscribe]
	   eval "$cmd_unsubscribe [$rap_redim_after_refs_change Rappel]"
	  }
   set name [$noeud Val B207_Transfo_Structure]
     if {[string equal $name {}]} {
	   puts "  PROBLEM : \"$noeud Val B207_Transfo_Structure\" => {}"
	  } else {$name UnManage_node
	          this release_transfo_structure $name
			 }
   $noeud Retirer_MetaData_T Is_edited_by
  # If related to a PM, then free meta data indicating it is being edited
   set PM [$managed_node Val Real_PM]; if {[string equal $PM ""]} {set PM [$managed_node Val CometPM]} 
   if {![string equal $PM {}]} {
	 if {[$PM Has_MetaData Is_edited_by_Meta_IHM_PM_P_B207_toolglass_art_resizing]} {
	   $PM Sub_MetaData Is_edited_by_Meta_IHM_PM_P_B207_toolglass_art_resizing
	  }
	}
   #puts "  EXEMPLE ADDED for $noeud"
   return
  }
  
# Create depending variables to be interpolated if not done...
 set L_var_obj [$this(reference_node) Val_MetaData Meta_IHM_PM_P_B207_toolglass_art_resizing_L_var_obj]
   set lg_var [lindex $L_var_obj 0]
     if {![string equal [$noeud Val_MetaData ${objName}_lg_var] $lg_var]} {
	   set     L_rel_v [$lg_var Add_var "$noeud Px" "$noeud Px"]
	   lappend L_rel_v [$lg_var Add_var "$noeud Ex" "$noeud Ex"]
	   $noeud Ajouter_MetaData_T ${objName}_lg_var           $lg_var
	   $noeud Ajouter_MetaData_T ${objName}_lg_var_L_rel_var $L_rel_v
	   puts "  LG RELATED VARIABLES CREATED FOR $noeud"
	  }
   set ht_var [lindex $L_var_obj 1]
     if {![string equal [$noeud Val_MetaData ${objName}_ht_var] $ht_var]} {
       set     L_rel_v [$ht_var Add_var "$noeud Py" "$noeud Py"]
	   lappend L_rel_v [$ht_var Add_var "$noeud Ey" "$noeud Ey"]
	   $noeud Ajouter_MetaData_T ${objName}_ht_var           $ht_var
	   $noeud Ajouter_MetaData_T ${objName}_ht_var_L_rel_var $L_rel_v
	   puts "  HT RELATED VARIABLES CREATED FOR $noeud"
	  }
 
# Plug the transformation structure 
 set name [this get_a_transfo_structure]
 $name UnManage_node
 $name Manage_node $noeud
   $noeud Ajouter_MetaData_T Is_edited_by      $objName
   $noeud Ajouter_MetaData_T Transfo_structure $name
 [$name get_root_node] Ajouter_au_contexte Meta_IHM_PM_P_B207_toolglass_art_resizing $objName 
 [$name get_root_node] Ajouter_au_contexte B207_Transfo_Structure $name
# Subscribe to reference variables modification to call back the redim method of the modifier AFTER that reference variables altered related ones
   set rap_redim_after_refs_change [B_rappel [Interp_TCL] "$name Redim"]
   $noeud Ajouter_MetaData_T rap_redim_after_refs_change $rap_redim_after_refs_change
   $noeud Ajouter_MetaData_T L_var_obj                   $L_var_obj
   foreach v $L_var_obj {
     set cmd_subscribe [$v get_cmd_subscribe]
	 eval "$cmd_subscribe [$rap_redim_after_refs_change Rappel]"
    }

# if it is a PM...look for the GDD type
 set PM [$noeud Val Real_PM]; if {[string equal $PM ""]} {puts "  No Real_PM indicated in $noeud"; set PM [$noeud Val CometPM]
                                                          set Real_PM ""
                                                         } else {puts "  Real_PM = $PM in $noeud"
														         set Real_PM $PM
																}
 if {![string equal $PM {}]} {
  # Add a variable object for the GDD type in the interpolator
   set L_vars_for_PM [$noeud Val ${objName}_vars_for_PM]
   if {[string equal $L_vars_for_PM ""]} {
     set v_lg [$lg_var Add_var "$PM get_GDD_id" "$objName Change_PM_type $PM 0"]
	   $v_lg set_interpolate_function interpolate_min
	 set v_ht [$ht_var Add_var "$PM get_GDD_id" "$objName Change_PM_type $PM 1"]
	   $v_ht set_interpolate_function interpolate_min
	 [$PM get_prim_handle] Ajouter_au_contexte ${objName}_vars_for_PM [list $v_lg $v_ht]
    } else {puts "  PM interpolation still exist"
	        set v_lg [lindex $L_vars_for_PM 0]; set v_ht [lindex $L_vars_for_PM 1]
			$lg_var Add_existing_var $v_lg 
	        $ht_var Add_existing_var $v_ht
		   }
   $PM Add_MetaData Is_edited_by_Meta_IHM_PM_P_B207_toolglass_art_resizing $objName
   $PM Add_MetaData PM_type_wanted_by_$objName [list [$PM get_GDD_id] [$PM get_GDD_id]]
   $PM Subscribe_to_Substitute_by $objName "$objName New_PM_replace $PM \$e" UNIQUE
  # Manage the case where we have a Real_PM value, that is a composite PM
   if {![string equal $Real_PM ""]} {
    # Where related variable still created
	 if {[llength $L_vars_for_PM] >= 4} {
	  # If yes, then update
	   set v_lg_PM [lindex $L_vars_for_PM 2]; set v_ht_PM [lindex $L_vars_for_PM 3]
	   $lg_var Add_existing_var $v_lg_PM
	   $ht_var Add_existing_var $v_ht_PM
	  } else {
	         # If not, then create
              set v_lg_PM [$lg_var Add_var "$PM get_GDD_id" "$objName Change_PM_type $PM 0"]; $v_lg_PM set_interpolate_function interpolate_min
	          set v_ht_PM [$ht_var Add_var "$PM get_GDD_id" "$objName Change_PM_type $PM 1"]; $v_ht_PM set_interpolate_function interpolate_min
			  [$PM get_prim_handle] Ajouter_au_contexte ${objName}_vars_for_PM [list [lindex $L_vars_for_PM 0] [lindex $L_vars_for_PM 1] $v_lg_PM $v_ht_PM]
			 }
	 set L_rel_var [$noeud Val_MetaData ${objName}_lg_var_L_rel_var]; 
	   lappend L_rel_var $v_lg_PM
	   $noeud Ajouter_MetaData_T ${objName}_lg_var_L_rel_var $L_rel_var
	 set L_rel_var [$noeud Val_MetaData ${objName}_ht_var_L_rel_var];
	   lappend L_rel_var $v_ht_PM
	   $noeud Ajouter_MetaData_T ${objName}_ht_var_L_rel_var $L_rel_var
    } else {puts "No real PM indicated in $noeud..."
	       #_________________________________________
           # XXX DEBUG, add PM related var to the lists ${objName}_lg_var_L_rel_var and ${objName}_ht_var_L_rel_var
	       set L_rel_var [$noeud Val_MetaData ${objName}_lg_var_L_rel_var]; 
	         lappend L_rel_var $v_lg
	         $noeud Ajouter_MetaData_T ${objName}_lg_var_L_rel_var $L_rel_var
	       set L_rel_var [$noeud Val_MetaData ${objName}_ht_var_L_rel_var];
	         lappend L_rel_var $v_ht
	         $noeud Ajouter_MetaData_T ${objName}_ht_var_L_rel_var $L_rel_var
	       #_________________________________________
	       }
  }
}

#___________________________________________________________________________________________________________________________________________
method Meta_IHM_PM_P_B207_toolglass_art_resizing New_PM_replace {PM_src PM_dst} {
 return
 puts "$objName New_PM_replace $PM_src $PM_dst"
# Add meta data related to interpolator variable object related to PM type
 set noeud [$PM_src get_prim_handle]
 set L_vars_for_PM [$noeud Val ${objName}_vars_for_PM]
 [$PM_dst get_prim_handle] Ajouter_au_contexte ${objName}_vars_for_PM $L_vars_for_PM
   set lg_var [lindex $L_vars_for_PM 0];
     $lg_var set_cmd_get "$PM_dst get_GDD_id"
     $lg_var set_cmd_set "$objName Change_PM_type $PM_dst 0"
	 $lg_var Display "  "
   set ht_var [lindex $L_vars_for_PM 1]; 
     $ht_var set_cmd_get "$PM_dst get_GDD_id"
	 $ht_var set_cmd_set "$objName Change_PM_type $PM_dst 1"
	 $ht_var Display "  "
}
 
#___________________________________________________________________________________________________________________________________________
method Meta_IHM_PM_P_B207_toolglass_art_resizing Change_PM_type {PM index t} {
# Is it an unactive PM? Then active it!
 if {![$PM Is_active]} {
   puts "$objName Change_PM_type $PM $index $t"
   set L_PM_actives [CSS++ $PM "#${PM}->PMs\[soft_type == BIGre\]"]
   foreach PM_active $L_PM_actives {
     if {[$PM_active Has_MetaData PM_type_wanted_by_$objName]} {
	   return [$PM_active Substitute_by $PM]
	  }
    }
   return
  }
  
 set L_PM_t [$PM Val_MetaData PM_type_wanted_by_$objName]
   lset L_PM_t $index $t
   $PM Add_MetaData PM_type_wanted_by_$objName $L_PM_t
 if {![string equal $t [$PM get_GDD_id]]} {
  # All asked types has to be the same
   foreach PM_t $L_PM_t {
     if {![string equal $PM_t $t]} {return}
    }
  # If so, do the substitution
   set LM [$PM get_LM]
   if {[lsearch [$LM get_L_actives_PM] $PM] == -1} {return}
   puts "  !!! $PM ([$PM get_GDD_id]) Update_factories $t"
   set new_PM [$PM Update_factories $t]
  }
}

