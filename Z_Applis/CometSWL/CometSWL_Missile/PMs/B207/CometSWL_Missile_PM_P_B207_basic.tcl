#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#_______________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit CometSWL_Missile_PM_P_B207_basic PM_BIGre

#___________________________________________________________________________________________________________________________________________
method CometSWL_Missile_PM_P_B207_basic constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id CometSWL_Missile_PM_P_B207_basic
   set this(root) [B_noeud]
   
 this set_prim_handle        $this(root)
 this set_root_for_daughters $this(root)

 set x 0; set y 0; set r 5
 set this(poly) [B_polygone]
   
   set contour [ProcOvale 0 0 1 1 60]
     B_configure $this(poly) -Ajouter_contour $contour \
	                         -Origine 0 0
     B_configure $this(root) -Origine $x $y \
                             -Ajouter_fils $this(poly) \
                             -Etirement $r $r
				
 Detruire $contour

 this Add_MetaData PRIM_STYLE_CLASS [list $this(root) "PARAM RESULT OUT"]
 
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometSWL_Missile_PM_P_B207_basic [P_L_methodes_set_CometSWL_Missile] {} {}
Methodes_get_LC CometSWL_Missile_PM_P_B207_basic [P_L_methodes_get_CometSWL_Missile] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters CometSWL_Missile_PM_P_B207_basic [P_L_methodes_set_CometSWL_Missile_COMET_RE]

#___________________________________________________________________________________________________________________________________________
Generate_accessors CometSWL_Missile_PM_P_B207_basic [list poly_translation poly_etirement]

#___________________________________________________________________________________________________________________________________________
method CometSWL_Missile_PM_P_B207_basic set_X       {v}  {$this(root) Px $v}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Missile_PM_P_B207_basic set_Y       {v}  {$this(root) Py $v}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Missile_PM_P_B207_basic get_or_create_prims {root} {
 set rep [this inherited $root]
 
 this set_X  [this get_X]
 this set_Y  [this get_Y]
 this set_VX [this get_VX]
 this set_VY [this get_VY]
 
 return $rep
}
