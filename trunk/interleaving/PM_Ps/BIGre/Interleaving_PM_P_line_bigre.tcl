
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#_______________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit CometInterleaving_PM_P_line_BIGre PM_BIGre

#___________________________________________________________________________________________________________________________________________
method CometInterleaving_PM_P_line_BIGre constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id LinearInterleaving_B207
   
 if {[string length [info proc B_noeud]] > 0} {} else {return $objName}

 set n [B_noeud]; $n Position_des_fils_changeable 0
 $n Nom_IU $objName

 this set_prim_handle        $n
 this set_root_for_daughters $n

# set this(rap_placement) [B_rappel [Interp_TCL] "$objName Line_v"]
#$this(rap_placement) Texte "$objName Line_v"
   $n abonner_a_LR_parcours [$n LR_Av_aff_fils] [$this(rap_placement) Rappel]

 eval "$objName configure $args"
 return $objName
}

#__________________________________________________
Methodes_set_LC CometInterleaving_PM_P_line_BIGre [P_L_methodes_set_CometInterleaving] {}  {}
Methodes_get_LC CometInterleaving_PM_P_line_BIGre [P_L_methodes_get_CometInterleaving] {}
