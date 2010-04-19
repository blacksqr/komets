inherit CometEdition_comet Logical_consistency

#___________________________________________________________________________________________________________________________________________
method CometEdition_comet constructor {name descr args} {
 this inherited $name $descr
 this set_GDD_id CT_CometEdition_comet

 set CFC ${objName}_CFC; CometEdition_comet_CFC $CFC; this set_Common_FC $CFC

 set this(LM_FC) ${objName}_LM_FC
 CometEdition_comet_LM_FC $this(LM_FC) $this(LM_FC) "The LM FC of $name"
   this Add_LM $this(LM_FC)
 set this(LM_LP) ${objName}_LM_LP
 CometEdition_comet_LM_LP $this(LM_LP) $this(LM_LP) "The LM LP of $name"
   this Add_LM $this(LM_LP)
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometEdition_comet dispose {} {this inherited}
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometEdition_comet [P_L_methodes_set_CometEdition_comet] {$this(FC)} {$this(L_LM)}
Methodes_get_LC CometEdition_comet [P_L_methodes_get_CometEdition_comet] {$this(FC)}

