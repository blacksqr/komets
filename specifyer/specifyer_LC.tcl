
inherit CometSpecifyer Logical_consistency


#___________________________________________________________________________________________________________________________________________
method CometSpecifyer constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id Specifyer
 set CFC "${objName}_CFC"; CommonFC_Specifyer $CFC
   this set_Common_FC $CFC

 set this(LM_LP) "${objName}_LM_LP";
   LogicalSpecifyer $this(LM_LP) $this(LM_LP) "The logical presentation of $name"
   this Add_LM $this(LM_LP);
   
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometSpecifyer $L_methodes_set_Specifyer {$this(FC)} {$this(L_LM)}
Methodes_get_LC CometSpecifyer $L_methodes_get_Specifyer {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method CometSpecifyer set_text {t} {
 [this get_Common_FC] set_text $t
 foreach LM [this get_L_LM] {
   $LM set_text $t
  }
 this Evaluate_if_task_is_completed
}

#___________________________________________________________________________________________________________________________________________
Manage_CallbackList CometSpecifyer [list set_text] end
#___________________________________________________________________________________________________________________________________________

proc Specify_a_number {s} {
 set v [$s get_text]
 if {[string equal $v {}]} {return 0}
 return [string is integer $v]
}
