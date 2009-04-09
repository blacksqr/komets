inherit CometMessageSender_LC Logical_consistency

#___________________________________________________________________________________________________________________________________________
method CometMessageSender_LC constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id CT_CometMessageSender
   
 set CFC "${objName}_CFC"; CometMessageSender_CFC $CFC
   this set_Common_FC $CFC

 set this(LM_LP) "${objName}_LM_LP";
   CometMessageSender_LM_LP $this(LM_LP) $this(LM_LP) "The logical presentation of $name"
   this Add_LM $this(LM_LP);
 set this(LM_FC) "${objName}_LM_FC";
   CometMessageSender_LM_FC $this(LM_FC) $this(LM_FC) "The logical functionnal core of $name"
   this Add_LM $this(LM_FC);

 eval "$objName configure $args"
 return $objName
}
#___________________________________________________________________________________________________________________________________________
method CometMessageSender_LC dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometMessageSender_LC [P_L_methodes_set_CometMessageSender] {$this(FC)} {$this(L_LM)}
Methodes_get_LC CometMessageSender_LC [P_L_methodes_get_CometMessageSender] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Manage_CallbackList CometMessageSender_LC [list set_destination set_subject set_message send_message] begin
