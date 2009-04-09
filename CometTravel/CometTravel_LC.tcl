inherit CometTravel_LC Logical_consistency

#___________________________________________________________________________________________________________________________________________
method CometTravel_LC constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id CT_CometTravel
   
 set CFC "${objName}_CFC"; CometTravel_CFC $CFC
   this set_Common_FC $CFC

 set this(LM_LP) "${objName}_LM_LP";
   CometTravel_LM_LP $this(LM_LP) $this(LM_LP) "The logical presentation of $name"
   this Add_LM $this(LM_LP);
 set this(LM_FC) "${objName}_LM_FC";
   CometTravel_LM_FC $this(LM_FC) $this(LM_FC) "The logical functionnal core of $name"
   this Add_LM $this(LM_FC);

 eval "$objName configure $args"
 return $objName
}
#___________________________________________________________________________________________________________________________________________
method CometTravel_LC dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometTravel_LC [P_L_methodes_set_CometTravel] {$this(FC)} {$this(L_LM)}
Methodes_get_LC CometTravel_LC [P_L_methodes_get_CometTravel] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method CometTravel_LC Compute_travel {} {
 puts "$objName Compute_travel"
 $this(LM_FC) Compute_travel
 $this(LM_LP) Compute_travel
}

#___________________________________________________________________________________________________________________________________________
#Manage_CallbackList CometTravel_LC activate begin
