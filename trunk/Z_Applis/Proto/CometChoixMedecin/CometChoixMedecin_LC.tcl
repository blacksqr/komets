inherit CometChoixMedecin Logical_consistency

#___________________________________________________________________________________________________________________________________________
method CometChoixMedecin constructor {name descr args} {
 this inherited $name $descr
 this set_GDD_id CT_CometChoixMedecin

 set CFC ${objName}_CFC; CometChoixMedecin_CFC $CFC; this set_Common_FC $CFC

 set this(LM_LP) ${objName}_LM_LP
 CometChoixMedecin_LM_LP $this(LM_LP) $this(LM_LP) "The LM LP of $name"
   this Add_LM $this(LM_LP)
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometChoixMedecin dispose {} {this inherited}
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometChoixMedecin [P_L_methodes_set_CometChoixMedecin] {$this(FC)} {$this(L_LM)}
Methodes_get_LC CometChoixMedecin [P_L_methodes_get_CometChoixMedecin] {$this(FC)}

