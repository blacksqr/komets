inherit CometStyleI_Editor Logical_consistency

#___________________________________________________________________________________________________________________________________________
method CometStyleI_Editor constructor {name descr args} {
 this inherited $name $descr
 this set_GDD_id CT_CometStyleI_Editor

 set CFC ${objName}_CFC; CometStyleI_Editor_CFC $CFC; this set_Common_FC $CFC

 set this(LM_LP) ${objName}_LM_LP
 CometStyleI_Editor_LM_LP $this(LM_LP) $this(LM_LP) "The LM LP of $name"
   this Add_LM $this(LM_LP)
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometStyleI_Editor dispose {} {this inherited}
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometStyleI_Editor [P_L_methodes_set_CometStyleI_Editor] {$this(FC)} {$this(L_LM)}
Methodes_get_LC CometStyleI_Editor [P_L_methodes_get_CometStyleI_Editor] {$this(FC)}

