inherit CometToolBox_GDD Logical_consistency

#___________________________________________________________________________________________________________________________________________
method CometToolBox_GDD constructor {name descr args} {
 this inherited $name $descr
 this set_GDD_id CT_CometToolBox_GDD

 set CFC ${objName}_CFC; CometToolBox_GDD_CFC $CFC; this set_Common_FC $CFC

 set this(LM_LP) ${objName}_LM_LP
 CometToolBox_GDD_LM_LP $this(LM_LP) $this(LM_LP) "The LM LP of $name"
   this Add_LM $this(LM_LP)
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometToolBox_GDD dispose {} {this inherited}
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometToolBox_GDD [P_L_methodes_set_CometToolBox_GDD] {$this(FC)} {$this(L_LM)}
Methodes_get_LC CometToolBox_GDD [P_L_methodes_get_CometToolBox_GDD] {$this(FC)}

