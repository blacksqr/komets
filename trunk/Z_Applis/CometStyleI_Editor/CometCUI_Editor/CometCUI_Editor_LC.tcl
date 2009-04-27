inherit CometCUI_Editor Logical_consistency

#___________________________________________________________________________________________________________________________________________
method CometCUI_Editor constructor {name descr args} {
 this inherited $name $descr
 this set_GDD_id CT_CometCUI_Editor

 set CFC ${objName}_CFC; CometCUI_Editor_CFC $CFC; this set_Common_FC $CFC

 set this(LM_LP) ${objName}_LM_LP
 CometCUI_Editor_LM_LP $this(LM_LP) $this(LM_LP) "The LM LP of $name"
   this Add_LM $this(LM_LP)
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometCUI_Editor dispose {} {this inherited}
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometCUI_Editor [P_L_methodes_set_CometCUI_Editor] {$this(FC)} {$this(L_LM)}
Methodes_get_LC CometCUI_Editor [P_L_methodes_get_CometCUI_Editor] {$this(FC)}

