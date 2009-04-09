inherit CometLog Logical_consistency


#___________________________________________________________________________________________________________________________________________
method CometLog constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id CT_Log
 set CFC "${objName}_CFC"; CommonFC_Log $CFC
   this set_Common_FC $CFC

 set this(LM_LP) "${objName}_LM_LP";
   CometLog_LM_P  $this(LM_LP) login "The logical presentation of $name"
   this Add_LM $this(LM_LP);
 set this(LM_FC) "${objName}_LM_FC";
   CometLog_LM_FC $this(LM_FC) pass "This logical part collect times from eventually different PM and compute a resulting time"
   this Add_LM $this(LM_FC);

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometLog dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometLog [L_methodes_set_Log] {$this(FC)} {$this(L_LM)}
Methodes_get_LC CometLog [L_methodes_get_Log] {$this(FC)}
