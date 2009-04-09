#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#_______________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Choice_PM_P_B207_deployable PM_BIGre

#___________________________________________________________________________________________________________________________________________
method Choice_PM_P_B207_deployable constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id Interleaving_PM_P_B207_deployable
   set this(mode_deploy)      deployed
   set this(index_of_current) 0
   
 if {[string length [info proc B_noeud]] > 0} {} else {return $objName}

 set this(n_root) [B_noeud]; 
   $this(n_root) Position_des_fils_changeable 0
   $this(n_root) Nom_IU $objName
   set this(poly_fond) [B_polygone]
     $this(n_root) Ajouter_fils_au_debut $this(poly_fond)
	 $this(poly_fond) Ajouter_contour [ProcRect 0 0 1 1]
	 $this(poly_fond) Couleur 0 0 0 0.7
	 Clipping $this(poly_fond)
     set this(n_root_for_daughters) [B_noeud]
       $this(poly_fond) Ajouter_fils_au_debut $this(n_root_for_daughters)
	   $this(n_root_for_daughters) Position_des_fils_changeable 0

 this set_prim_handle        $this(n_root)
 this set_root_for_daughters $this(n_root_for_daughters)

 $this(n_root_for_daughters) abonner_a_LR_parcours [$this(n_root_for_daughters) LR_Av_aff_fils] [$this(rap_placement) Rappel]

 eval "$objName configure $args"
 return $objName
}

#______________________________________________________ Adding the choices functions _______________________________________________________
Methodes_set_LC Choice_PM_P_B207_deployable $L_methodes_set_choices {} {}
Methodes_get_LC Choice_PM_P_B207_deployable $L_methodes_get_choices {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method Choice_PM_P_B207_deployable maj_choices {}   {
 puts "$objName maj_choices"
}
