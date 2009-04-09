inherit CometGraphBuilder Logical_consistency

#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder constructor {name descr args} {
 this inherited $name $descr
 this set_GDD_id CT_CometGraphBuilder

 set CFC ${objName}_CFC; CometGraphBuilder_CFC $CFC; this set_Common_FC $CFC

 set this(LM_LP) ${objName}_LM_LP
 CometGraphBuilder_LM_LP $this(LM_LP) $this(LM_LP) "The LM LP of $name"
   this Add_LM $this(LM_LP)
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometGraphBuilder dispose {} {this inherited}
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometGraphBuilder [P_L_methodes_set_CometGraphBuilder] {$this(FC)} {$this(L_LM)}
Methodes_get_LC CometGraphBuilder [P_L_methodes_get_CometGraphBuilder] {$this(FC)}

