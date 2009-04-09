inherit CometConsultationMedecin Logical_consistency

#___________________________________________________________________________________________________________________________________________
method CometConsultationMedecin constructor {name descr args} {
 this inherited $name $descr
 this set_GDD_id CT_CometConsultationMedecin

 set CFC ${objName}_CFC; CometConsultationMedecin_CFC $CFC; this set_Common_FC $CFC

 set this(LM_LP) ${objName}_LM_LP
 CometConsultationMedecin_LM_LP $this(LM_LP) $this(LM_LP) "The LM LP of $name"
   this Add_LM $this(LM_LP)
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometConsultationMedecin dispose {} {this inherited}
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometConsultationMedecin [P_L_methodes_set_CometConsultationMedecin] {$this(FC)} {$this(L_LM)}
Methodes_get_LC CometConsultationMedecin [P_L_methodes_get_CometConsultationMedecin] {$this(FC)}

