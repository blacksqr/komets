
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#_______________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit CometSWL_Planet_PM_P_B207_basic PM_BIGre

#___________________________________________________________________________________________________________________________________________
method CometSWL_Planet_PM_P_B207_basic constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id CometSWL_Planet_PM_P_B207_basic
   set this(root) [B_noeud]
   set this(rap_root_change) [B_rappel [Interp_TCL] "if {\[$this(root) A_changer\]} {$objName Update_datas}"]
   $this(root) abonner_a_LR_parcours [$this(root) LR_Av_aff] [$this(rap_root_change) Rappel]
   
 this set_prim_handle        $this(root)
 this set_root_for_daughters $this(root)

 set x 0; set y 0; set r 100
 set this(poly) [B_polygone]
   
   set contour [ProcOvale 0 0 1 1 60]
     B_configure $this(poly) -Ajouter_contour $contour \
	                         -Origine 0 0
     B_configure $this(root) -Origine $x $y \
                             -Ajouter_fils $this(poly) \
                             -Etirement $r $r
				
 set this(n_edition) [B_noeud]
 $this(root) Position_des_fils_changeable 0
 $this(root) Ajouter_fils_au_debut $this(n_edition)

 set this(poly_translation) [B_polygone]
 set this(poly_etirement)   [B_polygone]
 $this(poly_etirement)   Couleur 0 1 0 1
 $this(poly_translation) Couleur 1 0 0 1
 $this(n_edition) Ajouter_fils $this(poly_translation)
 $this(n_edition) Ajouter_fils $this(poly_etirement)
 $this(poly_etirement)   Ajouter_contour $contour
 Detruire $contour; set contour [ProcOvale 0 0 0.8 0.8 60]
 $this(poly_translation) Ajouter_contour $contour
 Detruire $contour

 $this(poly_etirement) Difference $this(poly_translation)
 B_contact ${objName}_ctc "$this(root) 0" -add "$this(poly_translation) 1" -add "$this(poly_etirement) 10"

 this Add_MetaData PRIM_STYLE_CLASS [list $this(root) "PARAM RESULT OUT image IMAGE"]
 
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Planet_PM_P_B207_basic dispose {} {
 ${objName}_ctc dispose
 
 this inherited
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometSWL_Planet_PM_P_B207_basic [P_L_methodes_set_CometSWL_Planet] {} {$this(L_actives_PM)}
Methodes_get_LC CometSWL_Planet_PM_P_B207_basic [P_L_methodes_get_CometSWL_Planet] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters CometSWL_Planet_PM_P_B207_basic [P_L_methodes_set_CometSWL_Planet_COMET_RE]

#___________________________________________________________________________________________________________________________________________
Generate_accessors CometSWL_Planet_PM_P_B207_basic [list poly_translation poly_etirement]

#___________________________________________________________________________________________________________________________________________
method CometSWL_Planet_PM_P_B207_basic Update_datas {} {
 set v [$this(root) Px]     ; if {$v != [this get_X]} {this prim_set_X $v; this set_X [this get_X]}
 set v [$this(root) Py]     ; if {$v != [this get_Y]} {this prim_set_Y $v; this set_Y [this get_Y]}
 set v [$this(root) Ex]     ; if {$v != [this get_R]} {this prim_set_R $v; this set_R [this get_R]}
 #set v [$this(root) density]; if {$v != [this get_density]} {this prim_set_density $v}
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Planet_PM_P_B207_basic set_mode    {m}  {
 if {$m == "game"} {set v 0} else {set v 1}
 B_configure $this(n_edition) -Afficher_noeud $v \
                              -Gerer_contacts $v
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Planet_PM_P_B207_basic set_X       {v}  {$this(root) Px $v}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Planet_PM_P_B207_basic set_Y       {v}  {$this(root) Py $v}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Planet_PM_P_B207_basic set_R       {v}  {
 $this(root) Etirement $v $v
# Update the polygons related to edition ?
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Planet_PM_P_B207_basic set_density {v}  {}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Planet_PM_P_B207_basic get_or_create_prims {root} {
 set rep [this inherited $root]
 
 this set_X    [this get_X]
 this set_Y    [this get_Y]
 this set_R    [this get_R]
# this set_mode [this get_mode]
 
 return $rep
}
