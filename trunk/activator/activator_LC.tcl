inherit CometActivator Logical_consistency

#___________________________________________________________________________________________________________________________________________
method CometActivator constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id CT_Activator
   
 set CFC "${objName}_CFC"; CommonFC_Activator $CFC
   this set_Common_FC $CFC

 set this(LM_LP) "${objName}_LM_LP";
   LogicalActivator  $this(LM_LP) $this(LM_LP) "The logical presentation of $name"
   this Add_LM $this(LM_LP);

   this set_text "OK"

 eval "$objName configure $args"
 return $objName
}
#___________________________________________________________________________________________________________________________________________
method CometActivator dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometActivator $L_methodes_set_Activator {$this(FC)} {$this(L_LM)}
Methodes_get_LC CometActivator $L_methodes_get_Activator {$this(FC)}


#___________________________________________________________________________________________________________________________________________
Inject_code CometActivator activate {foreach  {var val} $type {set $var $val}} {}

#___________________________________________________________________________________________________________________________________________
Manage_CallbackList CometActivator activate end
