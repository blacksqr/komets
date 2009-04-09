inherit CometChoiceN_PM_P_scale_round_BIGre PM_P_ChoiceN_BIGre

#___________________________________________________________________________________________________________________________________________
method CometChoiceN_PM_P_scale_round_BIGre constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id N_Choice_AUI_basic_CUI_slider_rounded_B207
   
   set this(mode_deplace) 0
   set this(ptr)          {}

   set this(lg) 200
   set this(ht) 30
   set this(bt_lg) 20

   set this(poly_centre)  [B_polygone]; B_configure $this(poly_centre) Ajouter_contour [ProcOeuf 0 0 100 100 50 60] -Perimetre_a_afficher 1
   set this(poly_manette) [B_polygone]; B_configure $this(poly_manette) -Couleur 1 0.8 0.3 1
     $this(poly_manette) Ajouter_contour [ProcOvale -100 0 10 10 60]
	 $this(poly_manette) Ajouter_contour [ProcOvale 0 0 10 10 60]
   set this(txt)          [B_texte 70 70 60 [fonte_Arial] [B_sim_sds]]; B_configure $this(txt) -Origine 0 0 -Editable 0 -Noeud_touchable 0 -Couleur_texte 0 0 0 1
   set this(ctc) ${objName}_ctc
   B_contact $this(ctc) "$this(poly_manette) 2" -pt_rot 0 0 -pt_trans 0 0

   #B_configure $this(poly_bordure) -Fct_interpollation [get_Fonction_interpolation_poly_boite_englobante] -Coords_couleurs [[ProcTabDouble {0 0 0.5 1 0.5 0.5 1 1 0.5 0.5 1 1 0 0 0.5 1}] Tab] -maj
   #B_configure $this(poly_manette) -Fct_interpollation [get_Fonction_interpolation_poly_boite_englobante] -Coords_couleurs [[ProcTabDouble {0 0.5 0 1 0 0.5 0 1 0.2 1 1 1 0.2 1 1 1}    ] Tab] -maj

   set this(rap_placement_manette) [B_rappel [Interp_TCL] "$objName Replace"]
     $this(poly_centre) abonner_a_LR_parcours [$this(poly_centre) LR_Av_aff_fils] [$this(rap_placement_manette) Rappel]

   B_configure $this(poly_centre) -Ajouter_fils $this(poly_manette) \
                                  -Position_des_fils_changeable 0   \
                                  -Ajouter_fils $this(txt)
   this set_prim_handle        $this(poly_centre)
   this set_root_for_daughters $this(poly_centre)

   set this(rap_enfonce) [B_rappel [Interp_TCL] "$objName set_mode_deplace 1; set evt \[B_sim_couche Evt_courant\]; $objName set_ptr_deplace \[\$evt Ptr\];"]
   set this(rap_relache) [B_rappel [Interp_TCL] "$objName Stop_ptr"]
     $this(poly_manette) abonner_a_detection_pointeur [$this(rap_enfonce) Rappel] 1
   
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Generate_accessors CometChoiceN_PM_P_scale_round_BIGre [list lg ht mode_deplace poly_centre poly_manette ctc txt]

#___________________________________________________________________________________________________________________________________________
method CometChoiceN_PM_P_scale_round_BIGre set_ptr_deplace {ptr} {
 this set_mode_deplace 1
 set this(ptr) $ptr
 $this(ptr) abonner_a_changement [$this(rap_relache) Rappel]
}

#___________________________________________________________________________________________________________________________________________
method CometChoiceN_PM_P_scale_round_BIGre Stop_ptr {} {
 if {[$this(ptr) Appuie] != 0} {return}
 this set_mode_deplace 0
 $this(ptr) desabonner_de_changement [$this(rap_relache) Rappel]
 set this(ptr) {}
}

#___________________________________________________________________________________________________________________________________________
method CometChoiceN_PM_P_scale_round_BIGre get_or_create_prims {root} {
 this Replace
 return [this inherited $root]
}
#___________________________________________________________________________________________________________________________________________
method CometChoiceN_PM_P_scale_round_BIGre dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
method CometChoiceN_PM_P_scale_round_BIGre Replace {} {
 set PI 3.14159265
 set p $this(poly_manette)
  $this(txt) TEXTE [this get_val]
 set rot [$this(poly_manette) Rotation]
 # Régler la rotation entre -PI/2 et 3PI/2
 while {$rot < -3*$PI/2.0} {set rot [expr $rot+2*$PI]}
 while {$rot > 1*$PI/2.0} {set rot [expr $rot-2*$PI]}
 if {-$rot < 0} {set rot 0}
 if {-$rot > $PI} {set rot $PI}
 
 $this(poly_manette) Rotation $rot
 
 set v [this get_val]
 set s [this get_step]
 set min [this get_b_inf]
 set max [this get_b_sup]
 set dt  [expr $max - $min]
 set nv [expr $min-(round($dt*$rot/$PI)/$s)*$s]
 if {$nv < $min} {set nv $max}
 if {$nv != $v} {
   if {[this get_mode_deplace]} {this prim_set_val $nv}
  }
}

#___________________________________________________________________________________________________________________________________________
method CometChoiceN_PM_P_scale_round_BIGre get_or_create_prims {root} {
 return [this get_prim_handle]
}
#___________________________________________________________________________________________________________________________________________
method CometChoiceN_PM_P_scale_round_BIGre maj_choices        {}   {
 set PI 3.14159265
 set v   [this get_val]
 set min [this get_b_inf]
 set max [this get_b_sup]
 set dt  [expr $max - $min]
 $this(poly_manette) Rotation [expr -$PI*($v-$min)/${dt}.0]
 $this(txt) TEXTE [this get_val]
   $this(txt) Optimiser_dimensions
   set b [$this(txt) Boite_noeud]
   $this(txt) Origine [expr -[$b Cx]] 0
}

#___________________________________________________________________________________________________________________________________________
method CometChoiceN_PM_P_scale_round_BIGre set_b_inf {v} {
 this inherited $v
 this maj_choices
}
#___________________________________________________________________________________________________________________________________________
method CometChoiceN_PM_P_scale_round_BIGre set_b_sup {v} {
 this inherited $v
 this maj_choices
}
#___________________________________________________________________________________________________________________________________________
method CometChoiceN_PM_P_scale_round_BIGre set_step  {v} {
 this inherited $v
 this maj_choices
}
#___________________________________________________________________________________________________________________________________________
method CometChoiceN_PM_P_scale_round_BIGre set_val  {v} {
 this inherited $v
 this maj_choices
}


