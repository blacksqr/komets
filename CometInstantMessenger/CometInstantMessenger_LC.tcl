inherit CometInstantMessenger Logical_consistency

#___________________________________________________________________________________________________________________________________________
method CometInstantMessenger constructor {name descr args} {
 this inherited $name $descr
 this set_GDD_id CT_CometInstantMessenger

 set CFC ${objName}_CFC; CometInstantMessenger_CFC $CFC; this set_Common_FC $CFC

 set this(LM_FC) ${objName}_LM_FC
 CometInstantMessenger_LM_FC $this(LM_FC) $this(LM_FC) "The LM FC of $name"
   this Add_LM $this(LM_FC)
 set this(LM_LP) ${objName}_LM_LP
 CometInstantMessenger_LM_LP $this(LM_LP) $this(LM_LP) "The LM LP of $name"
   this Add_LM $this(LM_LP)
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometInstantMessenger dispose {} {this inherited}
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometInstantMessenger [P_L_methodes_set_CometInstantMessenger] {$this(FC)} {$this(L_LM)}
Methodes_get_LC CometInstantMessenger [P_L_methodes_get_CometInstantMessenger] {$this(FC)}

