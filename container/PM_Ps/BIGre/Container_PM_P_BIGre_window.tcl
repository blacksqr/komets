#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Container_PM_P_BIGre_window PM_BIGre

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_BIGre_window constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id Container_CUI_window_BIGre
   
 set f [B_fiche $objName 256 256 [N_i_mere]]
   set n [$f Noeud_repere_fils]

 set this(rap_resize)  [B_rappel [Interp_TCL] "$objName Win_layout"]
   set this(L_prim_layout) [list]
   $f abonner_a_dimension  [$this(rap_resize) Rappel]
 
 set this(primitives_handle) $f
 $this(primitives_handle) Nom_IU $objName

 this set_root_for_daughters $this(primitives_handle)
 this set_prim_handle        $this(primitives_handle)

# $this(rap_placement) Texte "$objName Etirer_contenu"
   #$n abonner_a_LR_parcours [$n LR_Av_pre_rendu] [$this(rap_placement) Rappel]
   $n Ajouter_MetaData_T rap_placement $this(rap_placement)

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Generate_accessors Container_PM_P_BIGre_window [list L_prim_layout]

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_BIGre_window Win_layout {} {
 foreach {PM_prim layout} $this(L_prim_layout) {
   $PM_prim Maj_boites_recursif; $PM_prim Afficher; $PM_prim Maj_boites_recursif;
   set box  [$PM_prim Boite_noeud_et_fils]
   set prim [this get_prim_handle]; set L [$prim Longueur_corp]; set H [$prim Hauteur_corp]
   switch $layout {
     top-left {$PM_prim Origine [expr -[$box BG_X]] [expr $H - [$box Ty] - [$box BG_Y]]}
    }
  }
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_BIGre_window Layout {L_prim_layout} {
 set new_L [list]
 foreach {prim layout} $L_prim_layout {
   set found 0
   foreach {this_prim this_layout} $this(L_prim_layout) {
     if {$prim == $this_prim} {set found 1; break}
    }
   if {$found} {lappend nL $prim $this_layout} else {lappend nL $prim $layout}
  }
  
 set this(L_prim_layout) $nL
 this Win_layout
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_BIGre_window Resize {x y} {
 $this(primitives_handle) Dimension_corp $x $y
 $this(primitives_handle) Mettre_a_jour
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_BIGre_window Add_mother {m {index -1}} {
 $this(primitives_handle) Titre [[this get_LC] get_name]
 return [this inherited $m $index]
}

#___________________________________________________________________________________________________________________________________________
method Container_PM_P_BIGre_window Etirer_contenu {} {
 set f $this(primitives_handle)
 set n [$f Noeud_repere_fils]
   $n Calculer_boites
   set b [$n Boite_noeud_et_fils]
 $n maj [expr -[$b BG_X]] [expr -[$b BG_Y]] \
        0 \
        [expr [$f Longueur_corp]/[$b Tx]] [expr [$f Hauteur_corp]/[$b Ty]]
 
}
