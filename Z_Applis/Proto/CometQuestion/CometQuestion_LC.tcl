inherit CometQuestion Logical_consistency

#___________________________________________________________________________________________________________________________________________
method CometQuestion constructor {name descr args} {
 this inherited $name $descr
 this set_GDD_id CT_CometQuestion

 set CFC ${objName}_CFC; CometQuestion_CFC $CFC; this set_Common_FC $CFC

 set this(LM_LP) ${objName}_LM_LP
 CometQuestion_LM_LP $this(LM_LP) $this(LM_LP) "The LM LP of $name"
   this Add_LM $this(LM_LP)
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometQuestion dispose {} {this inherited}
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometQuestion [P_L_methodes_set_CometQuestion] {$this(FC)} {$this(L_LM)}
Methodes_get_LC CometQuestion [P_L_methodes_get_CometQuestion] {$this(FC)}

