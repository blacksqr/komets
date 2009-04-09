inherit CometClock Logical_consistency


#___________________________________________________________________________________________________________________________________________
method CometClock constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id Clock
 set CFC "${objName}_CFC"; CommonFC_Clock $CFC
   this set_Common_FC $CFC

 this set_time [clock seconds]


 set this(LM_LP) "${objName}_LM_LP";
   CometClock_LM_P  $this(LM_LP) $this(LM_LP) "The logical presentation of $name"
   this Add_LM $this(LM_LP);
 set this(LM_FC) "${objName}_LM_FC";
   CometClock_LM_FC $this(LM_FC) $this(LM_FC) "This logical part collect times from eventually different PM and compute a resulting time"
   this Add_LM $this(LM_FC);

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometClock dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometClock [L_methodes_set_Clock] {$this(FC)} {$this(L_LM)}
Methodes_get_LC CometClock [L_methodes_get_Clock] {$this(FC)}
