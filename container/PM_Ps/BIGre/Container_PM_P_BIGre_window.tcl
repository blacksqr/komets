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
