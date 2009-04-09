#___________________________________________________________________________________________________________________________________________
inherit CometOkCancel Logical_consistency

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometOkCancel constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id CT_OkCancel
 CometOkCancel_CFC "${objName}_CFC"
   this set_Common_FC "${objName}_CFC"

 set this(LM_LP) "${objName}_LM_LP";
   LogicalCometOkCancel $this(LM_LP) $this(LM_LP) "The logical presentation of $objName"; this Add_LM $this(LM_LP);

 this set_txt_OK     OK
 this set_txt_CANCEL CANCEL
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometOkCancel dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometOkCancel [L_methodes_set_CometOkCancel] {$this(FC)} {$this(L_LM)}
Methodes_get_LC CometOkCancel [L_methodes_get_CometOkCancel] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method CometOkCancel activate_OK     {} {}
method CometOkCancel activate_CANCEL {} {}

#___________________________________________________________________________________________________________________________________________
Manage_CallbackList CometOkCancel activate_OK     begin
Manage_CallbackList CometOkCancel activate_CANCEL begin
