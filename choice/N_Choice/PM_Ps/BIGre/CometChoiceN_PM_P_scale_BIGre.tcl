inherit CometChoiceN_PM_P_scale_BIGre PM_P_ChoiceN_BIGre

#___________________________________________________________________________________________________________________________________________
method CometChoiceN_PM_P_scale_BIGre constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id N_Choice_AUI_basic_CUI_slider_line_B207
   
   set this(mode_deplace) 0
   set this(ptr)          {}

   set this(lg) 200
   set this(ht) 30
   set this(bt_lg) 20

   set this(poly_bordure) [B_polygone]; B_configure $this(poly_bordure) Ajouter_contour [ProcTabDouble "0 0 $this(lg) 0 $this(lg) $this(ht) 0 $this(ht)"] -Perimetre_a_afficher 1
   set this(poly_fond)    [B_polygone];
   set this(poly_manette) [B_polygone]; B_configure $this(poly_manette) Ajouter_contour [ProcTabDouble "0 0 $this(bt_lg) 0 $this(bt_lg) $this(ht) 0 $this(ht)"] -Couleur 1 0.8 0.3 1
   set this(txt)          [B_texte [expr $this(bt_lg)] $this(bt_lg) [expr $this(bt_lg)*0.9] [fonte_Arial] [B_sim_sds]]; B_configure $this(txt) -Origine 0 [expr $this(ht)-$this(bt_lg)] -Editable 0 -Noeud_touchable 0
   set this(ctc) ${objName}_ctc
   B_contact $this(ctc) "$this(poly_manette) 1"

   B_configure $this(poly_bordure) -Fct_interpollation [get_Fonction_interpolation_poly_boite_englobante] -Coords_couleurs [[ProcTabDouble {0 0 0.5 1 0.5 0.5 1 1 0.5 0.5 1 1 0 0 0.5 1}] Tab] -maj
   B_configure $this(poly_manette) -Fct_interpollation [get_Fonction_interpolation_poly_boite_englobante] -Coords_couleurs [[ProcTabDouble {0 0.5 0 1 0 0.5 0 1 0.2 1 1 1 0.2 1 1 1}    ] Tab] -maj

   set this(rap_placement_manette) [B_rappel [Interp_TCL] "$objName Replace"]
     $this(poly_bordure) abonner_a_LR_parcours [$this(poly_bordure) LR_Av_pre_rendu] [$this(rap_placement_manette) Rappel]

   B_configure $this(poly_bordure) -Ajouter_fils $this(poly_manette) -Ajouter_fils $this(poly_fond) -Position_des_fils_changeable 0
   B_configure $this(poly_manette) -Ajouter_fils $this(txt)
   this set_prim_handle        $this(poly_bordure)
   this set_root_for_daughters $this(poly_bordure)

   set this(rap_enfonce) [B_rappel [Interp_TCL] "$objName set_mode_deplace 1; set evt \[B_sim_couche Evt_courant\]; $objName set_ptr_deplace \[\$evt Ptr\];"]
   set this(rap_relache) [B_rappel [Interp_TCL] "$objName Stop_ptr"]
     $this(poly_manette) abonner_a_detection_pointeur [$this(rap_enfonce) Rappel] 1

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Generate_accessors CometChoiceN_PM_P_scale_BIGre [list lg ht poly_bordure poly_fond poly_manette ctc txt mode_deplace]

#___________________________________________________________________________________________________________________________________________
method CometChoiceN_PM_P_scale_BIGre set_ptr_deplace {ptr} {
 this set_mode_deplace 1
 set this(ptr) $ptr
 $this(ptr) abonner_a_changement [$this(rap_relache) Rappel]
}

#___________________________________________________________________________________________________________________________________________
method CometChoiceN_PM_P_scale_BIGre Stop_ptr {} {
 if {[$this(ptr) Appuie] != 0} {return}
 this set_mode_deplace 0
 $this(ptr) desabonner_de_changement [$this(rap_relache) Rappel]
 set this(ptr) {}
}

#___________________________________________________________________________________________________________________________________________
method CometChoiceN_PM_P_scale_BIGre get_or_create_prims {root} {
 this Replace
 return [this inherited $root]
}
#___________________________________________________________________________________________________________________________________________
method CometChoiceN_PM_P_scale_BIGre dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
method CometChoiceN_PM_P_scale_BIGre Replace {} {
 set p $this(poly_manette)
 set x [$p Px]
 set t [expr $this(lg)-$this(bt_lg)]
 $p Origine [expr ($x<0)?0:(($x>$t)?$t:$x)] 0
 $this(txt) TEXTE [this get_val]
 
 set v [this get_val]
 set s [this get_step]
 set min [this get_b_inf]
 set max [this get_b_sup]
 set dt  [expr $max - $min]
 set nv [expr $min+(round($dt*[$p Px]/$t)/$s)*$s]

 if {$nv != $v} {
   if {[this get_mode_deplace]} {this prim_set_val $nv
                                 $p Origine [expr $t*($nv-$min)/$dt] 0
                                 $this(txt) TEXTE $nv
                                }
  }
 $this(poly_manette) Calculer_boites
 $this(poly_bordure) Calculer_boites
}

#___________________________________________________________________________________________________________________________________________
method CometChoiceN_PM_P_scale_BIGre get_or_create_prims {root} {
 return [this get_prim_handle]
}
#___________________________________________________________________________________________________________________________________________
method CometChoiceN_PM_P_scale_BIGre maj_choices        {}   {
 set t [expr $this(lg)-$this(bt_lg)]
 set v   [this get_val]
 set min [this get_b_inf]
 set max [this get_b_sup]
 set dt  [expr $max - $min]
 $this(poly_manette) Origine [expr $t*($v-$min)/${dt}.0] 0
}

#___________________________________________________________________________________________________________________________________________
method CometChoiceN_PM_P_scale_BIGre set_b_inf {v} {
 this inherited $v
 this maj_choices
}
#___________________________________________________________________________________________________________________________________________
method CometChoiceN_PM_P_scale_BIGre set_b_sup {v} {
 this inherited $v
 this maj_choices
}
#___________________________________________________________________________________________________________________________________________
method CometChoiceN_PM_P_scale_BIGre set_step  {v} {
 this inherited $v
 this maj_choices
}
#___________________________________________________________________________________________________________________________________________
method CometChoiceN_PM_P_scale_BIGre set_val  {v} {
 this inherited $v
 this maj_choices
}


