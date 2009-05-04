#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#_______________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit Interleaving_PM_P_B207_deployable PM_BIGre

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_B207_deployable constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id ScrollableMonospaceInterleaving_Deployable_B207
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
	 #Clipping $this(poly_fond)
     set this(n_root_for_daughters) [B_noeud]
       $this(poly_fond) Ajouter_fils_au_debut $this(n_root_for_daughters)
	   $this(n_root_for_daughters) Position_des_fils_changeable 0

 this set_prim_handle        $this(n_root)
 this set_root_for_daughters $this(n_root_for_daughters)

 $this(n_root_for_daughters) abonner_a_LR_parcours [$this(n_root_for_daughters) LR_Av_aff_fils] [$this(rap_placement) Rappel]

 eval "$objName configure $args"
 return $objName
}

#__________________________________________________
Methodes_set_LC Interleaving_PM_P_B207_deployable [P_L_methodes_set_CometInterleaving] {}  {}
Methodes_get_LC Interleaving_PM_P_B207_deployable [P_L_methodes_get_CometInterleaving] {}

#___________________________________________________________________________________________________________________________________________
Generate_accessors Interleaving_PM_P_B207_deployable [list mode_deploy index_of_current]

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_B207_deployable set_current {c} {
 set f [CSS++ $objName "#$objName > * \\$c/"]
 if {[string equal $f {}]} {puts "$c non trouvé parmis les descendants"; return} else {puts "$f trouvé comme conteneur de $c"}
 this set_index_of_current [lsearch [this get_out_daughters] $f]
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_B207_deployable set_method_placement {m} {
 $this(rap_placement) Texte "$objName $m; $objName Fit"
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_B207_deployable Add_daughters {m {index -1}} {
 this inherited $m $index
 this Fit
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_B207_deployable Sub_daughters {m} {
 this inherited $m
 if {$this(index_of_current) >= [this get_nb_daughters]} {set this(index_of_current) [expr [this get_nb_daughters]-1]}
 this Fit
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_B207_deployable Fit {} {
 switch $this(mode_deploy) {
   deployed   {set box [$this(n_root_for_daughters) Boite_noeud_et_fils]
               foreach d [this get_daughters] {
			     set n_root [lindex [$d get_prim_handle] 0]
				 $n_root Afficher_noeud 1; $n_root Gerer_contacts 1
				}
              }
   undeployed {set item [lindex [this get_out_daughters] [this get_index_of_current]]
               if {[string equal $item ""]} {
			     return
				 puts "$objName Fit PB!!!\n  index of current do not adress a valid PM...\n  index_of_current : [this get_index_of_current]\n  out_daughters : [this get_out_daughters]"; 
				 return} 
               set n_root_item [lindex [$item get_prim_handle] 0]
			   set box [$n_root_item Boite_noeud_et_fils_glob]
			   set i 0
			   foreach d [this get_daughters] {
                 set n_root [lindex [$d get_prim_handle] 0]
                 if {$i == $this(index_of_current)} {set aff 1} else {set aff 0}
                 $n_root Afficher_noeud $aff; $n_root Gerer_contacts $aff
                 incr i
                }
              }
  }
 
 $this(n_root_for_daughters) Calculer_boites
 $this(n_root_for_daughters) Origine [expr -[$box BG_X]] [expr -[$box BG_Y]]
 $this(poly_fond) Vider
 set contour [ProcRect 0 0 [$box Tx] [$box Ty]]
 $this(poly_fond) Ajouter_contour $contour
 Detruire $contour
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_B207_deployable set_mode_deploy {m} {
 set transition NO
 if {[string equal $this(mode_deploy) deployed]   && [string equal $m undeployed]} {set transition contraction}
 if {[string equal $this(mode_deploy) undeployed] && [string equal $m deployed]  } {set transition expansion}
 set this(mode_deploy) $m
 switch $transition {
   contraction {
               }
   expansion   {
               }
  }
}
