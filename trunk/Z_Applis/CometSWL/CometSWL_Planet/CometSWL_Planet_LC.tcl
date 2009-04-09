inherit CometSWL_Planet Logical_consistency

#___________________________________________________________________________________________________________________________________________
method CometSWL_Planet constructor {name descr args} {
 this inherited $name $descr
 this set_GDD_id CT_CometSWL_Planet

 set CFC ${objName}_CFC; CometSWL_Planet_CFC $CFC; this set_Common_FC $CFC

 set this(LM_LP) ${objName}_LM_LP
 CometSWL_Planet_LM_LP $this(LM_LP) $this(LM_LP) "The LM LP of $name"
   this Add_LM $this(LM_LP)
   
 this set_X 0; this set_Y 0; this set_R 100
 
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Planet dispose {} {this inherited}
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometSWL_Planet [P_L_methodes_set_CometSWL_Planet] {$this(FC)} {$this(L_LM)}
Methodes_get_LC CometSWL_Planet [P_L_methodes_get_CometSWL_Planet] {$this(FC)}

