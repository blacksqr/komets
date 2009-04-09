inherit CometSWL_Ship Logical_consistency

#___________________________________________________________________________________________________________________________________________
method CometSWL_Ship constructor {name descr args} {
 this inherited $name $descr
 this set_GDD_id CT_CometSWL_Ship

 set CFC ${objName}_CFC; CometSWL_Ship_CFC $CFC; this set_Common_FC $CFC

 set this(LM_LP) ${objName}_LM_LP
 CometSWL_Ship_LM_LP $this(LM_LP) $this(LM_LP) "The LM LP of $name"
   this Add_LM $this(LM_LP)
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Ship dispose {} {this inherited}
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometSWL_Ship [P_L_methodes_set_CometSWL_Ship] {$this(FC)} {$this(L_LM)}
Methodes_get_LC CometSWL_Ship [P_L_methodes_get_CometSWL_Ship] {$this(FC)}

