inherit CometSWL_Missile Logical_consistency

#___________________________________________________________________________________________________________________________________________
method CometSWL_Missile constructor {name descr args} {
 this inherited $name $descr
 this set_GDD_id CT_CometSWL_Missile

 set CFC ${objName}_CFC; CometSWL_Missile_CFC $CFC; this set_Common_FC $CFC

 set this(LM_LP) ${objName}_LM_LP
 CometSWL_Missile_LM_LP $this(LM_LP) $this(LM_LP) "The LM LP of $name"
   this Add_LM $this(LM_LP)
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Missile dispose {} {this inherited}
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometSWL_Missile [P_L_methodes_set_CometSWL_Missile] {$this(FC)} {$this(L_LM)}
Methodes_get_LC CometSWL_Missile [P_L_methodes_get_CometSWL_Missile] {$this(FC)}

