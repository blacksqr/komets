#_______________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Marker_PM_P_B207_surrounding PM_BIGre

#___________________________________________________________________________________________________________________________________________
method Marker_PM_P_B207_surrounding constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id Marker_PM_P_B207_surrounding   
   set this(noeud_root)        [B_noeud]
   this set_prim_handle        $this(noeud_root)
   this set_root_for_daughters $this(noeud_root)
   set this(rap_click) [B_rappel [Interp_TCL] "$objName prim_set_mark \[expr 1-\[$objName get_mark\]\]"]
     $this(noeud_root) abonner_a_detection_pointeur [$this(rap_click) Rappel] [ALX_pointeur_relache]
	 
 eval "$objName configure $args"
 return $objName
}
#___________________________________________________________________________________________________________________________________________
method Marker_PM_P_B207_surrounding dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC Marker_PM_P_B207_surrounding [L_methodes_set_Marker] {} {}
Methodes_get_LC Marker_PM_P_B207_surrounding [L_methodes_get_Marker] {$this(FC)}
Generate_PM_setters Marker_PM_P_B207_surrounding [L_methodes_CometRE_Marker]

#___________________________________________________________________________________________________________________________________________
method Marker_PM_P_B207_surrounding set_mark {v} {$this(noeud_root) Afficher_boite_noeud $v}
